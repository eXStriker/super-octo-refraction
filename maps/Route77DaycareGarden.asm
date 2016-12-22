Route77DaycareGarden_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 2
	dbw MAPCALLBACK_OBJECTS, .OverridePalettes
	dbw MAPCALLBACK_NEWMAP, .CheckEgg

.OverridePalettes:
	callasm .DoPaletteOverride
	return

.DoPaletteOverride:
	ld hl, wBreedMon1DVs
	ld de, Map1Object + MAPOBJECT_COLOR
	ld a, [wBreedMon1Species]
	call .OverridePalette
	ld hl, wBreedMon2DVs
	ld de, Map2Object + MAPOBJECT_COLOR
	ld a, [wBreedMon2Species]
.OverridePalette:
	ld [wCurPartySpecies], a
	push de
	callba GetPalette
	pop de
	swap l
	ret z ; default to red (already loaded) if we're using the orange palette (reserved for player)
	ld a, l
	ld [de], a ; lazy
	ret

.CheckEgg
	checkflag ENGINE_DAYCARE_MAN_HAS_EGG
	iffalse .HideEgg
	clearevent EVENT_DAYCARE_EGG
	jump .CheckMon1
.HideEgg:
	setevent EVENT_DAYCARE_EGG

.CheckMon1:
	checkflag ENGINE_DAYCARE_MAN_HAS_MON
	iffalse .HideMon1
	clearevent EVENT_DAYCARE_MON_1
	jump .CheckMon2
.HideMon1:
	setevent EVENT_DAYCARE_MON_1

.CheckMon2:
	checkflag ENGINE_DAYCARE_LADY_HAS_MON
	iffalse .HideMon2
	clearevent EVENT_DAYCARE_MON_2
	return
.HideMon2:
	setevent EVENT_DAYCARE_MON_2
	return

Route77DaycareGardenNPC3:
	opentext
	faceplayer
	special Special_DayCareMon1
	closetext
	end

Route77DaycareGardenNPC6:
	opentext
	faceplayer
	special Special_DayCareMon2
	closetext
	end

Route77DaycareGarden_12d0cc:
	end

Route77DaycareGardenEgg:
	opentext
	special Special_DayCareManOutside
	waitbutton
	closetext
	if_equal $1, .end_fail
	clearflag ENGINE_DAYCARE_MAN_HAS_EGG
	disappear 4
.end_fail
	end

Route77DaycareGarden_MapEventHeader:: db 0, 0

.Warps: db 4
	warp_def 47, 11, 1, CAPER_CITY
	warp_def 47, 12, 2, CAPER_CITY
	warp_def 14, 17, 1, ROUTE_77_DAYCARE_HOUSE
	warp_def 15, 17, 2, ROUTE_77_DAYCARE_HOUSE

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 3
	person_event SPRITE_DAYCARE_MON_1, 17, 1, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route77DaycareGardenNPC3, EVENT_DAYCARE_MON_1
	person_event SPRITE_DAYCARE_MON_2, 9, 13, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route77DaycareGardenNPC6, EVENT_DAYCARE_MON_2
	person_event SPRITE_EGG, 18, 10, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, Route77DaycareGardenEgg, EVENT_DAYCARE_EGG

