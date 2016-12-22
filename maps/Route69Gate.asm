Route69Gate_MapScriptHeader;trigger count
	db 2

	maptrigger .Trigger0
	maptrigger .Trigger1

 ;callback count
	db 0

.Trigger0:
	priorityjump Route69Gate_181651
	end

.Trigger1:
	end

Route69GateHiddenItem_1:
	dw EVENT_ROUTE_69_GATE_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route69GateNPC1:
	checkevent EVENT_RIVAL_ROUTE_69
	iftrue Route69Gate_1816fa
	jumptextfaceplayer Route69GateNPC1_Text_1819ca

Route69Gate_181651:
	playmusic MUSIC_MYSTICALMAN_ENCOUNTER
	spriteface 2, 0
	showemote 0, 2, 15
	applymovement 2, Route69Gate_181651_Movement1
	opentext
	writetext Route69Gate_181651_Text_1832ff
	buttonsound
	writetext Route69GateGotMapText
	playwaitsfx SFX_DEX_FANFARE_50_79
	waitbutton
	setflag ENGINE_HAS_MAP
	; setflag ENGINE_MAP_CARD
	dotrigger 1
	setevent EVENT_TALKED_TO_BOB
	writetext Route69Gate_181651_Text_1817d2
	waitbutton
	closetext
	applymovement 2, Route69Gate_181651_Movement2
	special RestartMapMusic
	end

Route69Gate_181651_Movement1:
	step_down
	step_down
	turn_head_left
	step_end

Route69Gate_181651_Movement2:
	step_up
	step_up
	turn_head_down
	step_end

Route69Gate_1816fa:
	jumptextfaceplayer Route69Gate_1816fa_Text_182840

Route69GateNPC1_Text_1819ca:
	ctxt "Be careful."

	para "At times, Naljo"
	line "is unpredictable."
	done

Route69Gate_181651_Text_1832ff:
	ctxt "Whoa there!"

	para "I can't let you"
	line "through, sorry."

	para "There's a hold"
	line "up at the house"
	para "up ahead by some"
	line "young punk."

	para "I've already"
	line "called someone"
	para "else to send"
	line "backup."

	para "<...>"

	para "<...>wait. Prof Ilk"
	line "sent you to help?"

	para "Well, I hope he"
	line "knows what he's"
	cont "doing<...>"

	para "<...>look, I have to"
	line "stand here 24/7"
	para "ever since crime"
	line "went up."

	para "It can be a real"
	line "drag<...>"

	para "Oh, sorry about"
	line "complaining there."
	
	para "Anyway, I see you"
	line "don't have a Map."
	
	para "<...>so just take one,"
	line "I don't feel like"
	para "filing a missing"
	line "persons report"
	cont "today<...>"
	done

Route69Gate_181651_Text_1817d2:
	ctxt "The house just up"
	line "ahead is where the"
	cont "commotion is."

	para "I bet you will be"
	line "able to handle it!"
	done

Route69Gate_1816fa_Text_182840:
	ctxt "Keep on fighting"
	line "'till the end!"
	done

Route69GateGotMapText:
	ctxt "<PLAYER> was"
	line "handed a Map!"
	done

Route69Gate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $5, $0, 3, ROUTE_70
	warp_def $4, $9, 1, ROUTE_69
	warp_def $5, $9, 2, ROUTE_69
	warp_def $4, $0, 1, ROUTE_70

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 1, 7, SIGNPOST_ITEM, Route69GateHiddenItem_1

	;people-events
	db 1
	person_event SPRITE_OFFICER, 3, 1, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route69GateNPC1, -1