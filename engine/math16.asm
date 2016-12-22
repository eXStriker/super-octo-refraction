_Multiply16::
	; calculates bc * de and stores the result in bcde (bc: high word, de: low word) and in hProduct
	; does not preserve af or hl
	xor a
	ld hl, hProduct
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	;fallthrough

_AddNTimes16::
	; calculates hProduct + bc * de, returns both in bcde (bc: high word, de: low word) and in hProduct
	; does not preserve af or hl; returns carry status for the addition
	ld hl, 0
	xor a ; zero, no carry
	push af
.loop
	srl d
	rr e
	jr nc, .next
	pop af
	ld a, [hProduct + 3]
	add c
	ld [hProduct + 3], a
	ld a, [hProduct + 2]
	adc b
	ld [hProduct + 2], a
	ld a, [hProduct + 1]
	adc l
	ld [hProduct + 1], a
	ld a, [hProduct]
	adc h
	ld [hProduct], a
	push af
.next
	sla c
	rl b
	rl l
	rl h
	ld a, e
	or d
	jr nz, .loop
	ld hl, hProduct
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	pop af
	ret

_Divide16::
	; calculates bc / de, stores quotient in de and remainder in bc
	; also stores quotient in hQuotient and remainder in hRemainder
	; does not preserve af or hl
	ld a, d
	and a
	jr z, .divisor_8_bit
	ld hl, 1
.initial_shift_loop
	bit 7, d
	jr nz, .main_division_loop
	sla e
	rl d
	sla l
	jr .initial_shift_loop
.main_division_loop
	ld a, c
	sub e
	ld a, b
	sbc d
	jr c, .remainder_smaller
	ld a, h
	add l
	ld h, a
	ld a, c
	sub e
	ld c, a
	ld a, b
	sbc d
	ld b, a
.remainder_smaller
	srl d
	rr e
	srl l
	jr nc, .main_division_loop
	ld e, h
	ld d, 0
	xor a
	ld hl, hDividend
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hl], c
	ret
.divisor_8_bit
	ld a, b
	ld [hDividend], a
	ld a, c
	ld [hDividend + 1], a
	ld a, e
	ld [hDivisor], a
	ld b, 2
	predef Divide
	ld hl, hQuotient + 1
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld c, [hl]
	xor a
	ld [hli], a
	ld [hl], c
	ld b, 0
	ret

DivideLong::
; divides 4-byte hDividend by 2-byte hDivisor
; stores quotient in 4-byte hLongQuotient (hDividend, hQuotient - 1, hProduct, etc) and remainder in 2-byte hRemainder
	push bc
	push de
	push hl
	ld hl, hDividend
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
	or l
	jp z, .division_by_zero
	push hl
	; clear quotient and remainder
	xor a
	ld hl, hLongQuotient
	rept 6
	ld [hli], a
	endr
	pop hl
	ld a, 32
	ld [hLoopCounter], a
.loop
	sla e
	rl d
	rl c
	rl b
	ld a, [hRemainder + 1]
	rla
	ld [hRemainder + 1], a
	ld a, [hRemainder]
	rla
	ld [hRemainder], a
	ld a, [hRemainder + 1]
	sub l
	ld a, [hRemainder]
	sbc h
	jr c, .skip
.sub
	ld a, [hRemainder + 1]
	sub l
	ld [hRemainder + 1], a
	ld a, [hRemainder]
	sbc h
	ld [hRemainder], a
	scf
	jr .done
.skip
	and a ; clear carry flag
.done
	ld a, [hLongQuotient + 3]
	rla
	ld [hLongQuotient + 3], a
	ld a, [hLongQuotient + 2]
	rla
	ld [hLongQuotient + 2], a
	ld a, [hLongQuotient + 1]
	rla
	ld [hLongQuotient + 1], a
	ld a, [hLongQuotient]
	rla
	ld [hLongQuotient], a
	ld a, [hLoopCounter]
	dec a
	ld [hLoopCounter], a
	jr nz, .loop
	pop hl
	pop de
	pop bc
	ret
.division_by_zero
	ld [hCrashSavedA], a
	ld a, $2
	pop hl
	pop de
	pop bc
	jp Crash
