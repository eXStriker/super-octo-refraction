HeathGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathGymHiddenItem_1:
	dw EVENT_HEATH_GYM_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

HeathGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_NATUREBADGE
	iftrue HeathGym_154de5
	writetext HeathGymNPC1_Text_154e83
	waitbutton
	closetext
	winlosstext HeathGymNPC1Text_154f26, 0
	loadtrainer RINJI, RINJI_GYM
	startbattle
	reloadmapafterbattle
	setflag ENGINE_NATUREBADGE
	opentext
	writetext HeathGymNPC1_Text_154f8c
	playwaitsfx SFX_TCG2_DIDDLY_5
	waitbutton
	playmapmusic
	writetext HeathGym_154f08_Text_154fa3
	playmusic MUSIC_LAUREL_FOREST
	buttonsound
	givetm 57 + RECEIVED_TM
	jumptext HeathGym_154dd8_Text_155060

HeathGym_Trainer_1:
	trainer EVENT_HEATH_GYM_TRAINER_1, BEAUTY, 1, HeathGym_Trainer_1_Text_15515e, HeathGym_Trainer_1_Text_15519d, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer HeathGym_Trainer_1_Script_Text_1551b9

HeathGym_Trainer_2:
	trainer EVENT_HEATH_GYM_TRAINER_2, YOUNGSTER, 3, HeathGym_Trainer_2_Text_1551e7, HeathGym_Trainer_2_Text_15521a, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer HeathGym_Trainer_2_Script_Text_155239

HeathGym_Trainer_3:
	trainer EVENT_HEATH_GYM_TRAINER_3, SCHOOLBOY, 1, HeathGym_Trainer_3_Text_15527e, HeathGym_Trainer_3_Text_1552da, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer HeathGym_Trainer_3_Script_Text_1552e4

HeathGym_Trainer_4:
	trainer EVENT_HEATH_GYM_TRAINER_4, TWINS, 1, HeathGym_Trainer_4_Text_15530f, HeathGym_Trainer_4_Text_155341, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer HeathGym_Trainer_4_Script_Text_155362

HeathGym_Trainer_5:
	jumptextfaceplayer HeathGym_Trainer_5_Script_Text_1553cf

HeathGymNPC2:
	faceplayer
	checkflag ENGINE_NATUREBADGE
	iftrue HeathGym_154e6c
	jumptext HeathGymNPC2_Text_1553fc

HeathGym_154de5:
	jumptext HeathGym_154de5_Text_1550fe

HeathGym_154e6c:
	jumptext HeathGym_154e6c_Text_1554bf

HeathGymNPC1_Text_154e83:
	ctxt "I'm Rinji."

	para "I am one with the"
	line "nature, and nature"
	cont "is one with me."

	para "How about you?"

	para "Do you feel the"
	line "nature around you?"

	para "You must learn"
	line "to live with it,"
	cont "not just in it."
	done

HeathGymNPC1Text_154f26:
	ctxt "Hmm<...>"

	para "I hope you learned"
	line "to appreciate the"
	cont "world as it is."

	para "Take this badge"
	line "with you."
	done

HeathGymNPC1_Text_154f8c:
	ctxt "<PLAYER> got"
	line "Nature Badge."
	done

HeathGym_Trainer_1_Text_15515e:
	ctxt "Hehe!"

	para "You can't beat my"
	line "Grass #mon!"
	done

HeathGym_Trainer_1_Text_15519d:
	ctxt "I'm not used to"
	line "failure!"
	done

HeathGym_Trainer_1_Script_Text_1551b9:
	ctxt "Everything always"
	line "goes perfectly"
	cont "for me in life<...>"

	para "Except this time."
	done

HeathGym_Trainer_2_Text_1551e7:
	ctxt "Grass-type #mon"
	line "are so underrated."

	para "Look!"
	done

HeathGym_Trainer_2_Text_15521a:
	ctxt "You proved how"
	line "tough you are<...>"
	done

HeathGym_Trainer_2_Script_Text_155239:
	ctxt "This stays between"
	line "you and me<...>"

	para "I'm only here for"
	line "the cute girls!"
	done

HeathGym_Trainer_3_Text_15527e:
	ctxt "This school is"
	line "my favorite kind!"
	done

HeathGym_Trainer_3_Text_1552da:
	ctxt "Urrgggh!"
	done

HeathGym_Trainer_3_Script_Text_1552e4:
	ctxt "I could learn a"
	line "thing or two!"
	done

HeathGym_Trainer_4_Text_15530f:
	ctxt "Amy: Hi!"

	para "Want to meet our"
	line "#mon?"
	done

HeathGym_Trainer_4_Text_155341:
	ctxt "Amy & May:"
	line "2 against 1<...>"

	para "Fair?"
	done

HeathGym_Trainer_4_Script_Text_155362:
	ctxt "Amy: You are real"
	line "good! Take care."
	done

HeathGym_Trainer_5_Script_Text_1553cf:
	ctxt "May: Perhaps we"
	line "should ask Rinji"
	cont "to help us more."
	done

HeathGymNPC2_Text_1553fc:
	ctxt "Yo, challenger!"

	para "Rinji takes his"
	line "Gym Leader duties"
	cont "very seriously."

	para "He is motivated"
	line "by nature, and"
	cont "the natural world"
	cont "surrounding him."
	done

HeathGym_154de5_Text_1550fe:
	ctxt "This region was"
	line "once all nature,"
	cont "but it's almost"
	cont "all gone now."

	para "Unacceptable!"
	done

HeathGym_154f08_Text_154fa3:
	ctxt "Nature Badge will"
	line "make the nature"
	cont "appreciate you up"
	cont "to level 40."

	para "Also, take this."
	done

HeathGym_154e6c_Text_1554bf:
	ctxt "Well done!"

	para "Rinji is a master"
	line "of focus, but you"
	cont "bested him!"
	done

HeathGym_154dd8_Text_155060:
	ctxt "TM57 contains"
	line "Razor Leaf!"

	para "The power of"
	line "nature will aid"
	cont "you with this."
	
	para "It also has a"
	line "better chance of"
	cont "critical hits!"
	done

HeathGym_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 3, 9, 1, HEATH_GYM_GATE
	warp_def 15, 35, 1, HEATH_GYM_HOUSE

.CoordEvents: db 0

.BGEvents: db 1
	signpost 9, 33, SIGNPOST_ITEM, HeathGymHiddenItem_1

.ObjectEvents: db 7
	person_event SPRITE_BUGSY, 6, 5, SPRITEMOVEDATA_SPINRANDOM_SLOW, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, HeathGymNPC1, -1
	person_event SPRITE_BEAUTY, 24, 35, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, HeathGym_Trainer_1, -1
	person_event SPRITE_YOUNGSTER, 32, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, HeathGym_Trainer_2, -1
	person_event SPRITE_SCHOOLBOY, 20, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, HeathGym_Trainer_3, -1
	person_event SPRITE_TWIN, 16, 24, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 1, HeathGym_Trainer_4, -1
	person_event SPRITE_TWIN, 16, 25, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 1, HeathGym_Trainer_5, -1
	person_event SPRITE_GYM_GUY, 4, 17, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, HeathGymNPC2, -1
