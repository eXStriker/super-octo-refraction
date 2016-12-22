Route55_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Route55UnlockRijonSecondHalf

Route55UnlockRijonSecondHalf:
	setevent EVENT_RIJON_SECOND_PART
	return

Route55HiddenItem_1:
	dw EVENT_ROUTE_55_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route55Signpost1:
	checkcode VAR_FACING
	loadarray .SignpostPointersArray
	readarrayhalfword 0
	loadsignpost -1

.SignpostPointersArray
	dw .FacingDown
.SignpostPointersArrayEntrySizeEnd:
	dw .FacingUp
	dw .FacingLeft
	dw .FacingRight

.FacingUp
	ctxt "(removed)"
	nl   " Studios."
	nl   "<UP>"
	nl   "<UP>@"
	start_asm
	ld hl, .facingUpEntryPoint
	ret

.FacingDown
	ctxt "(removed)"
	nl   " Studios.@"
.facingUpEntryPoint
	ctxt ""
	nl   "    <UP>"
	nl   "    <UP>"
	nl   "    <UP>"
	nl   "    <LEFT>@"
.facingLeftEntryPoint
	ctxt "<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT> You"
	done

.FacingLeft
	ctxt "(removed)"
	nl   " Studios."
	nl   "    <UP>"
	nl   "    <UP>"
	nl   "    <UP>"
	nl   "    <LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>"
	nl   "           <UP>"
	nl   "          You"
	done

.FacingRight
	ctxt "(removed)"
	nl   " Studios."
	nl   "    <UP>"
	nl   "    <UP>"
	nl   "    <UP>"
	nl   "    <UP>@"
	start_asm
	ld hl, .facingLeftEntryPoint
	ret

Route55_Trainer_1:
	trainer EVENT_ROUTE_55_TRAINER_1, HIKER, 5, Route55_Trainer_1_Text_33213d, Route55_Trainer_1_Text_332168, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route55_Trainer_1_Script_Text_332178
	endtext

Route55_Trainer_2:
	trainer EVENT_ROUTE_55_TRAINER_2, HIKER, 6, Route55_Trainer_2_Text_3321c1, Route55_Trainer_2_Text_3321ee, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route55_Trainer_2_Script_Text_3321fe
	endtext

Route55_Trainer_3:
	trainer EVENT_ROUTE_55_TRAINER_3, GENTLEMAN, 1, Route55_Trainer_3_Text_33225a, Route55_Trainer_3_Text_332281, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext Route55_Trainer_3_Script_Text_3322a1
	endtext

Route55_Trainer_1_Text_33213d:
	ctxt "Taking the long"
	line "way is always"
	cont "refreshing!"
	done

Route55_Trainer_1_Text_332168:
	ctxt "Good exercise!"
	done

Route55_Trainer_1_Script_Text_332178:
	ctxt "Why fly with your"
	line "#mon when you"
	cont "can walk with"
	cont "them?"
	done

Route55_Trainer_2_Text_3321c1:
	ctxt "Why didn't anyone"
	line "bother to clear"
	cont "this path?"
	done

Route55_Trainer_2_Text_3321ee:
	ctxt "Good exercise!"
	done

Route55_Trainer_2_Script_Text_3321fe:
	ctxt "Guess those crazy"
	line "guys up north"
	cont "want their"
	cont "studios to be in"
	cont "seclusion."
	done

Route55_Trainer_3_Text_33225a:
	ctxt "Enter this"
	line "building at your"
	cont "own risk!"
	done

Route55_Trainer_3_Text_332281:
	ctxt "Don't listen to"
	line "false prophets."
	done

Route55_Trainer_3_Script_Text_3322a1:
	ctxt "Those guys"
	line "believe that our"
	cont "world is nothing"
	cont "more than a game"
	cont "and that they"
	cont "created it."

	para "I can't stand"
	line "egomaniacs<...>"
	done

Route55_MapEventHeader:: db 0, 0

.Warps: db 4
	warp_def 7, 0, 1, SILK_TUNNEL_1F
	warp_def 5, 13, 2, ROUTE_55_GATE_UNDERGROUND
	warp_def 21, 6, 6, CAPER_CITY
	warp_def 49, 12, 1, MT_BOULDER_B1F

.CoordEvents: db 0

.BGEvents: db 2
	signpost 25, 13, SIGNPOST_READ, Route55Signpost1
	signpost 30, 2, SIGNPOST_ITEM, Route55HiddenItem_1

.ObjectEvents: db 3
	person_event SPRITE_FISHER, 53, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, Route55_Trainer_1, -1
	person_event SPRITE_FISHER, 49, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, Route55_Trainer_2, -1
	person_event SPRITE_GENTLEMAN, 27, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route55_Trainer_3, -1
