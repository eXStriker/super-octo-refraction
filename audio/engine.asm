; The entire sound engine. Uses section "audio" in WRAM.

; Interfaces are in bank 0.

; Notable functions:
; 	FadeMusic
; 	PlayStereoSFX

_MapSetup_Sound_Off::
; restart sound operation
; clear all relevant hardware registers & wram
	push hl
	push de
	push bc
	push af
	call MusicOff
	ld hl, rNR50 ; channel control registers
	xor a
	ld [hli], a ; rNR50 ; volume/vin
	ld [hli], a ; rNR51 ; sfx channels
	ld a, $80 ; all channels on
	ld [hli], a ; ff26 ; music channels

	ld hl, rNR10 ; sound channel registers
	ld e, $4 ; number of channels
.clearsound
;   sound channel   1      2      3      4
	xor a
	ld [hli], a ; rNR10, rNR20, rNR30, rNR40 ; sweep = 0

	ld [hli], a ; rNR11, rNR21, rNR31, rNR41 ; length/wavepattern = 0
	ld a, $8
	ld [hli], a ; rNR12, rNR22, rNR32, rNR42 ; envelope = 0
	xor a
	ld [hli], a ; rNR13, rNR23, rNR33, rNR43 ; frequency lo = 0
	ld a, $80
	ld [hli], a ; rNR14, rNR24, rNR34, rNR44 ; restart sound (freq hi = 0)
	dec e
	jr nz, .clearsound

	ld hl, Channel1 ; start of channel data
	ld de, $1bf ; length of area to clear (entire sound wram area)
.clearchannels ; clear Channel1-$c2bf
	xor a
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, .clearchannels
	ld a, $77 ; max
	ld [Volume], a
	call MusicOn
	pop af
	pop bc
	pop de
	pop hl
	ret

MusicFadeRestart:
; restart but keep the music id to fade in to
	ld a, [MusicFadeIDHi]
	push af
	ld a, [MusicFadeIDLo]
	push af
	call _MapSetup_Sound_Off
	pop af
	ld [MusicFadeIDLo], a
	pop af
	ld [MusicFadeIDHi], a
	ret

MusicOn:
	ld a, 1
	jr SetMusicPlaying

MusicOff:
	xor a
SetMusicPlaying:
	ld [MusicPlaying], a
	ret

_UpdateSound::
; called once per frame
	; no use updating audio if it's not playing
	; PCM uses a completely different routine, but it's in a DI state
	ld a, [MusicPlaying]
	and a
	ret z
	; start at ch1
_UpdateSound_SkipMusicCheck::
	xor a
	ld [CurChannel], a ; just
	ld [SoundOutput], a ; off
	ld bc, Channel1
.loop
	; is the channel active?
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_CHANNEL_ON, [hl]
	jp z, .nextchannel
	; check time left in the current note
	ld hl, Channel1NoteDuration - Channel1
	add hl, bc
	ld a, [hl]
	cp $2 ; 1 or 0?
	jr c, .noteover
	dec [hl]
	jr .asm_e8093

.noteover
	; reset vibrato delay
	ld hl, Channel1VibratoDelay - Channel1
	add hl, bc
	ld a, [hl]
	ld hl, Channel1VibratoDelayCount - Channel1
	add hl, bc
	ld [hl], a
	; turn vibrato off for now
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	res SOUND_UNKN_09, [hl]
	; get next note
	call ParseMusic
.asm_e8093

	call Functione84f9
	; duty cycle
	ld hl, Channel1DutyCycle - Channel1
	add hl, bc
	ld a, [hli]
	ld [wCurTrackDuty], a
	; intensity
	ld a, [hli]
	ld [wCurTrackIntensity], a
	; frequency
	ld a, [hli]
	ld [wCurTrackFrequency], a
	ld a, [hl]
	ld [wCurTrackFrequency + 1], a

	call HandlePorta
	call HandleArp
	call HandleTrackVibrato ; handle vibrato and other things
	call HandleNoise
	; turn off music when playing sfx?
	ld a, [SFXPriority]
	and a
	jr z, .next
	; are we in a sfx channel right now?
	ld a, [CurChannel]
	cp $4
	jr nc, .next
	; are any sfx channels active?
	; if so, mute
	ld a, [Channel5Flags]
	ld hl, Channel6Flags
	or [hl]
	ld hl, Channel7Flags
	or [hl]
	ld hl, Channel8Flags
	or [hl]
	bit SOUND_CHANNEL_ON, [hl]
	jr z, .next
.restnote
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_REST, [hl] ; Rest
.next
	; are we in a sfx channel right now?
	ld a, [CurChannel]
	cp $4 ; sfx
	jr nc, .asm_e80ee
	ld hl, Channel5Flags - Channel1
	add hl, bc
	bit SOUND_CHANNEL_ON, [hl]
	jr nz, .asm_e80fc
.asm_e80ee
	call UpdateChannels
	ld hl, Channel1Tracks - Channel1
	add hl, bc
	ld a, [SoundOutput]
	or [hl]
	ld [SoundOutput], a
.asm_e80fc
	; clear note flags
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	xor a
	ld [hl], a
.nextchannel
	; next channel
	ld hl, Channel2 - Channel1
	add hl, bc
	ld c, l
	ld b, h
	ld a, [CurChannel]
	inc a
	ld [CurChannel], a
	cp $8 ; are we done?
	jp nz, .loop ; do it all again

	call PlayDanger
	; fade music in/out
	call FadeMusic
	; write volume to hardware register
	ld a, [Volume]
	ld [rNR50], a
	; write SO on/off to hardware register
	ld a, [SoundOutput]
	ld [rNR51], a
	ret

HandleArp:
; using ProTracker's behavior where notes are determined
; from the one closest to the current frequency
	ld hl, Channel1Arpeggio - Channel1
	add hl, bc
	ld a, [hl]
	and a
	ret z
	ld e, a
	ld hl, Channel1NoteDuration - Channel1
	add hl, bc
	ld a, [hl]
.mod
	sub 3
	jr nc, .mod
	add 3
	and a
	jp z, .skip
	cp 1
	ld a, e
	jr z, .get1
	swap a
.get1
	and $f
	jp z, .skip
	ld l, a
	ld a, [wCurTrackFrequency]
	ld e, a
	ld a, [wCurTrackFrequency + 1]
	or $f8
	ld d, a
	ld a, l
	cp 12
	ld h, 0
	jr c, .nooct1
	sub 12
	inc h
.nooct1
	ld l, a
.loop1
	ld a, d
	cp $fc
	jr c, .lt1
	jr nz, .gt1
	ld a, e
	cp $16
	jr c, .lt1
.gt1
	sla e
	rl d
	inc h
	jr .loop1
.lt1
	push hl
	ld hl, FrequencyTable + 3
.loop2
	ld a, [hl]
	cp d
	jr c, .lt2
	jr nz, .gt2
	dec hl
	ld a, [hli]
	cp e
	jr nc, .gt2
.lt2
	inc hl
	inc hl
	jr .loop2
.gt2
	push bc
	dec hl
	dec hl
	dec hl
	ld a, e
	sub [hl]
	ld c, a
	inc hl
	ld a, d
	sbc [hl]
	ld b, a
	inc hl
	ld a, [hli]
	sub e
	ld e, a
	ld a, [hld]
	sbc d
	cp b
	jr c, .lt3
	jr nz, .gt3
	ld a, e
	cp c
	jr c, .lt3
.gt3
	dec hl
	dec hl
.lt3
	pop bc
	pop de
	ld a, d
	ld d, 0
	add hl, de
	add hl, de
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, d
	and a
	jr z, .nooct2
.loop3
	sra h
	rr l
	dec a
	jr nz, .loop3
.nooct2
	ld a, l
	ld [wCurTrackFrequency], a
	ld a, h
	and $7
	ld [wCurTrackFrequency + 1], a
.skip
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_6, [hl]
	ret

HandlePorta:
	xor a
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	bit SOUND_PORTA_1, [hl]
	jr z, .skip1
	inc a
.skip1
	bit SOUND_PORTA_2, [hl]
	jr z, .skip2
	add 2
.skip2
	and a
	ret z
	ld e, a
	ld hl, Channel1PortaSteps - Channel1
	add hl, bc
	ld a, [hl]
	cp $f0
	ld d, a
	jr c, .doporta
	sub $f0
	ld d, a
	ld hl, Channel1PortaCount - Channel1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .reloadcounter
	dec a
	jr z, .reloadcounter
	ld [hl], a
	ret
.reloadcounter
	push hl
	ld hl, Channel1NoteLength - Channel1
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hl], a
.doporta
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, e
	cp 1
	jr z, .up
	cp 2
	jr z, .down

	push bc
	push hl
	ld hl, Channel1DestFrequency - Channel1
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	inc hl
	ld a, [hld]
	cp b
	jr c, .lt
	jr nz, .gt
	ld a, [hl]
	cp c
	jr c, .lt
	jr z, .clamp
.gt
	ld a, [hli]
	sub d
	ld e, a
	ld a, [hld]
	sbc 0
	ld d, a
	cp b
	jr c, .clamp
	jr nz, .tonepordone
	ld a, e
	cp c
	jr c, .clamp
	jr .tonepordone
.lt
	ld a, [hli]
	add d
	ld e, a
	ld a, [hld]
	adc 0
	ld d, a
	cp b
	jr c, .tonepordone
	jr nz, .clamp
	ld a, e
	cp c
	jr nc, .clamp
	jr .tonepordone
.clamp
	ld d, b
	ld e, c
.tonepordone
	pop bc
	jr .done

.up
	ld a, [hli]
	sub d
	ld e, a
	ld a, [hld]
	sbc 0
	ld d, a
	jr nc, .done
	ld de, 0
	jr .done

.down
	ld a, [hli]
	add d
	ld e, a
	ld a, [hld]
	adc 0
	cp $8
	ld d, a
	jr c, .done
	ld de, $7ff
	jr .done

.done
	ld a, e
	ld [hli], a
	ld [wCurTrackFrequency], a
	ld a, d
	ld [hl], a
	ld [wCurTrackFrequency + 1], a
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_6, [hl]
	ret

UpdateChannels:
	ld a, [CurChannel]
	and $7
	jumptable

.ChannelFnPtrs
	dw .Channel1
	dw .Channel2
	dw .Channel3
	dw .Channel4
; sfx ch ptrs are identical to music chs
; ..except 5
	dw .Channel5
	dw .Channel6
	dw .Channel7
	dw .Channel8

.Channel1
	ld a, [Danger]
	bit 7, a
	jr z, .Channel5
	cp $ff
	ret nz
.Channel5
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	bit NOTE_UNKN_3, [hl]
	jr z, .asm_e8159

	ld a, [SoundInput]
	ld [rNR10], a
.asm_e8159
	bit NOTE_REST, [hl] ; rest
	jr nz, .ch1rest
	bit NOTE_UNKN_4, [hl]
	jr nz, .asm_e81a2
	bit NOTE_UNKN_1, [hl]
	jr nz, .asm_e816b
	bit NOTE_UNKN_6, [hl]
	jr nz, .asm_e8184
	jr .asm_e8175

.asm_e816b
	ld a, [wCurTrackFrequency]
	ld [rNR13], a
	ld a, [wCurTrackFrequency + 1]
	ld [rNR14], a
.asm_e8175
	bit NOTE_UNKN_0, [hl]
	ret z
	ld a, [wCurTrackDuty]
	ld d, a
	ld a, [rNR11]
	and $3f ; sound length
	or d
	ld [rNR11], a
	ret

.asm_e8184
	ld a, [wCurTrackDuty]
	ld d, a
	ld a, [rNR11]
	and $3f ; sound length
	or d
	ld [rNR11], a
	ld a, [wCurTrackFrequency]
	ld [rNR13], a
	ld a, [wCurTrackFrequency + 1]
	ld [rNR14], a
	ret

.ch1rest
	ld a, [rNR52]
	and %10001110 ; ch1 off
	ld [rNR52], a
	ld hl, rNR10
	jp ClearChannel

.asm_e81a2
	ld hl, wCurTrackDuty
	ld a, $3f ; sound length
	or [hl]
	ld [rNR11], a
	ld a, [wCurTrackIntensity]
	ld [rNR12], a
	ld a, [wCurTrackFrequency]
	ld [rNR13], a
	ld a, [wCurTrackFrequency + 1]
	or $80
	ld [rNR14], a
	ret

.Channel2
.Channel6
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	bit NOTE_REST, [hl] ; rest
	jr nz, .ch2rest
	bit NOTE_UNKN_4, [hl]
	jr nz, .asm_e8204
	bit NOTE_UNKN_6, [hl]
	jr nz, .asm_e81e6
	bit NOTE_UNKN_0, [hl]
	ret z
	ld a, [wCurTrackDuty]
	ld d, a
	ld a, [rNR21]
	and $3f ; sound length
	or d
	ld [rNR21], a
	ret

.asm_e81e6
	ld a, [wCurTrackDuty]
	ld d, a
	ld a, [rNR21]
	and $3f ; sound length
	or d
	ld [rNR21], a
.asm_e81db
	ld a, [wCurTrackFrequency]
	ld [rNR23], a
	ld a, [wCurTrackFrequency + 1]
	ld [rNR24], a
	ret

.ch2rest
	ld a, [rNR52]
	and %10001101 ; ch2 off
	ld [rNR52], a
	ld hl, rNR20
	jp ClearChannel

.asm_e8204
	ld hl, wCurTrackDuty
	ld a, $3f ; sound length
	or [hl]
	ld [rNR21], a
	ld a, [wCurTrackIntensity]
	ld [rNR22], a
	ld a, [wCurTrackFrequency]
	ld [rNR23], a
	ld a, [wCurTrackFrequency + 1]
	or $80 ; initial (restart)
	ld [rNR24], a
	ret

.Channel3
.Channel7
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	bit NOTE_REST, [hl] ; rest
	jr nz, .ch3rest
	bit NOTE_UNKN_4, [hl]
	jr nz, .asm_e824d
	bit NOTE_UNKN_6, [hl]
	ret z
	ld a, [wCurTrackFrequency]
	ld [rNR33], a
	ld a, [wCurTrackFrequency + 1]
	ld [rNR34], a
	ret

.ch3rest
	ld a, [rNR52]
	and %10001011 ; ch3 off
	ld [rNR52], a
	ld hl, rNR30
	jp ClearChannel

.asm_e824d
	ld a, $3f
	ld [rNR31], a
	xor a
	ld [rNR30], a
	call .asm_e8268
	ld a, $80
	ld [rNR30], a
	ld a, [wCurTrackFrequency]
	ld [rNR33], a
	ld a, [wCurTrackFrequency + 1]
	or $80
	ld [rNR34], a
	ret

.asm_e8268
	push hl
	ld a, [wCurTrackIntensity]
	and $f ; only 0-9 are valid
	; don't do anything if the intensity is $xf
	; this is useful for custom wave samples
	cp $f
	jr z, .skipwavecopy
	ld l, a
	ld h, 0
	; hl << 4
	; each wavepattern is $f bytes long
	; so seeking is done in $10s
rept 4
	add hl, hl
endr
	ld de, WaveSamples
	add hl, de
	; load wavepattern into rWave_0-rWave_f
_w_ = $ff30 ; rWave_0
rept $10
	ld a, [hli]
	ld [_w_], a
_w_ = _w_ + 1
endr
.skipwavecopy
	pop hl
	ld a, [wCurTrackIntensity]
	and $f0
	sla a
	ld [rNR32], a
	ret

.Channel4
.Channel8
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	bit NOTE_REST, [hl] ; rest
	jr nz, .ch4rest
	bit NOTE_UNKN_4, [hl]
	ret z
	ld a, $3f ; sound length
	ld [rNR41], a
	ld a, [wCurTrackIntensity]
	ld [rNR42], a
	ld a, [wCurTrackFrequency]
	ld [rNR43], a
	ld a, $80
	ld [rNR44], a
	ret

.ch4rest
	ld a, [rNR52]
	and %10000111 ; ch4 off
	ld [rNR52], a
	ld hl, rNR40
	jp ClearChannel

_CheckSFX:
; return carry if any sfx channels are active
	ld a, [Channel5Flags]
	ld hl, Channel6Flags
	or [hl]
	ld hl, Channel7Flags
	or [hl]
	ld hl, Channel8Flags
	or [hl]
	bit SOUND_CHANNEL_ON, a
	ret z
	; or will have cleared carry
	scf
	ret

PlayDanger:
	ld a, [Danger]
	bit 7, a
	ret z
	cp $ff
	ret z
	ld d, a
	call _CheckSFX
	jr c, .asm_e8335
	ld a, d
	and $1f
	jr z, .asm_e8323
	cp 16 ; halfway
	jr nz, .asm_e8335
	ld hl, Tablee8354
	jr .updatehw

.asm_e8323
	ld hl, Tablee8350
.updatehw
	xor a
	ld [rNR10], a ; sweep off
	ld a, [hli]
	ld [rNR11], a ; sound length / duty cycle
	ld a, [hli]
	ld [rNR12], a ; ch1 volume envelope
	ld a, [hli]
	ld [rNR13], a ; ch1 frequency lo
	ld a, [hli]
	ld [rNR14], a ; ch1 frequency hi
.asm_e8335
	ld a, d
	and $e0
	ld e, a
	ld a, d
	and $1f
	inc a
	cp 30
	jr c, .asm_e833c
	add 2
.asm_e833c
	add e
	jr nz, .load
	dec a
.load
	ld [Danger], a
	; is hw ch1 on?
	ld a, [SoundOutput]
	and $11
	ret nz
	; if not, turn it on
	ld a, [SoundOutput]
	or $11
	ld [SoundOutput], a
	ret

Tablee8350:
	db $80 ; duty 50%
	db $e2 ; volume 14, envelope decrease sweep 2
	db $50 ; frequency: $750
	db $87 ; restart sound

Tablee8354:
	db $80 ; duty 50%
	db $e2 ; volume 14, envelope decrease sweep 2
	db $ee ; frequency: $6ee
	db $86 ; restart sound

FadeMusic:
; fade music if applicable
; usage:
;	write to MusicFade
;	song fades out at the given rate
;	load song id in MusicFadeID
;	fade new song in
; notes:
;	max # frames per volume level is $3f

	; fading?
	ld a, [MusicFade]
	and a
	ret z
	; has the count ended?
	ld a, [MusicFadeCount]
	and a
	jr z, .update
	; count down
	dec a
	ld [MusicFadeCount], a
	ret

.update
	ld a, [MusicFade]
	ld d, a
	; get new count
	and $3f
	ld [MusicFadeCount], a
	; get SO1 volume
	ld a, [Volume]
	and $7
	; which way are we fading?
	bit 7, d
	jr nz, .fadein
	; fading out
	and a
	jr z, .novolume
	dec a
	jr .updatevolume

.novolume
	; make sure volume is off
	xor a
	ld [Volume], a
	; did we just get on a bike?
	ld a, [PlayerState]
	cp $1 ; bicycle
	jr z, .bicycle
	push bc
	; restart sound
	call MusicFadeRestart
	; get new song id
	ld a, [MusicFadeIDLo]
	and a
	jr z, .quit ; this assumes there are fewer than 256 songs!
	ld e, a
	ld a, [MusicFadeIDHi]
	ld d, a
	; load new song
	call _PlayMusic
.quit
	; cleanup
	pop bc
	; stop fading
	xor a
	ld [MusicFade], a
	ret

.bicycle
	push bc
	; restart sound
	call MusicFadeRestart
	; this turns the volume up
	; turn it back down
	xor a
	ld [Volume], a
	; get new song id
	ld a, [MusicFadeIDLo]
	ld e, a
	ld a, [MusicFadeIDHi]
	ld d, a
	; load new song
	call _PlayMusic
	pop bc
	; fade in
	ld hl, MusicFade
	set 7, [hl]
	ret

.fadein
	; are we done?
	cp $7
	jr nc, .maxvolume
	; inc volume
	inc a
	jr .updatevolume

.maxvolume
	; we're done
	xor a
	ld [MusicFade], a
	ret

.updatevolume
	; hi = lo
	ld d, a
	swap a
	or d
	ld [Volume], a
	ret

LoadNote:
	; check mute??
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	bit SOUND_UNKN_09, [hl]
	ret z
	; get note duration
	ld hl, Channel1NoteDuration - Channel1
	add hl, bc
	ld a, [hl]
	ld hl, wCurNoteDuration ; ????
	sub [hl]
	jr nc, .ok
	ld a, 1
.ok
	ld [hl], a
	; get frequency
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; ????
	ld hl, Channel1Field0x21 - Channel1
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc a, 0
	ld d, a
	; ????
	ld hl, Channel1Field0x22 - Channel1
	add hl, bc
	sub [hl]
	jr nc, .greater_than
	; ????
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	set SOUND_UNKN_11, [hl]
	; get frequency
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; ????
	ld hl, Channel1Field0x21 - Channel1
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a
	ld a, d
	sbc a, 0
	ld d, a
	; ????
	ld hl, Channel1Field0x22 - Channel1
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	jr .resume

.greater_than
	; ????
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	res SOUND_UNKN_11, [hl]
	; get frequency
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; ????
	ld hl, Channel1Field0x21 - Channel1
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc a, 0
	ld d, a
	; ????
	ld hl, Channel1Field0x22 - Channel1
	add hl, bc
	sub [hl]
	ld d, a
.resume
	push bc
	ld hl, wCurNoteDuration
	ld b, 0; loop count
.loop
	inc b
	ld a, e
	sub [hl]
	ld e, a
	jr nc, .loop
	ld a, d
	and a
	jr z, .quit
	dec d
	jr .loop

.quit
	ld a, e ; result
	add [hl]
	ld d, b ; loop count
	; ????
	pop bc
	ld hl, Channel1Field0x23 - Channel1
	add hl, bc
	ld [hl], d
	ld hl, Channel1Field0x24 - Channel1
	add hl, bc
	ld [hl], a
	; clear ????
	ld hl, Channel1Field0x25 - Channel1
	add hl, bc
	xor a
	ld [hl], a
	ret

HandleTrackVibrato:
; handle vibrato and other things
; unknowns: wCurTrackDuty, wCurTrackFrequency
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	bit SOUND_DUTY, [hl] ; duty
	jr z, .next
	ld hl, Channel1Field0x1c - Channel1
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	ld [hl], a
	and $c0
	ld [wCurTrackDuty], a
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_0, [hl]
.next
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	bit SOUND_CRY_PITCH, [hl]
	jr z, .vibrato
	ld hl, Channel1CryPitch - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wCurTrackFrequency
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, h
	and $7
	ld d, l
	ld hl, wCurTrackFrequency + 1
	ld [hld], a
	ld [hl], d
.vibrato
	; is vibrato on?
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	bit SOUND_VIBRATO, [hl] ; vibrato
	ret z
	; is vibrato active for this note yet?
	; is the delay over?
	ld hl, Channel1VibratoDelayCount - Channel1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .subexit
	; is the extent nonzero?
	ld hl, Channel1VibratoExtent - Channel1
	add hl, bc
	ld a, [hl]
	and a
	ret z
	; save it for later
	ld d, a
	; is it time to toggle vibrato up/down?
	ld hl, Channel1VibratoRate - Channel1
	add hl, bc
	ld a, [hl]
	and $f ; count
	jr z, .toggle
.subexit
	dec [hl]
	ret

.toggle
	; refresh count
	ld a, [hl]
	swap [hl]
	or [hl]
	ld [hl], a
	; ????
	ld a, [wCurTrackFrequency]
	ld e, a
	; toggle vibrato up/down
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	bit SOUND_VIBRATO_DIR, [hl] ; vibrato up/down
	jr z, .down
; up
	; vibrato down
	res SOUND_VIBRATO_DIR, [hl]
	; get the extent
	ld a, d
	and $f ; lo

	ld d, a
	ld a, e
	sub d
	ld e, a
	ld a, [wCurTrackFrequency + 1]
	jr nc, .asm_e84ef
	dec a
	cp $8
	jr nc, .asm_e84ef
	xor a
	ld e, a
	jr .asm_e84ef

.down
	; vibrato up
	set SOUND_VIBRATO_DIR, [hl]
	; get the extent
	ld a, d
	and $f0 ; hi
	swap a ; move it to lo

	add e
	ld e, a
	ld a, [wCurTrackFrequency + 1]
	jr nc, .asm_e84ef
	inc a
	cp $8
	jr c, .asm_e84ef
	ld a, $7
	ld e, $ff
.asm_e84ef
	ld [wCurTrackFrequency + 1], a
	ld a, e
	ld [wCurTrackFrequency], a

	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_6, [hl]
	ret

Functione84f9:
	; quit if ????
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	bit SOUND_UNKN_09, [hl]
	ret z
	; de = Frequency
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	bit SOUND_UNKN_11, [hl]
	jr z, .next

	ld hl, Channel1Field0x23 - Channel1
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, de
	ld d, h
	ld e, l
	; get ????
	ld hl, Channel1Field0x24 - Channel1
	add hl, bc
	ld a, [hl]
	; add it to ????
	ld hl, Channel1Field0x25 - Channel1
	add hl, bc
	add [hl]
	ld [hl], a
	ld a, 0
	adc e
	ld e, a
	ld a, 0
	adc d
	ld d, a

	ld hl, Channel1Field0x22 - Channel1
	add hl, bc
	ld a, [hl]
	cp d
	jp c, .quit1
	jr nz, .quit2
	ld hl, Channel1Field0x21 - Channel1
	add hl, bc
	ld a, [hl]
	cp e
	jp c, .quit1
	jr .quit2

.next
	ld a, e
	ld hl, Channel1Field0x23 - Channel1
	add hl, bc
	ld e, [hl]
	sub e
	ld e, a
	ld a, d
	sbc a, 0
	ld d, a
	ld hl, Channel1Field0x24 - Channel1
	add hl, bc
	ld a, [hl]
	add a
	ld [hl], a
	ld a, e
	sbc a, 0
	ld e, a
	ld a, d
	sbc a, 0
	ld d, a
	ld hl, Channel1Field0x22 - Channel1
	add hl, bc
	ld a, d
	cp [hl]
	jr c, .quit1
	jr nz, .quit2
	ld hl, Channel1Field0x21 - Channel1
	add hl, bc
	ld a, e
	cp [hl]
	jr nc, .quit2
.quit1
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	res SOUND_UNKN_09, [hl]
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	res SOUND_UNKN_11, [hl]
	ret

.quit2
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_1, [hl]
	set NOTE_UNKN_0, [hl]
	ret

HandleNoise:
	; is noise sampling on?
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_NOISE, [hl] ; noise sampling
	ret z
	; are we in a sfx channel?
	ld a, [CurChannel]
	bit 2, a ; sfx
	jr nz, .next
	; is ch8 on? (noise)
	ld hl, Channel8Flags
	bit SOUND_CHANNEL_ON, [hl] ; on?
	jr z, .next
	; is ch8 playing noise?
	bit SOUND_NOISE, [hl]
	ret nz ; quit if so

.next
	ld a, [wNoiseSampleDelay]
	and a
	jr z, ReadNoiseSample
	dec a
	ld [wNoiseSampleDelay], a
	ret

ReadNoiseSample:
; sample struct:
;	[wx] [yy] [zz]
;	w: ? either 2 or 3
;	x: duration
;	zz: intensity
;       yy: frequency

	; de = [NoiseSampleAddress]
	ld hl, NoiseSampleAddress
	ld a, [hli]
	ld d, [hl]
	ld e, a

	; is it empty?
	ld a, e
	or d
	ret z

	ld a, [de]
	inc de

	cp $ff
	ret z

	and $f
	inc a
	ld [wNoiseSampleDelay], a
	ld a, [de]
	inc de
	ld [wCurTrackIntensity], a
	ld a, [de]
	inc de
	ld [wCurTrackFrequency], a
	xor a
	ld [wCurTrackFrequency + 1], a

	ld hl, NoiseSampleAddress
	ld a, e
	ld [hli], a
	ld [hl], d

	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_4, [hl]
	ret

ParseMusic:
; parses until a note is read or the song is ended
	call GetMusicByte ; store next byte in a
	cp $ff ; is the song over?
	jr z, .endchannel
	cp $d0 ; is it a note?
	jr c, .readnote
	; then it's a command
.readcommand
	call ParseMusicCommand
	jr ParseMusic ; start over

.readnote
; CurMusicByte contains current note
; special notes
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_SFX, [hl]
	jp nz, ParseSFXOrRest
	bit SOUND_REST, [hl] ; rest
	jp nz, ParseSFXOrRest
	bit SOUND_NOISE, [hl] ; noise sample
	jp nz, GetNoiseSample
; normal note
	; set note duration (bottom nybble)
	ld a, [CurMusicByte]
	and $f
	call SetNoteDuration
	; get note pitch (top nybble)
	ld a, [CurMusicByte]
	swap a
	and $f
	jr z, .rest ; pitch 0-> rest
	; update pitch
	ld hl, Channel1Pitch - Channel1
	add hl, bc
	ld [hl], a
	; store pitch in e
	ld e, a
	; store octave in d
	ld hl, Channel1Octave - Channel1
	add hl, bc
	ld d, [hl]
	; update frequency
	call GetFrequency
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	bit SOUND_PORTA_1, [hl]
	jr z, .nottoneporta
	bit SOUND_PORTA_2, [hl]
	jr z, .nottoneporta
	ld hl, Channel1DestFrequency - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	jp LoadNote
.nottoneporta
	ld hl, Channel1Frequency - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	; ????
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_4, [hl]
	jp LoadNote

.rest
; note = rest
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_REST, [hl] ; Rest
	ret

;
.endchannel
; $ff is reached in music data
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_SUBROUTINE, [hl] ; in a subroutine?
	jr nz, .readcommand ; execute
	ld a, [CurChannel]
	cp $4 ; channels 0-3?
	jr nc, .chan_5to8
	; ????
	ld hl, Channel5Flags - Channel1
	add hl, bc
	bit SOUND_CHANNEL_ON, [hl]
	jr nz, .ok
.chan_5to8
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_REST, [hl]
	call nz, RestoreVolume
	; end music
	ld a, [CurChannel]
	cp $4 ; channel 5?
	jr nz, .ok
	; ????
	xor a
	ld [rNR10], a ; sweep = 0
.ok
; stop playing
	; turn channel off
	ld hl, Channel1Flags - Channel1
	add hl, bc
	res SOUND_CHANNEL_ON, [hl]
	; note = rest
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_REST, [hl]
	; clear music id & bank
	ld hl, Channel1MusicID - Channel1
	add hl, bc
	xor a
	ld [hli], a ; id hi
	ld [hli], a ; id lo
	ld [hli], a ; bank
	ret

RestoreVolume:
	; ch5 only
	ld a, [CurChannel]
	cp $4
	ret nz
	xor a
	ld hl, Channel6CryPitch
	ld [hli], a
	ld [hl], a
	ld hl, Channel8CryPitch
	ld [hli], a
	ld [hl], a
	ld a, [LastVolume]
	ld [Volume], a
	xor a
	ld [LastVolume], a
	ld [SFXPriority], a
	ret

ParseSFXOrRest:
	; turn noise sampling on
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_4, [hl] ; noise sample
	; update note duration
	ld a, [CurMusicByte]
	call SetNoteDuration ; top nybble doesnt matter?
	; update intensity from next param
	call GetMusicByte
	ld hl, Channel1Intensity - Channel1
	add hl, bc
	ld [hl], a
	; update lo frequency from next param
	call GetMusicByte
	ld hl, Channel1FrequencyLo - Channel1
	add hl, bc
	ld [hl], a
	; are we on the last channel? (noise sampling)
	ld a, [CurChannel]
	and $3
	cp $3
	ret z
	; update hi frequency from next param
	call GetMusicByte
	ld hl, Channel1FrequencyHi - Channel1
	add hl, bc
	ld [hl], a
	ret

GetNoiseSample:
; load ptr to sample header in NoiseSampleAddress
	; are we on the last channel?
	ld a, [CurChannel]
	and $3
	cp $3
	; ret if not
	ret nz
	; update note duration
	ld a, [CurMusicByte]
	and $f
	call SetNoteDuration
	; check current channel
	ld a, [CurChannel]
	bit 2, a ; are we in a sfx channel?
	jr nz, .sfx
	ld hl, Channel8Flags
	bit SOUND_CHANNEL_ON, [hl] ; is ch8 on? (noise)
	ret nz
	ld a, [MusicNoiseSampleSet]
	jr .next

.sfx
	ld a, [SFXNoiseSampleSet]
.next
	; load noise sample set id into de
	ld e, a
	ld d, 0
	; load ptr to noise sample set in hl
	ld hl, Drumkits
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; get pitch
	ld a, [CurMusicByte]
	swap a
	; non-rest note?
	and $f
	ret z
	; use 'pitch' to seek noise sample set
	ld e, a
	; ld d, 0 (unnecessary, nothing modifies d since the last "ld d, 0")
	add hl, de
	add hl, de
	; load sample pointer into NoiseSampleAddress
	ld a, [hli]
	ld [NoiseSampleAddressLo], a
	ld a, [hl]
	ld [NoiseSampleAddressHi], a
	; clear ????
	xor a
	ld [wNoiseSampleDelay], a
	ret

ParseMusicCommand:
	; reload command
	ld a, [CurMusicByte]
	; get command #
	sub $d0 ; first command
	jumptable

MusicCommands:
; pointer to each command in order
	; octaves
	dw Music_Octave8 ; octave 8
	dw Music_Octave7 ; octave 7
	dw Music_Octave6 ; octave 6
	dw Music_Octave5 ; octave 5
	dw Music_Octave4 ; octave 4
	dw Music_Octave3 ; octave 3
	dw Music_Octave2 ; octave 2
	dw Music_Octave1 ; octave 1
	dw Music_NoteType ; note length + intensity
	dw Music_ForceOctave ; set starting octave
	dw Music_Tempo ; tempo
	dw Music_DutyCycle ; duty cycle
	dw Music_Intensity ; intensity
	dw Music_SoundStatus ; update sound status
	dw Music_SoundDuty ; ???? + duty cycle
	dw Music_ToggleSFX ;
	dw Music_PitchSlide
	dw Music_Vibrato ; vibrato
	dw MusicE2 ; unused
	dw Music_ToggleNoise ; music noise sampling
	dw Music_Panning ; force panning
	dw Music_Volume ; volume
	dw Music_Tone ; tone
	dw Music_IncOctave ; unused
	dw Music_DecOctave ; unused
	dw Music_TempoRelative ; global tempo
	dw Music_RestartChannel ; restart current channel from header
	dw Music_NewSong ; new song
	dw Music_SFXPriorityOn ; sfx priority on
	dw Music_SFXPriorityOff ; sfx priority off
	dw MusicEE ; unused
	dw Music_StereoPanning ; stereo panning
	dw Music_SFXToggleNoise ; sfx noise sampling
	dw Music_CustomSample ; custom wave sample
	dw Music_Arpeggio ; arpeggio
	dw Music_PortaUp ; portamento up
	dw Music_PortaDown ; portamento down
	dw Music_TonePorta ; tone portamento
	dw Music_TCGNoteType0 ; unused
	dw Music_TCGNoteType1 ; unused
	dw Music_TCGNoteType2 ; unused
	dw MusicF9 ; unused
	dw Music_SetCondition ;
	dw Music_JumpIf ;
	dw Music_JumpChannel ; jump
	dw Music_LoopChannel ; loop
	dw Music_CallChannel ; call
	dw Music_EndChannel ; return

Music_CustomSample:
; loads a custom wave sample
; params: 16
	xor a
	ld [rNR30], a
_w_ = $ff30
	rept 16
	call GetMusicByte
	ld [_w_], a
_w_ = _w_ + 1
	endr
	ld hl, Channel1Intensity - Channel1
	add hl, bc
	ld a, [hl]
	and $f0
	or $0f ; set wavepattern to $f
	ld [hl], a
	ret

Music_Arpeggio:
; equivalent to .mod's 0xx command
; params: 1
	call GetMusicByte
	ld hl, Channel1Arpeggio - Channel1
	add hl, bc
	ld [hl], a
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_6, [hl]
	ret

Music_PortaCommon:
; x00 won't continue, it'll turn off instead
	ld hl, Channel1NoteLength - Channel1
	add hl, bc
	ld a, [hl]
	ld hl, Channel1PortaCount - Channel1
	add hl, bc
	ld [hl], a
	call GetMusicByte
	ld hl, Channel1PortaSteps - Channel1
	add hl, bc
	ld [hl], a
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	and a
	jr nz, .noturnoff
	res SOUND_PORTA_1, [hl] ; 0
	res SOUND_PORTA_2, [hl]
.noturnoff
	ret

Music_PortaUp:
; equivalent to .mod's 1xx command except 1fx
; which will be fine porta (1 1/16 note instead of 1 frame)
; params: 1
	call Music_PortaCommon
	ret z
	res SOUND_PORTA_1, [hl] ; 1
	set SOUND_PORTA_2, [hl]
	ret

Music_PortaDown:
; equivalent to .mod's 2xx command except 2fx
; which will be fine porta (1 1/16 note instead of 1 frame)
; params: 1
	call Music_PortaCommon
	ret z
	set SOUND_PORTA_1, [hl] ; 2
	res SOUND_PORTA_2, [hl]
	ret

Music_TonePorta:
; equivalent to .mod's 3xx command except 3fx
; which will be fine porta (1 1/16 note instead of 1 frame)
; params: 1
	call Music_PortaCommon
	ret z
	set SOUND_PORTA_1, [hl] ; 3
	set SOUND_PORTA_2, [hl]
	ret

; Copied from FroggestSpirit, with our thanks
Music_TCGNoteType0:
; notetype0
	call GetMusicByte
	ld hl, Channel1NoteLength - Channel1
	add hl, bc
	ld [hl], a
	ret

Music_TCGNoteType1:
; notetype1
	call GetMusicByte
	ld hl, Channel1Intensity - Channel1
	add hl, bc
	rla
	rla
	rla
	rla
	and $f0
	push bc
	ld b, a
	ld a, [hl]
	and $f
	add b
	pop bc
	ld [hl], a
	ret

Music_TCGNoteType2:
; notetype2
	call GetMusicByte
	ld hl, Channel1Intensity - Channel1
	add hl, bc
	push bc
	ld b, a
	ld a, [hl]
	and $f0
	add b
	pop bc
	ld [hl], a
	ret

Music_EndChannel:
; called when $ff is encountered w/ subroutine flag set
; end music stream
; return to caller of the subroutine
	; reset subroutine flag
	ld hl, Channel1Flags - Channel1
	add hl, bc
	res SOUND_SUBROUTINE, [hl]
	; copy LastMusicAddress to MusicAddress
	ld hl, Channel1LastMusicAddress - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

Music_CallChannel:
; call music stream (subroutine)
; parameters: ll hh ; pointer to subroutine
	; get pointer from next 2 bytes
	call GetMusicByte
	ld e, a
	call GetMusicByte
	ld d, a
	push de
	; copy MusicAddress to LastMusicAddress
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, Channel1LastMusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	; load pointer into MusicAddress
	pop de
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	; set subroutine flag
	ld hl, Channel1Flags - Channel1
	add hl, bc
	set SOUND_SUBROUTINE, [hl]
	ret

Music_JumpChannel:
; jump
; parameters: ll hh ; pointer
	; get pointer from next 2 bytes
	call GetMusicByte
	ld e, a
	call GetMusicByte
	ld d, a
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

Music_LoopChannel:
; loops xx - 1 times
; 	00: infinite
; params: 3
;	xx ll hh
;		xx : loop count
;   	ll hh : pointer

	; get loop count
	call GetMusicByte
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_LOOPING, [hl] ; has the loop been initiated?
	jr nz, .checkloop
	and a ; loop counter 0 = infinite
	jr z, .loop
	; initiate loop
	dec a
	set SOUND_LOOPING, [hl] ; set loop flag
	ld hl, Channel1LoopCount - Channel1
	add hl, bc
	ld [hl], a ; store loop counter
.checkloop
	ld hl, Channel1LoopCount - Channel1
	add hl, bc
	ld a, [hl]
	and a ; are we done?
	jr z, .endloop
	dec [hl]
.loop
	; get pointer
	call GetMusicByte
	ld e, a
	call GetMusicByte
	ld d, a
	; load new pointer into MusicAddress
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

.endloop
	; reset loop flag
	ld hl, Channel1Flags - Channel1
	add hl, bc
	res SOUND_LOOPING, [hl]
	; skip to next command
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc de ; skip
	inc de ; pointer
	ld a, d
	ld [hld], a
	ld [hl], e
	ret

Music_SetCondition:
; set condition for a jump
; used with FB
; params: 1
;	xx ; condition

	; set condition
	call GetMusicByte
	ld hl, Channel1Condition - Channel1
	add hl, bc
	ld [hl], a
	ret

Music_JumpIf:
; conditional jump
; used with FA
; params: 3
; 	xx: condition
;	ll hh: pointer

; check condition
	; a = condition
	call GetMusicByte
	; if existing condition matches, jump to new address
	ld hl, Channel1Condition - Channel1
	add hl, bc
	cp [hl]
	jr z, .jump
; skip to next command
	; get address
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; skip pointer
	inc de
	inc de
	; update address
	ld a, d
	ld [hld], a
	ld [hl], e
	ret

.jump
; jump to the new address
	; get pointer
	call GetMusicByte
	ld e, a
	call GetMusicByte
	ld d, a
	; update pointer in MusicAddress
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

MusicEE:
; conditional jump
; checks a byte in ram corresponding to the current channel
; doesn't seem to be set by any commands
; params: 2
;		ll hh ; pointer

; if ????, jump
	; get channel
	ld a, [CurChannel]
	and $3 ; ch0-3
	ld e, a
	ld d, 0
	; hl = Channel1JumpCondition + channel id
	ld hl, Channel1JumpCondition
	add hl, de
	; if set, jump
	ld a, [hl]
	and a
	jr nz, .jump
; skip to next command
	; get address
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; skip pointer
	inc de
	inc de
	; update address
	ld a, d
	ld [hld], a
	ld [hl], e
	ret

.jump
	; reset jump flag
	ld [hl], 0
	; de = pointer
	call GetMusicByte
	ld e, a
	call GetMusicByte
	ld d, a
	; update address
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

MusicF9:
; sets some flag
; seems to be unused
; params: 0
	ld a, 1
	ld [wc2b5], a
	ret

MusicE2:
; seems to have been dummied out
; params: 1
	call GetMusicByte
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_UNKN_0B, [hl]
	ret

Music_Vibrato:
; vibrato
; params: 2
;	1: [xx]
	; delay in frames
;	2: [yz]
	; y: extent
	; z: rate (# frames per cycle)

	; set vibrato flag?
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_VIBRATO, [hl]
	; start at lower frequency (extent is positive)
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	res SOUND_VIBRATO_DIR, [hl]
	; get delay
	call GetMusicByte
; update delay
	ld hl, Channel1VibratoDelay - Channel1
	add hl, bc
	ld [hl], a
; update delay count
	ld hl, Channel1VibratoDelayCount - Channel1
	add hl, bc
	ld [hl], a
; update extent
; this is split into halves only to get added back together at the last second
	; get extent/rate
	call GetMusicByte
	ld hl, Channel1VibratoExtent - Channel1
	add hl, bc
	ld d, a
	; get top nybble
	and $f0
	swap a
	srl a ; halve
	ld e, a
	adc a, 0; round up
	swap a
	or e
	ld [hl], a
; update rate
	ld hl, Channel1VibratoRate - Channel1
	add hl, bc
	; get bottom nybble
	ld a, d
	and $f
	ld d, a
	swap a
	or d
	ld [hl], a
	ret

Music_PitchSlide:
; params: 2
; usage:
; 1) slidepitchto (duration), (dest octave), (dest pitch)
; 2) set origin octave and pitch normally
	call GetMusicByte
	ld [wCurNoteDuration], a

	call GetMusicByte
	ld d, a
	and $f
	ld e, a

	ld a, d
	swap a
	and $f
	ld d, a
	call GetFrequency
	ld hl, Channel1Field0x21 - Channel1
	add hl, bc
	ld [hl], e
	ld hl, Channel1Field0x22 - Channel1
	add hl, bc
	ld [hl], d
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_UNKN_09, [hl]
	ret

Music_Tone:
; tone
; params: 2
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_CRY_PITCH, [hl]
	ld hl, Channel1CryPitch + 1 - Channel1
	add hl, bc
	call GetMusicByte
	ld [hld], a
	call GetMusicByte
	ld [hl], a
	ret

Music_SoundDuty:
; sequence of 4 duty cycles to be looped
; params: 1 (4 2-bit duty cycle arguments)
	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_DUTY, [hl] ; duty cycle
	; sound duty sequence
	call GetMusicByte
	rrca
	rrca
	ld hl, Channel1Field0x1c - Channel1
	add hl, bc
	ld [hl], a
	; update duty cycle
	and $c0 ; only uses top 2 bits
	ld hl, Channel1DutyCycle - Channel1
	add hl, bc
	ld [hl], a
	ret

Music_ToggleSFX:
; toggle something
; params: none
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_SFX, [hl]
	jr z, .on
	res SOUND_SFX, [hl]
	ret

.on
	set SOUND_SFX, [hl]
	ret

Music_ToggleNoise:
; toggle music noise sampling
; can't be used as a straight toggle since the param is not read from on->off
; params:
; 	noise on: 1
; 	noise off: 0
	; check if noise sampling is on
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_NOISE, [hl]
	jr z, .on
	; turn noise sampling off
	res SOUND_NOISE, [hl]
	ret

.on
	; turn noise sampling on
	set SOUND_NOISE, [hl]
	call GetMusicByte
	ld [MusicNoiseSampleSet], a
	ret

Music_SFXToggleNoise:
; toggle sfx noise sampling
; params:
;	on: 1
; 	off: 0
	; check if noise sampling is on
	ld hl, Channel1Flags - Channel1
	add hl, bc
	bit SOUND_NOISE, [hl]
	jr z, .on
	; turn noise sampling off
	res SOUND_NOISE, [hl]
	ret

.on
	; turn noise sampling on
	set SOUND_NOISE, [hl]
	call GetMusicByte
	ld [SFXNoiseSampleSet], a
	ret

Music_NoteType:
; note length
;	# frames per 16th note
; intensity: see Music_Intensity
; params: 2
	; note length
	call GetMusicByte
	ld hl, Channel1NoteLength - Channel1
	add hl, bc
	ld [hl], a
	ld a, [CurChannel]
	and $3
	cp CHAN4 ; CHAN8 & $3
	ret z
	; intensity
	jp Music_Intensity

Music_SoundStatus:
; update sound status
; params: 1
	call GetMusicByte
	ld [SoundInput], a
	ld hl, Channel1NoteFlags - Channel1
	add hl, bc
	set NOTE_UNKN_3, [hl]
	ret

Music_DutyCycle:
; duty cycle
; params: 1
	call GetMusicByte
	rrca
	rrca
	and $c0
	ld hl, Channel1DutyCycle - Channel1
	add hl, bc
	ld [hl], a
	ret

Music_Intensity:
; intensity
; params: 1
;	hi: pressure
;   lo: velocity
	call GetMusicByte
	ld hl, Channel1Intensity - Channel1
	add hl, bc
	ld [hl], a
	ret

Music_Tempo:
; global tempo
; params: 2
;	de: tempo
	call GetMusicByte
	ld d, a
	call GetMusicByte
	ld e, a
	jp SetGlobalTempo

Music_Octave8:
Music_Octave7:
Music_Octave6:
Music_Octave5:
Music_Octave4:
Music_Octave3:
Music_Octave2:
Music_Octave1:
; set octave based on lo nybble of the command
	ld hl, Channel1Octave - Channel1
	add hl, bc
	ld a, [CurMusicByte]
	and 7
	ld [hl], a
	ret

Music_IncOctave:
	ld hl, Channel1Octave - Channel1
	add hl, bc
	ld a, [hl]
	dec a
	and 7
	ld [hl], a
	ret

Music_DecOctave:
	ld hl, Channel1Octave - Channel1
	add hl, bc
	ld a, [hl]
	inc a
	and 7
	ld [hl], a
	ret

Music_ForceOctave:
; set starting octave
; this forces all notes up by the starting octave
; params: 1
	call GetMusicByte
	ld hl, Channel1StartingOctave - Channel1
	add hl, bc
	ld [hl], a
	ret

Music_StereoPanning:
; stereo panning
; params: 1
	; stereo on?
	ld a, [wOptions]
	bit 5, a ; stereo
	jr nz, Music_Panning
	; skip param
	jp GetMusicByte

Music_Panning:
; force panning
; params: 1
	call SetLRTracks
	call GetMusicByte
	ld hl, Channel1Tracks - Channel1
	add hl, bc
	and [hl]
	ld [hl], a
	ret

Music_Volume:
; set volume
; params: 1
;	see Volume
	; read param even if it's not used
	call GetMusicByte
	; is the song fading?
	ld a, [MusicFade]
	and a
	ret nz
	; reload param
	ld a, [CurMusicByte]
	; set volume
	ld [Volume], a
	ret

Music_TempoRelative:
; set global tempo to current channel tempo +- param
; params: 1 signed
	call GetMusicByte
	ld e, a
	; check sign
	add a, a
	sbc a
	ld d, a
	ld hl, Channel1Tempo - Channel1
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	jp SetGlobalTempo

Music_SFXPriorityOn:
; turn sfx priority on
; params: none
	ld a, 1
	jr Music_SetSFXPriority

Music_SFXPriorityOff:
; turn sfx priority off
; params: none
	xor a
	; fallthrough

Music_SetSFXPriority:
	ld [SFXPriority], a
	ret

Music_RestartChannel:
; restart current channel from channel header (same bank)
; params: 2 (5)
; ll hh: pointer to new channel header
;	header format: 0x yy zz
;		x: channel # (0-3)
;		zzyy: pointer to new music data

	; update music id
	ld hl, Channel1MusicID - Channel1
	add hl, bc
	ld a, [hli]
	ld [MusicIDLo], a
	ld a, [hl]
	ld [MusicIDHi], a
	; update music bank
	ld hl, Channel1MusicBank - Channel1
	add hl, bc
	ld a, [hl]
	ld [MusicBank], a
	; get pointer to new channel header
	call GetMusicByte
	ld l, a
	call GetMusicByte
	ld h, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	push bc ; save current channel
	call LoadChannel
	call StartChannel
	pop bc ; restore current channel
	ret

Music_NewSong:
; new song
; params: 2
;	de: song id
	call GetMusicByte
	ld e, a
	call GetMusicByte
	ld d, a
	push bc
	call _PlayMusic
	pop bc
	ret

GetMusicByte:
; returns byte from current address in a
; advances to next byte in music data
; input: bc = start of current channel
	push hl
	push de
	; load address into de
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	; load bank into a
	ld hl, Channel1MusicBank - Channel1
	add hl, bc
	ld a, [hl]
	; get byte
	call _LoadMusicByte ; load data into CurMusicByte
	inc de ; advance to next byte for next time this is called
	; update channeldata address
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	; cleanup
	pop de
	pop hl
	; store channeldata in a
	ld a, [CurMusicByte]
	ret

GetFrequency:
; generate frequency
; input:
; 	d: octave
;	e: pitch
; output:
; 	de: frequency

; get octave
	; get starting octave
	ld hl, Channel1StartingOctave - Channel1
	add hl, bc
	ld a, [hl]
	swap a ; hi nybble
	and $f
	; add current octave
	add d
	push af ; we'll use this later
	; get starting octave
	ld hl, Channel1StartingOctave - Channel1
	add hl, bc
	ld a, [hl]
	and $f ; lo nybble
	ld l, a ; ok
	ld d, 0
	ld h, d
	add hl, de ; add current pitch
	add hl, hl ; skip 2 bytes for each
	ld de, FrequencyTable
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	; get our octave
	pop af
	; shift right by [7 - octave] bits
.loop
	; [7 - octave] loops
	cp $7
	jr nc, .ok
	; sra de
	sra d
	rr e
	inc a
	jr .loop

.ok
	ld a, d
	and $7 ; top 3 bits for frequency (11 total)
	ld d, a
	ret

SetNoteDuration:
; input: a = note duration in 16ths
	; store delay units in de
	inc a
	ld e, a
	ld d, 0
	; store NoteLength in a
	ld hl, Channel1NoteLength - Channel1
	add hl, bc
	ld a, [hl]
	; multiply NoteLength by delay units
	ld l, d; just multiply (d = 0)
	call .Multiply
	ld a, l ; % $100
	; store Tempo in de
	ld hl, Channel1Tempo - Channel1
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	; add ???? to the next result
	ld hl, Channel1Field0x16 - Channel1
	add hl, bc
	ld l, [hl]
	; multiply Tempo by last result (NoteLength * delay % $100)
	call .Multiply
	; copy result to de
	ld e, l
	ld d, h
	; store result in ????
	ld hl, Channel1Field0x16 - Channel1
	add hl, bc
	ld [hl], e
	; store result in NoteDuration
	ld hl, Channel1NoteDuration - Channel1
	add hl, bc
	ld [hl], d
	ret

.Multiply
; multiplies a and de
; adds the result to l
; stores the result in hl
	ld h, 0
.loop
	; halve a
	srl a
	; is there a remainder?
	jr nc, .skip
	; add it to the result
	add hl, de
.skip
	; add de, de
	sla e
	rl d
	; are we done?
	and a
	jr nz, .loop
	ret

SetGlobalTempo:
	push bc ; save current channel
	; are we dealing with music or sfx?
	ld a, [CurChannel]
	cp CHAN5
	jr nc, .sfxchannels
	ld bc, Channel1
	call Tempo
	ld bc, Channel2
	call Tempo
	ld bc, Channel3
	call Tempo
	ld bc, Channel4
	call Tempo
	jr .end

.sfxchannels
	ld bc, Channel5
	call Tempo
	ld bc, Channel6
	call Tempo
	ld bc, Channel7
	call Tempo
	ld bc, Channel8
	call Tempo
.end
	pop bc ; restore current channel
	ret

Tempo:
; input:
; 	de: note length
	; update Tempo
	ld hl, Channel1Tempo - Channel1
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	; clear ????
	xor a
	ld hl, Channel1Field0x16 - Channel1
	add hl, bc
	ld [hl], a
	ret

StartChannel:
	call SetLRTracks
	ld hl, Channel1Flags - Channel1
	add hl, bc
	set SOUND_CHANNEL_ON, [hl] ; turn channel on
	ret

SetLRTracks:
; set tracks for a the current channel to default
; seems to be redundant since this is overwritten by stereo data later
	push de
	; store current channel in de
	ld a, [CurChannel]
	and $3
	ld e, a
	ld d, 0
	; get this channel's lr tracks
	call GetLRTracks
	add hl, de ; de = channel 0-3
	ld a, [hl]
	; load lr tracks into Tracks
	ld hl, Channel1Tracks - Channel1
	add hl, bc
	ld [hl], a
	pop de
	ret

_PlayMusic::
; load music
	call MusicOff
	ld hl, MusicID
	ld [hl], e ; song number
	inc hl
	ld [hl], d ; MusicIDHi (always $)
	ld hl, Music
	add hl, de ; three
	add hl, de ; byte
	add hl, de ; pointer
	ld a, [hli]
	ld [MusicBank], a
	ld e, [hl]
	inc hl
	ld d, [hl] ; music header address
	call LoadMusicByte ; store first byte of music header in a
	rlca
	rlca
	and $3 ; get number of channels
	inc a
.loop
; start playing channels
	push af
	call LoadChannel
	call StartChannel
	pop af
	dec a
	jr nz, .loop
	xor a
	ld [wc2b5], a
	ld [Channel1JumpCondition], a
	ld [Channel2JumpCondition], a
	ld [Channel3JumpCondition], a
	ld [Channel4JumpCondition], a
	ld [NoiseSampleAddressLo], a
	ld [NoiseSampleAddressHi], a
	ld [wNoiseSampleDelay], a
	ld [MusicNoiseSampleSet], a
	jp MusicOn

_PlayCryHeader::
; Play cry de using parameters:
;	CryPitch
;	CryLength

	call MusicOff

; Overload the music id with the cry id
	ld hl, MusicID
	ld a, e
	ld [hli], a
	ld [hl], d

; 3-byte pointers (bank, address)
	ld hl, Cries
	add hl, de
	add hl, de
	add hl, de

	ld a, [hli]
	ld [MusicBank], a

	ld e, [hl]
	inc hl
	ld d, [hl]

; Read the cry's sound header
	call LoadMusicByte
	; Top 2 bits contain the number of channels
	rlca
	rlca
	and 3

; For each channel:
	inc a
.loop
	push af
	call LoadChannel

	ld hl, Channel1Flags - Channel1
	add hl, bc
	set SOUND_REST, [hl]

	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_CRY_PITCH, [hl]

	ld hl, Channel1CryPitch - Channel1
	add hl, bc
	ld a, [CryPitch]
	ld [hli], a
	ld a, [CryPitch + 1]
	ld [hl], a

; No tempo for channel 4
	ld a, [CurChannel]
	and 3
	cp 3
	jr nc, .start

; Tempo is effectively length
	ld hl, Channel1Tempo - Channel1
	add hl, bc
	ld a, [CryLength]
	ld [hli], a
	ld a, [CryLength + 1]
	ld [hl], a
.start
	call StartChannel
	ld a, [wStereoPanningMask]
	and a
	jr z, .next

; Stereo only: Play cry from the monster's side.
; This only applies in-battle.

	ld a, [wOptions]
	bit 5, a ; stereo
	jr z, .next

; [Tracks] &= [CryTracks]
	ld hl, Channel1Tracks - Channel1
	add hl, bc
	ld a, [hl]
	ld hl, CryTracks
	and [hl]
	ld hl, Channel1Tracks - Channel1
	add hl, bc
	ld [hl], a

.next
	pop af
	dec a
	jr nz, .loop


; Cries play at max volume, so we save the current volume for later.
	ld a, [LastVolume]
	and a
	jr nz, .end

	ld a, [Volume]
	ld [LastVolume], a
	ld a, $77
	ld [Volume], a

.end
	ld a, 1 ; stop playing music
	ld [SFXPriority], a
	jp MusicOn

_PlaySFX::
; clear channels if they aren't already
	call MusicOff
	ld hl, Channel5Flags
	bit SOUND_CHANNEL_ON, [hl] ; ch5 on?
	jr z, .ch6
	res SOUND_CHANNEL_ON, [hl] ; turn it off
	xor a
	ld [rNR11], a ; length/wavepattern = 0
	ld [rNR13], a ; frequency lo = 0
	ld a, $8
	ld [rNR12], a ; envelope = 0
	ld a, $80
	ld [rNR14], a ; restart sound (freq hi = 0)
	xor a
	ld [SoundInput], a ; global sound off
	ld [rNR10], a ; sweep = 0
.ch6
	ld hl, Channel6Flags
	bit SOUND_CHANNEL_ON, [hl]
	jr z, .ch7
	res SOUND_CHANNEL_ON, [hl] ; turn it off
	xor a
	ld [rNR21], a ; length/wavepattern = 0
	ld [rNR23], a ; frequency lo = 0
	ld a, $8
	ld [rNR22], a ; envelope = 0
	ld a, $80
	ld [rNR24], a ; restart sound (freq hi = 0)
.ch7
	ld hl, Channel7Flags
	bit SOUND_CHANNEL_ON, [hl]
	jr z, .ch8
	res SOUND_CHANNEL_ON, [hl] ; turn it off
	xor a
	ld [rNR30], a ; sound mode #3 off
	ld [rNR31], a ; length/wavepattern = 0
	ld [rNR33], a ; frequency lo = 0
	ld a, $8
	ld [rNR32], a ; envelope = 0
	ld a, $80
	ld [rNR34], a ; restart sound (freq hi = 0)
.ch8
	ld hl, Channel8Flags
	bit SOUND_CHANNEL_ON, [hl]
	jr z, .chscleared
	res SOUND_CHANNEL_ON, [hl] ; turn it off
	xor a
	ld [rNR41], a ; length/wavepattern = 0
	ld [rNR43], a ; frequency lo = 0
	ld [NoiseSampleAddressLo], a
	ld [NoiseSampleAddressHi], a
	ld a, $8
	ld [rNR42], a ; envelope = 0
	ld a, $80
	ld [rNR44], a ; restart sound (freq hi = 0)
.chscleared
; start reading sfx header for # chs
	ld hl, MusicID
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, SFX
	add hl, de ; three
	add hl, de ; byte
	add hl, de ; pointers
	; get bank
	ld a, [hli]
	ld [MusicBank], a
	; get address
	ld e, [hl]
	inc hl
	ld d, [hl]
	; get # channels
	call LoadMusicByte
	rlca ; top 2
	rlca ; bits
	and $3
	inc a ; # channels -> # loops
.startchannels
	push af
	call LoadChannel ; bc = current channel
	ld hl, Channel1Flags - Channel1
	add hl, bc
	set SOUND_SFX, [hl]
	call StartChannel
	pop af
	dec a
	jr nz, .startchannels
	call MusicOn
	xor a
	ld [SFXPriority], a
	ret


PlayStereoSFX::
; play sfx de

	call MusicOff

; standard procedure if stereo's off
	ld a, [wOptions]
	bit 5, a
	jp z, _PlaySFX

; else, let's go ahead with this
	ld hl, MusicID
	ld a, e
	ld [hli], a
	ld [hl], d

; get sfx ptr
	ld hl, SFX
	add hl, de
	add hl, de
	add hl, de

; bank
	ld a, [hli]
	ld [MusicBank], a
; address
	ld e, [hl]
	inc hl
	ld d, [hl]

; bit 2-3
	call LoadMusicByte
	rlca
	rlca
	and 3 ; ch1-4
	inc a

.loop
	push af
	call LoadChannel

	ld hl, Channel1Flags - Channel1
	add hl, bc
	set SOUND_SFX, [hl]

	push de
	; get tracks for this channel
	ld a, [CurChannel]
	and 3 ; ch1-4
	ld e, a
	ld d, 0
	call GetLRTracks
	add hl, de
	ld a, [hl]
	ld hl, wStereoPanningMask
	and [hl]

	ld hl, Channel1Tracks - Channel1
	add hl, bc
	ld [hl], a

	ld hl, Channel1Field0x30 - Channel1 ; $c131 - Channel1
	add hl, bc
	ld [hl], a

	ld a, [CryTracks]
	cp 2 ; ch 1-2
	jr c, .skip

; ch3-4
	ld a, [wSFXDuration]

	ld hl, Channel1Flags2 - Channel1
	add hl, bc
	set SOUND_UNKN_0F, [hl]

.skip
	pop de

; turn channel on
	ld hl, Channel1Flags - Channel1
	add hl, bc
	set SOUND_CHANNEL_ON, [hl] ; on

; done?
	pop af
	dec a
	jr nz, .loop

; we're done
	jp MusicOn

LoadChannel:
; prep channel for use
; input:
; 	de:
	; get pointer to current channel
	call LoadMusicByte
	inc de
	and $7 ; bit 0-2 (current channel)
	ld [CurChannel], a
	ld c, a
	ld b, 0
	ld hl, ChannelPointers
	add hl, bc
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl] ; bc = channel pointer
	ld hl, Channel1Flags - Channel1
	add hl, bc
	res SOUND_CHANNEL_ON, [hl] ; channel off
	call ChannelInit
	; load music pointer
	ld hl, Channel1MusicAddress - Channel1
	add hl, bc
	call LoadMusicByte
	ld [hli], a
	inc de
	call LoadMusicByte
	ld [hl], a
	inc de
	; load music id
	ld hl, Channel1MusicID - Channel1
	add hl, bc
	ld a, [MusicIDLo]
	ld [hli], a
	ld a, [MusicIDHi]
	ld [hl], a
	; load music bank
	ld hl, Channel1MusicBank - Channel1
	add hl, bc
	ld a, [MusicBank]
	ld [hl], a
	ret

ChannelInit:
; make sure channel is cleared
; set default tempo and note length in case nothing is loaded
; input:
;   bc = channel struct pointer
	push de
	xor a
	; get channel struct location and length
	ld hl, Channel1MusicID - Channel1 ; start
	add hl, bc
	ld e, Channel2 - Channel1 ; channel struct length
	; clear channel
.loop
	ld [hli], a
	dec e
	jr nz, .loop
	; set tempo to default ($100)
	ld hl, Channel1Tempo - Channel1
	add hl, bc
	xor a
	ld [hli], a
	inc a
	ld [hl], a
	; set note length to default ($1) (fast)
	ld hl, Channel1NoteLength - Channel1
	add hl, bc
	ld [hl], a
	; clear portamento
	xor a
	ld hl, Channel1PortaCount - Channel1
	add hl, bc
	ld [hl], a
	ld hl, Channel1PortaSteps - Channel1
	add hl, bc
	ld [hl], a
	ld hl, Channel1Flags3 - Channel1
	add hl, bc
	res SOUND_PORTA_1, [hl] ; 0
	res SOUND_PORTA_2, [hl]
	pop de
	ret

LoadMusicByte::
; input:
;   de = current music address
; output:
;   a = CurMusicByte
	ld a, [MusicBank]
	call _LoadMusicByte
	ld a, [CurMusicByte]
	ret

FrequencyTable:
	dw $0000 ; filler
	dw $f82c ; C1
	dw $f89d ; C#1
	dw $f907 ; D1
	dw $f96b ; D#1
	dw $f9ca ; E1
	dw $fa23 ; F1
	dw $fa77 ; F#1
	dw $fac7 ; G1
	dw $fb12 ; G#1
	dw $fb58 ; A1
	dw $fb9b ; A#1
	dw $fbda ; B1
	dw $fc16 ; C2
	dw $fc4e ; C#2
	dw $fc83 ; D2
	dw $fcb5 ; D#2
	dw $fce5 ; E2
	dw $fd11 ; F2
	dw $fd3b ; F#2
	dw $fd63 ; G2
	dw $fd89 ; G#2
	dw $fdac ; A2
	dw $fdcd ; A#2
	dw $fded ; B2

WaveSamples:
	; these are streams of 32 4-bit values used as wavepatterns
	; nothing interesting here!
	dn $0, $2, $4, $6, $8, $a, $c, $e, $f, $f, $f, $e, $e, $d, $d, $c
	dn $c, $b, $a, $9, $8, $7, $6, $5, $4, $4, $3, $3, $2, $2, $1, $1
	dn $0, $2, $4, $6, $8, $a, $c, $e, $e, $f, $f, $f, $f, $e, $e, $e
	dn $d, $d, $c, $b, $a, $9, $8, $7, $6, $5, $4, $3, $2, $2, $1, $1
	dn $1, $3, $6, $9, $b, $d, $e, $e, $e, $e, $f, $f, $f, $f, $e, $d
	dn $d, $e, $f, $f, $f, $f, $e, $e, $e, $e, $d, $b, $9, $6, $3, $1
	dn $0, $2, $4, $6, $8, $a, $c, $d, $e, $f, $f, $e, $d, $e, $f, $f
	dn $e, $e, $d, $c, $b, $a, $9, $8, $7, $6, $5, $4, $3, $2, $1, $0
	dn $0, $1, $2, $3, $4, $5, $6, $7, $8, $a, $c, $d, $e, $e, $f, $7
	dn $7, $f, $e, $e, $d, $c, $a, $8, $7, $6, $5, $4, $3, $2, $1, $0
	dn $0, $0, $1, $1, $2, $2, $3, $3, $4, $4, $3, $3, $2, $2, $1, $1
	dn $f, $f, $e, $e, $c, $c, $a, $a, $8, $8, $a, $a, $c, $c, $e, $e
	dn $0, $2, $4, $6, $8, $a, $c, $e, $c, $b, $a, $9, $8, $7, $6, $5
	dn $f, $f, $f, $e, $e, $d, $d, $c, $4, $4, $3, $3, $2, $2, $1, $1
	dn $c, $0, $a, $9, $8, $7, $f, $5, $f, $f, $f, $e, $e, $d, $d, $c
	dn $4, $4, $3, $3, $2, $2, $f, $1, $0, $2, $4, $6, $8, $a, $c, $e
	dn $4, $4, $3, $3, $2, $2, $1, $f, $0, $0, $4, $6, $8, $a, $c, $e
	dn $f, $8, $f, $e, $e, $d, $d, $c, $c, $b, $a, $9, $8, $7, $6, $5
	dn $1, $1, $0, $0, $0, $0, $0, $8, $0, $0, $1, $3, $5, $7, $9, $a
	dn $b, $4, $b, $a, $a, $9, $9, $8, $8, $7, $6, $5, $4, $3, $2, $1
	dn $7, $9, $b, $d, $f, $f, $f, $f, $f, $f, $f, $f, $f, $d, $b, $9
	dn $7, $5, $3, $1, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1, $3, $5
	dn $0, $1, $1, $2, $2, $3, $3, $4, $4, $5, $5, $6, $6, $7, $7, $7
	dn $8, $8, $9, $9, $a, $a, $b, $b, $c, $c, $d, $d, $e, $e, $f, $f
	dn $4, $6, $8, $a, $c, $c, $c, $c, $c, $c, $c, $c, $c, $a, $8, $6
	dn $4, $2, $1, $1, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1, $1, $2
	dn $7, $a, $d, $f, $f, $f, $d, $a, $7, $4, $1, $0, $0, $0, $1, $4
	dn $7, $a, $d, $f, $f, $f, $d, $a, $7, $4, $1, $0, $0, $0, $1, $4
	dn $e, $e, $e, $e, $e, $e, $e, $e, $e, $e, $e, $e, $e, $e, $e, $e
	dn $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
	; wave $f will never be loaded

Drumkits:
	dw Drumkit0
	dw Drumkit1
	dw Drumkit2
	dw Drumkit3
	dw Drumkit4
	dw Drumkit5

Drumkit0:
	dw Drum00    ; rest
	dw Snare1    ; c
	dw Snare2    ; c#
	dw Snare3    ; d
	dw Snare4    ; d#
	dw Drum05    ; e
	dw Triangle1 ; f
	dw Triangle2 ; f#
	dw HiHat1    ; g
	dw Snare5    ; g#
	dw Snare6    ; a
	dw Snare7    ; a#
	dw HiHat2    ; b
Drumkit1:
	dw Drum00
	dw HiHat1
	dw Snare5
	dw Snare6
	dw Snare7
	dw HiHat2
	dw HiHat3
	dw Snare8
	dw Triangle3
	dw Triangle4
	dw Snare9
	dw Snare10
	dw Snare11
Drumkit2:
	dw Drum00
	dw Snare1
	dw Snare9
	dw Snare10
	dw Snare11
	dw Drum05
	dw Triangle1
	dw Triangle2
	dw HiHat1
	dw Snare5
	dw Snare6
	dw Snare7
	dw HiHat2
Drumkit3:
	dw Drum21
	dw Snare12
	dw Snare13
	dw Snare14
	dw Kick1
	dw Triangle5
	dw Drum20
	dw Drum27
	dw Drum28
	dw Drum29
	dw Drum21
	dw Kick2
	dw Crash2
Drumkit4:
	dw Drum21
	dw Drum20
	dw Snare13
	dw Snare14
	dw Kick1
	dw Drum33
	dw Triangle5
	dw Drum35
	dw Drum31
	dw Drum32
	dw Drum36
	dw Kick2
	dw Crash1
Drumkit5:
	dw Drum00
	dw Snare9
	dw Snare10
	dw Snare11
	dw Drum27
	dw Drum28
	dw Drum29
	dw Drum05
	dw Triangle1
	dw Crash1
	dw Snare14
	dw Snare13
	dw Kick2

Drum00:
; unused
	noise C#,  1, $11, $00
	endchannel

Snare1:
	noise C#,  1, $c1, $33
	endchannel

Snare2:
	noise C#,  1, $b1, $33
	endchannel

Snare3:
	noise C#,  1, $a1, $33
	endchannel

Snare4:
	noise C#,  1, $81, $33
	endchannel

Drum05:
	noise C#,  8, $84, $37
	noise C#,  7, $84, $36
	noise C#,  6, $83, $35
	noise C#,  5, $83, $34
	noise C#,  4, $82, $33
	noise C#,  3, $81, $32
	endchannel

Triangle1:
	noise C#,  1, $51, $2a
	endchannel

Triangle2:
	noise C#,  2, $41, $2b
	noise C#,  1, $61, $2a
	endchannel

HiHat1:
	noise C#,  1, $81, $10
	endchannel

Snare5:
	noise C#,  1, $82, $23
	endchannel

Snare6:
	noise C#,  1, $82, $25
	endchannel

Snare7:
	noise C#,  1, $82, $26
	endchannel

HiHat2:
	noise C#,  1, $a1, $10
	endchannel

HiHat3:
	noise C#,  1, $a2, $11
	endchannel

Snare8: ; e8f44
	noise C#,  1, $a2, $50
	endchannel

Triangle3:
	noise C#,  1, $a1, $18
	noise C#,  1, $31, $33
	endchannel

Triangle4:
	noise C#,  3, $91, $28
	noise C#,  1, $71, $18
	endchannel

Snare9:
	noise C#,  1, $91, $22
	endchannel

Snare10:
	noise C#,  1, $71, $22
	endchannel

Snare11:
	noise C#,  1, $61, $22
	endchannel

Drum20:
	noise C#,  1, $11, $11
Drum21:
	endchannel

Snare12:
	noise C#,  1, $91, $33
	endchannel

Snare13:
	noise C#,  1, $51, $32
	endchannel

Snare14:
	noise C#,  1, $81, $31
	endchannel

Kick1:
	noise C#,  1, $88, $6b
	noise C#,  1, $71, $00
	endchannel

Triangle5:
	noise D_,  1, $91, $18
	endchannel

Drum27:
	noise C#,  8, $92, $10
	endchannel

Drum28:
	noise D_,  4, $91, $00
	noise D_,  4, $11, $00
	endchannel

Drum29:
	noise D_,  4, $91, $11
	noise D_,  4, $11, $00
	endchannel

Crash1:
	noise D_,  4, $88, $15
	noise C#,  1, $65, $12
	endchannel

Drum31:
	noise D_,  4, $51, $21
	noise D_,  4, $11, $11
	endchannel

Drum32:
	noise D_,  4, $51, $50
	noise D_,  4, $11, $11
	endchannel

Drum33:
	noise C#,  1, $a1, $31
	endchannel

Crash2:
	noise C#,  1, $84, $12
	endchannel

Drum35:
	noise D_,  4, $81, $00
	noise D_,  4, $11, $00
	endchannel

Drum36:
	noise D_,  4, $81, $21
	noise D_,  4, $11, $11
	endchannel

Kick2:
	noise C#,  1, $a8, $6b
	noise C#,  1, $71, $00
	endchannel

GetLRTracks:
; gets the default sound l/r channels
; stores mono/stereo table in hl
	ld a, [wOptions]
	bit 5, a ; stereo
	; made redundant, could have had a purpose in gold
	jr nz, .stereo
	ld hl, MonoTracks
	ret

.stereo
	ld hl, StereoTracks
	ret

MonoTracks:
; bit corresponds to track #
; hi: left channel
; lo: right channel
	db $11, $22, $44, $88

StereoTracks:
; made redundant
; seems to be modified on a per-song basis
	db $11, $22, $44, $88

ChannelPointers:
; music channels
	dw Channel1
	dw Channel2
	dw Channel3
	dw Channel4
; sfx channels
	dw Channel5
	dw Channel6
	dw Channel7
	dw Channel8

ClearChannel:
; input: hl = beginning hw sound register (rNR10, rNR20, rNR30, rNR40)
; output: 00 00 80 00 80

;   sound channel   1      2      3      4
	xor a
	ld [hli], a ; rNR10, rNR20, rNR30, rNR40 ; sweep = 0

	ld [hli], a ; rNR11, rNR21, rNR31, rNR41 ; length/wavepattern = 0
	ld a, $8
	ld [hli], a ; rNR12, rNR22, rNR32, rNR42 ; envelope = 0
	xor a
	ld [hli], a ; rNR13, rNR23, rNR33, rNR43 ; frequency lo = 0
	ld a, $80
	ld [hli], a ; rNR14, rNR24, rNR34, rNR44 ; restart sound (freq hi = 0)
	ret
