Route49_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_NEWMAP, Route49BikeCheck

Route49BikeCheck:
	checkcode VAR_XCOORD
	if_equal 33, Route49PutOnBike
	clearflag ENGINE_ALWAYS_ON_BIKE
	return

Route49PutOnBike:
	setflag ENGINE_ALWAYS_ON_BIKE
	return

Route49HiddenItem_1:
	dw EVENT_ROUTE_49_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route49Signpost1:
	ctxt "<UP><LEFT> Route 48-B"
	next "<RIGHT> Owsauri City"
	done

Route49_Trainer_1:
	trainer EVENT_ROUTE_49_TRAINER_1, BIRD_KEEPER, 5, Route49_Trainer_1_Text_2f0de0, Route49_Trainer_1_Text_2f0e01, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route49_Trainer_1_Script_Text_2f0e23

Route49_Trainer_2:
	trainer EVENT_ROUTE_49_TRAINER_2, BIKER, 1, Route49_Trainer_2_Text_2f0e91, Route49_Trainer_2_Text_2f0eba, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route49_Trainer_2_Script_Text_2f0eec



Route49_Trainer_1_Text_2f0de0:
	ctxt "Fear my ferocious"
	line "Fearow force!"
	done

Route49_Trainer_1_Text_2f0e01:
	ctxt "Try saying that"
	line "five times fast!"
	done

Route49_Trainer_1_Script_Text_2f0e23:
	ctxt "My Fearow shall"
	line "grow stronger!"
	done

Route49_Trainer_2_Text_2f0e91:
	ctxt "You don't have"
	line "the legs to get"
	cont "to Johto!"
	done

Route49_Trainer_2_Text_2f0eba:
	ctxt "At least I have"
	line "my motorcycle to"
	cont "move me around."
	done

Route49_Trainer_2_Script_Text_2f0eec:
	ctxt "Get some wheels!"
	done

Route49_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $d, $2e, 1, ROUTE_50_GATE
	warp_def $7, $21, 2, ROUTE_49_GATE
	warp_def $d, $2f, 2, ROUTE_50_GATE
	warp_def $7, $28, 4, ROUTE_49_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 5, 41, SIGNPOST_LOAD, Route49Signpost1
	signpost 9, 26, SIGNPOST_ITEM, Route49HiddenItem_1

	;people-events
	db 2
	person_event SPRITE_SUPER_NERD, 6, 45, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, Route49_Trainer_1, -1
	person_event SPRITE_BIKER, 8, 13, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route49_Trainer_2, -1
