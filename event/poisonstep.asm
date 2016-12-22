DoPoisonStep::
	ld a, [wPartyCount]
	and a
	jr z, .no_faint

	xor a
	ld c, 7
	ld hl, EngineBuffer1
.loop_clearEngineBuffer1
	ld [hli], a
	dec c
	jr nz, .loop_clearEngineBuffer1

	xor a
	ld [wCurPartyMon], a
.loop_check_poison
	call .DamageMonIfPoisoned
	jr nc, .not_poisoned
; the output flag is stored in c, copy it to the ([wCurPartyMon] + 2)nd EngineBuffer
; and set the corresponding flag in EngineBuffer1
	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, EngineBuffer2
	add hl, de
	ld [hl], c
	ld a, [EngineBuffer1]
	or c
	ld [EngineBuffer1], a

.not_poisoned
	ld a, [wPartyCount]
	ld hl, wCurPartyMon
	inc [hl]
	cp [hl]
	jr nz, .loop_check_poison

	ld a, [EngineBuffer1]
	and %10
	jr nz, .someone_has_fainted
	ld a, [EngineBuffer1]
	and %01
	jr z, .no_faint
	call .PlayPoisonSFX
	xor a
	ret

.someone_has_fainted
	ld a, BANK(.Script_MonFaintedToPoison)
	ld hl, .Script_MonFaintedToPoison
	call CallScript
	scf
	ret

.no_faint
	xor a
	ret

.DamageMonIfPoisoned
; check if mon is poisoned, return if not
	ld a, MON_STATUS
	call GetPartyParamLocation
	ld a, [hl]
	and 1 << PSN
	ret z

; check if mon is already fainted, return if so
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	or c
	ret z

; do 1 HP damage
	dec bc
	ld a, b
	or c
	jr nz, .not_fainted
; check if mon has fainted as a result of poison damage

; the mon has fainted, reset its status, set carry, and return %10
	ld a, MON_STATUS
	call GetPartyParamLocation
	ld [hl], 0
	ld c, %10
	scf
	ret

.not_fainted
; set carry and return %01
	ld [hl], c
	dec hl
	ld [hl], b

	ld c, %01
	scf
	ret

.PlayPoisonSFX
	ld de, SFX_POISON
	call PlaySFX
	ld b, $2
	call LoadPoisonBGPals
	jp DelayFrame

.Script_MonFaintedToPoison
	callasm .PlayPoisonSFX
	opentext
	callasm .CheckWhitedOut
	closetext
	end

.CheckWhitedOut
	xor a
	ld [wCurPartyMon], a
	ld de, EngineBuffer2
.party_loop
	push de
	ld a, [de]
	and %10
	jr z, .mon_not_fainted
	ld c, HAPPINESS_POISONFAINT
	callba ChangeHappiness
	callba GetPartyNick
	ld hl, .PoisonFaintText
	call PrintText

.mon_not_fainted
	pop de
	inc de
	ld hl, wCurPartyMon
	inc [hl]
	ld a, [wPartyCount]
	cp [hl]
	jr nz, .party_loop
	callba CheckPlayerPartyForFitPkmn
	ld a, d
	ld [hScriptVar], a
	ret

.PoisonFaintText
	text_jump UnknownText_0x1c0acc

.PoisonWhiteOutText
	text_jump UnknownText_0x1c0ada

LoadPoisonBGPals:
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, BGPals
	ld c, $20
.loop
; RGB 31, 21, 28
	ld a, (palred 31 + palgreen 21 + palblue 28) % $100
	ld [hli], a
	ld a, (palred 31 + palgreen 21 + palblue 28) / $100
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ld c, 4
	call DelayFrames
	jp UpdateTimePals
