TrainerHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

TrainerHouse_Trainer_1:
	trainer EVENT_TRAINER_HOUSE_TRAINER_1, SUPER_NERD, 2, TrainerHouse_Trainer_1_Text_1182dc, TrainerHouse_Trainer_1_Text_118329, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer TrainerHouse_Trainer_1_Script_Text_118334

TrainerHouse_Trainer_2:
	trainer EVENT_TRAINER_HOUSE_TRAINER_2, SUPER_NERD, 1, TrainerHouse_Trainer_2_Text_118362, TrainerHouse_Trainer_2_Text_1183cb, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer TrainerHouse_Trainer_2_Script_Text_1183d8

TrainerHouse_Trainer_3:
	trainer EVENT_TRAINER_HOUSE_TRAINER_3, POKEMANIAC, 2, TrainerHouse_Trainer_3_Text_11841a, TrainerHouse_Trainer_3_Text_118458, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer TrainerHouse_Trainer_3_Script_Text_118462

TrainerHouse_Trainer_4:
	trainer EVENT_TRAINER_HOUSE_TRAINER_4, POKEMANIAC, 1, TrainerHouse_Trainer_4_Text_11849b, TrainerHouse_Trainer_4_Text_1184d7, $0000, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer TrainerHouse_Trainer_4_Script_Text_1184f9

TrainerHouseNPC1:
	checkevent EVENT_RYU_GOT_CYNDAQUIL
	iftrue TrainerHouse_119f27
	faceplayer
	opentext
	checkevent EVENT_RYU_BEATEN
	iftrue TrainerHouse_119f0d
	writetext TrainerHouseNPC1_Text_119f3d
	waitbutton
	closetext
	winlosstext TrainerHouseNPC1Text_119f99, 0
	loadtrainer BLACKBELT_T, 1
	startbattle
	reloadmapafterbattle
	setevent EVENT_RYU_BEATEN
	opentext

TrainerHouse_119f0d:
	writetext TrainerHouseNPC1_Text_119fb0
	buttonsound
	waitsfx
	checkcode VAR_PARTYCOUNT
	if_equal 6, TrainerHouse_119f2d
	writetext TrainerHouseNPC1_Text_11a045
	playwaitsfx SFX_CAUGHT_MON
	givepoke CYNDAQUIL, 10, ORAN_BERRY, 0
	setevent EVENT_RYU_GOT_CYNDAQUIL

TrainerHouse_119f27:
	jumptextfaceplayer TrainerHouseNPC1_Text_11a05a

TrainerHouse_119f2d:
	jumptextfaceplayer TrainerHouse_119f2d_Text_11a0cf

TrainerHouse_Trainer_1_Text_1182dc:
	ctxt "I always come here"
	line "to train with my"
	cont "#mon friends."
	done

TrainerHouse_Trainer_1_Text_118329:
	ctxt "<...>Grumble<...>"
	done

TrainerHouse_Trainer_1_Script_Text_118334:
	ctxt "Looks like you're"
	line "not my friend!"
	done

TrainerHouse_Trainer_2_Text_118362:
	ctxt "Having lots of"
	line "#mon helps you"
	cont "deal with multiple"
	cont "different types."

	para "Ultimately, you"
	line "have no clear type"
	cont "weaknesses left!"
	done

TrainerHouse_Trainer_2_Text_1183cb:
	ctxt "Ow, ow, ow!"
	done

TrainerHouse_Trainer_2_Script_Text_1183d8:
	ctxt "I know my #mon"
	line "type alignments."
	done

TrainerHouse_Trainer_3_Text_11841a:
	ctxt "What is it?"
	done

TrainerHouse_Trainer_3_Text_118458:
	ctxt "Aiyeeee!"
	done

TrainerHouse_Trainer_3_Script_Text_118462:
	ctxt "Geeze, don't brag"
	line "about it!"
	done

TrainerHouse_Trainer_4_Text_11849b:
	ctxt "Ha!"

	para "Shocked you,"
	line "didnt I?"
	done

TrainerHouse_Trainer_4_Text_1184d7:
	ctxt "Gaah! I lost!"
	line "That makes me mad!"
	done

TrainerHouse_Trainer_4_Script_Text_1184f9:
	ctxt "You gave me a"
	line "shock of my own."
	done

TrainerHouseNPC1_Text_119f3d:
	ctxt "Greetings, I give"
	line "gifts to talented"
	cont "Trainers."

	para "Do you have what"
	line "it takes? Then<...>"

	para "Prove it!"
	done

TrainerHouseNPC1Text_119f99:
	ctxt "Waaaarggh!"
	line "I'm beaten!"
	done

TrainerHouseNPC1_Text_119fb0:
	ctxt "Congratulations,"
	line "you earned this"
	cont "gift."

	para "I found this"
	line "#mon, and it"
	cont "needs a young"
	cont "Trainer such as"
	cont "yourself!"
	done

TrainerHouseNPC1_Text_11a045:
	ctxt "<PLAYER> got"
	line "Cyndaquil!"
	done

TrainerHouseNPC1_Text_11a05a:
	ctxt "Cyndaquil is a"
	line "rare Fire-type."

	para "I'm happy you"
	line "have it now, but"
	cont "I'm running out"
	cont "of #mon to"
	cont "give challengers."

	para "I always lose!"
	done

TrainerHouse_119f2d_Text_11a0cf:
	ctxt "You have no room"
	line "in your party!"

	para "Come back when"
	line "you have room and"
	cont "then I'll give you"
	cont "your prize."
	done

TrainerHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 10
	warp_def $7, $3, 14, OXALIS_CITY
	warp_def $e, $1, 2, TRAINER_HOUSE_B1F
	warp_def $0, $4, 1, TRAINER_HOUSE_B1F
	warp_def $1f, $17, 1, ACANIA_POKECENTER
	warp_def $1f, $18, 1, ACANIA_POKECENTER
	warp_def $7, $4, 14, OXALIS_CITY
	warp_def $26, $4, 4, TRAINER_HOUSE_B1F
	warp_def $2d, $3, 8, OXALIS_CITY
	warp_def $2d, $4, 8, OXALIS_CITY
	warp_def $e, $7, 3, TRAINER_HOUSE_B1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_SUPER_NERD, 29, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 2, 5, TrainerHouse_Trainer_1, -1
	person_event SPRITE_SUPER_NERD, 27, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 2, 5, TrainerHouse_Trainer_2, -1
	person_event SPRITE_POKEMANIAC, 25, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_PURPLE, 2, 5, TrainerHouse_Trainer_3, -1
	person_event SPRITE_POKEMANIAC, 23, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_PURPLE, 2, 5, TrainerHouse_Trainer_4, -1
	person_event SPRITE_BLACK_BELT, 31, 4, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, TrainerHouseNPC1, -1
