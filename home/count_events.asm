CountOwnedMonsFromList::
	; counts how many mons from a certain list (in de) the player owns. Returns in e.
	lb bc, CHECK_FLAG, 0
	ld hl, PokedexCaught
.loop
	ld a, [de]
	inc de
	cp -1
	jr z, .done
	dec a
	push bc
	ld c, a
	call FlagAction
	pop bc
	jr z, .loop
	inc c
	jr .loop
.done
	ld e, c
	ret

CountEventFlagsFromList::
	; counts how many event flags from a certain list (in hl) are set. Returns in de.
	ld de, 0
.loop
	push de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	and e
	inc a
	jr z, .done
	ld b, CHECK_FLAG
	push hl
	predef EventFlagAction
	pop hl
	pop de
	jr z, .loop
	inc de
	jr .loop
.done
	pop de
	ret
