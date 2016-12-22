Route66_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route66HiddenItem_1:
	dw EVENT_ROUTE_66_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route66Signpost1:
	ctxt "<UP> Owsauri City"
	done

Route66_Trainer_1:
	trainer EVENT_ROUTE_66_TRAINER_1, SWIMMERF, 5, Route66_Trainer_1_Text_333297, Route66_Trainer_1_Text_3332b2, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route66_Trainer_1_Script_Text_3332d6
	endtext

Route66_Trainer_2:
	trainer EVENT_ROUTE_66_TRAINER_2, SWIMMERM, 5, Route66_Trainer_2_Text_3331dd, Route66_Trainer_2_Text_33320e, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route66_Trainer_2_Script_Text_333245
	endtext

Route66_Trainer_3:
	trainer EVENT_ROUTE_66_TRAINER_3, SWIMMERM, 6, Route66_Trainer_3_Text_333119, Route66_Trainer_3_Text_333146, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route66_Trainer_3_Script_Text_333178
	endtext

Route66_Trainer_1_Text_333297:
	ctxt "Look at me, I'm"
	line "Ye Shiwen!"
	done

Route66_Trainer_1_Text_3332b2:
	ctxt "What, you don't"
	line "watch the"
	cont "olympics?"
	done

Route66_Trainer_1_Script_Text_3332d6:
	ctxt "They need to have"
	line "a #mon"
	cont "battling olympic"
	cont "event."

	para "Just a"
	line "suggestion!"
	done

Route66_Trainer_2_Text_3331dd:
	ctxt "This lake is a"
	line "great place to"
	cont "practice my"
	cont "laps."
	done

Route66_Trainer_2_Text_33320e:
	ctxt "Too bad most"
	line "people don't"
	cont "like #mon"
	cont "training on"
	cont "water."
	done

Route66_Trainer_2_Script_Text_333245:
	ctxt "Maybe once day"
	line "you can swim for"
	cont "yourself,"
	cont "instead of"
	cont "riding."
	done

Route66_Trainer_3_Text_333119:
	ctxt "I'm a swimmer, I"
	line "must use water"
	cont "#mon, right?"
	done

Route66_Trainer_3_Text_333146:
	ctxt "Hahaha, psych!"

	para "What, you saw"
	line "through my"
	cont "sarcasm?"
	done

Route66_Trainer_3_Script_Text_333178:
	ctxt "Trainers enjoy"
	line "having the same"
	cont "types as their"
	cont "interests."

	para "Makes sense of"
	line "course."
	done

Route66_MapEventHeader:: db 0, 0

.Warps: db 0

.CoordEvents: db 0

.BGEvents: db 2
	signpost 9, 11, SIGNPOST_LOAD, Route66Signpost1
	signpost 11, 18, SIGNPOST_ITEM, Route66HiddenItem_1

.ObjectEvents: db 4
	person_event SPRITE_POKE_BALL, 31, 13, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_BOIL, 0, EVENT_ROUTE_66_NPC_1
	person_event SPRITE_SWIMMER_GIRL, 21, 7, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route66_Trainer_1, -1
	person_event SPRITE_SWIMMER_GUY, 18, 14, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route66_Trainer_2, -1
	person_event SPRITE_SWIMMER_GUY, 30, 3, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route66_Trainer_3, -1

