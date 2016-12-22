HaywardMawile_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMawileNPC1:
	faceplayer
	opentext
	trade 4
	endtext

HaywardMawile_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 4, HAYWARD_CITY
	warp_def $7, $3, 4, HAYWARD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_DAISY, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HaywardMawileNPC1, -1
