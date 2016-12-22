MoundB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoundB1F_Item_1:
	db MOON_STONE, 1

MoundB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $5, $6, 7, MOUND_F1
	warp_def $10, $18, 1, MOUND_B2F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 11, 14, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_SILVER, 1, 0, MoundB1F_Item_1, EVENT_MOUND_B1F_ITEM_1
