HaywardMartF4_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartF4Signpost2:
	jumpstd elevatorbutton

HaywardMartF4NPC1:
	faceplayer
	opentext
	pokemart 0, 26
	closetext
	end

HaywardMartF4NPC2:
	jumptextfaceplayer HaywardMartF4NPC2_Text_178545

HaywardMartF4NPC2_Text_178545:
	ctxt "I'm so thankful"
	line "that they sell"
	cont "Repels here."

	para "I never go into"
	line "caves without"
	cont "them!"
	done

HaywardMartF4_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $0, $d, 1, HAYWARD_MART_F5
	warp_def $0, $10, 2, HAYWARD_MART_F3
	warp_def $0, $2, 1, HAYWARD_MART_ELEVATOR

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, HaywardMartF4Signpost2

	;people-events
	db 2
	person_event SPRITE_CLERK, 7, 3, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF4NPC1, -1
	person_event SPRITE_SUPER_NERD, 4, 5, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, HaywardMartF4NPC2, -1
