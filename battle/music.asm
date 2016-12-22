PlayBattleMusic:
	push hl
	push de
	push bc

	xor a
	ld [MusicFade], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	call MaxVolume

	ld a, [wBattleType]
	cp BATTLETYPE_SUICUNE
	ld de, MUSIC_SUICUNE_BATTLE
	jp z, .done
	cp BATTLETYPE_ROAMING
	jp z, .done

	; Are we fighting a trainer?
	ld a, [OtherTrainerClass]
	and a
	jr nz, .trainermusic

	ld a, [TempEnemyMonSpecies]
	ld hl, .legendaries
	call .loadfromarray
	jr c, .done

	ld hl, .wilds
	call .getregionmusicfromarray
	jr .done

.trainermusic
	ld hl, .trainers
	call .loadfromarray
	jr c, .done

	ld de, MUSIC_KANTO_GYM_LEADER_BATTLE
	callba IsKantoGymLeader
	jr c, .done

	ld de, MUSIC_KANTO_GYM_LEADER_BATTLE
	callba IsRijonGymLeader
	jr c, .done

	ld de, MUSIC_NALJO_GYM_LEADER_BATTLE
	callba IsNaljoGymLeader
	jr c, .done

	ld de, MUSIC_JOHTO_GYM_LEADER_BATTLE
	callba IsJohtoGymLeader
	jr c, .done

.othertrainer
	ld a, [wLinkMode]
	and a
	ld de, MUSIC_JOHTO_TRAINER_BATTLE
	jr nz, .done

	ld hl, .normal_trainers
	call .getregionmusicfromarray

.done
	call PlayMusic

	pop bc
	pop de
	pop hl
	ret

.loadfromarray
	ld e, 3
	call IsInArray
	ret nc
	inc hl
	jr .found

.getregionmusicfromarray
	push hl
	callba RegionCheck
	pop hl
	ld d, 0
	add hl, de
	add hl, de
.found
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret

.legendaries
	dbw ARTICUNO, MUSIC_KANTO_LEGENDARY
	dbw ZAPDOS,   MUSIC_KANTO_LEGENDARY
	dbw MOLTRES,  MUSIC_KANTO_LEGENDARY
	dbw MEWTWO,   MUSIC_KANTO_LEGENDARY
	dbw MEW,      MUSIC_KANTO_LEGENDARY
	dbw PHANCERO, MUSIC_KANTO_LEGENDARY
	dbw HO_OH,    MUSIC_HOOH_BATTLE
	dbw LUGIA,    MUSIC_LUGIA_BATTLE
	dbw KYOGRE,   MUSIC_HOENN_LEGENDARY
	dbw GROUDON,  MUSIC_HOENN_LEGENDARY
	dbw RAYQUAZA, MUSIC_HOENN_LEGENDARY
	db $ff

.wilds
	dw MUSIC_NALJO_WILD_BATTLE
	dw MUSIC_KANTO_WILD_BATTLE
	dw MUSIC_JOHTO_WILD_BATTLE
	dw MUSIC_KANTO_WILD_BATTLE
	dw MUSIC_KANTO_WILD_BATTLE
	dw MUSIC_HOENN_WILD_BATTLE
	dw MUSIC_NALJO_WILD_BATTLE

.trainers
	; I'll uncomment it once I done it
	;dbw RED,            MUSIC_FINAL_BATTLE
	;dbw GOLD,           MUSIC_FINAL_BATTLE
	;dbw BROWN,          MUSIC_FINAL_BATTLE
	dbw RED,            MUSIC_CHAMPION_BATTLE
	dbw GOLD,           MUSIC_CHAMPION_BATTLE
	dbw BROWN,          MUSIC_CHAMPION_BATTLE
	dbw CHAMPION,       MUSIC_CHAMPION_BATTLE
	dbw PATROLLER,      MUSIC_PALLET_BATTLE
	dbw GRUNTM,         MUSIC_ROCKET_BATTLE
	dbw ARCADEPC_GROUP, MUSIC_BATTLE_ARCADE_BATTLE
	dbw ERNEST,         MUSIC_HOENN_GYM_BATTLE
	dbw RIVAL1,         MUSIC_RIVAL_BATTLE
	db $ff

.normal_trainers
	dw MUSIC_JOHTO_TRAINER_BATTLE ; MUSIC_NALJO_TRAINER_BATTLE
	dw MUSIC_KANTO_TRAINER_BATTLE
	dw MUSIC_JOHTO_TRAINER_BATTLE
	dw MUSIC_KANTO_TRAINER_BATTLE
	dw MUSIC_KANTO_TRAINER_BATTLE
	dw MUSIC_HOENN_TRAINER_BATTLE
	dw MUSIC_JOHTO_TRAINER_BATTLE
