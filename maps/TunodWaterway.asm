TunodWaterway_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

TunodWaterwayNPC1:
	fruittree 22

TunodWaterway_Trainer_1:
	trainer EVENT_TUNOD_WATERWAY_TRAINER_1, SWIMMERM, 11, TunodWaterway_Trainer_1_Text_2f8e7f, TunodWaterway_Trainer_1_Text_2f8e9d, $0000, .Script

.Script:
	end_if_just_battled
	jumptext TunodWaterway_Trainer_1_Script_Text_2f8ee4

TunodWaterway_Trainer_2:
	trainer EVENT_TUNOD_WATERWAY_TRAINER_2, SWIMMERF, 8, TunodWaterway_Trainer_2_Text_2fa84f, TunodWaterway_Trainer_2_Text_2fa898, $0000, .Script

.Script:
	end_if_just_battled
	jumptext TunodWaterway_Trainer_2_Script_Text_2fa8c9

TunodWaterway_Trainer_1_Text_2f8e7f:
	ctxt "Swim for yourself"
	line "like I do!"
	done

TunodWaterway_Trainer_1_Text_2f8e9d:
	ctxt "I thought my"
	line "#mon would"
	para "have more energy"
	line "by not carrying"
	cont "me around<...>"
	done

TunodWaterway_Trainer_1_Script_Text_2f8ee4:
	ctxt "You should be"
	line "considerate that"
	para "we now have the"
	line "technology to"
	cont "tame #mon."
	done

TunodWaterway_Trainer_2_Text_2fa84f:
	ctxt "This used to be"
	line "my secret spot."

	para "Before Southerly"
	line "opened up that"
	cont "path<...>"
	done

TunodWaterway_Trainer_2_Text_2fa898:
	ctxt "Now, you see why"
	line "I wanted this"
	cont "place to myself?"
	done

TunodWaterway_Trainer_2_Script_Text_2fa8c9:
	ctxt "We lose more and"
	line "more privacy"
	para "every time the"
	line "world decides to"
	cont "become smaller."
	done

TunodWaterway_MapEventHeader ;filler
	db 0, 0

;warps
	db 0

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_FRUIT_TREE, 6, 18, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, TunodWaterwayNPC1, -1
	person_event SPRITE_SWIMMER_GUY, 11, 21, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, TunodWaterway_Trainer_1, EVENT_TUNOD_WATERWAY_TRAINER_1
	person_event SPRITE_SWIMMER_GIRL, 7, 40, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 5, TunodWaterway_Trainer_2, EVENT_TUNOD_WATERWAY_TRAINER_2
