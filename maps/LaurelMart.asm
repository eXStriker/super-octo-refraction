LaurelMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelMartNPC1:
	faceplayer
	opentext
	pokemart 0, 7
	closetext
	end

LaurelMartNPC2:
	jumptextfaceplayer LaurelMartNPC2_Text_148f8c

LaurelMartNPC3:
	faceplayer
	opentext
	writetext LaurelMartNPC3_Text_14bd90
	waitbutton
	writetext LaurelMartNPC3_Text_14bdd2
	loadmenudata LaurelCityGoldTokenMenu
	verticalmenu
	closewindow
	if_equal 1, LaurelMart_14bc90
	if_equal 2, LaurelMart_14bcb6
	if_equal 3, LaurelMart_14bcd6
	closetext
	end

LaurelMart_14bc90:
	opentext
	writetext LaurelMart_14bc90_Text_14bdea
	yesorno
	iffalse LaurelMart_14bca5
	takeitem GOLD_TOKEN, 3
	iffalse LaurelMart_14bca7
	verbosegiveitem MOON_STONE, 1
	iffalse LaurelMart_14bcad
	closetext
	end

LaurelMart_14bcb6:
	opentext
	writetext LaurelMart_14bcb6_Text_14be58
	yesorno
	iffalse LaurelMart_14bca5
	takeitem GOLD_TOKEN, 10
	iffalse LaurelMart_14bca7
	verbosegiveitem AMULET_COIN, 1
	iffalse LaurelMart_14bccd
	closetext
	end

LaurelMart_14bcd6:
	opentext
	writetext LaurelMart_14bcb6_Text_14be58
	yesorno
	iffalse LaurelMart_14bca5
	takeitem GOLD_TOKEN, 10
	iffalse LaurelMart_14bca7
	verbosegiveitem LUCKY_EGG, 1
	iffalse LaurelMart_14bccd
	closetext
	end

LaurelMart_14bca5:
	closetext
	end

LaurelMart_14bca7:
	writetext LaurelMart_14bca7_Text_14be22
	endtext

LaurelMart_14bcad:
	giveitem GOLD_TOKEN, 3
	writetext LaurelMart_14bcad_Text_14be79
	endtext

LaurelMart_14bccd:
	giveitem GOLD_TOKEN, 10
	jumptext LaurelMart_14bcad_Text_14be79
	endtext

LaurelCityGoldTokenMenu:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw LaurelCityGoldTokenOptions
	db 1 ; default option

LaurelCityGoldTokenOptions:
	db $80
	db $4
	db "Moon Stone      3@"
	db "Amulet Coin    10@"
	db "Lucky Egg      10@"
	db "Cancel@"

LaurelMartNPC2_Text_148f8c:
	ctxt "You can find one "
	line "Gold Token in each"
	cont "and every area."

	para "One in Spurge"
	line "City, one in"
	cont "Mound Cave, etc."
	done

LaurelMartNPC3_Text_14bd90:
	ctxt "Welcome!"

	para "You can exchange"
	line "Gold Tokens you"
	cont "have found for"
	cont "prizes."
	done

LaurelMartNPC3_Text_14bdd2:
	ctxt "Which item do"
	line "you want?"
	done

LaurelMart_14bc90_Text_14bdea:
	ctxt "That'll be 3"
	line "tokens, you agree?"
	done

LaurelMart_14bcb6_Text_14be58:
	ctxt "That'll be 10"
	line "tokens, you agree?"
	done

LaurelMart_14bca7_Text_14be22:
	ctxt "You need more"
	line "tokens than that"
	cont "to get this."
	done

LaurelMart_14bcad_Text_14be79:
	ctxt "Free up some"
	line "space, OK?"
	done

LaurelMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $7, 9, LAUREL_CITY
	warp_def $7, $6, 9, LAUREL_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelMartNPC1, -1
	person_event SPRITE_SUPER_NERD, 6, 2, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, LaurelMartNPC2, -1
	person_event SPRITE_CLERK, 3, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, LaurelMartNPC3, -1
