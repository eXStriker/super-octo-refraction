AcaniaGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaGymNPC1:
	jumptext AcaniaGymNPC1_Text_24c8fd

AcaniaGymNPC2:
	jumptext AcaniaGymNPC1_Text_24c8fd

AcaniaGymNPC3:
	faceplayer
	opentext
	checkflag ENGINE_HAZEBADGE
	iftrue AcaniaGym_24c815
	jumptext AcaniaGymNPC3_Text_24c81b

AcaniaGym_Trainer_1:
	trainer EVENT_ACANIA_GYM_TRAINER_1, BEAUTY, 5, AcaniaGym_Trainer_1_Text_24ca24, AcaniaGym_Trainer_1_Text_24ca69, $0000, .Script

.Script:
	opentext
	checkevent EVENT_ACANIA_GAS_CLOUD_2
	iftrue AcaniaGym_24ca1d
	writetext AcaniaGym_Trainer_1_Script_Text_24ca76
	waitbutton
	disappear 3
	setevent EVENT_ACANIA_GAS_CLOUD_2
	jumptext AcaniaGym_Trainer_1_Script_Text_24cabf

AcaniaGym_Trainer_2:
	trainer EVENT_ACANIA_GYM_TRAINER_2, SUPER_NERD, 9, AcaniaGym_Trainer_2_Text_24c977, AcaniaGym_Trainer_2_Text_24c9a2, $0000, .Script

.Script:
	opentext
	checkevent EVENT_ACANIA_GAS_CLOUD_1
	iftrue AcaniaGym_24c970
	writetext AcaniaGym_Trainer_2_Script_Text_24c9ad
	waitbutton
	disappear 2
	setevent EVENT_ACANIA_GAS_CLOUD_1
	jumptext AcaniaGym_Trainer_2_Script_Text_24c9df

AcaniaGymNPC4:
	faceplayer
	opentext
	checkflag ENGINE_HAZEBADGE
	iffalse AcaniaGym_24cb0a
	jumptext AcaniaGymNPC4_Text_24cb3c

AcaniaGym_24c815:
	jumptext AcaniaGym_24c815_Text_24c8a5

AcaniaGym_24ca1d:
	jumptext AcaniaGym_Trainer_1_Script_Text_24cabf

AcaniaGym_24c970:
	jumptext AcaniaGym_Trainer_2_Script_Text_24c9df

AcaniaGym_24cb0a:
	writetext AcaniaGym_24cb0a_Text_24cbd4
	waitbutton
	winlosstext AcaniaGym_24cb0aText_24cd03, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer AYAKA, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext AcaniaGym_24cb0a_Text_24cd97
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_HAZEBADGE
	playmusic MUSIC_GYM
	writetext AcaniaGym_24cb0a_Text_24cdaf
	waitbutton
	givetm TM_MUSTARD_GAS + RECEIVED_TM
	jumptext AcaniaGym_24cb0a_Text_24cdc6

AcaniaGymNPC1_Text_24c8fd:
	ctxt "This toxic gas"
	line "cloud is blocking"
	cont "the way."

	para "Trying to go"
	line "through it could"
	cont "be dangerous."
	done

AcaniaGymNPC3_Text_24c81b:
	ctxt "This Gym Leader's"
	line "name is Ayaka."

	para "She specializes"
	line "in Gas-types."

	para "Do refrain from"
	line "breathing too"
	cont "much in here<...>"
	done

AcaniaGym_Trainer_1_Text_24ca24:
	ctxt "Uhhh<...>"

	para "I'm -coughs-"

	para "I'm all ready to"
	line "battle since I"

	para "-coughs- have"
	line "to or whatever."
	done

AcaniaGym_Trainer_1_Text_24ca69:
	ctxt "Ughhhhhh<...>"
	done

AcaniaGym_Trainer_1_Script_Text_24ca76:
	ctxt "I'll clear the"
	line "gas because I'm"
	cont "supposed to<...>"

	para "<...> because the"
	line "leader told me"
	cont "to do it<...> yeah."
	done

AcaniaGym_Trainer_1_Script_Text_24cabf:
	ctxt "Uhhh, I don't know"
	line "what else to say."

	para "I'm sleepy<...>"
	done

AcaniaGym_Trainer_2_Text_24c977:
	ctxt "Uhhh<...>"

	para "Oh yeah, let's"
	line "battle, why not?"
	done

AcaniaGym_Trainer_2_Text_24c9a2:
	ctxt "Nice one!"
	done

AcaniaGym_Trainer_2_Script_Text_24c9ad:
	ctxt "You know that gas"
	line "blocking your way?"

	para "That problem just"
	line "got blown away."
	done

AcaniaGym_Trainer_2_Script_Text_24c9df:
	ctxt "I'm going to"
	line "-coughs-"
	cont "keep training."
	done

AcaniaGymNPC4_Text_24cb3c:
	ctxt "Well I think I'm"
	line "just going to lie"

	para "down for a bit"
	line "until the next"
	cont "Trainer comes in."

	para "That could be a"
	line "while."

	para "Oh well!"

	para "Just go battle"
	line "other people"
	cont "please."
	done

AcaniaGym_24c815_Text_24c8a5:
	ctxt "Great, you managed"
	line "to defeat her."

	para "But sadly, the"
	line "horrible scent of"
	cont "this Gym remains!"
	done

AcaniaGym_24cb0a_Text_24cbd4:
	ctxt "Someone's here?"

	para "-rubs eyes-"

	para "OK, I see<...>"

	para "You're a knight"
	line "wielding a shovel?"

	para "No<...> you're just a"
	line "Trainer out to get"
	cont "my Gym badge."

	para "How boring<...>"
	line "-yawns-"

	para "Well, according to"
	line "my very demanding"

	para "schedule, I have"
	line "time for a battle"
	cont "so sure, OK."

	para "I'm Ayaka and I"
	line "use Gas #mon."

	para "OK, let's get this"
	line "over with already."
	done

AcaniaGym_24cb0aText_24cd03:
	ctxt "-coughs-"

	para "Well, that was"
	line "different, eh."

	para "Oh, fine here is"
	line "your, wait<...>"

	para "What's the badge's"
	line "name again?"

	para "Haze?"

	para "Who came up with"
	line "that stupid name?"

	para "Me?"

	para "Oh, OK then."
	done

AcaniaGym_24cb0a_Text_24cd97:
	ctxt "<PLAYER> received"
	line "Haze Badge."
	done

AcaniaGym_24cb0a_Text_24cdaf:
	ctxt "Take this TM too."
	done

AcaniaGym_24cb0a_Text_24cdc6:
	ctxt "This TM is called"
	line "Mustard Gas."

	para "It uhh<...>"

	para "My brain hurts,"
	line "you figure it out."
	done

AcaniaGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $4, 5, ACANIA_DOCKS
	warp_def $d, $5, 5, ACANIA_DOCKS

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 6
	person_event SPRITE_SUDOWOODO, 7, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, AcaniaGymNPC1, EVENT_ACANIA_GAS_CLOUD_1
	person_event SPRITE_SUDOWOODO, 5, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, AcaniaGymNPC2, EVENT_ACANIA_GAS_CLOUD_2
	person_event SPRITE_GYM_GUY, 11, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, AcaniaGymNPC3, -1
	person_event SPRITE_BUENA, 4, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 2, 0, AcaniaGym_Trainer_1, -1
	person_event SPRITE_SUPER_NERD, 5, 1, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 2, 0, AcaniaGym_Trainer_2, -1
	person_event SPRITE_JASMINE, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, AcaniaGymNPC4, -1 
