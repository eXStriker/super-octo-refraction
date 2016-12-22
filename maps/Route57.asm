Route57_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route57HiddenItem_1:
	dw EVENT_ROUTE_57_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route57Signpost1:
	ctxt "#mon Gym"
	next "Leader: Joe"
	nl   ""
	next "The most normal"
	next "Trainer you'll"
	next "ever meet!"
	done

Route57_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $17, $6, 4, ROUTE_56_GATE
	warp_def $47, $9, 5, CAPER_CITY
	warp_def $3, $10, 10, EAGULOU_CITY_2
	warp_def $1, $6, 2, CASTRO_FOREST_GATE_SOUTH
	warp_def $19, $10, 1, ROUTE_57_GYM

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 27, 13, SIGNPOST_LOAD, Route57Signpost1
	signpost 12, 10, SIGNPOST_ITEM, Route57HiddenItem_1

	;people-events
	db 0
