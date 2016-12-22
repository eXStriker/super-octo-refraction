CastroValley_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, CastroValley_SetFlyFlag

CastroValley_SetFlyFlag:
	setflag ENGINE_FLYPOINT_CASTRO_VALLEY
	return

CastroValleyHiddenItem_1:
	dw EVENT_CASTRO_VALLEY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

CastroValleySignpost1:
	ctxt "The courtly"
	next "little port town"
	done

CastroValleySignpost2:
	jumpstd pokecentersign

CastroValleySignpost3:
	ctxt "Castro Forest"
	next "Entrance"
	done

CastroValleySignpost4:
	ctxt "#mon Gym"
	next "Leader: Koji"
	nl ""
	next "The tough and"
	next "brute Trainer!"
	done


CastroValleySignpost5:
	jumpstd martsign

CastroValleySignpost6:
	ctxt "Under"
	next "construction"
	done

CastroValleyNPC1:
	jumptextfaceplayer CastroValleyNPC1_Text_330d8d

CastroValleyNPC2:
	jumptextfaceplayer CastroValleyNPC2_Text_3306a3

CastroValleyNPC3:
	jumptextfaceplayer CastroValleyNPC3_Text_330113

CastroValleyNPC4:
	jumptextfaceplayer CastroValleyNPC4_Text_3306d3

CastroValleyNPC5:
	jumptextfaceplayer CastroValleyNPC5_Text_33067e

CastroValleyNPC1_Text_330d8d:
	ctxt "I caught a"
	line "Relicanth that"

	para "had a fossil"
	line "attached to it!"

	para "What luck!"
	done

CastroValleyNPC2_Text_3306a3:
	ctxt "There's a couple"
	line "of sages in the"
	cont "Castro Forest."

	para "I wonder what they"
	line "are doing?"
	done

CastroValleyNPC3_Text_330113:
	ctxt "Koji loves his"
	line "martial arts!"

	para "He's amazing!"
	done

CastroValleyNPC4_Text_3306d3:
	ctxt "I heard they're"
	line "converting the"

	para "mansion into an"
	line "apartment complex."

	para "I hope the rent's"
	line "cheap."
	done

CastroValleyNPC5_Text_33067e:
	ctxt "This isn't much"
	line "of a valley."
	done

CastroValley_MapEventHeader ;filler
	db 0, 0

;warps
	db 9
	warp_def $1b, $16, 1, CASTRO_GYM
	warp_def $1b, $1c, 1, CASTRO_MANSION
	warp_def $5, $1d, 1, CASTRO_MART
	warp_def $1d, $4, 2, CASTRO_GATE
	warp_def $f, $15, 1, CASTRO_POKECENTER
	warp_def $1f, $12, 4, CASTRO_DOCK_PATH
	warp_def $1f, $13, 5, CASTRO_DOCK_PATH
	warp_def $f, $b, 1, CASTRO_SUPER_ROD
	warp_def $9, $7, 1, CASTRO_TYROGUE_TRADE

	;xy triggers
	db 0

	;signposts
	db 7
	signpost 7, 21, SIGNPOST_LOAD, CastroValleySignpost1
	signpost 15, 22, SIGNPOST_READ, CastroValleySignpost2
	signpost 31, 5, SIGNPOST_LOAD, CastroValleySignpost3
	signpost 29, 23, SIGNPOST_LOAD, CastroValleySignpost4
	signpost 5, 30, SIGNPOST_READ, CastroValleySignpost5
	signpost 29, 31, SIGNPOST_LOAD, CastroValleySignpost6
	signpost 17, 26, SIGNPOST_ITEM, CastroValleyHiddenItem_1

	;people-events
	db 5
	person_event SPRITE_FISHING_GURU, 19, 23, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroValleyNPC1, -1
	person_event SPRITE_SAGE, 28, 8, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroValleyNPC2, -1
	person_event SPRITE_YOUNGSTER, 8, 20, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroValleyNPC3, -1
	person_event SPRITE_POKEFAN_F, 16, 15, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroValleyNPC4, -1
	person_event SPRITE_ROCKER, 6, 8, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroValleyNPC5, -1
