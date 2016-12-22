Route87_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route87Signpost1:
	ctxt "<UP>  Tunod Waterway"
	next "<UP><UP> Southerly City"
	next "<DOWN>  Laurel City"
	done

Route87_Trainer_1:
	trainer EVENT_ROUTE_87_TRAINER_1, SWIMMERM, 9, Route87_Trainer_1_Text_2fa659, Route87_Trainer_1_Text_2fa6a5, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route87_Trainer_1_Script_Text_2fa6bc

Route87_Trainer_2:
	trainer EVENT_ROUTE_87_TRAINER_2, SWIMMERF, 7, Route87_Trainer_2_Text_2f8da7, Route87_Trainer_2_Text_2f8ded, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route87_Trainer_2_Script_Text_2f8e22

Route87_Trainer_3:
	trainer EVENT_ROUTE_87_TRAINER_3, SWIMMERM, 10, Route87_Trainer_3_Text_2fa74e, Route87_Trainer_3_Text_2fa7b0, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route87_Trainer_3_Script_Text_2fa7e5

Route87_Trainer_1_Text_2fa659:
	ctxt "This is a long"
	line "waterway."

	para "Your #mon"
	line "better be prepared"
	para "for a major"
	line "workout!"
	done

Route87_Trainer_1_Text_2fa6a5:
	ctxt "That was too"
	line "intense!"
	done

Route87_Trainer_1_Script_Text_2fa6bc:
	ctxt "You should always"
	line "stretch before"
	para "swimming long"
	line "waterways."

	para "I do it in front"
	line "of the girls!"
	done

Route87_Trainer_2_Text_2f8da7:
	ctxt "Time for a calm"
	line "battle aided by"
	para "the gentle lull"
	line "of the ocean's"
	cont "waves."
	done

Route87_Trainer_2_Text_2f8ded:
	ctxt "You need to calm"
	line "down."
	done

Route87_Trainer_2_Script_Text_2f8e22:
	ctxt "You unleashed 3"
	line "years worth of"
	cont "repressed anger."
	done

Route87_Trainer_3_Text_2fa74e:
	ctxt "The closest"
	line "airport in Naljo"
	para "is the Southerly"
	line "Airport, and you"
	para "have to swim so"
	line "far to get to"
	cont "it!"
	done

Route87_Trainer_3_Text_2fa7b0:
	ctxt "Well I guess I'm"
	line "swimming the rest"
	cont "of the way there."
	done

Route87_Trainer_3_Script_Text_2fa7e5:
	ctxt "It turns out my"
	line "flight was"
	cont "delayed 4 hours."

	para "I woke up before"
	line "sunrise for"
	cont "nothing!"
	done

Route87_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $37, $a, 16, MAGIKARP_CAVERNS_MAIN
	warp_def $37, $b, 16, MAGIKARP_CAVERNS_MAIN

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 51, 12, SIGNPOST_LOAD, Route87Signpost1

	;people-events
	db 3
	person_event SPRITE_SWIMMER_GUY, 40, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route87_Trainer_1, -1
	person_event SPRITE_SWIMMER_GIRL, 23, 4, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route87_Trainer_2, -1
	person_event SPRITE_SWIMMER_GUY, 12, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route87_Trainer_3, -1
