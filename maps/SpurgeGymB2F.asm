SpurgeGymB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SpurgeGymB2FSignpost1:
	checkevent EVENT_SPURGE_GYM_SWITCH_ENABLED
	iftrue SpurgeGymB2F_2fc112
	playsound SFX_ENTER_DOOR
	setevent EVENT_SPURGE_GYM_SWITCH_ENABLED
	jumptext SpurgeGymB2FSignpost1_Text_2fc113

SpurgeGymB2F_2fc112:
	jumptext SpurgeGymB2FSignpost1_Text_ButtonAlreadyPushed

SpurgeGymPokeball2:
	setevent EVENT_SPURGE_GYM_POKEMON_4
	jump SpurgeGymGetPokemon

SpurgeGymPokeball1:
	setevent EVENT_SPURGE_GYM_POKEMON_1

SpurgeGymGetPokemon:
	callasm SpurgeGymNextPokemon
	opentext
	writetext SpurgeGymB2FNPC1_Text_2ff222
	cry 0
	disappear LAST_TALKED
	closetext
	end

SpurgeGymNextPokemon:
	ld hl, wPartyCount
	inc [hl]
	ld c, [hl]
	ld b, 0
	add hl, bc
	ld de, wBackupSecondPartySpecies
	ld a, [de]
	ld [hli], a
	ld [hScriptVar], a
	ld a, [hl]
	ld [de], a
	ld [hl], $ff
	ld a, c
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	jp CopyName2

SpurgeGymB2FNPC3:
	checkcode VAR_PARTYCOUNT
	if_not_equal 6, .didntGetAllPokes

	faceplayer
	opentext
	writetext SpurgeGymB2FNPC3_Text_2fc64c
	waitbutton
	winlosstext SpurgeGymB2FNPC3Text_2fc6f8, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer BRUCE, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SpurgeGymB2FNPC3_Text_2fc71a
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_NALJOBADGE
	special RestartMapMusic
	writetext SpurgeGymB2FNPC3_Text_2fc733
	waitbutton
	givetm 43 + RECEIVED_TM
	opentext
	writetext SpurgeGymB2FNPC3_Text_2fc75c
	waitbutton
	writetext SpurgeGymB2FNPC3_Text_2fc7c6
	waitbutton
	setevent EVENT_SPURGE_GYM_DEFEATED
	special Special_BattleTowerFade
	playwaitsfx SFX_WARP_FROM
	clearevent EVENT_ENTERED_SPURGE_GYM
	warp SPURGE_CITY, 34, 6
	end

.didntGetAllPokes
	jumptextfaceplayer FoundBruceDidntGetAllPokeText

FoundBruceDidntGetAllPokeText:
	ctxt "So, you did man-"
	line "age to find me!"

	para "However, you didn't"
	line "find all of your"
	cont "#mon yet!"

	para "Come back when you"
	line "find them all."
	done

SpurgeGymB2FSignpost1_Text_2fc113:
	ctxt "Pushed the"
	line "button."

	para "Not sure what"
	line "that did<...>"
	done

SpurgeGymB2FSignpost1_Text_ButtonAlreadyPushed:
	ctxt "The button has"
	line "already been"
	cont "pushed."
	done

SpurgeGymB2FNPC1_Text_2ff222:
	ctxt "<PLAYER> found"
	line "<STRBF1>!"
	done

SpurgeGymB2FNPC3_Text_2fc64c:
	ctxt "Welcome Trainer!"

	para "Because of your"
	line "bravery shown"
	cont "through my puzzle,"

	para "I have decided to"
	line "humbly accept your"
	cont "challenge at last!"

	para "I am Bruce, the"
	line "proud Steel Gym"
	cont "Leader of Naljo!"

	para "The defense capa-"
	line "bilities of steel"

	para "#mon can never"
	line "be matched!"

	para "Are you ready?"
	done

SpurgeGymB2FNPC3Text_2fc6f8:
	ctxt "H<...>how?"

	para "Well, no matter."

	para "You have earned"
	line "my Badge, and the"

	para "opportunity to"
	line "compete in the"
	cont "Rijon League!"
	done

SpurgeGymB2FNPC3_Text_2fc71a:
	ctxt "<PLAYER> received"
	line "Naljo Badge!"
	done

SpurgeGymB2FNPC3_Text_2fc733:
	ctxt "I suppose I could"
	line "give you this too."
	done

SpurgeGymB2FNPC3_Text_2fc75c:
	ctxt "This TM is"
	line "Flash Cannon!"

	para "It's a powerful"
	line "Steel move that"

	para "has the chance"
	line "of lowering the"

	para "foe's special"
	line "defense a bit!"
	done

SpurgeGymB2FNPC3_Text_2fc7c6:
	ctxt "Well, now it's"
	line "time for us to"
	cont "make our exit."

	para "I bid you"
	line "farewell."
	done

SpurgeGymB2F_MapEventHeader:: db 0, 0

.Warps: db 4
	warp_def 33, 3, 2, SPURGE_GYM_B2F_SIDESCROLL
	warp_def 3, 3, 3, SPURGE_GYM_B1F
	warp_def 3, 13, 4, SPURGE_GYM_B1F
	warp_def 15, 7, 5, SPURGE_GYM_B1F

.CoordEvents: db 0

.BGEvents: db 1
	signpost 1, 3, SIGNPOST_READ, SpurgeGymB2FSignpost1

.ObjectEvents: db 3
	person_event SPRITE_POKE_BALL, 24, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymPokeball1, EVENT_SPURGE_GYM_POKEMON_1
	person_event SPRITE_POKE_BALL, 2, 12, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymPokeball2, EVENT_SPURGE_GYM_POKEMON_4
	person_event SPRITE_CLAIR, 13, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SpurgeGymB2FNPC3, -1
