MersonCaveB3F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonCaveB3F_Item_1:
	db CAGE_KEY, 1

MersonCaveB3F_Item_2: 
	db CAGE_KEY, 1

MersonCaveB3F_Item_3:
	db SHINY_STONE, 1

MersonCaveB3F_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $32, $c, 1, MERSON_CAVE_B2F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_POKE_BALL, 12, 11, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 3, TM_FINAL_CHANCE, 0, EVENT_MERSON_CAVE_B3F_NPC_1
	person_event SPRITE_POKE_BALL, 28, 11, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MersonCaveB3F_Item_1, EVENT_MERSON_CAVE_B3F_ITEM_2
	person_event SPRITE_POKE_BALL, 50, 32, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MersonCaveB3F_Item_2, EVENT_MERSON_CAVE_B3F_ITEM_3
	person_event SPRITE_POKE_BALL, 15, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, MersonCaveB3F_Item_3, EVENT_MERSON_CAVE_B3F_ITEM_4
