LaurelGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelGateNPC1:
	jumptextfaceplayer LaurelGateNPC1_Text_1596c7

LaurelGateNPC2:
	jumptextfaceplayer LaurelGateNPC2_Text_159712

LaurelGateNPC3:
	jumptextfaceplayer LaurelGateNPC3_Text_15974e

LaurelGateNPC1_Text_1596c7:
	ctxt "Being a gate guard"
	line "pays very well."

	para "And what do I do?"

	para "Stand here all"
	line "day doing nothing!"

	para "Hooray for"
	line "capitalism!"
	done

LaurelGateNPC2_Text_159712:
	ctxt "They are building"
	line "these route gates"
	cont "everywhere<...>"
	done

LaurelGateNPC3_Text_15974e:
	ctxt "Humans didn't live"
	line "in Naljo until"

	para "the Protectors"
	line "brought those who"
	cont "are pure of heart."
	done

LaurelGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 1, ROUTE_75
	warp_def $5, $0, 2, ROUTE_75
	warp_def $4, $9, 12, LAUREL_CITY
	warp_def $5, $9, 13, LAUREL_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_OFFICER, 2, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelGateNPC1, -1
	person_event SPRITE_ROCKER, 6, 8, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, 8 + PAL_OW_BROWN, 0, 0, LaurelGateNPC2, -1
	person_event SPRITE_TEACHER, 1, 0, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, LaurelGateNPC3, -1
