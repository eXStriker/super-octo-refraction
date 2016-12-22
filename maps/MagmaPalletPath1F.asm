MagmaPalletPath1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaPalletPath1FTrap1:
	checkevent EVENT_VARANEOUS_REVIVED
	iffalse MagmaPalletPath1F_114f65
	end

MagmaPalletPath1F_Trainer_1:
	trainer EVENT_MAGMA_PALLETPATH_1F_TRAINER_1, PATROLLER, 8, MagmaPalletPath1F_Trainer_1_Text_117404, MagmaPalletPath1F_Trainer_1_Text_11743a, $0000, .Script

.Script:
	opentext
	writetext MagmaPalletPath1F_Trainer_1_Script_Text_117449
	waitbutton
	closetext
	applymovement 2, MagmaPalletPath1F_Trainer_1_Script_Movement1
	disappear 2
	end

MagmaPalletPath1F_Trainer_1_Script_Movement1:
	step_left
	step_left
	step_left
	step_down
	step_down
	step_left
	step_left
	step_left
	step_end

MagmaPalletPath1F_Trainer_2:
	trainer EVENT_MAGMA_PALLETPATH_1F_TRAINER_2, PATROLLER, 11, MagmaPalletPath1F_Trainer_2_Text_1174ed, MagmaPalletPath1F_Trainer_2_Text_11753e, $0000, .Script

.Script:
	opentext
	writetext MagmaPalletPath1F_Trainer_2_Script_Text_11754d
	waitbutton
	closetext
	applymovement 3, MagmaPalletPath1F_1175f7_Movement1
	disappear 3
	end

MagmaPalletPath1F_Trainer_3:
	trainer EVENT_MAGMA_PALLETPATH_1F_TRAINER_3, PATROLLER, 16, MagmaPalletPath1F_Trainer_3_Text_117b82, MagmaPalletPath1F_Trainer_3_Text_117bc9, $0000, .Script

.Script:
	opentext
	writetext MagmaPalletPath1F_Trainer_3_Script_Text_117bd5
	waitbutton
	closetext
	applymovement 7, MagmaPalletPath1F_117cef_Movement1
	disappear 7
	end

MagmaPalletPath1FNPC3_Movement1:
	step_up
	step_up
	step_end

MagmaPalletPath1FNPC3_Movement2:
	step_down
	step_down
	step_right
	step_right
	jump_step_down
	step_down
	step_left
	step_left
	turn_head_up
	step_end

MagmaPalletPath1FNPC3_Movement3:
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_up
	fast_slide_step_up
	step_end

MagmaPalletPath1FNPC3_Movement4:
	fast_slide_step_right
	fast_slide_step_down
	fast_slide_step_down
	fast_slide_step_up
	fast_slide_step_up
	step_end

MagmaPalletPath1FNPC3_Movement5:
	fast_slide_step_left
	step_end

MagmaPalletPath1FNPC3_Movement6:
	fast_slide_step_down
	fast_slide_step_down
	fast_jump_step_left
	fast_jump_step_left
	fast_jump_step_left
	fast_jump_step_left
	step_end

MagmaPalletPath1FNPC3_Movement7:
	step_right
	step_up
	step_right
	step_up
	step_up
	step_right
	step_up
	step_up
	step_end

MagmaPalletPath1F_114f65:
	opentext
	spriteface 10, 3
	writetext MagmaPalletPath1FNPC3_Text_115027
	waitbutton
	spriteface 9, 2
	writetext MagmaPalletPath1FNPC3_Text_115066
	waitbutton
	spriteface 8, 2
	writetext MagmaPalletPath1FNPC3_Text_1150d3
	waitbutton
	spriteface 9, 3
	writetext MagmaPalletPath1FNPC3_Text_115111
	waitbutton
	writetext MagmaPalletPath1FNPC3_Text_1151bb
	waitbutton
	writetext MagmaPalletPath1FNPC3_Text_115208
	waitbutton
	writetext MagmaPalletPath1FNPC3_Text_11525e
	waitbutton
	spriteface 9, 2
	writetext MagmaPalletPath1FNPC3_Text_1152a4
	waitbutton
	spriteface 8, 0
	writetext MagmaPalletPath1FNPC3_Text_11537f
	waitbutton
	closetext
	applymovement 0, MagmaPalletPath1F_114f65_Movement1
	spriteface 9, 0
	spriteface 10, 0
	opentext
	writetext MagmaPalletPath1FNPC3_Text_1153b5
	waitbutton
	spriteface 8, 1
	spriteface 9, 1
	spriteface 10, 1
	playsound SFX_AEROBLAST
	earthquake 16
	appear $4
	cry VARANEOUS
	closetext
	applymovement 4, MagmaPalletPath1F_114f65_Movement2
	spriteface 8, 1
	spriteface 9, 1
	spriteface 10, 1
	opentext
	writetext MagmaPalletPath1FNPC3_Text_1154f4
	waitbutton
	closetext
	applymovement 4, MagmaPalletPath1F_114f65_Movement3
	playsound SFX_KARATE_CHOP
	spriteface 4, DOWN
	spriteface 9, 2
	pause 16
	spriteface 9, 1
	opentext
	writetext MagmaPalletPath1FNPC3_Text_11560d
	closetext
	applymovement 4, MagmaPalletPath1F_114f65_Movement4
	playsound SFX_KARATE_CHOP
	spriteface 4, DOWN
	spriteface 8, 2
	pause 16
	spriteface 8, 1
	opentext
	writetext MagmaPalletPath1FNPC3_Text_11564c
	waitbutton
	applymovement 4, MagmaPalletPath1F_114f65_Movement5
	spriteface 0, 3
	refreshscreen 0
	pokepic VARANEOUS
	cry VARANEOUS
	waitsfx
	closepokepic
	opentext
	writetext MagmaPalletPath1FNPC3_Text_115691
	waitbutton
	cry VARANEOUS
	waitsfx
	closetext
	applymovement 4, MagmaPalletPath1F_114f65_Movement6
	spriteface 0, 2
	opentext
	writetext MagmaPalletPath1FNPC3_Text_1156a6
	waitbutton
	spriteface 0, 0
	spriteface 8, 0
	spriteface 9, 0
	spriteface 10, 0
	closetext
	appear $5
	appear $6
	follow 6, 5
	applymovement 6, MagmaPalletPath1F_114f65_Movement7
	spriteface 6, 1
	stopfollow
	opentext
	writetext MagmaPalletPath1F_11590a_Text_1156c6
	closetext
	applymovement 5, MagmaPalletPath1F_11590a_Movement1
	opentext
	writetext MagmaPalletPath1F_11590a_Text_115764
	special Special_BattleTowerFade
	playsound SFX_ENTER_DOOR
	waitsfx
	warp ROUTE_80_NOBU, 5, 4
	special InitRoamMons
	setevent EVENT_VARANEOUS_REVIVED
	setevent EVENT_MAGMA_POLICE
	writebyte VARANEOUS
	special SpecialSeenMon
	spriteface 0, 2
	end

MagmaPalletPath1F_114f65_Movement1:
	step_up
	step_up
	step_right
	turn_head_up
	step_end

MagmaPalletPath1F_114f65_Movement2:
	step_down
	jump_step_down
	step_end

MagmaPalletPath1F_114f65_Movement3:
	fast_slide_step_down
	fast_slide_step_up
	step_end

MagmaPalletPath1F_114f65_Movement4:
	fast_slide_step_right
	fast_slide_step_down
	fast_slide_step_up
	step_end

MagmaPalletPath1F_114f65_Movement5:
	fast_slide_step_right
	jump_step_down
	fast_slide_step_left
	step_end

MagmaPalletPath1F_114f65_Movement6:
	fast_slide_step_down
	fast_jump_step_left
	fast_jump_step_left
	fast_jump_step_left
	fast_jump_step_left
	step_end

MagmaPalletPath1F_114f65_Movement7:
	step_right
	step_up
	step_right
	step_up
	step_up
	step_up
	step_up
	step_end

MagmaPalletPath1F_1175f7_Movement1:
	step_right
	step_right
	step_right
	step_right
	step_right
	step_down
	step_down
	step_down
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	step_end

MagmaPalletPath1F_117cef_Movement1:
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_up
	step_up
	step_up
	step_end

MagmaPalletPath1F_11590a_Movement1:
	step_right
	turn_head_up
	step_end

MagmaPalletPath1F_Trainer_1_Text_117404:
	ctxt "Wait, what are"
	line "you doing here?"

	para "You're not going"
	line "to stop us!"
	done

MagmaPalletPath1F_Trainer_1_Text_11743a:
	ctxt "Stubborn, huh?"
	done

MagmaPalletPath1F_Trainer_1_Script_Text_117449:
	ctxt "Look, we do what"
	line "we have to do."

	para "Face it, it's over"
	line "your head, kid."

	para "We'll do anything"
	line "we have to do to"
	cont "get our way."

	para "The end always ju-"
	line "stifies the means."
	done

MagmaPalletPath1F_Trainer_2_Text_1174ed:
	ctxt "This the best gig"
	line "I'll ever get,"

	para "I'm not going to"
	line "let you take it"
	cont "away from me!"
	done

MagmaPalletPath1F_Trainer_2_Text_11753e:
	ctxt "No mercy, huh?"
	done

MagmaPalletPath1F_Trainer_2_Script_Text_11754d:
	ctxt "I'm not completely"
	line "sure what the boss"
	cont "has been up to,"

	para "but he's called"
	line "all of us here."

	para "He's saying that"
	line "everything he's"

	para "done has led up"
	line "to this moment."

	para "Color me curious."
	done

MagmaPalletPath1F_Trainer_3_Text_117b82:
	ctxt "Guess what idiot?"

	para "You're too late!"

	para "We already have"
	line "everything that"
	cont "we need<...>!"
	done

MagmaPalletPath1F_Trainer_3_Text_117bc9:
	ctxt "No matter."
	done

MagmaPalletPath1F_Trainer_3_Script_Text_117bd5:
	ctxt "<...>"

	para "You're just like"
	line "your father."

	para "He who disobeyed"
	line "his roots to"

	para "strive for"
	line "popularity, as a"

	para "self proclaimed"
	line "#mon Master."

	para "Well, now all that"
	line "will change."

	para "Your family has"
	line "betrayed Naljo"
	cont "for the last time!"

	para "The proud culture"
	line "of Naljo will be"
	cont "awoken once again!"
	done

MagmaPalletPath1FNPC3_Text_115027:
	ctxt "Blue: I'm still"
	line "confused Red,"
	cont "why are we here?"

	para "And why do we"
	line "have to keep on"
	cont "wearing spandex?"
	done

MagmaPalletPath1FNPC3_Text_115066:
	ctxt "Red: AGAIN, THIS"
	line "IS NOT SPANDEX!"

	para "It's a traditional"
	line "Naljo garb."

	para "As I've already"
	line "told you, Andy,"

	para "we have finally"
	line "finished searching"

	para "the region for the"
	line "orbs of the Naljo"
	cont "Guardians."

	para "Once Varaneous"
	line "wakes up, Naljo"

	para "will return to"
	line "the paradise that"

	para "our forefathers"
	line "once experienced!"
	done

MagmaPalletPath1FNPC3_Text_1150d3:
	ctxt "Pink: Why is it"
	line "just the three"
	cont "of us here?"

	para "I heard one of"
	line "the other guys"
	cont "got arrested,"

	para "but what about"
	line "the other two?"
	done

MagmaPalletPath1FNPC3_Text_115111:
	ctxt "Red: They are"
	line "also traitors."

	para "They viewed us"
	line "as criminals who"

	para "just want money"
	line "and rare #mon."

	para "We're not Team"
	line "Rocket, we just"
	cont "want outsiders to"

	para "stop interfering"
	line "with our almost"
	cont "forgotten culture."
	done

MagmaPalletPath1FNPC3_Text_1151bb:
	ctxt "Pink: But<...> they"
	line "were trying to"
	cont "help us get money"
	cont "so we could cover"
	cont "even more ground."

	para "After all, the"
	line "end jus<...>"
	done

MagmaPalletPath1FNPC3_Text_115208:
	ctxt "Red: Shut up!"

	para "Money doesn't"
	line "interest me."

	para "Money is part of"
	line "what ruined Naljo."
	done

MagmaPalletPath1FNPC3_Text_11525e:
	ctxt "Blue: Eh<...> I don't"
	line "know if this is"
	cont "a good idea<...>"

	para "I might have to"
	line "keep this gig off"
	cont "my resume<...>"
	done

MagmaPalletPath1FNPC3_Text_1152a4:
	ctxt "Red: <...>You're"
	line "going to pay if"
	cont "you betray me too."

	para "My world has no"
	line "such thing as a"
	cont "'fire escape'<...>"

	para "<...>understood?"

	para "Do you remember"
	line "what I did to that"
	cont "Team Rocket, who"
	cont "tried to steal my"
	cont "#mon before?"
	done

MagmaPalletPath1FNPC3_Text_11537f:
	ctxt "Pink: <...>Please,"
	line "I'd like to forget"
	cont "all about that."

	para "<...>"

	para "Wait, that kid"
	line "actually followed"
	cont "us back here."
	done

MagmaPalletPath1FNPC3_Text_1153b5:
	ctxt "Red: Why do you"
	line "insist on standing"
	cont "in our way?"

	para "This creature and"
	line "its brethren are"

	para "the key to Naljo's"
	line "future safety."

	para "Varaneous itself"
	line "could bring the"

	para "seas to a boil if"
	line "it so desired."

	para "At last, the power"
	line "to protect Naljo"
	cont "is within reach<...>"

	para "While waking from"
	line "its slumber, still"

	para "weakened from its"
	line "long sleep, it'll"
	cont "be mine to catch!"

	para "This embodiment of"
	line "fire, war and"
	cont "destruction<...>"

	para "All mine!"
	done

MagmaPalletPath1FNPC3_Text_1154f4:
	ctxt "Red: Varaneous,"
	line "you've awakened!"

	para "You've been asleep"
	line "for centuries."

	para "Naljo is in dire"
	line "need of you and"

	para "the three other"
	line "Guardians."

	para "Naljo culture is"
	line "vanishing, and"

	para "Naljo descendants"
	line "have given up your"

	para "vision of old and"
	line "accept foreigners"
	cont "with open arms."
	done

MagmaPalletPath1FNPC3_Text_11560d:
	ctxt "Red: What?!"

	para "Why would you"
	line "attack me<...>?"

	para "I'm a descendant!"
	prompt

MagmaPalletPath1FNPC3_Text_11564c:
	ctxt "Pink: My leg<...>"

	para "It's broken!"
	done

MagmaPalletPath1FNPC3_Text_115691:
	ctxt "Varaneous:"
	line "-sniffs-"
	done

MagmaPalletPath1FNPC3_Text_1156a6:
	ctxt "Red: That #mon"
	line "stole the other"
	cont "orbs!"

	para "Nobu: Officer,"
	line "there they are!"
	done

MagmaPalletPath1F_11590a_Text_1156c6:
	ctxt "Officer: Looks"
	line "like we were able"

	para "to finally track"
	line "you guys down."

	para "We're locking you"
	line "all up for good."

	para "Wait, where are"
	line "the Green and"
	cont "Yellow ones?"

	para "No matter, we're"
	line "making progress<...>"

	para "Hey kid, are you"
	line "a part of this"
	cont "group, as well?"
	prompt

MagmaPalletPath1F_11590a_Text_115764:
	ctxt "Nobu: No, officer."

	para "The fanatic in red"
	line "has been plotting"
	cont "for years to wake"
	cont "up the Protectors."

	para "Officer: You mean"
	line "the ones from all"
	cont "the old stories?"

	para "Nobu: Indeed."

	para "But wait!"

	para "Why did Varaneous"
	line "attack them, and"
	cont "not you<...>?"

	para "Wait a minute<...>"

	para "You remind me of"
	line "someone I saw on"
	cont "TV once."

	para "Wait!"

	para "Lance is really"
	line "your father?"

	para "The legendary"
	line "Dragon Trainer?"

	para "Well, it all"
	line "makes sense now!"

	para "<...>"

	para "You seem confused."

	para "Let's return home"
	line "and I'll explain"
	cont "everything to you."
	prompt

MagmaPalletPath1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 5
	warp_def $d, $1a, 5, MAGMA_PALLETPATH_1F
	warp_def $1d, $b, 4, MAGMA_PALLETPATH_1F
	warp_def $33, $37, 2, MAGMA_PALLETPATH_B1F
	warp_def $5, $7, 2, MAGMA_PALLETPATH_1F
	warp_def $30, $21, 1, MAGMA_PALLETPATH_1F

	;xy triggers
	db 1
	xy_trigger 0, $11, $2f, $0, MagmaPalletPath1FTrap1, $0, $0

	;signposts
	db 0

	;people-events
	db 9
	person_event SPRITE_PALETTE_PATROLLER, 52, 51, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_PURPLE, 2, 3, MagmaPalletPath1F_Trainer_1, EVENT_MAGMA_PALLETPATH_1F_TRAINER_1
	person_event SPRITE_PALETTE_PATROLLER, 5,  21, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, MagmaPalletPath1F_Trainer_2, EVENT_MAGMA_PALLETPATH_1F_TRAINER_2
	person_event SPRITE_VARANEOUS, 10, 48, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 1, ObjectEvent, EVENT_VARANEOUS_REVIVED
	person_event SPRITE_SAGE, 20, 44, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, ObjectEvent, EVENT_MAGMA_POLICE
	person_event SPRITE_CLAIR, 20, 45, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_MAGMA_POLICE
	person_event SPRITE_PALETTE_PATROLLER, 29, 48, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 1, MagmaPalletPath1F_Trainer_3, EVENT_MAGMA_PALLETPATH_1F_TRAINER_3
	person_event SPRITE_PALETTE_PATROLLER, 14, 49, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, ObjectEvent, EVENT_VARANEOUS_REVIVED
	person_event SPRITE_PALETTE_PATROLLER, 14, 48, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, ObjectEvent, EVENT_VARANEOUS_REVIVED
	person_event SPRITE_PALETTE_PATROLLER, 14, 47, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_VARANEOUS_REVIVED
