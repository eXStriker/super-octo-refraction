JaeruGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

JaeruGymSignpost16:
	jumptext JaeruGymStatueText

JaeruGymTrash:
	jumptext JaeruGymTrashText

JaeruGymStatueText:
	ctxt "Jaeru Town"
	line "#mon Gym"

	para "Leader: Sparky"
	done

JaeruGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_SPARKYBADGE
	iftrue JaeruGym_164c30
	writetext JaeruGymNPC1_Text_164c99
	waitbutton
	closetext
	winlosstext JaeruGymNPC1Text_164d8a, 0
	loadtrainer SPARKY, 1
	startbattle
	reloadmapafterbattle
	opentext
	writetext JaeruGymNPC1_Text_164dc9
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	waitsfx
	setflag ENGINE_SPARKYBADGE
	jumptext JaeruGym_164c26_Text_164de3

JaeruGym_Trainer_1:
	trainer EVENT_JAERU_GYM_TRAINER_1, GENTLEMAN, 2, JaeruGym_Trainer_1_Text_164ea8, JaeruGym_Trainer_1_Text_164ede, $0000, .Script

.Script:
	end_if_just_battled
	jumptext JaeruGym_Trainer_1_Script_Text_164f02

JaeruGym_Trainer_2:
	trainer EVENT_JAERU_GYM_TRAINER_2, COOLTRAINERM, 8, JaeruGym_Trainer_2_Text_164f3a, JaeruGym_Trainer_2_Text_164f89, $0000, .Script

.Script:
	end_if_just_battled
	jumptext JaeruGym_Trainer_2_Script_Text_164f9d

JaeruGym_Trainer_3:
	trainer EVENT_JAERU_GYM_TRAINER_3, SUPER_NERD, 8, JaeruGym_Trainer_3_Text_164fd9, JaeruGym_Trainer_3_Text_16500c, $0000, .Script

.Script:
	end_if_just_battled
	jumptext JaeruGym_Trainer_3_Script_Text_165028

JaeruGymNPC2:
	faceplayer
	checkflag ENGINE_SPARKYBADGE
	iftrue JaeruGym_164c80
	jumptext JaeruGymNPC2_Text_165069

JaeruGym_164c30:
	jumptext JaeruGym_164c30_Text_164e55

JaeruGym_164c80:
	jumptext JaeruGym_164c80_Text_165131

JaeruGymTrashText:
	ctxt "Nope! Nothing here"
	line "but trash."
	done

JaeruGymNPC1_Text_164c99:
	ctxt "Sparky: What do"
	line "you want, I'm"

	para "working on"
	line "outsourcing my"
	cont "workers. "

	para "Don't tell them"
	line "that please."

	para "Oh a battle?"

	para "I suppose."
	done

JaeruGymNPC1Text_164d8a:
	ctxt "Fine, you get the"
	line "Sparky Badge, now"

	para "let me get back to"
	line "work."
	done

JaeruGymNPC1_Text_164dc9:
	ctxt "<PLAYER> received"
	line "Sparky Badge"
	done

JaeruGym_Trainer_1_Text_164ea8:
	ctxt "I'm on my break."
	line "Go ahead kid!"
	done

JaeruGym_Trainer_1_Text_164ede:
	ctxt "Better get"
	line "overtime for this!"
	done

JaeruGym_Trainer_1_Script_Text_164f02:
	ctxt "I get paid more"
	line "than you, hahaha!"
	done

JaeruGym_Trainer_2_Text_164f3a:
	ctxt "The boss is not"
	line "accepting meetings"

	para "right now, go"
	line "away!"
	done

JaeruGym_Trainer_2_Text_164f89:
	ctxt "Fine!"
	done

JaeruGym_Trainer_2_Script_Text_164f9d:
	ctxt "The boss won't be"
	line "happy about this!"
	done

JaeruGym_Trainer_3_Text_164fd9:
	ctxt "You don't work"
	line "here!"

	para "Begone!"
	done

JaeruGym_Trainer_3_Text_16500c:
	ctxt "Too much overtime!"
	done

JaeruGym_Trainer_3_Script_Text_165028:
	ctxt "Battles with me"
	line "are now optional."

	para "Union rules."
	done

JaeruGymNPC2_Text_165069:
	ctxt "What's up!"

	para "Sparky has grown"
	line "up over the years"

	para "and converted his"
	line "GYM into an"
	cont "office."

	para "Not sure what his"
	line "home business"

	para "does, but I don't"
	line "want to find out."
	done

JaeruGym_164c30_Text_164e55:
	ctxt "Sparky: What?"

	para "I'm busy!"
	done

JaeruGym_164c80_Text_165131:
	ctxt "Whew! That was an"
	line "electrifying bout!"

	para "It sure made me"
	line "nervous."
	done

JaeruGym_164c26_Text_164de3:
	ctxt "This badge"
	line "increases the"
	para "speed of your"
	line "#mon."

	para "Use that to get"
	line "out of here."
	done

JaeruGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $4, 3, JAERU_CITY
	warp_def $11, $5, 3, JAERU_CITY

	;xy triggers
	db 0

	;signposts
	db 5
	signpost 11, 9, SIGNPOST_READ, JaeruGymTrash
	signpost 9, 3, SIGNPOST_READ, JaeruGymTrash
	signpost 0, 9, SIGNPOST_READ, JaeruGymTrash
	signpost 15, 3, SIGNPOST_READ, JaeruGymSignpost16
	signpost 15, 6, SIGNPOST_READ, JaeruGymSignpost16

	;people-events
	db 5
	person_event SPRITE_SPARKY, 2, 0, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, JaeruGymNPC1, -1
	person_event SPRITE_GENTLEMAN, 10, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 4, JaeruGym_Trainer_1, -1
	person_event SPRITE_COOLTRAINER_M, 7, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 3, JaeruGym_Trainer_2, -1
	person_event SPRITE_SUPER_NERD, 11, 4, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 2, 4, JaeruGym_Trainer_3, -1
	person_event SPRITE_GYM_GUY, 15, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 1, JaeruGymNPC2, -1
