EagulouCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, EagulouCity_SetFlyFlag

EagulouCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_EAGULOU_CITY
	return

EagulouCityHiddenItem_1:
	dw EVENT_EAGULOU_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

EagulouCitySignpost1:
	ctxt "<UP> Eagulou Park"
	done

EagulouCitySignpost2:
	ctxt "Self proclaimed"
	next "under rated"
	done

EagulouCitySignpost3:
	jumpstd martsign

EagulouCitySignpost4:
	jumpstd pokecentersign

EagulouCity_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 5, 6, 3, MT_BOULDER_B1F
	warp_def 3, 18, 1, EAGULOU_GYM_F1
	warp_def 11, 15, 1, EAGULOU_POKECENTER
	warp_def 5, 10, 3, EAGULOU_PARK_GATE
	warp_def 11, 5, 1, EAGULOU_MART

.CoordEvents: db 0

.BGEvents: db 5
	signpost 7, 11, SIGNPOST_LOAD, EagulouCitySignpost1
	signpost 5, 17, SIGNPOST_LOAD, EagulouCitySignpost2
	signpost 11, 6, SIGNPOST_READ, EagulouCitySignpost3
	signpost 11, 16, SIGNPOST_READ, EagulouCitySignpost4
	signpost 14, 7, SIGNPOST_ITEM, EagulouCityHiddenItem_1

.ObjectEvents: db 0

