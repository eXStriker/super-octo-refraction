AcquaRoom_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_NEWMAP, .AcquaRoomWarp
	
.AcquaRoomWarp
	writebyte 2
	farjump AcquaWarpMod

AcquaRoom_Item_1:
	db SHARP_BEAK, 1

AcquaRoom_Item_2:
	db TRADE_STONE, 1

AcquaRoom_Item_3:
	db NUGGET, 1

AcquaRoom_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $3, $25, 2, ACQUA_START
	warp_def $d, $5, 3, ACQUA_MEDTIDE
	warp_def $15, $3, 3, ACQUA_LOWTIDE
	warp_def $21, $3, 255, CAPER_CITY
	warp_def $1f, $1f, 6, ACQUA_ROOM
	warp_def $1f, $7, 5, ACQUA_ROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_POKE_BALL, 10, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, AcquaRoom_Item_1, EVENT_ACQUA_ROOM_ITEM_1
	person_event SPRITE_POKE_BALL, 20, 5, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, AcquaRoom_Item_2, EVENT_ACQUA_ROOM_ITEM_2
	person_event SPRITE_POKE_BALL, 23, 24, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, AcquaRoom_Item_3, EVENT_ACQUA_ROOM_ITEM_3
