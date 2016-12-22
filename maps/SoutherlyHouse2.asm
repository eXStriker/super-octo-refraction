SoutherlyHouse2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SoutherlyHouseNPC2:
	jumptextfaceplayer SoutherlyHouseNPC2Text

SoutherlyHouseNPC3:
	jumptextfaceplayer SoutherlyHouseNPC3Text

SoutherlyHouseNPC2Text:
	ctxt "Welcome to Tunod!"

	para "Thanks to the"
	line "new southern path,"

	para "we're getting all"
	line "sorts of new"
	cont "visitors!"
	done

SoutherlyHouseNPC3Text:
	ctxt "Espo Forest's"
	line "blocked off for"

	para "now, but there's a"
	line "lot of Leafeon"
	cont "who live there!"
	done

SoutherlyHouse2_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 7, 2, 1, SOUTHERLY_CITY
	warp_def 7, 3, 1, SOUTHERLY_CITY

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 2
	person_event SPRITE_TEACHER, 5, 6, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SoutherlyHouseNPC2, -1
	person_event SPRITE_TEACHER, 5, 7, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SoutherlyHouseNPC3, -1
