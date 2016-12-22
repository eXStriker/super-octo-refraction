AzaleaTown_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw MAPCALLBACK_NEWMAP, AzaleaTown_SetFlyFlag

AzaleaTown_SetFlyFlag:
	setflag ENGINE_FLYPOINT_AZALEA_TOWN
	return

AzaleaTownSignpost1:
	ctxt "Kurt's House"
	done

AzaleaTownSignpost2:
	ctxt "#mon Gym"
	next "Leader: Bugsy"
	nl   ""
	next "The walking Bug"
	next "#mon Encyclo-"
	next "pedia"
	done

AzaleaTownSignpost3:
	ctxt "Where People and"
	next "#mon Live in"
	next "Happy Harmony"
	done

AzaleaTownSignpost4:
	ctxt "Charcoal Kiln"
	done

AzaleaTownSignpost5:
	ctxt "<RIGHT> Route 33"
	next "  Closed due to"
	next "  landslide."
	done

AzaleaTownSignpost6:
	jumpstd pokecentersign

AzaleaTownSignpost7:
	jumpstd martsign

AzaleaTownSignpost8:
	ctxt "<LEFT> Ilex Forest"
	done

AzaleaTownNPC1:
	fruittree 13

AzaleaTownNPC2:
	jumptextfaceplayer AzaleaTownNPC2_Text_3236d2

AzaleaTownNPC3:
	jumptextfaceplayer AzaleaTownNPC3_Text_32370e

AzaleaTownNPC4:
	jumptextfaceplayer AzaleaTownNPC4_Text_3237a4

AzaleaTownNPC2_Text_3236d2:
	ctxt "The Slowpoke are"
	line "goofing off"
	cont "somewhere."

	para "But where?"
	done

AzaleaTownNPC3_Text_32370e:
	ctxt "There was a quake"
	line "close to here a"

	para "couple of years"
	line "ago."

	para "Our town got a"
	line "bit ruffled, but"

	para "Goldenrod wasn't"
	line "so lucky."

	para "Thankfully no one"
	line "was hurt."
	done

AzaleaTownNPC4_Text_3237a4:
	ctxt "Ilex Forest has a"
	line "shrine that wards"

	para "off evil spirits"
	line "and is a symbol"
	cont "of good luck."
	done

AzaleaTown_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $a, $4, 3, ILEX_FOREST_GATE
	warp_def $b, $4, 4, ILEX_FOREST_GATE
	warp_def $5, $9, 1, AZALEA_KURT
	warp_def $f, $a, 1, AZALEA_GYM
	warp_def $9, $f, 1, AZALEA_POKECENTER
	warp_def $5, $15, 1, AZALEA_MART
	warp_def $d, $15, 1, AZALEA_CHARCOAL

	;xy triggers
	db 0

	;signposts
	db 8
	signpost 9, 10, SIGNPOST_LOAD, AzaleaTownSignpost1
	signpost 15, 14, SIGNPOST_LOAD, AzaleaTownSignpost2
	signpost 9, 19, SIGNPOST_LOAD, AzaleaTownSignpost3
	signpost 13, 19, SIGNPOST_LOAD, AzaleaTownSignpost4
	signpost 7, 29, SIGNPOST_LOAD, AzaleaTownSignpost5
	signpost 9, 16, SIGNPOST_READ, AzaleaTownSignpost6
	signpost 5, 22, SIGNPOST_READ, AzaleaTownSignpost7
	signpost 9, 5, SIGNPOST_LOAD, AzaleaTownSignpost8

	;people-events
	db 4
	person_event SPRITE_FRUIT_TREE, 2, 8, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, AzaleaTownNPC1, -1
	person_event SPRITE_GRAMPS, 9, 23, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, AzaleaTownNPC2, -1
	person_event SPRITE_TEACHER, 12, 16, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, 0, 0, AzaleaTownNPC3, -1
	person_event SPRITE_YOUNGSTER, 16, 7, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, AzaleaTownNPC4, -1
