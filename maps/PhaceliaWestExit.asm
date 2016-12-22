PhaceliaWestExit_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaWestExitNPC1:
	jumpstd strengthboulder

PhaceliaWestExit_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $5, $f, 6, PHACELIA_TOWN
	warp_def $11, $b, 1, ROUTE_78
	warp_def $5, $3, 2, ROUTE_71B

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_BOULDER, 2, 6, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PhaceliaWestExitNPC1, -1
