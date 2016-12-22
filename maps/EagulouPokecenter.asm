EagulouPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EagulouPokecenterNPC1:
	jumpstd pokecenternurse

EagulouPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 3, EAGULOU_CITY
	warp_def $7, $5, 3, EAGULOU_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, EagulouPokecenterNPC1, -1
