EagulouParkGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EagulouParkGateNPC1:
	faceplayer
	opentext
	writetext EagulouParkGateNPC1_Text_3309b9
	endtext

EagulouParkGateNPC1_Text_3309b9:
	ctxt "Welcome to the"
	line "Eagulou Park!"

	para "The rules have"
	line "changed recently."

	para "Everyone is"
	line "allowed to enter,"
	cont "free of charge,"

	para "but you must buy"
	line "Park Balls in the"

	para "local mart in"
	line "order to catch"
	cont "#mon."

	para "You're also not"
	line "allowed to hurt"

	para "the #mon even"
	line "if they decide to"

	para "attack you, so be"
	line "careful!"
	done

EagulouParkGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $0, $3, 1, EAGULOU_CITY_3
	warp_def $0, $4, 2, EAGULOU_CITY_3
	warp_def $5, $3, 4, EAGULOU_CITY
	warp_def $5, $4, 4, EAGULOU_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 2, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, EagulouParkGateNPC1, -1
