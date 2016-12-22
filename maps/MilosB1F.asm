MilosB1F_MapScriptHeader;trigger count
	db 2
	maptrigger MilosB1FCutscene
	maptrigger .Trigger1
 ;callback count
	db 0

.Trigger1
	end

MilosB1FNPC1:
	faceplayer
	opentext
	checkevent EVENT_MILOS_CATACOMBS_FLUTE
	sif true
		jumptext .already_got_flute_text
	writetext .intro_text
	yesorno
	sif false
		jumptext .said_no_text
	checkitem LEMONADE
	sif false
		jumptext .no_lemonade_text
	verbosegiveitem RED_FLUTE, 1
	sif false
		jumptext .no_room_text
	takeitem LEMONADE, 1
	setevent EVENT_MILOS_CATACOMBS_FLUTE
	jumptext .gave_lemonade_text

.already_got_flute_text
	ctxt "Enjoying the"
	line "flute?"

	para "I found it in a"
	line "lower floor."

	para "Rumor has it that"
	line "it belonged to"
	cont "some ancient"
	cont "civilization."
	done

.intro_text
	ctxt "I love lemonade!"

	para "If you get me a"
	line "glass of lemonade,"
	cont "I'll give you a"
	cont "special flute!"

	para "So what do you"
	line "say, will you"
	cont "give me one?"
	done

.said_no_text
	ctxt "Well that's not"
	line "very nice."
	done

.no_lemonade_text
	ctxt "You can't fool"
	line "me, you don't"
	cont "have a single"
	cont "lemonade glass!"
	done

.gave_lemonade_text
	ctxt "Wonderful, can't"
	line "wait to drink"
	cont "this stuff!"

	para "Wait a second<...>"

	para "Haven't you ever"
	line "heard of a"
	cont "cooler?"

	para "Or at least a"
	line "thermos?"
	done

.no_room_text
	ctxt "You don't have room"
	line "for my flute!"
	
	para "I can't take your"
	line "lemonade and give"
	cont "you nothing back<...>"
	done

MilosB1F_Trainer_1:
	trainer EVENT_MILOS_B1F_TRAINER_1, PATROLLER, 4, MilosB1F_Trainer_1_Text_1f99ef, MilosB1F_Trainer_1_Text_1f9a24, $0000, .Script

.Script:
	jumptext MilosB1F_Trainer_1_Script_Text_1f9a36

MilosB1FCutscene:
	opentext
	writetext MilosB1FNPC3_Text_1f9b33
	waitbutton
	writetext MilosB1FNPC3_Text_1f9b65
	waitbutton
	writetext MilosB1FNPC3_Text_1f9b93
	waitbutton
	writetext MilosB1FNPC3_Text_1f9bbc
	waitbutton
	writetext MilosB1FNPC3_Text_1f9c2b
	waitbutton
	spriteface 4, 3
	writetext MilosB1FNPC3_Text_1f9c86
	waitbutton
	spriteface 6, 2
	writetext MilosB1FNPC3_Text_1f9ca9
	waitbutton
	writetext MilosB1FNPC3_Text_1f9ced
	waitbutton
	writetext MilosB1FNPC3_Text_1f9d23
	waitbutton
	writetext MilosB1FNPC3_Text_1f9d5d
	waitbutton
	spriteface 4, 1
	spriteface 6, 1
	writetext MilosB1FNPC3_Text_1f9d88
	waitbutton
	writetext MilosB1FNPC3_Text_1f9dbb
	waitbutton
	writetext MilosB1FNPC3_Text_1f9e02
	waitbutton
	writetext MilosB1FNPC3_Text_1f9e4c
	waitbutton
	writetext MilosB1FNPC3_Text_1f9eab
	waitbutton
	writetext MilosB1FNPC3_Text_1f9ef9
	waitbutton
	writetext MilosB1FNPC3_Text_1f9f24
	waitbutton
	writetext MilosB1FNPC3_Text_1f9f34
	waitbutton
	writetext MilosB1FNPC3_Text_1f9f83
	waitbutton
	writetext MilosB1FNPC3_Text_1f9fa7
	waitbutton
	writetext MilosB1FNPC3_Text_1f9ff2
	waitbutton
	closetext
	follow 5, 8
	applymovement 5, MilosB1FNPC3_Movement1
	opentext
	writetext MilosB1FNPC3_Text_1fa06a
	waitbutton
	writetext MilosB1FNPC3_Text_1fa0ae
	waitbutton
	writetext MilosB1FNPC3_Text_1fa0fb
	waitbutton
	spriteface 6, 2
	writetext MilosB1FNPC3_Text_1fa116
	closetext
	applymovement 6, MilosB1FNPC3_Movement2
	opentext
	writetext MilosB1FNPC3_Text_1fa123
	waitbutton
	follow 4, 7
	closetext
	applymovement 4, MilosB1FNPC3_Movement2
	setevent EVENT_MOUND_B2F_ITEM_2
	disappear 4
	disappear 5
	disappear 6
	disappear 7
	disappear 8
	dotrigger 1
	end

MilosB1FNPC3_Movement1:
	step_left
	step_left
	step_up
	step_left
	step_left
	step_left
	step_end

MilosB1FNPC3_Movement2:
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_left
	step_left
	step_end

MilosB1F_Trainer_1_Text_1f99ef:
	ctxt "Seriously?"
	done

MilosB1F_Trainer_1_Text_1f9a24:
	ctxt "Hey, come on now!"
	done

MilosB1F_Trainer_1_Script_Text_1f9a36:
	ctxt "Look, I'm having"
	line "a real bad day."

	para "I don't want to"
	line "talk to you."
	done

MilosB1FNPC2_Text_1fba00:
	ctxt "@"
	;deciram $d597, 1, 0
	ctxt "/15"
	line "Roll the dice?"
	done

MilosB1FNPC3_Text_1f9b33:
	ctxt "Black: So, boss."

	para "When are we gonna"
	line "get paid for this?"
	done

MilosB1FNPC3_Text_1f9b65:
	ctxt "No. 13: You'll"
	line "get paid when"
	cont "you do your job!"
	done

MilosB1FNPC3_Text_1f9b93:
	ctxt "Yellow: But we"
	line "have been doing"
	cont "our job properly!"
	done

MilosB1FNPC3_Text_1f9bbc:
	ctxt "No. 08: Oh yeah,"
	line "missy? Then tell"
	cont "me about this:"

	para "why are the cops"
	line "suspecting that"
	cont "something fishy's"
	cont "going on in the"
	cont "underground city?"
	done

MilosB1FNPC3_Text_1f9c2b:
	ctxt "Black: It probably"
	line "has something to"
	cont "do with all of"
	cont "those big, weird"
	cont "earthquakes<...>"
	done

MilosB1FNPC3_Text_1f9c86:
	ctxt "Green: Missy?"

	para "Wait<...> Dude."

	para "You're a girl?"
	done

MilosB1FNPC3_Text_1f9ca9:
	ctxt "Yellow: Of course"
	line "I am! We went to"
	cont "high school tog-"
	cont "ether, remember!?"
	done

MilosB1FNPC3_Text_1f9ced:
	ctxt "Green: <...>I don't"
	line "remember our high"
	cont "school allowing"
	cont "girls at campus."
	done

MilosB1FNPC3_Text_1f9d23:
	ctxt "Yellow: Yeah, they"
	line "let me in anyway."

	para "Have a problem"
	line "with that, huh?"
	done

MilosB1FNPC3_Text_1f9d5d:
	ctxt "No. 13: Is this"
	line "what you guys call"
	cont "'doing our job'?"
	done

MilosB1FNPC3_Text_1f9d88:
	ctxt "No. 08: I can't"
	line "believe the boss"
	cont "hired these guys."
	done

MilosB1FNPC3_Text_1f9dbb:
	ctxt "No. 13: Could you"
	line "guys please just"
	cont "SHUT UP and do"
	cont "your darn job?"

	para "No cops!"

	para "Got it?"
	done

MilosB1FNPC3_Text_1f9e02:
	ctxt "Yellow: Got it,"
	line "but the cops aren't"
	cont "who you should be"
	cont "worried about<...>"
	done

MilosB1FNPC3_Text_1f9e4c:
	ctxt "Green: There's"
	line "some kid from a"
	cont "distant region"
	cont "who keeps getting"
	cont "in our way!"
	done

MilosB1FNPC3_Text_1f9eab:
	ctxt "Black: Naturally,"
	line "no matter what we"
	cont "do, we'll end up"
	cont "facing that, uhm,"
	cont "'annoyance' again."
	done

MilosB1FNPC3_Text_1f9ef9:
	ctxt "Yellow: It's like,"
	line "our fate I guess."
	done

MilosB1FNPC3_Text_1f9f24:
	ctxt "Green: Totally."
	done

MilosB1FNPC3_Text_1f9f34:
	ctxt "No. 13: Well if"
	line "that's the case<...>"

	para "I'll just let the"
	line "boss know about"
	cont "this 'prodigy'."
	done

MilosB1FNPC3_Text_1f9f83:
	ctxt "No. 08: But we'll"
	line "take care of him."
	done

MilosB1FNPC3_Text_1f9fa7:
	ctxt "No. 13: Don't"
	line "worry about it."
	done

MilosB1FNPC3_Text_1f9ff2:
	ctxt "No. 08: Anyway,"
	line "you three let your"
	cont "boss know to keep"
	cont "going with these<...>"
	cont "'distractions'."

	para "We're really close"
	line "to finishing our"
	cont "project, at last."
	done

MilosB1FNPC3_Text_1fa06a:
	ctxt "Green: That was"
	line "some pretty cool"
	cont "banter we had"
	cont "going on there."
	done

MilosB1FNPC3_Text_1fa0ae:
	ctxt "Yellow: Yeah, but"
	line "why don't you know"
	cont "my gender<...>?"

	para "I thought we were"
	line "together for ages!"
	done

MilosB1FNPC3_Text_1fa0fb:
	ctxt "Green: We are WHAT"
	line "now? <...> Why"
	cont "do you think that?"
	done

MilosB1FNPC3_Text_1fa116:
	ctxt "Yellow: <...>"
	prompt

MilosB1FNPC3_Text_1fa123:
	ctxt "Green: Hang on,"
	line "it's sometimes"
	cont "hard to hear"
	cont "with this helmet."
	done

MilosB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $21, $21, 9, MILOS_F1
	warp_def $3, $3, 1, MILOS_B2F
	warp_def $21, $7, 5, MILOS_F1
	warp_def $11, $3, 1, MILOS_B2FB
	warp_def $4, $8, 3, MILOS_B2F
	warp_def $5, $8, 3, MILOS_B2F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 7
	person_event SPRITE_POKEFAN_M, 6, 36, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MilosB1FNPC1, -1
	person_event SPRITE_PALETTE_PATROLLER, 6, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 2, MilosB1F_Trainer_1, EVENT_MILOS_B1F_TRAINER_1
	person_event SPRITE_PALETTE_PATROLLER, 31, 33, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ObjectEvent, EVENT_MILOS_B1F_NPC_2
	person_event SPRITE_SCIENTIST, 29, 32, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, EVENT_MILOS_B1F_NPC_3
	person_event SPRITE_PALETTE_PATROLLER, 31, 34, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, ObjectEvent, EVENT_MILOS_B1F_NPC_4
	person_event SPRITE_PALETTE_PATROLLER, 31, 32, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, ObjectEvent, EVENT_MILOS_B1F_NPC_5
	person_event SPRITE_SCIENTIST, 29, 34, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, EVENT_MILOS_B1F_NPC_6
