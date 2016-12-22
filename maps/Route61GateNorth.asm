Route61GateNorth_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route61GateNorthHiddenItem_1:
	dw EVENT_ROUTE_61_GATE_NORTH_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route61GateNorth_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 0, 5, 3, ROUTE_61
	warp_def 9, 4, 5, ROUTE_62
	warp_def 9, 5, 5, ROUTE_62

.CoordEvents: db 0

.BGEvents: db 1
	signpost 2, 8, SIGNPOST_ITEM, Route61GateNorthHiddenItem_1

.ObjectEvents: db 0
