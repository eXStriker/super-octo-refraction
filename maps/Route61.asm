Route61_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route61Signpost1:
	signpostheader 0
	text_jump Route62Signpost1

Route61_Trainer_1:
	trainer EVENT_ROUTE_61_TRAINER_1, FISHER, 8, Route61_Trainer_1_Text_33095b, Route61_Trainer_1_Text_33097c, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route61_Trainer_1_Script_Text_33098f

Route61_Item_1:
	db CAGE_KEY, 1

Route61_Trainer_2:
	trainer EVENT_ROUTE_61_TRAINER_2, FISHER, 9, Route61_Trainer_2_Text_330327, Route61_Trainer_2_Text_330342, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route61_Trainer_2_Script_Text_330362

Route61_Trainer_3:
	trainer EVENT_ROUTE_61_TRAINER_3, FISHER, 10, Route61_Trainer_3_Text_330f2d, Route61_Trainer_3_Text_330f45, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route61_Trainer_3_Script_Text_330f6a

Route61_Trainer_1_Text_33095b:
	ctxt "This is my secret"
	line "fishing spot."
	done

Route61_Trainer_1_Text_33097c:
	ctxt "Don't tell anyone!"
	done

Route61_Trainer_1_Script_Text_33098f:
	ctxt "The fish are"
	line "always biting"
	cont "here."
	done

Route61_Trainer_2_Text_330327:
	ctxt "I have a rod that's"
	line "super."
	done

Route61_Trainer_2_Text_330342:
	ctxt "That's how I"
	line "caught these"
	cont "#mon!"
	done

Route61_Trainer_2_Script_Text_330362:
	ctxt "Maybe I should let"
	line "them dangle around"

	para "the hook a bit"
	line "before I decide"

	para "that they should"
	line "go to town with"
	cont "me."
	done

Route61_Trainer_3_Text_330f2d:
	ctxt "Hook, line and"
	line "sinker!"
	done

Route61_Trainer_3_Text_330f45:
	ctxt "What, that idiom"
	line "doesn't apply"
	cont "here?"
	done

Route61_Trainer_3_Script_Text_330f6a:
	ctxt "It'd be a good"
	line "idea to sleep"
	cont "with the fishes."

	para "Still wrong?"
	done

Route61_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 33, 13, 1, ROUTE_61_HOUSE2
	warp_def 31, 6, 2, ROUTE_61_GATE_SOUTH
	warp_def 65, 8, 1, ROUTE_61_GATE_NORTH
	warp_def 29, 13, 1, ROUTE_61_HOUSE
	warp_def 65, 9, 1, ROUTE_61_GATE_NORTH

.CoordEvents: db 0

.BGEvents: db 1
	signpost 55, 11, SIGNPOST_LOAD, Route61Signpost1

.ObjectEvents: db 4
	person_event SPRITE_FISHER, 97, 6, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 8, Route61_Trainer_1, -1
	person_event SPRITE_POKE_BALL, 103, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, Route61_Item_1, EVENT_ROUTE_61_ITEM_1
	person_event SPRITE_FISHER, 49, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 0, Route61_Trainer_2, -1
	person_event SPRITE_FISHER, 37, 7, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 0, Route61_Trainer_3, -1

