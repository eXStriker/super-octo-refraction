Route71b_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route71bSignpost1:
	ctxt "Battle Tower"
	done ;58

Route71b_Trainer_1:
	trainer EVENT_ROUTE_71B_TRAINER_1, JUGGLER, 3, Route71b_Trainer_1_Text_13efb2, Route71b_Trainer_1_Text_13efd5, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route71b_Trainer_1_Script_Text_13eff2
	endtext

Route71b_Trainer_2:
	trainer EVENT_ROUTE_71B_TRAINER_2, FIREBREATHER, 8, Route71b_Trainer_2_Text_13eec0, Route71b_Trainer_2_Text_13eefb, $0000, .Script

.Script:
	opentext
	writetext Route71b_Trainer_2_Script_Text_13ef17
	endtext

Route71b_Trainer_3:
	trainer EVENT_ROUTE_71B_TRAINER_3, FIREBREATHER, 7, Route71b_Trainer_3_Text_13ee1b, Route71b_Trainer_3_Text_13ee3c, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route71b_Trainer_3_Script_Text_13ee5e
	endtext

; Route71BAnnoyingYoungsterScript:
	; jumptextfaceplayer Route71BAnnoyingYoungsterText

Route71b_Trainer_1_Text_13efb2:
	ctxt "Time for my new"
	line "juggling routine!"
	done

Route71b_Trainer_1_Text_13efd5:
	ctxt "That doesn't"
	line "appease you?"
	done

Route71b_Trainer_1_Script_Text_13eff2:
	ctxt "Being able to"
	line "juggle like this"
	cont "takes practice!"

	para "Nobody is born a"
	line "juggler."
	done

Route71b_Trainer_2_Text_13eec0:
	ctxt "I know a little"
	line "secret about"
	cont "mining properly."

	para "Beat me to find"
	line "out what it is!"
	done

Route71b_Trainer_2_Text_13eefb:
	ctxt "Alright, you wanna"
	line "hear it?"
	done

Route71b_Trainer_2_Script_Text_13ef17:
	ctxt "There are actually"
	line "different items"
	cont "you can mine out"
	cont "in various areas!"

	para "For instance, if"
	line "you're looking"
	cont "for fire stones,"

	para "mine deep into"
	line "Firelight Caverns!"
	done

Route71b_Trainer_3_Text_13ee1b:
	ctxt "Time to melt away"
	line "those chills."
	done

Route71b_Trainer_3_Text_13ee3c:
	ctxt "Well, now that"
	line "didn't work out."
	done

Route71b_Trainer_3_Script_Text_13ee5e:
	ctxt "If you head east"
	line "you'll end up in"
	cont "Firelight Caverns."

	para "That's where I"
	line "caught my #mon!"
	done

Route71b_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 25, 2, 8, CLATHRITE_1F
	warp_def 25, 26, 3, PHACELIA_WEST_EXIT
	warp_def 13, 24, 1, BATTLE_TOWER_ENTRANCE

.CoordEvents: db 0

.BGEvents: db 1
	signpost 22, 20, SIGNPOST_LOAD, Route71bSignpost1

.ObjectEvents: db 3 ; 4
	person_event SPRITE_JUGGLER, 21, 20, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, Route71b_Trainer_1, -1
	person_event SPRITE_FIREBREATHER, 26, 27, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 1, Route71b_Trainer_2, -1
	person_event SPRITE_FIREBREATHER, 25, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route71b_Trainer_3, -1
	; person_event SPRITE_YOUNGSTER, 14, 24, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route71BAnnoyingYoungsterScript, -1
