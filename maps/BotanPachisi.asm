BotanPachisi_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BotanPachisiNPC1:
	farjump PachisiGameBotan
	end

BotanPachisi_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $2b, $e, 4, BOTAN_CITY
	warp_def $2b, $f, 4, BOTAN_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 38, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, BotanPachisiNPC1, -1
