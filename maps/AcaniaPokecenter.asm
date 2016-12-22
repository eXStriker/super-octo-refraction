AcaniaPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaPokecenterNPC1:
	jumpstd pokecenternurse

AcaniaPokecenterNPC2:
	jumptextfaceplayer AcaniaPokecenterNPC2_Text_147b0c

AcaniaPokecenterNPC3:
	jumptextfaceplayer AcaniaPokecenterNPC3_Text_147ab0

AcaniaPokecenterNPC4:
	jumptextfaceplayer AcaniaPokecenterNPC4_Text_147bc1

AcaniaPokecenterNPC2_Text_147b0c:
	ctxt "If you surf east,"
	line "you'll end up in"
	cont "the Rijon region."

	para "Somebody built a"
	line "teleporter that"

	para "takes Trainers"
	line "who collected"
	para "all the Naljo"
	line "badges to the"
	cont "Rijon League!"

	para "Isn't that cool?"
	done

AcaniaPokecenterNPC3_Text_147ab0:
	ctxt "My #mon and I"
	line "are so tempted to"
	cont "chop the docks."

	para "That would impress"
	line "Andre, right<...>?"
	done

AcaniaPokecenterNPC4_Text_147bc1:
	ctxt "The Lighthouse is"
	line "still under heavy"
	cont "construction,"

	para "but they're going"
	line "to use the power"
	para "of Fire #mon"
	line "to keep it lit."

	para "Otherwise, it"
	line "would be way too"
	para "dangerous to head"
	line "to the east."
	done

AcaniaPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 1, ACANIA_DOCKS
	warp_def $7, $5, 1, ACANIA_DOCKS
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AcaniaPokecenterNPC1, -1
	person_event SPRITE_FISHER, 4, 5, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, 0, 0, 0, AcaniaPokecenterNPC2, -1
	person_event SPRITE_BLACK_BELT, 6, 7, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, AcaniaPokecenterNPC3, -1
	person_event SPRITE_SUPER_NERD, 6, 0, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AcaniaPokecenterNPC4, -1


