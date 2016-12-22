; Audio interfaces.

_LoadMusicByte::
; CurMusicByte = [a:de]
GLOBAL LoadMusicByte
	rst Bankswitch

	ld a, [de]
	ld [CurMusicByte], a
	ld a, BANK(LoadMusicByte)
	rst Bankswitch
	ret

FadeToMapMusic::
	push hl
	push de
	push bc
	push af

	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	jr z, .popOffRegsAndReturn

	ld a, 8
	ld [MusicFade], a
	ld a, e
	ld [wMapMusic], a
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a
.popOffRegsAndReturn
	jr PopOffRegsAndReturn


MapSetup_Sound_Off::
	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	ret z

; fallthrough
TurnSoundOff::
	push hl
	push de
	push bc
	push af

	callba _MapSetup_Sound_Off

	jr PopOffRegsAndReturn

UpdateSound::

	push hl
	push de
	push bc
	push af

	callba _UpdateSound_SkipMusicCheck

	jr PopOffRegsAndReturn


_PlayMapMusic:
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	pop de
	ld a, e
	ld [wMapMusic], a

; fallthrough
PlayMusic::
; Play music de.

	push hl
	push de
	push bc
	push af

	bankpushcall _PlayMusic, PlayMusic_BankPush
	
	jr PopOffRegsAndReturn

PlayMusic2::
; Stop playing music, then play music de.

	push hl
	push de
	push bc
	push af

	bankpushcall _PlayMusic, PlayMusic2_BankPush

	jr PopOffRegsAndReturn

Script_playmapmusic::
; script command 0x82
PlayMapMusic::
	push hl
	push de
	push bc
	push af

	call GetMapMusic
	ld a, [wMapMusic]
	cp e
	call nz, _PlayMapMusic
	jr PopOffRegsAndReturn

EnterMapMusic::
	push hl
	push de
	push bc
	push af

	xor a
	ld [wDontPlayMapMusicOnReload], a
	call GetMapMusic
	call _PlayMapMusic

PopOffRegsAndReturn:
	pop af
PopOffBCDEHLAndReturn:
	pop bc
	pop de
	pop hl
	ret

GetMapHeaderAttribute_PopOffBCDEHLAndReturn:
	ld c, a
	jr PopOffBCDEHLAndReturn

TryRestartMapMusic::
	call PopSoundstate
	push af
	ld a, [wDontPlayMapMusicOnReload]
	and a
	jr nz, DontRestartMapMusic
	pop af
	ret nc
RestartMapMusic::
	push hl
	push de
	push bc
	push af
	ld a, [wMapMusic]
	ld e, a
	ld d, 0
	call PlayMusic
	jr PopOffRegsAndReturn

WaitPlaySFX::
	call WaitSFX
	; fallthrough

PlaySFX::
; Play sound effect de.
; Sound effects are ordered by priority (lowest to highest)

	push hl
	push de
	push bc
	push af

	; Is something already playing?
	call CheckSFX
	jr nc, .play

	; Does it have priority?
	ld a, [CurSFX]
	cp e
	jr c, PopOffRegsAndReturn

.play
	ld a, e
	ld [CurSFX], a

	callba _PlaySFX
	jr PopOffRegsAndReturn

KillPlayWaitSFX:
	call SFXChannelsOff
	jr PlayWaitSFX

WaitPlayWaitSFX:
	call WaitSFX

PlayWaitSFX::
	call PlaySFX
	; fallthrough

Script_waitsfx::
; script command 0x86
WaitSFX::
; infinite loop until sfx is done playing

	push hl
	push de
	push bc
	ld bc, Channel6Flags - Channel5Flags
	jr .handleLoop
.wait
	call DelayFrame
.handleLoop
	ld a, 4
	ld hl, Channel5Flags
.checkEachChannel
	bit SOUND_CHANNEL_ON, [hl]
	jr nz, .wait
	add hl, bc
	dec a
	jr nz, .checkEachChannel
	jr PopOffBCDEHLAndReturn

DontRestartMapMusic:
	pop af
	xor a
	ld [wMapMusic], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	xor a
	ld [wDontPlayMapMusicOnReload], a
	ret

PlayCryHeader::
; Play cry header at hl
	anonbankpush CryHeaders

PlayCryHeader_BankPush:
	ld a, [hli]
	cp $ff
	jr z, .ded
	ld e, a
	ld d, 0

	ld a, [hli]
	ld [CryPitch], a
	ld a, [hli]
	ld [CryPitch + 1], a
	ld a, [hli]
	ld [CryLength], a
	ld a, [hl]
	ld [CryLength + 1], a
	jpba _PlayCryHeader

.ded
	ld e, 0
	call LoadDEDCryHeader
	jp PlayDEDCry

PlayMusic_BankPush:
	ld a, e
	and a
	jp z, _MapSetup_Sound_Off
	jp _PlayMusic

PlayMusic2_BankPush:
	push de
	ld de, MUSIC_NONE
	call _PlayMusic
	call DelayFrame
	pop de
	jp _PlayMusic

IsSFXPlaying::
; Return carry if no sound effect is playing.
; The inverse of CheckSFX.
	ld a, [Channel5Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	ld a, [Channel6Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	ld a, [Channel7Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	ld a, [Channel8Flags]
	bit SOUND_CHANNEL_ON, a
	jr nz, .playing
	scf
	ret

.playing
	pop hl
	and a
	ret

MaxVolume::
	ld a, $77 ; max
	ld [Volume], a
	ret

LowVolume::
	ld a, $33 ; 40%
	ld [Volume], a
	ret

VolumeOff::
	xor a
	ld [Volume], a
	ret

FadeInMusic::
	ld a, 4 | 1 << 7
	ld [MusicFade], a
	ret

SkipMusic::
; Skip a frames of music
	ld [hBuffer], a
	ld a, [MusicPlaying]
	push af
	xor a
	ld [MusicPlaying], a
	ld a, [hBuffer]
.loop
	call UpdateSound
	dec a
	jr nz, .loop
	pop af
	ld [MusicPlaying], a
	ret

SpecialMapMusic::
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, .surf
	cp PLAYER_SURF_PIKA
	jr z, .surf

.no
	and a
	ret

.surf
	ld de, MUSIC_SURF
	scf
	ret

CheckSFX::
; Return carry if any SFX channels are active.
	ld a, [Channel5Flags]
	bit 0, a
	jr nz, .playing
	ld a, [Channel6Flags]
	bit 0, a
	jr nz, .playing
	ld a, [Channel7Flags]
	bit 0, a
	jr nz, .playing
	ld a, [Channel8Flags]
	bit 0, a
	jr nz, .playing
	and a
	ret
.playing
	scf
	ret

TerminateExpBarSound::
	xor a
	ld [Channel5Flags], a
	ld [SoundInput], a
	ld [rNR10], a
	ld [rNR11], a
	ld [rNR12], a
	ld [rNR13], a
	ld [rNR14], a
	ret

ChannelsOff::
; Quickly turn off music channels
	xor a
	ld [Channel1Flags], a
	ld [Channel2Flags], a
	ld [Channel3Flags], a
	ld [Channel4Flags], a
	ld [SoundInput], a
	ret

SFXChannelsOff::
; Quickly turn off sound effect channels
	xor a
	ld [Channel5Flags], a
	ld [Channel6Flags], a
	ld [Channel7Flags], a
	ld [Channel8Flags], a
	ld [SoundInput], a
	ret

PushSoundstate::
	push hl
	push de
	push bc

	call SFXChannelsOff ; kill SFX
	call DelayFrame ; sync tracks

	di
	callba _PushSoundstate

	jr PopOffBCDEHLAndReti

PopSoundstate::
	push hl
	push de
	push bc

	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame ; sync tracks

	di
	callba _PopSoundstate

PopOffBCDEHLAndReti:
	pop bc
	pop de
	pop hl
	reti
