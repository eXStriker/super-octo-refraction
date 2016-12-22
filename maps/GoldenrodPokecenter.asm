GoldenrodPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodPokecenterNPC1:
	faceplayer
	opentext
	writetext GoldenrodPokecenterNPC1_Text_325f0b
	endtext

GoldenrodPokecenterNPC2:
	faceplayer
	opentext
	writetext GoldenrodPokecenterNPC2_Text_325f9e
	endtext

GoldenrodPokecenterNPC3:
	faceplayer
	opentext
	writetext GoldenrodPokecenterNPC3_Text_325ea2
	endtext

GoldenrodPokecenterNPC4:
	jumpstd pokecenternurse

GoldenrodPokecenterNPC1_Text_325f0b:
	ctxt "I helped rebuild"
	line "Goldenrod after"

	para "that huge"
	line "earthquake a"

	para "couple of years"
	line "ago."

	para "We're not done"
	line "yet, we still"

	para "have to rebuild"
	line "the Radio Tower."
	done

GoldenrodPokecenterNPC2_Text_325f9e:
	ctxt "If you had a radio"
	line "before Goldenrod"

	para "was shook up, you"
	line "could listen to"

	para "music broadcasted"
	line "by the Radio"
	cont "Tower."
	done

GoldenrodPokecenterNPC3_Text_325ea2:
	ctxt "The total kinds"
	line "of #mon in"
	cont "the world keeps"
	cont "growing, because"
	cont "there's always"
	cont "new #mon to"
	cont "discover."
	done

GoldenrodPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 3, GOLDENROD_CITY
	warp_def $7, $5, 3, GOLDENROD_CITY
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_BLACK_BELT, 3, 5, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GoldenrodPokecenterNPC1, -1
	person_event SPRITE_COOLTRAINER_F, 6, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, GoldenrodPokecenterNPC2, -1
	person_event SPRITE_FISHER, 4, 0, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GoldenrodPokecenterNPC3, -1
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodPokecenterNPC4, -1
