Fish:
; Using a fishing rod.
; Fish for monsters with rod e in encounter group d.
; Return monster e at level d.

	push af
	push bc
	push hl

	ld b, e
	dec d
	ld e, d
	ld d, 0

	ld h, d
	ld l, e
	add hl, hl ; x2
	add hl, de ; x3
	add hl, hl ; x6
	add hl, de ; x7
	ld de, FishGroups
	add hl, de
	call .Fish

	pop hl
	pop bc
	pop af
	ret

.Fish
; Fish for monsters with rod b from encounter data in FishGroup at hl.
; Return monster e at level d.

	call Random
	cp [hl]
	jr nc, .no_bite

	; Get encounter data by rod:
	; 0: Old
	; 1: Good
	; 2: Super
	inc hl
	ld e, b
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; Compare the encounter chance to select a Pokemon.
	call Random
.loop
	cp [hl]
	jr z, .ok
	jr c, .ok
	inc hl
	inc hl
	inc hl
	jr .loop
.ok
	inc hl

	; Species 0 reads from a time-based encounter table.
	ld a, [hli]
	ld d, a

	ld e, [hl]
	ret

.no_bite
	ld de, 0
	ret

INCLUDE "data/wild/fish.asm"
