Route59_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route59HiddenItem_1:
	dw EVENT_ROUTE_59_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route59Signpost1:
	ctxt "<UP> Silph Warehouse"
	next "<UP><RIGHT> Botan City"
	next "<LEFT> Jaeru City"
	done

Route59_Trainer_1:
	trainer EVENT_ROUTE_59_TRAINER_1, JUGGLER, 2, Route59_Trainer_1_Text_33392b, Route59_Trainer_1_Text_333951, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route59_Trainer_1_Script_Text_333997

Route59_Trainer_2:
	trainer EVENT_ROUTE_59_TRAINER_2, FIREBREATHER, 4, Route59_Trainer_2_Text_333851, Route59_Trainer_2_Text_3338a2, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route59_Trainer_2_Script_Text_3338f1

Route59_Trainer_1_Text_33392b:
	ctxt "Botan City isn't"
	line "quarantined"
	cont "anymore!"
	done

Route59_Trainer_1_Text_333951:
	ctxt "Too bad they don't"
	line "have a #mon"
	cont "Center,"

	para "because I could"
	line "use one about now."
	done

Route59_Trainer_1_Script_Text_333997:
	ctxt "Now that the"
	line "tension in Botan"

	para "city has calmed"
	line "down, everyone"

	para "is free to enter"
	line "and exit at will."
	done

Route59_Trainer_2_Text_333851:
	ctxt "The middle of this"
	line "grass field is the"

	para "best place to"
	line "practice my fire"
	cont "breathing!"
	done

Route59_Trainer_2_Text_3338a2:
	ctxt "Calm down, you"
	line "beat me."

	para "It's not like"
	line "you're the champ"
	cont "or something."

	para "Oh wait."
	done

Route59_Trainer_2_Script_Text_3338f1:
	ctxt "Time to pack up"
	line "on more corn"
	cont "starch."
	done

Route59_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 3, 54, 1, SILPH_WAREHOUSE_F1
	warp_def 5, 63, 2, ROUTE_59_GATE

.CoordEvents: db 0

.BGEvents: db 2
	signpost 7, 55, SIGNPOST_LOAD, Route59Signpost1
	signpost 12, 17, SIGNPOST_ITEM, Route59HiddenItem_1

.ObjectEvents: db 3
	person_event SPRITE_POKE_BALL, 11, 23, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_SWORDS_DANCE, 0, EVENT_ROUTE_59_NPC_1
	person_event SPRITE_JUGGLER, 10, 48, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route59_Trainer_1, -1
	person_event SPRITE_FIREBREATHER, 4, 17, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, Route59_Trainer_2, -1

