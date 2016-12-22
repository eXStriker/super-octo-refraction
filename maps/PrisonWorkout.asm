PrisonWorkout_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PrisonWorkoutSignpost1:
	jumptext PrisonWorkoutSignpost1_Text_25471a

PrisonWorkoutSignpost2:
	jumptext PrisonWorkoutSignpost1_Text_25471a

PrisonWorkoutNPC1:
	jumptextfaceplayer PrisonWorkoutNPC1_Text_25461f

PrisonWorkoutNPC2:
	jumptextfaceplayer PrisonWorkoutNPC2_Text_254538

PrisonWorkoutNPC3:
	faceplayer
	opentext
	checkevent EVENT_PRISON_WORKOUT_KEY
	iftrue PrisonWorkout_2542cd
	writetext PrisonWorkoutNPC3_Text_2542d9
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	iffalse PrisonWorkout_2542d3
	setevent EVENT_PRISON_WORKOUT_KEY
	closetext
	end

PrisonWorkoutNPC4:
	faceplayer
	opentext
	checkevent EVENT_PRISON_ROOF_TRAINER_2
	iftrue PrisonWorkout_25552a
	checkevent EVENT_PRISON_WORKOUT_TRAINER
	iffalse PrisonWorkout_255514
	jumptext PrisonWorkoutNPC4_Text_255531

PrisonWorkout_2542cd:
	jumptext PrisonWorkout_2542cd_Text_2544cc

PrisonWorkout_25552a:
	setevent EVENT_PRISON_B1F_KNOW_PASSWORD
	jumptext PrisonWorkout_25552a_Text_2556f3

PrisonWorkout_255514:
	writetext PrisonWorkout_255514_Text_2555ad
	waitbutton
	winlosstext PrisonWorkout_255514Text_2556de, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer OFFICER, 7
	startbattle
	reloadmapafterbattle
	playmapmusic
	setevent EVENT_PRISON_WORKOUT_TRAINER
	checkevent EVENT_PRISON_ROOF_TRAINER_2
	iftrue PrisonWorkout_25552a
	jumptext PrisonWorkout_PaulieText

PrisonWorkout_2542d3:
	jumptext PrisonWorkout_2542d3_Text_25450c

PrisonWorkoutNurse:
	faceplayer
	opentext
	writetext PrisonNurseText
	waitbutton
	special HealParty
	special Special_BattleTowerFade
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	jumptext PrisonNurseDoneText
	
PrisonWorkout_PaulieText:
	ctxt "Be careful"
	line "downstairs."
	
	para "Those #mon are"
	line "unpredictable."
	done

PrisonNurseText:
	ctxt "You look tired."

	para "Here, take a rest."
	done

PrisonNurseDoneText:
	ctxt "There we go, you"
	line "look a lot better."

	para "Come back whenever"
	line "you need a rest."
	done

PrisonWorkoutSignpost1_Text_25471a:
	ctxt "There's only"
	line "trash in here."
	done

PrisonWorkoutNPC1_Text_25461f:
	ctxt "I heard that this"
	line "island used to be"
	para "the resting ground"
	line "of the legendary"
	cont "Naljo Guardians."

	para "Humans and other"
	line "#mon were not"
	para "allowed to visit"
	line "the island."

	para "However, the hired"
	line "construction crew"
	cont "didn't care;"

	para "they had their"
	line "orders to build"
	para "a prison, so they"
	line "built it over this"
	cont "historic landmark."
	done

PrisonWorkoutNPC2_Text_254538:
	ctxt "Working out is the"
	line "only joy I get out"
	cont "of life now<...>"

	para "However, it doesn't"
	line "fill the void."

	para "At the time I was"
	line "arrested, they"
	para "separated me and"
	line "my #mon<...>"

	para "The friendship I"
	line "had with them"
	para "is much stronger"
	line "than my body could"
	cont "ever become."
	done

PrisonWorkoutNPC3_Text_2542d9:
	ctxt "Hah!"

	para "What do you want,"
	line "you little wimp?"

	para "Looking for keys?"

	para "Well yeah, I got"
	line "a spare one."

	para "I don't need it"
	line "because I'm tough"
	para "enough to live the"
	line "prison life."
	done

PrisonWorkoutNPC4_Text_255531:
	ctxt "Hey kid."

	para "You should start"
	line "with the lightest"
	cont "training weights."

	para "It's going to be"
	line "a looong time"
	para "before you get"
	line "even close to"
	cont "the other guys."
	done

PrisonWorkout_2542cd_Text_2544cc:
	ctxt "You need to keep"
	line "getting tougher."

	para "You'll need real"
	line "toughness to"
	cont "survive in here."
	done

PrisonWorkout_25552a_Text_2556f3:
	ctxt "What's that?"

	para "Johnny-boy said"
	line "it's okay to give"
	cont "you the password?"

	para "Ah, OK."
	line "Sorry about that."

	para "The password to"
	line "the main gate is:"
	cont "Wigglyjelly"

	para "It's a combination"
	line "of my favorite"
	para "sweets and Grady's"
	line "childhood #mon!"

	para "Or was it:"
	line "Jigglydoughnut<...>?"

	para "No, no, no! I'm"
	line "certain it's"
	cont "Wigglyjelly!"
	done

PrisonWorkout_255514_Text_2555ad:
	ctxt "Oh geez!"

	para "Kid you scared the"
	line "stones out of me."

	para "There's been a"
	line "lot of paranormal"
	para "activity around"
	line "this place."

	para "I know what will"
	line "calm me down."

	para "A #mon battle!"
	done

PrisonWorkout_255514Text_2556de:
	ctxt "This is"
	line "ridiculous."
	done

PrisonWorkout_2542d3_Text_25450c:
	ctxt "Free up some"
	line "space first"
	cont "actually."
	done

PrisonWorkout_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $8, $0, 10, PRISON_F1
	warp_def $9, $0, 11, PRISON_F1

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 15, 18, SIGNPOST_READ, PrisonWorkoutSignpost1
	signpost 3, 18, SIGNPOST_READ, PrisonWorkoutSignpost2

	;people-events
	db 5
	person_event SPRITE_BLACK_BELT, 14, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, PrisonWorkoutNPC1, -1
	person_event SPRITE_BLACK_BELT, 4, 14, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, PrisonWorkoutNPC2, -1
	person_event SPRITE_BLACK_BELT, 10, 9, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonWorkoutNPC3, -1
	person_event SPRITE_OFFICER, 13, 17, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonWorkoutNPC4, -1
	person_event SPRITE_NURSE, 2, 16, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PrisonWorkoutNurse, -1
