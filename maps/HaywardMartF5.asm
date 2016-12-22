HaywardMartF5_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartF5Signpost2:
	jumpstd elevatorbutton

HaywardMartF5NPC1:
	faceplayer
	opentext
	pokemart 0, 27
	closetext
	end

HaywardMartF5NPC2:
	faceplayer
	opentext
	pokemart 0, 28
	closetext
	end

HaywardMartF5NPC3:
	jumptextfaceplayer HaywardMartF5NPC3_Text_178647

HaywardMartF5NPC4:
	jumptextfaceplayer HaywardMartF5NPC4_Text_178696

HaywardMartF5NPC5:
	jumptextfaceplayer HaywardMartF5NPC5_Text_1786da

HaywardMartF5NPC3_Text_178647:
	ctxt "Got any cash?"

	para "My #mon need"
	line "their vitamins."
	done

HaywardMartF5NPC4_Text_178696:
	ctxt "My #mon loves"
	line "these enhancers,"
	para "but I'm not sure"
	line "why<...>"
	done

HaywardMartF5NPC5_Text_1786da:

	ctxt "X Accuracy works"
	line "well with low"
	cont "accuracy moves."
	done

HaywardMartF5_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $0, $10, 1, HAYWARD_MART_F4
	warp_def $0, $d, 1, HAYWARD_MART_F6
	warp_def $0, $2, 1, HAYWARD_MART_ELEVATOR

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, HaywardMartF5Signpost2

	;people-events
	db 5
	person_event SPRITE_CLERK, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF5NPC1, -1
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF5NPC2, -1
	person_event SPRITE_GENTLEMAN, 4, 15, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, HaywardMartF5NPC3, -1
	person_event SPRITE_SAILOR, 5, 8, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF5NPC4, -1
	person_event SPRITE_TEACHER, 7, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, HaywardMartF5NPC5, -1
