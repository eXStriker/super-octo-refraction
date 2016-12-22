MersonCaveB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonCaveB2FHiddenItem_1:
	dw EVENT_MERSON_CAVE_B2F_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

MersonCaveB2F_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $11, $9, 1, MERSON_CAVE_B3F
	warp_def $3, $1, 5, CAPER_CITY
	warp_def $9, $19, 2, SEASHORE_CITY
	warp_def $e, $18, 5, MERSON_CAVE_B1F
	warp_def $4, $1, 5, CAPER_CITY
	warp_def $18, $c, 3, MERSON_CAVE_B1F
	warp_def $3, $19, 1, GRAVEL_TOWN

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 12, 20, SIGNPOST_ITEM, MersonCaveB2FHiddenItem_1

	;people-events
	db 0
