SpurgeMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SpurgeMartSignpost1:
SpurgeMartSignpost2:
	opentext
	special Special_SpurgeMartBank
	endtext

SpurgeMartNPC1:
	faceplayer
	opentext
	pokemart 0, 2
	closetext
	end

SpurgeMartNPC2:
	faceplayer
	opentext
	pokemart 0, 3
	closetext
	end

SpurgeMartNPC3:
	faceplayer
	opentext
	pokemart 0, 4
	closetext
	end

SpurgeMartNPC4:
	faceplayer
	opentext
	pokemart 0, 4
	closetext
	end

SpurgeMartNPC5:
	jumptextfaceplayer SpurgeMartNPC5_Text_1779ed

SpurgeMartNPC6:
	faceplayer
	opentext
	writetext SpurgeMartNPC6_Text_177d90
	loadmenudata SpurgeGoldTokenMenuHeader
	verticalmenu
	closewindow
	anonjumptable
	dw .quit
	dw SpurgeMart_177c90
	dw SpurgeMart_177cb8
	dw SpurgeMart_177cd8
	dw .quit

.quit
	jumptext SpurgeMart_177c3c_Text_177eba

SpurgeGoldTokenMenuHeader:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw .GoldTokenMenu
	db 1 ; default option

.GoldTokenMenu:
	db $80 ; flags
	db 4 ; items
	db "Megaphone    (2)@"
	db "Protein      (2)@"
	db "ConfuseGuard (3)@"
	db "Cancel@"

SpurgeMartNPC7:
	opentext
	pokemart 0, 5
	closetext
	end

SpurgeMartNPC8:
	jumptextfaceplayer SpurgeMartNPC8_Text_1778fd

SpurgeMartNPC9:
	jumptextfaceplayer SpurgeMartNPC9_Text_17793f

SpurgeMartNPC10:
	jumptextfaceplayer SpurgeMartNPC10_Text_177885

SpurgeMartNPC11:
	jumptextfaceplayer SpurgeMartNPC11_Text_177ab3

SpurgeMartNPC12:
	jumptextfaceplayer SpurgeMartNPC12_Text_1778bb

SpurgeMartNPC13:
	jumptextfaceplayer SpurgeMartNPC13_Text_1777d0

SpurgeMartNPC14:
	jumptextfaceplayer SpurgeMartNPC14_Text_177a90

SpurgeMart_177c90:
	opentext
	writetext SpurgeMart_177c90_Text_177dea
	yesorno
	iffalse SpurgeMart_177c9e
	jump SpurgeMart_177ca3

SpurgeMart_177cb8:
	opentext
	writetext SpurgeMart_177c90_Text_177dea
	yesorno
	iffalse SpurgeMart_177c9e
	jump SpurgeMart_177cc6

SpurgeMart_177cd8:
	opentext
	writetext SpurgeMart_177cd8_Text_177e58
	yesorno
	iftrue SpurgeMart_177ce6

SpurgeMart_177c9e:
	jumptext SpurgeMart_177c3c_Text_177eba

SpurgeMart_177ca3:
	takeitem GOLD_TOKEN, 2
	iffalse SpurgeMart_177cb2
	verbosegiveitem MEGAPHONE, 1
	jumptext SpurgeMart_177ca3_Text_177e0a

SpurgeMart_177cc6:
	takeitem GOLD_TOKEN, 2
	iffalse SpurgeMart_177cb2
	verbosegiveitem PROTEIN, 1
	jumptext SpurgeMart_177ca3_Text_177e0a

SpurgeMart_177ce6:
	takeitem GOLD_TOKEN, 3
	iffalse SpurgeMart_177cb2
	givetm TM_SWAGGER + RECEIVED_TM
	jumptext SpurgeMart_177ca3_Text_177e0a

SpurgeMart_177cb2:
	jumptext SpurgeMart_177cb2_Text_177e22

SpurgeMartNPC5_Text_1779ed:
	ctxt "Come look around,"
	line "I have games 'o"
	cont "plenty here."

	para "If you see a game"
	line "you like, just"
	cont "let me know!"
	done

SpurgeMartNPC6_Text_177d90:
	ctxt "Welcome!"

	para "You can exchange"
	line "Gold Tokens you"
	cont "have found for"
	cont "prizes."
	para "Which one do you"
	line "want?"
	done

SpurgeMartNPC8_Text_1778fd:
	ctxt "Soda pop isn't"
	line "very healthy, but"
	cont "it costs less"
	cont "than water."
	done

SpurgeMartNPC9_Text_17793f:
	ctxt "Some very shady"
	line "guy all dressed"

	para "in red came by"
	line "to buy a meal."

	para "And when I say red"
	line "I MEAN RED!"

	para "Helmet, jumpsuit."
	line "All of it red."

	para "He refused to take"
	line "the helmet off, so"

	para "he ordered his"
	line "food to go."
	done

SpurgeMartNPC10_Text_177885:
	ctxt "This food court"
	line "never fails to"
	cont "fill my big belly"
	cont "up real good."
	done

SpurgeMartNPC11_Text_177ab3:
	ctxt "My Snorlax loves"
	line "these burgers too."

	para "He can eat a lot"
	line "more than me."
	done

SpurgeMartNPC12_Text_1778bb:
	ctxt "I hear the milk"
	line "they sell here is"
	cont "made in a small"
	cont "farm in Johto."
	done

SpurgeMartNPC13_Text_1777d0:
	ctxt "I'm trying to get"
	line "a return on a"
	cont "game I bought"
	cont "for my son."

	para "Who is 'Frigo'"
	line "anyway? Seriously?"

	para "And Pokemon Quartz"
	line "had a lot of"
	cont "profanity in it!"

	para "It was rated E"
	line "for Everyone too!"
	done

SpurgeMartNPC14_Text_177a90:
	ctxt "I can't decide"
	line "what to buy!"
	done

SpurgeMart_177c90_Text_177dea:
	ctxt "That'll be 2"
	line "tokens, you agree?"
	done

SpurgeMart_177cd8_Text_177e58:
	ctxt "That'll be 3"
	line "tokens, you agree?"
	done

SpurgeMart_177c3c_Text_177eba:
	ctxt "Alright then<...>"
	done

SpurgeMart_177ca3_Text_177e0a:
	ctxt "Thank you, come"
	line "again!"
	done

SpurgeMart_177cb2_Text_177e22:
	ctxt "You need more"
	line "tokens than that."
	done

SpurgeMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $23, $14, 8, SPURGE_CITY
	warp_def $23, $15, 8, SPURGE_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 9, 10, SIGNPOST_RIGHT, SpurgeMartSignpost1
	signpost 9, 11, SIGNPOST_LEFT, SpurgeMartSignpost2

	;people-events
	db 14
	person_event SPRITE_CLERK, 8, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SpurgeMartNPC1, -1
	person_event SPRITE_CLERK, 19, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeMartNPC2, -1
	person_event SPRITE_CLERK, 10, 35, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeMartNPC3, -1
	person_event SPRITE_CLERK, 12, 36, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeMartNPC4, -1
	person_event SPRITE_CLERK, 28, 1, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeMartNPC5, -1
	person_event SPRITE_CLERK, 24, 19, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeMartNPC6, -1
	person_event SPRITE_CLERK, 30, 38, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SpurgeMartNPC7, -1
	person_event SPRITE_GENTLEMAN, 10, 17, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SpurgeMartNPC8, -1
	person_event SPRITE_R_GAMBLER, 15, 24, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeMartNPC9, -1
	person_event SPRITE_FISHER, 11, 33, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeMartNPC10, -1
	person_event SPRITE_FISHER, 18, 28, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, 0, 0, SpurgeMartNPC11, -1
	person_event SPRITE_R_JRTRAINERM, 18, 5, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeMartNPC12, -1
	person_event SPRITE_TEACHER, 26, 4, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, SpurgeMartNPC13, -1
	person_event SPRITE_YOUNGSTER, 29, 19, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeMartNPC14, -1
