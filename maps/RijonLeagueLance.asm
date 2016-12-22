RijonLeagueLance_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RijonLeagueLanceNPC1:
	faceplayer
	opentext
	writetext RijonLeagueLanceNPC1_Text_2f4f2c
	waitbutton
	winlosstext RijonLeagueLanceNPC1Text_2f502d, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	checkcode VAR_BADGES
	if_greater_than 19, .rematch
	loadtrainer CHAMPION, 1
.battle
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext RijonLeagueLanceNPC1_Text_2f5092
	waitbutton
	special FadeOutPalettes
	wait 20
	warpfacing UP, RIJON_LEAGUE_PARTY, 11, 7
	opentext
	writetext RijonLeagueLanceNPC1_Text_2f515f
	waitbutton
	writetext RijonLeagueLanceNPC1_Text_2f51a8
	waitbutton
	writetext RijonLeagueLanceNPC1_Text_2f520b
	waitbutton

	checkevent EVENT_RIJON_LEAGUE_WON
	iftrue .givenPass
	writetext RijonLeagueLanceNPC1_Text_2f523f
	waitbutton
	verbosegiveitem RIJON_PASS, 1
	setevent EVENT_RIJON_LEAGUE_WON
.givenPass
	writetext RijonLeagueLanceNPC1_Text_2f5287
	waitbutton
	closetext
	special FadeOutPalettes
	;reset legendary spawns
	checkcode VAR_BADGES
	if_less_than 20, .dontresetlegendaries
	;birds
	writebyte PHANCERO
	special SpecialMonCheck
	iftrue .skipphancero
	clearevent EVENT_PHANCERO
.skipphancero
	writebyte ARTICUNO
	special SpecialMonCheck
	iftrue .skiparticuno
	clearevent EVENT_ARTICUNO
.skiparticuno
	writebyte ZAPDOS
	special SpecialMonCheck
	iftrue .skipzapdos
	clearevent EVENT_ZAPDOS
.skipzapdos
	writebyte MOLTRES
	special SpecialMonCheck
	iftrue .skipmoltres
	clearevent EVENT_MOLTRES
.skipmoltres
	;guardians
	writebyte FAMBACO
	special SpecialMonCheck
	iftrue .skipfambaco
	clearevent EVENT_FAMBACO
.skipfambaco
	writebyte LIBABEEL
	special SpecialMonCheck
	iftrue .skiplibabeel
	clearevent EVENT_LIBABEEL
.skiplibabeel
	writebyte RAIWATO
	special SpecialMonCheck
	iftrue .skipraiwato
	clearevent EVENT_RAIWATO
.skipraiwato
	writebyte VARANEOUS
	special SpecialMonCheck
	iftrue .skipvaraneous
	special InitRoamMons
.skipvaraneous
.dontresetlegendaries
	special HealParty
	wait 30
	warpfacing UP, RIJON_LEAGUE_CHAMPION_ROOM, 5, 10
	follow 2, PLAYER
	applymovement 2, .lanceWalksUp
	opentext
	writetext RijonLeagueLance_2f55f1_Text_2f5432
	writebyte 2
	special HealMachineAnim
	halloffame
	end

.lanceWalksUp
	step_up
	step_up
	step_up
	step_up
	step_left
	step_end

.rematch
	loadtrainer CHAMPION, 2
	jump .battle

RijonLeagueLanceNPC1_Text_2f4f2c:
	ctxt "My child!" 

	para "How I've missed"
	line "you." 

	para "When I heard about"
	line "the cave in, I"

	para "rushed to clear"
	line "all the under-"
	para "ground pathways to"
	line "search for you."

	para "I eventually"
	line "stumbled upon"

	para "Professor Ilk who'd"
	line "been studying the"

	para "strange seismic"
	line "activities within"

	para "the very same"
	line "caves!"

	para "He described to me"
	line "a young Trainer"

	para "who'd been trapped"
	line "on Naljo's side of"

	para "the mountains that"
	line "befriended a tiny"

	para "Larvitar and star-"
	line "ted up an"

	para "adventure in the"
	line "region." 

	para "When I discovered"
	line "it was you, my"

	para "heart swelled with"
	line "pride!" 

	para "I trusted that you"
	line "alone would"

	para "survive and"
	line "overcome whatever"

	para "obstacles lay"
	line "before you."

	para "I had to trust"
	line "that you alone"

	para "would make wise"
	line "decisions,"

	para "without needing my"
	line "guidance."

	para "Now that you've"
	line "come to challenge"

	para "me for my title,"
	line "I will do all I"

	para "can to make sure"
	line "that you earn this"
	cont "honor."

	done

RijonLeagueLanceNPC1Text_2f502d:
	ctxt "Amazing!"

	para "There is no one"
	line "I'd rather"

	para "relinquish my"
	line "title to than to"
	cont "you!"
	done

RijonLeagueLanceNPC1_Text_2f5092:
	ctxt "Your #mon"
	line "battle in a way"

	para "where they antic-"
	line "ipate all commands"

	para "you make while"
	line "trusting your"

	para "ability to read"
	line "the battlefield."

	para "Your potential is"
	line "limitless and it"

	para "will continue to"
	line "grow as you and"

	para "your #mon grow"
	line "old together."

	para "To think you've"
	line "defeated your old"

	para "man at such a"
	line "young age!"

	para "Let's head to the"
	line "Hall of Fame room"
	cont "right away!"

	para "<...>"

	para "There's something"
	line "else you'd like to"
	cont "do first?"

	para "<...><...><...>"

	para "Well<...>"
	line "OK."

	para "Anything for you."
	done

RijonLeagueLanceNPC1_Text_2f515f:
	ctxt "Mom: My! What an"
	line "adventure!"

	para "I'm relieved that"
	line "that you're back"
	cont "safe and sound."

	para "And becoming the"
	line "Rijon Champion<...>"

	para "You're just like"
	line "your father!"
	done

RijonLeagueLanceNPC1_Text_2f51a8:
	ctxt "Lance: Yes,"
	line "<PLAYER> learned"

	para "a lot on that"
	line "adventure."

	para "I've forgotten all"
	line "about my Naljo"
	cont "ancestry."

	para "I've just been so"
	line "busy<...>"

	para "<...>but I need"
	line "to do what I"

	para "can to keep Naljo"
	line "safe."

	para "The guardians are"
	line "still experiencing"
	para "an unfamiliar"
	line "Naljo."

	para "I don't want them"
	line "to harm anyone."

	para "I know some people"
	line "in Rijon who may"
	para "be able to help"
	line "us."
	done

RijonLeagueLanceNPC1_Text_2f520b:
	ctxt "Mom: That's very"
	line "noble of you."

	para "Maybe you've"
	line "changed after all."
	done

RijonLeagueLanceNPC1_Text_2f523f:
	ctxt "Lance: Let's meet"
	line "up in Rijon when"
	para "you get the"
	line "chance."

	para "I'll be at the"
	line "Power Plant."

	para "This pass will"
	line "let you take the"
	cont "tunnel to Rijon."
	done

RijonLeagueLanceNPC1_Text_2f5287:
	ctxt "Lance: <PLAYER>."

	para "Just let me know"
	line "when you want to"

	para "visit the Hall of"
	line "Fame room."

	para "But I can tell<...>"

	para "<...>that you're not"
	line "in any rush."

	para "No worries."

	para "We have all the"
	line "time in the world<...>"
	done

RijonLeagueLance_2f55f1_Text_2f5432:
	ctxt "All the Trainers"
	line "who have earned"

	para "the honor to be"
	line "Rijon's Champion"

	para "have been entered"
	line "in this computer."

	para "Now you, my child,"
	line "will immortalize"

	para "yourself and the"
	line "#mon who've"

	para "fought by your"
	line "side in the"

	para "history of Rijon's"
	line "Pokemon League."
	done

RijonLeagueLance_MapEventHeader:: db 0, 0

.Warps: db 1
	warp_def 19, 3, 1, INTRO_OUTSIDE

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 1
	person_event SPRITE_LANCE, 3, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, RijonLeagueLanceNPC1, -1
