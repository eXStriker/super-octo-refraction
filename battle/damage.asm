; damage formula:
; base damage = (0.4 * level + 2) * (attack * attack mod) * power / (defense * 50) * item modifier / 100 * critical hit mod
; modified damage = (base damage + 2) * modifiers * (2 ^ shift count) * (100 - random variance) / 100
; move power and modifiers are stored as fractions
; attack mod and critical hit mod are stored as exponents; the exponentiation base is 1.5
; fixed damage ignores all of the above and simply deals the damage that was set

ROUND_DAMAGE EQU 1 ; set to 0 to floor damage or 1 to round

_GetCurrentDamage::

	; if the fixed damage flag is set, just copy that value to wCurDamage and we're done
	ld hl, wCurDamageFlags
	bit 7, [hl]
	jr z, .not_fixed_damage
	inc hl
	ld a, [hli]
	ld [wCurDamage], a
	ld a, [hl]
	ld [wCurDamage + 1], a
	ret

.not_fixed_damage
	; save the current WRAM bank and switch to the bank with the big number buffers
	ld a, [rSVBK]
	push af
	ld a, BANK(wBigNumerator)
	ld [rSVBK], a

	; clear the numerator and denominator buffers; we won't use all the bytes there until we need to
	ld hl, wBigNumerator
	ld bc, 40
	xor a
	call ByteFill

	; start by figuring out the base damage
	; since multiplication is commutative, we can reorder the operations as much as we like
	; numerator = (2 * level + 10) * attack * (3 ^ attack mod) * power numerator * item modifier * (3 ^ critical hit mod)
	; reordered: [2 * (level + 5) * (3 ^ (attack mod + critical hit mod))] * [attack * power numerator] * item modifier

	; level + 5
	ld a, [wCurDamageLevel]
	add a, 5
	ld e, a
	ld d, 0
	rl d

	; * 2
	sla e
	rl d

	; attack mod + critical hit mod
	ld a, [wCurDamageFlags]
	and $33
	ld c, a
	swap c
	add a, c
	and 7
	ld [wCurDamage], a ;using wCurDamage as a buffer, since this function will overwrite it anyway

	; 3 ^ previous value
	ld bc, 1
	and a
	jr z, .stop_tripling
.tripling_loop
	ld h, b
	ld l, c
	add hl, hl
	add hl, bc
	ld b, h
	ld c, l
	dec a
	jr nz, .tripling_loop
.stop_tripling

	; multiply them together and store the result
	call Multiply16
	ld hl, wBigNumerator
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b

	; attack, power numerator
	ld hl, wCurDamageAttack
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wCurDamageMovePowerNumerator
	ld a, [hli]
	ld d, a
	ld e, [hl]

	; multiply them together...
	call Multiply16
	; ...and by the previous value
	ld a, 4
	ld hl, wBigNumerator
	call MultiplyBigNumberByWord

	; finally, load the item modifier...
	ld a, [wCurDamageItemModifier]
	ld e, a
	; ...and multiply it by the big number from before
	ld a, 8
	ld hl, wBigNumerator
	call MultiplyBigNumberByByte

	; now move onto the base damage denominator
	; denominator = 5 * (2 ^ attack mod) * power denominator * defense * 50 * 100 * (2 ^ critical hit mod)
	; reordered: defense * 25000 * power denominator * (2 ^ (attack mod + critical hit mod))

	; load the defense
	ld hl, wCurDamageDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	; * 25000
	ld de, 25000
	call Multiply16

	; store the result
	ld hl, wBigDenominator
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b

	; * power denominator
	ld a, [wCurDamageMovePowerDenominator]
	ld e, a
	ld a, 4
	ld hl, wBigDenominator
	call MultiplyBigNumberByByte

	; reload attack mod + critical hit mod from wCurDamage, and use it as a shift counter to shift the base denominator
	ld a, [wCurDamage]
	and a
	jr z, .no_base_mod_shifting
	ld e, a
.base_mod_shifting_loop
	ld a, 6
	ld hl, wBigDenominator
	call ShiftBigNumber
	dec e
	jr nz, .base_mod_shifting_loop
.no_base_mod_shifting

	; add 2 to base damage
	ld a, 9
	ld de, wBigDenominator
	ld hl, wBigNumerator
	call AddBigNumberToBigNumber
	ld a, 10
	call AddBigNumberToBigNumber

	; handle the modifiers, both numerator and denominator
	ld hl, wCurDamageModifierNumerator
	ld b, 0
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld hl, wBigNumerator
	ld a, 10
	call MultiplyBigNumberByWord

	ld hl, wCurDamageModifierDenominator
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, 6
	ld hl, wBigDenominator
	call MultiplyBigNumberByHalfword

	; handle random damage variance, if it is set
	ld a, [wCurDamageRandomVariance]
	and a
	jr z, .no_random_variance
	cpl
	sub 155 ;~100
	ld e, a
	ld a, 13
	ld hl, wBigNumerator
	call MultiplyBigNumberByByte
	ld e, 100
	ld a, 8
	ld hl, wBigDenominator
	call MultiplyBigNumberByByte
.no_random_variance

	; load the shift counter, and determine which value must be shifted
	ld a, [wCurDamageShiftCount]
	and a
	ld hl, wBigNumerator
	ld de, wBigDenominator
	jr z, .ready
	bit 7, a
	jr z, .shift_numerator

	; shift the denominator
	cpl
	inc a
	ld hl, wBigDenominator
	call ShiftBigNumberByAmount
	ld d, h
	ld e, l
	ld hl, wBigNumerator
	jr .ready

.shift_numerator
	; shift the numerator
	call ShiftBigNumberByAmount

.ready
	; if the result will be zero, return one instead
	call CompareBigNumbers
	jr nc, .not_minimum
	ld bc, 1
	jr .done

.not_minimum
	; shift the denominator by 16 to begin the long division process, and check for overflow
	dec de
	dec de
	call CompareBigNumbers
	jr c, .not_maximum
	ld bc, $ffff
	jr .done

.not_maximum
	; bc = quotient, a = bit count
	ld bc, 0
	ld a, 16

.division_loop
	push af
	sla c
	rl b
	ld a, 16
	call ShiftBigNumber
	call CompareBigNumbers
	jr c, .no_increment_quotient
	inc bc
	ld a, 16
	call SubtractBigNumberFromBigNumber
.no_increment_quotient
	pop af
	dec a
	jr nz, .division_loop

IF ROUND_DAMAGE != 0
	; use the remainder (in wBigNumerator) to determine if the fractional part is .5 or greater, and round up in that case
	ld a, 16
	call ShiftBigNumber
	call CompareBigNumbers
	jr c, .done
	inc c
	jr nz, .done
	inc b
	jr nz, .done
	; 65535.5 and higher should still round down
	dec bc
ENDC

.done
	; we're done; store the result, restore the previous WRAM bank and return
	ld hl, wCurDamage
	ld a, b
	ld [hli], a
	ld [hl], c
	pop af
	ld [rSVBK], a
	ret

MultiplyBigNumberByByte:
	; multiplies the a-byte value at hl by e; stores in place
	ld d, 0
	; fallthrough

MultiplyBigNumberByHalfword:
	; multiplies the a-byte value at hl by de; stores in place
	inc a
	srl a
	push hl
	push bc
	ld bc, 0
.loop
	push de
	push af
	xor a
	ld [hProduct], a
	ld [hProduct + 1], a
	ld a, b
	ld [hProduct + 2], a
	ld a, c
	ld [hProduct + 3], a
	ld a, [hli]
	ld b, [hl]
	dec hl
	ld c, a
	call AddNTimes16
	ld a, [hProduct + 3]
	ld [hli], a
	ld a, [hProduct + 2]
	ld [hli], a
	ld a, [hProduct + 1]
	ld c, a
	ld a, [hProduct]
	ld b, a
	pop af
	pop de
	dec a
	jr nz, .loop
	ld a, c
	ld [hli], a
	ld [hl], b
	pop bc
	pop hl
	ret

MultiplyBigNumberByWord:
	; multiplies the a-byte value at hl by bcde; stores in place
	push de
	push hl
	push bc
	push af
	ld de, wBigNumberBuffer
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	pop af
	ld c, a
	ld b, 0
	push af
	rst CopyBytes
	pop af
	pop bc
	push af
	ld hl, wBigNumberBuffer
	ld d, b
	ld e, c
	call MultiplyBigNumberByHalfword
	pop af
	pop hl
	pop de
	push af
	call MultiplyBigNumberByHalfword
	pop af
	ld de, wBigNumberBuffer
	; fallthrough

AddBigNumberToBigNumber:
	; adds a-byte de to a-byte hl; stores in place
	push hl
	push de
	push bc
	ld c, a
	and a
.loop
	ld a, [de]
	inc de
	ld b, a
	ld a, [hl]
	adc b
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ret

SubtractBigNumberFromBigNumber:
	; subtracts a-byte de from a-byte hl; stores in place
	push hl
	push de
	push bc
	ld c, a
	and a
.loop
	ld a, [de]
	inc de
	ld b, a
	ld a, [hl]
	sbc b
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ret

ShiftBigNumber:
	; shifts a-byte value at hl to the left (one bit); stores in place
	push hl
	and a
.shift_loop
	rl [hl]
	inc hl
	dec a
	jr nz, .shift_loop
	pop hl
	ret

ShiftBigNumberByAmount:
	; shifts 16-byte value at hl by a; returns updated pointer in hl
	push bc
	ld c, a
	and 7
	srl c
	srl c
	srl c
	jr z, .no_byte_shift
.byte_shift_loop
	dec hl
	dec c
	jr nz, .byte_shift_loop
.no_byte_shift
	ld c, a
	and a
	jr z, .done
.bit_shift_loop
	ld a, 16
	call ShiftBigNumber
	dec c
	jr nz, .bit_shift_loop
.done
	pop bc
	ret

CompareBigNumbers:
	; compares 16-byte values at hl and de; returns flags as usual (carry if hl < de, etc)
	push hl
	push de
	push bc
	ld a, e
	add a, 15
	ld e, a
	jr nc, .no_carry_e
	inc d
.no_carry_e
	ld a, l
	add a, 15
	ld l, a
	jr nc, .no_carry_l
	inc h
.no_carry_l
	ld c, 16
.loop
	ld a, [de]
	dec de
	ld b, a
	ld a, [hld]
	cp b
	jr nz, .done
	dec c
	jr nz, .loop
.done
	pop bc
	pop de
	pop hl
	ret
