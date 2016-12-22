SpurgeGymB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SpurgeGymB1FSignpost1:
	checkevent EVENT_SPURGE_GYM_PUSHROCK
	iftrue .alreadyPressed
	opentext
	writetext SpurgeGymB1FSignpost1_Text_2ff25d
	playwaitsfx SFX_EGG_BOMB
	disappear 3
	setevent EVENT_SPURGE_GYM_PUSHROCK
	closetext
	end

.alreadyPressed:
	jumptext SpurgeGymB1FSignpost1_Text_ButtonAlreadyPressed

SpurgeGymB1F_Pokemon:
	setevent EVENT_SPURGE_GYM_POKEMON_3
	jump SpurgeGymGetPokemon

SpurgeGymB1F_Pokemon2:
	setevent EVENT_SPURGE_GYM_POKEMON_6
	jump SpurgeGymGetPokemon

SpurgeGymB1FNPC1:
	jumptext SpurgeGymB1FNPC1_Text_2ff279

SpurgeGymB1FNPC2:
	faceplayer
	checkcode VAR_PARTYCOUNT
	iffalse SpurgeGymB1F_2fdd6d
	opentext
	writetext SpurgeGymB1FNPC2_Text_2fdd71
	waitbutton
	winlosstext SpurgeGymB1FNPC2Text_2fdd94, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer CADENCE, 2
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SpurgeGymB1FNPC2_Text_2fddb6
	waitbutton
	closetext
	setevent EVENT_SPURGE_GYM_B1F_NPC_2
	playsound SFX_WARP_FROM
	applymovement 4, SpurgeGymB1FNPC2_Movement1
	disappear 4
	end

SpurgeGymB1FNPC2_Movement1:
	teleport_from
	remove_person
	step_end

SpurgeGymB1FNPC3:
	faceplayer
	opentext
	checkcode VAR_PARTYCOUNT
	if_less_than 1, SpurgeGymB1F_2ff377
	writetext SpurgeGymB1FNPC3_Text_2ff37d
	waitbutton
	winlosstext SpurgeGymB1FNPC3Text_2ff3b4, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer JOSIAH, 2
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SpurgeGymB1FNPC3_Text_2ff3d0
	waitbutton
	closetext
	setevent EVENT_SPURGE_GYM_B1F_NPC_3
	playsound SFX_WARP_FROM
	applymovement 5, SpurgeGymB1FNPC3_Movement1
	disappear 5
	end

SpurgeGymB1FNPC3_Movement1:
	teleport_from
	remove_person
	step_end

SpurgeGymB1FNPC4:
	faceplayer
	checkcode VAR_PARTYCOUNT
	if_equal 0, SpurgeGymB1F_2fc3f2
	opentext
	writetext SpurgeGymB1FNPC4_Text_2fc3f6
	waitbutton
	winlosstext SpurgeGymB1FNPC4Text_2fc4a8, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer EDISON, 2
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SpurgeGymB1FNPC4_Text_2fc4d1
	waitbutton
	closetext
	setevent EVENT_SPURGE_GYM_B1F_NPC_4
	playsound SFX_WARP_FROM
	applymovement 6, SpurgeGymB1FNPC4_Movement1
	disappear 6
	end

SpurgeGymB1FNPC4_Movement1:
	teleport_from
	remove_person
	step_end

SpurgeGymB1FNPC5:
	faceplayer
	checkcode VAR_PARTYCOUNT
	if_equal 0, SpurgeGymB1F_2fdbc2
	opentext
	writetext SpurgeGymB1FNPC5_Text_2fdbc6
	waitbutton
	winlosstext SpurgeGymB1FNPC5Text_2fdc63, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer RINJI, 2
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SpurgeGymB1FNPC5_Text_2fdc6f
	waitbutton
	closetext
	setevent EVENT_SPURGE_GYM_B1F_NPC_5
	playsound SFX_WARP_FROM
	applymovement 7, SpurgeGymB1FNPC5_Movement1
	disappear 7
	end

SpurgeGymB1FNPC5_Movement1:
	teleport_from
	remove_person
	step_end

SpurgeGymB1FNPC6:
	opentext
	takeitem DYNAMITE
	iftrue SpurgeGymB1F_2ff2b9
	jumptext SpurgeGymB1FNPC6_Text_2ff2cd

SpurgeGymB1F_Item_2:
	db DYNAMITE, 1

SpurgeGymB1F_2fdd6d:
	jumptext SpurgeGymB1F_2fdd6d_Text_2fde02

SpurgeGymB1F_2ff377:
	jumptext SpurgeGymB1F_2ff377_Text_2ff432

SpurgeGymB1F_2fc3f2:
	jumptext SpurgeGymB1F_2fc3f2_Text_2fc521

SpurgeGymB1F_2fdbc2:
	jumptext SpurgeGymB1F_2fdbc2_Text_2fdd11

SpurgeGymB1F_2ff2b9:
	writetext SpurgeGymB1F_2ff2b9_Text_2ff301
	waitbutton
	closetext
	applymovement 0, SpurgeGymB1F_2ff2b9_Movement1
	disappear 8
	playwaitsfx SFX_EGG_BOMB
	setevent EVENT_SPURGE_GYM_SMASHROCK
	end

SpurgeGymB1F_2ff2b9_Movement1:
	run_step_right
	run_step_right
	run_step_right
	run_step_down
	run_step_down
	run_step_down
	run_step_right
	run_step_right
	run_step_right
	step_end

SpurgeGymB1FSignpost1_Text_2ff25d:
	ctxt "Pressed the"
	line "button!"
	done

SpurgeGymB1FSignpost1_Text_ButtonAlreadyPressed:
	ctxt "The button has"
	line "already been"
	cont "pressed."
	done

SpurgeGymB1FNPC1_Text_2ff279:
	ctxt "There should be a"
	line "way to move this"
	cont "without a #mon."
	done

SpurgeGymB1FNPC2_Text_2fdd71:
	ctxt "YOU!"

	para "Every time a Gym"
	line "Leader loses, a"

	para "bit of respect"
	line "goes straight down"
	cont "the drain." 

	para "I'mma get you"
	line "back, this time"

	para "with EVERYTHING"
	line "I'VE GOT!"
	done

SpurgeGymB1FNPC2Text_2fdd94:
	ctxt "Noo! Not again!"
	done

SpurgeGymB1FNPC2_Text_2fddb6:
	ctxt "Once again you've"
	line "knocked down my"
	cont "Gym's prestige." 
	done

SpurgeGymB1FNPC3_Text_2ff37d:
	ctxt "How you doin' my"
	line "main man!"

	para "You may have"
	line "toasted me back"

	para "when you were just"
	line "a newbie, but I"

	para "think it was just"
	line "beginner's luck."

	para "I'm packing the"
	line "heat forrealz this"
	cont "time, bet on it!"
	done

SpurgeGymB1FNPC3Text_2ff3b4:
	ctxt "You're packin some"
	line "serious heat dude!"
	done

SpurgeGymB1FNPC3_Text_2ff3d0:
	ctxt "Ah, burned again<...>"
	done

SpurgeGymB1FNPC4_Text_2fc3f6:
	ctxt "A battle is a"
	line "battle and a de-"
	cont "feat is a defeat."

	para "I've reviewed,"
	line "calculated, and"

	para "planned brand new"
	line "strategies to beat"

	para "your very unique"
	line "battling style."

	para "I will not be"
	line "defeated again!"
	done

SpurgeGymB1FNPC4Text_2fc4a8:
	ctxt "But-how?!"
	done

SpurgeGymB1FNPC4_Text_2fc4d1:
	ctxt "How could I have"
	line "been so foolish!"

	para "There must have"
	line "been an opening<...> "
	cont "but where?"
	done

SpurgeGymB1FNPC5_Text_2fdbc6:
	ctxt "Greetings." 

	para "It's been a while." 

	para "I can tell by the"
	line "way the world vib-"

	para "rates around you"
	line "that you and your" 

	para "#mon have grown"
	line "so much stronger"

	para "because of your"
	line "unique bond."

	para "Let's test that"
	line "bond properly."
	done

SpurgeGymB1FNPC5Text_2fdc63:
	ctxt "Seeing the growth"
	line "of a bond between" 

	para "#mon and"
	line "Trainer is such an"

	para "immensely humbling"
	line "experience!"
	done

SpurgeGymB1FNPC5_Text_2fdc6f:
	ctxt "Pleasant journeys"
	line "my friend!"
	done

SpurgeGymB1FNPC6_Text_2ff2cd:
	ctxt "There should be a"
	line "way to move this"
	cont "without a #mon."
	done

SpurgeGymB1F_2fdd6d_Text_2fde02:
	ctxt "Hang on a sec!"

	para "You can't battle"
	line "me without a"
	cont "#mon! on you!"
	done

SpurgeGymB1F_2ff377_Text_2ff432:
	ctxt "Whoa hold on a"
	line "sec, you can't"
	cont "battle me unless"
	cont "you have a"
	cont "#mon on you!"
	done

SpurgeGymB1F_2fc3f2_Text_2fc521:
	ctxt "I'm sorry, but"
	line "you need at least"
	cont "one #mon to"
	cont "battle with me!"
	done

SpurgeGymB1F_2fdbc2_Text_2fdd11:
	ctxt "I'm sorry, but"
	line "you need at least"
	cont "one #mon to"
	cont "battle with me!"
	done

SpurgeGymB1F_2ff2b9_Text_2ff301:
	ctxt "Placed the dyna-"
	line "mite on the rock"
	cont "and lit it up!"

	para "Stand back!"
	done

SpurgeGymB1F_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 37, 25, 1, SPURGE_GYM_HOUSE
	warp_def 29, 9, 1, SPURGE_GYM_B2F_SIDESCROLL
	warp_def 17, 31, 2, SPURGE_GYM_B2F
	warp_def 7, 37, 3, SPURGE_GYM_B2F
	warp_def 5, 7, 4, SPURGE_GYM_B2F

.CoordEvents: db 0

.BGEvents: db 1
	signpost 27, 37, SIGNPOST_READ, SpurgeGymB1FSignpost1

.ObjectEvents: db 9
	person_event SPRITE_POKE_BALL, 10, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymB1F_Pokemon, EVENT_SPURGE_GYM_POKEMON_3
	person_event SPRITE_BOULDER, 29, 19, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SpurgeGymB1FNPC1, EVENT_SPURGE_GYM_PUSHROCK
	person_event SPRITE_PRYCE, 8, 20, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeGymB1FNPC2, EVENT_SPURGE_GYM_B1F_NPC_2
	person_event SPRITE_FALKNER, 27, 32, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymB1FNPC3, EVENT_SPURGE_GYM_B1F_NPC_3
	person_event SPRITE_MORTY, 6, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeGymB1FNPC4, EVENT_SPURGE_GYM_B1F_NPC_4
	person_event SPRITE_BUGSY, 8, 37, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SpurgeGymB1FNPC5, EVENT_SPURGE_GYM_B1F_NPC_5
	person_event SPRITE_ROCK, 33, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SpurgeGymB1FNPC6, EVENT_SPURGE_GYM_SMASHROCK
	person_event SPRITE_POKE_BALL, 26, 19, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, SpurgeGymB1F_Item_2, EVENT_SPURGE_GYM_B1F_ITEM_2
	person_event SPRITE_POKE_BALL, 8, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymB1F_Pokemon2, EVENT_SPURGE_GYM_POKEMON_6
