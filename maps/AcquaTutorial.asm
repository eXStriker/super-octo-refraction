AcquaTutorial_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcquaTutorialHiddenItem_1:
	dw EVENT_ACQUA_TUTORIAL_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

AcquaTutorialSignpost1:
	opentext
	writetext AcquaTutorialSignpost1_Text_1173bc
	yesorno
	iftrue AcquaTutorial_11707b
	closetext
	end

AcquaTutorialSignpost3:
	checkevent EVENT_ACQUA_MOVED_BOULDER
	iffalse AcquaTutorial_117011
	end

AcquaTutorialSignpost4:
	checkevent EVENT_ACQUA_MOVED_BOULDER
	iffalse AcquaTutorial_117032
	jumptext AcquaTutorial_117040_Text_1173d6

AcquaTutorialNPC1:
	jumptext AcquaTutorialNPC1_Text_11723a

AcquaTutorialNPC5:
	opentext
	writetext AcquaTutorialNPC5_Text_117278
	waitbutton
	closetext
AcquaTutorialNPC2:
AcquaTutorialNPC3:
AcquaTutorialNPC4:
AcquaTutorialNPC6:
AcquaTutorialNPC7:
	pause 12
	playsound SFX_DOUBLE_KICK
	disappear LAST_TALKED
	end

AcquaTutorialNPC8:
	faceplayer
	opentext
	writetext AcquaTutorialNPC8_Text_1172af
	callasm .giveSoftSand
	iftrue .noRoomForSoftSand
	writetext AcquaTutorialNPC8_Text_GaveSoftSand
	playwaitsfx SFX_ITEM
	writetext AcquaTutorialNPC8_Text_1172af_2
	waitbutton
	closetext
	applymovement 0, AcquaTutorialNPC8_Movement1
	applymovement 9, AcquaTutorialNPC8_Movement2
	disappear 9
	end

.noRoomForSoftSand
	jumptext AcquaTutorialNPC8_Text_NoRoomForSoftSand

.giveSoftSand
	ld hl, PartyMon1Item
	ld a, [hl]
	and a
	jr nz, .fail
	ld [hl], SOFT_SAND
	xor a
.fail
	ld [hScriptVar], a
	ret

AcquaTutorialNPC8_Movement1:
	step_left
	step_up
	step_up
	step_right
	turn_head_left
	step_end

AcquaTutorialNPC8_Movement2:
	step_left
	step_left
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_left
	step_left
	step_left
	step_end

AcquaTutorialNPC9:
	faceplayer
	opentext
	writetext AcquaTutorial_117055_Text_117120
	waitbutton
	closetext
	playsound SFX_RUN
	applymovement 10, AcquaTutorial_117055_Movement1
	disappear 10
	playwaitsfx SFX_EXIT_BUILDING
	jumptext AcquaTutorial_117055_Text_117152

AcquaTutorial_Item_1:
	db POTION, 1

AcquaTutorial_116ffb:
	closetext
	end

AcquaTutorial_11707b:
	restorecustchar
	clearflag ENGINE_POKEMON_MODE
	warp ACQUA_TUTORIAL, 26, 20
	closetext
	blackoutmod ACQUA_START
	checkevent EVENT_ACQUA_MOVED_BOULDER
	iffalse .nofx
	playsound SFX_EMBER
	earthquake 40
	waitsfx
.nofx
	end

AcquaTutorial_117011:
	opentext
	writetext AcquaTutorial_117011_Text_11735d
	waitbutton
	closetext
	playsound SFX_STRENGTH
	earthquake 16
	opentext
	writetext AcquaTutorial_117011_Text_117380
	waitbutton
	setevent EVENT_ACQUA_MOVED_BOULDER
	closetext
	end

AcquaTutorial_117032:
	opentext
	writetext AcquaTutorial_117032_Text_117200
	yesorno
	if_equal 1, AcquaTutorial_116f5c
	closetext
	end

AcquaTutorial_117055_Movement1:
	fast_slide_step_up
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_down
	fast_slide_step_right
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_down
	fast_slide_step_right
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_down
	fast_slide_step_right
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_up
	step_end

AcquaTutorial_116f5c:
	closetext
	backupcustchar
	setflag ENGINE_POKEMON_MODE
	warp ACQUA_TUTORIAL, 30, 42
	blackoutmod ACQUA_TUTORIAL
	end

AcquaTutorialSignpost1_Text_1173bc:
	ctxt "Return to your"
	line "Trainer?"
	done

AcquaTutorialNPC1_Text_11723a:
	ctxt "The boulder is"
	line "too heavy to move!"
	done

AcquaTutorialNPC5_Text_117278:
	text_from_ram wPartyMonNicknames
	ctxt " eagerly"
	line "devoured the soil."
	done

AcquaTutorialNPC8_Text_1172af:
	ctxt "<...>"

	para "Oh! Hello!"

	para "I'm sorry I ran"
	line "away just now<...>"

	para "I'm really shy<...>"

	para "If you keep your"
	line "Trainer away,"

	para "I'll give you a"
	line "gift, as thanks!"
	prompt

AcquaTutorialNPC8_Text_GaveSoftSand:
	ctxt "The Larvitar gives"
	line "you Soft Sand!"
	done

AcquaTutorialNPC8_Text_NoRoomForSoftSand:
	ctxt "Oh, you're holding"
	line "an item already."

	para "I'll be staying"
	line "here a bit longer,"

	para "if you change your"
	line "mind, I can give"
	cont "you the gift."
	done

AcquaTutorialNPC8_Text_1172af_2:
	ctxt "I guess I should"
	line "hide somewhere"
	cont "else for now<...>"
	done

AcquaTutorial_117011_Text_11735d:
	ctxt "What is this"
	line "button here for?"
	done

AcquaTutorial_117011_Text_117380:
	ctxt "Sounds like"
	line "something moved."
	done

AcquaTutorial_117032_Text_117200:
	ctxt "It's too small for"
	line "you to enter<...>"

	para "Send @"
	text_from_ram wPartyMonNicknames
	ctxt ""
	line "instead?"
	done

AcquaTutorial_117040_Text_1173d6:
	ctxt "The room"
	line "collapsed."
	done

AcquaTutorial_117055_Text_117120:
	ctxt "Hmm… Another"
	line "Larvitar."
	done

AcquaTutorial_117055_Text_117152:
	ctxt "The Larvitar fled!"
	done

AcquaTutorial_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 19, 21, 1, ACQUA_START
	warp_def 25, 26, 2, ACQUA_EXITCHAMBER

.CoordEvents: db 0

.BGEvents: db 4
	signpost 41, 30, SIGNPOST_READ, AcquaTutorialSignpost1
	signpost 16, 33, SIGNPOST_ITEM, AcquaTutorialHiddenItem_1
	signpost 51, 43, SIGNPOST_READ, AcquaTutorialSignpost3
	signpost 19, 26, SIGNPOST_READ, AcquaTutorialSignpost4

.ObjectEvents: db 10
	person_event SPRITE_BOULDER, 25, 26, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC1, EVENT_ACQUA_MOVED_BOULDER
	person_event SPRITE_ROCK, 54, 31, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC2, -1
	person_event SPRITE_ROCK, 44, 41, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC3, -1
	person_event SPRITE_ROCK, 46, 35, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC4, -1
	person_event SPRITE_ROCK, 44, 32, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC5, -1
	person_event SPRITE_ROCK, 54, 42, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC6, -1
	person_event SPRITE_ROCK, 52, 43, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcquaTutorialNPC7, -1
	person_event SPRITE_LARVITAR, 47, 43, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, AcquaTutorialNPC8, EVENT_ACQUA_TUTORIAL_SCARED_LARVITAR_INSIDE
	person_event SPRITE_LARVITAR, 22, 27, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, AcquaTutorialNPC9, EVENT_ACQUA_TUTORIAL_SCARED_LARVITAR_OUTSIDE
	person_event SPRITE_POKE_BALL, 7, 30, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, AcquaTutorial_Item_1, EVENT_ACQUA_TUTORIAL_ITEM_1

