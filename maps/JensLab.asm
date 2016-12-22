JensLab_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

JensLabNPC1:
	faceplayer
	opentext
	checkevent EVENT_PROF_JEN_INTRO
	iffalse JensLab_2f027f
	copybytetovar wRijonBadges
	if_not_equal $ff, JensLab_2f0288
	checkevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	iffalse JensLab_2f028e
	jumptext JensLabNPC1_Text_2f02a5

JensLabNPC2:
	checkevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	iffalse JensLab_2f076e
	checkevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	iffalse JensLab_2f0775
	jumptext JensLabNPC2_Text_2f07b3

JensLabNPC3:
	checkevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	iffalse JensLab_2f06a9
	checkevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	iffalse JensLab_2f06b0
	jumptext JensLabNPC3_Text_2f06ee

JensLabNPC4:
	checkevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	iffalse JensLab_2f05e1
	checkevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	iffalse JensLab_2f05e8
	jumptext JensLabNPC4_Text_2f0626

JensLabNPC5:
	faceplayer
	opentext
	checkevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	iffalse JensLab_2f0a4b
	checkevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	iffalse JensLab_2f0a2d
	checkevent EVENT_PROF_JEN_PROF_1
	iftrue JensLab_2f0a51
	writetext JensLabNPC5_Text_2f0876
	yesorno
	iftrue JensLab_2f0a33
	jumptext JensLabNPC5_Text_2f0905

JensLabNPC6:
	faceplayer
	opentext
	checkevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	iffalse JensLab_2f086a
	checkevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	iffalse JensLab_2f084c
	checkevent EVENT_PROF_JEN_PROF_2
	iftrue JensLab_2f0870
	writetext JensLabNPC5_Text_2f0876
	yesorno
	iftrue JensLab_2f0852
	jumptext JensLabNPC5_Text_2f0905

JensLab_2f027f:
	setevent EVENT_PROF_JEN_INTRO
	jumptext JensLab_2f027f_Text_2f032c

JensLab_2f0288:
	jumptext JensLab_2f0288_Text_2f0471

JensLab_2f028e:
	writetext JensLab_2f028e_Text_2f04b5
	waitbutton
	verbosegiveitem FERRY_TICKET, 1
	setevent EVENT_PROF_JEN_GIVEN_FERRY_TICKET
	jumptext JensLab_2f028e_Text_2f054a

JensLab_2f076e:
	jumptext JensLabNPC2_Text_2f07b3

JensLab_2f0775:
	refreshscreen 0
	pokepic CHARMANDER
	cry CHARMANDER
	waitbutton
	closepokepic
	opentext
	writetext JensLab_2f0775_Text_2f07c5
	yesorno
	iftrue JensLab_2f0788
	closetext
	end

JensLab_2f06a9:
	jumptext JensLabNPC3_Text_2f06ee

JensLab_2f06b0:
	refreshscreen 0
	pokepic SQUIRTLE
	cry SQUIRTLE
	waitbutton
	closepokepic
	opentext
	writetext JensLab_2f06b0_Text_2f0701
	yesorno
	iftrue JensLab_2f06c3
	closetext
	end

JensLab_2f05e1:
	jumptext JensLabNPC4_Text_2f0626

JensLab_2f05e8:
	refreshscreen 0
	pokepic BULBASAUR
	cry BULBASAUR
	waitbutton
	closepokepic
	opentext
	writetext JensLab_2f05e8_Text_2f063a
	yesorno
	iftrue JensLab_2f05fb
	closetext
	end

JensLab_2f0a4b:
	jumptext JensLab_2f0a4b_Text_2f0992

JensLab_2f0a2d:
	jumptext JensLab_2f0a2d_Text_2f0929

JensLab_2f0a51:
	jumptext JensLab_2f0a51_Text_2f09e8

JensLab_2f0a33:
	takeitem GOLD_TOKEN, 8
	iffalse JensLab_2f0a45
	clearevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	setevent EVENT_PROF_JEN_PROF_1
	jumptext JensLab_2f0a33_Text_2f0950

JensLab_2f086a:
	jumptext JensLab_2f0a4b_Text_2f0992

JensLab_2f084c:
	jumptext JensLab_2f0a2d_Text_2f0929

JensLab_2f0870:
	jumptext JensLab_2f0a51_Text_2f09e8

JensLab_2f0852:
	takeitem GOLD_TOKEN, 8
	iffalse JensLab_2f0864
	clearevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	setevent EVENT_PROF_JEN_PROF_2
	writetext JensLab_2f0a33_Text_2f0950
	endtext

JensLab_2f0788:
	checkcode VAR_PARTYCOUNT
	if_equal 6, JensLab_2f07a7
	jump JensLab_2f078e

JensLab_2f06c3:
	checkcode VAR_PARTYCOUNT
	if_equal 6, JensLab_2f06e2
	jump JensLab_2f06c9

JensLab_2f05fb:
	checkcode VAR_PARTYCOUNT
	if_equal 6, JensLab_2f061a
	jump JensLab_2f0601

JensLab_2f0a45:
	jumptext JensLab_2f0a45_Text_2f0974

JensLab_2f0864:
	jumptext JensLab_2f0a45_Text_2f0974

JensLab_2f07a7:
	checkcode VAR_BOXSPACE
	iftrue JensLab_2f078e
	jumptext JensLab_2f07a7_Text_2f07f9

JensLab_2f06e2:
	checkcode VAR_BOXSPACE
	iftrue JensLab_2f06c9
	jumptext JensLab_2f07a7_Text_2f07f9

JensLab_2f061a:
	checkcode VAR_BOXSPACE
	iftrue JensLab_2f0601
	jumptext JensLab_2f07a7_Text_2f07f9

JensLab_2f078e:
	disappear 3
	opentext
	writetext JensLab_2f0788_Text_2f07e1
	playwaitsfx SFX_DEX_FANFARE_80_109
	givepoke CHARMANDER, 5, NO_ITEM, 0
	setevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	setevent EVENT_PROF_JEN_CHARMANDER
	closetext
	end

JensLab_2f06c9:
	disappear 4
	opentext
	writetext JensLab_2f06c3_Text_2f071b
	playwaitsfx SFX_DEX_FANFARE_80_109
	givepoke SQUIRTLE, 5, NO_ITEM, 0
	setevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	setevent EVENT_PROF_JEN_SQUIRTLE
	closetext
	end

JensLab_2f0601:
	disappear 5
	opentext
	writetext JensLab_2f05fb_Text_2f0655
	playwaitsfx SFX_DEX_FANFARE_80_109
	givepoke BULBASAUR, 5, NO_ITEM, 0
	setevent EVENT_PROF_JEN_PICKED_UP_FREE_POKE
	setevent EVENT_PROF_JEN_BULBASAUR
	closetext
	end

JensLabNPC1_Text_2f02a5:
	ctxt "There's always"
	line "new and amazing"

	para "discoveries about"
	line "#mon to find!"

	para "I hope one day"
	line "I'll be a #mon"

	para "professor that's"
	line "as smart as my"
	cont "grandfather!"
	done

JensLabNPC2_Text_2f07b3:
	ctxt "It's a red"
	line "#ball!"
	done

JensLabNPC3_Text_2f06ee:
	ctxt "It's a blue"
	line "#ball!"
	done

JensLabNPC4_Text_2f0626:
	ctxt "It's a green"
	line "#ball!"
	done

JensLabNPC5_Text_2f0876:
	ctxt "I am Prof Tim's"
	line "aide as well as"
	para "a collector of"
	line "Gold Tokens."

	para "If you give me"
	line "eight, I'll let"
	para "you have one of"
	line "those #mon on"
	cont "that table."

	para "Up for it?"
	done

JensLabNPC5_Text_2f0905:
	ctxt "How could you say"
	line "no to new #mon?"
	done

JensLab_2f027f_Text_2f032c:
	ctxt "Hello they call"
	line "me Jen, Prof."

	para "Tim's assistant"
	line "intern."

	para "Prof. Tim's been"
	line "away for a while"

	para "so I've taken over"
	line "his research for"
	cont "now."

	para "Oh you're the"
	line "newest Rijon"
	cont "league champion?"

	para "I actually know"
	line "of a secret battle"

	para "retreat called the"
	line "Battle Arcade."

	para "If you collect all"
	line "8 Rijon badges, I"

	para "will give you a"
	line "ticket there."

	para "Good luck!"
	done

JensLab_2f0288_Text_2f0471:
	ctxt "Hi there!"

	para "Still don't have"
	line "all the Rijon"
	cont "badges?"

	para "Well don't give up!"
	done

JensLab_2f028e_Text_2f04b5:
	ctxt "Amazing!"

	para "You were able to"
	line "collect all of"
	cont "the Rijon badges!"

	para "Take this ticket,"
	line "head to Castro"

	para "Valley's port and"
	line "take the ship to"
	cont "the battle arcade."
	done

JensLab_2f028e_Text_2f054a:
	ctxt "I'll also let you"
	line "have one of these"

	para "newly hatched"
	line "#mon."

	para "A Trainer as"
	line "skillful as"

	para "yourself should"
	line "be able to raise"

	para "one of them"
	line "right!"
	done

JensLab_2f0775_Text_2f07c5:
	ctxt "It's a Charmander!"

	para "Want it?"
	done

JensLab_2f06b0_Text_2f0701:
	ctxt "It's a Squirtle!"

	para "Want it?"
	done

JensLab_2f05e8_Text_2f063a:
	ctxt "It's a Bulbasaur!"

	para "Want it?"
	done

JensLab_2f0a4b_Text_2f0992:
	ctxt "I am Prof Tim's"
	line "aide."

	para "I might have an"
	line "offer for you"

	para "after you impress"
	line "Jen over there."
	done

JensLab_2f0a2d_Text_2f0929:
	ctxt "Pick up your gift"
	line "first!"
	done

JensLab_2f0a51_Text_2f09e8:
	ctxt "Thanks for the"
	line "tokens my good"
	cont "man!"
	done

JensLab_2f0a33_Text_2f0950:
	ctxt "Great, now pick"
	line "one off of the"
	cont "table!"
	done

JensLab_2f0788_Text_2f07e1:
	ctxt "<PLAYER> received"
	line "Charmander!"
	done

JensLab_2f06c3_Text_2f071b:
	ctxt "<PLAYER> received"
	line "Squirtle!"
	done

JensLab_2f05fb_Text_2f0655:
	ctxt "<PLAYER> received"
	line "Bulbasaur!"
	done

JensLab_2f0a45_Text_2f0974:
	ctxt "Not enough, come"
	line "back later."
	done

JensLab_2f07a7_Text_2f07f9:
	ctxt "Free up some"
	line "space in either"

	para "your party or"
	line "box!"
	done

JensLab_2f061a_Text_2f066c:
	ctxt "Free up some"
	line "space in either"
	para "your party or"
	line "box!"
	done

JensLab_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $b, $4, 3, GRAVEL_TOWN
	warp_def $b, $5, 3, GRAVEL_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 6
	person_event SPRITE_DAISY, 2, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, JensLabNPC1, -1
	person_event SPRITE_POKE_BALL, 3, 8, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, JensLabNPC2, EVENT_PROF_JEN_CHARMANDER
	person_event SPRITE_POKE_BALL, 3, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, JensLabNPC3, EVENT_PROF_JEN_SQUIRTLE
	person_event SPRITE_POKE_BALL, 3, 6, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, JensLabNPC4, EVENT_JENS_LAB_NPC_4
	person_event SPRITE_SCIENTIST, 9, 8, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, JensLabNPC5, -1
	person_event SPRITE_SCIENTIST, 9, 1, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, JensLabNPC6, -1
