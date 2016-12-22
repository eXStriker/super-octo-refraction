EmberBrook_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EmberBrook_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $8, $6, 3, EMBER_BROOK_GATE
	warp_def $9, $6, 4, EMBER_BROOK_GATE
	warp_def $7, $31, 1, MT_EMBER_ENTRANCE

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
