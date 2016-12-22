CastroDockPath_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroDockPath_Item_1:
	db NUGGET, 1

CastroDockPath_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $2, $5, 3, CASTRO_DOCK_PATH
	warp_def $2a, $5, 1, CASTRO_DOCK
	warp_def $37, $5, 1, CASTRO_DOCK_PATH
	warp_def $32, $4, 6, CASTRO_VALLEY
	warp_def $32, $5, 7, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_ROCKET, -4, -3, $44, 0, 0, -1, -1, PAL_OW_RED, 6, 76, ObjectEvent, -1
	person_event SPRITE_MONSTER, -3, -4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 1, 68, CastroDockPath_Item_1, EVENT_CASTRO_DOCK_PATH_ITEM_1
	person_event SPRITE_NONE, -4, 4, $3a, 0, 0, -1, -1, PAL_OW_RED, 9, 58, ObjectEvent, -1
