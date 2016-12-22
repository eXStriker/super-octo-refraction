Route82_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route82HiddenItem_1:
	dw EVENT_ROUTE_82_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route82Signpost1:
	ctxt "<LEFT> Torenia City" ;55
	next "<RIGHT> Acania Docks"
	done

Route82_Trainer_1:
	trainer EVENT_ROUTE_82_TRAINER_1, FISHER, 12, Route82_Trainer_1_Text_132688, Route82_Trainer_1_Text_1326a8, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route82_Trainer_1_Script_Text_1326af

Route82_Trainer_2:
	trainer EVENT_ROUTE_82_TRAINER_2, FISHER, 13, Route82_Trainer_2_Text_1339a6, Route82_Trainer_2_Text_1339e0, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route82_Trainer_2_Script_Text_1339eb

Route82_Trainer_3:
	trainer EVENT_ROUTE_82_TRAINER_3, COOLTRAINERF, 5, Route82_Trainer_3_Text_132e86, Route82_Trainer_3_Text_132eb7, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route82_Trainer_3_Script_Text_132ec6

Route82NPC1:
	fruittree 24

Route82_Item_1:
	db POLKADOT_BOW, 1

Route82_Trainer_1_Text_132688:
	ctxt "I'm gonna catch"
	line "me a Relicanth!"
	done

Route82_Trainer_1_Text_1326a8:
	ctxt "Dang!"
	done

Route82_Trainer_1_Script_Text_1326af:
	ctxt "-sigh- It wouldn't"
	line "surprise me at all"
	cont "if the Relicanth"
	cont "were dispersing."

	para "I heard that some"
	line "people are now"
	cont "dumping pollution"
	cont "into the ocean."
	done

Route82_Trainer_2_Text_1339a6:
	ctxt "I think some of"
	line "the rarest fish"
	cont "#mon hide under"
	cont "these very docks."
	done

Route82_Trainer_2_Text_1339e0:
	ctxt "No no no!"
	done

Route82_Trainer_2_Script_Text_1339eb:
	ctxt "I fished while"
	line "riding my #mon"
	cont "until it couldn't"
	cont "take it anymore."

	para "Now I fish on the"
	line "docks instead."
	done

Route82_Trainer_3_Text_132e86:
	ctxt "Hey, you look"
	line "pretty tough!"

	para "Can I see your"
	line "#mon please?"
	done

Route82_Trainer_3_Text_132eb7:
	ctxt "That was fun!"
	done

Route82_Trainer_3_Script_Text_132ec6:
	ctxt "It always makes"
	line "me excited to see"
	cont "other people with"
	cont "strong #mon."

	para "It's not every day"
	line "that I meet people"
	cont "who can put up a"
	cont "good fight."
	done

Route82_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $8, $4, 3, ROUTE_82_GATE
	warp_def $9, $4, 4, ROUTE_82_GATE
	warp_def $3, $1c, 1, ROUTE_82_MONKEY
	warp_def $b, $2a, 1, ROUTE_82_CAVE
	warp_def $9, $30, 2, ROUTE_82_CAVE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 8, 6, SIGNPOST_LOAD, Route82Signpost1
	signpost 4, 34, SIGNPOST_ITEM, Route82HiddenItem_1

	;people-events
	db 5
	person_event SPRITE_FISHER, 12, 17, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, Route82_Trainer_1, -1
	person_event SPRITE_FISHER, 4, 45, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, Route82_Trainer_2, -1
	person_event SPRITE_COOLTRAINER_F, 13, 30, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 1, Route82_Trainer_3, -1
	person_event SPRITE_FRUIT_TREE, 12, 50, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route82NPC1, -1
	person_event SPRITE_POKE_BALL, 4, 50, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 2, Route82_Item_1, EVENT_ROUTE_82_ITEM_1
