GoldenrodUnderground_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodUndergroundSignpost1:
	opentext
	writetext GoldenrodUndergroundSignpost1_Text_326e22
	endtext

GoldenrodUndergroundNPC1:
	farjump GoldenrodUnderground_1181d6

GoldenrodUndergroundNPC2:
	farjump GoldenrodUnderground_118129

GoldenrodUnderground_Trainer_1:
	trainer EVENT_GOLDENROD_UNDERGROUND_TRAINER_1, SUPER_NERD, 6, GoldenrodUnderground_Trainer_1_Text_326f1e, GoldenrodUnderground_Trainer_1_Text_326f3d, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext GoldenrodUnderground_Trainer_1_Script_Text_326f54
	endtext

GoldenrodUnderground_Trainer_2:
	trainer EVENT_GOLDENROD_UNDERGROUND_TRAINER_2, OFFICER, 2, GoldenrodUnderground_Trainer_2_Text_326e52, GoldenrodUnderground_Trainer_2_Text_326e8f, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext GoldenrodUnderground_Trainer_2_Script_Text_326e99
	endtext

GoldenrodUnderground_Trainer_3:
	trainer EVENT_GOLDENROD_UNDERGROUND_TRAINER_3, SUPER_NERD, 7, GoldenrodUnderground_Trainer_3_Text_326fb3, GoldenrodUnderground_Trainer_3_Text_326fda, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext GoldenrodUnderground_Trainer_3_Script_Text_326ff4
	endtext

GoldenrodUndergroundNPC3:
	faceplayer
	opentext
	jumptextfaceplayer GoldenrodUndergroundNPC3_Text_327e7f
	endtext

GoldenrodUnderground_1181d6:
	opentext
	checkcode VAR_WEEKDAY
	if_equal 0, GoldenrodUnderground_1181e8
	if_equal 3, GoldenrodUnderground_1181e8
	if_equal 5, GoldenrodUnderground_1181e8
	jump GoldenrodUnderground_1182c8

GoldenrodUnderground_118129:
	opentext
	checkcode VAR_WEEKDAY
	if_equal 2, GoldenrodUnderground_11813b
	if_equal 4, GoldenrodUnderground_11813b
	if_equal 6, GoldenrodUnderground_11813b
	jump GoldenrodUnderground_1182c8

GoldenrodUnderground_1181e8:
	checkflag EVENT_GOLDENROD_HAIRCUT_BROTHERS
	iftrue GoldenrodUnderground_11827d
	special PlaceMoneyTopRight
	writetext GoldenrodUnderground_1181e8_Text_118726
	yesorno
	iffalse GoldenrodUnderground_118271
	checkmoney 0, 300
	if_equal 2, GoldenrodUnderground_118277
	writetext GoldenrodUnderground_1181e8_Text_1187bb
	buttonsound
	special Special_OlderHaircutBrother
	if_equal 0, GoldenrodUnderground_118271
	if_equal 1, GoldenrodUnderground_118271
	setflag EVENT_GOLDENROD_HAIRCUT_BROTHERS
	if_equal 2, GoldenrodUnderground_11821e
	if_equal 3, GoldenrodUnderground_11822a
	jump GoldenrodUnderground_118236

GoldenrodUnderground_1182c8:
	writetext GoldenrodUnderground_1182c8_Text_1188ce
	endtext

GoldenrodUnderground_11813b:
	checkflag EVENT_GOLDENROD_HAIRCUT_BROTHERS
	iftrue GoldenrodUnderground_1181d0
	special PlaceMoneyTopRight
	writetext GoldenrodUnderground_11813b_Text_1185c3
	yesorno
	iffalse GoldenrodUnderground_1181c4
	checkmoney 0, 500
	if_equal 2, GoldenrodUnderground_1181ca
	writetext GoldenrodUnderground_11813b_Text_118664
	buttonsound
	special Special_YoungerHaircutBrother
	if_equal 0, GoldenrodUnderground_1181c4
	if_equal 1, GoldenrodUnderground_1181c4
	setflag EVENT_GOLDENROD_HAIRCUT_BROTHERS
	if_equal 2, GoldenrodUnderground_118171
	if_equal 3, GoldenrodUnderground_11817d
	jump GoldenrodUnderground_118189

GoldenrodUnderground_11827d:
	writetext GoldenrodUnderground_11827d_Text_118845
	endtext

GoldenrodUnderground_118271:
	writetext GoldenrodUnderground_118271_Text_11880c
	endtext

GoldenrodUnderground_118277:
	writetext GoldenrodUnderground_118277_Text_118825
	endtext

GoldenrodUnderground_11821e:
	setevent EVENT_0
	clearevent EVENT_1
	clearevent EVENT_2
	jump GoldenrodUnderground_118242

GoldenrodUnderground_11822a:
	clearevent EVENT_0
	setevent EVENT_1
	clearevent EVENT_2
	jump GoldenrodUnderground_118242

GoldenrodUnderground_118236:
	clearevent EVENT_0
	clearevent EVENT_1
	setevent EVENT_2
	jump GoldenrodUnderground_118242

GoldenrodUnderground_1181d0:
	writetext GoldenrodUnderground_1181d0_Text_1186f5
	endtext

GoldenrodUnderground_1181c4:
	writetext GoldenrodUnderground_1181c4_Text_1186b4
	endtext

GoldenrodUnderground_1181ca:
	writetext GoldenrodUnderground_1181ca_Text_1186d3
	endtext

GoldenrodUnderground_118171:
	setevent EVENT_0
	clearevent EVENT_1
	clearevent EVENT_2
	jump GoldenrodUnderground_118195

GoldenrodUnderground_11817d:
	clearevent EVENT_0
	setevent EVENT_1
	clearevent EVENT_2
	jump GoldenrodUnderground_118195

GoldenrodUnderground_118189:
	clearevent EVENT_0
	clearevent EVENT_1
	setevent EVENT_2
	jump GoldenrodUnderground_118195

GoldenrodUnderground_118242:
	takemoney 0, 300
	special PlaceMoneyTopRight
	writetext GoldenrodUnderground_118242_Text_1187d8
	waitbutton
	closetext
	special Special_BattleTowerFade
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	opentext
	writetext GoldenrodUnderground_118242_Text_1187f4
	waitbutton
	checkevent EVENT_0
	iftrue GoldenrodUnderground_118283
	checkevent EVENT_1
	iftrue GoldenrodUnderground_11828c
	jump GoldenrodUnderground_118295

GoldenrodUnderground_118195:
	takemoney 0, 500
	special PlaceMoneyTopRight
	writetext GoldenrodUnderground_118195_Text_118682
	waitbutton
	closetext
	special Special_BattleTowerFade
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	opentext
	writetext GoldenrodUnderground_118195_Text_1186a2
	waitbutton
	checkevent EVENT_0
	iftrue GoldenrodUnderground_118283
	checkevent EVENT_1
	iftrue GoldenrodUnderground_11828c
	jump GoldenrodUnderground_118295

GoldenrodUnderground_118283:
	writetext GoldenrodUnderground_118283_Text_118889
	special PlayCurMonCry
	endtext

GoldenrodUnderground_11828c:
	writetext GoldenrodUnderground_11828c_Text_1188a6
	special PlayCurMonCry
	endtext

GoldenrodUnderground_118295:
	writetext GoldenrodUnderground_118295_Text_1188b8
	special PlayCurMonCry
	endtext

GoldenrodUndergroundSignpost1_Text_326e22:
	ctxt "NO ENTRY BEYOND"
	line "THIS POINT"
	done

GoldenrodUnderground_Trainer_1_Text_326f1e:
	ctxt "I want to see your"
	line "rare #mon!"
	done

GoldenrodUnderground_Trainer_1_Text_326f3d:
	ctxt "No reason to get"
	line "mad!"
	done

GoldenrodUnderground_Trainer_1_Script_Text_326f54:
	ctxt "You're trying to"
	line "complete the"
	cont "Naljo Dex?"

	para "Wow, that's a"
	line "very ambitious"
	cont "goal!"
	done

GoldenrodUnderground_Trainer_2_Text_326e52:
	ctxt "I don't recognize"
	line "you."

	para "I hope you're not"
	line "causing any"
	cont "trouble."
	done

GoldenrodUnderground_Trainer_2_Text_326e8f:
	ctxt "Ah well."
	done

GoldenrodUnderground_Trainer_2_Script_Text_326e99:
	ctxt "Keep the battles"
	line "civilized or else"

	para "I'll seal this "
	line "place off."

	para "You want that on"
	line "your conscious?"
	done

GoldenrodUnderground_Trainer_3_Text_326fb3:
	ctxt "Have you been to"
	line "the new Game"
	cont "Corner?"
	done

GoldenrodUnderground_Trainer_3_Text_326fda:
	ctxt "I only asked a"
	line "question!"
	done

GoldenrodUnderground_Trainer_3_Script_Text_326ff4:
	ctxt "You can play five"
	line "games at the"
	cont "Game Corner!"
	done

GoldenrodUndergroundNPC3_Text_327e7f:
	ctxt "Those Trainers"
	line "down there can"
	cont "be unruly."
	done

GoldenrodUnderground_1181e8_Text_118726:
	ctxt "Welcome to the"
	line "#mon Salon!"

	para "I'm the younger"
	line "and less expen-"
	cont "sive of the two"
	cont "Haircut Brothers."

	para "I'll spiff up your"
	line "#mon for just"
	cont "¥300."

	para "So? How about it?"
	done

GoldenrodUnderground_1181e8_Text_1187bb:
	ctxt "OK, which #mon"
	line "should I do?"
	done

GoldenrodUnderground_1182c8_Text_1188ce:
	ctxt "I don't work"
	line "today."
	done

GoldenrodUnderground_11813b_Text_1185c3:
	ctxt "Welcome!"

	para "I run the #mon"
	line "Salon!"

	para "I'm the older and"
	line "better of the two"
	cont "Haircut Brothers."

	para "I can make your"
	line "#mon beautiful"
	cont "for just ¥500."

	para "Would you like me"
	line "to do that?"
	done

GoldenrodUnderground_11813b_Text_118664:
	ctxt "Which #mon"
	line "should I work on?"
	done

GoldenrodUnderground_11827d_Text_118845:
	ctxt "My shift's over"
	line "for the day."
	done

GoldenrodUnderground_118271_Text_11880c:
	ctxt "No?"
	line "How sad."
	done

GoldenrodUnderground_118277_Text_118825:
	ctxt "Sorry, you need more money."
	done

GoldenrodUnderground_1181d0_Text_1186f5:
	ctxt "I do only one"
	line "haircut a day. I'm"
	cont "done for today."
	done

GoldenrodUnderground_1181c4_Text_1186b4:
	ctxt "Is that right?"
	line "That's a shame!"
	done

GoldenrodUnderground_1181ca_Text_1186d3:
	ctxt "You'll need more"
	line "money than that."
	done

GoldenrodUnderground_118242_Text_1187d8:
	ctxt "OK! I'll make it"
	line "look cool!"
	done

GoldenrodUnderground_118242_Text_1187f4:
	ctxt "There we go!"
	line "All done!"
	done

GoldenrodUnderground_118195_Text_118682:
	ctxt "OK! Watch it"
	line "become beautiful!"
	done

GoldenrodUnderground_118195_Text_1186a2:
	ctxt "There! All done!"
	done

GoldenrodUnderground_118283_Text_118889:
	text_from_ram wStringBuffer1
	ctxt " looks a"
	line "little happier."
	done

GoldenrodUnderground_11828c_Text_1188a6:
	text_from_ram wStringBuffer1
	ctxt " looks"
	line "happy."
	done

GoldenrodUnderground_118295_Text_1188b8:
	text_from_ram wStringBuffer1
	ctxt " looks"
	line "delighted!"
	done

GoldenrodUnderground_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $2, $1, 3, GOLDENROD_UNDERGROUND_ENTRY_A
	warp_def $22, $1, 3, GOLDENROD_UNDERGROUND_ENTRY_B
	warp_def $6, $12, 4, GOLDENROD_UNDERGROUND
	warp_def $23, $f, 3, GOLDENROD_UNDERGROUND
	warp_def $23, $10, 3, GOLDENROD_UNDERGROUND
	warp_def $1f, $10, 1, GOLDENROD_SWITCHES

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 6, 19, SIGNPOST_READ, GoldenrodUndergroundSignpost1

	;people-events
	db 6
	person_event SPRITE_SUPER_NERD, 15, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodUndergroundNPC1, -1
	person_event SPRITE_SUPER_NERD, 11, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodUndergroundNPC2, -1
	person_event SPRITE_SUPER_NERD, 19, 4, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BROWN, 2, 4, GoldenrodUnderground_Trainer_1, -1
	person_event SPRITE_OFFICER, 26, 3, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 2, GoldenrodUnderground_Trainer_2, -1
	person_event SPRITE_SUPER_NERD, 9, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 2, GoldenrodUnderground_Trainer_3, -1
	person_event SPRITE_GRANNY, 20, 16, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodUndergroundNPC3, -1
