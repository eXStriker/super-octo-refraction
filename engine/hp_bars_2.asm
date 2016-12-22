ComputeHPBarPixels: ; c699
; bc * (6 * 8 * 2) / de
	ld a, b
	or c
	jr z, .zero
	push hl
	xor a
	ld [hMultiplicand + 0], a
	ld a, b
	ld [hMultiplicand + 1], a
	ld a, c
	ld [hMultiplicand + 2], a
	ld a, 6 * 8 * 2
	ld [hMultiplier], a
	predef Multiply
	; we have 16-bit divide now so we can do this
	ld a, d
	ld [hDivisor], a
	ld a, e
	ld [hDivisor + 1], a
	predef DivideLong
	ld a, [hLongQuotient + 3]
	ld e, a
	pop hl
	and a
	ret nz
	ld e, 1
	ret

.zero
	ld e, 0
	ret

AnimateHPBar: ; c6e0
	call ApplyTilemapInVBlank
	call _AnimateHPBar
	jp ApplyTilemapInVBlank
