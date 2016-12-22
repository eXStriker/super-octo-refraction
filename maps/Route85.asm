Route85_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route85Signpost2:
	ctxt "<LEFT> Phacelia Town"
	next "<RIGHT> Firelight"
	nl "   Caverns"
	done ;38

Route85Signpost3:
	ctxt "Entrance"
	done ;57

Route85_Trainer_1:
	trainer EVENT_ROUTE_85_TRAINER_1, BIRD_KEEPER, 3, Route85_Trainer_1_Text_12ae66, Route85_Trainer_1_Text_12ae88, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	checkevent EVENT_ARRESTED_PALETTE_BLACK
	iffalse Route85_12ae60
	jumptext Route85_Trainer_1_Script_Text_12aeb6

Route85NPC1:
	faceplayer
	opentext
	writetext Route85NPC1_Text_12ad84
	waitbutton
	writetext Route85NPC1_Text_12adb1
	waitbutton
	stopfollow
	warp PHACELIA_POLICE_F2, 3, 1
	spriteface 0, 2
	spriteface 2, 3
	opentext
	writetext Route85NPC1_Text_12add2
	waitbutton
	callasm RestoreSpriteFromPalette
	setevent EVENT_ROUTE_85_POLICEMAN_GONE
	clearevent EVENT_IN_UNDERCOVER_MISSION
	clearevent EVENT_PALETTE_BLACK_FOLLOWING
	setevent EVENT_ARRESTED_PALETTE_BLACK
	closetext
	callasm CancelMapSign
	opentext
	writetext Route85NPC1_Text_12adec
	waitbutton
	givetm 101 + RECEIVED_TM
	jumptext CopExplainHMText

RestoreSpriteFromPalette:
	ld a, [wSavedPlayerCharacteristics2]
	ld [wPlayerGender], a
	ret

Route85NPC2:
	jumpstd smashrock

Route85NPC3:
	jumpstd smashrock

Route85NPC4:
	faceplayer
	opentext
	checkevent EVENT_PALETTE_BLACK_FOLLOWING
	iftrue Route85_12accc
	setevent EVENT_PALETTE_BLACK_FOLLOWING
	clearevent EVENT_ROUTE_85_POLICEMAN_GONE
	follow PLAYER, 6
	appear 3
	jumptext Route85NPC4_Text_12acd2

Route85_Trainer_2:
	trainer EVENT_ROUTE_85_TRAINER_2, PSYCHIC_T, 3, Route85_Trainer_2_Text_12af90, Route85_Trainer_2_Text_12afa9, $0000, .Script

.Script:
	end_if_just_battled
	checkevent EVENT_ARRESTED_PALETTE_BLACK
	iffalse Route85_12af8a
	jumptext Route85_Trainer_2_Script_Text_12afca

Route85_Item_1:
	db DRAGON_FANG, 1

Route85NPC6:
	fruittree 19

Route85_12ae60:
	jumptext Route85_12ae60_Text_12aef8

Route85_12accc:
	jumptext Route85_12accc_Text_12ad37

Route85_12af8a:
	jumptext Route85_12af8a_Text_12b03c

Route85_Trainer_1_Text_12ae66:
	ctxt "Huh, so you're a"
	line "Pallet Patroller?"
	done

Route85_Trainer_1_Text_12ae88:
	ctxt "I can't believe I"
	line "lost to a Pallet"
	cont "Patroller!"
	done

Route85_Trainer_1_Script_Text_12aeb6:
	ctxt "I'm worn out"
	line "after a battle"
	para "with a Pallet"
	line "Patroller!"
	done

Route85NPC1_Text_12ad84:
	ctxt "Officer: Great"
	line "job, I knew you"
	cont "could do it."
	done

Route85NPC1_Text_12adb1:
	ctxt "Black: Why did I"
	line "fall for that?"
	done

Route85NPC1_Text_12add2:
	ctxt "I'll need that"
	line "suit back."
	done
	
CopExplainHMText:
	ctxt "HM05 is Rock"
	line "Smash."
	
	para "You'll be able to"
	line "break loose rocks"
	cont "with this."
	
	para "However, you'll"
	line "need the city's"
	
	para "badge before you"
	line "can use this!"
	done

	     ;******************
Route85NPC1_Text_12adec:
	ctxt "The guard in front"
	line "of the quarry's "
	para "gym will let you"
	line "through now."

	para "Please also take"
	line "this gift."
	done

Route85NPC4_Text_12acd2:
	ctxt "Hey."

	para "Just taking a"
	line "smoke break."

	para "<...>"

	para "Oh what?"

	para "You found our"
	line "leader, really?"

	para "Lead the way."
	done

Route85_Trainer_2_Text_12af90:
	ctxt "Are you looking"
	line "for your buddy?"
	done

Route85_Trainer_2_Text_12afa9:
	ctxt "Fine, I'll stay"
	line "out of your way."
	done

Route85_Trainer_2_Script_Text_12afca:
	ctxt "I'm scared of"
	line "those Pallet"
	cont "Patrollers."

	para "I've heard that"
	line "they do what they"
	para "want without"
	line "worrying about"
	cont "consequences."
	done

Route85_12ae60_Text_12aef8:
	ctxt "It seems like the"
	line "purpose of your"
	para "crew is only to"
	line "waste time."

	para "<...>"

	para "<...> Wait."

	para "Then why are the"
	line "cops looking for"
	cont "you guys?"
	done

Route85_12accc_Text_12ad37:
	ctxt "So, are we going"
	line "or what?"
	done

Route85_12af8a_Text_12b03c:
	ctxt "As long as it"
	line "doesn't involve"
	para "me, I won't be"
	line "reporting your"
	cont "shenanigans."
	done

Route85_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 7, 7, 2, PHACELIA_EAST_EXIT
	warp_def 6, 61, 2, ROUTE_82_MONKEY
	warp_def 3, 57, 1, MAGMA_F1

.CoordEvents: db 0

.BGEvents: db 2
	signpost 11, 16, SIGNPOST_LOAD, Route85Signpost2
	signpost 7, 56, SIGNPOST_LOAD, Route85Signpost3

.ObjectEvents: db 9
	person_event SPRITE_BIRDKEEPER, 8, 30, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 2, 3, Route85_Trainer_1, -1
	person_event SPRITE_OFFICER, 8, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 5, Route85NPC1, EVENT_ROUTE_85_POLICEMAN_GONE
	person_event SPRITE_ROCK, 7, 57, SPRITEMOVEDATA_SUDOWOODO, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route85NPC2, -1
	person_event SPRITE_ROCK, 15, 40, SPRITEMOVEDATA_SUDOWOODO, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route85NPC3, -1
	person_event SPRITE_PALETTE_PATROLLER, 9, 52, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_OW_SILVER, 0, 5, Route85NPC4, EVENT_ARRESTED_PALETTE_BLACK
	person_event SPRITE_PSYCHIC, 9, 44, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8, 2, 2, Route85_Trainer_2, -1
	person_event SPRITE_POKE_BALL, 13, 61, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, Route85_Item_1, EVENT_ROUTE_85_ITEM_1
	person_event SPRITE_POKE_BALL, 15, 43, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_ROLLOUT, 0, EVENT_ROUTE_85_NPC_5
	person_event SPRITE_FRUIT_TREE, 6, 44, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 3, Route85NPC6, -1

