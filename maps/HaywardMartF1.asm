HaywardMartF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartF1Signpost2:
	jumpstd elevatorbutton

HaywardMartF1NPC1:
	jumptextfaceplayer HaywardMartF1NPC1_Text_178011

HaywardMartF1NPC1_Text_178011:
	ctxt "Welcome to the"
	line "Southland Mall."
	done

HaywardMartF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $7, $2, 1, HAYWARD_CITY
	warp_def $7, $3, 1, HAYWARD_CITY
	warp_def $0, $d, 2, HAYWARD_MART_F2
	warp_def $0, $2, 1, HAYWARD_MART_ELEVATOR
	warp_def $7, $10, 2, HAYWARD_CITY
	warp_def $7, $11, 2, HAYWARD_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, HaywardMartF1Signpost2

	;people-events
	db 1
	person_event SPRITE_RECEPTIONIST, 3, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, HaywardMartF1NPC1, -1
