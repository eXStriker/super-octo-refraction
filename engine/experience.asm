CalcLevel:
	ld a, [hVBlank]
	push af
	ld a, 2
	ld [hVBlank], a

	ld a, [TempMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld d, 0
.next_level
	inc d
	ld a, d
	cp MAX_LEVEL + 1
	jr z, .got_level
	call CalcExpAtLevel
	push hl
	ld hl, TempMonExp + 2
	ld a, [hProduct + 3]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [hProduct + 2]
	ld c, a
	ld a, [hld]
	sbc c
	ld a, [hProduct + 1]
	ld c, a
	ld a, [hl]
	sbc c
	pop hl
	jr nc, .next_level

.got_level
	pop af
	ld [hVBlank], a
	dec d
	ret

CalcExpAtLevel::
; max((a/b)*n**3 + c*n**2 + d*n - e, 0)
	ld a, d
	cp 2
	jr nc, .greater_than_2
	; level 1 is 0 exp
	xor a
	ld [hProduct + 1], a
	ld [hProduct + 2], a
	ld [hProduct + 3], a
	ret

.greater_than_2
	ld a, [BaseGrowthRate]
	cp ERRATIC
	jp z, ErraticGrowth
	cp FLUCTUATING
	jp z, FluctuatingGrowth
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, GrowthRates
	add hl, bc
; Cube the level
	ld a, d
	call GetCube

; Multiply by a
	ld a, [hl]
	and $f0
	swap a
	ld [hMultiplier], a
	predef Multiply
; Divide by b
	ld a, [hli]
	and $f
	ld [hDivisor], a
	ld b, 4
	predef Divide
; Push the cubic term to the stack
	ld a, [hQuotient + 0]
	push af
	ld a, [hQuotient + 1]
	push af
	ld a, [hQuotient + 2]
	push af
; Square the level and multiply by the lower 7 bits of c
	ld a, d
	call GetSquare
	ld a, [hl]
	and $7f
	ld [hMultiplier], a
	predef Multiply
; Push the absolute value of the quadratic term to the stack
	ld a, [hProduct + 1]
	push af
	ld a, [hProduct + 2]
	push af
	ld a, [hProduct + 3]
	push af
	ld a, [hli]
	push af
; Multiply the level by d
	xor a
	ld [hMultiplicand + 0], a
	ld [hMultiplicand + 1], a
	ld a, d
	ld [hMultiplicand + 2], a
	ld a, [hli]
	ld [hMultiplier], a
	predef Multiply
; Subtract e
	ld b, [hl]
	ld a, [hProduct + 3]
	sub b
	ld [hMultiplicand + 2], a
	ld b, $0
	ld a, [hProduct + 2]
	sbc b
	ld [hMultiplicand + 1], a
	ld a, [hProduct + 1]
	sbc b
	ld [hMultiplicand], a
; If bit 7 of c is set, c is negative; otherwise, it's positive
	pop af
	and $80
	jr nz, .subtract
; Add c*n**2 to (d*n - e)
	pop bc
	ld a, [hProduct + 3]
	add b
	ld [hMultiplicand + 2], a
	pop bc
	ld a, [hProduct + 2]
	adc b
	ld [hMultiplicand + 1], a
	pop bc
	ld a, [hProduct + 1]
	adc b
	ld [hMultiplicand], a
	jr .done_quadratic

.subtract
; Subtract c*n**2 from (d*n - e)
	pop bc
	ld a, [hProduct + 3]
	sub b
	ld [hMultiplicand + 2], a
	pop bc
	ld a, [hProduct + 2]
	sbc b
	ld [hMultiplicand + 1], a
	pop bc
	ld a, [hProduct + 1]
	sbc b
	ld [hMultiplicand], a

.done_quadratic
; Add (a/b)*n**3 to (d*n - e +/- c*n**2)
	pop bc
	ld a, [hProduct + 3]
	add b
	ld [hMultiplicand + 2], a
	pop bc
	ld a, [hProduct + 2]
	adc b
	ld [hMultiplicand + 1], a
	pop bc
	ld a, [hProduct + 1]
	adc b
	ld [hMultiplicand], a
	ret

GetSquare:
	push hl
	ld c, a
	ld b, 0
	ld hl, 0
	rst AddNTimes
	ld a, l
	ld [hMultiplicand + 2], a
	ld a, h
	ld [hMultiplicand + 1], a
	xor a
	ld [hMultiplicand], a
	pop hl
	ret

GetCube:
	call GetSquare
	ld a, c
	ld [hMultiplier], a
	predef_jump Multiply

GrowthRates:

growth_rate: MACRO
; [1]/[2]*n**3 + [3]*n**2 + [4]*n - [5]
	dn \1, \2
	if \3 & $80 ; signed
		db -\3 | $80
	else
		db \3
	endc
	db \4, \5
ENDM

	growth_rate 1, 1,   0,   0,   0 ; Medium Fast
	growth_rate 3, 4,  10,   0,  30 ; Slightly Fast
	growth_rate 3, 4,  20,   0,  70 ; Slightly Slow
	growth_rate 6, 5, -15, 100, 140 ; Medium Slow
	growth_rate 4, 5,   0,   0,   0 ; Fast
	growth_rate 5, 4,   0,   0,   0 ; Slow

FluctuatingGrowth:
	ld a, d
	call GetCube
	ld a, d
	cp 16
	jr c, .less_than_16
	cp 37
	jr c, .less_than_37
	; 36-100
	srl a
	add 32
	jr .div_50_multiply

.less_than_37
	add 14
	jr .div_50_multiply

.less_than_16
	inc a
	ld c, 3
	call SimpleDivide
	ld a, b
	add 24
.div_50_multiply
	ld [hMultiplier], a
	predef Multiply
	ld a, 50
	ld [hDivisor], a
	ld b, 4
	predef_jump Divide

ErraticGrowth:
	ld a, d
	call GetCube
	ld a, d
	cp 51
	jr c, .less_than_51
	cp 69
	jr c, .less_than_69
	cp 99
	jr c, .less_than_99
	; 99-100
	ld a, 160
	sub d
	jr .div_100_multiply

.less_than_51
	ld a, 100
	sub d
	ld [hMultiplier], a
	predef Multiply
	ld a, 50
	ld [hDivisor], a
	ld b, 4
	predef_jump Divide

.less_than_69
	ld a, 150
	sub d
.div_100_multiply
	ld [hMultiplier], a
	predef Multiply
	ld a, 100
	ld [hDivisor], a
	ld b, 4
	predef_jump Divide

.less_than_99
	; back up the cube
	ld a, [hProduct + 1]
	push af
	ld a, [hProduct + 2]
	push af
	ld a, [hProduct + 3]
	push af
	; floor((1911 - 10 * n) / 3)
	ld a, d
	ld hl, 0
	ld bc, -10
	rst AddNTimes
	ld de, 1911
	add hl, de
	ld a, l
	ld [hDividend + 1], a
	ld a, h
	ld [hDividend], a
	ld a, 3
	ld [hDivisor], a
	ld b, 2
	predef Divide
	; we now have a 2-byte number to multiply with a 3-byte number
	; we'll do this in two stages
	pop af
	ld e, a
	pop af
	ld d, a
	ld a, [hQuotient + 1]
	ld b, a
	ld a, [hQuotient + 2]
	ld c, a
	push bc
	call Multiply16
	pop bc
	pop af
	ld hl, 0
	rst AddNTimes
	ld a, [hProduct + 1]
	add l
	ld [hProduct + 1], a
	ld a, [hProduct]
	adc h
	ld [hProduct], a
	ld a, 500 / $100
	ld [hDivisor], a
	ld a, 500 % $100
	ld [hDivisor + 1], a
	predef_jump DivideLong
