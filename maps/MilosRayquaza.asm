MilosRayquaza_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MilosRayquaza_MapEventHeader ;filler
	db 0, 0

;warps
	db 0

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_SAGE, 7, 5, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, -1
	person_event SPRITE_RAYQUAZA, 2, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ObjectEvent, -1
