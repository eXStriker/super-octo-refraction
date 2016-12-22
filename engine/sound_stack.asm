_PushSoundstate::
	ld a, [rSVBK]
	push af
	ld a, BANK(wSoundStackSize)
	ld [rSVBK], a

	ld hl, wSoundStackSize
	ld a, [hl]
	cp SOUND_STACK_CAPACITY
	jr nc, .full

	inc [hl]
	dec hl
	ld bc, wMusic - wMapMusic
	rst AddNTimes

	ld bc, wMapMusic - wMusic
	ld de, wMusic
	inc b
	inc c
	jr .handleLoop

.loop
	ld a, [de]
	ld [hld], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop

	and a
	jr .done

.full
	scf
.done
	pop bc
	ld a, b
	ld [rSVBK], a
	ret

_PopSoundstate::
	ld a, [rSVBK]
	push af
	ld a, BANK(wSoundStackSize)
	ld [rSVBK], a

	ld hl, wSoundStackSize
	ld a, [hl]
	and a
	jr z, .nothing_to_pop

	dec a
	ld [hld], a
	ld bc, wMusic - wMapMusic
	rst AddNTimes

	ld bc, wMapMusic - wMusic
	ld de, wMusic
	inc b
	inc c
	jr .handleLoop

.loop
	ld a, [hld]
	ld [de], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop

	and a
	jr .done

.nothing_to_pop
	scf
.done
	pop bc
	ld a, b
	ld [rSVBK], a
	ret
