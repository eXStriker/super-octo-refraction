GravelMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GravelMartNPC1:
	faceplayer
	opentext
	pokemart 0, 18
	closetext
	end

GravelMartNPC2:
	jumptextfaceplayer GravelMartNPC2_Text_333a91

GravelMartNPC3:
	jumptextfaceplayer GravelMartNPC3_Text_333b0e

GravelMartNPC2_Text_333a91:
	ctxt "I'm worried about"
	line "Prof. Tim."

	para "He's never gone"
	line "for this long"
	cont "before."
	done

GravelMartNPC3_Text_333b0e:
	ctxt "Elixirs are great,"
	line "but expensive!"
	done

GravelMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 2, GRAVEL_TOWN
	warp_def $7, $7, 2, GRAVEL_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GravelMartNPC1, -1
	person_event SPRITE_FISHER, 5, 10, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GravelMartNPC2, -1
	person_event SPRITE_BLACK_BELT, 2, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GravelMartNPC3, -1
