SeashoreCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, SeashoreCity_SetFlyFlag

SeashoreCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_SEASHORE_CITY
	return

SeashoreCitySignpost1:
	ctxt "Where waves of"
	next "new journeys"
	next "begin their long"
	next "travels."
	done

SeashoreCitySignpost2:
	ctxt "#mon Gym"
	next "Leader: Sheryl"
	nl ""
	;next "Please add"
	;next "description."
	done

SeashoreCityNPC1:
	jumptextfaceplayer SeashoreCityNPC1_Text_331aa9

SeashoreCityNPC2:
	jumptextfaceplayer SeashoreCityNPC2_Text_331b96

SeashoreCityNPC3:
	jumptextfaceplayer SeashoreCityNPC3_Text_331bba

SeashoreCity_Item_1:
	db DIVE_BALL, 2

SeashoreCityNPC1_Text_331aa9:
	ctxt "Did you know that"
	line "the legendary"

	para "Trainer known as"
	line "Brown once lived"
	cont "here?"

	para "I met him when he"
	line "first started"
	cont "training."
	done

SeashoreCityNPC2_Text_331b96:
	ctxt "It's important to"
	line "stay put!"
	done

SeashoreCityNPC3_Text_331bba:
	ctxt "Set positive"
	line "goals, then"

	para "achieve them,"
	line "even if only you"

	para "will appreciate"
	line "it."
	done

SeashoreCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $19, $17, 1, BROWNS_HOUSE_F1
	warp_def $3, $20, 3, MERSON_CAVE_B2F
	warp_def $3, $22, 4, MERSON_CAVE_B1F
	warp_def $f, $19, 1, SEASHORE_MURA
	warp_def $d, $20, 1, SEASHORE_GYM

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 29, 21, SIGNPOST_LOAD, SeashoreCitySignpost1
	signpost 15, 33, SIGNPOST_LOAD, SeashoreCitySignpost2

	;people-events
	db 4
	person_event SPRITE_YOUNGSTER, 23, 29, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SeashoreCityNPC1, -1
	person_event SPRITE_DAISY, 18, 26, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SeashoreCityNPC2, -1
	person_event SPRITE_YOUNGSTER, 20, 13, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SeashoreCityNPC3, -1
	person_event SPRITE_POKE_BALL, 6, 5, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, SeashoreCity_Item_1, EVENT_SEASHORE_CITY_ITEM_1
