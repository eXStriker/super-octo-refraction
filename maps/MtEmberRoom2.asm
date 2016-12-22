MtEmberRoom2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MtEmberRoom2_Item_1:
	db HEAT_ROCK, 1

MtEmberRoom2_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $b, $c, 2, MT_EMBER
	warp_def $b, $d, 2, MT_EMBER

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 4, 3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, MtEmberRoom2_Item_1, EVENT_MT_EMBER_ROOM_2_ITEM_1
