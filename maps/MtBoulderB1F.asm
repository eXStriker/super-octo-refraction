MtBoulderB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MtBoulderB1FHiddenItem_1:
	dw EVENT_MT_BOULDER_B1F_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

MtBoulderB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $b, $5, 4, ROUTE_55
	warp_def $6, $8, 3, MT_BOULDER_B2F
	warp_def $4, $19, 1, EAGULOU_CITY
	warp_def $3, $1d, 8, SILK_TUNNEL_B2F
	warp_def $e, $19, 6, RIJON_HIDDEN_BASEMENT
	warp_def $11, $11, 5, RIJON_UNDERGROUND_HORIZONTAL

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 16, 9, SIGNPOST_ITEM, MtBoulderB1FHiddenItem_1

	;people-events
	db 0
