SoutherlyGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SoutherlyGymSignpost1:
	jumptext SoutherlyGymSignpost1_Text_2fa015

SoutherlyGym_Item_1:
	db FIRE_RING, 1

SoutherlyGymNPC1:
	jumptext SoutherlyGymNPC1_Text_2f9ef0

SoutherlyGymNPC4:
	faceplayer
	opentext
	checkflag ENGINE_BLAZEBADGE
	iffalse SoutherlyGym_2f9f3b
	jumptext SoutherlyGymNPC4_Text_2f9f41

SoutherlyGym_Trainer_1:
	trainer EVENT_SOUTHERLY_GYM_TRAINER_1, HIKER, 12, SoutherlyGym_Trainer_1_Text_2fa0fd, SoutherlyGym_Trainer_1_Text_2fa116, $0000, .Script

.Script:
	opentext
	checkevent EVENT_SOUTHERLY_GYM_NPC_2
	iftrue SoutherlyGym_2fa0f6
	writetext SoutherlyGym_Trainer_1_Script_Text_2fa134
	waitbutton
	disappear 4
	setevent EVENT_SOUTHERLY_GYM_NPC_2
	jumptext SoutherlyGym_Trainer_1_Script_Text_2fa163

SoutherlyGym_Trainer_2:
	trainer EVENT_SOUTHERLY_GYM_TRAINER_2, FIREBREATHER, 6, SoutherlyGym_Trainer_2_Text_2f86fe, SoutherlyGym_Trainer_2_Text_2f8742, $0000, .Script

.Script:
	opentext
	checkevent EVENT_SOUTHERLY_GYM_NPC_1
	iftrue SoutherlyGym_2f86f7
	writetext SoutherlyGym_Trainer_2_Script_Text_2f8751
	waitbutton
	disappear 3
	setevent EVENT_SOUTHERLY_GYM_NPC_1
	jumptext SoutherlyGym_Trainer_2_Script_Text_2f8773

SoutherlyGym_Trainer_3:
	trainer EVENT_SOUTHERLY_GYM_TRAINER_3, CAMPER, 7, SoutherlyGym_Trainer_3_Text_2fa047, SoutherlyGym_Trainer_3_Text_2fa07b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SoutherlyGym_Trainer_3_Script_Text_2fa099

SoutherlyGym_Trainer_4:
	trainer EVENT_SOUTHERLY_GYM_TRAINER_4, FIREBREATHER, 5, SoutherlyGym_Trainer_4_Text_2f864d, SoutherlyGym_Trainer_4_Text_2f867d, $0000, .Script

.Script:
	opentext
	checkevent EVENT_SOUTHERLY_GYM_NPC_3
	iftrue SoutherlyGym_2f8646
	writetext SoutherlyGym_Trainer_4_Script_Text_2f8695
	waitbutton
	disappear 5
	setevent EVENT_SOUTHERLY_GYM_NPC_3
	jumptext SoutherlyGym_Trainer_4_Script_Text_2f86b1

SoutherlyGymNPC5:
	faceplayer
	opentext
	checkflag ENGINE_BLAZEBADGE
	iffalse SoutherlyGym_2fa19d
	jumptext SoutherlyGymNPC5_Text_2fa1cd

SoutherlyGym_2f9f3b:
	jumptext SoutherlyGym_2f9f3b_Text_2f9f89

SoutherlyGym_2fa0f6:
	jumptext SoutherlyGym_Trainer_1_Script_Text_2fa163

SoutherlyGym_2f86f7:
	jumptext SoutherlyGym_Trainer_2_Script_Text_2f8773

SoutherlyGym_2f8646:
	jumptext SoutherlyGym_Trainer_4_Script_Text_2f86b1

SoutherlyGym_2fa19d:
	writetext SoutherlyGym_2fa19d_Text_2fa2ad
	waitbutton
	winlosstext SoutherlyGym_2fa19dText_2fa363, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer ERNEST, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SoutherlyGym_2fa19d_Text_2fa3d0
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	writetext SoutherlyGym_2fa19d_Text_2fa3eb
	waitbutton
	givetm 38 + RECEIVED_TM
	setflag ENGINE_BLAZEBADGE
	jumptext SoutherlyGym_2fa19d_Text_2fa406

SoutherlyGymSignpost1_Text_2fa015:
	ctxt "Southerly Gym"

	para "Leader: Ernest"
	done

SoutherlyGymNPC1_Text_2f9ef0:
	ctxt "This flame is"
	line "really hot."

	para "It'd be unwise to"
	line "walk through it."
	done

SoutherlyGymNPC4_Text_2f9f41:
	ctxt "You came from"
	line "Naljo huh?"

	para "Is it really as"
	line "pessimistic as"
	cont "everyone says?"
	done

SoutherlyGym_Trainer_1_Text_2fa0fd:
	ctxt "Can you stand the"
	line "heat?"
	done

SoutherlyGym_Trainer_1_Text_2fa116:
	ctxt "You're tougher"
	line "than you look."
	done

SoutherlyGym_Trainer_1_Script_Text_2fa134:
	ctxt "Well here, let me"
	line "create a short"
	cont "cut for you."
	done

SoutherlyGym_Trainer_1_Script_Text_2fa163:
	ctxt "That should help"
	line "you get back"
	cont "here easier."
	done

SoutherlyGym_Trainer_2_Text_2f86fe:
	ctxt "I'm the strongest"
	line "GYM minion!"

	para "Beat me and I'll"
	line "let you fight"
	cont "Ernest."
	done

SoutherlyGym_Trainer_2_Text_2f8742:
	ctxt "Down and out!"
	done

SoutherlyGym_Trainer_2_Script_Text_2f8751:
	ctxt "I'll get rid of"
	line "the fire for"
	cont "you."
	done

SoutherlyGym_Trainer_2_Script_Text_2f8773:
	ctxt "You still won't"
	line "be able to"
	cont "defeat Ernest!"
	done

SoutherlyGym_Trainer_3_Text_2fa047:
	ctxt "Are you prepared"
	line "to experience"
	para "third degree"
	line "burns?"
	done

SoutherlyGym_Trainer_3_Text_2fa07b:
	ctxt "Whoa, no need for"
	line "hostility!"
	done

SoutherlyGym_Trainer_3_Script_Text_2fa099:
	ctxt "People in this"
	line "area are more"
	para "friendly than"
	line "where you came"
	cont "from."
	done

SoutherlyGym_Trainer_4_Text_2f864d:
	ctxt "I'll help you get"
	line "to the leader if"
	cont "you beat me."
	done

SoutherlyGym_Trainer_4_Text_2f867d:
	ctxt "That was a hot"
	line "battle!"
	done

SoutherlyGym_Trainer_4_Script_Text_2f8695:
	ctxt "I'll douse the"
	line "nearby fire."
	done

SoutherlyGym_Trainer_4_Script_Text_2f86b1:
	ctxt "Good luck with"
	line "the rest of your"
	cont "battles!"
	done

SoutherlyGymNPC5_Text_2fa1cd:
	ctxt "If you're looking"
	line "for more of a"
	para "challenge, the"
	line "airport might be"
	para "able to take you"
	line "to a place with"
	cont "stronger Trainers."

	para "You'll need a"
	line "special ticket"
	para "to get there"
	line "though."

	para "The area is so"
	line "exclusive, that"
	para "even I don't know"
	line "where it is."
	done

SoutherlyGym_2f9f3b_Text_2f9f89:
	ctxt "Woo, is it hot in"
	line "here or what?"

	para "If you couldn't"
	line "tell, Ernest"
	para "uses the fire"
	line "type!"

	para "Using a grass or"
	line "bug type would"
	para "not work well"
	line "here."
	done

SoutherlyGym_2fa19d_Text_2fa2ad:
	ctxt "Hello youngster!"

	para "I think I've"
	line "heard of you"
	cont "before."

	para "Lance's your"
	line "father right?"

	para "Well I'm the Gym"
	line "Leader around"
	cont "these parts."

	para "If you defeat me"
	line "I'll hand over"
	cont "the Blaze Badge."

	para "Let's do this!"
	done

SoutherlyGym_2fa19dText_2fa363:
	ctxt "The fires on my"
	line "#mon's fighting"
	para "spirit has been"
	line "reduced to mere"
	cont "embers."

	para "You are truly"
	line "worthy of this"
	cont "badge!"
	done

SoutherlyGym_2fa19d_Text_2fa3d0:
	ctxt "Obtained the"
	line "Blaze Badge!"
	done

SoutherlyGym_2fa19d_Text_2fa3eb:
	ctxt "Here's a bonus TM"
	line "for you!"
	done

SoutherlyGym_2fa19d_Text_2fa406:
	ctxt "TM38 contains"
	line "Fire Blast!"

	para "It's a burning hot"
	line "fire move that has"
	para "a chance to burn"
	line "the opponent."

	para "It's immensely"
	line "strong, just like"
	para "you and your"
	line "father are."
	done

SoutherlyGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def 19, 8, 5, SOUTHERLY_CITY
	warp_def 19, 9, 5, SOUTHERLY_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 17, 11, SIGNPOST_READ, SoutherlyGymSignpost1
	signpost 17, 6, SIGNPOST_READ, SoutherlyGymSignpost1

	;people-events
	db 10
	person_event SPRITE_P0, -3, -3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 1, SoutherlyGym_Item_1, EVENT_SOUTHERLY_GYM_ITEM_1
	person_event SPRITE_FIRE, 3, 11, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyGymNPC1, EVENT_SOUTHERLY_GYM_NPC_1
	person_event SPRITE_FIRE, 12, 10, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyGymNPC1, EVENT_SOUTHERLY_GYM_NPC_2
	person_event SPRITE_FIRE, 8, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyGymNPC1, EVENT_SOUTHERLY_GYM_NPC_3
	person_event SPRITE_GYM_GUY, 17, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyGymNPC4, -1
	person_event SPRITE_FISHER, 13, 13, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, SoutherlyGym_Trainer_1, -1
	person_event SPRITE_FISHER, 0, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 1, SoutherlyGym_Trainer_2, -1
	person_event SPRITE_YOUNGSTER, 6, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 1, SoutherlyGym_Trainer_3, -1
	person_event SPRITE_FISHER, 4, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 1, SoutherlyGym_Trainer_4, -1
	person_event SPRITE_COOLTRAINER_M, 0, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SoutherlyGymNPC5, -1
