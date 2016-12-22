AzaleaGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AzaleaGymSignpost1:
	jumptext AzaleaGymSignpost1_Text_324316

AzaleaGymSignpost2:
	jumptext AzaleaGymSignpost1_Text_324316

AzaleaGym_Item_1:
	db IRON, 1

AzaleaGym_Trainer_1:
	trainer EVENT_AZALEA_GYM_TRAINER_1, LASS, 4, AzaleaGym_Trainer_1_Text_32434e, AzaleaGym_Trainer_1_Text_324384, $0000, .Script

.Script:
	end_if_just_battled
	jumptext AzaleaGym_Trainer_1_Script_Text_324397

AzaleaGym_Trainer_2:
	trainer EVENT_AZALEA_GYM_TRAINER_2, BUG_CATCHER, 8, AzaleaGym_Trainer_2_Text_324566, AzaleaGym_Trainer_2_Text_32459b, $0000, .Script

.Script:
	end_if_just_battled
	jumptext AzaleaGym_Trainer_2_Script_Text_3245c0

AzaleaGym_Trainer_3:
	trainer EVENT_AZALEA_GYM_TRAINER_3, BUG_CATCHER, 7, AzaleaGym_Trainer_3_Text_324446, AzaleaGym_Trainer_3_Text_324477, $0000, .Script

.Script:
	end_if_just_battled
	jumptext AzaleaGym_Trainer_3_Script_Text_324499

AzaleaGym_Trainer_4:
	trainer EVENT_AZALEA_GYM_TRAINER_4, LASS, 5, AzaleaGym_Trainer_4_Text_3243db, AzaleaGym_Trainer_4_Text_324407, $0000, .Script

.Script:
	end_if_just_battled
	jumptext AzaleaGym_Trainer_4_Script_Text_32441a

AzaleaGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_HIVEBADGE
	iffalse AzaleaGym_324600
	jumptext AzaleaGymNPC1_Text_324632

AzaleaGym_Trainer_5:
	trainer EVENT_AZALEA_GYM_TRAINER_5, BUG_CATCHER, 9, AzaleaGym_Trainer_5_Text_3244d9, AzaleaGym_Trainer_5_Text_324516, $0000, .Script

.Script:
	end_if_just_battled
	jumptext AzaleaGym_Trainer_5_Script_Text_324520

AzaleaGymNPC2:
	jumptextfaceplayer AzaleaGymNPC2_Text_32429b

AzaleaGym_324600:
	writetext AzaleaGym_324600_Text_32467c
	winlosstext AzaleaGym_324600Text_324711, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer BUGSY, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext AzaleaGym_324600_Text_32477b
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_HIVEBADGE
	playmusic MUSIC_GYM
	writetext AzaleaGym_324600_Text_324793
	waitbutton
	givetm 87 + RECEIVED_TM
	opentext
	writetext AzaleaGym_324600_Text_3247c3
	setflag ENGINE_HIVEBADGE
	endtext

AzaleaGymSignpost1_Text_324316:
	ctxt "Azalea Town"
	line "#mon Gym"

	para "Leader: Bugsy"
	done

AzaleaGym_Trainer_1_Text_32434e:
	ctxt "There's no way we're"
	line "letting you battle"
	cont "the leader!"
	done

AzaleaGym_Trainer_1_Text_324384:
	ctxt "Oh my goodness<...>"
	done

AzaleaGym_Trainer_1_Script_Text_324397:
	ctxt "You really built a"
	line "strong team."

	para "I admire that."
	done

AzaleaGym_Trainer_2_Text_324566:
	ctxt "Bug #mon evolve"
	line "young."

	para "So they get"
	line "stronger faster."
	done

AzaleaGym_Trainer_2_Text_32459b:
	ctxt "However, just"
	line "evolving isn't"
	cont "enough!"
	done

AzaleaGym_Trainer_2_Script_Text_3245c0:
	ctxt "I guess I'd better"
	line "train a bit more!"
	done

AzaleaGym_Trainer_3_Text_324446:
	ctxt "Bug #mon are"
	line "rad!"

	para "Here's the proof"
	line "coming at ya!"
	done

AzaleaGym_Trainer_3_Text_324477:
	ctxt "Well you're tough"
	line "that's for sure."
	done

AzaleaGym_Trainer_3_Script_Text_324499:
	ctxt "I met a cool girl"
	line "who loves bug"
	cont "#mon."
	done

AzaleaGym_Trainer_4_Text_3243db:
	ctxt "Wait!"

	para "Don't rush to"
	line "Bugsy, battle us"
	cont "first!"
	done

AzaleaGym_Trainer_4_Text_324407:
	ctxt "Oh my goodness<...>"
	done

AzaleaGym_Trainer_4_Script_Text_32441a:
	ctxt "I'm ashamed of my"
	line "loss."
	done

AzaleaGymNPC1_Text_324632:
	ctxt "Bug #mon are"
	line "deep."

	para "There's an"
	line "endless amount"

	para "of mysteries to"
	line "be explored."
	done

AzaleaGym_Trainer_5_Text_3244d9:
	ctxt "I grew up with my"
	line "#mon."

	para "I couldn't imagine"
	line "it any other way."
	done

AzaleaGym_Trainer_5_Text_324516:
	ctxt "Urrgggh!"
	done

AzaleaGym_Trainer_5_Script_Text_324520:
	ctxt "All we can do is"
	line "grow and get"

	para "better, as a"
	line "team."
	done

AzaleaGymNPC2_Text_32429b:
	ctxt "Yo challenger!"

	para "Bugsy's knowledge"
	line "of insect #mon"
	cont "is enormous!"

	para "Try taking them"
	line "down with fire and"
	cont "flying #mon!"
	done

AzaleaGym_324600_Text_32467c:
	ctxt "I'm Bugsy."

	para "I never lose when"
	line "it comes to bug"
	cont "#mon!"

	para "You can consider"
	line "me the authority"
	cont "on bug #mon!"

	para "I've learned a"
	line "lot over the"

	para "years, let me"
	line "show you."
	done

AzaleaGym_324600Text_324711:
	ctxt "You are amazing!"

	para "There will always"
	line "be something new"

	para "to learn about"
	line "bug #mon!"

	para "Please take the"
	line "Hive Badge!"
	done

AzaleaGym_324600_Text_32477b:
	ctxt "<PLAYER> received"
	line "Hive Badge."
	done

AzaleaGym_324600_Text_324793:
	ctxt "Please take this"
	line "gift as well,"
	cont "you deserve it."
	done

AzaleaGym_324600_Text_3247c3:
	ctxt "This bug TM works"
	line "for all #mon"
	cont "with horns."

	para "That way, even"
	line "more #mon can"

	para "harness the"
	line "power of bugs!"
	done

AzaleaGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $f, $4, 4, AZALEA_TOWN
	warp_def $f, $5, 4, AZALEA_TOWN

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 13, 3, SIGNPOST_READ, AzaleaGymSignpost1
	signpost 13, 6, SIGNPOST_READ, AzaleaGymSignpost2

	;people-events
	db 8
	person_event SPRITE_P0, -3, -3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 1, AzaleaGym_Item_1, EVENT_AZALEA_GYM_ITEM_1
	person_event SPRITE_LASS, 10, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 1, AzaleaGym_Trainer_1, -1
	person_event SPRITE_BUG_CATCHER, 3, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, AzaleaGym_Trainer_2, -1
	person_event SPRITE_BUG_CATCHER, 2, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, AzaleaGym_Trainer_3, -1
	person_event SPRITE_LASS, 10, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 1, AzaleaGym_Trainer_4, -1
	person_event SPRITE_BUGSY, 7, 5, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, AzaleaGymNPC1, -1
	person_event SPRITE_BUG_CATCHER, 8, 1, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, AzaleaGym_Trainer_5, -1
	person_event SPRITE_GYM_GUY, 13, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, AzaleaGymNPC2, -1
