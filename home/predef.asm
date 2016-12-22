_Predef::
; Call predefined function on the stack.
; Preserves bc, de, hl.
	ld a, h
	ld [hPredefTemp+1], a
	ld a, l
	ld [hPredefTemp], a
	pop hl
	ld a, [hli]
	ld [hBuffer], a
	add a
	jr c, .predefJump
	push hl
.predefJump
	ld a, [hROMBank]
	push af
	ld a, BANK(PredefPointers)
	rst Bankswitch
	push de
	ld a, [hBuffer]
	and $7f
	ld e, a
	ld d, 0
	ld hl, PredefPointers
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, d
	pop de
	and a
	jr nz, .bankswitch
	pop af
	rst Bankswitch
	push af
	jr .restoredOriginalBank
.bankswitch
	rst Bankswitch
.restoredOriginalBank
	call RetrieveHLAndCallFunction
	jr ReturnFarCall
