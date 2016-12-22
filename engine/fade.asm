RelativeFade::
	push hl
	push de
	push bc
	ld a, c
	bit 7, a
	res 7, a
	jr z, .regularDelay
	ld [wFadeReloadValue], a
.regularDelay
	ld [wFadeCounterBeforeDelay], a
	bit 7, b
	res 7, b
	ld a, FadeDeltas % $100
	ld [hPrintNum4], a
	ld a, FadeDeltas / $100
	ld [hPrintNum5], a
	ld a, b
	ld bc, FadeCounters
	jr z, .skip
	push af
	push hl
	push de
	call .setupdeltas
	pop de
	pop hl
	ld a, 8 palettes
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, 8 palettes
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
	pop af
.skip
	call .setupdeltas
	pop bc
	pop de
	pop hl
.loop
	push hl
	push bc
	bit 7, b
	res 7, b
	ld de, FadeDeltas
	ld a, b
	ld [hLoopCounter], a
	jr z, .skip2
	push bc
	push hl
	call .fade
	pop hl
	pop bc
	ld a, 8 palettes
	add l
	ld l, a
	jr nc, .noCarry3
	inc h
.noCarry3
	ld a, [hLoopCounter]
	add a
	ld [hLoopCounter], a
.skip2
	call .fade
	xor a
	ld [hPrintNum1], a
	ld a, [hLoopCounter]
	ld hl, FadeDeltas
	ld bc, FadeCounters
.loop2
	ld [hLoopCounter], a
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [bc]
	and a
	jr z, .nob2
	bit 7, a
	jr z, .addb2
	inc a
	jr nz, .nob2
	ld de, palblue 1
	add hl, de
	jr .nob2
.addb2
	dec a
	jr nz, .nob2
	ld de, $10000 - palblue 1
	add hl, de
.nob2
	ld d, a
	ld [bc], a
	inc bc
	ld a, [hPrintNum1]
	or d
	ld [hPrintNum1], a
	ld a, [bc]
	and a
	jr z, .nog2
	bit 7, a
	jr z, .addg2
	inc a
	jr nz, .nog2
	ld de, palgreen 1
	add hl, de
	jr .nog2
.addg2
	dec a
	jr nz, .nog2
	ld de, $10000 - palgreen 1
	add hl, de
.nog2
	ld d, a
	ld [bc], a
	inc bc
	ld a, [hPrintNum1]
	or d
	ld [hPrintNum1], a
	ld a, [bc]
	and a
	jr z, .nor2
	bit 7, a
	jr z, .addr2
	inc a
	jr nz, .nor2
	ld de, palred 1
	add hl, de
	jr .nor2
.addr2
	dec a
	jr nz, .nor2
	ld de, $10000 - palred 1
	add hl, de
.nor2
	ld d, a
	ld [bc], a
	inc bc
	ld a, [hPrintNum1]
	or d
	ld [hPrintNum1], a
	ld d, h
	ld e, l
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, [hLoopCounter]
	dec a
	jr nz, .loop2
	pop bc
	pop hl
	ld a, [wFadeReloadValue]
	and a
	jr z, .regularDelay2
	ld a, [wFadeCounterBeforeDelay]
	dec a
	ld [wFadeCounterBeforeDelay], a
	jr nz, .noDelay
	ld a, [wFadeReloadValue]
	ld [wFadeCounterBeforeDelay], a
	ld a, 1
	ld [hCGBPalUpdate], a
	call DelayFrame
	jr .noDelay
.regularDelay2
	ld a, 1
	ld [hCGBPalUpdate], a
	ld a, [wFadeCounterBeforeDelay]
	ld c, a
	call DelayFrames
.noDelay
	ld a, [hPrintNum1]
	and a
	jp nz, .loop
	ret

.fade
	ld a, [de]
	inc de
	add [hl]
	ld [hli], a
	ld a, [de]
	inc de
	adc [hl]
	ld [hli], a
	dec b
	jr nz, .fade
	ret

.setupdeltas
	push af
	push bc
	ld a, [hl]
	and $1f
	ld b, a
	ld a, [de]
	and $1f
	sub b
	ld [hPrintNum1], a
	ld a, [hli]
	ld c, a
	ld a, [hl]
	and $3
	rept 3
	sla c
	rla
	endr
	ld b, a
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	and $3
	rept 3
	sla c
	rla
	endr
	sub b
	ld [hPrintNum2], a
	ld a, [hli]
	srl a
	srl a
	and $1f
	ld b, a
	ld a, [de]
	inc de
	srl a
	srl a
	and $1f
	sub b
	ld [hPrintNum3], a
	pop bc
	push hl
	push de
	ld hl, 0
	ld a, [hPrintNum1]
	ld [bc], a
	inc bc
	and a
	jr z, .nob
	bit 7, a
	ld de, palblue 1
	jr z, .addb
	ld de, $10000 - palblue 1
.addb
	add hl, de
.nob
	ld a, [hPrintNum2]
	ld [bc], a
	inc bc
	and a
	jr z, .nog
	bit 7, a
	ld de, palgreen 1
	jr z, .addg
	ld de, $10000 - palgreen 1
.addg
	add hl, de
.nog
	ld a, [hPrintNum3]
	ld [bc], a
	inc bc
	and a
	jr z, .nor
	bit 7, a
	ld de, palred 1
	jr z, .addr
	ld de, $10000 - palred 1
.addr
	add hl, de
.nor
	ld d, h
	ld e, l
	ld a, [hPrintNum4]
	ld l, a
	ld a, [hPrintNum5]
	ld h, a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, l
	ld [hPrintNum4], a
	ld a, h
	ld [hPrintNum5], a
	pop de
	pop hl
	pop af
	dec a
	jp nz, .setupdeltas
	ret

WhitePals:
rept 16
	RGB 31, 31, 31
endr

BlackPals:
rept 16
	RGB 0, 0, 0
endr