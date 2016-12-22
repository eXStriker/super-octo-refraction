Route83_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route83HiddenItem_1:
	dw EVENT_ROUTE_83_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route83Signpost3:
	ctxt "<LEFT>Mound Cave"
	next "<RIGHT>Torenia City"
	next "<LEFT><DOWN>Route 73"
	done ;34

Route83_Trainer_1:
	trainer EVENT_ROUTE_83_TRAINER_1, SCHOOLBOY, 3, Route83_Trainer_1_Text_12e62a, Route83_Trainer_1_Text_12e65a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route83_Trainer_1_Script_Text_12e674

Route83_Item_1:
	db POISON_BARB, 1

Route83NPC1:
	jumptextfaceplayer Route83NPC1_Text_12e4f0

Route83_Item_2:
	db REPEL, 2

Route83_Trainer_1_Text_12e62a:
	ctxt "Round 1: FIGHT!"
	done

Route83_Trainer_1_Text_12e65a:
	ctxt "FATALITY!"
	done

Route83_Trainer_1_Script_Text_12e674:
	ctxt "I like video games"
	line "more than school."

	para "Hehe."
	done

Route83NPC1_Text_12e4f0:
	ctxt "Hello!"

	para "Sorry, I just HAVE"
	line "to tie my shoes on"
	cont "this very spot<...>"
	done

Route83_MapEventHeader:: db 0, 0

.Warps: db 4
	warp_def 9, 8, 1, MOUND_UPPERAREA
	warp_def 9, 12, 6, CAPER_CITY
	warp_def 4, 50, 1, CAPER_CITY
	warp_def 4, 50, 2, CAPER_CITY

.CoordEvents: db 0

.BGEvents: db 2
	signpost 5, 32, SIGNPOST_ITEM, Route83HiddenItem_1
	signpost 9, 55, SIGNPOST_LOAD, Route83Signpost3

.ObjectEvents: db 4
	person_event SPRITE_SCHOOLBOY, 7, 43, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 5, Route83_Trainer_1, -1
	person_event SPRITE_POKE_BALL, 5, 34, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, Route83_Item_1, EVENT_ROUTE_83_ITEM_1
	person_event SPRITE_SCHOOLBOY, 10, 27, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route83NPC1, EVENT_LAUREL_FOREST_MAIN_TRAINER_2
	person_event SPRITE_POKE_BALL, 9, 24, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, Route83_Item_2, EVENT_ROUTE_83_ITEM_2
