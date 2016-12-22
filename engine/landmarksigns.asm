QueueLandmarkSignAnim:
	xor a
	ld [hBGMapMode], a
	call GetMapPermission
	cp GATE
	jr z, .cancel
	call GetCurWorldMapLocation
	and a
	jr z, .cancel
	cp DUMMY2
	jr c, .landmark_okay
	cp DUMMY4 + 1
	jr c, .cancel
	cp MYSTERY_LANDMARK
	jr nc, .cancel
.landmark_okay
	ld [wCurrentLandmark], a
	ld hl, wMapSignRoutineIdx
	ld [hl], 0
	ret

.cancel
	ld hl, wMapSignRoutineIdx
	ld [hl], $80
	ret

RunLandmarkSignAnim:
	xor a
	ld [hBGMapMode], a
	ld a, [wMapSignRoutineIdx]
	bit 7, a
	ret nz
	cp (.JumptableEnd - .Jumptable) / 2
	jp nc, CancelMapSign
	ld e, a
	xor a
	ld [wLCDCPointer], a
	ld a, e
	jumptable

.Jumptable:
	dw .Test
	dw .SlideOut
	dw .Draw
	dw .SlideIn
	dw .Countdown
	dw .SlideOut
	dw CancelMapSign
.JumptableEnd:

.SlideIn:
; The sign has a height of 3, so slide it in
; until the whole sign is visible.
	ld a, [rWY]
	dec a
	dec a
	ld [rWY], a
	ld [hWY], a
	cp SCREEN_HEIGHT_PX - (3 * 8)
	ret nz
; Display the sign for 120 frames.
	ld a, 120
	ld [wMapSignTimer], a
	jp .Next

.Countdown
	ld hl, wMapSignTimer
	dec [hl]
	ret nz
	jp .Next

.Test:
; If the landmark for the current map is the same
; as the last sign displayed, exit the routine.
	ld hl, wLastLandmark
	ld a, [wCurrentLandmark]
	cp [hl]
	jp z, CancelMapSign
	ld [hl], a
	call .Next
; If the last sign is still visible i.e. its
; timer is still running, slide out the old sign.
	ld a, [rWY]
	cp SCREEN_HEIGHT_PX
	jp z, .Next
.SlideOut:
; Slide the current window off screen
	ld a, [rWY]
	inc a
	inc a
	ld [rWY], a
	ld [hWY], a
	cp SCREEN_HEIGHT_PX
	ret nz
	jp .Next

.Draw:
	ld de, LandmarkSignGFX
	ld hl, VTiles1
	lb bc, BANK(LandmarkSignGFX), 23
	call Request2bpp
	decoord 0, 0
	ld hl, LandmarkSignTilemap
	ld bc, LandmarkSignTilemapEnd - LandmarkSignTilemap
	rst CopyBytes

	ld a, [wCurrentLandmark]
	ld e, a
	callba GetLandmarkName

	ld de, wStringBuffer1
	ld hl, wMisc
	call CopyName2

	ld de, wMisc
	ld hl, wDecompressScratch
	lb bc, $38, $10
	predef PlaceVWFString

	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	ld a, b
	and $7
	ld d, a
	ld bc, 16
	jr z, .nopad
	add hl, bc
	ld a, 8
	sub d
	ld d, a
.nopad
	ld bc, $10000 - wDecompressScratch
	add hl, bc
	srl h
	rr l
	push hl
	ld a, l
	and $8
	add d
	srl a
	adc 0
	rept 4
	srl h
	rr l
	endr
	jr nc, .noceil
	inc l
.noceil
	push hl
	ld e, l
	sla e
	and a
	ld hl, wDecompressScratch
	jr z, .noshift
	ld bc, 15
.centerloop
	push hl
	ld d, 8
.centerloop2
	push de
	push hl
	and a ; clear carry flag
	push af
.centerloop3
	ld a, $ff
	ld [hli], a
	pop af
	rr [hl]
	push af
	add hl, bc
	dec e
	jr nz, .centerloop3
	pop af
	pop hl
	pop de
	inc hl
	inc hl
	dec d
	jr nz, .centerloop2
	pop hl
	dec a
	jr nz, .centerloop
	pop bc
	pop hl
	jr .skip
.noshift
	pop bc
	pop de
	inc d
	ld a, $ff
.noshiftloop
	ld [hli], a
	inc hl
	dec e
	jr nz, .noshiftloop
	dec d
	jr z, .skip
	jr .noshiftloop
.skip
	hlcoord 10, 1
	ld a, l
	sub c
	ld l, a
	jr nc, .nocarry
	dec h
.nocarry
	sla c
	ld b, c
	ld a, $97
.fillinc
	ld [hli], a
	inc a
	dec b
	jr nz, .fillinc
	ld hl, VTiles1 tile $17
	ld de, wDecompressScratch
	ld b, BANK(RunLandmarkSignAnim)
	call Request2bpp
	pop af
	ld [rSVBK], a

	hlcoord 0, 0, AttrMap
	ld bc, 3 * SCREEN_WIDTH
	ld a, $87
	call ByteFill
	callba Function104303
.Next:
; Queue the next function in the sequence.
	ld hl, wMapSignRoutineIdx
	inc [hl]
	ret

LandmarkSignTilemap:
	db $80, $81, $82, $89, $89, $89, $89, $89, $89, $8a
	db $8b, $89, $89, $89, $89, $89, $89, $8f, $90, $91
	db $83, $84, $85, $96, $96, $96, $96, $96, $96, $96
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $92
	db $86, $87, $88, $8c, $8c, $8c, $8c, $8c, $8c, $8d
	db $8e, $8c, $8c, $8c, $8c, $8c, $8c, $93, $94, $95
LandmarkSignTilemapEnd
