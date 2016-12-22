LaurelForestGates_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelForestGatesHiddenItem_1:
	dw EVENT_LAUREL_FOREST_GATES_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

LaurelForestGates_MapEventHeader ;filler
	db 0, 0

;warps
	db 10
	warp_def $0, $5, 4, LAUREL_FOREST_MAIN
	warp_def $7, $4, 3, TORENIA_CITY
	warp_def $7, $5, 3, TORENIA_CITY
	warp_def $e, $4, 1, LAUREL_FOREST_MAIN
	warp_def $e, $5, 2, LAUREL_FOREST_MAIN
	warp_def $15, $4, 1, ROUTE_76
	warp_def $15, $5, 1, ROUTE_76
	warp_def $7, $13, 7, LAUREL_FOREST_MAIN
	warp_def $0, $4, 3, LAUREL_FOREST_MAIN
	warp_def $7, $14, 7, LAUREL_FOREST_MAIN

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 3, 22, SIGNPOST_ITEM, LaurelForestGatesHiddenItem_1

	;people-events
	db 2
	person_event SPRITE_P0, 17, 16, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, -1
	person_event SPRITE_P0, 16, 19, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, -1
