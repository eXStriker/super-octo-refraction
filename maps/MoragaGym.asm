MoragaGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoragaGymSignpost1:
	jumptext MoragaGymSignpost1_Text_17b130

MoragaGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_SPROUTBADGE
	iffalse MoragaGym_17ad3d
	jumptext MoragaGymNPC1_Text_17ad6c

MoragaGym_Trainer_1:
	trainer EVENT_MORAGA_GYM_TRAINER_1, TEACHER, 1, MoragaGym_Trainer_1_Text_17b081, MoragaGym_Trainer_1_Text_17b09f, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MoragaGym_Trainer_1_Script_Text_17b0b9

MoragaGym_Trainer_2:
	trainer EVENT_MORAGA_GYM_TRAINER_2, LASS, 8, MoragaGym_Trainer_2_Text_17af76, MoragaGym_Trainer_2_Text_17af91, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MoragaGym_Trainer_2_Script_Text_17afa3

MoragaGym_Trainer_3:
	trainer EVENT_MORAGA_GYM_TRAINER_3, COOLTRAINERM, 7, MoragaGym_Trainer_3_Text_17afd7, MoragaGym_Trainer_3_Text_17b00a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MoragaGym_Trainer_3_Script_Text_17b01f

MoragaGym_Trainer_4:
	trainer EVENT_MORAGA_GYM_TRAINER_4, LASS, 7, MoragaGym_Trainer_4_Text_17af10, MoragaGym_Trainer_4_Text_17af27, $0000, .Script

.Script:
	end_if_just_battled
	jumptext MoragaGym_Trainer_4_Script_Text_17af30

MoragaGym_17ad3d:
	writetext MoragaGym_17ad3d_Text_17ad97
	winlosstext MoragaGym_17ad3dText_17ae3d, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer LOIS, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext MoragaGym_17ad3d_Text_17ae7c
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	writetext MoragaGym_17ad3d_Text_17ae96
	waitbutton
	givetm 19 + RECEIVED_TM
	opentext
	writetext MoragaGym_17ad3d_Text_17aeb1
	setflag ENGINE_SPROUTBADGE
	endtext

MoragaGymSignpost1_Text_17b130:
	ctxt "Moraga Town"
	line "#mon Gym"

	para "Leader: Lois"
	done

MoragaGymNPC1_Text_17ad6c:
	ctxt "Best of luck on"
	line "getting the Rijon"
	cont "badges."
	done

MoragaGym_Trainer_1_Text_17b081:
	ctxt "Did yunno Lois has"
	line "a twin?"
	done

MoragaGym_Trainer_1_Text_17b09f:
	ctxt "I only asked a"
	line "question!"
	done

MoragaGym_Trainer_1_Script_Text_17b0b9:
	ctxt "Lois has a twin"
	line "sister who's also"

	para "a Gym Leader, but"
	line "she lives in Kanto."

	para "I can't remember"
	line "her name<...> is it"
	cont "Erin?"
	done

MoragaGym_Trainer_2_Text_17af76:
	ctxt "You're not ready"
	line "for Lois."
	done

MoragaGym_Trainer_2_Text_17af91:
	ctxt "Perhaps you are."
	done

MoragaGym_Trainer_2_Script_Text_17afa3:
	ctxt "I'm really shy"
	line "about newcomers."
	done

MoragaGym_Trainer_3_Text_17afd7:
	ctxt "I'm a cool dude"
	line "that loves hanging"
	cont "with the girls!"
	done

MoragaGym_Trainer_3_Text_17b00a:
	ctxt "Josiah, forgive"
	line "me!"
	done

MoragaGym_Trainer_3_Script_Text_17b01f:
	ctxt "They don't let"
	line "just any guy hang"
	cont "out here."

	para "Only the best is"
	line "allowed to chill."
	done

MoragaGym_Trainer_4_Text_17af10:
	ctxt "Lois is so"
	line "inspiring!"
	done

MoragaGym_Trainer_4_Text_17af27:
	ctxt "Whoops!"
	done

MoragaGym_Trainer_4_Script_Text_17af30:
	ctxt "I want to be a Gym"
	line "Leader just like"
	cont "her one day!"
	done

MoragaGym_17ad3d_Text_17ad97:
	ctxt "Ahhh<...> hello."

	para "I'm just so"
	line "happy<...>"

	para "My garden smells"
	line "wonderful."

	para "Oh yes, sorry, I'm"
	line "Lois, the Gym"

	para "leader of this"
	line "city or town."

	para "I suppose you"
	line "want to battle?"

	para "Wonderful!"
	done

MoragaGym_17ad3dText_17ae3d:
	ctxt "So much bliss out"
	line "of that battle!"

	para "You have earned"
	line "this badge!"
	done

MoragaGym_17ad3d_Text_17ae7c:
	ctxt "<PLAYER> received"
	line "Sprout Badge."
	done

MoragaGym_17ad3d_Text_17ae96:
	ctxt "You've earned"
	line "this TM too."
	done

MoragaGym_17ad3d_Text_17aeb1:
	ctxt "TM19 is Giga"
	line "Drain!"

	para "Your #mon will"
	line "recover half of"
	cont "the damage it"
	cont "deals to its foe."
	done

MoragaGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $4, 4, MORAGA_TOWN
	warp_def $11, $5, 4, MORAGA_TOWN

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 15, 3, SIGNPOST_READ, MoragaGymSignpost1
	signpost 15, 6, SIGNPOST_READ, MoragaGymSignpost1

	;people-events
	db 5
	person_event SPRITE_LOIS, 3, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, MoragaGymNPC1, -1
	person_event SPRITE_TEACHER, 6, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 2, 2, MoragaGym_Trainer_1, -1
	person_event SPRITE_LASS, 10, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 2, MoragaGym_Trainer_2, -1
	person_event SPRITE_COOLTRAINER_M, 7, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_RED, 2, 2, MoragaGym_Trainer_3, -1
	person_event SPRITE_LASS, 11, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 2, 2, MoragaGym_Trainer_4, -1
