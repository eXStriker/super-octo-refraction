LaurelNamerater_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelNameraterNPC1:
	faceplayer
	opentext
	special NameRater
	endtext

LaurelNamerater_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 11, LAUREL_CITY
	warp_def $7, $3, 11, LAUREL_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_GENTLEMAN, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelNameraterNPC1, -1
