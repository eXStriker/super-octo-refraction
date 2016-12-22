MtEmberEntrance_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MtEmberEntrance_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $2, $2, 3, EMBER_BROOK
	warp_def $f, $11, 1, MT_EMBER_ROOM_1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
