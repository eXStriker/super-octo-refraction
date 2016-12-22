HeathGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathGateNPC1:
	jumptextfaceplayer HeathGateNPC1_Text_144bb0
	
HeathGateTrigger:
	checkevent EVENT_GOT_HM01
	sif true
		end
		
	setevent EVENT_GOT_HM01
	
	opentext
	writetext HeathGateGuardHeyText
	waitbutton
	closetext
	checkcode VAR_YCOORD
	sif =, 5, then
		applymovement 0, HeathGateWalkUp
	selse
		spriteface 0, UP
	sendif
	
	opentext
	writetext HeathGateGuardEncounterText
	waitbutton 
	givetm 97 + RECEIVED_TM
	jumptext HeathGateGuardEncounterTextAfter

HeathGateWalkUp:
	step_up
	step_end

HeathGate_Trainer_1:
	trainer EVENT_HEATH_GATE_TRAINER_1, PATROLLER, 15, HeathGate_Trainer_1_Text_1464d0, HeathGate_Trainer_1_Text_146587, $0000, .Script

.Script:
	end_if_just_battled
	jumptext HeathGate_Trainer_1_Script_Text_14666b

HeathGateNPC1_Text_144bb0:
	ctxt "We put in more"
	line "route gates for"
	cont "higher security."

	para "Some freaks have"
	line "been running"
	para "around vandalizing"
	line "everything."
	done

HeathGate_Trainer_1_Text_1464d0:
	ctxt "Oh great, it's you."

	para "I heard all about"
	line "what you did from"
	para "that <...>annoying<...>"
	line "Pink Patroller."

	para "You have no right"
	line "to mess with my"
	cont "group like that."

	para "Guess I'll just"
	line "have to teach you"
	cont "a lesson or two."
	done

HeathGate_Trainer_1_Text_146587:
	ctxt "What is it with"
	line "everyone!"

	para "I was once one"
	line "of the greatest"
	para "Trainers in the"
	line "world, beaten by"
	cont "a mere child!"

	para "No matter, I have"
	line "big plans that'll"
	para "make everything in"
	line "Naljo right again."

	para "You got lucky this"
	line "time, but I'll be"
	cont "back. Count on it."
	done

HeathGate_Trainer_1_Script_Text_14666b:
	ctxt "I don't like you."

	para "None of us do."

	para "Just<...> make"
	line "everything in the"
	para "world right, and"
	line "surrender."
	done
	
HeathGateGuardHeyText:
	ctxt "Hey, I need to"
	line "talk to you."
	done

HeathGateGuardEncounterText:
	ctxt "Please keep quiet"
	line "about me ignoring"
	cont "that battle."

	para "Huh? Why I didn't"
	line "stop Mr. Spandex"
	cont "that you fought?"

	para "He yelled at me"
	line "when I called his"
	cont "outfit spandex."

	para "My hurt feelings"
	line "made me decide to"
	cont "take a break."
	
	para "If you keep quiet,"
	line "I'll give you this"
	cont "nifty HM."
	done
	
HeathGateGuardEncounterTextAfter:
	ctxt "HM01 is Cut!"

	para "You'll be able to"
	line "clear small bushes"
	cont "blocking your way."
	
	para "Such as the bush"
	line "east of here."
	
	para "You'll need the"
	line "Nature Badge in"
	
	para "order to use it"
	line "though."
	done
		

HeathGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 7, HEATH_VILLAGE
	warp_def $5, $0, 8, HEATH_VILLAGE
	warp_def $4, $9, 1, ROUTE_74
	warp_def $5, $9, 2, ROUTE_74

	;xy triggers
	db 2
	xy_trigger 0, 4, 5, $0, HeathGateTrigger, $0, $0
	xy_trigger 0, 5, 5, $0, HeathGateTrigger, $0, $0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 2, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, HeathGateNPC1, -1
	person_event SPRITE_PALETTE_PATROLLER, 3, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 4, HeathGate_Trainer_1, EVENT_HEATH_GATE_TRAINER_1
