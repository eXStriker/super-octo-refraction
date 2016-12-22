Route70_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route70HiddenItem_1:
	dw EVENT_ROUTE_70_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route70Signpost1:
	ctxt "<UP>Heath Village"
	next "<DOWN>Caper City"
	done ;2

Route70Signpost2:
	ctxt "<RIGHT>Route 69"
	done ;3

Route70_Trainer_1:
	trainer EVENT_ROUTE_70_TRAINER_1, BUG_CATCHER, 1, Route70_Trainer_1_Text_12975e, Route70_Trainer_1_Text_129789, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route70_Trainer_1_Script_Text_1297a2

Route70NPC1:
	jumptextfaceplayer Route70NPC1_Text_1297f0

Route70_Item_1:
	db ANTIDOTE, 1

Route70_Item_2:
	db REPEL, 2

Route70NPC2:
	jumptextfaceplayer Route70NPC2_Text_12984a

Route70NPC1_Text_1297f0:
	ctxt "Man, this snow"
	line "is really deep!"

	para "If you walk and"
	line "hold the B button," 

	para "you might be able"
	line "to actually run"
	cont "faster through it!"

	done

Route70NPC2_Text_12984a:
	ctxt "See that tunnel"
	line "to the right here?"

	para "It leads to Rijon!"

	para "You gotta have a"
	line "Rijon Pass to get"
	cont "past the guard,"

	para "or so I've heard."
	done

Route70_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 6, 13, 1, ROUTE_69_GATE
	warp_def 11, 13, 1, LONG_TUNNEL_PATH
	warp_def 7, 13, 1, ROUTE_69_GATE

.CoordEvents: db 0

.BGEvents: db 3
	signpost 39, 8, SIGNPOST_LOAD, Route70Signpost1
	signpost 7, 10, SIGNPOST_LOAD, Route70Signpost2
	signpost 29, 7, SIGNPOST_ITEM, Route70HiddenItem_1

.ObjectEvents: db 4
	person_event SPRITE_YOUNGSTER, 38, 6, SPRITEMOVEDATA_SPINRANDOM_SLOW, 2, 2, -1, -1, PAL_OW_GREEN, 0, 0, Route70NPC1, -1
	person_event SPRITE_POKE_BALL, 11, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, Route70_Item_1, EVENT_ROUTE_70_ITEM_1
	person_event SPRITE_POKE_BALL, 31, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, Route70_Item_2, EVENT_ROUTE_70_ITEM_2
	person_event SPRITE_FISHER, 15, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route70NPC2, -1

