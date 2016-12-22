OwsauriPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OwsauriPokecenterNPC1:
	jumpstd pokecenternurse

OwsauriPokecenterNPC2:
	jumptextfaceplayer OwsauriPokecenterNPC2_Text_323b92

OwsauriPokecenterNPC3:
	jumptextfaceplayer OwsauriPokecenterNPC3_Text_323b08

OwsauriPokecenterNPC4:
	jumptextfaceplayer OwsauriPokecenterNPC4_Text_323b3a

OwsauriPokecenterNPC2_Text_323b92:
	ctxt "North of Jaeru"
	line "City's the league"
	cont "of this region."

	para "But you already"
	line "knew that right?"
	done

OwsauriPokecenterNPC3_Text_323b08:
	ctxt "Don't go into that"
	line "Gym without a"
	cont "sweater!"
	done

OwsauriPokecenterNPC4_Text_323b3a:
	ctxt "They opened up a"
	line "place where"

	para "geologists can"
	line "study earthquakes"
	cont "in Hayward City."
	done

OwsauriPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 3, OWSAURI_CITY
	warp_def $7, $5, 3, OWSAURI_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriPokecenterNPC1, -1
	person_event SPRITE_RECEPTIONIST, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, OwsauriPokecenterNPC2, -1
	person_event SPRITE_SUPER_NERD, 6, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OwsauriPokecenterNPC3, -1
	person_event SPRITE_SCIENTIST, 6, 0, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, OwsauriPokecenterNPC4, -1
