HaywardMartF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartF2Signpost2:
	jumpstd elevatorbutton

HaywardMartF2NPC1:
	faceplayer
	opentext
	pokemart 0, 23
	closetext
	end

HaywardMartF2NPC2:
	faceplayer
	opentext
	pokemart 0, 24
	closetext
	end

HaywardMartF2NPC3:
	jumptextfaceplayer HaywardMartF2NPC3_Text_1781ed

HaywardMartF2NPC4:
	jumptextfaceplayer HaywardMartF2NPC4_Text_178262

HaywardMartF2NPC3_Text_1781ed:
	ctxt "Max Repel is"
	line "mankind's greatest"
	cont "invention!"
	done

HaywardMartF2NPC4_Text_178262:
	ctxt "This store's gone"
	line "three days without"
	para "people arguing"
	line "over shoes."
	done

HaywardMartF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $0, $d, 1, HAYWARD_MART_F3
	warp_def $0, $10, 3, HAYWARD_MART_F1
	warp_def $0, $2, 1, HAYWARD_MART_ELEVATOR

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, HaywardMartF2Signpost2

	;people-events
	db 4
	person_event SPRITE_CLERK, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF2NPC1, -1
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF2NPC2, -1
	person_event SPRITE_POKEFAN_M, 7, 2, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, 0, 0, HaywardMartF2NPC3, -1
	person_event SPRITE_YOUNGSTER, 5, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, HaywardMartF2NPC4, -1
