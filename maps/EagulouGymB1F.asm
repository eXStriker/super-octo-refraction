EagulouGymB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, EagulouPrisonDoors

EagulouPrisonDoors:
	checkevent EVENT_EAGULOU_DOOR_1
	sif true
		changeblock 4, 4, $57
	checkevent EVENT_EAGULOU_DOOR_2
	sif true
		changeblock 16, 4, $57
	checkevent EVENT_EAGULOU_DOOR_3
	sif true
		changeblock 4, 14, $57
	checkevent EVENT_EAGULOU_DOOR_4
	sif true
		changeblock 16, 14, $57
	return

EagulouGymB1FDoor1:
	checkevent EVENT_EAGULOU_GYM_B1F_TRAINER_1
	sif false
		jumptext EagulouGymB1F_Text_KeysWontWork
	checkevent EVENT_EAGULOU_DOOR_1
	sif true
		end
	opentext
	checkitem CAGE_KEY
	sif false
		jumptext EagulouGymB1F_Text_DoorIsLocked
	writetext EagulouGymB1F_Text_UnlockedDoor
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 4, 4, $57
	reloadmappart
	setevent EVENT_EAGULOU_DOOR_1
	closetext
	end

EagulouGymB1FDoor2:
	checkevent EVENT_EAGULOU_GYM_B1F_TRAINER_3
	sif false
		jumptext EagulouGymB1F_Text_KeysWontWork
	checkevent EVENT_EAGULOU_DOOR_2
	sif true
		end
	opentext
	checkitem CAGE_KEY
	sif false
		jumptext EagulouGymB1F_Text_DoorIsLocked
	writetext EagulouGymB1F_Text_UnlockedDoor
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 16, 4, $57
	reloadmappart
	setevent EVENT_EAGULOU_DOOR_2
	closetext
	end

EagulouGymB1FDoor3:
	checkevent EVENT_EAGULOU_DOOR_3
	sif true
		end
	opentext
	checkitem CAGE_KEY
	sif false
		jumptext EagulouGymB1F_Text_DoorIsLocked
	writetext EagulouGymB1F_Text_UnlockedDoor
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 4, 14, $57
	reloadmappart
	setevent EVENT_EAGULOU_DOOR_3
	closetext
	end

EagulouGymB1FDoor4:
	checkevent EVENT_EAGULOU_GYM_B1F_TRAINER_2
	sif false
		jumptext EagulouGymB1F_Text_KeysWontWork
	checkevent EVENT_EAGULOU_DOOR_4
	sif true
		end
	opentext
	checkitem CAGE_KEY
	sif false
		jumptext EagulouGymB1F_Text_DoorIsLocked
	writetext EagulouGymB1F_Text_UnlockedDoor
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	changeblock 16, 14, $57
	reloadmappart
	setevent EVENT_EAGULOU_DOOR_4
	closetext
	end

EagulouGymB1F_Trainer_1:
	trainer EVENT_EAGULOU_GYM_B1F_TRAINER_1, GRUNTM, 1, EagulouGymB1F_Trainer_1_Text_BeforeBattle, EagulouGymB1F_Trainer_1_Text_BattleWon, $0000, .Script
.Script
	opentext
	checkevent EVENT_EAGULOU_JAIL_GOT_NPC_KEY_1
	sif true
		jumptext EagulouGymB1F_Trainer_1_Text_AfterBattle
	writetext EagulouGymB1F_Trainer_1_Text_GiveKey
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	sif false, then
		waitbutton
		jumptext EagulouGymB1F_Text_NoSpace
	sendif
	setevent EVENT_EAGULOU_JAIL_GOT_NPC_KEY_1
	closetext
	end

EagulouGymB1F_Trainer_2:
	trainer EVENT_EAGULOU_GYM_B1F_TRAINER_2, SAILOR, 3, EagulouGymB1F_Trainer_2_Text_BeforeBattle, EagulouGymB1F_Trainer_2_Text_BattleWon, $0000, .Script
.Script
	opentext
	checkevent EVENT_EAGULOU_JAIL_GOT_NPC_KEY_2
	sif true
		jumptext EagulouGymB1F_Trainer_2_Text_AfterBattle
	writetext EagulouGymB1F_Trainer_2_Text_GiveKey
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	sif false, then
		waitbutton
		jumptext EagulouGymB1F_Text_NoSpace
	sendif
	setevent EVENT_EAGULOU_JAIL_GOT_NPC_KEY_2
	closetext
	end

EagulouGymB1F_Trainer_3:
	trainer EVENT_EAGULOU_GYM_B1F_TRAINER_3, PATROLLER, 20, EagulouGymB1F_Trainer_3_Text_BeforeBattle, EagulouGymB1F_Trainer_3_Text_BattleWon, $0000, .Script
.Script
	opentext
	checkevent EVENT_EAGULOU_JAIL_GOT_NPC_KEY_3
	sif true
		jumptext EagulouGymB1F_Trainer_3_Text_AfterBattle
	writetext EagulouGymB1F_Trainer_3_Text_GiveKey
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	sif false, then
		waitbutton
		jumptext EagulouGymB1F_Text_NoSpace
	sendif
	setevent EVENT_EAGULOU_JAIL_GOT_NPC_KEY_3
	closetext
	end

EagulouGymB1FGuide:
	jumptextfaceplayer EagulouGymB1FGuide_Text

EagulouGymB1F_Item_1:
	db CAGE_KEY, 1

EagulouGymB1FLeader:
	faceplayer
	opentext
	checkflag ENGINE_STARBADGE
	sif true
		jumptext EagulouGymB1FLeader_Text_AfterBattle
	writetext EagulouGymB1FLeader_Text_BeforeBattle
	winlosstext EagulouGymB1FLeader_Text_BattleWon, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer SILVER, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext EagulouGymB1FLeader_Text_GiveBadge
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_STARBADGE
	playmusic MUSIC_GYM
	writetext EagulouGymB1FLeader_Text_AfterBadge
	waitbutton
	givetm 8 + RECEIVED_TM
	jumptext EagulouGymB1FLeader_Text_GiveTM

EagulouGymB1F_Text_UnlockedDoor:
	ctxt "Unlocked the"
	line "door!"
	done

EagulouGymB1F_Trainer_1_Text_BeforeBattle:
	ctxt "The spirit of Team"
	line "Rocket shall live"
	cont "on!"
	done

EagulouGymB1F_Trainer_1_Text_BattleWon:
	ctxt "Ouch, fine, I'll"
	line "take a break."
	done

EagulouGymB1F_Trainer_1_Text_GiveKey:
	ctxt "If you want annoy"
	line "that pathetic"

	para "Pallet Patroller,"
	line "then take this"
	cont "key."
	done

EagulouGymB1FLeader_Text_AfterBattle:
	ctxt "Never forget the"
	line "special bond you"

	para "hold with your"
	line "#mon."
	done

EagulouGymB1F_Trainer_2_Text_BeforeBattle:
	ctxt "Can't blame a guy"
	line "for trying to"

	para "hijack a ship full"
	line "of rare #mon."
	done

EagulouGymB1F_Trainer_2_Text_BattleWon:
	ctxt "Guess I gotta"
	line "serve my time."
	done

EagulouGymB1F_Trainer_2_Text_GiveKey:
	ctxt "Well here's the"
	line "key to the Rocket"
	cont "cage."
	done

EagulouGymB1F_Trainer_3_Text_BeforeBattle:
	ctxt "This jail is so"
	line "icky!"

	para "I know, I'll refuse"
	line "to eat and then"
	cont "they'll let me go!"
	done

EagulouGymB1F_Trainer_3_Text_BattleWon:
	ctxt "Come on now, my"
	line "boyfriend will"

	para "not be happy to"
	line "hear about this!"
	done

EagulouGymB1F_Trainer_3_Text_GiveKey:
	ctxt "Go bother the"
	line "warden, I'm tired"
	cont "of you."
	done

EagulouGymB1FGuide_Text:
	ctxt "This is pretty"
	line "much an extension"

	para "of Saxifrage"
	line "Island."

	para "They got so filled"
	line "up that they we"

	para "decided to take"
	line "care of some of"
	cont "their criminals."
	done

EagulouGymB1F_Text_KeysWontWork:
	ctxt "None of your keys"
	line "will work on"
	cont "this door."
	done

EagulouGymB1F_Text_DoorIsLocked:
	ctxt "The door is"
	line "locked."
	done

EagulouGymB1F_Trainer_1_Text_AfterBattle:
	ctxt "I'm forever loyal"
	line "to Giovanni."

	para "He'll return one"
	line "day and reunite"
	cont "Team Rocket!"
	done

EagulouGymB1FLeader_Text_BeforeBattle:
	ctxt "<...> My name's"
	line "Silver."

	para "I'm the Warden and"
	line "Gym Leader of"
	cont "Eagulou."

	para "I used to believe"
	line "that having strong"

	para "#mon was the"
	line "bottom line!"

	para "#mon may be"
	line "considered weak,"

	para "but the bond be-"
	line "tween a Trainer"

	para "and a #mon"
	line "has unlimited"
	cont "potential!"

	para "Be patient and"
	line "your #mon will"

	para "become your"
	line "greatest ally!"

	para "<PLAYER>!"

	para "I challenge you!"
	done

EagulouGymB1FLeader_Text_BattleWon:
	ctxt "<...> That's"
	line "impressive."

	para "You share a strong"
	line "bond with your"
	cont "team!"
	done

EagulouGymB1FLeader_Text_GiveBadge:
	ctxt "<PLAYER> received"
	line "Star Badge!"
	done

EagulouGymB1FLeader_Text_AfterBadge:
	ctxt "<...>I think you're"
	line "worthy of this."

	para "I earned this"
	line "several years ago"

	para "from Sprout Tower's"
	line "wise Elder."

	para "I understood his"
	line "advice several"
	cont "years later."

	para "#mon are not"
	line "tools of war."
	done

EagulouGymB1FLeader_Text_GiveTM:
	ctxt "<...>This TM is"
	line "called Flash."

	para "It's not a popular"
	line "TM, but it will"

	para "light up dark"
	line "places & lower"

	para "the accuracy of"
	line "the foe during"
	cont "battles."
	done

EagulouGymB1F_Trainer_2_Text_AfterBattle:
	ctxt "I'll be sentenced"
	line "to life if I make"
	cont "a run for it!"
	done

EagulouGymB1F_Text_NoSpace:
	ctxt "Free up some"
	line "space, will ya?!"
	done

EagulouGymB1F_Trainer_3_Text_AfterBattle:
	ctxt "Can you sneak me"
	line "in some cupcakes?"
	done

EagulouGymB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $10, $11, 2, EAGULOU_GYM_F1

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 4, 4, SIGNPOST_READ, EagulouGymB1FDoor1
	signpost 4, 16, SIGNPOST_READ, EagulouGymB1FDoor2
	signpost 14, 4, SIGNPOST_READ, EagulouGymB1FDoor3
	signpost 14, 16, SIGNPOST_READ, EagulouGymB1FDoor4

	;people-events
	db 6
	person_event SPRITE_ROCKET, 12, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 2, 0, EagulouGymB1F_Trainer_1, -1
	person_event SPRITE_SILVER, 2, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, EagulouGymB1FLeader, -1
	person_event SPRITE_SAILOR, 12, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 2, 0, EagulouGymB1F_Trainer_2, -1
	person_event SPRITE_PALETTE_PATROLLER, 2, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, 8 + PAL_OW_PURPLE, 2, 0, EagulouGymB1F_Trainer_3, -1
	person_event SPRITE_OFFICER, 8, 10, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 0, 0, EagulouGymB1FGuide, -1
	person_event SPRITE_POKE_BALL, 6, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, EagulouGymB1F_Item_1, EVENT_EAGULOU_GYM_B1F_ITEM_1
