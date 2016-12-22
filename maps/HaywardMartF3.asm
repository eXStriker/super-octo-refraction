HaywardMartF3_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartF3Signpost2:
	jumpstd elevatorbutton

HaywardMartF3NPC1:
	faceplayer
	opentext
	pokemart 0, 25
	closetext
	end

HaywardMartF3NPC2:
	jumptextfaceplayer HaywardMartF3NPC2_Text_178377

HaywardMartF3NPC3:
	jumptextfaceplayer HaywardMartF3NPC3_Text_1783aa

HaywardMartF3NPC4:
	jumptextfaceplayer HaywardMartF3NPC4_Text_1783eb

HaywardMartF3NPC5:
	jumptextfaceplayer HaywardMartF3NPC5_Text_178485

HaywardMartF3NPC2_Text_178377:
	ctxt "This floor used"
	line "to sell video"
	cont "games."
	done

HaywardMartF3NPC3_Text_1783aa:
	ctxt "MUST"

	para "PLAY"

	para "VIDEO"

	para "GAMES!"
	done

HaywardMartF3NPC4_Text_1783eb:
	ctxt "Go away, I almost"
	line "have that high"
	cont "score!"
	done

HaywardMartF3NPC5_Text_178485:
	ctxt "Where did the"
	line "video games go?"
	done

HaywardMartF3_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $0, $10, 1, HAYWARD_MART_F2
	warp_def $0, $d, 2, HAYWARD_MART_F4
	warp_def $0, $2, 1, HAYWARD_MART_ELEVATOR

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, HaywardMartF3Signpost2

	;people-events
	db 5
	person_event SPRITE_CLERK, 5, 15, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF3NPC1, -1
	person_event SPRITE_YOUNGSTER, 5, 0, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, HaywardMartF3NPC2, -1
	person_event SPRITE_GAMEBOY_KID, 2, 17, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, HaywardMartF3NPC3, -1
	person_event SPRITE_GAMEBOY_KID, 1, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HaywardMartF3NPC4, -1
	person_event SPRITE_SUPER_NERD, 6, 8, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, HaywardMartF3NPC5, -1
