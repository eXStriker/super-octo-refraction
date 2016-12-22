Route55GateUnderground_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route55GateUndergroundNPC1:
	jumptextfaceplayer Route55GateUndergroundNPC1_Text_322d24

Route55GateUndergroundNPC1_Text_322d24:
	ctxt "This tunnel leads"
	line "to Route 52, aka"
	cont "the Hayward"
	cont "Docks."
	done

Route55GateUnderground_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $4, $4, 2, RIJON_UNDERGROUND_HORIZONTAL
	warp_def $7, $3, 2, ROUTE_55
	warp_def $7, $4, 2, ROUTE_55

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_COOLTRAINER_F, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, Route55GateUndergroundNPC1, -1
