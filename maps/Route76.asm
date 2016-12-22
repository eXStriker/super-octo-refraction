Route76_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route76HiddenItem_1:
	dw EVENT_ROUTE_76_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route76Signpost1:
	ctxt "<UP> Laurel City"
	next "<RIGHT> Laurel Forest"
	next "<RIGHT><DOWN>Torenia City"
	done ;26

Route76NPC1:
	jumptextfaceplayer Route76NPC1_Text_133a42

Route76_Trainer_1:
	trainer EVENT_ROUTE_76_TRAINER_1, TWINS, 2, Route76_Trainer_1_Text_13010f, Route76_Trainer_1_Text_130138, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route76_Trainer_1_Script_Text_130151

Route76_Trainer_2:
	trainer EVENT_ROUTE_76_TRAINER_2, PSYCHIC_T, 1, Route76_Trainer_2_Text_130180, Route76_Trainer_2_Text_1301ca, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route76_Trainer_2_Script_Text_1301e5

Route76_Item_1:
	db GREAT_BALL, 2

Route76NPC1_Text_133a42:
	ctxt "Liz: We loved"
	line "playing with"
	cont "our Shinx."

	para "I hope he's OK."
	done

Route76_Trainer_1_Text_13010f:
	ctxt "Where is our"
	line "Shinx?!"
	done

Route76_Trainer_1_Text_130138:
	ctxt "Liz & Lily: You're"
	line "mean!"
	done

Route76_Trainer_1_Script_Text_130151:
	ctxt "Lily: -sniffs-"

	para "Please find it<...>"
	done

Route76_Trainer_2_Text_130180:
	ctxt "I'm looking for"
	line "my lost #mon."
	done

Route76_Trainer_2_Text_1301ca:
	ctxt "That's sad too<...>"
	done

Route76_Trainer_2_Script_Text_1301e5:
	ctxt "I don't know why"
	line "the #mon in"
	cont "this town keep"
	cont "vanishing<...>"
	done

Route76_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $b, $e, 6, LAUREL_FOREST_GATES

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 11, 11, SIGNPOST_LOAD, Route76Signpost1
	signpost 11, 16, SIGNPOST_ITEM, Route76HiddenItem_1

	;people-events
	db 4
	person_event SPRITE_TWIN, 12, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 1, Route76NPC1, -1
	person_event SPRITE_TWIN, 12, 12, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route76_Trainer_1, -1
	person_event SPRITE_PSYCHIC, 6, 7, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 4, Route76_Trainer_2, -1
	person_event SPRITE_POKE_BALL, 3, 13, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, Route76_Item_1, EVENT_ROUTE_76_ITEM_1
