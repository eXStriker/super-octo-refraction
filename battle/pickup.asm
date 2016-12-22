CheckPickup::
	ld hl, wPartySpecies
	xor a
	jr .handleLoop

.loop
	pop hl
	ld a, [wCurPartyMon]
	inc a
.handleLoop
	ld [wCurPartyMon], a
	ld a, [hli]
	cp $ff
	ret z
	push hl
	cp EGG
	jr z, .loop
	ld [wCurSpecies], a
	ld a, MON_DVS
	call GetPartyParamLocation
	call CalcMonAbility
	cp ABILITY_PICKUP
	jr nz, .loop
	ld a, MON_ITEM
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr nz, .loop
	push hl
	call Random
	ld b, a
	ld c, 0
	ld hl, .Chances
.get_probability
	ld a, [hli]
	cp b
	jr nc, .got_probability
	inc c
	jr .get_probability

.got_probability
	ld b, 0
	ld a, 10
	ld hl, .Items
	rst AddNTimes
	push hl
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	dec a
	ld c, 10
	call SimpleDivide
	pop hl
	ld c, b
	ld b, 0
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hl], a
	jr .loop

.Chances:
	db 30 percent
	db 40 percent
	db 50 percent
	db 60 percent
	db 70 percent
	db 80 percent
	db 90 percent
	db 94 percent
	db 98 percent
	db 99 percent
	db $ff

.Items:
; Row corresponds to the random value
; Col corresponds to the level bracket
	db POTION, ANTIDOTE, SUPER_POTION, GREAT_BALL, REPEL, ESCAPE_ROPE, FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE ; 30%
	db ANTIDOTE, SUPER_POTION, GREAT_BALL, REPEL, ESCAPE_ROPE, FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY ; 10%
	db SUPER_POTION, GREAT_BALL, REPEL, ESCAPE_ROPE, FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE ; 10%
	db GREAT_BALL, REPEL, ESCAPE_ROPE, FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE, MOON_STONE ; 10%
	db REPEL, ESCAPE_ROPE, FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE, MOON_STONE, HEART_SCALE ; 10%
	db ESCAPE_ROPE, FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE, MOON_STONE, HEART_SCALE, FULL_RESTORE ; 10%
	db FULL_HEAL, HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE, MOON_STONE, HEART_SCALE, FULL_RESTORE, MAX_REVIVE ; 10%
	db HYPER_POTION, ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE, MOON_STONE, HEART_SCALE, FULL_RESTORE, MAX_REVIVE, PP_UP ; 4%
	db ULTRA_BALL, REVIVE, RARE_CANDY, SUN_STONE, MOON_STONE, HEART_SCALE, FULL_RESTORE, MAX_REVIVE, PP_UP, MAX_ELIXIR ; 4%
	db HYPER_POTION, NUGGET, KINGS_ROCK, FULL_RESTORE, ETHER, EVERSTONE, BERSERK_GENE, ELIXIR, BERSERK_GENE, LEFTOVERS ; 1%
	db NUGGET, KINGS_ROCK, FULL_RESTORE, ETHER, EVERSTONE, BERSERK_GENE, ELIXIR, BERSERK_GENE, LEFTOVERS, BERSERK_GENE ; 1%
