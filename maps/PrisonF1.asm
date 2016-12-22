PrisonF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, PrisonF1_112470

PrisonF1Signpost1:
	checkevent EVENT_PRISON_LOCKED_DOOR_1
	iftrue PrisonF1_111b2b
	opentext
	checkitem CAGE_KEY
	iffalse PrisonF1_111b2c
	writetext PrisonF1Signpost1_Text_111b32
	yesorno
	iffalse PrisonF1_111b2b
	writetext PrisonF1Signpost1_Text_111b54
	waitbutton
	setevent EVENT_PRISON_LOCKED_DOOR_1
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	scall PrisonF1_112470
	refreshscreen 0
	reloadmappart
	closetext
	end

PrisonF1OpenDoor:
	iftrue PrisonF1_111b2b
	opentext
	checkitem CAGE_KEY
	iffalse PrisonF1_111b2c
	writetext PrisonF1Signpost1_Text_111b32
	yesorno
	iffalse PrisonF1_111b2b
	writetext PrisonF1Signpost1_Text_111b54
	waitbutton
	writebyte 1
	end

DontOpen:
	end

PrisonF1Signpost2:
	checkevent EVENT_PRISON_LOCKED_DOOR_2
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_2
	jump PrisonF1_111b20

PrisonF1Signpost3:
	checkevent EVENT_PRISON_LOCKED_DOOR_8
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_8
	jump PrisonF1_111b20

PrisonF1Signpost4:
	checkevent EVENT_PRISON_LOCKED_DOOR_7
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_7
	jump PrisonF1_111b20

PrisonF1Signpost5:
	checkevent EVENT_PRISON_LOCKED_DOOR_6
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_6
	jump PrisonF1_111b20

PrisonF1Signpost6:
	checkevent EVENT_PRISON_LOCKED_DOOR_5
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_5
	jump PrisonF1_111b20

PrisonF1Signpost7:
	checkevent EVENT_PRISON_LOCKED_DOOR_3
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_3
	jump PrisonF1_111b20

PrisonF1Signpost8:
	checkevent EVENT_PRISON_LOCKED_DOOR_4
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_4
	jump PrisonF1_111b20

PrisonF1Signpost9:
	checkevent EVENT_PRISON_LOCKED_DOOR_9
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_9
	jump PrisonF1_111b20

PrisonF1Signpost10:
	checkevent EVENT_PRISON_LOCKED_DOOR_10
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_10
	jump PrisonF1_111b20

PrisonF1Signpost11:
	jumptext PrisonF1Signpost11_Text_112504

PrisonF1Signpost12:
	checkevent EVENT_PRISON_LOCKED_DOOR_12
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_12
	jump PrisonF1_111b20

PrisonF1Signpost13:
	checkevent EVENT_PRISON_LOCKED_DOOR_14
	scall PrisonF1OpenDoor
	iffalse DontOpen
	setevent EVENT_PRISON_LOCKED_DOOR_14
	jump PrisonF1_111b20

PrisonF1_Trainer_1:
	trainer EVENT_PRISON_F1_TRAINER_1, COOLTRAINERM, 12, PrisonF1_Trainer_1_Text_110db3, PrisonF1_Trainer_1_Text_110e00, $0000, .Script

.Script:
	jumptextfaceplayer PrisonF1_Trainer_1_Script_Text_110e1b

PrisonF1_Item_1:
	db CAGE_KEY, 1

PrisonF1_Trainer_2:
	trainer EVENT_PRISON_F1_TRAINER_2, FISHER, 14, PrisonF1_Trainer_2_Text_113a7a, PrisonF1_Trainer_2_Text_113abb, $0000, .Script

.Script:
	jumptextfaceplayer PrisonF1_Trainer_2_Script_Text_113adf

PrisonF1_Trainer_3:
	trainer EVENT_PRISON_F1_TRAINER_3, BIKER, 9, PrisonF1_Trainer_3_Text_111f8e, PrisonF1_Trainer_3_Text_111ff0, $0000, .Script

.Script:
	opentext
	checkevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_4
	iftrue PrisonF1_111f88
	writetext PrisonF1_Trainer_3_Script_Text_112071
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	iffalse PrisonF1NoRoom
	setevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_4
	closetext
	end

PrisonF1_111f88:
	jumptextfaceplayer PrisonF1_111f88_Text_1120fa

PrisonF1_Item_2:
	db PP_UP, 1

PrisonF1_Trainer_4:
	trainer EVENT_PRISON_F1_TRAINER_4, SAILOR, 4, PrisonF1_Trainer_4_Text_112913, PrisonF1_Trainer_4_Text_11296e, $0000, .Script

.Script:
	opentext
	checkevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_3
	iftrue PrisonF1_11290d
	writetext PrisonF1_Trainer_4_Script_Text_112996
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	iffalse PrisonF1NoRoom
	setevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_3
	closetext
	end

PrisonF1_Item_3:
	db FLUFFY_COAT, 1

PrisonF1_Item_4:
	db CAGE_KEY, 1

PrisonF1_Item_5:
	db FRIEND_BALL, 3

PrisonF1_Trainer_5:
	trainer EVENT_PRISON_F1_TRAINER_5, MINER, 1, PrisonF1_Trainer_5_Text_111d4e, PrisonF1_Trainer_5_Text_111d7b, $0000, .Script

.Script:
	opentext
	checkevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_1
	iftrue PrisonF1_111d48
	writetext PrisonF1_Trainer_5_Script_Text_111d8d
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	iffalse PrisonF1NoRoom
	setevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_1
	closetext
	end

PrisonF1_Trainer_6:
	trainer EVENT_PRISON_F1_TRAINER_6, BIRD_KEEPER, 8, PrisonF1_Trainer_6_Text_111e74, PrisonF1_Trainer_6_Text_111ea7, $0000, .Script

.Script:
	opentext
	checkevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_2
	iftrue PrisonF1_111e6e
	writetext PrisonF1_Trainer_6_Script_Text_111eaf
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	iffalse PrisonF1NoRoom
	setevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_2
	closetext
	end

PrisonF1NPC2:
	faceplayer
	opentext
	checkevent EVENT_PRISON_ROOF_CARD
	iftrue PrisonF1_11148a
	writetext PrisonF1NPC2_Text_111490
	verbosegiveitem ROOF_CARD, 1
	writetext PrisonF1NPC2_Text_111842
	setevent EVENT_PRISON_ROOF_CARD
	endtext

PrisonF1_Trainer_7:
	trainer EVENT_PRISON_F1_TRAINER_7, SAILOR, 5, PrisonF1_Trainer_7_Text_1112f6, PrisonF1_Trainer_7_Text_111313, $0000, PrisonF1_Trainer_7_Script

PrisonF1NoRoom:
	jumptext PrisonF1_111f81_Text_1120e8

PrisonF1_Trainer_7_Script:
	opentext
	checkevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_5
	iftrue PrisonF1_1112f0
	writetext PrisonF1_Trainer_7_Script_Text_11132c
	waitbutton
	verbosegiveitem CAGE_KEY, 1
	iffalse PrisonF1NoRoom
	setevent EVENT_PRISON_GOT_KEY_FROM_TRAINER_5
	closetext
	end

PrisonF1_111b2b:
	writebyte 0
	end

PrisonF1_111b2c:
	writebyte 0
	jumptext PrisonF1_111b2c_Text_111b68

PrisonF1_112470:
	checkevent EVENT_PRISON_LOCKED_DOOR_1
	iffalse PrisonF1Door2
	changeblock 20, 6, $1a

PrisonF1Door2:
	checkevent EVENT_PRISON_LOCKED_DOOR_2
	iffalse PrisonF1Door3
	changeblock 34, 4, $1a

PrisonF1Door3:
	checkevent EVENT_PRISON_LOCKED_DOOR_3
	iffalse PrisonF1Door4
	changeblock 36, 18, $57

PrisonF1Door4:
	checkevent EVENT_PRISON_LOCKED_DOOR_4
	iffalse PrisonF1Door5
	changeblock 34, 26, $18

PrisonF1Door5:
	checkevent EVENT_PRISON_LOCKED_DOOR_5
	iffalse PrisonF1Door6
	changeblock 26, 26, $18

PrisonF1Door6:
	checkevent EVENT_PRISON_LOCKED_DOOR_6
	iffalse PrisonF1Door7
	changeblock 18, 26, $18

PrisonF1Door7:
	checkevent EVENT_PRISON_LOCKED_DOOR_7
	iffalse PrisonF1Door8
	changeblock 12, 22, $18

PrisonF1Door8:
	checkevent EVENT_PRISON_LOCKED_DOOR_8
	iffalse PrisonF1Door9
	changeblock 4, 22, $18

PrisonF1Door9:
	checkevent EVENT_PRISON_LOCKED_DOOR_9
	iffalse PrisonF1Door10
	changeblock 4, 30, $57

PrisonF1Door10:
	checkevent EVENT_PRISON_LOCKED_DOOR_10
	iffalse PrisonF1Door11
	changeblock 10, 30, $57

PrisonF1Door11:
	checkevent EVENT_PRISON_LOCKED_DOOR_11
	iffalse PrisonF1Door12
	changeblock 14, 30, $57

PrisonF1Door12:
	checkevent EVENT_PRISON_LOCKED_DOOR_12
	iffalse PrisonF1Door13
	changeblock 22, 30, $57

PrisonF1Door13:
	checkevent EVENT_PRISON_LOCKED_DOOR_13
	iffalse PrisonF1Door14
	changeblock 30, 30, $57

PrisonF1Door14:
	checkevent EVENT_PRISON_LOCKED_DOOR_14
	iffalse PrisonF1_1124fc
	changeblock 36, 30, $57
	return

PrisonF1_111b20:
	takeitem CAGE_KEY, 1
	playsound SFX_ENTER_DOOR
	scall PrisonF1_112470
	refreshscreen 0
	reloadmappart
	closetext
	end

PrisonF1_11290d:
	jumptext PrisonF1_11290d_Text_1129ed

PrisonF1_111d48:
	jumptext PrisonF1_111d48_Text_111e2c

PrisonF1_111e6e:
	jumptext PrisonF1_111e6e_Text_111f41

PrisonF1_111e67:
	jumptext PrisonF1_111e67_Text_111f11

PrisonF1_11148a:
	jumptext PrisonF1_11148a_Text_112209

PrisonF1_1112f0:
	jumptext PrisonF1_1112f0_Text_111358

PrisonF1_1124fc:
	return

PrisonF1Signpost1_Text_111b32:
	ctxt "Do you want to"
	line "unlock this door?"
	done

PrisonF1Signpost1_Text_111b54:
	ctxt "Unlocked the"
	line "door!"
	done

PrisonF1Signpost11_Text_112504:
	ctxt "Don't try to jump"
	line "and escape."

	para "Don't forget,"
	line "you're here"
	cont "forever."
	done

PrisonF1_Trainer_1_Text_110db3:
	ctxt "Prison actually"
	line "isn't too bad."

	para "At least I don't"
	line "have to pay my"
	cont "student loans."
	done

PrisonF1_Trainer_1_Text_110e00:
	ctxt "More interest,"
	line "more pain."
	done

PrisonF1_Trainer_1_Script_Text_110e1b:
	ctxt "You seem like a"
	line "sensible young"
	para "kid, with a very"
	line "sensible kind of"
	cont "lifestyle."

	para "You pursue the"
	line "life that you want"
	para "over the life you"
	line "are expected to"
	para "live, and because"
	line "of that decision,"

	para "great things will"
	line "happen to you and"
	para "to those with whom"
	line "you've interacted."

	para "If you want some"
	line "real trustworthy"
	para "info: try and go"
	line "up to the roof."

	para "A bunch of the"
	line "prison guards go"
	para "up there to have a"
	line "drink and smoke"
	cont "during breaks."

	para "Some of them may"
	line "even be so drunk"
	para "they slip you the"
	line "secret password."
	done

PrisonF1_Trainer_2_Text_113a7a:
	ctxt "<...> I hope my girl"
	line "Jasmine is still"
	para "waiting for me"
	line "on the outside."
	done

PrisonF1_Trainer_2_Text_113abb:
	ctxt "No fair! I wasn't"
	line "paying attention!"
	done

PrisonF1_Trainer_2_Script_Text_113adf:
	ctxt "Sorry young one,"
	line "I don't have any"
	para "information to"
	line "spare with you."
	done

PrisonF1_Trainer_3_Text_111f8e:
	ctxt "They're letting"
	line "kids into this"
	cont "place too, now?"

	para "Prison is hereby"
	line "officially uncool."
	done

PrisonF1_Trainer_3_Text_111ff0:
	ctxt "I just can't"
	line "believe this!"

	para "Prison has ended"
	line "up becoming some"
	para "place for trendy"
	line "hipsters to get"
	para "locked up for non-"
	line "violent 'civil"
	cont "disobedience'."
	done

PrisonF1_Trainer_3_Script_Text_112071:
	ctxt "The only reason"
	line "why I let myself"
	para "get locked up in"
	line "here is to get me"
	cont "some respect."

	para "<...> Which is why I"
	line "don't need this"
	cont "key anymore."
	done

PrisonF1_Trainer_4_Text_112913:
	ctxt "I need some space."
	done

PrisonF1_Trainer_4_Text_11296e:
	ctxt "You just made a"
	line "very big mistake"
	cont "there, kid."
	done

PrisonF1_Trainer_4_Script_Text_112996:
	ctxt "If you take this"
	line "rusty key off my"
	para "hands, I bother"
	line "with you."
	done

PrisonF1_Trainer_5_Text_111d4e:
	ctxt "You out for some"
	line "information?"

	para "Well, how about"
	line "a battle instead."
	done

PrisonF1_Trainer_5_Text_111d7b:
	ctxt "Darn, you're good!"
	done

PrisonF1_Trainer_5_Script_Text_111d8d:
	ctxt "Heh, it's been so"
	line "long since I have"
	para "felt that thrill"
	line "of battling."

	para "Also, sorry kid,"
	line "I don't have any"
	para "useful information"
	line "for you, really."

	para "I do have a key"
	line "though, somewhere."
	done

PrisonF1_Trainer_6_Text_111e74:
	ctxt "Hey there friend!"
	done

PrisonF1_Trainer_6_Text_111ea7:
	ctxt "What waas that?"
	done

PrisonF1_Trainer_6_Script_Text_111eaf:
	para "I can't believe"
	line "you, after all"
	cont "we've been through!"

	para "Just please take"
	line "this key and go!"
	done

PrisonF1NPC2_Text_111490:
	ctxt "I recognize you."

	para "You went under-"
	line "cover and landed"
	cont "me up in here."

	para "I could easily"
	line "blame you for my"
	cont "being in here,"

	para "but I spent a"
	line "good deal of my"
	para "time here just"
	line "thinking about my"
	cont "life decisions."

	para "Not just my own"
	line "choices, but the"
	para "kind of choices"
	line "that get all of us"
	para "to change the road"
	line "we're set out on."

	para "Me, I joined a"
	line "group of #mon"
	para "Trainers who were"
	line "extreme in their"
	para "means in attaining"
	line "their philosophy."

	para "We used anything,"
	line "such as psychic"
	para "oppression with"
	line "our #mon, to"
	cont "get our way."

	para "I believed I was"
	line "doing good<...>"

	para "That I was doing"
	line "a service to our"
	para "future generations"
	line "by finding ways to"
	para "radically improve"
	line "growth of #mon."

	para "I believed what I"
	line "was doing was good"
	para "until our run-ins"
	line "with you started:"

	para "you, just a humble"
	line "Trainer, who with"

	para "his #mon bested"
	line "our genetically"
	cont "superior ones."

	para "You showed real"
	line "respect to your"
	para "#mon team and"
	line "crafted an extrem-"
	para "ely positive bond"
	line "between them."

	para "The world needs"
	line "more Trainers like"
	cont "you, not like us."

	para "Here, take this."

	para "You deserve this"
	line "more than me."
	done

PrisonF1NPC2_Text_111842:
	ctxt "It's a card I found"
	line "on the ground."

	para "This card lets you"
	line "access the roof."

	para "The basement's door"
	line "is locked by some"
	cont "special code."

	para "That's where they"
	line "keep the unruly"
	cont "#mon of prison."

	para "Someone else might"
	line "know the passcode."
	done

PrisonF1_Trainer_7_Text_1112f6:
	ctxt "It's awfully cold"
	line "in here<...>"
	done

PrisonF1_Trainer_7_Text_111313:
	ctxt "Well, at least"
	line "that warmed me up."
	done

PrisonF1_Trainer_7_Script_Text_11132c:
	ctxt "If you take this"
	line "key, will you"
	cont "please just go?"
	done

PrisonF1_111b2c_Text_111b68:
	ctxt "You need a Cage"
	line "Key to unlock"
	cont "this door."
	done

PrisonF1_111f88_Text_1120fa:
	ctxt "The only reason"
	line "why I let myself"

	para "get locked up in"
	line "here is to get"

	para "some respect from"
	line "my peers."
	done

PrisonF1_111f81_Text_1120e8:
	ctxt "Free some space."
	done

PrisonF1_11290d_Text_1129ed:
	ctxt "Scram!"
	done

PrisonF1_111d48_Text_111e2c:
	ctxt "Get outta here!"
	done

PrisonF1_111e6e_Text_111f41:
	ctxt "Say no more, just"
	line "let me be!"
	done

PrisonF1_111e67_Text_111f11:
	ctxt "I can't give you"
	line "anything if you"
	cont "can't carry it!"
	done

PrisonF1_11148a_Text_112209:
	ctxt "Worry about"
	line "yourself."
	done

PrisonF1_1112f0_Text_111358:
	ctxt "I'll just eat and"
	line "gain blubber."
	done

PrisonF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 11
	warp_def $23, $12, 1, SAXIFRAGE_ISLAND
	warp_def $23, $13, 1, SAXIFRAGE_ISLAND
	warp_def $2, $2, 2, PRISON_PATHS
	warp_def $11, $16, 7, PRISON_PATHS
	warp_def $f, $1f, 3, PRISON_PATHS
	warp_def $8, $25, 1, PRISON_F2
	warp_def $c, $22, 1, PRISON_B1F
	warp_def $1a, $0, 1, PRISON_BATHS
	warp_def $1b, $0, 2, PRISON_BATHS
	warp_def $1c, $27, 1, PRISON_WORKOUT
	warp_def $1d, $27, 2, PRISON_WORKOUT

	;xy triggers
	db 0

	;signposts
	db 13
	signpost 7, 20, SIGNPOST_READ, PrisonF1Signpost1
	signpost 5, 34, SIGNPOST_READ, PrisonF1Signpost2
	signpost 23, 5, SIGNPOST_READ, PrisonF1Signpost3
	signpost 23, 13, SIGNPOST_READ, PrisonF1Signpost4
	signpost 27, 19, SIGNPOST_READ, PrisonF1Signpost5
	signpost 27, 27, SIGNPOST_READ, PrisonF1Signpost6
	signpost 19, 37, SIGNPOST_READ, PrisonF1Signpost7
	signpost 27, 35, SIGNPOST_READ, PrisonF1Signpost8
	signpost 30, 4, SIGNPOST_READ, PrisonF1Signpost9
	signpost 30, 10, SIGNPOST_READ, PrisonF1Signpost10
	signpost 2, 19, SIGNPOST_READ, PrisonF1Signpost11
	signpost 30, 22, SIGNPOST_READ, PrisonF1Signpost12
	signpost 30, 36, SIGNPOST_READ, PrisonF1Signpost13

	;people-events
	db 14
	person_event SPRITE_COOLTRAINER_M, 20, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 2, 0, PrisonF1_Trainer_1, -1
	person_event SPRITE_POKE_BALL, 5, 5, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PrisonF1_Item_1, EVENT_PRISON_F1_ITEM_1
	person_event SPRITE_OFFICER, 8, 20, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ObjectEvent, EVENT_PRISON_F1_NPC_1
	person_event SPRITE_FISHER, 25, 35, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 2, 0, PrisonF1_Trainer_2, -1
	person_event SPRITE_BIKER, 24, 25, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 2, 0, PrisonF1_Trainer_3, -1
	person_event SPRITE_POKE_BALL, 24, 19, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, PrisonF1_Item_2, EVENT_PRISON_F1_ITEM_2
	person_event SPRITE_SAILOR, 20, 11, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 2, 0, PrisonF1_Trainer_4, -1
	person_event SPRITE_POKE_BALL, 5, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, PrisonF1_Item_3, EVENT_PRISON_F1_ITEM_3
	person_event SPRITE_POKE_BALL, 16, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PrisonF1_Item_4, EVENT_PRISON_F1_ITEM_4
	person_event SPRITE_POKE_BALL, 32, 23, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, PrisonF1_Item_5, EVENT_PRISON_F1_ITEM_5
	person_event SPRITE_MINER, 32, 13, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 2, 0, PrisonF1_Trainer_5, -1
	person_event SPRITE_BIRDKEEPER, 32, 29, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, 2, 0, PrisonF1_Trainer_6, -1
	person_event SPRITE_PALETTE_PATROLLER, 32, 3, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_SILVER, 0, 0, PrisonF1NPC2, EVENT_PHLOX_LAB_CEO
	person_event SPRITE_SAILOR, 3, 35, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, 2, 0, PrisonF1_Trainer_7, -1
