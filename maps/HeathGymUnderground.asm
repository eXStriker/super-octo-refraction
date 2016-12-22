HeathGymUnderground_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathGymUndergroundNPC1:
	jumptextfaceplayer HeathGymUndergroundNPC1_Text_10a970

HeathGymUndergroundNPC1_Text_10a970:
	ctxt "Hah!"

	para "Lava may seem"
	line "useless to some,"
	para "but to me, it's a"
	line "big money maker!"

	para "Interact with the"
	line "lava to smelt"
	para "whatever ore you"
	line "may have mined."

	para "Or turn your coal"
	line "into ash."

	para "Just make sure"
	line "you have your"
	para "Soot Sack before"
	line "you put your coal"
	cont "in there!"
	done

HeathGymUnderground_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $11, $5, 3, HEATH_GYM_UNDERGROUND
	warp_def $13, $7, 3, HEATH_GYM_HOUSE
	warp_def $b, $3, 1, HEATH_GYM_UNDERGROUND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_BLACK_BELT, 2, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_PLAYER, 0, 0, HeathGymUndergroundNPC1, -1
