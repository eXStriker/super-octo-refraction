Route63_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route63HiddenItem_1:
	dw EVENT_ROUTE_63_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route63Signpost1:
	ctxt "<LEFT> Hayward City"
	next "<RIGHT> Silk Tunnel"
	done

Route63_Item_1:
	db SMOKE_BALL, 1

Route63_Trainer_1:
	trainer EVENT_ROUTE_63_TRAINER_1, BUG_CATCHER, 10, Route63_Trainer_1_Text_333375, Route63_Trainer_1_Text_33339b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route63_Trainer_1_Script_Text_3333ba

Route63_Trainer_2:
	trainer EVENT_ROUTE_63_TRAINER_2, LASS, 6, Route63_Trainer_2_Text_33340c, Route63_Trainer_2_Text_33343b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route63_Trainer_2_Script_Text_333445

Route63NPC1:
	fruittree 6

Route63_Trainer_1_Text_333375:
	ctxt "Time for my swarm"
	line "of bugs to attack!"
	done

Route63_Trainer_1_Text_33339b:
	ctxt "You didn't even"
	line "use bug spray!"
	done

Route63_Trainer_1_Script_Text_3333ba:
	ctxt "Bugs are super"
	line "effective"

	para "against psychic"
	line "and dark."

	para "Cool huh?"
	done

Route63_Trainer_2_Text_33340c:
	ctxt "I know why that"
	line "tunnel is called"
	cont "Silk Tunnel!"
	done

Route63_Trainer_2_Text_33343b:
	ctxt "Curious?"
	done

Route63_Trainer_2_Script_Text_333445:
	ctxt "That tunnel is"
	line "called Silk Tunnel"

	para "because it used to"
	line "be the biggest"

	para "source of wild"
	line "Caterpie."

	para "They all held silk"
	line "that people used"
	cont "to make clothes."

	para "Enjoyed your"
	line "history lesson?"
	done

Route63_MapEventHeader:: db 0, 0

.Warps: db 1
	warp_def 7, 54, 1, SILK_TUNNEL_1F

.CoordEvents: db 0

.BGEvents: db 2
	signpost 7, 3, SIGNPOST_LOAD, Route63Signpost1
	signpost 11, 24, SIGNPOST_ITEM, Route63HiddenItem_1

.ObjectEvents: db 4
	person_event SPRITE_POKE_BALL, 10, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, Route63_Item_1, EVENT_ROUTE_63_ITEM_1
	person_event SPRITE_YOUNGSTER, 2, 23, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, Route63_Trainer_1, -1
	person_event SPRITE_LASS, 6, 40, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route63_Trainer_2, -1
	person_event SPRITE_FRUIT_TREE, 7, 47, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, Route63NPC1, -1

