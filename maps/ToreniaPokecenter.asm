ToreniaPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaPokecenterNPC1:
	jumpstd pokecenternurse

ToreniaPokecenterNPC2:
	jumptextfaceplayer ToreniaPokecenterNPC2_Text_150b49

ToreniaPokecenterNPC3:
	jumptextfaceplayer ToreniaPokecenterNPC3_Text_150b7e

ToreniaPokecenterNPC4:
	jumptextfaceplayer ToreniaPokecenterNPC4_Text_150c64

ToreniaPokecenterNPC2_Text_150b49:
	ctxt "Why would the"
	line "newest city get"
	cont "the Magnet Train?"
	done

ToreniaPokecenterNPC3_Text_150b7e:
	ctxt "I never have luck"
	line "with board games."

	para "Like the one in"
	line "the Pachisi hall."

	para "I always 'die'."
	done

ToreniaPokecenterNPC4_Text_150c64:
	ctxt "This city's still"
	line "newly constructed."

	para "That's why it has"
	line "so many narrow"
	cont "paths."
	done

ToreniaPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 5, TORENIA_CITY
	warp_def $7, $5, 5, TORENIA_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ToreniaPokecenterNPC1, -1
	person_event SPRITE_GENTLEMAN, 7, 0, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, ToreniaPokecenterNPC2, -1
	person_event SPRITE_ROCKER, 3, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, ToreniaPokecenterNPC3, -1
	person_event SPRITE_R_ENGINEER, 3, 3, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, ToreniaPokecenterNPC4, -1
