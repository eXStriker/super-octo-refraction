MtBoulderB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MtBoulderB2FSignpost1:
	jumptext MtBoulderB2FSignpost1_Text_3310a6

MtBoulderB2FSignpost1_Text_3310a6:
	ctxt "The sign is too"
	line "broken down."

	para "Impossible to"
	line "read."
	done

MtBoulderB2F_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $11, $14, 8, MT_BOULDER_B1F
	warp_def $11, $15, 8, MT_BOULDER_B1F
	warp_def $7, $b, 2, MT_BOULDER_B1F
	warp_def $4, $19, 3, MT_BOULDER_B1F

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 15, 9, SIGNPOST_READ, MtBoulderB2FSignpost1

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 1, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 3, TM_REFLECT, 0, EVENT_MT_BOULDER_B2F_NPC_1
