CaperHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CaperHouseNPC1:
	jumptextfaceplayer CaperHouseNPC1_Text_1850cd

CaperHouseNPC1_Text_1850cd:
	ctxt "Oh, a new face."

	para "What brings you"
	line "to Caper City?"

	para "<...>"

	para "What!?"

	para "You fell down the"
	line "hole in the mines?"

	para "I need to put a"
	line "ladder there<...>"
	done

CaperHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 3, CAPER_CITY
	warp_def $7, $3, 3, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_POKEFAN_M, 3, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CaperHouseNPC1, -1
