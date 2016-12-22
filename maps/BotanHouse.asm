BotanHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BotanHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 1, BOTAN_CITY
	warp_def $7, $3, 1, BOTAN_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 0
