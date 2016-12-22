PlayStereoCry2::
; Don't wait for the cry to end.
; Used during pic animations.
	push af
	ld a, 1
	ld [wStereoPanningMask], a
	pop af
	jp _PlayCry

PlayFaintingCry2::
	push hl
	push de
	push bc

	call LoadCryHeader
	jr c, .ded
	ld hl, CryPitch
	ld a, 90 percent
	call .Multiply
	ld a, [hProduct + 2]
	ld [hli], a
	ld a, [hProduct + 1]
	ld [hli], a

	ld a, 11 percent
	call .Multiply
	ld a, [hProduct + 2]
	add [hl]
	ld [hli], a
	ld a, [hProduct + 1]
	adc [hl]
	ld [hl], a

	callba _PlayCryHeader
	jr PlayCry_PopBCDEHLOff

.ded
	ld e, 1
	call PlayDEDCry
	jr PlayCry_PopBCDEHLOff

.Multiply
	ld [hMultiplier], a
	ld a, [hli]
	ld [hMultiplicand + 2], a
	ld a, [hld]
	ld [hMultiplicand + 1], a
	xor a
	ld [hMultiplicand], a
	ld [hProduct], a
	predef_jump Multiply

PlayCry::
	call PlayCry2
	jp WaitSFX

PlayCry2::
; Don't wait for the cry to end.
	push af
	xor a
	ld [wStereoPanningMask], a
	ld [CryTracks], a
	pop af

_PlayCry::
	push hl
	push de
	push bc

	call GetCryIndex
	call nc, PlayCryHeader
PlayCry_PopBCDEHLOff:
	jp PopOffBCDEHLAndReturn

LoadCryHeader::
; Load cry header bc.

	call GetCryIndex
	ret c

	anonbankpush CryHeaders

.Function:
	ld a, [hli]
	cp $ff
	jr z, .ded
	ld d, 0
	ld e, a

	ld a, [hli]
	ld [CryPitch], a
	ld a, [hli]
	ld [CryPitch + 1], a
	ld a, [hli]
	ld [CryLength], a
	ld a, [hl]
	ld [CryLength + 1], a
	and a
	ret

.ded
	call LoadDEDCryHeader
	scf
	ret

GetCryIndex::
	and a
	jr z, .no
	cp NUM_POKEMON + 1
	jr nc, .no

	dec a
	ld c, a
	ld b, 0
	ld hl, CryHeaders
	ld a, 5
	rst AddNTimes
	and a
	ret

.no
	scf
	ret
