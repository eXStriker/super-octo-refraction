MersonPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MersonPokecenterNPC1:
	jumpstd pokecenternurse

MersonPokecenterNPC2:
	jumptextfaceplayer MersonPokecenterNPC2_Text_32228c

MersonPokecenterNPC3:
	jumptextfaceplayer MersonPokecenterNPC3_Text_3222d8

MersonPokecenterNPC2_Text_32228c:
	ctxt "That path to South"
	line "Rijon should have"

	para "been cleared a"
	line "a long time ago."
	done

MersonPokecenterNPC3_Text_3222d8:
	ctxt "There's a man who"
	line "is very interested"
	cont "in a full #dex."

	para "He gave me four"
	line "Gold Tokens"

	para "since I own more"
	line "than 30 #mon!"
	done

MersonPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 1, MERSON_CITY
	warp_def $7, $5, 1, MERSON_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MersonPokecenterNPC1, -1
	person_event SPRITE_YOUNGSTER, 6, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MersonPokecenterNPC2, -1
	person_event SPRITE_TEACHER, 4, 0, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, MersonPokecenterNPC3, -1
