SoutherlyHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SoutherlyHouseNPC:
	jumptextfaceplayer SoutherlyHouseNPCText

SoutherlyHouseNPCText:
	ctxt "A kind Trainer"
	line "traded me a Kirlia"
	cont "a long time ago."

	para "Mine evolved into"
	line "a Gallade!"

	para "Only a male Kirlia"
	line "can evolve into"
	cont "a Gallade."
	done

SoutherlyHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 2, SOUTHERLY_CITY
	warp_def $7, $3, 2, SOUTHERLY_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SAILOR, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SoutherlyHouseNPC, -1
