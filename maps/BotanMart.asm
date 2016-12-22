BotanMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BotanMartNPC1:
	faceplayer
	opentext
	pokemart 0, 29
	closetext
	end

BotanMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 3, BOTAN_CITY
	warp_def $7, $7, 3, BOTAN_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, BotanMartNPC1, -1
