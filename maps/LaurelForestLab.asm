LaurelForestLab_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelForestLab_Trainer_1:
	trainer EVENT_LAUREL_FOREST_LAB_TRAINER_1, SCIENTIST, 1, LaurelForestLab_Trainer_1_Text_149cc1, LaurelForestLab_Trainer_1_Text_149d2e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext LaurelForestScientistDefeated1Text

LaurelForestLab_Trainer_2:
	trainer EVENT_LAUREL_FOREST_LAB_TRAINER_2, SCIENTIST, 2, LaurelForestLab_Trainer_2_Text_149d58, LaurelForestLab_Trainer_2_Text_149d73, $0000, .Script

.Script:
	end_if_just_battled
	jumptext LaurelForestScientistDefeated2Text

LaurelForestLab_Totodile:
	setevent EVENT_POKEONLY_TOTODILE
	clearevent EVENT_BROOKLYN_NOT_IN_FOREST
	callasm RemoveSecondPartyMember
	opentext
	writetext LaurelForestLabTotodileText
	waitbutton
	restorecustchar
	restoresecondpokemon
	clearflag ENGINE_POKEMON_MODE
	clearflag ENGINE_USE_TREASURE_BAG
	warp LAUREL_FOREST_MAIN, 36, 4
	spriteface 0, 2
	showemote EMOTE_HEART, 4, 40
	applymovement 4, LaurelForestBrooklynMoveTowards
	opentext
	writetext LaurelForestBrooklynGetsTotodileText
	waitbutton
	closetext
	applymovement 4, LaurelForestBrooklynMoveAway
	disappear 4
	setevent EVENT_BROOKLYN_NOT_IN_FOREST
	end

LaurelForestBrooklynMoveTowards:
	big_step_right
	big_step_right
	big_step_right
	step_end

LaurelForestBrooklynMoveAway:
	big_step_left
	big_step_left
	big_step_left
	big_step_left
	big_step_left
	step_end

LaurelForestScientistDefeated1Text:
	ctxt "What an annoying"
	line "creature."
	done

LaurelForestScientistDefeated2Text:
	ctxt "If only you could"
	line "comprehend what"
	cont "we're doing."
	done

LaurelForestBrooklynGetsTotodileText:
	ctxt "Oh, I've missed"
	line "you so much my"
	cont "little Totodile!"

	para "Thank you so much!"

	para "Oh, if you want"
	line "to battle me,"

	para "then meet me at"
	line "my Gym back in"
	cont "Laurel City."
	done

LaurelForestLabTotodileText:
	ctxt "Wow, you made it!"

	para "However, I'm not"
	line "sure if I want"
	para "to go back to"
	line "my owner or not."

	para "She is just"
	line "so annoying."

	para "<...>"

	para "Wait, you met"
	line "a brainwashed"
	cont "Charizard?"

	para "I won't take my"
	line "chances, let's"
	cont "get out of here!"
	done

LaurelForestLab_Trainer_1_Text_149cc1:
	ctxt "How did our guard"
	line "let this lowly"
	cont "#mon pass?"

	para "Looks like I need"
	line "to improve my mind"
	para "control device to"
	line "make it flawless!"
	done

LaurelForestLab_Trainer_1_Text_149d2e:
	ctxt "No more #mon?"

	para "No way!"
	done

LaurelForestLab_Trainer_2_Text_149d58:
	ctxt "Ah, another good"
	line "test subject!"
	done

LaurelForestLab_Trainer_2_Text_149d73:
	ctxt "I was just trying"
	line "to catch you to"
	para "help enhance your"
	line "natural abilities."
	done

LaurelForestLab_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $f, $a, 3, LAUREL_FOREST_POKEMON_ONLY
	warp_def $f, $b, 3, LAUREL_FOREST_POKEMON_ONLY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_SCIENTIST, 15, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 6, LaurelForestLab_Trainer_1, EVENT_LAUREL_FOREST_LAB_TRAINER_1
	person_event SPRITE_SCIENTIST, 12, 11, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, LaurelForestLab_Trainer_2, EVENT_LAUREL_FOREST_LAB_TRAINER_2
	person_event SPRITE_TOTODILE, 1, 5, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, LaurelForestLab_Totodile, EVENT_POKEONLY_TOTODILE
