ringdata: macro
	db \1 ; Ring received
	bigdw \2 ; Ash needed
	db \3 ; Level required
	db \4 ; Stone needed
	db \5 ; Stone quantities
	endm

Jeweling:
	opentext
	writetext Jeweling_WelcomeText
	loadscrollingmenudata RingMenu
.jewelingLoop
	scrollingmenu %10
	sif false, then
		closewindow
		jumptext Jewling_WeHopeToSeeYouSoon
	sendif

	addvar -1
	loadarray RingTable
	readarray 3
	comparevartobyte JewelingLevel
	sif false, then
		readarray 3
		writetext LowLevelText
	selse
		readarrayhalfword 1
		checkash
		sif =, 2, then
			writetext NotEnoughAshText
		selse
			cmdwitharrayargs .CustomTakeItemEnd - .CustomTakeItem
.CustomTakeItem:
			db takeitem_command, %11, 4, 5
.CustomTakeItemEnd:
			sif false, then
				readarray 4
				itemtotext 0, 0
				readarray 5
				itemplural 0
				writetext NotEnoughStonesText
			selse
				readarray 0
				verbosegiveitem ITEM_FROM_MEM, 1
				sif false, then
					cmdwitharrayargs .CustomGiveItemEnd - .CustomGiveItem
.CustomGiveItem:
					db giveitem_command, %11, 4, 5
.CustomGiveItemEnd:
				selse
					readarrayhalfword 1
					callasm TakeAsh
					readarrayhalfword 1
					copybytetovar wScriptArrayCurrentEntry
					divideop 0, 2
					addvar 1
					givejewelingEXP
				sendif
			sendif
		sendif
	sendif
	jump .jewelingLoop

Jewling_WeHopeToSeeYouSoon:
	ctxt "Come again soon!"
	done

NotEnoughStonesText:
	ctxt "You need @"
	deciram hScriptVar, 1, 2
	ctxt ""
	line "<STRBF1>"
	cont "to make this ring."
	prompt

LowLevelText:
	ctxt "You must be level"
	line "@"
	deciram hScriptVar, 1, 2
	ctxt " in order to"
	cont "make this ring."
	prompt

NotEnoughAshText:
	ctxt "You need @"
	deciram hScriptHalfwordVar, 2, 4
	ctxt " grams"
	line "of ash to make"
	cont "this ring."
	prompt

Jeweling_WelcomeText:
	ctxt "Welcome, welcome!"

	para "I can make a ring"
	line "for you, if you"

	para "have the necessary"
	line "materials."

	para "Which ring do you"
	line "want to make?"
	sdone

RingMenu:
	db %1000010
	db 02, 01
	db 10, 15
	dw .MenuData2
	db 1

.MenuData2
	db %100000
	db 4, SCREEN_WIDTH + 5
	db RingTableEntrySizeEnd - RingTable
	dba RingTable_WithListQuantity
	dba PlaceMenuItemName
	dba PlaceMenuItemRingCost
	dba UpdateItemDescription

PlaceMenuItemRingCost:
	push de
	callba ScrollingMenu_GetAddressOfMenu_UseScrollingMenuCursorPosition
	inc hl
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ld hl, sp + 0
	ld d, h
	ld e, l
	pop hl
	push bc
	lb bc, 2, 4
	call PrintNum
	pop bc
	ld a, " "
	ld [hli], a
	ld a, "g"
	ld [hli], a
	ld [hl], "."
	ret

RingTable_WithListQuantity:
	db 8
RingTable:
	ringdata GRASS_RING, 25, 0, LEAF_STONE, 1
RingTableEntrySizeEnd:
	ringdata FIRE_RING, 25, 4, FIRE_STONE, 1
	ringdata WATER_RING, 50, 8, WATER_STONE, 1
	ringdata THUNDER_RING, 50, 12, THUNDERSTONE, 2
	ringdata SHINY_RING, 75, 17, SHINY_STONE, 3
	ringdata DAWN_RING, 75, 21, DAWN_STONE, 3
	ringdata DUSK_RING, 100, 25, DUSK_STONE, 3
	ringdata MOON_RING, 100, 29, MOON_STONE, 3
RingTableEnd:
	db $ff