Route54_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route54HiddenItem_1:
	dw EVENT_ROUTE_54_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route54Signpost1:
	ctxt "<UP> Merson Cave"
	next "  Entrance"
	done

Route54_Trainer_1:
	trainer EVENT_ROUTE_54_TRAINER_1, LASS, 3, Route54_Trainer_1_Text_331f6b, Route54_Trainer_1_Text_331f7d, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route54_Trainer_1_Script_Text_331f8b

Route54_Trainer_2:
	trainer EVENT_ROUTE_54_TRAINER_2, SAGE, 5, Route54_Trainer_2_Text_331ed0, Route54_Trainer_2_Text_331eeb, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route54_Trainer_2_Script_Text_331f01

Route54NPC1:
	fruittree 4

Route54_Trainer_1_Text_331f6b:
	ctxt "Cutey cute cute!"
	done

Route54_Trainer_1_Text_331f7d:
	ctxt "Oh well, good"
	line "game!"
	done

Route54_Trainer_1_Script_Text_331f8b:
	ctxt "Always prefer"
	line "cute!"
	done

Route54_Trainer_2_Text_331ed0:
	ctxt "I have found"
	line "inner peace."
	done

Route54_Trainer_2_Text_331eeb:
	ctxt "I remain"
	line "emotionless"
	done

Route54_Trainer_2_Script_Text_331f01:
	ctxt "How you react to"
	line "situations is"
	cont "more important"
	cont "than the"
	cont "situations that"
	cont "approach you."
	done

Route54_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $3, $28, 2, MERSON_CAVE_B1F
	warp_def $1, $2, 7, MERSON_CAVE_B1F
	warp_def $d, $9, 9, MERSON_CAVE_B2F
	warp_def $7, $3, 5, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 9, 45, SIGNPOST_LOAD, Route54Signpost1
	signpost 15, 52, SIGNPOST_ITEM, Route54HiddenItem_1

	;people-events
	db 3
	person_event SPRITE_COOLTRAINER_F, 13, 51, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, Route54_Trainer_1, -1
	person_event SPRITE_SAGE, 6, 42, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route54_Trainer_2, -1
	person_event SPRITE_FRUIT_TREE, 9, 54, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route54NPC1, -1
