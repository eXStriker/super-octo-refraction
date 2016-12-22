RijonLeagueSora_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RijonLeagueSoraNPC1:
	faceplayer
	opentext
	writetext RijonLeagueSoraNPC1_Text_2f473a
	waitbutton
	winlosstext RijonLeagueSoraNPC1Text_2f4807, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	checkcode VAR_BADGES
	if_greater_than 19, .rematch
	loadtrainer SORA, 1
.battle
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext RijonLeagueSoraNPC1_Text_2f4814
	waitbutton
	closetext
	playsound SFX_WHIRLWIND
	applymovement 2, RijonLeagueSora_2f46c1_Movement1
	disappear 2
	end

.rematch
	loadtrainer SORA, 2
	jump .battle

RijonLeagueSora_2f46c1_Movement1:
	teleport_from
	remove_person
	step_end

RijonLeagueSoraNPC1_Text_2f473a:
	ctxt "How ya doin'"
	line "Trainer?"

	para "Or should I say<...>"
	line "CHALLENGER!"

	para "There we go, that"
	line "has a better sound"
	cont "to it."

	para "I'm Sora, the"
	line "flying #mon"

	para "Trainer of the"
	line "Rijon League!"

	para "You've made it"
	line "past the first"

	para "gate, but it's only"
	line "going to get more"

	para "difficult from"
	line "here on out"
	cont "buck-o!"

	para "Try not to get"
	line "blown away by my"
	cont "sheer power!"  
	done

RijonLeagueSoraNPC1Text_2f4807:
	ctxt "I'm breathless!"
	done

RijonLeagueSoraNPC1_Text_2f4814:
	ctxt "Seriously, not"
	line "many Trainers can"

	para "overpower me, but"
	line "I'm glad, you got"
	cont "a good vibe."

	para "If you've defeated"
	line "me then you and"

	para "your #mon have"
	line "the inner strength"

	para "and power to"
	line "overcome the"

	para "challenges of the"
	line "League."

	para "Congratulations"
	line "challenger!"

	para "Move on to your"
	line "next opponent."
	done

RijonLeagueSora_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $10, $3, 1, INTRO_OUTSIDE
	warp_def $5, $10, 1, RIJON_LEAGUE_DAICHI
	warp_def $5, $11, 1, RIJON_LEAGUE_DAICHI

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SORA, 5, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, RijonLeagueSoraNPC1, -1
