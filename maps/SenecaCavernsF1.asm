SenecaCavernsF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SenecaCavernsF1_Trainer_1:
	trainer EVENT_SENECACAVERNSF1_TRAINER_1, BURGLAR, 2, SenecaCavernsF1_Trainer_1_Text_24d278, SenecaCavernsF1_Trainer_1_Text_24d2a3, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SenecaCavernsF1_Trainer_1_Script_Text_24d2b9
	endtext

SenecaCavernsF1_Trainer_2:
	trainer EVENT_SENECACAVERNSF1_TRAINER_2, BIRD_KEEPER, 7, SenecaCavernsF1_Trainer_2_Text_24d327, SenecaCavernsF1_Trainer_2_Text_24d348, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SenecaCavernsF1_Trainer_2_Script_Text_24d358
	endtext

SenecaCavernsF1_Trainer_3:
	trainer EVENT_SENECACAVERNSF1_TRAINER_3, GUITARIST, 4, SenecaCavernsF1_Trainer_3_Text_24d3a4, SenecaCavernsF1_Trainer_3_Text_24d3c3, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SenecaCavernsF1_Trainer_3_Script_Text_24d3ca
	endtext

SenecaCavernsF1_Trainer_4:
	trainer EVENT_SENECACAVERNSF1_TRAINER_4, FIREBREATHER, 9, SenecaCavernsF1_Trainer_4_Text_24d40d, SenecaCavernsF1_Trainer_4_Text_24d41c, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SenecaCavernsF1_Trainer_4_Script_Text_24d43c
	endtext

SenecaCavernsF1_Item_1:
	db PP_UP, 1

SenecaCavernsF1_Item_2:
	db ELIXIR, 1

SenecaCavernsF1NPC1:
	jumpstd smashrock

SenecaCavernsF1_Trainer_1_Text_24d278:
	ctxt "There's no way a"  
	line "kid like you can"
	cont "handle me!"
	done

SenecaCavernsF1_Trainer_1_Text_24d2a3:
	ctxt "Beaten at my own"
	line "game<...>"
	done

SenecaCavernsF1_Trainer_1_Script_Text_24d2b9:
	ctxt "Now I gotta walk"
	line "all the way down"

	para "to the #mon"
	line "Center."
	done

SenecaCavernsF1_Trainer_2_Text_24d327:
	ctxt "Behold, your"
	line "avian"
	cont "adversaries!"
	done

SenecaCavernsF1_Trainer_2_Text_24d348:
	ctxt "What bad luck!"
	done

SenecaCavernsF1_Trainer_2_Script_Text_24d358:
	ctxt "Once I heal them"
	line "up, they'll be"

	para "ready to take"
	line "you down."
	done

SenecaCavernsF1_Trainer_3_Text_24d3a4:
	ctxt "Great acoustics"
	line "in here, huh?"
	done

SenecaCavernsF1_Trainer_3_Text_24d3c3:
	ctxt "Ouch!"
	done

SenecaCavernsF1_Trainer_3_Script_Text_24d3ca:
	ctxt "Nothing is ever"
	line "going to keep me"
	cont "from rockin!"
	done

SenecaCavernsF1_Trainer_4_Text_24d40d:
	ctxt "Flamethrower!"
	done

SenecaCavernsF1_Trainer_4_Text_24d41c:
	ctxt "Great, now I need"
	line "a Burn Heal."
	done

SenecaCavernsF1_Trainer_4_Script_Text_24d43c:
	ctxt "Some people think"
	line "the east side of"

	para "this cave contains"
	line "the Rijon League."

	para "Very funny."
	done

SenecaCavernsF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $1c, $20, 3, ROUTE_67
	warp_def $9, $21, 4, SENECACAVERNSB2F
	warp_def $5, $1b, 3, SENECACAVERNSB1F
	warp_def $b, $d, 1, SENECACAVERNSB1F
	warp_def $1c, $c, 2, ROUTE_67

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 7
	person_event SPRITE_R_BURGLER, 20, 37, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, SenecaCavernsF1_Trainer_1, -1
	person_event SPRITE_BIRDKEEPER, 10, 40, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, SenecaCavernsF1_Trainer_2, -1
	person_event SPRITE_ROCKER, 16, 13, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 2, 2, SenecaCavernsF1_Trainer_3, -1
	person_event SPRITE_FIREBREATHER, 28, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 1, SenecaCavernsF1_Trainer_4, -1
	person_event SPRITE_POKE_BALL, 17, 41, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, SenecaCavernsF1_Item_1, EVENT_SENECACAVERNSF1_ITEM_1
	person_event SPRITE_POKE_BALL, 16, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, SenecaCavernsF1_Item_2, EVENT_SENECACAVERNSF1_ITEM_2
	person_event SPRITE_ROCK, 20, 35, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsF1NPC1, -1
