PhloxLab1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw MAPCALLBACK_TILES, PhloxLabF1Tiles

PhloxLabF1_Item:
	db MAX_REVIVE, 1

PhloxLabF1RefreshMap:
	changemap BANK(PhloxLab1F_BlockData), PhloxLab1F_BlockData

; fallthrough	
PhloxLabF1Tiles:
	checkevent EVENT_PHLOX_LAB_RED_ON
	sif false, then
		changeblock 12, 18, $3a
		changeblock 2, 2, $3a
		changeblock 8, 16, $57
		changeblock 8, 18, $3b
	sendif

	checkevent EVENT_PHLOX_LAB_BLUE_ON
	sif false, then
		changeblock 20, 18, $3a
		changeblock 20, 2, $3a
		changeblock 20, 4, $3f
		changeblock 22, 4, $41
	sendif

	checkevent EVENT_PHLOX_LAB_GREEN_ON
	sif false, then
		changeblock 6, 18, $3a
		changeblock 4, 22, $3a
		changeblock 8, 4, $3b
		changeblock 6, 4, $3f
	sendif

	checkevent EVENT_PHLOX_LAB_YELLOW_ON
	sif false, then
		changeblock 16, 2, $3a
		changeblock 8, 6, $3a
	sendif

	checkevent EVENT_PHLOX_LAB_BROWN_ON
	sif true
		return
	changeblock 16, 22, $3a
	changeblock 12, 2, $3a
	return

PhloxLab1FRedWarp1:
	switch 0

PhloxLab1FRedWarp2:
	switch 1

PhloxLab1FBlueWarp1:
	switch 2

PhloxLab1FBlueWarp2:
	switch 3

PhloxLab1FGreenWarp1:
	switch 4

PhloxLab1FGreenWarp2:
	switch 5

PhloxLab1FYellowWarp1:
	switch 6

PhloxLab1FYellowWarp2:
	switch 7

PhloxLab1FBrownWarp1:
	switch 8

PhloxLab1FBrownWarp2:
	writebyte 9
	sendif
	playsound SFX_WARP_TO
	applymovement 0, PhloxLabWarpFrom
	special FadeOutPalettes
	loadarray PhloxLabWarpCoordsArray
	cmdwitharrayargs .CustomWarpEnd - .CustomWarp
.CustomWarp:
	db warp_command, %110
	map PHLOX_LAB_1F
	db 0, 1
.CustomWarpEnd:
	playsound SFX_WARP_FROM
	applymovement 0, PhloxLabWarpTo
	end

PhloxLabWarpCoordsArray:
	db 03, 02
PhloxLabWarpCoordsArrayEntrySizeEnd:
	db 13, 18
	db 21, 02
	db 21, 18
	db 05, 22
	db 07, 18
	db 17, 02
	db 09, 06
	db 17, 22
	db 13, 02

PhloxLabWarpFrom:
	teleport_from
	step_end

PhloxLabWarpTo:
	teleport_to
	step_end

PhloxLabRedSwitch:
	switch 0

PhloxLabBlueSwitch:
	switch 1

PhloxLabGreenSwitch:
	switch 2

PhloxLabYellowSwitch:
	switch 3

PhloxLabBrownSwitch:
	writebyte 4

; toggle switch
	sendif
	loadarray PhloxLabSwitchArray
	readarrayhalfword 0
	checkevent -1
	sif false, then
		setevent -1
	selse
		clearevent -1
	sendif

	scall PhloxLabF1RefreshMap
	waitsfx
	playwaitsfx SFX_TWO_PC_BEEPS
	readarrayhalfword 2
	jumptext -1

PhloxLabSwitchArray:
	dw EVENT_PHLOX_LAB_RED_ON, PhloxLabRedSwitchText
PhloxLabSwitchArrayEntrySizeEnd:
	dw EVENT_PHLOX_LAB_BLUE_ON, PhloxLabBlueSwitchText
	dw EVENT_PHLOX_LAB_GREEN_ON, PhloxLabGreenSwitchText
	dw EVENT_PHLOX_LAB_YELLOW_ON, PhloxLabYellowSwitchText
	dw EVENT_PHLOX_LAB_BROWN_ON, PhloxLabBrownSwitchText

PhloxLabF1_YellowPalette:
	trainer EVENT_PHLOX_LAB_F1_YELLOW_PALETTE, PATROLLER, 17, PhloxLabF1_YellowPalette_Text, PhloxLabF1_YellowPalette_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF1_YellowPalette_Script_Text

PhloxLabF1_Trainer_1:
	trainer EVENT_PHLOX_LAB_F1_TRAINER_1, SCIENTIST, 4, PhloxLabF1_Trainer_1_Text, PhloxLabF1_Trainer_1_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF1_Trainer_1_Script_Text

PhloxLabF1_Trainer_2:
	trainer EVENT_PHLOX_LAB_F1_TRAINER_2, SCIENTIST, 5, PhloxLabF1_Trainer_2_Text, PhloxLabF1_Trainer_2_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF1_Trainer_2_Script_Text

PhloxLabF1_Trainer_3:
	trainer EVENT_PHLOX_LAB_F1_TRAINER_3, SCIENTIST, 6, PhloxLabF1_Trainer_3_Text, PhloxLabF1_Trainer_3_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF1_Trainer_3_Script_Text

PhloxLabF1_Trainer_4:
	trainer EVENT_PHLOX_LAB_F1_TRAINER_4, SCIENTIST, 7, PhloxLabF1_Trainer_4_Text, PhloxLabF1_Trainer_4_Lose_Text, $0000, .Script

.Script
	end_if_just_battled
	jumptext PhloxLabF1_Trainer_4_Script_Text

PhloxLabF1_Trainer_1_Text:
	ctxt "6 years of medical"
	line "& #mon anatomy"
	cont "study will give me"
	cont "the upper hand in"
	cont "this battle!"
	done

PhloxLabF1_Trainer_1_Lose_Text:
	ctxt "<...>6 years wasted<...>"
	done

PhloxLabF1_Trainer_1_Script_Text:
	ctxt "Judging by the way"
	line "you fight, you"

	para "must be a true"
	line "#mon prodigy."
	done

PhloxLabF1_Trainer_2_Text:
	ctxt "<...>yes?"
	done

PhloxLabF1_Trainer_2_Lose_Text:
	ctxt "They don't pay me"
	line "enough to care if"
	cont "I lost to you."
	done

PhloxLabF1_Trainer_2_Script_Text:
	ctxt "I should consider"
	line "a career change."
	done

PhloxLabF1_Trainer_3_Text:
	ctxt "I just signed up"
	line "for the generous"
	cont "healthcare plan."

	para "There's no way I'm"
	line "letting you take"
	cont "down this company."
	done

PhloxLabF1_Trainer_3_Lose_Text:
	ctxt "Oh well, guess I"
	line "need to file for"
	cont "unemployment now."
	done

PhloxLabF1_Trainer_3_Script_Text:
	ctxt "If you were more"
	line "considerate, you"

	para "wouldn't jepordize"
	line "our employment."
	done

PhloxLabF1_Trainer_4_Text:
	ctxt "There is so much"
	line "research still"
	cont "left to be done!"

	para "I will stop you!"
	done

PhloxLabF1_Trainer_4_Lose_Text:
	ctxt "I must preserve"
	line "my findings for"
	cont "later publishing."
	done

PhloxLabF1_Trainer_4_Script_Text:
	ctxt "I'm going to make"
	line "this company many"
	cont "millions, someday."

	para "Then they'll have"
	line "to bump up my"
	cont "measly salary."
	done

PhloxLabF1_YellowPalette_Text:
	ctxt "Palette Red was an"
	line "awful leader that"

	para "never appreciated"
	line "my fashion style."

	para "That's why he was"
	line "easily upstaged by"
	cont "a kid like you."
	done

PhloxLabF1_YellowPalette_Lose_Text:
	ctxt "No! The terrible"
	line "lighting ruined my"
	cont "shot at this!"
	done

PhloxLabF1_YellowPalette_Script_Text:
	ctxt "Forget this place!"

	para "Maybe I'll go out"
	line "to Kalos."

	para "I'm sure someone"
	line "out there will"

	para "appreciate my"
	line "style and FLARE!"
	done

PhloxLabRedSwitchText:
	ctxt "Pressed the Red"
	line "Switch!"
	done

PhloxLabBlueSwitchText:
	ctxt "Pressed the Blue"
	line "Switch!"
	done

PhloxLabGreenSwitchText:
	ctxt "Pressed the Green"
	line "Switch!"
	done

PhloxLabYellowSwitchText:
	ctxt "Pressed the Yellow"
	line "Switch!"
	done

PhloxLabBrownSwitchText:
	ctxt "Pressed the Brown"
	line "Switch!"
	done

PhloxLab1F_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 23, 14, 3, PHLOX_TOWN
	warp_def 23, 15, 3, PHLOX_TOWN
	warp_def 7, 18, 1, PHLOX_LAB_2F

.CoordEvents: db 10
	xy_trigger 0, 18, 13, $0, PhloxLab1FRedWarp1, EVENT_PHLOX_LAB_RED_ON
	xy_trigger 0, 02, 03, $0, PhloxLab1FRedWarp2, EVENT_PHLOX_LAB_RED_ON
	xy_trigger 0, 18, 21, $0, PhloxLab1FBlueWarp1, EVENT_PHLOX_LAB_BLUE_ON
	xy_trigger 0, 02, 21, $0, PhloxLab1FBlueWarp2, EVENT_PHLOX_LAB_BLUE_ON
	xy_trigger 0, 18, 07, $0, PhloxLab1FGreenWarp1, EVENT_PHLOX_LAB_GREEN_ON
	xy_trigger 0, 22, 05, $0, PhloxLab1FGreenWarp2, EVENT_PHLOX_LAB_GREEN_ON
	xy_trigger 0, 06, 09, $0, PhloxLab1FYellowWarp1, EVENT_PHLOX_LAB_YELLOW_ON
	xy_trigger 0, 02, 17, $0, PhloxLab1FYellowWarp2, EVENT_PHLOX_LAB_YELLOW_ON
	xy_trigger 0, 02, 13, $0, PhloxLab1FBrownWarp1, EVENT_PHLOX_LAB_BROWN_ON
	xy_trigger 0, 22, 17, $0, PhloxLab1FBrownWarp2, EVENT_PHLOX_LAB_BROWN_ON

.BGEvents: db 5
	signpost 16, 16, SIGNPOST_UP, PhloxLabRedSwitch
	signpost 0, 4, SIGNPOST_UP, PhloxLabBlueSwitch
	signpost 0, 16, SIGNPOST_UP, PhloxLabGreenSwitch
	signpost 16, 2, SIGNPOST_UP, PhloxLabYellowSwitch
	signpost 0, 12, SIGNPOST_UP, PhloxLabBrownSwitch

.ObjectEvents: db 6
	person_event SPRITE_SCIENTIST, 20, 3, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, PhloxLabF1_Trainer_1, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_SCIENTIST, 3, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, PhloxLabF1_Trainer_2, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_SCIENTIST, 11, 19, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, PhloxLabF1_Trainer_3, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_SCIENTIST, 9, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, PhloxLabF1_Trainer_4, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_PALETTE_PATROLLER, 9, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 3, PhloxLabF1_YellowPalette, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_POKE_BALL, 7, 14, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_SILVER, 3, TM_METRONOME, 0, EVENT_PHLOX_F1_TM51
	person_event SPRITE_POKE_BALL, 8, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, PhloxLabF1_Item, EVENT_PHLOX_ITEM
