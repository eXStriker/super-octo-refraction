Route50_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route50HiddenItem_1:
	dw EVENT_ROUTE_50_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route50Signpost1:
	ctxt "<LEFT> Route 50"
	next "<RIGHT><UP> Route 49"
	done

Route50_Trainer_1:
	trainer EVENT_ROUTE_50_TRAINER_1, BUG_CATCHER, 6, Route50_Trainer_1_Text_3325ad, Route50_Trainer_1_Text_3325ce, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route50_Trainer_1_Script_Text_3325ee

Route50_Trainer_2:
	trainer EVENT_ROUTE_50_TRAINER_2, BURGLAR, 1, Route50_Trainer_2_Text_332c69, Route50_Trainer_2_Text_332c7d, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route50_Trainer_2_Script_Text_332ca5

Route50_Trainer_3:
	trainer EVENT_ROUTE_50_TRAINER_3, SUPER_NERD, 5, Route50_Trainer_3_Text_332c14, Route50_Trainer_3_Text_332c1b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route50_Trainer_3_Script_Text_332c32

Route50NPC2:
	fruittree 3

Route50_Trainer_1_Text_3325ad:
	ctxt "Neat little place"
	line "to hide, huh?"
	done

Route50_Trainer_1_Text_3325ce:
	ctxt "Less hiding and"
	line "more training."
	done

Route50_Trainer_1_Script_Text_3325ee:
	ctxt "Just sitting and"
	line "waiting for"
	cont "another Trainer."
	done

Route50_Trainer_2_Text_332c69:
	ctxt "I came from"
	line "Johto!"
	done

Route50_Trainer_2_Text_332c7d:
	ctxt "Where are you"
	line "from?"

	para "Never heard of"
	line "it."
	done

Route50_Trainer_2_Script_Text_332ca5:
	ctxt "You can get to"
	line "Azalea Town if"

	para "you keep going"
	line "north!"
	done

Route50_Trainer_3_Text_332c14:
	ctxt "Wait!"
	done

Route50_Trainer_3_Text_332c1b:
	ctxt "Thanks for your"
	line "time."
	done

Route50_Trainer_3_Script_Text_332c32:
	ctxt "I don't need your"
	line "help right now."
	done

Route50_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $5, $30, 3, ROUTE_50_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 5, 43, SIGNPOST_LOAD, Route50Signpost1
	signpost 7, 21, SIGNPOST_ITEM, Route50HiddenItem_1

	;people-events
	db 5
	person_event SPRITE_BUG_CATCHER, 2, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route50_Trainer_1, -1
	person_event SPRITE_PHARMACIST, 6, 41, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route50_Trainer_2, -1
	person_event SPRITE_GYM_GUY, 5, 24, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 2, 5, Route50_Trainer_3, -1
	person_event SPRITE_POKE_BALL, 11, 28, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 3, TM_STEEL_WING, 0, EVENT_ROUTE_50_NPC_1
	person_event SPRITE_FRUIT_TREE, 2, 38, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, Route50NPC2, -1
