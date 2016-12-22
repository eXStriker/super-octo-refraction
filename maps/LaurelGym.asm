LaurelGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LaurelGymSignpost1:
	jumptext LaurelGymSignpost1_Text_163672

LaurelGymNPC1:
	faceplayer
	checkevent EVENT_POKEONLY_TOTODILE
	iffalse LaurelGym_160575
	checkevent EVENT_LAUREL_CITY_GOT_TOTODILE
	iftrue LaurelGym_16057b
	checkflag ENGINE_GULFBADGE
	iftrue LaurelGym_160578
	opentext
	writetext LaurelGymNPC1_Text_160280
	winlosstext LaurelGymNPC1Text_160346, 0
	loadtrainer BROOKLYN, 1
	startbattle
	reloadmapafterbattle
	setflag ENGINE_GULFBADGE
	opentext
	writetext LaurelGym_160628_Text_160610
	playwaitsfx SFX_TCG2_DIDDLY_5
	special RestartMapMusic
	writetext LaurelGym_160628_Text_160389
	waitbutton
	givetm 45 + RECEIVED_TM
	setevent EVENT_LAUREL_CITY_NPC_3
	closetext
	end

LaurelGym_Trainer_1:
	trainer EVENT_LAUREL_GYM_TRAINER_1, CHEERLEADER, 2, LaurelGym_Trainer_1_Text_1634d4, LaurelGym_Trainer_1_Text_1634f3, $0000, .Script

.Script:
	end_if_just_battled
	jumptext LaurelGym_Trainer_1_Script_Text_16350c

LaurelGym_Trainer_2:
	trainer EVENT_LAUREL_GYM_TRAINER_2, CHEERLEADER, 1, LaurelGym_Trainer_2_Text_16344c, LaurelGym_Trainer_2_Text_163478, $0000, .Script

.Script:
	end_if_just_battled
	jumptext LaurelGym_Trainer_2_Script_Text_163490

LaurelGymNPC2:
	faceplayer
	opentext
	checkevent EVENT_POKEONLY_TOTODILE
	iffalse LaurelGym_162166
	checkevent EVENT_LAUREL_CITY_GOT_TOTODILE
	iftrue LaurelGym_16216c
	jumptext LaurelGymNPC2_Text_1604e8

LaurelGym_160575:
	jumptext LaurelGym_160575_Text_160000

LaurelGym_16057b:
	jumptext LaurelGym_16057b_Text_160491

LaurelGym_160578:
	jumptext LaurelGym_160578_Text_160448

LaurelGym_162166:
	jumptext LaurelGym_162166_Text_160100

LaurelGym_16216c:
	jumptext LaurelGym_16216c_Text_16055c

LaurelGymSignpost1_Text_163672:
	ctxt "Princess Brooklyn!"
	done

LaurelGymNPC1_Text_160280:
	ctxt "Thank you for"
	line "finding my sweet"
	cont "little Totodile!"

	para "Later I'm going"
	line "to put some"
	para "makeup on it and"
	line "make it look very"
	para "pretty and hold"
	line "it all day long!"

	para "Oh right, you want"
	line "my badge?"

	para "Well fine, let's"
	line "do this."

	para "I'm Brooklyn and"
	line "I train Fairy-"
	cont "type #mon."

	para "They're just so"
	line "adorable that I"
	cont "just can't resist"
	cont "this type!"
	prompt

LaurelGymNPC1Text_160346:
	ctxt "Alright alright,"
	line "so you beat me."

	para "Fine, take this"
	line "gram of metal."
	done

LaurelGym_Trainer_1_Text_1634d4:
	ctxt "A battle with me!"

	para "Lucky you!"
	done

LaurelGym_Trainer_1_Text_1634f3:
	ctxt "You burned this"
	line "bridge forever."
	done

LaurelGym_Trainer_1_Script_Text_16350c:
	ctxt "Your reputation"
	line "here is done for!"
	done

LaurelGym_Trainer_2_Text_16344c:
	ctxt "You're being rude"
	line "by coming in here"
	cont "unannounced."
	done

LaurelGym_Trainer_2_Text_163478:
	ctxt "That's totally"
	line "disrespectful."
	done

LaurelGym_Trainer_2_Script_Text_163490:
	ctxt "OK, like."

	para "Totally, whatever."
	done

LaurelGymNPC2_Text_1604e8:
	ctxt "Thank goodness"
	line "you saved her"
	cont "Totodile."

	para "I was getting a"
	line "headache from her"
	para "whining, and this"
	line "job doesn't pay"
	cont "enough."
	done

LaurelGym_160575_Text_160000:
	ctxt "HEY!"

	para "Who said you could"
	line "barge in here?"

	para "<...>"

	para "WHAT?"

	para "'Be nice?'"

	para "My baby is MISS-"
	line "ING, you creep!"

	para "<...>"

	para "Why, by baby I"
	line "mean my Totodile."

	para "I refuse to battle"
	line "anyone until my"
	cont "baby is returned."

	para "Want my badge?"

	para "Then you better"
	line "go look for my"
	cont "sweet Totodile."

	para "NOW!"
	done

LaurelGym_16057b_Text_160491:
	ctxt "MY TOTODILE IS"
	line "GONE AGAIN!!!"

	para "<...>"

	para "What do you mean,"
	line "'you won't help"
	cont "me find it'?"

	para "GET OUT!"
	done

LaurelGym_160578_Text_160448:
	ctxt "If you excuse me,"
	line "I need to put"
	para "on dresses for"
	line "my cute darling"
	cont "little Totodile!"
	done

LaurelGym_160628_Text_160610:
	ctxt "<PLAYER> received"
	line "Charm Badge!"
	done

LaurelGym_160628_Text_160389:
	ctxt "So for some reason"
	line "the Charm Badge"
	para "will let your"
	line "#mon use"
	para "Strength outside"
	line "of battle."

	para "Also, since I'm"
	line "such a little"
	para "angel, I'll let"
	line "you have this."
	done

LaurelGym_162166_Text_160100:
	ctxt "Hey there!"

	para "Brooklyn is the"
	line "Gym Leader here."

	para "She can be loud"
	line "and annoying when"
	para "she doesn't get"
	line "her way."

	para "<...>"

	para "Oh, so you need"
	line "Brooklyn's badge?"
	cont "Well, shoot<...>"

	para "She is having some"
	line "personal troubles"
	para "right now, and I"
	line "don't know much."

	para "All I can remember"
	line "is some abductions"
	para "have been going on"
	line "in this town the"
	cont "last few months."

	para "One person cited"
	line "that one of the"
	para "kidnappers looked"
	line "to be a scientist."

	para "Another said they"
	line "saw some shadowy"
	para "figure carry their"
	line "#mon away to"
	para "the forest, to the"
	line "south of town."

	para "You might want"
	line "to look there<...>"
	done

LaurelGym_16216c_Text_16055c:
	ctxt "Oh geeze, not"
	line "again<...>"
	done

LaurelGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $8, 8, LAUREL_CITY
	warp_def $11, $9, 8, LAUREL_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 3, 4, SIGNPOST_READ, LaurelGymSignpost1
	signpost 3, 13, SIGNPOST_READ, LaurelGymSignpost1

	;people-events
	db 4
	person_event SPRITE_WHITNEY, 2, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, LaurelGymNPC1, -1
	person_event SPRITE_CHEERLEADER, 6, 4, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 1, LaurelGym_Trainer_1, -1
	person_event SPRITE_CHEERLEADER, 10, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 1, LaurelGym_Trainer_2, -1
	person_event SPRITE_GYM_GUY, 12, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, LaurelGymNPC2, -1
