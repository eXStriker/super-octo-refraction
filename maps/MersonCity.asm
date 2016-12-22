MersonCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, MersonCity_SetFlyFlag

MersonCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_MERSON_CITY
	return

MersonCityHiddenItem_1:
	dw EVENT_MERSON_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

MersonCitySignpost1:
	ctxt "#mon Gym"
	next "Leader: Karpman"
	;nl ""
	;next "Please insert"
	;next "description."
	done

MersonCitySignpost2:
	ctxt "The little rocky"
	next "crevice"
	done

MersonCitySignpost3:
	jumpstd martsign

MersonCitySignpost4:
	jumpstd pokecentersign

MersonCityNPC1:
	jumptextfaceplayer MersonCityNPC1_Text_332007

MersonCityNPC2:
	jumptextfaceplayer MersonCityNPC2_Text_33203f

MersonCityNPC3:
	jumptextfaceplayer MersonCityNPC3_Text_33208c

MersonCityNPC1_Text_332007:
	ctxt "Karpman's been"
	line "getting stronger"
	cont "over the years."
	done

MersonCityNPC2_Text_33203f:
	ctxt "I planted a tree"
	line "in front of the"
	cont "#mon Center."

	para "I'm sure nobody"
	line "will mind."
	done

MersonCityNPC3_Text_33208c:
	ctxt "This town will be"
	line "known as the"

	para "gateway to South"
	line "Rijon once the"

	para "south path is"
	line "cleared."
	done

MersonCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $21, $f, 1, MERSON_POKECENTER
	warp_def $1d, $b, 1, MERSON_GOLD_TOKEN_EXCHANGE
	warp_def $5, $2, 1, MERSON_GYM
	warp_def $d, $f, 1, MERSON_MART
	warp_def $19, $5, 1, MERSON_BIRD_HOUSE
	warp_def $11, $d, 1, MERSON_HOUSE2

	;xy triggers
	db 0

	;signposts
	db 5
	signpost 7, 1, SIGNPOST_LOAD, MersonCitySignpost1
	signpost 7, 11, SIGNPOST_LOAD, MersonCitySignpost2
	signpost 13, 16, SIGNPOST_READ, MersonCitySignpost3
	signpost 33, 16, SIGNPOST_READ, MersonCitySignpost4
	signpost 35, 16, SIGNPOST_ITEM, MersonCityHiddenItem_1

	;people-events
	db 3
	person_event SPRITE_BLACK_BELT, 9, 12, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonCityNPC1, -1
	person_event SPRITE_FISHING_GURU, 30, 4, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonCityNPC2, -1
	person_event SPRITE_LASS, 21, 7, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonCityNPC3, -1
