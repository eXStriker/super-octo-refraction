Apartments1C_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Apartments1CNPC1:
	jumptextfaceplayer Apartments1CNPC1_Text_3205d2

Apartments1CNPC1_Text_3205d2:
	ctxt "What, I forgot to"
	line "lock my door?"

	para "I'm sorry, but"
	line "I have to ask"
	cont "you to leave."

	para "Now?"
	done

Apartments1C_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 7, APARTMENTS_F2
	warp_def $7, $3, 7, APARTMENTS_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_TEACHER, 4, 5, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, Apartments1CNPC1, -1
