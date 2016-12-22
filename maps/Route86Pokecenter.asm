Route86Pokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route86PokecenterNPC1:
	jumpstd pokecenternurse

Route86PokecenterNPC2:
	jumptextfaceplayer Route86PokecenterNPC2_Text_170b31

Route86PokecenterNPC2_Text_170b31:
	ctxt "The Battle Arcade"
	line "is unpredictable!"

	para "I don't last very"
	line "long in there."
	done

Route86Pokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 2, ROUTE_86
	warp_def $7, $5, 2, ROUTE_86
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route86PokecenterNPC1, -1
	person_event SPRITE_ROCKER, 4, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route86PokecenterNPC2, -1
