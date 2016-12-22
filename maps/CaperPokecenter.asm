CaperPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CaperPokecenterNPC1:
	jumpstd pokecenternurse

CaperPokecenterNPC2:
	jumptextfaceplayer CaperPokecenterNPC2_Text_1758dd

CaperPokecenterNPC3:
	jumptextfaceplayer CaperPokecenterNPC3_Text_175923

CaperPokecenterNPC2_Text_1758dd:
	ctxt "I wish I could"
	line "meet Prof. Ilk."

	para "He's always busy"
	line "with his work<...>"
	done

CaperPokecenterNPC3_Text_175923:
	ctxt "#mon Centers"
	line "are great!"

	para "They heal your"
	line "#mon in no"
	cont "time at all!"
	done

CaperPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 4, CAPER_CITY
	warp_def $7, $5, 4, CAPER_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CaperPokecenterNPC1, -1
	person_event SPRITE_LASS, 7, 0, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, CaperPokecenterNPC2, -1
	person_event SPRITE_BOARDER, 4, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, CaperPokecenterNPC3, -1
