GravelTown_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, GravelTown_SetFlyFlag

GravelTown_SetFlyFlag:
	setflag ENGINE_FLYPOINT_GRAVEL_TOWN
	setevent EVENT_RIJON_SECOND_PART
	return

GravelTownHiddenItem_1:
	dw EVENT_GRAVEL_TOWN_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

GravelTownSignpost1:
	ctxt "Professor Tim's"
	next "Lab"
	done

GravelTownSignpost2:
	jumpstd martsign

GravelTownSignpost3:
	ctxt "Merson Cave"
	next "Entrance"
	done

GravelTownSignpost4:
	ctxt "A quiet mountain"
	next "town."
	done

GravelTownNPC1:
	jumptextfaceplayer GravelTownNPC1_Text_331dc5

GravelTownNPC2:
	jumptextfaceplayer GravelTownNPC2_Text_331dfd

GravelTownNPC1_Text_331dc5:
	ctxt "The crisp mountain"
	line "air makes me feel"
	cont "so alive!"
	done

GravelTownNPC2_Text_331dfd:
	ctxt "Even though"
	line "someone planted"

	para "these flowers on"
	line "a path, they're"

	para "inexplicably"
	line "staying strong."
	done

GravelTown_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $23, $d, 7, MERSON_CAVE_B2F
	warp_def $1b, $9, 1, GRAVEL_MART
	warp_def $b, $c, 1, JENS_LAB

	;xy triggers
	db 0

	;signposts
	db 5
	signpost 13, 13, SIGNPOST_LOAD, GravelTownSignpost1
	signpost 27, 10, SIGNPOST_READ, GravelTownSignpost2
	signpost 35, 11, SIGNPOST_LOAD, GravelTownSignpost3
	signpost 9, 3, SIGNPOST_LOAD, GravelTownSignpost4
	signpost 1, 6, SIGNPOST_ITEM, GravelTownHiddenItem_1

	;people-events
	db 2
	person_event SPRITE_COOLTRAINER_M, 12, 4, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, GravelTownNPC1, -1
	person_event SPRITE_YOUNGSTER, 28, 15, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, GravelTownNPC2, -1
