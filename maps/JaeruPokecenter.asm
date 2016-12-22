JaeruPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

JaeruPokecenterNPC1:
	jumpstd pokecenternurse

JaeruPokecenterNPC2:
	jumptextfaceplayer JaeruPokecenterNPC2_Text_1758dd

JaeruPokecenterNPC3:
	jumptextfaceplayer JaeruPokecenterNPC3_Text_175923

JaeruPokecenterNPC2_Text_1758dd:
	ctxt "Sparky used to fix"
	line "cars in a far"
	para "away city called"
	line "Oceanview."

	para "Now he's managing"
	line "his own company"

	para "right here in"
	line "Jaeru!"
	done

JaeruPokecenterNPC3_Text_175923:
	ctxt "This city is the"
	line "pathway to the"
	cont "Rijon League!"
	done

JaeruPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 7, JAERU_CITY
	warp_def $7, $5, 7, JAERU_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, JaeruPokecenterNPC1, -1
	person_event SPRITE_R_FISHER, 7, 0, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, JaeruPokecenterNPC2, -1
	person_event SPRITE_R_NERD, 4, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, JaeruPokecenterNPC3, -1
