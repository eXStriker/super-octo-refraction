Route80Phancero_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route80Phancero_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $11, $8, 1, INTRO_OUTSIDE

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_BIRD, 16, 5, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_ROUTE_80_PHANCERO_NPC_1
	person_event SPRITE_POKE_BALL, 17, 17, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, -1
