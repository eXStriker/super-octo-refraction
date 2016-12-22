Route58Gate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route58GateNPC1:
	jumptextfaceplayer Route58GateNPC1_Text_166063

Route58GateNPC2:
	jumptextfaceplayer Route58GateNPC1_Text_166063

Route58GateNPC1_Text_166063:
	ctxt "We're not letting"
	line "you through."

	para "This place is"
	line "quarantined for"
	cont "now."
	done

Route58Gate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $0, $3, 1, ROUTE_58
	warp_def $0, $4, 2, ROUTE_58
	warp_def $5, $3, 3, ROUTE_58
	warp_def $5, $4, 3, ROUTE_58

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 3, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route58GateNPC1, EVENT_ROUTE_59_TRAINER_1
	person_event SPRITE_OFFICER, 3, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route58GateNPC2, EVENT_ROUTE_59_TRAINER_1
