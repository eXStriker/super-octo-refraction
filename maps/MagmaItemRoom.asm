MagmaItemRoom_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaItemRoom_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $11, $5, 4, MAGMA_F1
	warp_def $3, $7, 7, MAGMA_ROOMS
	warp_def $5, $7, 3, PROVINCIAL_PARK

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 14, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 3, TM_FIRE_BLAST, 0, EVENT_MAGMA_ITEMROOM_NPC_1
