Route77DaycareHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route77DaycareHouseSignpost1:
	jumpstd difficultbookshelf

Route77DaycareHouseSignpost2:
	jumpstd difficultbookshelf

Route77DaycareHouseNPC1:
	faceplayer
	opentext
	special Special_DayCareLady
	endtext

Route77DaycareHouseNPC2:
	faceplayer
	opentext
	special Special_DayCareMan
	endtext

Route77DaycareHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $5, $0, 3, ROUTE_77_DAYCARE_GARDEN
	warp_def $6, $0, 4, ROUTE_77_DAYCARE_GARDEN
	warp_def $7, $2, 3, ROUTE_77
	warp_def $7, $3, 3, ROUTE_77

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 1, 0, SIGNPOST_READ, Route77DaycareHouseSignpost1
	signpost 1, 1, SIGNPOST_READ, Route77DaycareHouseSignpost2

	;people-events
	db 2
	person_event SPRITE_PHARMACIST, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_RED, 0, 0, Route77DaycareHouseNPC1, -1
	person_event SPRITE_LASS, 3, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_RED, 0, 0, Route77DaycareHouseNPC2, -1
