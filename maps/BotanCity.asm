BotanCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, BotanCity_SetFlyFlag

BotanCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_BOTAN_CITY
	return

BotanCityHiddenItem_1:
	dw EVENT_BOTAN_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

BotanCitySignpost1:
	ctxt "The city of"
	next "nostalgia"
	done

BotanCitySignpost2:
	ctxt "Botan City"
	next "Station"
	done

BotanCitySignpost3:
	jumpstd pokecentersign

BotanCitySignpost5:
	opentext
	qrcode 1
	waitbutton
	checkitem QR_READER
	sif false, then
		closetext
		end
	sendif
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext BotanCitySignpost5_Text_13ea1a

BotanCitySignpost6:
	jumpstd martsign

BotanCityNPC1:
	jumptextfaceplayer BotanCityNPC1_Text_13e67d

BotanCityNPC2:
	jumptextfaceplayer BotanCityNPC2_Text_13e6e0

BotanCityNPC3:
	jumptextfaceplayer BotanCityNPC3_Text_13e75d

BotanCityNPC4:
	jumptextfaceplayer BotanCityNPC4_Text_13db24

BotanCityNPC5:
	jumptextfaceplayer BotanCityNPC5_Text_13db92

BotanCityNPC6:
	jumptextfaceplayer BotanCityNPC6_Text_13dc3b

BotanCityNPC7:
	jumptextfaceplayer BotanCityNPC7_Text_13e707

BotanCityNPC8:
	jumptextfaceplayer BotanCityNPC8_Text_13dcdb

BotanCitySignpost5_Text_13ea1a:
	ctxt "Sapphire Egg -"
	line "Route 75"
	cont "grass patch"
	done

BotanCityNPC1_Text_13e67d:
	ctxt "The ghosts up to"
	line "the north keep"

	para "playing nasty"
	line "pranks on people."

	para "I wish they'd mind"
	line "their manners!"
	done

BotanCityNPC2_Text_13e6e0:
	ctxt "You better not be"
	line "from Naljo."
	done

BotanCityNPC3_Text_13e75d:
	ctxt "#mon Centers"
	line "aren't allowed to"
	cont "exist here<...>"

	para "It's a strong"
	line "belief that<...>"

	para "<...>'they'<...>"

	para "don't like #mon"
	line "to be healed that"
	cont "way."
	done

BotanCityNPC4_Text_13db24:
	ctxt "We're the only"
	line "town that still"
	cont "bothers to farm."
	done

BotanCityNPC5_Text_13db92:
	ctxt "I was a construc-"
	line "tion worker for"
	cont "'that' building."

	para "I now regret it."
	done

BotanCityNPC6_Text_13dc3b:
	ctxt "Quarantined,"
	line "yet again."

	para "Sigh<...>"
	done

BotanCityNPC7_Text_13e707:
	ctxt "Please don't tell"
	line "anybody about"
	cont "this place."
	done

BotanCityNPC8_Text_13dcdb:
	ctxt "This city has"
	line "to be Rijon's"
	cont "strangest city."

	para "No other cities"
	line "have to deal with"

	para "the surprises we"
	line "always get."
	done

BotanCity_MapEventHeader:: db 0, 0

.Warps: db 9
	warp_def 5, 15, 1, BOTAN_HOUSE
	warp_def 9, 6, 4, ROUTE_59_GATE
	warp_def 17, 19, 1, BOTAN_MART
	warp_def 13, 36, 1, BOTAN_PACHISI
	warp_def 19, 37, 1, BOTAN_POKECENTER
	warp_def 8, 6, 3, CAPER_CITY
	warp_def 25, 6, 1, BOTAN_MAGNET_TRAIN
	warp_def 17, 1, 1, CAPER_CITY
	warp_def 3, 22, 3, HAUNTED_FOREST_GATE

.CoordEvents: db 0

.BGEvents: db 6
	signpost 11, 25, SIGNPOST_LOAD, BotanCitySignpost1
	signpost 27, 9, SIGNPOST_LOAD, BotanCitySignpost2
	signpost 19, 38, SIGNPOST_READ, BotanCitySignpost3
	signpost 8, 18, SIGNPOST_ITEM, BotanCityHiddenItem_1
	signpost 11, 17, SIGNPOST_READ, BotanCitySignpost5
	signpost 17, 20, SIGNPOST_READ, BotanCitySignpost6

.ObjectEvents: db 8
	person_event SPRITE_POKEFAN_F, 20, 19, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, 0, 0, 0, BotanCityNPC1, -1
	person_event SPRITE_FISHING_GURU, 29, 11, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, 8, 0, 0, BotanCityNPC2, -1
	person_event SPRITE_ROCKER, 12, 23, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, 8, 0, 0, BotanCityNPC3, -1
	person_event SPRITE_POKEFAN_F, 11, 10, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, 0, 0, 0, BotanCityNPC4, -1
	person_event SPRITE_FISHER, 12, 27, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8, 0, 0, BotanCityNPC5, EVENT_BOTAN_CITY_NPC_5
	person_event SPRITE_YOUNGSTER, 35, 0, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 1, -1, -1, 8, 0, 0, BotanCityNPC6, -1
	person_event SPRITE_YOUNGSTER, 22, 38, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, BotanCityNPC7, -1
	person_event SPRITE_SAGE, 8, 15, SPRITEMOVEDATA_SPINRANDOM_SLOW, 1, 1, -1, -1, 8, 0, 0, BotanCityNPC8, -1

