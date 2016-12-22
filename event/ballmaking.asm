BallMaking::
	pushhalfword PokeballTable
	writehalfword PokeballMenu
	jump BallMakingMain
	
BallMakingBasement::
	pushhalfword PokeballBasementTable
	writehalfword PokeballBasementMenu

BallMakingMain:
	opentext
	callasm _LoadFontsBattleExtra
	writetext ChoosePokeballText
	loadscrollingmenudata -1
.ballMakingLoop
	scrollingmenu %10
	sif false, then
		pophalfwordvar
		closewindow
		closetext
		end
	sendif
	
	pullhalfwordvar
	addvar -1
	loadarray -1, PokeballTableEntrySizeEnd - PokeballTable

	readarray 1
	comparevartobyte BallMakingLevel
	sif false, then
		readarray 1
		writetext LowBallLevelText
	selse
		readarray 2
		itemtotext 0, 0
		copyvartobyte wCurItem
		takeitem ITEM_FROM_MEM
		sif false, then
			readarray 0
			writetext NotEnoughApricornsText
		selse
			readarray 1
			sif >, 49, then
				copybytetovar BallMakingLevel
				addvar -49
				copyvartobyte wScriptBuffer
				random
				comparevartobyte wScriptBuffer
				iftrue .madeSpecialBall ; basically a goto
				writetext BallFailText
			selse
.madeSpecialBall
				readarray 0
				sif =, MASTER_BALL
					setevent EVENT_CRAFTED_MASTER_BALL
				verbosegiveitem ITEM_FROM_MEM, 1
				sif false, then
					readarray 2
					giveitem ITEM_FROM_MEM
				selse
					readarray 1
					divideop 0, 10
					giveballmakingEXP 0
					waitbutton
				sendif
			sendif
		sendif
	sendif
	jump .ballMakingLoop

BallFailText:
	ctxt "Darn! The apricorn"
	line "broke!"
	
	para "Failed to make"
	line "a ball."
	prompt

NotEnoughApricornsText:
	ctxt "You need a"
	line "<STRBF3> to"
	cont "make this"
	cont "#ball."
	prompt

LowBallLevelText:
	ctxt "You must be level"
	line "@"
	deciram hScriptVar, 1, 0
	ctxt " to make this"
	cont "#ball."
	prompt

ChoosePokeballText:
	ctxt "Choose the ball"
	line "you want to make."
	sdone

PokeballMenu:
	db %1000010
	db 02, 01
	db 10, 15
	dw .PokeballMenuOptions
	db 1

.PokeballMenuOptions
	db %100000
	db 4, SCREEN_WIDTH + 7
	db PokeballTableEntrySizeEnd - PokeballTable
	dba PokeballTable_WithListQuantity
	dba PlaceMenuItemName
	dba PlaceBallMakingLevelRequirement
	dba UpdateItemDescription

PokeballBasementMenu:
	db %1000010
	db 02, 01
	db 10, 15
	dw .PokeballBasementMenuOptions
	db 1

.PokeballBasementMenuOptions:
	db %100000
	db 4, SCREEN_WIDTH + 6
	db PokeballTableEntrySizeEnd - PokeballTable
	dba PokeballBasementTable_WithListQuantity
	dba PlaceMenuItemName
	dba PlaceBallMakingLevelRequirement
	dba UpdateItemDescription

PlaceBallMakingLevelRequirement:
	push de
	callba ScrollingMenu_GetAddressOfMenu_UseScrollingMenuCursorPosition
	inc hl
	inc hl
	ld a, [hl]
	ld [wd265], a
	call GetItemName
	ld b, 4
	ld h, d
	ld l, e
.findSpaceLoop
	ld a, [hli]
	cp " "
	jr z, .foundSpace
	dec b
	jr nz, .findSpaceLoop
	inc hl
.foundSpace
	dec hl
	ld [hl], "@"
	pop hl
	ld de, .ApricornColourAndLevelString
	jp PlaceText

.ApricornColourAndLevelString:
	text "<STRBF1>/", $6e, "@"
	deciram MenuSelectionQuantity, 1, 2
	db "@"

PokeballTable_WithListQuantity:
	db 10
PokeballTable:
	db POKE_BALL, 0, ORNGAPRICORN
PokeballTableEntrySizeEnd:
	db GREAT_BALL, 4, CYANAPRICORN
	db ULTRA_BALL, 7, GREYAPRICORN
	db QUICK_BALL, 10, YLW_APRICORN
	db DUSK_BALL, 14, BLK_APRICORN
	db FAST_BALL, 18, RED_APRICORN
	db DIVE_BALL, 22, BLU_APRICORN
	db REPEAT_BALL, 26, PNK_APRICORN
	db TIMER_BALL, 30, WHT_APRICORN
	db FRIEND_BALL, 35, GRN_APRICORN
	db $ff

PokeballBasementTable_WithListQuantity:
	db 2
PokeballBasementTable:
	db MASTER_BALL, 50, PRPLAPRICORN
	db SHINY_BALL, 50, SHNYAPRICORN
	db $ff
