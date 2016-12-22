HeathVillage_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Heath_SetFlyFlag

Heath_SetFlyFlag:
	setflag ENGINE_FLYPOINT_HEATH_VILLAGE
	return

HeathVillageSignpost1:
	ctxt "Rinji's Forest"
	done ;19

HeathVillageSignpost2:
	ctxt "Rest house"
	done ;20

HeathVillageSignpost3:
	ctxt "Heath Village."
	next "Holds rich"
	next "traditions"
	done ;21

HeathVillageNPC1:
	jumptextfaceplayer HeathVillageNPC1_Text_125b4e

HeathVillageNPC2:
	jumptextfaceplayer HeathVillageNPC2_Text_125bc1

HeathVillageNPC3:
	jumptextfaceplayer HeathVillageNPC3_Text_125bf5

HeathVillageNPC4:
	jumptextfaceplayer HeathVillageNPC4_Text_125d16

HeathVillageNPC5:
	faceplayer
	checkevent EVENT_GOT_BICYCLE
	sif true
		jumptext HeathVillageNPC5_Text_EnjoyBicycle

	opentext
	writetext HeathVillageNPC5_Text_TechnologySucks
	callasm .CheckStepCounter
	sif false
		jumptext HeathVillageNPC5_Text_WalkMore
	writetext HeathVilalgeNPC5_Text_YouGetBicycle
	waitbutton
	verbosegiveitem BICYCLE, 1
	setevent EVENT_GOT_BICYCLE
	endtext

.CheckStepCounter:
	xor a
	ld [hScriptVar], a
	ld hl, wGlobalStepCounter + 3
	ld a, [hld]
	or [hl]
	jr nz, .enoughSteps
	dec hl
	ld a, [hld]
	cp 10000 >> 8
	jr z, .checkLower
	jr nc, .enoughSteps
.checkLower
	ld a, [hl]
	cp 10000 & $ff
	ret c
.enoughSteps
	ld a, $1
	ld [hScriptVar], a
	ret

HeathVillageNPC5_Text_TechnologySucks:
	ctxt "People these days"
	line "don't appreciate"
	cont "their legs enough."
	prompt

HeathVillageNPC5_Text_WalkMore:
	ctxt "Hmm... your shoes"
	line "aren't worn in"
	cont "enough."

	para "Come back once"
	line "you've shown an"

	para "appreciation of"
	line "the power of"
	cont "walking."
	done

HeathVilalgeNPC5_Text_YouGetBicycle:
	ctxt "I can tell by your"
	line "shoes that you've"
	cont "taken many steps."

	para "It's nice knowing"
	line "people that still"
	cont "use our feet."

	para "As a token of"
	line "gratitude, you can"
	cont "have this Bicycle!"
	done

HeathVillageNPC5_Text_EnjoyBicycle:
	ctxt "Having fun with"
	line "your bicycle?"
  
	para "It's astounding how"
	line "many things your"
	cont "legs can do!"
	done

HeathVillageNPC1_Text_125b4e:
	ctxt "I can climb any"
	line "mountain in Naljo!"

	para "Maybe someday I"
	line "can climb other"
	cont "famed mountains."
	done

HeathVillageNPC2_Text_125bc1:
	ctxt "Inside is a small"
	line "shrine dedicated"
	para "to the Guardians"
	line "of Naljo."

	para "Residents visit"
	line "daily in hopes"
	para "that they will"
	line "awaken and watch"
	cont "over us once more."
	done

HeathVillageNPC3_Text_125bf5:
	ctxt "I'm going to be a"
	line "Grass-type user,"
	cont "just like Rinji."

	para "Rinji loves"
	line "everything about"
	para "nature, and he's"
	line "livid about the"
	para "changes that are"
	line "happening to our"
	cont "dear region."
	done

HeathVillageNPC4_Text_125d16:
	ctxt "I enjoy the vill-"
	line "age traditions."

	para "It's a nice change"
	line "of pace from the"
	para "modernization that"
	line "plagues society."
	done

HeathVillage_MapEventHeader:: db 0, 0

.Warps: db 8
	warp_def 19, 32, 4, HEATH_GYM_GATE
	warp_def 18, 32, 3, HEATH_GYM_GATE
	warp_def 1, 3, 1, HEATH_HOUSE_TM30
	warp_def 21, 11, 1, HEATH_HOUSE_TM13
	warp_def 9, 17, 1, HEATH_INN
	warp_def 25, 19, 1, HEATH_HOUSE_WEAVER
	warp_def 10, 33, 1, HEATH_GATE
	warp_def 11, 33, 2, HEATH_GATE

.CoordEvents: db 0

.BGEvents: db 3
	signpost 16, 32, SIGNPOST_LOAD, HeathVillageSignpost1
	signpost 11, 15, SIGNPOST_LOAD, HeathVillageSignpost2
	signpost 23, 13, SIGNPOST_LOAD, HeathVillageSignpost3

.ObjectEvents: db 5
	person_event SPRITE_BLACK_BELT, 12, 13, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 8, 0, 0, HeathVillageNPC1, -1
	person_event SPRITE_COOLTRAINER_F, 26, 22, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, 0, 0, 0, HeathVillageNPC2, -1
	person_event SPRITE_YOUNGSTER, 14, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, HeathVillageNPC3, -1
	person_event SPRITE_COOLTRAINER_F, 31, 6, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 8, 0, 0, HeathVillageNPC4, -1
	person_event SPRITE_BLACK_BELT, 24, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, 0, 0, HeathVillageNPC5, -1

