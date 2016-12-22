Route78_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route78HiddenItem_1:
	dw EVENT_ROUTE_78_HIDDENITEM_HYPER_POTION
	db HYPER_POTION

Route78Signpost1:
	ctxt "<UP> Phacelia"
	next "<DOWN><LEFT>Ruins"
	next "<DOWN><RIGHT>Route 79"
	done ;35

Route78_Trainer_1:
	trainer EVENT_ROUTE_78_TRAINER_1, SWIMMERM, 3, Route78_Trainer_1_Text_1324c3, Route78_Trainer_1_Text_1324ff, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route78_Trainer_1_Script_Text_132506

Route78_Trainer_2:
	trainer EVENT_ROUTE_78_TRAINER_2, SWIMMERM, 4, Route78_Trainer_2_Text_132542, Route78_Trainer_2_Text_132572, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route78_Trainer_2_Script_Text_13258b

Route78_Trainer_3:

	trainer EVENT_ROUTE_78_TRAINER_3, SWIMMERF, 3, Route78_Trainer_3_Text_1337b1, Route78_Trainer_3_Text_1337d5, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route78_Trainer_3_Script_Text_133809

Route78_Trainer_4:
	trainer EVENT_ROUTE_78_TRAINER_4, SWIMMERF, 4, Route78_Trainer_4_Text_133858, Route78_Trainer_4_Text_133887, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route78_Trainer_4_Script_Text_1338bb

Route78NPC1:
	jumpstd smashrock

Route78NPC2:
	jumptextfaceplayer Route78NPC2_Text_1334c3

Route78NPC5:
	faceplayer
	opentext
	writetext Route78NPC5_Text_13274b
	checkitem FAKE_ID
	iffalse Route78_132744
	setevent EVENT_NALJO_ID_GUARD
	writetext Route78NPC5_Text_132782
	closetext
	playsound SFX_ENTER_DOOR
	applymovement 10, Route78NPC5_Movement1
	disappear 10
	closetext
	end

Route78NPC5_Movement1:
	step_up
	step_end

Route78_132744:
	jumptext Route78_132744_Text_1328a8

Route78_Trainer_1_Text_1324c3:
	ctxt "Floating at the"
	line "cove is life."

	para "Some girls find"
	line "this place pretty"
	cont "romantic."
	done

Route78_Trainer_1_Text_1324ff:
	ctxt "Dang."
	done

Route78_Trainer_1_Script_Text_132506:
	ctxt "This route is at"
	line "peak beauty when"
	cont "the sun sets<...>"
	done

Route78_Trainer_2_Text_132542:
	ctxt "The ruins hold a"
	line "lot of mysteries."

	para "So I'm told."
	done

Route78_Trainer_2_Text_132572:
	ctxt "Fine."

	para "I'll just explore"
	line "the area myself."
	done

Route78_Trainer_2_Script_Text_13258b:
	ctxt "If only someone"
	line "was brave enough"
	para "to go deep into"
	line "those ruins."

	para "Who knows what"
	line "discoveries lie"
	para "right underneath"
	line "us!"
	done

Route78_Trainer_3_Text_1337b1:
	ctxt "The #mon found"
	line "here are beauties."
	done

Route78_Trainer_3_Text_1337d5:
	ctxt "Admire their inner"
	line "beauty, and not"
	para "their fighting"
	line "abilities."
	done

Route78_Trainer_3_Script_Text_133809:
	ctxt "I wish I could"
	line "dive deep and see"
	cont "all of those cute"
	cont "water #mon!"
	done

Route78_Trainer_4_Text_133858:
	ctxt "My surfboard"
	line "broke<...> again!"

	para "Now I can't surf!"
	done

Route78_Trainer_4_Text_133887:
	ctxt "You really added"
	line "salt to the wound."

	para "Who do you think"
	line "you are<...>?"
	done

Route78_Trainer_4_Script_Text_1338bb:
	ctxt "When you surf on"
	line "your #mon,"

	para "consider how it"
	line "really feels."

	para "You don't want to"
	line "break a good pal"
	cont "of yours, do you?"
	done

Route78NPC2_Text_1334c3:
	ctxt "If you don't have"
	line "a way to get"
	cont "across the water,"

	para "your only option"
	line "is to go back to"
	para "the quarry and"
	line "then go east."
	done

Route78NPC5_Text_13274b:
	ctxt "I can't let anybody"
	line "in here without a"
	cont "proper Naljo ID."
	sdone

Route78NPC5_Text_132782:
	ctxt "Thanks for showing"
	line "me your ID Card."

	para "I'll now let you"
	line "visit the island."

	para "Is this your first"
	line "time visiting?"

	para "Well, Saxifrage is"
	line "where we lock up"
	para "those who commit"
	line "crimes: criminals!"

	para "You can look at"
	line "them, but please,"
	cont "don't feed them."

	para "After all, it's"
	line "like a zoo, but"
	cont "with less rights."
	sdone

Route78_132744_Text_1328a8:
	ctxt "You don't have it?"

	para "You're lucky I'm"
	line "nice to minors."

	para "Otherwise, I'd"
	line "arrest you right"
	cont "here on the spot."
	done

Route78_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $5, $a, 2, PHACELIA_WEST_EXIT
	warp_def $15, $4, 1, RUINS_ENTRY
	warp_def $15, $e, 1, ROUTE_78_EAST_EXIT

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 8, 12, SIGNPOST_LOAD, Route78Signpost1
	signpost 11, 18, SIGNPOST_ITEM, Route78HiddenItem_1

	;people-events
	db 9
	person_event SPRITE_SWIMMER_GUY, 15, 9, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, 0, 2, 4, Route78_Trainer_1, -1
	person_event SPRITE_SWIMMER_GUY, 22, 7, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 5, Route78_Trainer_2, -1
	person_event SPRITE_SWIMMER_GIRL, 20, 9, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 2, 2, Route78_Trainer_3, -1
	person_event SPRITE_SWIMMER_GIRL, 25, 12, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 2, 3, Route78_Trainer_4, -1
	person_event SPRITE_ROCK, 13, 4, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route78NPC1, -1
	person_event SPRITE_LASS, 6, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route78NPC2, -1
	person_event SPRITE_POKE_BALL, 15, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_DIG, 0, EVENT_ROUTE_78_TM28
	person_event SPRITE_POKE_BALL, 32, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_NOISE_PULSE, 0, EVENT_ROUTE_78_TM78
	person_event SPRITE_OFFICER, 22, 14, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route78NPC5, EVENT_NALJO_ID_GUARD
