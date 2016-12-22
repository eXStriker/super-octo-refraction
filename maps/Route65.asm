Route65_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route65HiddenItem_1:
	dw EVENT_ROUTE_65_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route65Signpost1:
Route65Signpost2:
	ctxt "Path to Rijon"
	next "League"
	done

Route65Signpost4:
	opentext
	qrcode 3
	waitbutton
	checkitem QR_READER
	sif false
		closetext
		end
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext Route65Signpost4_Text_2502ff

Route65_Trainer_1:
	trainer EVENT_ROUTE_65_TRAINER_1, RIVAL1, 5, Route65_Trainer_1_Text_250060, Route65_Trainer_1_Text_2501dc, $0000, .Script

.Script:
	jumptext Route65_Trainer_1_Script_Text_25020e

Route65Signpost4_Text_2502ff:
	ctxt "Prism Key: Tree"
	line "outside Seashore"
	cont "Gym"
	done

Route65_Trainer_1_Text_250060:
	ctxt "Don't go any"
	line "further."

	para "I travelled this"
	line "world with diff-"
	cont "erent eyes since"

	para "I've escaped"
	line "prison."

	para "Life as a fugitive"
	line "is difficult and"
	cont "empty."

	para "When I lay awake"
	line "at night with my"

	para "#mon at my"
	line "side, I realize"

	para "that I am actually"
	line "thankful for their"
	cont "presence."

	para "My bonds with them"
	line "have grown while I"

	para "have grown"
	line "stronger."

	para "It's time for me to"
	line "test my strength"
	cont "in battle!"
	done

Route65_Trainer_1_Text_2501dc:
	ctxt "I still have more"
	line "to learn."
	done

Route65_Trainer_1_Script_Text_25020e:
	ctxt "I know I've done"
	line "much harm to"

	para "others as well as"
	line "my own #mon," 

	para "but thanks to the"
	line "example you set,"

	para "I'm ready to start"
	line "over and be the"
	cont "better Trainer."

	para "The way your" 
	line "#mon battle"

	para "reflect your inner"
	line "strength and"
	cont "resolve."

	para "A Trainer like you"
	line "is destined to be"
	cont "champion."

	para "So long until next"
	line "time Trainer."
	done

Route65_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $73, $d, 1, ROUTE_67_GATE
	warp_def $8b, $7, 1, JAERU_GATE
	warp_def $8b, $8, 2, JAERU_GATE

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 136, 8, SIGNPOST_LOAD, Route65Signpost1
	signpost 21, 12, SIGNPOST_LOAD, Route65Signpost2
	signpost 100, 14, SIGNPOST_ITEM, Route65HiddenItem_1
	signpost 123, 4, SIGNPOST_READ, Route65Signpost4

	;people-events
	db 1
	person_event SPRITE_SILVER, 15, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 6, Route65_Trainer_1, -1
