MoundF1_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, MoundF1_SwapMap

MoundF1_Item_1:
	db MINING_PICK, 1

MoundF1NPC3:
	jumpstd smashrock

MoundF1NPC4:
	opentext
	writetext MoundF1NPC4_Text_10b350
	waitbutton
	closetext
	faceplayer
	showemote 3, 6, 32
	spriteface 6, 2
	opentext
	writetext MoundF1NPC4_Text_10b398
	playwaitsfx SFX_HANG_UP
	closetext

	faceplayer
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext MoundF1NPC4_Text_10b3b0
	waitbutton
	loadtrainer RIVAL1, RIVAL1_2
	winlosstext MoundF1NPC4Text_10b470, 0
	startbattle
	reloadmapafterbattle

	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext MoundF1NPC4_Text_10b4a2
	waitbutton
	closetext
	applymovement 6, MoundF1NPC4_Movement1
	special RestartMapMusic
	disappear 6
	setevent EVENT_MOUND_CAVE_RIVAL
	end

MoundF1NPC4_Movement1:
	step_left
	step_left
	step_left
	step_left
	step_left
	step_down
	step_down
	step_down
	step_end

MoundF1_Item_2:
	db SUPER_POTION, 1

MoundF1NPC2:
	opentext
	checkevent EVENT_SPOKE_DYNAMITE_GUY
	sif false, then
		writetext MoundF1NPC2_Text_109dd0
		waitbutton
		setevent EVENT_SPOKE_DYNAMITE_GUY
	sendif
	takeitem DYNAMITE, 5
	iffalse MoundF1_NotEnoughDynamite
	giveitem DYNAMITE, 5
	writetext MoundF1_10a554_Text_10a0ea
	findpokemontype FIRE
	waitbutton
	sif false, then
		closetext
		end
	sendif
	callasm ReadScriptVarMonName
	writetext MoundF1_DynamiteGuy_Text_TryMon
	addvar -1
	copyvartobyte wCurPartyMon
	yesorno
	closetext
	sif false
		end
	callstd fieldmovepokepic
	opentext
	writetext MoundF1_10a5ba_Text_10a4ac
	waitbutton
	closetext
	applymovement 0, MoundF1_10a5ba_Movement1
	applymovement 3, MoundF1_10a5ba_Movement2
	applymovement 3, MoundF1_10a5ba_Movement3
	showemote 0, 0, 32
	applymovement 0, MoundF1_10a602_Movement1
	changemap BANK(MoundF1_10a5d0_BlockData1), MoundF1_10a5d0_BlockData1
	playsound SFX_EGG_BOMB
	earthquake 24
	playsound SFX_EGG_BOMB
	earthquake 24
	playsound SFX_EGG_BOMB
	earthquake 24
	playsound SFX_EGG_BOMB
	earthquake 24
	spriteface 3, 1
	spriteface PLAYER, LEFT
	loademote 2
	showemote 2, 3, 32
	opentext
	writetext MoundF1_10a5d0_Text_10a4d6
	waitbutton
	closetext
	playsound SFX_JUMP_OVER_LEDGE
	applymovement 3, MoundF1_10a5d0_Movement1
	takeitem DYNAMITE, 5
	setevent EVENT_BLEW_UP_DYNAMITE
	end

MoundF1_SwapMap:
	checkevent EVENT_BLEW_UP_DYNAMITE
	sif true
		changemap BANK(MoundF1_10a5d0_BlockData1), MoundF1_10a5d0_BlockData1
	return

MoundF1_NotEnoughDynamite:
	checkitem POKE_BALL
	iffalse .givePokeball
	writetext MoundF1NPC2_Text_10a000
	waitbutton
	jumptext MoundF1NPC2_Text_10a0b8

.givePokeball
	writetext MinerNoPokeballsText
	waitbutton
	verbosegiveitem POKE_BALL, 3
	closetext
	end

MoundF1_10a5ba_Movement1:
	step_right
	step_end

MoundF1_10a5ba_Movement2:
	step_down
	step_end

MoundF1_10a5ba_Movement3:
	run_step_down
	run_step_down
	run_step_right
	run_step_right
	run_step_right
	run_step_right
	run_step_right
	run_step_right
	run_step_up
	run_step_right
	run_step_right
	run_step_down
	step_end

MoundF1_10a602_Movement1:
	run_step_down
	run_step_down
	run_step_right
	run_step_right
	run_step_right
	run_step_right
	run_step_right
	run_step_up
	run_step_right
	run_step_right
	run_step_right
	step_end

MoundF1_10a5d0_Movement1:
	jump_step_left
	run_step_left
	run_step_left
	hide_person
	step_down
	step_down
	step_down
	step_down
	step_end

MinerNoPokeballsText:
	ctxt "You don't have any"
	line "#balls?"

	para "Well<...>"

	para "To get through the"
	line "cave, you're going"

	para "to need Electric"
	line "and Fire #mon."

	para "Here."

	para "Have a couple of"
	line "#balls!"
	done

MoundF1NPC2_Text_109dd0:
	ctxt "Ah, hello there!"

	para "I'd like to leave"
	line "this place."

	para "However<...>"

	para "These rocks are"
	line "blocking the exit."

	para "I almost have"
	line "enough dynamite"
	cont "to get rid of"
	cont "these darn things,"

	para "but I'd need about"
	line "5 more to get them"
	cont "out of my way<...>"

	para "Forever. Hehe."
	done

MoundF1NPC2_Text_10a000:
	ctxt "Hmm. If I'm not"
	line "mistaken, there"
	cont "should be some"
	cont "dynamite left."

	para "It should be"
	line "spread out on the"
	cont "bottom floor."

	para "However, I saw"
	line "a bunch of multi-"
	cont "colored freaks"
	cont "hang around there."

	para "If you want to"
	line "help me out and"
	cont "deal with them,"
	cont "be my guest."
	done

MoundF1NPC2_Text_10a0b8:
	ctxt "I'm still waiting"
	line "for the dynamite."

	para "I need 5 sticks to"
	line "blast us through."
	done

MoundF1NPC4_Text_10b350:
	ctxt "I can't hear you<...>"

	para "OK, now I get you."

	para "Alright, you want"
	line "me to go where?"
	done

MoundF1NPC4_Text_10b398:
	ctxt "<...>"

	para "I'll call you back."
	done

MoundF1NPC4_Text_10b3b0:
	ctxt "I told you to stay"
	line "out of my way."

	para "Can't you follow"
	line "the most basic"
	cont "instructions?"

	para "<...>"

	para "I guess it's time"
	line "to see if these"
	cont "new #mon can"
	cont "slice your team"
	cont "up real good!"
	done

MoundF1NPC4Text_10b470:
	ctxt "What was that"
	line "for, huh?"
	done

MoundF1NPC4_Text_10b4a2:
	ctxt "These worthless"
	line "pests are just a"
	cont "waste of my time."

	para "Now I am off to"
	line "find new #mon"
	cont "that suit my"
	cont "specific needs."

	para "<...>"

	para "What those are?"

	para "Hah! That's not"
	line "your concern."
	done

MoundF1_10a554_Text_10a0ea:
	ctxt "Great, you got all"
	line "of the sticks!"

	para "However, we need"
	line "some real fire to"
	cont "light the fuse."

	para "Maybe a Fire-type"
	line "#mon or move"
	cont "could do it<...>"
	done

MoundF1_DynamiteGuy_Text_TryMon:
	ctxt "Try with"
	line "<STRBF2>?"
	done

MoundF1_10a5ba_Text_10a4ac:
	ctxt "Great, it lit"
	line "the fuse, let's"
	cont "stand back!"
	done

MoundF1_10a5d0_Text_10a4d6:
	ctxt "Whoo hoo!"

	para "I'm free!"

	para "Thanks kid."
	done

MoundF1_10a5d0_BlockData1:
INCBIN "./maps/MoundF1_10a5d0_BlockData1.blk.lz"

MoundF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 10
	warp_def $19, $11, 3, ROUTE_73
	warp_def $2b, $3, 10, MOUND_F1
	warp_def $45, $19, 2, CAPER_CITY
	warp_def $3, $19, 5, CAPER_CITY
	warp_def $5, $f, 8, MOUND_F1
	warp_def $d, $11, 1, MOUND_B3F
	warp_def $31, $9, 1, MOUND_B1F
	warp_def $3b, $11, 5, MOUND_F1
	warp_def $a, $10, 1, CAPER_CITY
	warp_def $59, $3, 2, MOUND_F1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 7
	person_event SPRITE_POKE_BALL, 31, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, 3, TM_AERIAL_ACE, 0, EVENT_MOUND_CAVE_TM43
	person_event SPRITE_R_HIKER, 2, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoundF1NPC2, EVENT_BLEW_UP_DYNAMITE
	person_event SPRITE_POKE_BALL, 73, 14, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundF1_Item_1, EVENT_MOUND_F1_ITEM_1
	person_event SPRITE_ROCK, 37, 11, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, MoundF1NPC3, -1
	person_event SPRITE_SILVER, 27, 11, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoundF1NPC4, EVENT_MOUND_CAVE_RIVAL
	person_event SPRITE_POKE_BALL, 60, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 3, TM_PROTECT, 0, EVENT_MOUND_CAVE_TM17
	person_event SPRITE_POKE_BALL, 87, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MoundF1_Item_2, EVENT_MOUND_F1_ITEM_2
