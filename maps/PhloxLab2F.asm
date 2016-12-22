PhloxLab2F_MapScriptHeader::

.Triggers: db 0

.Callbacks: db 1
	dbw MAPCALLBACK_TILES, PhloxLabF2Tiles

.Scripts:

PhloxLabF2TilesCallback:
	clearevent EVENT_0 

PhloxLabF2Tiles:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_1
	iffalse .skip1
	changeblock 2, 2, $68
.skip1
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_2
	iffalse .skip2
	changeblock 6, 2, $68
.skip2
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_3
	iffalse .skip3
	changeblock 10, 2, $68
.skip3
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_4
	iffalse .skip4
	changeblock 18, 2, $65
.skip4
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_5
	iffalse .skip5
	changeblock 22, 2, $65
.skip5
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_6
	iffalse .skip6
	changeblock 26, 2, $65
.skip6
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_2
	iffalse .skip7
	changeblock 10, 22, $87
	changeblock 10, 24, $87
.skip7
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_1
	iffalse .skip8
	changeblock 20, 20, $89
.skip8
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_4
	iffalse .skip9
	changeblock 4, 18, $89
.skip9
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_5
	iffalse .skip10
	changeblock 18, 14, $7b
	changeblock 18, 16, $5f
.skip10
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_6
	iffalse .skip11
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_3
	iftrue .filledTub
	changeblock 18, 12, $75
	changeblock 20, 12, $76
	changeblock 22, 12, $76
	changeblock 24, 12, $76
	changeblock 26, 12, $76
.skip11
	checkevent EVENT_0
	iftrue .notInCallback
	setevent EVENT_0
	return

.filledTub
	changeblock 18, 12, $79
	changeblock 20, 12, $7A
	changeblock 22, 12, $7A
	changeblock 24, 12, $7A
	changeblock 26, 12, $7A
	checkevent EVENT_0
	iftrue .notInCallback
	setevent EVENT_0
	return

.notInCallback
	end

PhloxLabF2Door1:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_1
	iftrue .alreadyOpen
	checkitem CAGE_CARD_1
	iftrue .opendoor
	jumptext PhloxLabF2Door1Text
	end

.opendoor
	scall PhloxOpenDoorDialogue
	takeitem CAGE_CARD_1
	setevent EVENT_PHLOX_LAB_POKEMON_DOOR_1
	setlasttalked 8
	scall PokemonExitRight
	playsound SFX_MEGA_PUNCH
	earthquake 80
.alreadyOpen
	end

PhloxOpenDoorDialogue:
	opentext
	writetext PhloxLabF2OpenDoorText
	waitbutton
	playsound SFX_ENTER_DOOR
	end

PokemonExitRight:
	scall PhloxLabF2Tiles
	closetext
	applymovement PLAYER, PhloxLabWalkRight
	applymovement LAST_TALKED, PhloxPokemonExitRightPart1
	spriteface PLAYER, RIGHT
	applymovement LAST_TALKED, PhloxPokemonExitRightPart2
	disappear LAST_TALKED
	end

PokemonExitLeft:
	scall PhloxLabF2Tiles
	closetext
	applymovement PLAYER, PhloxLabWalkLeft
	applymovement LAST_TALKED, PhloxPokemonExitLeftPart1
	spriteface PLAYER, LEFT
	applymovement LAST_TALKED, PhloxPokemonExitLeftPart2
	disappear LAST_TALKED
	end

PhloxLabF2Door2:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_2
	iftrue .alreadyOpen
	checkitem CAGE_CARD_2
	iftrue .opendoor
	jumptext PhloxLabF2Door2Text
	end

.opendoor
	scall PhloxOpenDoorDialogue
	takeitem CAGE_CARD_2
	setevent EVENT_PHLOX_LAB_POKEMON_DOOR_2
	setlasttalked 9
	scall PokemonExitRight
	playsound SFX_MOONLIGHT
.alreadyOpen
	end

PhloxLabF2Door3:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_3
	iftrue .alreadyOpen
	checkitem CAGE_CARD_3
	iftrue .opendoor
	jumptext PhloxLabF2Door3Text
	end

.opendoor
	scall PhloxOpenDoorDialogue
	takeitem CAGE_CARD_3
	setevent EVENT_PHLOX_LAB_POKEMON_DOOR_3
	setlasttalked 10
	scall PokemonExitRight
	playsound SFX_HYDRO_PUMP
	earthquake 80
.alreadyOpen
	end

PhloxLabF2Door4:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_4
	iftrue .alreadyOpen
	checkitem CAGE_CARD_4
	iftrue .opendoor
	jumptext PhloxLabF2Door4Text
	end

.opendoor
	scall PhloxOpenDoorDialogue
	takeitem CAGE_CARD_4
	setevent EVENT_PHLOX_LAB_POKEMON_DOOR_4
	setlasttalked 11
	scall PokemonExitLeft
	playsound SFX_GS_INTRO_CHARIZARD_FIREBALL
	earthquake 80
.alreadyOpen
	end

PhloxLabF2Door5:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_5
	iftrue .alreadyOpen
	checkitem CAGE_CARD_5
	iftrue .opendoor
	jumptext PhloxLabF2Door5Text
	end

.opendoor
	scall PhloxOpenDoorDialogue
	takeitem CAGE_CARD_5
	setevent EVENT_PHLOX_LAB_POKEMON_DOOR_5
	setlasttalked 12
	scall PokemonExitLeft
	playwaitsfx SFX_THUNDERSHOCK
	playsound SFX_WALL_OPEN
.alreadyOpen
	end

PhloxLabF2Door6:
	checkevent EVENT_PHLOX_LAB_POKEMON_DOOR_6
	iftrue .alreadyOpen
	checkitem CAGE_CARD_6
	iftrue .opendoor
	jumptext PhloxLabF2Door6Text
	end

.opendoor
	scall PhloxOpenDoorDialogue
	takeitem CAGE_CARD_6
	setevent EVENT_PHLOX_LAB_POKEMON_DOOR_6
	setlasttalked 13
	scall PokemonExitLeft
	playsound SFX_HYDRO_PUMP
	earthquake 80
.alreadyOpen
	end

PhloxLabWalkRight:
	step_right
	turn_head_left
	step_end

PhloxLabWalkLeft:
	step_left
	turn_head_right
	step_end

PhloxPokemonExitRightPart1:
	step_left
	step_down
	step_down
	step_down
	step_down
	step_right
	step_end

PhloxPokemonExitLeftPart1:
	step_down
	step_right
	step_down
	step_down
	step_down
	step_left
	step_end

PhloxPokemonExitRightPart2:
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_end

PhloxPokemonExitLeftPart2:
	step_left
	step_left
	step_left
	step_left
	step_left
	step_left
	step_left
	step_end

PhloxLabF2ElectricPanel:
	jumptextfaceplayer ElectricPanelText

PhloxLabF2Trainer1:
	trainer EVENT_PHLOX_LAB_F2_TRAINER_1, SCIENTIST, 8, PhloxLabF2_Trainer_1_Text, PhloxLabF2_Trainer_1_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF2_Trainer_1_After_Text

PhloxLabF2Trainer2:
	trainer EVENT_PHLOX_LAB_F2_TRAINER_2, SCIENTIST, 9, PhloxLabF2_Trainer_2_Text, PhloxLabF2_Trainer_2_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF2_Trainer_2_After_Text

PhloxLabF2PaletteGreen:
	trainer EVENT_PHLOX_LAB_F2_GREEN_PALETTE, PATROLLER, 18, PhloxLabF2_Palette_Green_Text, PhloxLabF2_Palette_Green_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF2_Palette_Green_After_Text


PhloxLabF2_Item1:
	db CAGE_CARD_1, 1

PhloxLabF2_Item2:
	db CAGE_CARD_2, 1

PhloxLabF2_Item3:
	db CAGE_CARD_3, 1

PhloxLabF2_Item4:
	db CAGE_CARD_4, 1

PhloxLabF2_Item5:
	db CAGE_CARD_5, 1

PhloxLabF2_Item6:
	db CAGE_CARD_6, 1

.Text:

PhloxLabF2_Palette_Green_Text:
	ctxt "Enough of you!"

	para "Tell me."

	para "What is your goal"
	line "in life, huh?"

	para "My goal in life is"
	line "to be financially"
	cont "stable, for once."

	para "And here's you,"
	line "trying to take all"
	cont "of that away."

	para "Do you think I"
	line "care that it's"
	cont "unethical, huh?"

	para "People around the"
	line "world do unethical"
	cont "things to survive."

	para "Once those greedy"
	line "people think they"

	para "need our product"
	line "to complete in"
	cont "#mon battles<...>"

	para "I will have all"
	line "the money I need"

	para "to get everything"
	line "I ever wanted."

	para "You are not going"
	line "to go any further."
	done

PhloxLabF2_Palette_Green_Lose_Text:
	ctxt "Persistent child!"

	para "You always want"
	line "to do the right"
	cont "thing, don't you."

	para "But guess what?"

	para "The rest of the"
	line "world won't care"
	cont "about your needs."

	para "Giving gets you"
	line "nowhere in life."

	para "Taking is the only"
	line "way to survive in"
	cont "this world today."
	done

PhloxLabF2_Palette_Green_After_Text:
	ctxt "Go on."

	para "Think about who"
	line "you're hurting."
	done
		 

PhloxLabF2_Trainer_2_Text:
	ctxt "If you succeed,"
	line "my career will"
	cont "be ruined forever!"
	done

PhloxLabF2_Trainer_2_Lose_Text:
	ctxt "All my hopes, all"
	line "my dreams, they"

	para "amount to nothing"
	line "in the end."
	done

PhloxLabF2_Trainer_2_After_Text:
	ctxt "Takes a lifetime"
	line "to create a good"
	cont "reputation."

	para "It takes a moment"
	line "to destroy it."
	done

PhloxLabF2_Trainer_1_Text:
	ctxt "This isn't my world"
	line "but I'm fine<...>"

	para "I am the reverse"
	line "engineer of the"
	cont "world! As we know."
	done

PhloxLabF2_Trainer_1_Lose_Text:
	ctxt "Now I need to"
	line "reverse engineer"
	cont "your abilities!"
	done

PhloxLabF2_Trainer_1_After_Text:
	ctxt "Being able to"
	line "reverse engineer"

	para "actual #mon is"
	line "fun! Try it!"
	done

PhloxLabF2OpenDoorText:
	ctxt "The Cage Card"
	line "opened the door!"
	done

PhloxLabF2Door1Text:
	ctxt "Door 1"
	done

PhloxLabF2Door2Text:
	ctxt "Door 2"
	done

PhloxLabF2Door3Text:
	ctxt "Door 3"
	done

PhloxLabF2Door4Text:
	ctxt "Door 4"
	done

PhloxLabF2Door5Text:
	ctxt "Door 5"
	done

PhloxLabF2Door6Text:
	ctxt "Door 6"
	done

ElectricPanelText:
	ctxt "It's an electrical"
	line "panel."

	para "Looks complicated."

	para "Maybe it's used to"
	line "unlock this door?"
	done

PhloxLab2F_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 2, 14, 3, PHLOX_LAB_1F
	warp_def 10, 26, 1, PHLOX_LAB_3F

.CoordEvents: db 0

.BGEvents: db 7
	signpost 3, 2, SIGNPOST_UP, PhloxLabF2Door1
	signpost 3, 6, SIGNPOST_UP, PhloxLabF2Door2
	signpost 3, 10, SIGNPOST_UP, PhloxLabF2Door3
	signpost 3, 19, SIGNPOST_UP, PhloxLabF2Door4
	signpost 3, 23, SIGNPOST_UP, PhloxLabF2Door5
	signpost 3, 27, SIGNPOST_UP, PhloxLabF2Door6
	signpost 15, 17, SIGNPOST_UP, PhloxLabF2ElectricPanel

.ObjectEvents: db 15
	person_event SPRITE_POKE_BALL, 22, 27, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PhloxLabF2_Item1, EVENT_PHLOX_F2_CARDKEY_1
	person_event SPRITE_POKE_BALL, 25, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PhloxLabF2_Item2, EVENT_PHLOX_F2_CARDKEY_2
	person_event SPRITE_POKE_BALL, 1, 25, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PhloxLabF2_Item3, EVENT_PHLOX_F2_CARDKEY_3
	person_event SPRITE_POKE_BALL, 11, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PhloxLabF2_Item4, EVENT_PHLOX_F2_CARDKEY_4
	person_event SPRITE_POKE_BALL, 19, 10, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PhloxLabF2_Item5, EVENT_PHLOX_F2_CARDKEY_5
	person_event SPRITE_POKE_BALL, 25, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PhloxLabF2_Item6, EVENT_PHLOX_F2_CARDKEY_6
	person_event SPRITE_HITMONCHAN, 1, 3, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, ObjectEvent, EVENT_PHLOX_LAB_POKEMON_DOOR_1
	person_event SPRITE_GLACEON, 1, 7, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_PHLOX_LAB_POKEMON_DOOR_2
	person_event SPRITE_BLASTOISE, 1, 11, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_PHLOX_LAB_POKEMON_DOOR_3
	person_event SPRITE_MAGMORTAR, 1, 18, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, EVENT_PHLOX_LAB_POKEMON_DOOR_4
	person_event SPRITE_AMPHAROS, 1, 22, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, EVENT_PHLOX_LAB_POKEMON_DOOR_5
	person_event SPRITE_MILOTIC, 1, 26, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, EVENT_PHLOX_LAB_POKEMON_DOOR_6
	person_event SPRITE_SCIENTIST, 16, 10, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, PhloxLabF2Trainer1, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_SCIENTIST, 22, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, PhloxLabF2Trainer2, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_PALETTE_PATROLLER, 19, 23, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 2, 4, PhloxLabF2PaletteGreen, EVENT_PHLOX_LAB_CEO
