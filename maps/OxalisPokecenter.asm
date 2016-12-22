OxalisPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OxalisPokecenterNPC1:
	jumpstd pokecenternurse

OxalisPokecenterNPC2:
	jumptextfaceplayer OxalisPokecenterNPC2_Text_15d513

OxalisPokecenterNPC3:
	jumptextfaceplayer OxalisPokecenterNPC3_Text_15d597

OxalisPokecenterNPC4:
	jumptextfaceplayer OxalisPokecenterNPC4_Text_15d614

OxalisPokecenterNPC2_Text_15d513:
	ctxt "Shh!"

	para "<...>"

	para "I'm beating my"
	line "old high score!"
	done

OxalisPokecenterNPC3_Text_15d597:
	ctxt "I'm from Sinnoh,"
	line "and the #mon"
	para "here are really"
	line "different."

	para "I see a few"
	line "familiar faces,"
	para "but the wild is"
	line "mostly different."
	done

OxalisPokecenterNPC4_Text_15d614:
	ctxt "A Trainer laughed"
	line "at my #mon<...>"

	para "But I think my"
	line "Jigglypuff is"
	cont "the cutest!"

	para "Maybe it's because"
	line "they don't live in"
	cont "the wild in Rijon?"
	done

OxalisPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 7, OXALIS_CITY
	warp_def $7, $5, 7, OXALIS_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OxalisPokecenterNPC1, -1
	person_event SPRITE_GAMEBOY_KID, 6, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, OxalisPokecenterNPC2, -1
	person_event SPRITE_JUGGLER, 3, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, OxalisPokecenterNPC3, -1
	person_event SPRITE_TWIN, 5, 0, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, OxalisPokecenterNPC4, -1
