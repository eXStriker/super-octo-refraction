Route69_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route69Signpost1:
	signpostheader 3
	ctxt "Please stop tak-"
	next "ing the signs."
	nl   ""
	next "<UP> Heath Village"
	next "<DOWN> Caper City"
	done ;22

Route69_Trainer_1:
	trainer EVENT_ROUTE_69_TRAINER_1, HIKER, 2, Route69_Trainer_1_Text_134feb, Route69_Trainer_1_Text_135039, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_1_Script_Text_13504b

Route69_Trainer_2:
	trainer EVENT_ROUTE_69_TRAINER_2, HIKER, 3, Route69_Trainer_2_Text_135087, Route69_Trainer_2_Text_1350dc, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_2_Script_Text_1350fb

Route69_Trainer_4:
	trainer EVENT_ROUTE_69_TRAINER_4, HIKER, 10, Route69_Trainer_4_Text_1351c4, Route69_Trainer_4_Text_135220, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_4_Script_Text_13523b

Route69_Trainer_5:
	trainer EVENT_ROUTE_69_TRAINER_5, BLACKBELT_T, 2, Route69_Trainer_5_Text_135276, Route69_Trainer_5_Text_1352b1, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_5_Script_Text_1352bc

Route69_Trainer_6:
	trainer EVENT_ROUTE_69_TRAINER_6, COOLTRAINERM, 3, Route69_Trainer_6_Text_13530e, Route69_Trainer_6_Text_135339, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_6_Script_Text_135350

Route69_Trainer_7:
	trainer EVENT_ROUTE_69_TRAINER_7, COOLTRAINERF, 1, Route69_Trainer_7_Text_1353b2, Route69_Trainer_7_Text_135405, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Route69_Trainer_7_Script_Text_135414

Route69_Item_1:
	db POTION, 1

Route69_Item_2:
	db MIRACLE_SEED, 1

Route69_Item_3:
	db NUGGET, 1

IlkBrotherHouseBlockLeaving:
	checkevent EVENT_ROUTE_69_ILK_BRO_TRAPPED
	iffalse .done
	opentext
	writetext IlkBroDontLeave
	waitbutton
	closetext
	applymovement 0, .ilkBroMovePlayerUp
	disappear 0
	warpsound
	special Special_BattleTowerFade
	waitsfx
	warpfacing 1, ROUTE_69_ILKBROTHERHOUSE, 4, 9
	playmusic MUSIC_RIVAL_ENCOUNTER
.done
	end

.ilkBroMovePlayerUp
	step_up
	step_end

IlkBroDontLeave:
	ctxt "Where are you"
	line "going?"

	para "Please come back"
	line "inside and stop"
	cont "that crazy kid!"
	done

Route69_Trainer_1_Text_134feb:
	ctxt "As a Trainer, you"
	line "must be prepared"
	cont "for anything."
	done

Route69_Trainer_1_Text_135039:
	ctxt "Oh, I lost that!"
	done

Route69_Trainer_1_Script_Text_13504b:
	ctxt "It's impossible to"
	line "predict every"
	cont "single thing."
	done

Route69_Trainer_2_Text_135087:
	ctxt "You think you're"
	line "slick don't you?"

	para "You're nothing"
	line "compared to me!"
	done

Route69_Trainer_2_Text_1350dc:
	ctxt "Not slick enough!"
	done

Route69_Trainer_2_Script_Text_1350fb:
	ctxt "I'm so slick, that"
	line "I detest Crobats."
	done

Route69_Trainer_4_Text_1351c4:
	ctxt "My #mon enjoy a"
	line "hike just as much"
	cont "as I do."
	done

Route69_Trainer_4_Text_135220:
	ctxt "They experience"
	line "losses too!"
	done

Route69_Trainer_4_Script_Text_13523b:
	ctxt "Going on hikes are"
	line "funner with your"
	cont "#mon!"
	done

Route69_Trainer_5_Text_135276:
	ctxt "I come here to"
	line "train here every"
	cont "day with my"
	cont "loyal #mon!"
	done

Route69_Trainer_5_Text_1352b1:
	ctxt "Waaaargh!"
	done

Route69_Trainer_5_Script_Text_1352bc:
	ctxt "I must train with"
	line "my #mon even"
	cont "harder now!"
	done

Route69_Trainer_6_Text_13530e:
	ctxt "You cannot deny"
	line "my awesome skill!"
	done

Route69_Trainer_6_Text_135339:
	ctxt "I admit defeat."
	done

Route69_Trainer_6_Script_Text_135350:
	ctxt "It's important to"
	line "recognize your"
	cont "flaws, so you can"
	cont "improve."

	para "Self discipline."
	done

Route69_Trainer_7_Text_1353b2:
	ctxt "What are your"
	line "battle methods?"
	done

Route69_Trainer_7_Text_135405:
	ctxt "<...>Really?"
	done

Route69_Trainer_7_Script_Text_135414:
	ctxt "Perhaps you can"
	line "teach me a thing"
	cont "or two<...>"

	para "No?"

	para "How rude!"
	done

Route69_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $54, $6, 2, ROUTE_69_GATE
	warp_def $55, $6, 3, ROUTE_69_GATE
	warp_def $41, $b, 1, ROUTE_69_ILKBROTHERHOUSE
	warp_def $3b, $e, 2, MOUND_UPPERAREA

	;xy triggers
	db 1
	xy_trigger 0, 66, 11, $0, IlkBrotherHouseBlockLeaving, $0, $0

	;signposts
	db 1
	signpost 5, 11, SIGNPOST_LOAD, Route69Signpost1

	;people-events
	db 10
	person_event SPRITE_HIKER, 19, 10, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 1, Route69_Trainer_1, -1
	person_event SPRITE_HIKER, 24, 14, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 2, Route69_Trainer_2, -1
	person_event SPRITE_HIKER, 41, 32, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 2, 1, Route69_Trainer_4, -1
	person_event SPRITE_BLACK_BELT, 48, 7, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 0, 2, 2, Route69_Trainer_5, -1
	person_event SPRITE_COOLTRAINER_M, 58, 11, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route69_Trainer_6, -1
	person_event SPRITE_COOLTRAINER_F, 4, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 3, Route69_Trainer_7, -1
	person_event SPRITE_POKE_BALL, 63, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, Route69_Item_1, EVENT_ROUTE_69_ITEM_1
	person_event SPRITE_POKE_BALL, 79, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, Route69_Item_2, EVENT_ROUTE_69_ITEM_2
	person_event SPRITE_POKE_BALL, 34, 17, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_FURY_CUTTER, 0, EVENT_ROUTE_69_NPC_1
	person_event SPRITE_POKE_BALL, 52, 10, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, Route69_Item_3, EVENT_ROUTE_69_ITEM_3
