MagmaF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaF1NPC1:
	jumpstd strengthboulder

MagmaF1_Item_1:
	db CALCIUM, 1

MagmaF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $21, $19, 3, ROUTE_85
	warp_def $d, $15, 3, MAGMA_ROOMS
	warp_def $12, $20, 9, CAPER_CITY
	warp_def $9, $25, 1, MAGMA_ITEMROOM
	warp_def $12, $20, 4, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_BOULDER, 6, 20, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_PLAYER, 0, 0, MagmaF1NPC1, -1
	person_event SPRITE_POKE_BALL, 6, 3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MagmaF1_Item_1, EVENT_MAGMA_F1_ITEM_1
