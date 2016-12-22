CanLearnTMHMMove:
	ld a, [wCurPartySpecies]
	dec a
	ld hl, TMHMLearnsets
	lb bc, 0, 13
	rst AddNTimes

	ld a, BANK(TMHMLearnsets)
	lb bc, 0, 13
	ld de, CurBaseData
	call FarCopyBytes

	ld hl, CurBaseData
	push hl

	ld a, [wPutativeTMHMMove]
	ld b, a
	ld c, 0
	ld hl, TMHMMoves
.loop
	ld a, [hli]
	and a
	jr z, .end
	cp b
	jr z, .asm_11659
	inc c
	jr .loop

.asm_11659
	pop hl
	ld b, CHECK_FLAG
	predef_jump FlagAction

.end
	pop hl
	ld c, 0
	ret

GetTMHMMove::
	ld a, [wCurTMHM]
	and $7f
	dec a
	ld hl, TMHMMoves
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	ret

INCLUDE "data/tmmoves.asm"
