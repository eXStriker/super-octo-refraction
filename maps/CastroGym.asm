CastroGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroGymNPC1:
	checkflag ENGINE_FISTBADGE
	iftrue CastroGym_17011a
	applymovement 2, CastroGymNPC1_Movement1
	faceplayer
	opentext
	writetext CastroGymNPC1_Text_17024f
	waitbutton
	closetext
	winlosstext CastroGymNPC1Text_1702bb, 0
	loadtrainer KOJI, 1
	startbattle
	reloadmapafterbattle
	variablesprite SPRITE_CASTRO_GYM_1, SPRITE_LASS
	variablesprite SPRITE_CASTRO_GYM_2, SPRITE_LASS
	variablesprite SPRITE_CASTRO_GYM_3, SPRITE_LASS
	variablesprite SPRITE_CASTRO_GYM_4, SPRITE_YOUNGSTER
	special RunCallback_04
	opentext
	writetext CastroGymNPC1_Text_170305
	playwaitsfx SFX_GET_BADGE
	setflag ENGINE_FISTBADGE
	jump CastroGym_17011c

CastroGymNPC1_Movement1:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	step_end

CastroGymNPC2:
	checkevent EVENT_MORAGA_GYM_TRAINER_3
	iftrue CastroGym_170146
	applymovement 3, CastroGymNPC2_Movement1
	faceplayer
	variablesprite SPRITE_CASTRO_GYM_1, SPRITE_LASS
	special RunCallback_04
	faceplayer
	opentext
	checkevent EVENT_MORAGA_GYM_TRAINER_3
	iftrue CastroGym_170169
	writetext CastroGymNPC2_Text_170400
	waitbutton
	closetext
	winlosstext CastroGymNPC2Text_170440, 0
	loadtrainer LASS, 9
	startbattle
	iftrue CastroGym_170164
	reloadmapafterbattle
	setevent EVENT_MORAGA_GYM_TRAINER_3
	end

CastroGymNPC2_Movement1:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	step_end

CastroGymNPC3:
	checkevent EVENT_MORAGA_GYM_TRAINER_2
	iftrue CastroGym_170180
	applymovement 4, CastroGymNPC3_Movement1
	faceplayer
	variablesprite SPRITE_CASTRO_GYM_2, SPRITE_LASS
	special RunCallback_04
	faceplayer
	opentext
	checkevent EVENT_MORAGA_GYM_TRAINER_2
	iftrue CastroGym_1701a3
	writetext CastroGymNPC3_Text_170480
	waitbutton
	closetext
	winlosstext CastroGymNPC3Text_170495, 0
	loadtrainer LASS, 10
	startbattle
	iftrue CastroGym_17019e
	reloadmapafterbattle
	setevent EVENT_MORAGA_GYM_TRAINER_2
	end

CastroGymNPC3_Movement1:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	step_end

CastroGymNPC4:
	checkevent EVENT_ROUTE_66_TRAINER_2
	iftrue CastroGym_1701ba
	applymovement 5, CastroGymNPC4_Movement1
	faceplayer
	variablesprite SPRITE_CASTRO_GYM_3, SPRITE_LASS
	special RunCallback_04
	faceplayer
	opentext
	checkevent EVENT_ROUTE_66_TRAINER_2
	iftrue CastroGym_1701dd
	writetext CastroGymNPC4_Text_1704d5
	waitbutton
	closetext
	winlosstext CastroGymNPC4Text_17050b, 0
	loadtrainer PICNICKER, 5
	startbattle
	iftrue CastroGym_1701d8
	reloadmapafterbattle
	setevent EVENT_ROUTE_66_TRAINER_2
	end

CastroGymNPC4_Movement1:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	step_end

CastroGymNPC5:
	checkevent EVENT_MORAGA_GYM_TRAINER_1
	iftrue CastroGym_1701f4
	applymovement 6, CastroGymNPC5_Movement1
	faceplayer
	variablesprite SPRITE_CASTRO_GYM_4, SPRITE_YOUNGSTER
	special RunCallback_04
	faceplayer
	opentext
	checkevent EVENT_MORAGA_GYM_TRAINER_1
	iftrue CastroGym_170217
	writetext CastroGymNPC5_Text_170542
	waitbutton
	closetext
	winlosstext CastroGymNPC5Text_17056a, 0
	loadtrainer CAMPER, 6
	startbattle
	iftrue CastroGym_170212
	reloadmapafterbattle
	setevent EVENT_MORAGA_GYM_TRAINER_1
	end

CastroGymNPC5_Movement1:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	step_end

CastroGymNPC6:
	jumptextfaceplayer CastroGymNPC6_Text_1705ba

CastroGym_17011a:
	faceplayer
	opentext
	checkevent EVENT_CASTRO_GYM_TM_RECEIVED
	iftrue CastroGym_17012f
	writetext CastroGym_17011a_Text_17031c
	buttonsound
	givetm TM_COUNTER + RECEIVED_TM
	setevent EVENT_CASTRO_GYM_TM_RECEIVED
	jumptext CastroGym_17011a_Text_17038e

CastroGym_17011c:
	checkevent EVENT_CASTRO_GYM_TM_RECEIVED
	iftrue CastroGym_17012f
	writetext CastroGym_17011a_Text_17031c
	buttonsound
	givetm TM_COUNTER + RECEIVED_TM
	setevent EVENT_CASTRO_GYM_TM_RECEIVED
	jumptext CastroGym_17011a_Text_17038e

CastroGym_170146:
	faceplayer
	opentext
	checkevent EVENT_MORAGA_GYM_TRAINER_3
	iftrue CastroGym_170169
	writetext CastroGymNPC2_Text_170400
	waitbutton
	closetext
	winlosstext CastroGymNPC2Text_170440, 0
	loadtrainer LASS, 9
	startbattle
	iftrue CastroGym_170164
	reloadmapafterbattle
	setevent EVENT_MORAGA_GYM_TRAINER_3
	end

CastroGym_170169:
	jumptext CastroGym_170169_Text_170453

CastroGym_170164:
	variablesprite SPRITE_CASTRO_GYM_1, SPRITE_KOJI
	reloadmapafterbattle
	end

CastroGym_170180:
	faceplayer
	opentext
	checkevent EVENT_MORAGA_GYM_TRAINER_2
	iftrue CastroGym_1701a3
	writetext CastroGymNPC3_Text_170480
	waitbutton
	closetext
	winlosstext CastroGymNPC3Text_170495, 0
	loadtrainer LASS, 10
	startbattle
	iftrue CastroGym_17019e
	reloadmapafterbattle
	setevent EVENT_MORAGA_GYM_TRAINER_2
	end

CastroGym_1701a3:
	writetext CastroGym_1701a3_Text_1704b3
	endtext

CastroGym_17019e:
	variablesprite SPRITE_CASTRO_GYM_2, SPRITE_KOJI
	reloadmapafterbattle
	end

CastroGym_1701ba:
	faceplayer
	opentext
	checkevent EVENT_ROUTE_66_TRAINER_2
	iftrue CastroGym_1701dd
	writetext CastroGymNPC4_Text_1704d5
	waitbutton
	closetext
	winlosstext CastroGymNPC4Text_17050b, 0
	loadtrainer PICNICKER, 5
	startbattle
	iftrue CastroGym_1701d8
	reloadmapafterbattle
	setevent EVENT_ROUTE_66_TRAINER_2
	end

CastroGym_1701dd:
	jumptext CastroGym_1701dd_Text_170526

CastroGym_1701d8:
	variablesprite SPRITE_CASTRO_GYM_3, SPRITE_KOJI
	reloadmapafterbattle
	end

CastroGym_1701f4:
	faceplayer
	opentext
	checkevent EVENT_MORAGA_GYM_TRAINER_1
	iftrue CastroGym_170217
	writetext CastroGymNPC5_Text_170542
	waitbutton
	closetext
	winlosstext CastroGymNPC5Text_17056a, 0
	loadtrainer CAMPER, 6
	startbattle
	iftrue CastroGym_170212
	reloadmapafterbattle
	setevent EVENT_MORAGA_GYM_TRAINER_1
	end

CastroGym_170217:
	writetext CastroGym_170217_Text_17058b
	endtext

CastroGym_170212:
	variablesprite SPRITE_CASTRO_GYM_4, SPRITE_KOJI
	reloadmapafterbattle
	end

CastroGym_17012f:
	jumptextfaceplayer CastroGym_17011a_Text_17038e

CastroGymNPC1_Text_17024f:
	ctxt "Am I Koji?"

	para "Why yes I am!"
	done

CastroGymNPC1Text_1702bb:
	ctxt "Well done!"

	para "Here!"

	para "The Fist Badge!"
	done

CastroGymNPC1_Text_170305:
	ctxt "<PLAYER> received"
	line "Fist Badge."
	done

CastroGymNPC2_Text_170400:
	ctxt "Japanese"
	line "onomatopoeia"
	cont "is so kawaii!"
	done

CastroGymNPC2Text_170440:
	ctxt "Hiri hiri!"
	done

CastroGymNPC3_Text_170480:
	ctxt "Well, you chose"
	line "unwisely."
	done

CastroGymNPC3Text_170495:
	ctxt "Ack!"
	done

CastroGymNPC4_Text_1704d5:
	ctxt "Koji is hot."

	para "Dressing like him"
	line "is<...>"

	para "wonderful!"
	done

CastroGymNPC4Text_17050b:
	ctxt "Wasn't supposed"
	line "to happen!"
	done

CastroGymNPC5_Text_170542:
	ctxt "Ninjas are so"
	line "cool!"
	done

CastroGymNPC5Text_17056a:
	ctxt "Not skilled"
	line "enough!"
	done

CastroGymNPC6_Text_1705ba:
	ctxt "What up?"

	para "All these Trainers"
	line "look the same, but"

	para "only one is the"
	line "leader!"
	done

CastroGym_17011a_Text_17031c:
	ctxt "Here!"

	para "Take TM!"
	done

CastroGym_17011a_Text_17038e:
	ctxt "Hah!"

	para "That was joyful"
	line "sparring!"
	done

CastroGym_170169_Text_170453:
	ctxt "Uwaaaa!"
	done

CastroGym_1701a3_Text_1704b3:
	ctxt "You have more"
	line "chances."
	done

CastroGym_1701dd_Text_170526:
	ctxt "Can't wait for"
	line "Halloween!"
	done

CastroGym_170217_Text_17058b:
	ctxt "Time to study"
	line "ninjutsu instead"
	cont "of pretending."
	done

CastroGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $3, 1, CASTRO_VALLEY
	warp_def $11, $4, 1, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 6
	person_event SPRITE_KOJI, 10, 8, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, CastroGymNPC1, -1
	person_event SPRITE_KOJI, 13, 2, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, CastroGymNPC2, -1
	person_event SPRITE_KOJI, 7, 4, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, CastroGymNPC3, -1
	person_event SPRITE_KOJI, 6, 26, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, CastroGymNPC4, -1
	person_event SPRITE_KOJI, 1, 6, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, CastroGymNPC5, -1
	person_event SPRITE_GYM_GUY, 15, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, CastroGymNPC6, -1
