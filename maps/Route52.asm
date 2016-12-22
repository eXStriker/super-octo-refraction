Route52_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route52HiddenItem_1:
	dw EVENT_ROUTE_52_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route52Signpost1:
	ctxt "<RIGHT> Hayward Docks"
	done

Route52_Item_1:
	db FIRE_RING, 1

Route52_Trainer_1:
	trainer EVENT_ROUTE_52_TRAINER_1, FISHER, 7, Route52_Trainer_1_Text_3323b1, Route52_Trainer_1_Text_3323cb, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route52_Trainer_1_Script_Text_3323e3

Route52NPC1:
	jumpstd smashrock

Route52NPC2:
	fruittree 1

Route52_Trainer_1_Text_3323b1:
	ctxt "Check out my epic"
	line "catch!"
	done

Route52_Trainer_1_Text_3323cb:
	ctxt "Guess I can do"
	line "better."
	done

Route52_Trainer_1_Script_Text_3323e3:
	ctxt "I'm fishing to"
	line "see what I can"
	cont "get next."
	done

Route52_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $3f, $c, 5, CAPER_CITY
	warp_def $2b, $3, 2, ROUTE_52_GATE_UNDERGROUND
	warp_def $13, $f, 1, ROUTE_52_HOUSE
	warp_def $1, $8, 2, ROUTE_52_GATE
	warp_def $5, $8, 2, ROUTE_52_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 47, 5, SIGNPOST_LOAD, Route52Signpost1
	signpost 61, 4, SIGNPOST_ITEM, Route52HiddenItem_1

	;people-events
	db 4
	person_event SPRITE_POKE_BALL, 64, 13, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 27, Route52_Item_1, EVENT_ROUTE_52_ITEM_1
	person_event SPRITE_FISHING_GURU, 31, 12, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 2, 1, Route52_Trainer_1, -1
	person_event SPRITE_ROCK, 64, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route52NPC1, -1
	person_event SPRITE_FRUIT_TREE, 17, 14, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route52NPC2, -1
