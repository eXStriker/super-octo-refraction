JaeruCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, JaeruCity_SetFlyFlag

JaeruCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_JAERU_CITY
	return

JaeruCityHiddenItem_1:
	dw EVENT_JAERU_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

JaeruCitySignpost1:
	jumpstd pokecentersign

JaeruCitySignpost2:
	jumpstd martsign

JaeruCitySignpost3:
	ctxt "The impossible to"
	next "pronounce city."
	done

JaeruCitySignpost4:
	ctxt "#mon Gym"
	next "Leader: Sparky"
	nl ""
	next "The Trainer that"
	next "shocks everybody!"
	done

JaeruCityNPC1:
	jumptextfaceplayer JaeruCityNPC1_Text_3337da

JaeruCityNPC2:
	jumptextfaceplayer JaeruCityNPC2_Text_3337a5

JaeruCityNPC3:
	jumptextfaceplayer JaeruCityNPC3_Text_333769

JaeruCityNPC1_Text_3337da:
	ctxt "Sparky lost his"
	line "edge, see for"
	cont "yourself."
	done

JaeruCityNPC2_Text_3337a5:
	ctxt "They sell some of"
	line "the best beer"
	cont "right here!"
	done

JaeruCityNPC3_Text_333769:
	ctxt "If you go north,"
	line "you'll end up at"
	cont "the Rijon League."
	done

JaeruCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $5, $20, 4, JAERU_GATE
	warp_def $19, $4, 4, ROUTE_60_GATE
	warp_def $1f, $1e, 1, JAERU_GYM
	warp_def $19, $1f, 5, CAPER_CITY
	warp_def $1b, $15, 1, JAERU_MART
	warp_def $1d, $7, 1, JAERU_GUARD_SUPPLIER
	warp_def $1b, $f, 1, JAERU_POKECENTER

	;xy triggers
	db 0

	;signposts
	db 5
	signpost 27, 16, SIGNPOST_READ, JaeruCitySignpost1
	signpost 27, 22, SIGNPOST_READ, JaeruCitySignpost2
	signpost 23, 27, SIGNPOST_LOAD, JaeruCitySignpost3
	signpost 31, 27, SIGNPOST_LOAD, JaeruCitySignpost4
	signpost 16, 15, SIGNPOST_ITEM, JaeruCityHiddenItem_1

	;people-events
	db 3
	person_event SPRITE_YOUNGSTER, 26, 28, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_YELLOW, 0, 0, JaeruCityNPC1, -1
	person_event SPRITE_PHARMACIST, 30, 21, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, 0, 0, JaeruCityNPC2, -1
	person_event SPRITE_LASS, 25, 10, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, JaeruCityNPC3, -1
