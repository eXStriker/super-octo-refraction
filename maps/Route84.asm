Route84_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route84HiddenItem_1:
	dw EVENT_ROUTE_84_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route84Signpost2:
	ctxt "<LEFT> Phlox Town"
	next "<RIGHT> Clathrite"
	done ;44

Route84_Trainer_1:
	trainer EVENT_ROUTE_84_TRAINER_1, COOLTRAINERM, 11, Route84_Trainer_1_Text_1376a4, Route84_Trainer_1_Text_1376cf, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route84_Trainer_1_Script_Text_1376e4

Route84_Trainer_2:
	trainer EVENT_ROUTE_84_TRAINER_2, SKIER, 4, Route84_Trainer_2_Text_137608, Route84_Trainer_2_Text_137649, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route84_Trainer_2_Script_Text_137653

Route84_Trainer_3:
	trainer EVENT_ROUTE_84_TRAINER_3, SKIER, 5, Route84_Trainer_3_Text_137541, Route84_Trainer_3_Text_13756a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route84_Trainer_3_Script_Text_137584

Route84_Trainer_4:
	trainer EVENT_ROUTE_84_TRAINER_4, HIKER, 13, Route84_Trainer_4_Text_137716, Route84_Trainer_4_Text_13775d, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route84_Trainer_4_Script_Text_137767

Route84NPC2:
	fruittree 23

Route84_Trainer_1_Text_1376a4:
	ctxt "You've just been"
	line "fully ambushed!"

	para "Roll for"
	line "initiative!"
	done

Route84_Trainer_1_Text_1376cf:
	ctxt "Awww, you're no"
	line "fun<...> Boring."
	done

Route84_Trainer_1_Script_Text_1376e4:
	ctxt "Not even a little"
	line "bit surprised?"
	done

Route84_Trainer_2_Text_137608:
	ctxt "That's a very fun"
	line "obstacle course"
	cont "for skilled skiers"
	cont "such as myself!"
	done

Route84_Trainer_2_Text_137649:
	ctxt "Dang it."
	done

Route84_Trainer_2_Script_Text_137653:
	ctxt "Sometimes I like"
	line "to ski on the snow"
	cont "with my #mon!"

	para "Fun, huh?"
	done

Route84_Trainer_3_Text_137541:
	ctxt "This region has"
	line "some really weird"
	cont "geography<...>"
	done

Route84_Trainer_3_Text_13756a:
	ctxt "Not that I'm"
	line "complaining!"
	done

Route84_Trainer_3_Script_Text_137584:
	ctxt "This region's odd"
	line "geography is said"
	cont "to come from old"
	cont "legendary #mon."

	para "They made this"
	line "the perfect place"
	cont "for some skating!"
	done

Route84_Trainer_4_Text_137716:
	ctxt "That tunnel wasn't"
	line "much trouble."

	para "Just need to keep"
	line "proper track of"
	cont "where you're going!"
	done

Route84_Trainer_4_Text_13775d:
	ctxt "Hold it."
	done

Route84_Trainer_4_Script_Text_137767:
	ctxt "I don't even need"
	line "a compass, hahaha!"
	done

Route84_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 7, 63, 5, CLATHRITE_1F
	warp_def 5, 7, 1, PHLOX_ENTRY

.CoordEvents: db 0

.BGEvents: db 2
	signpost 5, 42, SIGNPOST_ITEM, Route84HiddenItem_1
	signpost 9, 24, SIGNPOST_LOAD, Route84Signpost2

.ObjectEvents: db 6
	person_event SPRITE_COOLTRAINER_M, 8, 25, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route84_Trainer_1, -1
	person_event SPRITE_BUENA, 11, 35, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route84_Trainer_2, -1
	person_event SPRITE_BUENA, 10, 18, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route84_Trainer_3, -1
	person_event SPRITE_HIKER, 7, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8, 2, 4, Route84_Trainer_4, -1
	person_event SPRITE_FRUIT_TREE, 17, 29, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route84NPC2, -1
	person_event SPRITE_POKE_BALL, 14, 51, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_STEEL_EATER, 0, EVENT_ROUTE_84_NPC_3
