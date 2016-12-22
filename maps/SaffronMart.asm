SaffronMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronMartNPC1:
	faceplayer
	opentext
	pokemart 0, 13
	closetext
	end

SaffronMartNPC2:
	jumptextfaceplayer SaffronMartNPC2_Text_1479b7

SaffronMartNPC3:
	jumptextfaceplayer SaffronMartNPC3_Text_147a67

SaffronMartNPC2_Text_1479b7:
	ctxt "A Trainer called"
	line "Gold once visited"

	para "Saffron and he"
	line "showed me how to"
	cont "be stronger."

	para "I was able to"
	line "defeat the leader"

	para "of the Fighting"
	line "Dojo, but Sabrina"

	para "is still too much"
	line "for me!"
	done

SaffronMartNPC3_Text_147a67:
	ctxt "It's always"
	line "exciting to meet"

	para "visitors from"
	line "faraway regions."
	done

SaffronMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 5, SAFFRON_CITY
	warp_def $7, $7, 5, SAFFRON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronMartNPC1, -1
	person_event SPRITE_COOLTRAINER_F, 6, 9, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, SaffronMartNPC2, -1
	person_event SPRITE_LASS, 3, 1, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronMartNPC3, -1
