AzaleaPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AzaleaPokecenterNPC1:
	jumpstd pokecenternurse

AzaleaPokecenterNPC2:
	faceplayer
	opentext
	writetext AzaleaPokecenterNPC2_Text_325afa
	endtext

AzaleaPokecenterNPC3:
	faceplayer
	opentext
	writetext AzaleaPokecenterNPC3_Text_325a30
	endtext

AzaleaPokecenterNPC4:
	faceplayer
	opentext
	writetext AzaleaPokecenterNPC4_Text_325ac0
	endtext

AzaleaPokecenterNPC2_Text_325afa:
	ctxt "I do not wish to"
	line "disturb the land's"
	cont "choices."

	para "As with the quake"
	line "a few years back,"

	para "the path will open"
	line "on its own when it"
	cont "chooses to."
	done

AzaleaPokecenterNPC3_Text_325a30:
	ctxt "If you crack an"
	line "apricorn open, you"

	para "can catch #mon"
	line "with it!"

	para "Before #balls"
	line "were invented,"

	para "people used"
	line "apricorns."
	done

AzaleaPokecenterNPC4_Text_325ac0:
	ctxt "The landslide east"
	line "of here blocked"
	cont "off Route 33."
	done

AzaleaPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 5, AZALEA_TOWN
	warp_def $7, $5, 5, AZALEA_TOWN
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaPokecenterNPC1, -1
	person_event SPRITE_SUPER_NERD, 7, 7, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, AzaleaPokecenterNPC2, -1
	person_event SPRITE_POKEFAN_F, 4, 0, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaPokecenterNPC3, -1
	person_event SPRITE_FISHING_GURU, 1, 6, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaPokecenterNPC4, -1
