OxalisGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

OxalisGymLeader:
	faceplayer
	opentext
	checkflag ENGINE_PYREBADGE
	sif true
		jumptext OxalisGymLeader_Text_AfterBattle
	writetext OxalisGymLeader_Text_BeforeBattle
	waitbutton
	closetext

	;Start the battle
	winlosstext OxalisGymLeader_Text_BattleWon, 0
	loadtrainer JOSIAH, JOSIAH_GYM
	startbattle
	reloadmapafterbattle
	opentext
	writetext OxalisGymLeader_Text_GiveBadge
	playwaitsfx SFX_TCG2_DIDDLY_5

	;Ended battle
	setflag ENGINE_PYREBADGE
	setevent EVENT_ROUTE_73_GUARD
	setevent EVENT_LINK_OPEN
	writetext OxalisGymLeader_Text_AfterBadge
	buttonsound
	givetm 82 + RECEIVED_TM
	jumptext OxalisGymLeader_Text_GiveTM

OxalisGym_Trainer_1:
	trainer EVENT_OXALIS_GYM_TRAINER_1, COOLTRAINERM, 2, OxalisGym_Trainer_1_Text_BeforeBattle, OxalisGym_Trainer_1_Text_BattleWon, $0000, .Script
.Script
	end_if_just_battled
	jumptextfaceplayer OxalisGym_Trainer_1_Text_AfterBattle

OxalisGym_Trainer_2:
	trainer EVENT_OXALIS_GYM_TRAINER_2, COOLTRAINERM, 1, OxalisGym_Trainer_2_Text_BeforeBattle, OxalisGym_Trainer_2_Text_BattleWon, $0000, .Script
.Script
	end_if_just_battled
	jumptextfaceplayer OxalisGym_Trainer_2_Text_AfterBattle

OxalisGymGuide:
	checkflag ENGINE_PYREBADGE
	sif true
		jumptextfaceplayer OxalisGymGuide_Text_AfterBadge
	jumptextfaceplayer OxalisGymGuide_Text_BeforeBadge

OxalisGymLeader_Text_BeforeBattle:
	ctxt "Sup."

	para "It's Josiah."

	para "Yo dawg, I'm not"
	line "going to make it"
	cont "easy for you."

	para "Let's make this"
	line "battle erupt!"
	done

OxalisGymLeader_Text_BattleWon:
	ctxt "<...>Whoa!"

	para "You are the bomb!"

	para "You have earned"
	line "my badge."
	done

OxalisGymLeader_Text_GiveBadge:
	ctxt "<PLAYER> received"
	line "Pyre Badge!"
	done

OxalisGymLeader_Text_AfterBadge:
	ctxt "Pyre Badge"
	line "increases da"
	cont "attack power."

	para "It also lets ya"
	line "use Flash out of"
	cont "battle!"

	para "Now that's thug!"

	para "Also take this."
	done

OxalisGymLeader_Text_GiveTM:
	ctxt "Yo so that's called"
	line "a TM, and it means"
	cont "somethin<...> uhm,"

	para "Technical Machine?"
	line "Yeh, that's it."

	para "Yer #mon can"
	line "learn moves from"

	para "it, and it has"
	line "unlimited uses!"

	para "This TM is for"
	line "Will-O-Wisp."

	para "It inflicts a"
	line "burn on the foe!"
	done

OxalisGym_Trainer_1_Text_BeforeBattle:
	ctxt "What's the matter?"

	para "Can't handle being"
	line "around steaming"
	cont "700 C lava?"
	done

OxalisGym_Trainer_1_Text_BattleWon:
	ctxt "Gaaah!"
	done

OxalisGym_Trainer_1_Text_AfterBattle:
	ctxt "Seems you can"
	line "handle the heat."

	para "But<...> can you"
	line "handle Josiah?"
	done

OxalisGym_Trainer_2_Text_BeforeBattle:
	ctxt "<...>a kid?"

	para "Is this a joke?"

	para "Well, this should"
	line "be a blast<...>"

	para "For me!"
	done

OxalisGym_Trainer_2_Text_BattleWon:
	ctxt "Improbable!"
	done

OxalisGym_Trainer_2_Text_AfterBattle:
	ctxt "My shame can only"
	line "be rinsed with a"
	cont "proper lava bath."
	done

OxalisGymGuide_Text_BeforeBadge:
	ctxt "Hello there!"
	line "I've been waiting"
	cont "for your arrival."

	para "Prof. Ilk has"
	line "asked of me"
	cont "to assist you."

	para "I'll give you"
	line "all the inside"
	cont "info you need!"

	para "Alright, Josiah"
	line "has Fire #mon,"

	para "but you can tell"
	line "by the scenery,"
	cont "right? Blazing!"

	para "Water would be"
	line "a good choice of"
	cont "#mon to use."

	para "Rock is another"
	line "excellent choice!"

	para "If you're getting"
	line "burned too often,"

	para "try buying a Burn"
	line "Heal at the Mart."
	done

OxalisGymLeader_Text_AfterBattle:
	ctxt "So ya, the Rijon"
	line "League requires"
	cont "eight badges, so<...>"

	para "Go for it bro,"
	line "get them all."
	done

OxalisGymGuide_Text_AfterBadge:
	ctxt "Good job!"

	para "You couldn't have"
	line "done it without my"
	cont "advice, though!"
	done

OxalisGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $13, $f, 5, OXALIS_CITY
	warp_def $15, $2, 5, OXALIS_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_FALKNER, 4, 26, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED + 8, 0, 0, OxalisGymLeader, -1
	person_event SPRITE_YOUNGSTER, 10, 18, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 2, 3, OxalisGym_Trainer_1, -1
	person_event SPRITE_YOUNGSTER, 10, 4, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, 2, 3, OxalisGym_Trainer_2, -1
	person_event SPRITE_GYM_GUY, 18, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, OxalisGymGuide, -1
