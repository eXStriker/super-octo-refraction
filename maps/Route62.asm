Route62_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route62HiddenItem_1:
	dw EVENT_ROUTE_62_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route62Signpost1:
	ctxt "The path to many"
	next "cities!"
	done

Route62_Trainer_1:
	trainer EVENT_ROUTE_62_TRAINER_1, GENTLEMAN, 3, Route62_Trainer_1_Text_33085b, Route62_Trainer_1_Text_330874, $0000, .Script

.Script:
	jumptext Route62_Trainer_1_Script_Text_3308b8

Route62NPC1:
	jumptextfaceplayer Route62NPC1_Text_330008

Route62_Trainer_2:
	trainer EVENT_ROUTE_62_TRAINER_2, BLACKBELT_T, 11, Route62_Trainer_2_Text_3307b1, Route62_Trainer_2_Text_3307e2, $0000, .Script

.Script:
	jumptext Route62_Trainer_2_Script_Text_330817

Route62_Trainer_3:
	trainer EVENT_ROUTE_62_TRAINER_3, SAGE, 6, Route62_Trainer_3_Text_330de3, Route62_Trainer_3_Text_330e1d, $0000, .Script

.Script:
	jumptext Route62_Trainer_3_Script_Text_330e3c

Route62_Trainer_1_Text_33085b:
	ctxt "I'm late for my"
	line "meeting!"
	done

Route62_Trainer_1_Text_330874:
	ctxt "I guess they have"
	line "a good reason for"

	para "blocking off the"
	line "Eagulou path."
	done

Route62_Trainer_1_Script_Text_3308b8:
	ctxt "I must respect"
	line "their beliefs."

	para "Another way to get"
	line "to Eagulou is an"

	para "underground path"
	line "connecting to"
	cont "Moraga."

	para "I hope that's not"
	line "blocked off"
	cont "either!"
	done

Route62NPC1_Text_330008:
	ctxt "I wasn't normal"
	line "enough for Joe's"

	para "Gym, so he kicked"
	line "me to the curb."
	done

Route62_Trainer_2_Text_3307b1:
	ctxt "It appears fists"
	line "alone won't get"
	cont "me to Joe's Gym."
	done

Route62_Trainer_2_Text_3307e2:
	ctxt "If the path was"
	line "open, this team"

	para "would own that"
	line "Gym!"
	done

Route62_Trainer_2_Script_Text_330817:
	ctxt "They seemed wise,"
	line "they must have a"
	cont "good reason."
	done

Route62_Trainer_3_Text_330de3:
	ctxt "Ah, so you've"
	line "met my friends?"
	done

Route62_Trainer_3_Text_330e1d:
	ctxt "Unfriendly."
	done

Route62_Trainer_3_Script_Text_330e3c:
	ctxt "I have to stick"
	line "with my friends."
	
	para "They're all scared"
	line "of Varaneous."
	done

Route62_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $5, $2d, 1, ROUTE_62_GATE
	warp_def $9, $35, 5, CAPER_CITY
	warp_def $8, $3a, 5, CAPER_CITY
	warp_def $9, $3a, 5, CAPER_CITY
	warp_def $5, $c, 2, ROUTE_61_GATE_NORTH

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 5, 27, SIGNPOST_LOAD, Route62Signpost1
	signpost 14, 36, SIGNPOST_ITEM, Route62HiddenItem_1

	;people-events
	db 4
	person_event SPRITE_GENTLEMAN, 11, 16, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route62_Trainer_1, -1
	person_event SPRITE_P0, 0, 0, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route62NPC1, -1
	person_event SPRITE_BLACK_BELT, 10, 31, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_BROWN, 2, 3, Route62_Trainer_2, -1
	person_event SPRITE_SAGE, 6, 41, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route62_Trainer_3, -1
