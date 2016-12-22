PrisonB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, SetBlocksPrisonB1F

SetBlocksPrisonB1F:
	checkevent EVENT_PRISON_B1F_DOOR_7
	iffalse .skipDoor1
	changeblock 14, 16, $18

.skipDoor1
	checkevent EVENT_PRISON_B1F_DOOR_1
	iffalse .skipDoor2
	changeblock 2, 6, $18

.skipDoor2
	checkevent EVENT_PRISON_B1F_DOOR_2
	iffalse .skipDoor3
	changeblock 14, 6, $18

.skipDoor3
	checkevent EVENT_PRISON_B1F_DOOR_3
	iffalse .skipDoor4
	changeblock 24, 6, $18

.skipDoor4
	checkevent EVENT_PRISON_B1F_DOOR_4
	iffalse .skipDoor5
	changeblock 2, 20, $18

.skipDoor5
	checkevent EVENT_PRISON_B1F_DOOR_5
	iffalse .skipDoor6
	changeblock 14, 20, $18

.skipDoor6
	checkevent EVENT_PRISON_B1F_DOOR_6
	iffalse .skipDoor7
	changeblock 24, 20, $18

.skipDoor7
	return

PrisonB1FSignpost1:
	checkevent EVENT_PRISON_B1F_DOOR_1
	iftrue PrisonB1F_1d1232
	opentext
	checkitem CAGE_KEY
	iffalse PrisonB1F_1d1233
	setevent EVENT_PRISON_B1F_DOOR_1
	writetext PrisonB1FSignpost1_Text_1d1239
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	jump PrisonB1F_1d23ea

PrisonB1FSignpost2:
	checkevent EVENT_PRISON_B1F_DOOR_2
	iftrue PrisonB1F_1d1232
	opentext
	checkitem CAGE_KEY
	iffalse PrisonB1F_1d1233
	setevent EVENT_PRISON_B1F_DOOR_2
	jump PrisonB1F_1d1222

PrisonB1FSignpost3:
	checkevent EVENT_PRISON_B1F_DOOR_3
	iftrue PrisonB1F_1d1232
	opentext
	checkitem CAGE_KEY
	iffalse PrisonB1F_1d1233
	setevent EVENT_PRISON_B1F_DOOR_3
	jump PrisonB1F_1d1222

PrisonB1FSignpost4:
	checkevent EVENT_PRISON_B1F_DOOR_4
	iftrue PrisonB1F_1d1232
	opentext
	checkitem CAGE_KEY
	iffalse PrisonB1F_1d1233
	setevent EVENT_PRISON_B1F_DOOR_4
	jump PrisonB1F_1d1222

PrisonB1FSignpost5:
	checkevent EVENT_PRISON_B1F_DOOR_5
	iftrue PrisonB1F_1d1232
	opentext
	checkitem CAGE_KEY
	iffalse PrisonB1F_1d1233
	setevent EVENT_PRISON_B1F_DOOR_5
	jump PrisonB1F_1d1222

PrisonB1FSignpost6:
	checkevent EVENT_PRISON_B1F_DOOR_6
	iftrue PrisonB1F_1d1232
	opentext
	checkitem CAGE_KEY
	iffalse PrisonB1F_1d1233
	setevent EVENT_PRISON_B1F_DOOR_6
	jump PrisonB1F_1d1222

PrisonB1FSignpost7:
	checkevent EVENT_PRISON_B1F_PASSWORD_DOOR
	iftrue PrisonB1F_1d12db

	opentext
	checkevent EVENT_PRISON_B1F_KNOW_PASSWORD
	iffalse PrisonB1F_1d12dc
	setevent EVENT_PRISON_B1F_PASSWORD_DOOR
	writetext PrisonB1F_1d12c9_Text_1d12e2
	waitbutton
	playsound SFX_ENTER_DOOR
	setevent EVENT_0
	setevent EVENT_PRISON_B1F_DOOR_7
	jump PrisonB1F_1d118c

PrisonB1F_Trainer_1:
	trainer EVENT_PRISON_B1F_TRAINER_1, RIVAL1, RIVAL1_4, PrisonB1F_Trainer_1_Text_1d1f77, PrisonB1F_Trainer_1_Text_1d2295, $0000, .Script

.Script:
	faceplayer
	opentext
	checkevent EVENT_SOUTH_SOUTHERLY_NPC_1
	iftrue PrisonB1F_1d1f71
	writetext PrisonB1F_Trainer_1_Script_Text_1d22a2
	waitbutton
	givetm 100 + RECEIVED_TM
	opentext
	writetext PrisonB1F_Trainer_1_Script_Text_1d231f
	setevent EVENT_SOUTH_SOUTHERLY_NPC_1
	endtext

PrisonB1FNPC1:
	faceplayer
	setevent EVENT_PRISON_B1F_NPC_1
	cry METAGROSS
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon METAGROSS, 50
	startbattle
	reloadmapafterbattle
	disappear 3
	end

PrisonB1FNPC2:
	faceplayer
	setevent EVENT_PRISON_B1F_NPC_2
	clearevent EVENT_FAMBACO
	cry FAMBACO
	waitsfx
	applymovement 4, PrisonB1FNPC2_Movement1
	spriteface 0, 3
	applymovement 4, PrisonB1FNPC2_Movement2
	disappear 4
	end

PrisonB1FNPC2_Movement1:
	fast_jump_step_right
	step_end

PrisonB1FNPC2_Movement2:
	fast_slide_step_right
	fast_slide_step_right
	fast_slide_step_up
	fast_slide_step_up
	fast_slide_step_up
	fast_slide_step_up
	fast_slide_step_up
	step_end

PrisonB1Makuhita:
	cry HARIYAMA
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon HARIYAMA, 45
	startbattle
	reloadmapafterbattle
	end

PrisonB1FNPC3:
	faceplayer
	setevent EVENT_PRISON_B1F_NPC_3
	scall PrisonB1Makuhita
	disappear 5
	end

PrisonB1FNPC4:
	faceplayer
	setevent EVENT_PRISON_B1F_NPC_4
	scall PrisonB1Makuhita
	disappear 6
	end

PrisonB1FNPC5:
	faceplayer
	setevent EVENT_PRISON_B1F_NPC_5
	cry MACHOKE
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon MACHOKE, 45
	startbattle
	reloadmapafterbattle
	disappear 7
	end

PrisonB1FNPC6:
	faceplayer
	setevent EVENT_PRISON_B1F_NPC_6
	cry BRONZONG
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon BRONZONG, 50
	startbattle
	reloadmapafterbattle
	disappear 8
	end

PrisonB1F_1d1232:
	end

PrisonB1F_1d1233:
	jumptext PrisonB1F_1d1233_Text_1d124d

PrisonB1F_1d23ea:
	setevent EVENT_0
	jump PrisonB1F_1d118c

PrisonB1F_1d1222:
	writetext PrisonB1FSignpost1_Text_1d1239
	waitbutton
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	jump PrisonB1F_1d23ea

PrisonB1F_1d12db:
	end

PrisonB1F_1d1f71:
	jumptext PrisonB1F_1d1f71_Text_1d23a0

PrisonB1F_1d118c:
	checkevent EVENT_PRISON_B1F_DOOR_1
	iffalse PrisonB1F_1d11df
	changeblock 2, 6, $18

PrisonBasementDoor2:
	checkevent EVENT_PRISON_B1F_DOOR_2
	iffalse PrisonB1F_1d11e6
	changeblock 14, 6, $18

PrisonBasementDoor3:
	checkevent EVENT_PRISON_B1F_DOOR_3
	iffalse PrisonB1F_1d11ed
	changeblock 24, 6, $18

PrisonBasementDoor4:
	checkevent EVENT_PRISON_B1F_DOOR_4
	iffalse PrisonB1F_1d11f4
	changeblock 2, 20, $18

PrisonBasementDoor5:
	checkevent EVENT_PRISON_B1F_DOOR_5
	iffalse PrisonB1F_1d11fb
	changeblock 14, 20, $18

PrisonBasementDoor6:
	checkevent EVENT_PRISON_B1F_DOOR_6
	iffalse PrisonB1F_1d1202
	changeblock 24, 20, $18

PrisonBasementDoor7:
	checkevent EVENT_PRISON_B1F_DOOR_7
	iffalse PrisonB1F_1d1209
	changeblock 14, 16, $18

PrisonBasementDoor8:
	checkevent EVENT_0
	iffalse PrisonB1F_1d11db
	clearevent EVENT_0
	refreshscreen 0
	reloadmappart
	closetext
	end

PrisonB1F_1d12dc:
	jumptext PrisonB1F_1d12dc_Text_1d12f6

PrisonB1F_1d11df:
	changeblock 2, 6, $19
	jump PrisonBasementDoor2

PrisonB1F_1d11e6:
	changeblock 14, 6, $19
	jump PrisonBasementDoor3

PrisonB1F_1d11ed:
	changeblock 24, 6, $19
	jump PrisonBasementDoor4

PrisonB1F_1d11f4:
	changeblock 2, 20, $19
	jump PrisonBasementDoor5

PrisonB1F_1d11fb:
	changeblock 14, 20, $19
	jump PrisonBasementDoor6

PrisonB1F_1d1202:
	changeblock 24, 20, $19
	jump PrisonBasementDoor7

PrisonB1F_1d1209:
	changeblock 14, 16, $19
	jump PrisonBasementDoor8

PrisonB1F_1d11db:
	return

PrisonB1FSignpost1_Text_1d1239:
	ctxt "Unlocked the door!"
	done

PrisonB1F_Trainer_1_Text_1d1f77:
	ctxt "So you're looking"
	line "for a way out of"
	cont "here as well?"

	para "This prison is ma-"
	line "naged by some lazy"

	para "businessman, and"
	line "guarded by fat,"
	cont "useless imbeciles."

	para "I was arrested"
	line "for my battling"
	para "and hard training"
	line "methods, but<...>"

	para "unfortunately for"
	line "this world full"

	para "of weaklings, I'm"
	line "too powerful to"

	para "be locked within"
	line "these walls of"
	cont "crumbling cement."

	para "I battle #mon"
	line "the way these"
	para "creatures have"
	line "been bred to be."

	para "You think these"
	line "tiny cretins have"
	para "developed their"
	line "ability to"

	para "breathe fire,"
	line "throw boulders,"

	para "and slice their"
	line "enemies to battle"
	cont "just for sport?"

	para "Of course not!"

	para "I battle these"
	line "creatures the way"
	para "they're meant to"
	line "battle; ruthless."

	para "In battle, the"
	line "only true way to"
	para "achieve absolute"
	line "power is exploit-"
	para "ing the weakness"
	line "of the enemy while"
	para "maintaining com-"
	line "plete control of"
	cont "the entire field."

	para "Come, my humble"
	line "trainer, and let's"
	cont "do battle! Haha."
	done

PrisonB1F_Trainer_1_Text_1d2295:
	ctxt "Impossible!"
	done

PrisonB1F_Trainer_1_Script_Text_1d22a2:
	ctxt "You know, I feel"
	line "sorry for you."

	para "You're never going"
	line "to experience a"
	para "#mon battle"
	line "like I do being"
	cont "stuck in here."

	para "Take this HM."
	done

PrisonB1F_Trainer_1_Script_Text_1d231f:
	ctxt "That's what I'm"
	line "using to escape."

	para "I'm not telling"
	line "you how to use"
	para "it to escape, you"
	line "gotta figure that"
	cont "out yourself."
	done

PrisonB1F_1d1233_Text_1d124d:
	ctxt "The door is"
	line "locked."
	done

PrisonB1F_1d1f71_Text_1d23a0:
	ctxt "The next time we"
	line "meet, I promise."

	para "That battle will"
	line "end the way I"
	cont "desire."
	done

PrisonB1F_1d12dc_Text_1d12f6:
	ctxt "The door is"
	line "locked."

	para "It looks like it"
	line "needs a password"
	cont "to unlock."
	done

PrisonB1F_1d12c9_Text_1d12e2:
	ctxt "Wigglyjelly!"
	done

PrisonB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $e, $f, 7, PRISON_F1

	;xy triggers
	db 0

	;signposts
	db 7
	signpost 7, 3, SIGNPOST_READ, PrisonB1FSignpost1
	signpost 7, 15, SIGNPOST_READ, PrisonB1FSignpost2
	signpost 7, 25, SIGNPOST_READ, PrisonB1FSignpost3
	signpost 21, 3, SIGNPOST_READ, PrisonB1FSignpost4
	signpost 21, 15, SIGNPOST_READ, PrisonB1FSignpost5
	signpost 21, 25, SIGNPOST_READ, PrisonB1FSignpost6
	signpost 17, 15, SIGNPOST_READ, PrisonB1FSignpost7

	;people-events
	db 7
	person_event SPRITE_SILVER, 18, 2, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, 2, 0, PrisonB1F_Trainer_1, EVENT_PRISON_B1F_TRAINER_1
	person_event SPRITE_METAGROSS, 24, 26, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, PrisonB1FNPC1, EVENT_PRISON_B1F_NPC_1
	person_event SPRITE_FAMBACO, 22, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonB1FNPC2, EVENT_PRISON_B1F_NPC_2
	person_event SPRITE_HARIYAMA, 24, 3, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PrisonB1FNPC3, EVENT_PRISON_B1F_NPC_3
	person_event SPRITE_HARIYAMA, 4, 26, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, PrisonB1FNPC4, EVENT_PRISON_B1F_NPC_4
	person_event SPRITE_MACHOKE, 4, 14, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, PrisonB1FNPC5, EVENT_PRISON_B1F_NPC_5
	person_event SPRITE_BRONZONG, 4, 3, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, PrisonB1FNPC6, EVENT_PRISON_B1F_NPC_6
