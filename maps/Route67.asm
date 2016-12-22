Route67_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Route67_SetFlyFlag

Route67_SetFlyFlag:
	setflag ENGINE_FLYPOINT_SENECA_CAVERNS
	return

Route67HiddenItem_1:
	dw EVENT_ROUTE_67_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route67Signpost1:
	jumpstd pokecentersign

Route67Signpost3:
	ctxt "Pathway to the"
	next "Rijon League!"
	done

Route67_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $b, $6, 3, ROUTE_67_GATE
	warp_def $7, $23, 5, SENECACAVERNSF1
	warp_def $7, $27, 1, SENECACAVERNSF1
	warp_def $7, $2b, 1, ROUTE_67_POKECENTER
	warp_def $d, $25, 1, ROUTE_67_HOUSE
	warp_def $8, $2f, 1, EMBER_BROOK_GATE
	warp_def $9, $2f, 2, EMBER_BROOK_GATE

	;xy triggers
	db 0

	;signposts
	db 3
	signpost 7, 44, SIGNPOST_READ, Route67Signpost1
	signpost 16, 21, SIGNPOST_ITEM, Route67HiddenItem_1
	signpost 12, 20, SIGNPOST_LOAD, Route67Signpost3

	;people-events
	db 0
