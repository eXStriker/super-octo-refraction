SpawnPoints:

spawn: MACRO
; map, X, Y
	map \1
	db \2, \3
ENDM
	spawn INTRO_OUTSIDE,                  8,  3
	spawn CAPER_CITY,                    17, 10
	spawn OXALIS_CITY,                   37, 14
	spawn SPURGE_CITY,                   33, 24
	spawn HEATH_VILLAGE,                 17, 10
	spawn LAUREL_CITY,                   23, 28
	spawn TORENIA_CITY,                  13, 12
	spawn PHACELIA_TOWN,                 15, 10
	spawn ACANIA_DOCKS,                   7, 16
	spawn SAXIFRAGE_ISLAND,              25, 12
	spawn PHLOX_TOWN,                    13, 18
	spawn ROUTE_86,                      10, 10
	spawn SEASHORE_CITY,                 23, 26
	spawn GRAVEL_TOWN,                   12, 12
	spawn MERSON_CITY,                   15, 34
	spawn HAYWARD_CITY,                  27, 24
	spawn OWSAURI_CITY,                  33, 24
	spawn MORAGA_TOWN,                   39,  8
	spawn JAERU_CITY,                    15, 28
	spawn BOTAN_CITY,                     6, 26
	spawn CASTRO_VALLEY,                 21, 16
	spawn EAGULOU_CITY,                  15, 12 
	spawn RIJON_LEAGUE_OUTSIDE,          10,  6
	spawn ROUTE_67,                      43,  8
	spawn AZALEA_TOWN,                   15, 10
	spawn GOLDENROD_CITY,                15, 24
	spawn SAFFRON_CITY,                  15, 38
	spawn SOUTHERLY_CITY,                20, 16
	spawn BATTLE_TOWER_ENTRANCE,          3,  5
	spawn SPURGE_GYM_1F,                  4,  4
	spawn ACQUA_START,                   28, 35 ;After getting in the minecart
	spawn ACQUA_TUTORIAL,                30, 42 ;If you faint while Larvitar
	spawn LAUREL_FOREST_POKEMON_ONLY,     4, 56 ;Faint in Pokemon only area
	spawn ROUTE_77,                       5, 70 ;Pokecenter
	spawn ROUTE_81,                       6, 48 ;Pokecenter
	spawn PRISON_F1,                     20,  5 ;Faint in Prison
	spawn MYSTERY_ZONE,					 17,  8 
	spawn N_A,                           -1, -1

LoadSpawnPoint:
	; loads the spawn point in wd001
	push hl
	push de
	ld a, [wd001]
	cp SPAWN_N_A
	jr z, .spawn_n_a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, SpawnPoints
	add hl, de
	ld a, [hli]
	ld [MapGroup], a
	ld a, [hli]
	ld [MapNumber], a
	ld a, [hli]
	ld [XCoord], a
	ld a, [hli]
	ld [YCoord], a
.spawn_n_a
	pop de
	pop hl
	ret

IsSpawnPoint:
; Checks if the map loaded in de is a spawn point.  Returns carry if it's a spawn point.
	ld hl, SpawnPoints
	ld c, 0
.loop
	ld a, [hl]
	cp SPAWN_N_A
	jr z, .nope
	cp d
	jr nz, .next
	inc hl
	ld a, [hld]
	cp e
	jr z, .yes

.next
	inc c
	ld a, 4
	add l
	ld l, a
	jr nc, .loop
	inc h
	jr .loop

.nope
	and a
	ret

.yes
	scf
	ret
