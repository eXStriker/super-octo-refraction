HaywardMartF6_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartF6Signpost1:
	jumptext HaywardMartF6Signpost1_Text_17895a

HaywardMartVendingMachine:
	opentext
HaywardMartF6_1787a0:
	writetext HaywardMartF6Signpost2_Text_17886c
	special PlaceMoneyTopRight
	loadmenudata .VendingMachineMenu
	verticalmenu
	closewindow
	anonjumptable
	dw .quit
	dw HaywardMartF6_1787b6
	dw HaywardMartF6_1787d0
	dw HaywardMartF6_1787ea
.quit
	closetext
	end

.VendingMachineMenu
	db $40 ; flags
	db 03, 00 ; start coords
	db 10, 13 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2: ; 17d297
	db %10000000 ; flags
	db 3
	db "Fresh Water@"
	db "Soda Pop@"
	db "Lemonade@"

HaywardMartF6NPC1:
	faceplayer
	opentext
	clearevent EVENT_0
	checkevent EVENT_EXPLAIN_EGGS
	iftrue SecretEggExplanation
	writetext HaywardMartF6NPC1_Text_17b214
	setevent EVENT_EXPLAIN_EGGS
	waitbutton
SecretEggExplanation:
	checkitem RUBY_EGG
	iftrue HaywardMartF6_17b1a3
CheckSapphireEgg:
	checkitem SAPPHIRE_EGG
	iftrue HaywardMartF6_17b1c2
CheckEmeraldEgg:
	checkitem EMERALD_EGG
	iftrue HaywardMartF6_17b1e1
CheckIfLastEgg:
	checkevent EVENT_GAVE_RUBY_EGG
	iffalse .didntGetAll
	checkevent EVENT_GAVE_SAPPHIRE_EGG
	iffalse .didntGetAll
	checkevent EVENT_GAVE_EMERALD_EGG
	iffalse .didntGetAll
	jumptext HaywardMartF6_17b19b_Text_17b2b4

.didntGetAll
	jumptext HaywardMartF6_NoEggs

HaywardMartF6NPC2:
	jumptextfaceplayer HaywardMartF6NPC2_Text_17892c

HaywardMartF6_1787b6:
	checkmoney 0, 200
	if_equal 2, HaywardMartF6_178811
	giveitem FRESH_WATER, 1
	iffalse HaywardMartF6_178818
	takemoney 0, 200
	itemtotext FRESH_WATER, 0
	jump HaywardMartF6_178804

HaywardMartF6_1787d0:
	checkmoney 0, 300
	if_equal 2, HaywardMartF6_178811
	giveitem SODA_POP, 1
	iffalse HaywardMartF6_178818
	takemoney 0, 300
	itemtotext SODA_POP, 0
	jump HaywardMartF6_178804

HaywardMartF6_1787ea:
	checkmoney 0, 350
	if_equal 2, HaywardMartF6_178811
	giveitem LEMONADE, 1
	iffalse HaywardMartF6_178818
	takemoney 0, 350
	itemtotext LEMONADE, 0
	jump HaywardMartF6_178804

HaywardMartF6_17b1a3:
	writetext HaywardMartF6_17b1a3_Text_17b30a
	yesorno
	iffalse HaywardMartF6_17b200
	takeitem RUBY_EGG, 1
	giveitem RED_ORB, 1
	writetext HaywardMartF6_17b1a3_Text_17b35b
	waitbutton
	setevent EVENT_GAVE_RUBY_EGG
	playwaitsfx SFX_DEX_FANFARE_200_229
	jump CheckSapphireEgg

HaywardMartF6_17b1c2:
	writetext HaywardMartF6_17b1c2_Text_17b377
	yesorno
	iffalse HaywardMartF6_17b207
	takeitem SAPPHIRE_EGG, 1
	giveitem BLUE_ORB, 1
	writetext HaywardMartF6_17b1c2_Text_17b3cd
	waitbutton
	setevent EVENT_GAVE_SAPPHIRE_EGG
	playwaitsfx SFX_DEX_FANFARE_200_229
	jump CheckEmeraldEgg

HaywardMartF6_17b1e1:
	writetext HaywardMartF6_17b1e1_Text_17b3ee
	yesorno
	iffalse HaywardMartF6_17b20e
	takeitem EMERALD_EGG, 1
	giveitem GREEN_ORB, 1
	writetext HaywardMartF6_17b1e1_Text_17b440
	waitbutton
	setevent EVENT_GAVE_EMERALD_EGG
	playwaitsfx SFX_DEX_FANFARE_200_229
	jump CheckIfLastEgg

HaywardMartF6_17b183:
	jumptext HaywardMartF6_17b183_Text_17b28a

HaywardMartF6_178811:
	writetext HaywardMartF6_178811_Text_1788aa
	waitbutton
	jump HaywardMartF6_1787a0

HaywardMartF6_178818:
	writetext HaywardMartF6_178818_Text_1788c3
	waitbutton
	jump HaywardMartF6_1787a0

HaywardMartF6_178804:
	pause 10
	playsound SFX_ENTER_DOOR
	writetext HaywardMartF6_178804_Text_178890
	buttonsound
	itemnotify
	waitbutton
	jump HaywardMartF6_1787a0

HaywardMartF6_17b200:
	writetext HaywardMartF6_17b200_Text_17b45d
	waitbutton
	jump CheckSapphireEgg

HaywardMartF6_17b207:
	writetext HaywardMartF6_17b200_Text_17b45d
	waitbutton
	jump CheckEmeraldEgg

HaywardMartF6_17b20e:
	writetext HaywardMartF6_17b200_Text_17b45d
	waitbutton
	jump CheckIfLastEgg

HaywardMartF6Signpost1_Text_17895a:
	ctxt "6F: Rooftop Square"
	line "Vending Machines"
	done

HaywardMartF6Signpost2_Text_17886c:
	ctxt "A vending machine!"
	line "Here's the menu."
	done

HaywardMartF6NPC1_Text_17b214:
	ctxt "Oh hello."

	para "I'm looking for"
	line "some special eggs."

	para "Not #mon eggs,"
	line "but secret eggs."

	para "They're difficult"
	line "to find."

	para "If you find one"
	line "that I want, I'll"

	para "give you a shiny"
	line "orb I received"
	cont "five years ago."

	para "The Trainer later"
	line "became the Rijon"
	cont "Champion<...>"

	para "<...>but he vanished"
	line "a year later."
	done

HaywardMartF6NPC2_Text_17892c:
	ctxt "That girl there"
	line "is trying to get"
	cont "rid of her orbs."

	para "If I were her, I'd"
	line "hold onto them."
	done

HaywardMartF6_17b1a3_Text_17b30a:
	ctxt "You have a"
	line "luxurious Ruby"
	cont "Egg!"

	para "I'll trade you it"
	line "for my Red Orb!"

	para "Will you trade?"
	done

HaywardMartF6_17b1a3_Text_17b35b:
	ctxt "Great, here's"
	line "your Red Orb!"
	done

HaywardMartF6_17b1c2_Text_17b377:
	ctxt "You have a"
	line "beautiful"
	cont "Sapphire Egg!"

	para "I'll trade you it"
	line "for my Blue Orb!"

	para "Want you trade?"
	done

HaywardMartF6_17b1c2_Text_17b3cd:
	ctxt "Wonderful, here's"
	line "your Blue Orb!"
	done

HaywardMartF6_17b1e1_Text_17b3ee:
	ctxt "You have a shiny"
	line "Emerald Egg!"

	para "I'll trade you it"
	line "for my Green"
	cont "Orb!"

	para "Want you trade?"
	done

HaywardMartF6_17b1e1_Text_17b440:
	ctxt "Nice, here's your"
	line "Green Orb!"
	done

HaywardMartF6_17b183_Text_17b28a:
	ctxt "You don't have"
	line "any eggs that I"
	cont "want."

	para "Come back when you"
	line "do."
	done

HaywardMartF6_178811_Text_1788aa:
	ctxt "Oops, not enough"
	line "money…"
	done

HaywardMartF6_178818_Text_1788c3:
	ctxt "There's no more"
	line "room for stuff…"
	done

HaywardMartF6_178804_Text_178890:
	ctxt "Clang!"

	para "<STRBF1>"
	line "popped out."
	done

HaywardMartF6_17b200_Text_17b45d:
	ctxt "Come on, that egg"
	line "isn't any use to"
	cont "you!"
	done

HaywardMartF6_NoEggs:
	ctxt "Come back when"
	line "you have more"
	cont "special eggs."
	done

HaywardMartF6_17b19b_Text_17b2b4:
	ctxt "What? I'm all out"
	line "of orbs."

	para "I already have all"
	line "the eggs that I"
	cont "want."
	done

HaywardMartF6_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $0, $10, 2, HAYWARD_MART_F5
	warp_def $0, $2, 2, HAYWARD_MART_ELEVATOR

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 1, 12, SIGNPOST_UP, HaywardMartVendingMachine
	signpost 1, 13, SIGNPOST_UP, HaywardMartVendingMachine
	signpost 1, 14, SIGNPOST_UP, HaywardMartVendingMachine
	signpost 1, 15, SIGNPOST_UP, HaywardMartVendingMachine

	;people-events
	db 2
	person_event SPRITE_LASS, 4, 9, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, HaywardMartF6NPC1, -1
	person_event SPRITE_YOUNGSTER, 5, 13, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, HaywardMartF6NPC2, -1
