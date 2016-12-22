CastroPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroPokecenterNPC1:
	jumpstd pokecenternurse

CastroPokecenterNPC2:
	jumptextfaceplayer CastroPokecenterNPC2_Text_320e63

CastroPokecenterNPC3:
	jumptextfaceplayer CastroPokecenterNPC3_Text_3209a8

CastroPokecenterNPC2_Text_320e63:
	ctxt "There's a ferry in"
	line "town that'll take"

	para "you to a place"
	line "called the Battle"
	cont "Arcade."

	para "I don't know where"
	line "they sell ferry"
	cont "tickets though."
	done

CastroPokecenterNPC3_Text_3209a8:
	ctxt "I'm training to"
	line "become part of"
	cont "Koji's crew!"

	para "HA!"
	done

CastroPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 5, CASTRO_VALLEY
	warp_def $7, $5, 5, CASTRO_VALLEY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroPokecenterNPC1, -1
	person_event SPRITE_POKEFAN_M, 6, 8, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroPokecenterNPC2, -1
	person_event SPRITE_BLACK_BELT, 4, 1, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroPokecenterNPC3, -1
