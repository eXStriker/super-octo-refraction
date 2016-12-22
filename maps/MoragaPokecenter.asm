MoragaPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoragaPokecenterNPC1:
	jumpstd pokecenternurse

MoragaPokecenterNPC2:
	jumptextfaceplayer MoragaPokecenterNPC2_Text_323cd8

MoragaPokecenterNPC3:
	jumptextfaceplayer MoragaPokecenterNPC3_Text_323c8c

MoragaPokecenterNPC4:
	jumptextfaceplayer MoragaPokecenterNPC4_Text_323c3c

MoragaPokecenterNPC2_Text_323cd8:
	ctxt "They renovated"
	line "the nearby Power"
	cont "Plant."

	para "They even let the"
	line "#mon stay there!"

	para "I caught an"
	line "Electabuzz there!"
	done

MoragaPokecenterNPC3_Text_323c8c:
	ctxt "Collecting Rijon"
	line "badges?"

	para "Well you've got a"
	line "tough road ahead"
	cont "of you."
	done

MoragaPokecenterNPC4_Text_323c3c:
	ctxt "If I ever open a"
	line "Gym, it'll be guys"
	cont "only."

	para "It will blow"
	line "everybody's mind."
	done

MoragaPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 6, MORAGA_TOWN
	warp_def $7, $5, 6, MORAGA_TOWN
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaPokecenterNPC1, -1
	person_event SPRITE_SUPER_NERD, 3, 8, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaPokecenterNPC2, -1
	person_event SPRITE_FISHING_GURU, 5, 6, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaPokecenterNPC3, -1
	person_event SPRITE_GENTLEMAN, 4, 1, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaPokecenterNPC4, -1
