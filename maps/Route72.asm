Route72_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route72HiddenItem_1:
	dw EVENT_ROUTE_72_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route72Signpost2:
	ctxt "<UP> Oxalis City"
	next "<DOWN><LEFT>Caper City"
	next "<DOWN><RIGHT> Clathrite"
	next "  Tunnel"
	done ;6

Route72_Trainer_1:
	trainer EVENT_ROUTE_72_TRAINER_1, YOUNGSTER, 1, Route72_Trainer_1_Text_12d2ee, Route72_Trainer_1_Text_12d30f, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route72_Trainer_1_Script_Text_12d31f

Route72_Trainer_2:
	trainer EVENT_ROUTE_72_TRAINER_2, YOUNGSTER, 2, Route72_Trainer_2_Text_12d36c, Route72_Trainer_2_Text_12d38e, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route72_Trainer_2_Script_Text_12d3b0

Route72_Trainer_3:
	trainer EVENT_ROUTE_72_TRAINER_3, PICNICKER, 1, Route72_Trainer_3_Text_12d473, Route72_Trainer_3_Text_12d4a4, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route72_Trainer_3_Script_Text_12d4be

Route72_Trainer_4:
	trainer EVENT_ROUTE_72_TRAINER_4, POKEFANM, 1, Route72_Trainer_4_Text_12d59c, Route72_Trainer_4_Text_12d5e7, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route72_Trainer_4_Script_Text_12d602

Route72_Trainer_1_Text_12d2ee:
	ctxt "Hey there!"

	para "If two Trainers"
	line "meet eye to eye,"
	cont "the battle begins!"
	done

Route72_Trainer_1_Text_12d30f:
	ctxt "What happened?"
	done

Route72_Trainer_1_Script_Text_12d31f:
	ctxt "It's hard work"
	line "being a Trainer!"

	para "You never know"
	line "what your opponent"
	cont "has in store!"
	done

Route72_Trainer_2_Text_12d36c:
	ctxt "Education is the"
	line "key to success."
	done

Route72_Trainer_2_Text_12d38e:
	ctxt "No! I failed!"
	done

Route72_Trainer_2_Script_Text_12d3b0:
	ctxt "Bleh!"

	para "If you were my"
	line "teacher, I'd have"
	cont "gotten an F!"
	done

Route72_Trainer_3_Text_12d473:
	ctxt "Oh, hey there."

	para "Can I interest"
	line "you in a battle?"
	done

Route72_Trainer_3_Text_12d4a4:
	ctxt "Oh well!"

	para "That was fun!"
	done

Route72_Trainer_3_Script_Text_12d4be:
	ctxt "Never become a"
	line "negative nancy!"
	done

Route72_Trainer_4_Text_12d59c:
	ctxt "Who's the biggest"
	line "Pikachu fan?"

	para "Look no further."
	done

Route72_Trainer_4_Text_12d5e7:
	ctxt "My Pikachu<...>"
	done

Route72_Trainer_4_Script_Text_12d602:
	ctxt "I used all my sick"
	line "and vacation days"
	cont "to collect Pikachu"
	cont "merchandise!"
	done

Route72_Item:
	db PARLYZ_HEAL, 2

Route72_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 37, 13, 1, ROUTE_72_GATE
	warp_def 37, 14, 2, ROUTE_72_GATE
	warp_def 7, 11, 7, ROUTE_72_GATE

.CoordEvents: db 0

.BGEvents: db 2
	signpost 11, 18, SIGNPOST_ITEM, Route72HiddenItem_1
	signpost 33, 17, SIGNPOST_LOAD, Route72Signpost2

.ObjectEvents: db 5
	person_event SPRITE_YOUNGSTER, 30, 10, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, Route72_Trainer_1, -1
	person_event SPRITE_YOUNGSTER, 14, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route72_Trainer_2, -1
	person_event SPRITE_PICNICKER, 28, 4, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 1, Route72_Trainer_3, -1
	person_event SPRITE_POKEFAN_M, 19, 4, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route72_Trainer_4, -1
	person_event SPRITE_POKE_BALL, 25, 19, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, Route72_Item, EVENT_ROUTE_72_ITEM
