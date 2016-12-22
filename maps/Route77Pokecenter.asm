Route77Pokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route77PokecenterNPC1:
	jumpstd pokecenternurse

Route77PokecenterNPC2:
	jumptextfaceplayer Route77Pokecenter_15980b_Text_15991e

Route77PokecenterNPC3:
	jumptextfaceplayer Route77PokecenterNPC3_Text_15b913


Route77PokecenterNPC3_Text_15b913:
	ctxt "Underneath the"
	line "cave there used"
	cont "to be a town."

	para "So it makes sense"
	line "that there's a"
	cont "#mon Center."
	done

Route77Pokecenter_15980b_Text_15991e:
	ctxt "#mon Center near"
	line "a cave? Good idea!"
	done

Route77Pokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 4, ROUTE_77
	warp_def $7, $5, 4, ROUTE_77
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route77PokecenterNPC1, -1
	person_event SPRITE_ROCKER, 13, 32, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route77PokecenterNPC2, -1
	person_event SPRITE_POKEFAN_F, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route77PokecenterNPC3, -1
