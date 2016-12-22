LaurelCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Laurel_SetFlyFlag

Laurel_SetFlyFlag:
	setflag ENGINE_FLYPOINT_LAUREL_CITY
	return

LaurelCityHiddenItem_1:
	dw EVENT_LAUREL_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

LaurelCityTrap1:
	checkcode VAR_BOXSPACE
	if_equal 0, LaurelCity_1262c5
	checkflag ENGINE_GULFBADGE
	iftrue LaurelCity_126288
	end

LaurelCitySignpost1:
	ctxt "Magikarp"
	next "Cavern"
	done ;27

LaurelCitySignpost2:
	ctxt "We are"
	next "scientists!"
	done ;25

LaurelCitySignpost3:
	ctxt "Name Rater's"
	next "home"
	done ;24

LaurelCitySignpost4:
	ctxt "The city of"
	next "royalty"
	done ;23

LaurelCitySignpost6:
	jumpstd pokecentersign

LaurelCitySignpost7:
	jumpstd martsign

LaurelCityNPC1:
	jumptextfaceplayer LaurelCityNPC1_Text_124604

LaurelCityNPC2:
	jumptextfaceplayer LaurelCityNPC2_Text_124646

LaurelCityNPC3:
	jumptextfaceplayer LaurelCityNPC3_Text_1246de

LaurelCityNPC4:
	end

LaurelCityNPC5:
	jumptextfaceplayer LaurelCityNPC5_Text_1247a4

LaurelCityNPC6:
	jumptextfaceplayer LaurelCityNPC6_Text_12487e

LaurelCity_1262c5:
	checkcode VAR_PARTYCOUNT
	if_not_equal 6, LaurelCity_126280
	end

LaurelCity_126288:
	checkevent EVENT_LAUREL_CITY_GOT_TOTODILE
	iffalse LaurelCity_126290
	end

LaurelCity_126280:
	checkflag ENGINE_GULFBADGE
	iftrue LaurelCity_126288
	end

LaurelCity_126290:
	cry TOTODILE
	appear $5
	applymovement 5, LaurelCity_126290_Movement1
	spriteface 0, 1
	spriteface 5, 0
	opentext
	writetext LaurelCity_126290_Text_126304
	waitbutton
	writetext LaurelCity_126290_Text_12630e
	playwaitsfx SFX_FANFARE_2
	waitbutton
	givepoke TOTODILE, 15, ORAN_BERRY, 0
	disappear 5
	setevent EVENT_LAUREL_CITY_GOT_TOTODILE
	closetext
	end

LaurelCity_126290_Movement1:
	step_down
	step_down
	step_right
	step_end

LaurelCityTeleportation:
	opentext
	writetext LauerlCityBillTeleportationText
	waitbutton
	checkevent EVENT_REGISTERED_SOUTHERLY
	iftrue LaurelCityRegisteredSoutherly
	jumptext LauerlCityBillTeleportationNoRegisteredText

LaurelCityRegisteredSoutherly:
	writetext LauerlCityBillTeleportationSoutherlyText
	yesorno
	iftrue .WarpToSoutherly
	closetext
	end

.WarpToSoutherly
	warp SOUTHERLY_POKECENTER, 5, 5
	end


LauerlCityBillTeleportationText:
	ctxt "Bill's"
	line "Teleportation"
	cont "System!"
	done

LauerlCityBillTeleportationNoRegisteredText:
	ctxt "No cities have"
	line "been registered!"
	done

LauerlCityBillTeleportationSoutherlyText:
	ctxt "Would you like to"
	line "teleport to"
	cont "Southerly City?"
	done

LaurelCityNPC1_Text_124604:
	ctxt "There's a lab"
	line "nearby that can"
	cont "revive fossils."
	done

LaurelCityNPC2_Text_124646:
	ctxt "Brooklyn, the"
	line "local Gym Leader,"
	cont "is too entitled."

	para "I fear for this"
	line "generation<...>"
	done

LaurelCityNPC3_Text_1246de:
	ctxt "The city's badge"
	line "is needed to enter"
	cont "this cave."
	done

LaurelCityNPC5_Text_1247a4:
	ctxt "A new shop opened"
	line "here recently."
	done

LaurelCityNPC6_Text_12487e:
	ctxt "It's so silly!"

	para "The Gym Leader"
	line "thinks she's some"
	cont "sort of queen<...>"

	para "I can't stand it!"
	done

LaurelCity_126290_Text_126304:
	ctxt "-whines-"
	done

LaurelCity_126290_Text_12630e:
	ctxt "Totodile has"
	line "decided to join"
	cont "your party!"
	done

LaurelCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 13
	warp_def $1d, $1d, 1, CAPER_CITY
	warp_def $b, $f, 1, LAUREL_STICK
	warp_def $b, $22, 15, MAGIKARP_CAVERNS_MAIN
	warp_def $1, $15, 1, ORPHANAGE
	warp_def $5, $16, 1, LAUREL_LAB
	warp_def $1b, $17, 1, LAUREL_POKECENTER
	warp_def $1, $16, 1, SPURGE_HOUSE
	warp_def $3, $2, 1, LAUREL_GYM
	warp_def $15, $12, 2, LAUREL_MART
	warp_def $21, $16, 1, ACANIA_HOUSE
	warp_def $17, $5, 1, LAUREL_NAMERATER
	warp_def $10, $2, 3, LAUREL_GATE
	warp_def $11, $2, 4, LAUREL_GATE

	;xy triggers
	db 1
	xy_trigger 0, $6, $3, $0, LaurelCityTrap1, $0, $0

	;signposts
	db 8
	signpost 13, 35, SIGNPOST_LOAD, LaurelCitySignpost1
	signpost 6, 20, SIGNPOST_LOAD, LaurelCitySignpost2
	signpost 27, 5, SIGNPOST_LOAD, LaurelCitySignpost3
	signpost 19, 25, SIGNPOST_LOAD, LaurelCitySignpost4
	signpost 21, 12, SIGNPOST_ITEM, LaurelCityHiddenItem_1
	signpost 27, 24, SIGNPOST_READ, LaurelCitySignpost6
	signpost 21, 19, SIGNPOST_READ, LaurelCitySignpost7
	signpost 27, 21, SIGNPOST_READ, LaurelCityTeleportation

	;people-events
	db 7
	person_event SPRITE_FIREBREATHER, 12, 8, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, LaurelCityNPC1, -1
	person_event SPRITE_GRAMPS, 28, 15, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelCityNPC2, -1
	person_event SPRITE_GRAMPS, 12, 34, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, LaurelCityNPC3, EVENT_LAUREL_CITY_NPC_3
	person_event SPRITE_TOTODILE, 3, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelCityNPC4, EVENT_LAUREL_CITY_HIDDEN_TOTODILE
	person_event SPRITE_LASS, 23, 24, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, LaurelCityNPC5, -1
	person_event SPRITE_LASS, 18, 11, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, LaurelCityNPC6, -1
	person_event SPRITE_POKE_BALL, 21, 37, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_ICY_WIND, 0, EVENT_LAUREL_CITY_NPC_7
