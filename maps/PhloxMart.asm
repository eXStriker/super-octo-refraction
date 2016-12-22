PhloxMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhloxMartNPC1:
	jumptextfaceplayer PhloxMartNPC1_Text_1d2b6d

PhloxMartNPC2:
	jumptextfaceplayer PhloxMartNPC2_Text_1d2af4

PhloxMartNPC3:
	faceplayer
	opentext
	pokemart 0, 11
	closetext
	end

PhloxMartNPC1_Text_1d2b6d:
	ctxt "Do you know where"
	line "they sell ski gear"
	cont "around here?"

	para "All mountain"
	line "towns sell winter"
	cont "sports equipment,"
	cont "don't they?"
	done

PhloxMartNPC2_Text_1d2af4:
	ctxt "Did you know?"

	para "Max Potions and"
	line "Full Restores"
	para "only heal up to"
	line "999 HP."

	para "A #mon can't"
	line "have more than"
	cont "999 HP though."
	done

PhloxMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 2, PHLOX_TOWN
	warp_def $7, $7, 2, PHLOX_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_SUPER_NERD, 2, 11, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, PhloxMartNPC1, -1
	person_event SPRITE_TEACHER, 6, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, PhloxMartNPC2, -1
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhloxMartNPC3, -1
