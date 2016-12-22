PrintBigNumber:
	; prints the number bcde, at coordinates hl, using [hDigitsFlags] digits, right-aligned and space-padded
	; bcde is treated as an unsigned number if [hDigitsFlags]'s bit 7 is set, or as signed otherwise
	ld a, [hDigitsFlags]
	push af
	cpl
	and b
	scf
	ccf
	bit 7, a
	call nz, .change_sign
	ld a, b
	ld [hDividend], a
	ld a, c
	ld [hDividend + 1], a
	ld a, d
	ld [hDividend + 2], a
	ld a, e
	ld [hDividend + 3], a
	pop de
	res 7, d
	ld e, d
	ld d, 0
	sbc a
	ld c, a
	push de
	push hl
	add hl, de
	dec hl
.next_digit
	ld a, 10
	ld [hDivisor], a
	ld b, 4
	predef Divide
	ld a, [hRemainder]
	add "0"
.print_digit
	ld [hld], a
	dec e
	jr nz, .next_digit
	pop hl
	pop de
.clear_leading_zero
	dec e
	jr z, .check_negative
	ld a, [hl]
	cp "0"
	jr nz, .check_negative
	ld a, $7f
	ld [hli], a
	jr .clear_leading_zero
.check_negative
	ld a, c
	and a
	ret z
	dec hl
	ld [hl], $e3
	ret
.change_sign
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	ld a, d
	cpl
	ld d, a
	ld a, e
	cpl
	ld e, a
	scf
	inc e
	ret nz
	inc d
	ret nz
	inc c
	ret nz
	inc b
	ret
