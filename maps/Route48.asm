Route48_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_NEWMAP, Route48OnBike

Route48OnBike:
	setflag ENGINE_ALWAYS_ON_BIKE
	setflag ENGINE_DOWNHILL
	return

Route48HiddenItem_1:
	dw EVENT_ROUTE_48_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route48Signpost1:
	ctxt "Johto - Rijon"
	next "border"
	done

Route48Signpost2:
	ctxt "<UP> Ilex Forest"
	line "<DOWN> Route 49"
	done

Route48Signpost3:
	ctxt "Going uphill!"
	done

Route48NPC1:
	fruittree 12

Route48_Trainer_1:
	trainer EVENT_ROUTE_48_TRAINER_1, BIKER, 3, Route48_Trainer_1_Text_2f10ed, Route48_Trainer_1_Text_2f10fa, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route48_Trainer_1_Script_Text_2f1103

Route48_Trainer_2:
	trainer EVENT_ROUTE_48_TRAINER_2, BIKER, 5, Route48_Trainer_2_Text_2f1206, Route48_Trainer_2_Text_2f1222, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route48_Trainer_2_Script_Text_2f1231

Route48_Trainer_3:
	trainer EVENT_ROUTE_48_TRAINER_3, BIKER, 4, Route48_Trainer_3_Text_2f116b, Route48_Trainer_3_Text_2f1197, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route48_Trainer_3_Script_Text_2f11ac

Route48_Trainer_4:
	trainer EVENT_ROUTE_48_TRAINER_4, BIKER, 6, Route48_Trainer_4_Text_2f125e, Route48_Trainer_4_Text_2f127e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route48_Trainer_4_Script_Text_2f1295

Route48_Trainer_5:
	trainer EVENT_ROUTE_48_TRAINER_5, BIKER, 2, Route48_Trainer_5_Text_2f1081, Route48_Trainer_5_Text_2f10a4, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route48_Trainer_5_Script_Text_2f10c1

Route48_Trainer_1_Text_2f10ed:
	ctxt "Conformist!"
	done

Route48_Trainer_1_Text_2f10fa:
	ctxt "Aaargy."
	done

Route48_Trainer_1_Script_Text_2f1103:
	ctxt "Why should the"
	line "media control"
	cont "you?"

	para "Listen to what I"
	line "have to say, not"
	cont "to what they say."
	done

Route48_Trainer_2_Text_2f1206:
	ctxt "Biking on docks,"
	line "safe huh?"
	done

Route48_Trainer_2_Text_2f1222:
	ctxt "You're a wimp!"
	done

Route48_Trainer_2_Script_Text_2f1231:
	ctxt "Too scared to"
	line "bike, huh?"
	done

Route48_Trainer_3_Text_2f116b:
	ctxt "I'm going to make"
	line "some donuts on"
	cont "this dock!"
	done

Route48_Trainer_3_Text_2f1197:
	ctxt "That burned me"
	line "out."
	done

Route48_Trainer_3_Script_Text_2f11ac:
	ctxt "One time my bike"
	line "rolled into the"
	cont "bay."

	para "Needless to say,"
	line "I was furious!"
	done

Route48_Trainer_4_Text_2f125e:
	ctxt "I'm not allowed"
	line "the Johto gate."
	done

Route48_Trainer_4_Text_2f127e:
	ctxt "It's 'cause I'm"
	line "hostile!"
	done

Route48_Trainer_4_Script_Text_2f1295:
	ctxt "Azalea Town's"
	line "boring people can't"

	para "appreciate my wild"
	line "lifestyle."
	done

Route48_Trainer_5_Text_2f1081:
	ctxt "I don't like you,"
	line "but lets battle."
	done

Route48_Trainer_5_Text_2f10a4:
	ctxt "Now I really don't"
	line "like you."
	done

Route48_Trainer_5_Script_Text_2f10c1:
	ctxt "I still don't"
	line "like you!"
	done

Route48_MapEventHeader:: db 0, 0

.Warps: db 0

.CoordEvents: db 0

.BGEvents: db 4
	signpost 51, 9, SIGNPOST_LOAD, Route48Signpost1
	signpost 87, 9, SIGNPOST_LOAD, Route48Signpost2
	signpost 141, 11, SIGNPOST_LOAD, Route48Signpost3
	signpost 25, 10, SIGNPOST_ITEM, Route48HiddenItem_1

.ObjectEvents: db 6
	person_event SPRITE_FRUIT_TREE, 98, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route48NPC1, -1
	person_event SPRITE_BIKER, 91, 4, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, Route48_Trainer_1, -1
	person_event SPRITE_BIKER, 39, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route48_Trainer_2, -1
	person_event SPRITE_BIKER, 63, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route48_Trainer_3, -1
	person_event SPRITE_BIKER, 19, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 2, 0, Route48_Trainer_4, -1
	person_event SPRITE_BIKER, 119, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route48_Trainer_5, -1
