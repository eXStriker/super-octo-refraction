IntroCave_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

IntroCaveNPC1:
	faceplayer
	opentext
	writetext IntroCaveNPC1_Text_146410
	waitbutton
	closetext
	applymovement 2, IntroCaveNPC1_Movement1
	applymovement 0, IntroCaveNPC1_Movement2
	jump IntroCave_146136

IntroCaveNPC1_Movement1:
	step_right
	turn_head_left
	step_end

IntroCaveNPC1_Movement2:
	step_down
	turn_head_right
	step_sleep_8
	step_sleep_8
	step_sleep_8
	step_down
	step_down
	step_end

IntroCave_146136:
	special ClearBGPalettes
	disappear 2
	special Special_ReloadSpritesNoPalettes
	playsound SFX_BALL_POOF
	writebyte 8
.loop
	playwaitsfx SFX_SANDSTORM
	addvar -1
	iftrue .loop
	playwaitsfx SFX_EMBER
	playwaitsfx SFX_STOMP
	;show logo and title music here
	special InitClock
	warp ACQUA_START, 28, 36
	blackoutmod ACQUA_START
	end

IntroCaveNPC1_Text_146410:
	ctxt "Hey kid, are you"
	line "lost?"

	para "Your campsite is"
	line "up north?"

	para "The path was"
	line "blocked by a"
	cont "landslide?"

	para "Well you're in"
	line "luck!"

	para "This cart will"
	line "take you right"
	cont "back there."
	done

IntroCave_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $5, 1, INTRO_OUTSIDE
	warp_def $0, $0, 1, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_FISHER, 12, 12, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, IntroCaveNPC1, -1
