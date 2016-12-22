LaurelPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelPokecenterNPC1:
	jumpstd pokecenternurse

LaurelPokecenterNPC2:
	jumptextfaceplayer LaurelPokecenterNPC2_Text_148581

LaurelPokecenterNPC3:
	jumptextfaceplayer LaurelPokecenterNPC3_Text_1485d6

LaurelPokecenterNPC4:
	jumptextfaceplayer LaurelPokecenterNPC4_Text_14861c

LaurelPokecenterNPC2_Text_148581:
	ctxt "Magikarp are"
	line "so pathetic!"

	para "Why would anyone"
	line "worship them!?"
	done

LaurelPokecenterNPC3_Text_1485d6:
	ctxt "Why is that man"
	line "upset about this"
	cont "city growing?"

	para "I find that notion"
	line "very exciting!"
	done

LaurelPokecenterNPC4_Text_14861c:
	ctxt "This city keeps"
	line "moving gradually"
	para "towards becoming"
	line "just another typ-"
	cont "ical urban town."

	para "It makes me sick."
	done

LaurelPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 6, LAUREL_CITY
	warp_def $7, $5, 6, LAUREL_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelPokecenterNPC1, -1
	person_event SPRITE_POKEFAN_M, 3, 0, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, LaurelPokecenterNPC2, -1
	person_event SPRITE_COOLTRAINER_F, 6, 2, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, LaurelPokecenterNPC3, -1
	person_event SPRITE_GYM_GUY, 7, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, LaurelPokecenterNPC4, -1
