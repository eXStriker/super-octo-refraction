Random::
	; just like the stock RNG, this exits with the value in [hRandomSub]
	push hl
	push bc
	push de
	call UpdateDividerCounters
	call CycleRNGState ; exits with hl = wRNGState + 3
	ld a, [rDIV]
	add a, [hl]
	ld [hRandomAdd], a
	ld a, [hli]
	inc hl
	inc hl
	sub [hl]
	ld [hRandomSub], a
	pop de
	pop bc
	pop hl
	ret

CycleRNGState::
	ld hl, wRNGState
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, e
	sla a
	xor b
	ld b, a
	ld a, d
	rla
	ld l, c
	rl l
	ld h, b
	rl h
	sbc a
	and 1
	xor c
	ld c, a
	ld a, h
	xor d
	ld d, a
	ld a, l
	xor e
	ld e, a
	ld h, b
	ld l, c
	push hl
	ld h, d
	ld a, e
	rept 2
		sla e
		rl d
		rl c
		rl b
	endr
	xor e
	ld e, a
	ld a, h
	xor d
	ld d, a
	pop hl
	ld a, l
	xor c
	ld c, a
	ld a, h
	xor b
	ld hl, wRNGState
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

UpdateDividerCounters:
	ld a, [rDIV]
	ld hl, wRNGCumulativeDividerMinus
	sbc [hl]
	ld [hld], a
	ld a, [rDIV]
	adc [hl]
	ld [hld], a
	ret nc
	inc [hl]
	ret

AdvanceRNGState:
	ld hl, wRNGState
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
	ld a, [rDIV]
	rra
	jr nc, .try_upper
.try_lower
	ld a, h
	cp d
	jr nz, .lower
	ld a, l
	cp e
	jr nz, .lower
.upper
	xor c
	ld c, a
	ld a, h
	xor b
	ld b, a
	jr .done
.try_upper
	ld a, h
	cp b
	jr nz, .upper
	ld a, l
	cp c
	jr nz, .upper
.lower
	ld a, h
	xor d
	ld d, a
	ld a, l
	xor e
	ld e, a
.done
	ld hl, wRNGState
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	ret

BattleRandom::
; _BattleRandom lives in another bank.

; It handles all RNG calls in the battle engine, allowing
; link battles to remain in sync using a shared PRNG.

	ld a, [wLinkMode]
	and a
	jp z, Random
	jpba _BattleRandom

RandomRange::
; Return a random number between 0 and a (non-inclusive).

	push bc
	ld c, a

	; b = $100 % c
	xor a
	sub c
.mod
	sub c
	jr nc, .mod
	add c
	ld b, a

	; Get a random number
	; from 0 to $ff - b.
	push bc
.loop
	call Random
	ld a, [hRandomAdd]
	ld c, a
	add b
	jr c, .loop
	ld a, c
	pop bc

	call SimpleDivide

	pop bc
	ret
