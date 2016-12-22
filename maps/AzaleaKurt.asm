AzaleaKurt_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, KurtBasementOpen

KurtBasementOpen:
	checkevent EVENT_UNLOCK_KURT_CHAMBER
	iffalse .notOpen
	changeblock 14, 4, $1e
.notOpen
	return

AzaleaKurtSignpost1:
	farjump BallMaking
	end

AzaleaKurtNPC1:
	faceplayer
	opentext
	copybytetovar BallMakingLevel
	if_less_than 35, AzaleaKurt_325567
	checkevent EVENT_UNLOCK_KURT_CHAMBER
	iftrue AzaleaKurt_32556d
	writetext AzaleaKurtNPC1_Text_325573
	waitbutton
	follow 2, 0
	closetext
	checkcode VAR_FACING
	if_equal 1, .below
	applymovement 2, AzaleaKurtNPC1_Movement1

.donewalking
	stopfollow
	playsound SFX_ENTER_DOOR
	changeblock 14, 4, $1e
	setevent EVENT_UNLOCK_KURT_CHAMBER
	opentext
	writetext AzaleaKurtNPC1_Text_3255c5
	endtext

.below
	applymovement 2, AzaleaKurtNPC1_MovementBelow
	jump .donewalking

AzaleaKurtNPC1_MovementBelow:
	slow_step_right
	slow_step_down
	slow_step_right
	slow_step_right
	slow_step_right
	slow_step_right
	turn_head_left
	step_end

AzaleaKurtNPC1_Movement1:
	slow_step_down
	slow_step_right
	slow_step_right
	slow_step_right
	slow_step_right
	slow_step_right
	turn_head_left
	step_end

AzaleaKurtNPC2:
	jumptextfaceplayer AzaleaKurtNPC2_Text_324b14

AzaleaKurt_325567:
	writetext AzaleaKurt_325567_Text_325698
	endtext

AzaleaKurt_32556d:
	writetext AzaleaKurt_32556d_Text_325707
	endtext

AzaleaKurtNPC1_Text_325573:
	ctxt "Wow, you're able"
	line "to make Friend"
	cont "Balls?"

	para "I shouldn't show"
	line "you this<...> but"
	cont "follow me."
	done

AzaleaKurtNPC1_Text_3255c5:
	ctxt "In the basement"
	line "there's tools that"

	para "will allow you to"
	line "make some of the"
	cont "rarest balls."

	para "They're very hard"
	line "to make, so you"

	para "won't always"
	line "succeed."

	para "But the more"
	line "levels you gain,"

	para "the easier it gets"
	line "to make them."
	done

AzaleaKurtNPC2_Text_324b14:
	ctxt "Hello, I'm Kurt."

	para "To create a ball,"
	line "just walk over"

	para "to the crafting"
	line "table in the right"

	para "side of the room"
	line "and interact with"
	cont "the tools."
	done

AzaleaKurt_325567_Text_325698:
	ctxt "Grandpa used to"
	line "make #balls for"

	para "people until his"
	line "he got arthritis."

	para "Now he teaches"
	line "people how to"
	cont "make them."
	done

AzaleaKurt_32556d_Text_325707:
	ctxt "Maybe you can"
	line "continue my"
	cont "Grandpa's legacy."

	para "I believe in you!"
	done

AzaleaKurt_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $3, 3, AZALEA_TOWN
	warp_def $7, $4, 3, AZALEA_TOWN
	warp_def $5, $f, 1, AZALEA_KURT_BASEMENT

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 2, 14, SIGNPOST_READ, AzaleaKurtSignpost1

	;people-events
	db 2
	person_event SPRITE_LASS, 4, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaKurtNPC1, -1
	person_event SPRITE_KURT, 2, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaKurtNPC2, -1
