MersonMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonMartNPC1:
	opentext
	pokemart 0, 19
	closetext
	end

MersonMartNPC2:
	jumptextfaceplayer MersonMartNPC2_Text_2f0d19

MersonMartNPC3:
	jumptextfaceplayer MersonMartNPC3_Text_2f0d5c

MersonMartNPC2_Text_2f0d19:
	ctxt "I can never beat"
	line "Karpman with the"

	para "garbage they sell"
	line "here!"
	done

MersonMartNPC3_Text_2f0d5c:
	ctxt "They sell Water"
	line "Stones in a city"

	para "that has a Water"
	cont "Gym."

	para "Ironic, huh?"
	done

MersonMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 4, MERSON_CITY
	warp_def $7, $7, 4, MERSON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonMartNPC1, -1
	person_event SPRITE_POKEFAN_M, 5, 11, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonMartNPC2, -1
	person_event SPRITE_SUPER_NERD, 2, 1, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, MersonMartNPC3, -1
