PhaceliaPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaPokecenterNPC1:
	jumptextfaceplayer PhaceliaPokecenterNPC1_Text_2f75a4

PhaceliaPokecenterNPC2:
	jumptextfaceplayer PhaceliaPokecenterNPC2_Text_2f75e9

PhaceliaPokecenterNPC3:
	jumpstd pokecenternurse

PhaceliaPokecenterNPC1_Text_2f75a4:
	ctxt "This #mon"
	line "Center was just"
	cont "built."

	para "It has that new"
	line "building smell."
	done

PhaceliaPokecenterNPC2_Text_2f75e9:
	ctxt "The caverns used"
	line "to be a lot bigger"
	cont "until they allo-"
	cont "cated some space"
	cont "for the new city."

	para "Some think that's"
	line "what's causing"
	cont "all the recent"
	cont "earthquakes."

	para "I think there's a"
	line "different reason;"
	cont "we're nowhere near"
	cont "a plate boundary."
	done

PhaceliaPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 4, PHACELIA_TOWN
	warp_def $7, $5, 4, PHACELIA_TOWN
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_LASS, 4, 7, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaPokecenterNPC1, -1
	person_event SPRITE_SUPER_NERD, 6, 1, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaPokecenterNPC2, -1
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaPokecenterNPC3, -1
