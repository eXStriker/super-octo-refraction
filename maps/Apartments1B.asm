Apartments1B_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Apartments1BNPC1:
	jumptextfaceplayer Apartments1BNPC1_Text_32062a

Apartments1BNPC1_Text_32062a:
	ctxt "That Game Corner"
	line "outside is so"
	para "noisy, even at"
	line "night."

	para "Seems like they've"
	line "never heard of a"
	para "sound deadening"
	line "board."
	done

Apartments1B_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 6, APARTMENTS_F2
	warp_def $7, $3, 6, APARTMENTS_F2

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SUPER_NERD, 3, 2, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, Apartments1BNPC1, -1
