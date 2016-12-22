HauntedForest_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HauntedForest_Item_1:
	db STARDUST, 1

HauntedForest_Trainer_1:
	trainer EVENT_HAUNTED_FOREST_TRAINER_1, SAGE, 2, HauntedForest_Trainer_1_Text_16dffa, HauntedForest_Trainer_1_Text_16e08b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext HauntedForest_Trainer_1_Script_Text_16e0c8

HauntedForest_Trainer_2:
	trainer EVENT_HAUNTED_FOREST_TRAINER_2, SAGE, 1, HauntedForest_Trainer_2_Text_16df4b, HauntedForest_Trainer_2_Text_16df88, $0000, .Script

.Script:
	end_if_just_battled
	jumptext HauntedForest_Trainer_2_Script_Text_16dfac

HauntedForest_Trainer_3:
	trainer EVENT_HAUNTED_FOREST_TRAINER_3, MEDIUM, 1, HauntedForest_Trainer_3_Text_16e1a1, HauntedForest_Trainer_3_Text_16e0e3, $0000, HauntedForest_Trainer_3_Script

SkipGravestoneCheck:
	closetext
	end

RedGravestone:
	opentext
	writetext RedGravestoneText
	waitbutton
	checkevent EVENT_HAUNTED_MANSION_KEY
	iftrue SkipGravestoneCheck
	checkevent EVENT_0
	iftrue WrongGravestone
	setevent EVENT_0
	jump RightGravestone

TealGravestone:
	opentext
	writetext TealGravestoneText
	waitbutton
	checkevent EVENT_HAUNTED_MANSION_KEY
	iftrue SkipGravestoneCheck
	checkevent EVENT_4
	iffalse WrongGravestone
	writetext GotMansionKeyText
	waitbutton
	verbosegiveitem MANSION_KEY, 1
	waitbutton
	setevent EVENT_HAUNTED_MANSION_KEY
	closetext
	end

GreyGravestone:
	opentext
	writetext GreyGravestoneText
	waitbutton
	checkevent EVENT_HAUNTED_MANSION_KEY
	iftrue SkipGravestoneCheck
	checkevent EVENT_0
	iffalse WrongGravestone
	checkevent EVENT_1
	iftrue WrongGravestone
	setevent EVENT_1
	jump RightGravestone

YellowGravestone:
	opentext
	writetext YellowGravestoneText
	waitbutton
	checkevent EVENT_HAUNTED_MANSION_KEY
	iftrue SkipGravestoneCheck
	checkevent EVENT_2
	iffalse WrongGravestone
	checkevent EVENT_3
	iftrue WrongGravestone
	setevent EVENT_3
	jump RightGravestone

BrownGravestone:
	opentext
	writetext BrownGravestoneText
	waitbutton
	checkevent EVENT_HAUNTED_MANSION_KEY
	iftrue SkipGravestoneCheck
	checkevent EVENT_3
	iffalse WrongGravestone
	checkevent EVENT_4
	iftrue WrongGravestone
	setevent EVENT_4
	jump RightGravestone

BlueGravestone:
	opentext
	writetext BlueGravestoneText
	waitbutton
	checkevent EVENT_HAUNTED_MANSION_KEY
	iftrue SkipGravestoneCheck
	checkevent EVENT_1
	iffalse WrongGravestone
	checkevent EVENT_2
	iftrue WrongGravestone
	setevent EVENT_2
	jump RightGravestone

RightGravestone:
	playsound SFX_GLASS_TING
	writetext GoodGravestoneText
	endtext

WrongGravestone:
	playsound SFX_WRONG
	writetext WrongGravestoneText
	waitbutton
	closetext
	clearevent EVENT_0
	clearevent EVENT_1
	clearevent EVENT_2
	clearevent EVENT_3
	clearevent EVENT_4
	end

HauntedForest_Trainer_3_Script:
	end_if_just_battled
	jumptext HauntedForest_Trainer_3_Script_Text_16e15c

GotMansionKeyText:
	ctxt "A hand reaches"
	line "out of the ground"
	cont "and hands you key!"
	done

GoodGravestoneText:
	ctxt "That sound is"
	line "reassuring!"
	done

RedGravestoneText:
	ctxt "It's a red"
	line "gravestone."
	done

GreyGravestoneText:
	ctxt "It's a grey"
	line "gravestone."
	done

BlueGravestoneText:
	ctxt "It's a blue"
	line "gravestone."
	done

YellowGravestoneText:
	ctxt "It's a yellow"
	line "gravestone."
	done

BrownGravestoneText:
	ctxt "It's a brown"
	line "gravestone."
	done

TealGravestoneText:
	ctxt "It's a teal"
	line "gravestone."
	done

WrongGravestoneText:
	ctxt "That doesn't sound"
	line "right."
	done

HauntedForest_Trainer_1_Text_16dffa:
	ctxt "An insincere and"
	line "evil friend is"
	para "more to be feared"
	line "than a wild beast."

	para "A wild beast may"
	line "wound your body,"

	para "but an evil friend"
	line "- he will wound"
	cont "your very mind."
	done

HauntedForest_Trainer_1_Text_16e08b:
	ctxt "Ambition is like"
	line "love, impatient"
	para "both of delays"
	line "and rivals."
	done

HauntedForest_Trainer_1_Script_Text_16e0c8:
	ctxt "A jug fills drop"
	line "by drop."
	done

HauntedForest_Trainer_2_Text_16df4b:
	ctxt "For those who live"
	line "wisely in life,"

	para "even death itself"
	line "isn't to be feared."
	done

HauntedForest_Trainer_2_Text_16df88:
	ctxt "He is able who"
	line "thinks he is able."
	done

HauntedForest_Trainer_2_Script_Text_16dfac:
	ctxt "Hatred does not"
	line "cease by hatred,"
	cont "but only by love."

	para "This is the true"
	line "eternal rule."
	done

HauntedForest_Trainer_3_Text_16e1a1:
	ctxt "Believe nothing,"
	line "no matter where"
	para "you read it, or"
	line "who said it, no"
	para "matter if I have"
	line "said it, unless"
	para "it agrees with"
	line "your own reason"
	para "and your own"
	line "common sense."
	done

HauntedForest_Trainer_3_Text_16e0e3:
	ctxt "Have compassion"
	line "for all beings,"
	para "rich and poor"
	line "alike. Each has"
	cont "their suffering."

	para "Some suffer too"
	line "much, others far"
	cont "too little."
	done

HauntedForest_Trainer_3_Script_Text_16e15c:
	ctxt "Better than a"
	line "thousand hollow"
	para "words, is one word"
	line "that brings peace."
	done

HauntedForest_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $26, $d, 1, HAUNTED_FOREST_GATE
	warp_def $27, $d, 2, HAUNTED_FOREST_GATE
	warp_def $5, $6, 1, HAUNTED_MANSION

	;xy triggers
	db 0

	;signposts
	db 6
	signpost $14, $06, SIGNPOST_READ, RedGravestone
	signpost $02, $21, SIGNPOST_READ, TealGravestone
	signpost $06, $26, SIGNPOST_READ, GreyGravestone
	signpost $06, $09, SIGNPOST_READ, YellowGravestone
	signpost $16, $23, SIGNPOST_READ, BrownGravestone
	signpost $18, $25, SIGNPOST_READ, BlueGravestone

	;people-events
	db 5
	person_event SPRITE_POKE_BALL, 38, 29, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 3, TM_NIGHT_SHADE, 0, EVENT_GOT_TM05
	person_event SPRITE_POKE_BALL, 19, 1, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, HauntedForest_Item_1, EVENT_HAUNTED_FOREST_ITEM_1
	person_event SPRITE_SAGE, 11, 14, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, HauntedForest_Trainer_1, -1
	person_event SPRITE_SAGE, 29, 15, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, HauntedForest_Trainer_2, -1
	person_event SPRITE_GRANNY, 10, 36, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 2, 3, HauntedForest_Trainer_3, -1
