SaffronGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronGymSignpost:
	jumptext SaffronGymSignpost_Text

SaffronGym_Trainer_1:
	trainer EVENT_SAFFRON_GYM_TRAINER_1, PSYCHIC_T, 6, SaffronGym_Trainer_1_Text_BeforeBattle, SaffronGym_Trainer_1_Text_BattleWon, $0000, .Script

.Script
	end_if_just_battled
	jumptextfaceplayer SaffronGym_Trainer_1_Text_AfterBattle

SaffronGym_Trainer_2:
	trainer EVENT_SAFFRON_GYM_TRAINER_2, MEDIUM, 6, SaffronGym_Trainer_2_Text_BeforeBattle, SaffronGym_Trainer_2_Text_BattleWon, $0000, .Script

.Script
	end_if_just_battled
	jumptextfaceplayer SaffronGym_Trainer_2_Text_AfterBattle

SaffronGym_Trainer_3:
	trainer EVENT_SAFFRON_GYM_TRAINER_3, MEDIUM, 7, SaffronGym_Trainer_3_Text_BeforeBattle, SaffronGym_Trainer_3_Text_BattleWon, $0000, .Script

.Script
	end_if_just_battled
	jumptextfaceplayer SaffronGym_Trainer_3_Text_AfterBattle

SaffronGymGuide:
	jumptextfaceplayer SaffronGymGuide_Text

SaffronGymSabrina:
	opentext
	checkflag ENGINE_MARSHBADGE
	sif true
		jumptextfaceplayer SaffronGymSabrina_Text_AfterGettingBadge
	faceplayer
	writetext SaffronGymSabrina_Text_BeforeBattle
	winlosstext SaffronGymSabrina_Text_BattleWon, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer SABRINA, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	faceplayer
	writetext SaffronGymSabrina_Text_ReceivedBadge
	playwaitsfx SFX_TCG2_DIDDLY_5
	writetext SaffronGymSabrina_Text_BeforeTM
	waitbutton
	givetm 69 + RECEIVED_TM
	setflag ENGINE_MARSHBADGE
	jumptext SaffronGymSabrina_Text_AfterTM

SaffronGymSignpost_Text:
	ctxt "Saffron Gym"

	para "Leader: Sabrina"
	done

SaffronGym_Trainer_1_Text_BeforeBattle:
	ctxt "What is the power"
	line "of your soul?"
	done

SaffronGym_Trainer_1_Text_BattleWon:
	ctxt "Such a strong"
	line "soul!"
	done

SaffronGym_Trainer_1_Text_AfterBattle:
	ctxt "Your soul grows"
	line "stronger."
	done

SaffronGym_Trainer_2_Text_BeforeBattle:
	ctxt "Evil spirits?"

	para "Begone!"
	done

SaffronGym_Trainer_2_Text_BattleWon:
	ctxt "Ayayayayya"
	done

SaffronGym_Trainer_2_Text_AfterBattle:
	ctxt "Don't bother me"
	line "any more, evil"
	cont "spirit!"
	done

SaffronGym_Trainer_3_Text_BeforeBattle:
	ctxt "The power of all"
	line "those you defeated"
	cont "comes from me!"
	done

SaffronGym_Trainer_3_Text_BattleWon:
	ctxt "Far too strong!"
	done

SaffronGym_Trainer_3_Text_AfterBattle:
	ctxt "Tell me your"
	line "power source!"
	done

SaffronGymSabrina_Text_AfterGettingBadge:
	ctxt "Your love for"
	line "your #mon"

	para "overwhelmed my"
	line "psychic power."

	para "The power of love"
	line "may also be a"

	para "kind of psychic"
	line "power."
	done

SaffronGymGuide_Text:
	ctxt "Hey!"

	para "Sabrina made"
	line "changes to her"

	para "warp system"
	line "recently, so try"
	cont "not to get lost!"
	done

SaffronGymSabrina_Text_BeforeBattle:
	ctxt "I knew you were"
	line "coming."

	para "I had a vision of"
	line "your arrival"

	para "several years"
	line "ago."

	para "It's my duty as a"
	line "Gym Leader to"

	para "provide badges"
	line "to anyone who"

	para "has proven him"
	line "or herself"
	cont "worthy."

	para "Since you want to"
	line "battle, I will"

	para "show you the"
	line "extent of my"
	cont "psychic abilities."
	done

SaffronGymSabrina_Text_BattleWon:
	ctxt "I was unable to"
	line "foresee this"
	cont "amount of power."

	para "You earned the"
	line "Marsh Badge."
	done

SaffronGymSabrina_Text_ReceivedBadge:
	ctxt "<PLAYER> received"
	line "Marsh Badge."
	done

SaffronGymSabrina_Text_BeforeTM:
	ctxt "Please take this"
	line "gift as well."
	done

SaffronGymSabrina_Text_AfterTM:
	ctxt "This TM is"
	line "Safeguard."

	para "This move prevents"
	line "your party from"

	para "being affected by"
	line "common status"

	para "conditions for"
	line "five turns."
	done

SaffronGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 35
	warp_def $f, $b, 10, SAFFRON_GYM
	warp_def $3, $1, 16, SAFFRON_GYM
	warp_def $3, $5, 22, SAFFRON_GYM
	warp_def $3, $9, 11, SAFFRON_GYM
	warp_def $3, $b, 17, SAFFRON_GYM
	warp_def $3, $f, 23, SAFFRON_GYM
	warp_def $3, $13, 12, SAFFRON_GYM
	warp_def $5, $1, 18, SAFFRON_GYM
	warp_def $5, $5, 24, SAFFRON_GYM
	warp_def $5, $9, 13, SAFFRON_GYM
	warp_def $5, $b, 19, SAFFRON_GYM
	warp_def $5, $f, 25, SAFFRON_GYM
	warp_def $5, $13, 14, SAFFRON_GYM
	warp_def $9, $1, 20, SAFFRON_GYM
	warp_def $9, $5, 26, SAFFRON_GYM
	warp_def $9, $f, 15, SAFFRON_GYM
	warp_def $9, $13, 21, SAFFRON_GYM
	warp_def $b, $1, 27, SAFFRON_GYM
	warp_def $b, $5, 28, SAFFRON_GYM
	warp_def $b, $f, 6, SAFFRON_GYM
	warp_def $b, $13, 5, SAFFRON_GYM
	warp_def $f, $1, 31, SAFFRON_GYM
	warp_def $f, $5, 4, SAFFRON_GYM
	warp_def $f, $f, 3, SAFFRON_GYM
	warp_def $f, $13, 30, SAFFRON_GYM
	warp_def $11, $1, 2, SAFFRON_GYM
	warp_def $11, $5, 1, SAFFRON_GYM
	warp_def $11, $f, 29, SAFFRON_GYM
	warp_def $11, $13, 7, SAFFRON_GYM
	warp_def $9, $b, 1, SAFFRON_GYM
	warp_def $11, $8, 2, SAFFRON_CITY
	warp_def $11, $9, 2, SAFFRON_CITY
	warp_def $0, $2, 33, SAFFRON_GYM
	warp_def $0, $1, 1, SAFFRON_GYM
	warp_def $0, $0, 1, SAFFRON_GYM

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 15, 8, SIGNPOST_READ, SaffronGymSignpost

	;people-events
	db 5
	person_event SPRITE_YOUNGSTER, 4, 10, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 2, SaffronGym_Trainer_1, -1
	person_event SPRITE_GRANNY, 10, 3, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 2, SaffronGym_Trainer_2, -1
	person_event SPRITE_GRANNY, 10, 17, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 2, SaffronGym_Trainer_3, -1
	person_event SPRITE_SABRINA, 8, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronGymSabrina, -1
	person_event SPRITE_GYM_GUY, 14, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronGymGuide, -1
