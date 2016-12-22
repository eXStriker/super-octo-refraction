Route75_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route75HiddenItem_1:
	dw EVENT_ROUTE_75_HIDDENITEM_SAPPHIRE_EGG
	db SAPPHIRE_EGG

Route75HiddenItem_2:
	dw EVENT_ROUTE_75_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route75_Trainer_1:
	trainer EVENT_ROUTE_75_TRAINER_1, SCHOOLBOY, 2, Route75_Trainer_1_Text_130638, Route75_Trainer_1_Text_130661, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route75_Trainer_1_Script_Text_130681

Route75_Trainer_2:
	trainer EVENT_ROUTE_75_TRAINER_2, LASS, 1, Route75_Trainer_2_Text_1306f0, Route75_Trainer_2_Text_13072e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route75_Trainer_2_Script_Text_130752

Route75_Trainer_3:
	trainer EVENT_ROUTE_75_TRAINER_3, BIRD_KEEPER, 2, Route75_Trainer_3_Text_1305a8, Route75_Trainer_3_Text_1305d6, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route75_Trainer_3_Script_Text_1305f9

Route75_Trainer_4:
	trainer EVENT_ROUTE_75_TRAINER_4, BEAUTY, 2, Route75_Trainer_4_Text_130796, Route75_Trainer_4_Text_1307ca, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route75_Trainer_4_Script_Text_1307eb

Route75_Trainer_5:
	trainer EVENT_ROUTE_75_TRAINER_5, SAILOR, 2, Route75_Trainer_5_Text_13081d, Route75_Trainer_5_Text_130856, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route75_Trainer_5_Script_Text_130872

Route75_Item_1:
	db PP_UP, 1

Route75_Trainer_1_Text_130638:
	ctxt "Let me try some-"
	line "thing I learned"
	cont "at school today."
	done

Route75_Trainer_1_Text_130661:
	ctxt "I didn't study"
	line "enough, I guess."
	done

Route75_Trainer_1_Script_Text_130681:
	ctxt "School keeps me"
	line "way too busy<...>"
	done

Route75_Trainer_2_Text_1306f0:
	ctxt "You look good,"
	line "but<...> not good"
	cont "enough for me!"
	done

Route75_Trainer_2_Text_13072e:
	ctxt "I see. So you can"
	line "battle that way."
	done

Route75_Trainer_2_Script_Text_130752:
	ctxt "I need to get"
	line "some Running"
	cont "Shoes!"
	done

Route75_Trainer_3_Text_1305a8:
	ctxt "#mon strike"
	line "with such grace!"
	done

Route75_Trainer_3_Text_1305d6:
	ctxt "But I like showing"
	line "off<...>"
	done

Route75_Trainer_3_Script_Text_1305f9:
	ctxt "I hope to be as"
	line "good as my idol"
	cont "Falkner one day!"
	done

Route75_Trainer_4_Text_130796:
	ctxt "I have cute"
	line "#mon, look!"
	done

Route75_Trainer_4_Text_1307ca:
	ctxt "Cuteness alone"
	line "can't win?"
	done

Route75_Trainer_4_Script_Text_1307eb:
	ctxt "As long as I have"
	line "my #mon, then"
	cont "I'm happy."
	done

Route75_Trainer_5_Text_13081d:
	ctxt "Oh snap!"

	para "What happened"
	line "to the bridge?"
	done

Route75_Trainer_5_Text_130856:
	ctxt "Your skill is"
	line "world class!"
	done

Route75_Trainer_5_Script_Text_130872:
	ctxt "Which region is"
	line "north again?"
	done

Route75_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $6, $25, 1, LAUREL_GATE
	warp_def $7, $25, 2, LAUREL_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 11, 36, SIGNPOST_ITEM, Route75HiddenItem_1
	signpost 13, 18, SIGNPOST_ITEM, Route75HiddenItem_2

	;people-events
	db 6
	person_event SPRITE_SCHOOLBOY, 10, 9, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 2, Route75_Trainer_1, -1
	person_event SPRITE_LASS, 6, 35, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 2, Route75_Trainer_2, -1
	person_event SPRITE_BIRDKEEPER, 10, 33, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 2, Route75_Trainer_3, -1
	person_event SPRITE_BEAUTY, 10, 18, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 2, Route75_Trainer_4, -1
	person_event SPRITE_SAILOR, 6, 23, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, 0, 2, 1, Route75_Trainer_5, -1
	person_event SPRITE_POKE_BALL, 4, 5, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, Route75_Item_1, EVENT_ROUTE_75_ITEM_1
