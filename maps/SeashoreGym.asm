SeashoreGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SeashoreGymHiddenItem_1:
	dw EVENT_SEASHORE_GYM_HIDDENITEM_PRISM_KEY
	db PRISM_KEY

SeashoreGymHiddenItem_2:
	dw EVENT_SEASHORE_GYM_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

SeashoreGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_PSIBADGE
	iftrue SeashoreGym_184106
	writetext SeashoreGymNPC1_Text_184180
	waitbutton
	closetext
	winlosstext SeashoreGymNPC1Text_184295, 0
	loadtrainer SHERYL, 1
	startbattle
	reloadmapafterbattle
	opentext
	writetext SeashoreGym_1840f5_Text_184336
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	setflag ENGINE_PSIBADGE
	jumptext SeashoreGym_1840f5_Text_18434e

SeashoreGym_Trainer_1:
	trainer EVENT_SEASHORE_GYM_TRAINER_1, MEDIUM, 4, SeashoreGym_Trainer_1_Text_18448a, SeashoreGym_Trainer_1_Text_1844bc, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SeashoreGym_Trainer_1_Script_Text_1844d5

SeashoreGym_Trainer_2:
	trainer EVENT_SEASHORE_GYM_TRAINER_2, PSYCHIC_T, 5, SeashoreGym_Trainer_2_Text_1844f8, SeashoreGym_Trainer_2_Text_184522, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SeashoreGym_Trainer_2_Script_Text_184547

SeashoreGym_Trainer_3:
	trainer EVENT_SEASHORE_GYM_TRAINER_3, MEDIUM, 7, SeashoreGym_Trainer_3_Text_18457e, SeashoreGym_Trainer_3_Text_1845b5, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SeashoreGym_Trainer_3_Script_Text_1845d7

SeashoreGym_Trainer_4:
	trainer EVENT_SEASHORE_GYM_TRAINER_4, PSYCHIC_T, 4, SeashoreGym_Trainer_4_Text_18460d, SeashoreGym_Trainer_4_Text_184643, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SeashoreGym_Trainer_4_Script_Text_184654

SeashoreGymNPC2:
	jumptextfaceplayer SeashoreGymNPC2_Text_18669d

SeashoreGym_184106:
	jumptext SeashoreGym_184106_Text_18440d

SeashoreGymNPC1_Text_184180:
	ctxt "Sheryl: Once"
	line "again, another"

	para "Trainer seeking"
	line "my Psi Badge."

	para "I feel that you"
	line "have the heart"

	para "and soul of a"
	line "Trainer."

	para "The soul like"
	line "Brown, the one I"

	para "fought many years"
	line "ago<...>"

	para "This will be fun"
	line "indeed<...>"
	done

SeashoreGymNPC1Text_184295:
	ctxt "Sheryl: Just as"
	line "I thought!"

	para "Thank you for"
	line "the battle, go"

	para "ahead and take my"
	line "Psi Badge!"
	done

SeashoreGym_Trainer_1_Text_18448a:
	ctxt "Shh<...>"

	para "Quiet down"
	line "child<...>"
	done

SeashoreGym_Trainer_1_Text_1844bc:
	ctxt "Strong<...>"
	line "Far too strong<...>"
	done

SeashoreGym_Trainer_1_Script_Text_1844d5:
	ctxt "Set a spell for"
	line "once!"
	done

SeashoreGym_Trainer_2_Text_1844f8:
	ctxt "You need to clear"
	line "your mind dude!"
	done

SeashoreGym_Trainer_2_Text_184522:
	ctxt "Maybe I should<...>!"
	done

SeashoreGym_Trainer_2_Script_Text_184547:
	ctxt "Stress only makes"
	line "us humans weaker."
	done

SeashoreGym_Trainer_3_Text_18457e:
	ctxt "Demons, begone!"
	done

SeashoreGym_Trainer_3_Text_1845b5:
	ctxt "The demons won!"
	done

SeashoreGym_Trainer_3_Script_Text_1845d7:
	ctxt "Please let me be!"
	done

SeashoreGym_Trainer_4_Text_18460d:
	ctxt "Alright, lets"
	line "kick it up a"
	cont "notch!"
	done

SeashoreGym_Trainer_4_Text_184643:
	ctxt "I was no match…"
	done

SeashoreGym_Trainer_4_Script_Text_184654:
	ctxt "Huh, why didn't"
	line "that work?"
	done

SeashoreGymNPC2_Text_18669d:
	ctxt "Heya!"

	para "This is Sheryl's"
	line "Gym."

	para "Don't be fooled"
	line "by her mind"

	para "tricks, you're"
	line "in the Gym!"

	para "She uses Psychic"
	line "#mon, so"

	para "approach with"
	line "caution."
	done

SeashoreGym_184106_Text_18440d:
	ctxt "Never give up and"
	line "show the world"

	para "how well you"
	line "train!"
	done

SeashoreGym_1840f5_Text_184336:
	ctxt "<PLAYER> received"
	line "Psi Badge."
	done

SeashoreGym_1840f5_Text_18434e:
	ctxt "Sheryl: I have a"
	line "feeling your badge"

	para "scavenger hunt"
	line "will never end."

	para "I will support"
	line "your quest, never"
	cont "give up!"
	done

SeashoreGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $d, $20, 5, SEASHORE_CITY
	warp_def $19, $17, 3, SEASHORE_GYM
	warp_def $f, $19, 2, SEASHORE_GYM

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 14, 29, SIGNPOST_ITEM, SeashoreGymHiddenItem_1
	signpost 17, 21, SIGNPOST_ITEM, SeashoreGymHiddenItem_2

	;people-events
	db 6
	person_event SPRITE_SHERAL, 6, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, SeashoreGymNPC1, -1
	person_event SPRITE_GRANNY, 19, 24, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 2, 3, SeashoreGym_Trainer_1, -1
	person_event SPRITE_YOUNGSTER, 5, 19, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 3, SeashoreGym_Trainer_2, -1
	person_event SPRITE_GRANNY, 20, 14, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 2, 2, SeashoreGym_Trainer_3, -1
	person_event SPRITE_PSYCHIC, 24, 32, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 4, SeashoreGym_Trainer_4, -1
	person_event SPRITE_GYM_GUY, 14, 31, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, SeashoreGymNPC2, -1
