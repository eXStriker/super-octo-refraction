LaurelForestMain_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelForestMainNPC2:
	jumptext LaurelForestMainNPC2_Text_1367fb

LaurelForestMain_Trainer_1:
	trainer EVENT_LAUREL_FOREST_MAIN_TRAINER_1, BUG_CATCHER, 3, LaurelForestMain_Trainer_1_Text_137384, LaurelForestMain_Trainer_1_Text_1373a1, $0000, .Script

.Script:
	end_if_just_battled
	jumptext LaurelForestMain_Trainer_1_Script_Text_1373bd

LaurelForestMain_Trainer_2:
	trainer EVENT_LAUREL_FOREST_MAIN_TRAINER_2, BUG_CATCHER, 4, LaurelForestMain_Trainer_2_Text_13743d, LaurelForestMain_Trainer_2_Text_13748b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext LaurelForestMain_Trainer_2_Script_Text_1374c5

LaurelForestMainNPC1:
	opentext
	writetext LaurelForestMain_137300_Text_1367d0
	yesorno
	closetext
	iffalse .end
	checkevent EVENT_POKEONLY_FINISHED_CATERPIE_QUEST
	iftrue .finishedCaterpieQuest
	clearevent EVENT_POKEONLY_CATERPIE_IN_PARTY
	setevent EVENT_POKEONLY_CATERPIE_NOT_IN_NEST
	setevent EVENT_POKEONLY_METAPOD_NOT_IN_NEST
	setevent EVENT_POKEONLY_CHILD_BUTTERFREE_NOT_IN_NEST
	clearevent EVENT_POKEONLY_MOTHERBUTTERFREE_IN_PARTY
	clearevent EVENT_POKEONLY_CATERPIE_PICKED_UP

.finishedCaterpieQuest
	checkevent EVENT_POKEONLY_FINISHED_PIKACHU_QUEST
	iftrue .finishedPikachuQuest
	clearevent EVENT_POKEONLY_PIKACHU_IN_PARTY
	clearevent EVENT_POKEONLY_PIKACHU_MAD
	clearevent EVENT_POKEONLY_PIKACHU_GAVE_OBJECTIVE

.finishedPikachuQuest
	checkevent EVENT_POKEONLY_CHARMANDER_PUSHED_BOULDER_2
	iftrue .rescuedCharmander
	setevent EVENT_POKEONLY_CHARMANDER_TRAPPED

.rescuedCharmander
	clearevent EVENT_POKEONLY_BEACH_BUTTON_PRESSED
	setevent EVENT_POKEONLY_FIRE_OUT
	backupcustchar
	backupsecondpokemon
	setflag ENGINE_POKEMON_MODE
	setflag ENGINE_USE_TREASURE_BAG
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	callasm .HealFirstPartymon
	warp LAUREL_FOREST_POKEMON_ONLY, 3, 56
	blackoutmod LAUREL_FOREST_POKEMON_ONLY
.end
	end

.HealFirstPartymon
	xor a
	ld [wCurPartyMon], a
	ld [wPokeonlyMainSpecies], a
	jpba HealPartyMon

LaurelForestMainNPC2_Text_1367fb:
	ctxt "Only those who"
	line "understand the"
	para "true potential of"
	line "the ancient fish"
	cont "may pass."

	para "You're just like"
	line "the rest, you do"
	cont "not understand."

	para "BEGONE!"
	done

LaurelForestMain_Trainer_1_Text_137384:
	ctxt "Wow, so many bugs"
	line "to catch here!"
	done

LaurelForestMain_Trainer_1_Text_1373a1:
	ctxt "It's a good place"
	line "to train, too!"
	done

LaurelForestMain_Trainer_1_Script_Text_1373bd:
	ctxt "My mommy doesn't"
	line "let me take my"
	cont "bug #mon home."

	para "Instead, I have"
	line "a secret hiding"
	para "place for them"
	line "in the forest."
	done

LaurelForestMain_Trainer_2_Text_13743d:
	ctxt "This forest used"
	line "to extend even"
	para "further downwards,"
	line "until they started"
	para "all the building"
	line "work on that city!"
	done

LaurelForestMain_Trainer_2_Text_13748b:
	ctxt "The construction"
	line "probably scared"
	cont "most of the local"
	cont "bugs away<...>"
	done

LaurelForestMain_Trainer_2_Script_Text_1374c5:
	ctxt "Hm<...> I wonder if"
	line "certain species"
	cont "left the forest."

	para "I'd like to get"
	line "my hands on some"
	cont "rare bug #mon."
	done

LaurelForestMain_137300_Text_1367d0:
	ctxt "The Clefairy won't"
	line "let you pass<...>"

	para "Send @"
	text_from_ram wPartyMonNicknames
	ctxt ""
	line "instead?"
	done

LaurelForestMain_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $3, $4, 4, LAUREL_FOREST_GATES
	warp_def $3, $5, 5, LAUREL_FOREST_GATES
	warp_def $21, $4, 9, LAUREL_FOREST_GATES
	warp_def $21, $5, 1, LAUREL_FOREST_GATES
	warp_def $1, $10, 1, TRAINER_HOUSE
	warp_def $0, $22, 1, TRAINER_HOUSE
	warp_def $3, $1f, 8, LAUREL_FOREST_GATES

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_FAIRY, 4, 37, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 0, 0, LaurelForestMainNPC1, -1
	person_event SPRITE_ELDER, 15, 16, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, LaurelForestMainNPC2, EVENT_MAGIKARP_TEST
	person_event SPRITE_WHITNEY, 4, 32, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, ObjectEvent, EVENT_BROOKLYN_NOT_IN_FOREST
	person_event SPRITE_BUG_CATCHER, 20, 33, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 5, LaurelForestMain_Trainer_1, -1
	person_event SPRITE_BUG_CATCHER, 31, 20, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, LaurelForestMain_Trainer_2, -1
