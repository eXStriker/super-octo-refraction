GoldenrodMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodMartNPC1:
	jumptextfaceplayer GoldenrodMartNPC1_Text_3260b6

GoldenrodMartNPC2:
	jumptextfaceplayer GoldenrodMartNPC2_Text_326018

GoldenrodMartNPC3:
	faceplayer
	opentext
	pokemart 0, 33
	closetext
	end

GoldenrodMartNPC1_Text_3260b6:
	ctxt "This place has"
	line "decent sections"

	para "for a single floor"
	line "mart."
	done

GoldenrodMartNPC2_Text_326018:
	ctxt "A huge department"
	line "store used to"
	cont "stand here."

	para "The quake"
	line "destroyed the"
	cont "building."

	para "Goldenrod will"
	line "have a basic mart"

	para "until more floors"
	line "are built."
	done

GoldenrodMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 2, GOLDENROD_CITY
	warp_def $7, $7, 2, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_SUPER_NERD, 2, 2, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, GoldenrodMartNPC1, -1
	person_event SPRITE_COOLTRAINER_F, 5, 10, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 0, 0, GoldenrodMartNPC2, -1
	person_event SPRITE_CLERK, 3, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodMartNPC3, -1
