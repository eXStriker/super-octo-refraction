GetBreedMon1LevelGrowth: ; e698
	ld de, wBreedMon1Level
	ld hl, wBreedMon1Stats
	jr GetBreedMonLevelGrowth

GetBreedMon2LevelGrowth: ; e6b3
	ld de, wBreedMon2Level
	ld hl, wBreedMon2Stats
GetBreedMonLevelGrowth:
	push de
	ld de, TempMon
	ld bc, BOXMON_STRUCT_LENGTH
	rst CopyBytes
	callba CalcLevel
	pop hl
	ld b, [hl]
	ld a, d
	ld e, a
	sub b
	ld d, a
	ret
