Route50Gate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route50GateNPC1:
	jumptext Route50GateNPC1_Text_333ea1

Route50GateNPC1_Text_333ea1:
	ctxt "The lookout spot"
	line "upstairs is closed"

	para "due to peeping"
	line "toms."
	done

Route50Gate_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $0, $4, 1, ROUTE_49
	warp_def $0, $5, 3, ROUTE_49
	warp_def $7, $4, 1, ROUTE_50
	warp_def $7, $5, 1, ROUTE_50
	warp_def $6, $8, 2, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 4, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route50GateNPC1, -1
