JaeruGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

JaeruGateNPC1:
	jumptextfaceplayer JaeruGateNPC1_Text_3209df

JaeruGateNPC2:
	jumptextfaceplayer JaeruGateNPC1_Text_3209df

JaeruGateNPC1_Text_3209df:
	ctxt "If you got here by"
	line "taking the portal,"

	para "we can't let you"
	line "pass."

	para "Sorry."
	done

JaeruGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $0, $4, 2, ROUTE_65
	warp_def $0, $5, 3, ROUTE_65
	warp_def $7, $4, 1, JAERU_CITY
	warp_def $7, $5, 1, JAERU_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 2, 5, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, JaeruGateNPC1, EVENT_CASTRO_FOREST_TRAINER_2
	person_event SPRITE_OFFICER, 2, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, JaeruGateNPC2, EVENT_CASTRO_FOREST_TRAINER_2
