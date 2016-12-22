DED_RATE = 10485
DED_RATE_NORMAL = 1048576 / DED_RATE
DED_RATE_FAINTED = DED_RATE_NORMAL * 10 / 9

_PlayDEDCry::
	ld c, DED_RATE_NORMAL % $100 ; playback rate
	ld a, e
	and a
	jr z, .notfainted
	ld c, DED_RATE_FAINTED
.notfainted
	call WaitSFX
	ld a, [rSVBK]
	push af
	ld a, 2 ; BANK(wDEDTempSamp)
	ld [rSVBK], a
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, 1 << VBLANK | 1 << TIMER
	ld [rIE], a
	ld a, [rNR50]
	push af
	ld a, [rNR51]
	push af
	ld a, [hVBlank]
	push af
	ld a, $77 ; full volume
	ld [rNR50], a
	xor a
	ld [rNR30], a
	ld a, $20
	ld [rNR32], a
	xor a
	sub c
	ld [rTMA], a
	ld [rTIMA], a
	xor a
	sla c
	sub c
	ld [rNR33], a
	ld c, $44 ; ch3 only
	ld a, [wOptions]
	bit 5, a ; stereo
	jr z, .mono
	ld a, [CryTracks]
	and a
	jr z, .mono
	and c
	ld c, a
.mono
	ld a, c
	ld [rNR51], a
	di
	xor a
	ld [hDEDCryFlag], a
	ld a, 7
	ld [hVBlank], a
	call PlayDEDSamples
	ei
	xor a
	ld [rNR30], a
	ld [rTAC], a
	pop af
	ld [hVBlank], a
	pop af
	ld [rNR51], a
	pop af
	ld [rNR50], a
	pop af
	ld [rIE], a
	pop af
	ld [rSVBK], a
	scf
	ret

.notfound
	and a
	ret
