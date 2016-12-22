OxalisCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Oxalis_SetFlyFlag

Oxalis_SetFlyFlag:
	setflag ENGINE_FLYPOINT_OXALIS_CITY
	return

OxalisCitySignpost1:
	ctxt "Get some"
	next "clothes that"
	next "are just right"
	next "for you!"
	done ;9

OxalisCitySignpost2:
	ctxt "The city for"
	next "young, growing"
	next "trainers"
	done ;7

OxalisCitySignpost3:
	jumpstd martsign

OxalisCitySignpost4:
	ctxt "#mon Gym"
	next "Leader: Josiah"
	next ""
	next "Too hot to"
	next "handle!"
	done ;11

OxalisCitySignpost5:
	ctxt "Find out how"
	next "happy your"
	next "#mon"
	next "really are"
	done ;8

OxalisCitySignpost7:
	ctxt "Rookie trainer"
	next "hall."
	next "Just the place"
	next "for beginners!"
	done ;10

OxalisCitySignpost8:
	opentext
	qrcode 0
	waitbutton
	checkitem QR_READER
	sif false, then
		closetext
		end
	sendif
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext OxalisCitySignpost8_Text_1238da

OxalisCitySignpost9:
	jumpstd pokecentersign

OxalisCityNPC2:
	jumptextfaceplayer OxalisCityNPC2_Text_121ec6

OxalisCityNPC3:
	jumptextfaceplayer OxalisCityNPC3_Text_121f43

OxalisCityNPC4:
	jumptextfaceplayer OxalisCityNPC4_Text_121fd0

OxalisCityNPC5:
	jumptextfaceplayer OxalisCityNPC5_Text_12212c

OxalisCityNPC7:
	jumptextfaceplayer OxalisCityNPC7_Text_122ef1

OxalisCityNPC8:
	jumptextfaceplayer OxalisCityNPC8_Text_122e7f

OxalisCityNPC9:
	jumptextfaceplayer OxalisCityNPC9_Text_122da9

OxalisCitySignpost8_Text_1238da:
	ctxt "Sapphire Egg -"
	line "Route 75 small"
	cont "grass patch"
	done

OxalisCityNPC2_Text_121ec6:
	ctxt "There's some real"
	line "arrogant people"
	cont "this day and age."

	para "Josiah is our"
	line "local Gym Leader,"

	para "and he can be"
	line "described with"
	cont "one single word."

	para "<...>"

	para "Idiot."
	done

OxalisCityNPC3_Text_121f43:
	ctxt "See my pink dress?"

	para "Rad, isn't it!?"

	para "I got it made"
	line "for me from our"
	cont "local Salon."

	para "It's the most"
	line "stylish Salon in"
	cont "all of Naljo!"

	para "They even do"
	line "your makeup!"

	para "Give it a try!"
	done

OxalisCityNPC4_Text_121fd0:
	ctxt "There's a woman"
	line "living here."

	para "She can check"
	line "how happy your"
	cont "#mon are."
	done

OxalisCityNPC5_Text_12212c:
	ctxt "Hmm<...>"

	para "This town sure"
	line "has grown<...>"
	done

OxalisCityNPC7_Text_122ef1:
	ctxt "There has to be"
	line "more out there"
	cont "than what we're"
	cont "told about<...>"
	done

OxalisCityNPC8_Text_122e7f:
	ctxt "This house has"
	line "two underground"
	cont "passageways."

	para "It was built to"
	line "connect Oxalis"
	cont "with the mountains"
	cont "on Route 73."

	para "Lately, Trainers"
	line "have started to"
	cont "gather inside."

	para "One guy even gives"
	line "away free #mon"
	cont "from time to time!"
	done

OxalisCityNPC9_Text_122da9:
	ctxt "I tell you,"
	line "this place<...>"

	para "Like, if you tryna"
	line "be a nice person"
	cont "'round here<...>"

	para "Y'know, like you"
	line "say 'hello!'<...>"

	para "<...>or 'good"
	line "morning!'<...>"

	para "<...>and it just blows"
	line "up in your face."
	cont "'Leave me alone!'"
	cont "'Get lost scrub!'"
	cont "'Don't touch me!'"

	para "I know peeps from"
	line "Johto and Rijon."

	para "Way more chill."

	para "You say 'yo!' and"
	line "they reply 'ey!'"

	para "So why are Naljo"
	line "people so stuck"
	cont "up all the time?"
	done

OxalisCity_MapEventHeader:: db 0, 0

.Warps: db 15
	warp_def 7, 12, 1, OXALIS_SALON
	warp_def 23, 27, 1, SPRITE_PICKER_MALE
	warp_def 21, 33, 1, HAPPINESS_RATER
	warp_def 31, 23, 5, ROUTE_72_GATE
	warp_def 15, 22, 1, OXALIS_GYM
	warp_def 1, 21, 3, SPRITE_PICKER_MALE
	warp_def 13, 37, 1, OXALIS_POKECENTER
	warp_def 5, 37, 8, TRAINER_HOUSE
	warp_def 2, 4, 1, CAPER_CITY
	warp_def 1, 5, 1, CAPER_CITY
	warp_def 15, 7, 1, APARTMENTS_F2
	warp_def 19, 12, 2, OXALIS_MART
	warp_def 0, 4, 3, CAPER_CITY
	warp_def 5, 29, 1, TRAINER_HOUSE
	warp_def 31, 24, 6, ROUTE_72_GATE

.CoordEvents: db 0

.BGEvents: db 8
	signpost 9, 15, SIGNPOST_LOAD, OxalisCitySignpost1
	signpost 25, 23, SIGNPOST_LOAD, OxalisCitySignpost2
	signpost 19, 13, SIGNPOST_READ, OxalisCitySignpost3
	signpost 17, 21, SIGNPOST_LOAD, OxalisCitySignpost4
	signpost 23, 35, SIGNPOST_LOAD, OxalisCitySignpost5
	signpost 6, 30, SIGNPOST_LOAD, OxalisCitySignpost7
	signpost 7, 19, SIGNPOST_READ, OxalisCitySignpost8
	signpost 13, 38, SIGNPOST_READ, OxalisCitySignpost9

.ObjectEvents: db 7
	person_event SPRITE_GRAMPS, 18, 22, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OxalisCityNPC2, -1
	person_event SPRITE_TEACHER, 10, 12, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_PURPLE, 0, 0, OxalisCityNPC3, -1
	person_event SPRITE_LASS, 24, 32, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, OxalisCityNPC4, -1
	person_event SPRITE_GRAMPS, 28, 16, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_OW_RED, 0, 0, OxalisCityNPC5, -1
	person_event SPRITE_YOUNGSTER, 22, 8, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, OxalisCityNPC7, -1
	person_event SPRITE_YOUNGSTER, 6, 27, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, OxalisCityNPC8, -1
	person_event SPRITE_ROCKER, 13, 32, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_OW_RED, 0, 0, OxalisCityNPC9, -1
