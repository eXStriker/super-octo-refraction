EagulouPark1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

EagulouPark1Signpost:
	ctxt "Area 3"
	done

EagulouPark1Item1:
	db ULTRA_BALL, 1 ;Put speaker part here

EagulouPark1Item2:
	db CHARCOAL, 1

EagulouPark1_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $4, $0, 7, EAGULOU_CITY_2
	warp_def $5, $0, 8, EAGULOU_CITY_2
	warp_def $16, $0, 5, EAGULOU_CITY_3
	warp_def $17, $0, 6, EAGULOU_CITY_3
	warp_def $9, $19, 10, EAGULOU_CITY_2

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 23, 5, SIGNPOST_LOAD, EagulouPark1Signpost

	;people-events
	db 3
	person_event SPRITE_POKE_BALL, 1, 27, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, EagulouPark1Item1, EVENT_EAGULOU_PARK_1_ITEM_1
	person_event SPRITE_POKE_BALL, 4, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_HEADBUTT, 0, EVENT_EAGULOU_PARK_1_ITEM_2
	person_event SPRITE_POKE_BALL, 24, 28, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_SILVER, 1, 0, EagulouPark1Item2, EVENT_EAGULOU_PARK_1_ITEM_3
