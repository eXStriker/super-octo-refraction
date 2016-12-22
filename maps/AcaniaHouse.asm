AcaniaHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaHouseNPC1:
	jumptextfaceplayer AcaniaHouseNPC1_Text_24c08d

AcaniaHouseNPC2:
	faceplayer
	opentext
	writetext AcaniaHouseNPC2_Text_24c111
	cry AGGRON
	waitsfx
	endtext

AcaniaHouseNPC1_Text_24c08d:
	ctxt "This was a decent"
	line "place to live in,"

	para "until that Gym"
	line "Leader showed up."

	para "She uses Gas-"
	line "type #mon,"

	para "and the foul odor"
	line "is unpleasant."
	done

AcaniaHouseNPC2_Text_24c111:
	ctxt "Aggron: Rwar!"
	done

AcaniaHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 7, ACANIA_DOCKS
	warp_def $7, $3, 7, ACANIA_DOCKS

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_COOLTRAINER_F, 3, 5, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, AcaniaHouseNPC1, -1
	person_event SPRITE_AGGRON, 5, 1, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, AcaniaHouseNPC2, -1
