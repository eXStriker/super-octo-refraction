Route81_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, Route81Bridge

Route81Bridge:
	checkevent EVENT_BUILT_BRIDGE
	iffalse .noBridge
	changeblock 6, 12, $f
	changeblock 8, 12, $f
	changeblock 6, 14, $f
	changeblock 8, 14, $f
.noBridge
	return

Route81Signpost1:
	ctxt "<UP> Acania Docks"
	next "<LEFT> Naljo Park"
	next "<RIGHT> Route 80"
	done ;36

Route81Signpost2:
	jumpstd pokecentersign

Route81_Trainer_1:
	trainer EVENT_ROUTE_81_TRAINER_1, BIRD_KEEPER, 4, Route81_Trainer_1_Text_128016, Route81_Trainer_1_Text_128037, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route81_Trainer_1_Script_Text_12805e

Route81_Trainer_2:
	trainer EVENT_ROUTE_81_TRAINER_2, BLACKBELT_T, 6, Route81_Trainer_2_Text_12b2c8, Route81_Trainer_2_Text_12b2f9, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route81_Trainer_2_Script_Text_12b300

Route81_Trainer_3:
	trainer EVENT_ROUTE_81_TRAINER_3, PICNICKER, 5, Route81_Trainer_3_Text_12b215, Route81_Trainer_3_Text_12b255, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route81_Trainer_3_Script_Text_12b266

Route81_Trainer_4:
	trainer EVENT_ROUTE_81_TRAINER_4, PICNICKER, 8, Route81_Trainer_4_Text_12b163, Route81_Trainer_4_Text_12b1aa, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route81_Trainer_4_Script_Text_12b1c8

Route81_Trainer_5:
	trainer EVENT_ROUTE_81_TRAINER_5, SUPER_NERD, 3, Route81_Trainer_5_Text_12b0a7, Route81_Trainer_5_Text_12b10f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route81_Trainer_5_Script_Text_12b119

Route81NPC1:
	faceplayer
	opentext
	checkevent EVENT_ROUTE_81_TM32
	iftrue Route81_12b35e
	writetext Route81NPC1_Text_12b364
	waitbutton
	givetm 32 + RECEIVED_TM
	iffalse .full
	setevent EVENT_ROUTE_81_TM32
.full
	closetext
	end

Route81NPC2:
	fruittree 21

Route81_Item_1:
	db DAMP_ROCK, 1

Route81NPC3:
	faceplayer
	opentext
	checkevent EVENT_NOBU_EXPLAINS_PROTECTORS
	iffalse Route81_12a4ff
	checkevent EVENT_BUILT_BRIDGE
	iftrue Route81_12a505
	checkitem BRICK_PIECE
	iftrue Route81_12a517
	jumptext Route81NPC3_Text_12a565

Route81_12b35e:
	jumptext Route81_12b35e_Text_12b3bb

Route81_12a4ff:
	jumptext Route81_12a4ff_Text_12a672

Route81_12a505:
	jumptext Route81_12a505_Text_12a704

Route81_12a517:
	writetext Route81_12a517_Text_12a7b1
	yesorno
	iffalse Route81_12a50b
	takeitem BRICK_PIECE, 20
	iffalse Route81_12a511
	setevent EVENT_BUILT_BRIDGE
	writetext Route81_12a517_Text_12a7fe
	special ClearBGPalettes
	special Special_BattleTowerFade
	playwaitsfx SFX_GRASS_RUSTLE
	playwaitsfx SFX_VICEGRIP
	playwaitsfx SFX_DOUBLE_KICK
	playwaitsfx SFX_DOUBLESLAP
	playwaitsfx SFX_STOMP
	scall Route81Bridge
	reloadmap
	special FadeInPalettes
	jumptext Route81_12a517_Text_12a81a

Route81_12a50b:
	jumptext Route81_12a50b_Text_12a738

Route81_12a511:
	jumptext Route81_12a511_Text_12a754

Route81_Trainer_1_Text_128016:
	ctxt "My bird #mon"
	line "can fly me across!"
	done

Route81_Trainer_1_Text_128037:
	ctxt "Guess they can't"
	line "help me win a"
	cont "battle, though."
	done

Route81_Trainer_1_Script_Text_12805e:
	ctxt "Construction on"
	line "the bridge isn't"
	cont "done yet<...>"

	para "Thankfully, my"
	line "#mon can help"
	cont "me get across."
	done

Route81_Trainer_2_Text_12b2c8:
	ctxt "HAAAAAAAAAAAAAAAAA"
	line "AAAAAAAAAAAAAAAAA!"

	para "<...>"

	para "I'm training to"
	line "one day become"
	cont "Andre's disciple!"
	done

Route81_Trainer_2_Text_12b2f9:
	ctxt "WHAT?"
	done

Route81_Trainer_2_Script_Text_12b300:
	ctxt "I carved this path"
	line "with my own hands."

	para "That must impress"
	line "my idol, right?!"
	done

Route81_Trainer_3_Text_12b215:
	ctxt "Going north would"
	line "lead you straight"
	para "to Acania if the"
	line "bridge wasn't out."
	done

Route81_Trainer_3_Text_12b255:
	ctxt "That was harsh!"
	done

Route81_Trainer_3_Script_Text_12b266:
	ctxt "If you can find"
	line "HM03, for Surf,"

	para "you can ride your"
	line "#mon as it swim"
	cont "through the sea!"
	done

Route81_Trainer_4_Text_12b163:
	ctxt "This used to be my"
	line "favorite picnic"
	para "spot, until they"
	line "built that stupid"
	cont "#mon Center<...>"
	done

Route81_Trainer_4_Text_12b1aa:
	ctxt "Well, they were"
	line "intimidated."
	done

Route81_Trainer_4_Script_Text_12b1c8:
	ctxt "The construction"
	line "of that #mon"
	cont "Center really"
	para "scared my poor"
	line "#mon."
	done

Route81_Trainer_5_Text_12b0a7:
	ctxt "I heard there's"
	line "scientists who"
	para "want to enhance"
	line "natural abilities"
	cont "of #mon."

	para "That's so cool."
	done

Route81_Trainer_5_Text_12b10f:
	ctxt "Really?!"
	done

Route81_Trainer_5_Script_Text_12b119:
	ctxt "I could sure use"
	line "the help of those"
	cont "smarter than me."
	done

Route81NPC1_Text_12b364:
	ctxt "I thought my"
	line "#mon would team"

	para "up when using this"
	line "move, but I was"
	cont "very mistaken!"

	para "Here, take it!"
	done

Route81NPC3_Text_12a565:
	ctxt "OK, so<...> Lance is"
	line "your father, and"
	para "you need to get"
	line "up there to stop"
	para "crazy #mon"
	line "from possibly"
	cont "destroying Naljo?"

	para "Uh, OK."
	line "Sounds legit."

	para "I'll need 20"
	line "Brick Pieces to"
	para "prop up the dock"
	line "from the bottom,"

	para "otherwise it"
	line "could break."

	para "There's a mart"
	line "that sells them<...>"

	para "I'm not so sure"
	line "where though<...>"
	done

Route81_12b35e_Text_12b3bb:
	ctxt "TM32 is called"
	line "Double Team."

	para "Don't let the"
	line "name fool you,"
	para "it only raises"
	line "evasiveness."
	done

Route81_12a4ff_Text_12a672:
	ctxt "I'm supposed to"
	line "finish building"
	cont "this bridge<...>"

	para "I'm way too tired"
	line "to work, though."

	para "You'd have to"
	line "give me a good"
	para "reason why this"
	line "bridge needs to"
	cont "be built now."
	done

Route81_12a505_Text_12a704:
	ctxt "I built your"
	line "bridge, now"

	para "please stop"
	line "bothering me."
	done

Route81_12a517_Text_12a7b1:
	ctxt "So you have some"
	line "bricks?"

	para "Want to give them"
	line "to me so I can"
	cont "build the bridge?"
	done

Route81_12a517_Text_12a7fe:
	ctxt "Good, time to get"
	line "to work!"
	prompt

Route81_12a517_Text_12a81a:
	ctxt "How invigorating!"

	para "Well that's my"
	line "workout for the"
	cont "week."

	para "I'm done, bye."
	done

Route81_12a50b_Text_12a738:
	ctxt "Then stop wasting"
	line "my time."
	done

Route81_12a511_Text_12a754:
	ctxt "I need TWENTY."

	para "Let me spell that"
	line "out for you."

	para "T"

	para "W"

	para "E<...>"

	para "Don't facepalm"
	line "while I'm talking"
	cont "to you!"
	done

Route81_MapEventHeader:: db 0, 0

.Warps: db 7
	warp_def 9, 7, 3, ROUTE_81_NORTHGATE
	warp_def 58, 4, 3, PROVINCIAL_PARK_GATE
	warp_def 58, 13, 1, ROUTE_81_EASTGATE
	warp_def 59, 4, 4, PROVINCIAL_PARK_GATE
	warp_def 59, 13, 2, ROUTE_81_EASTGATE
	warp_def 47, 6, 1, ROUTE_81_POKECENTER
	warp_def 43, 17, 1, ROUTE_81_GOODROD

.CoordEvents: db 0

.BGEvents: db 2
	signpost 56, 8, SIGNPOST_LOAD, Route81Signpost1
	signpost 47, 7, SIGNPOST_READ, Route81Signpost2

.ObjectEvents: db 9
	person_event SPRITE_BIRDKEEPER, 22, 6, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, 2, 2, Route81_Trainer_1, -1
	person_event SPRITE_BLACK_BELT, 28, 7, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 2, Route81_Trainer_2, -1
	person_event SPRITE_PICNICKER, 37, 10, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 1, Route81_Trainer_3, -1
	person_event SPRITE_PICNICKER, 43, 3, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 3, Route81_Trainer_4, -1
	person_event SPRITE_COOLTRAINER_M, 49, 12, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 4, Route81_Trainer_5, -1
	person_event SPRITE_BIRDKEEPER, 29, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, Route81NPC1, -1
	person_event SPRITE_FRUIT_TREE, 34, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route81NPC2, -1
	person_event SPRITE_POKE_BALL, 11, 9, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, Route81_Item_1, EVENT_ROUTE_81_ITEM_1
	person_event SPRITE_BLACK_BELT, 16, 8, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route81NPC3, -1
