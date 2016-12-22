MagikarpCavernsRapids_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagikarpCavernsRapids_Item_1:
	db WATER_STONE, 4

MagikarpCavernsRapids_Item_2:
	db MYSTIC_WATER, 1

MagikarpCavernsRapids_MapEventHeader ;filler
	db 0, 0

;warps
	db 18
	warp_def $b, $a, 1, CAPER_CITY
	warp_def $8, $3, 3, MAGIKARP_CAVERNS_RAPIDS
	warp_def $6, $3, 2, MAGIKARP_CAVERNS_RAPIDS
	warp_def $2, $2, 5, MAGIKARP_CAVERNS_RAPIDS
	warp_def $a, $1f, 4, MAGIKARP_CAVERNS_RAPIDS
	warp_def $d, $20, 7, MAGIKARP_CAVERNS_RAPIDS
	warp_def $2, $29, 6, MAGIKARP_CAVERNS_RAPIDS
	warp_def $7, $1d, 9, MAGIKARP_CAVERNS_RAPIDS
	warp_def $7, $23, 8, MAGIKARP_CAVERNS_RAPIDS
	warp_def $d, $22, 11, MAGIKARP_CAVERNS_RAPIDS
	warp_def $13, $18, 10, MAGIKARP_CAVERNS_RAPIDS
	warp_def $8, $18, 13, MAGIKARP_CAVERNS_RAPIDS
	warp_def $d, $1a, 12, MAGIKARP_CAVERNS_RAPIDS
	warp_def $13, $24, 15, MAGIKARP_CAVERNS_RAPIDS
	warp_def $12, $1b, 14, MAGIKARP_CAVERNS_RAPIDS
	warp_def $14, $1b, 1, MAGIKARP_CAVERNS_END
	warp_def $0, $0, 1, CAPER_CITY
	warp_def $0, $0, 1, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_POKE_BALL, 6, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, MagikarpCavernsRapids_Item_1, EVENT_MAGIKARP_CAVERNS_RAPIDS_ITEM_1
	person_event SPRITE_POKE_BALL, 6, 34, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, MagikarpCavernsRapids_Item_2, EVENT_MAGIKARP_CAVERNS_RAPIDS_ITEM_2
