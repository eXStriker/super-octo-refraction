MersonHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 4, SEASHORE_CITY
	warp_def $7, $3, 4, SEASHORE_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_BLUE, -2, 0, $2a, 0, 0, -1, -1, PAL_OW_RED, 4, 42, ObjectEvent, -1
	person_event SPRITE_NONE, -2, 3, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 7, 3, ObjectEvent, -1
