IntroOutside_MapScriptHeader;trigger count
	db 4
	maptrigger .Trigger0
	maptrigger .Trigger1
	maptrigger .Trigger2
	maptrigger .Trigger3
 ;callback count
	db 2
	dbw MAPCALLBACK_TILES, .LandslideTiles
	dbw MAPCALLBACK_NEWMAP, .Callback

.LandslideTiles:
	checkevent EVENT_INTRO_LANDSLIDE
	iffalse .end
	changeblock 08, 16, $3B
	changeblock 10, 16, $8E
	changeblock 12, 16, $28
.end
	return

.Callback:
	;playmusic 2
	checkevent EVENT_INITIALIZED_EVENTS
	sif true
		return
	jumpstd initializeevents

.Trigger0
	priorityjump .PlayMusic
.Trigger1
.Trigger2
.Trigger3
	end

.PlayMusic
	playmusic MUSIC_NATIONAL_PARK
	dotrigger 1
	end

IntroMomLeavingDialogue:
	spriteface PLAYER, UP
	opentext
	writetext MomDialogueLeaving
	waitbutton
	closetext
	checkcode VAR_XCOORD
	sif =, 4, then
		applymovement $2, IntroMomWalksToPlayerFar
	selse
		applymovement $2, IntroMomWalksToPlayer
	sendif
	opentext
	writetext MomDialogueLeaving2
	waitbutton
	closetext
	applymovement $2, IntroMomWalksBack
	dotrigger 2
	end

StartingGameEarthquake:
	playmusic MUSIC_NONE
	playsound SFX_EMBER
	earthquake 50
	changeblock 08, 16, $3B
	changeblock 10, 16, $8E
	changeblock 12, 16, $28
	spriteface $0, UP
	showemote EMOTE_SHOCK, 0, 16
	waitsfx
	dotrigger 3
	setevent EVENT_INTRO_LANDSLIDE
	end

MomCampsiteTextScript:
	jumptextfaceplayer MomDialogueCampsite

MomCampsiteFireScript:
	jumptext CampsiteFireText

CampsiteFireText:
	ctxt "Looks hot!"

	para "Better not touch<...>"
	done

MomDialogueCampsite:
	ctxt "It's so beautiful"
	line "here, isn't it?"

	para "I've missed just"
	line "escaping into the"
	cont "wilderness<...>"

	para "I know you miss"
	line "your father,"
	cont "<PLAYER><...>"

	para "But he's out there,"
	line "making a bigger"
	cont "name for himself."

	para "I know you want"
	line "to follow in his"
	cont "footsteps<...>"

	para "But promise me"
	line "that no matter how"

	para "big you get, that"
	line "you will never"
	cont "forget about me."

	para "Thanks for coming"
	line "with me <PLAYER>."

	done

MomDialogueLeaving:
	ctxt "<PLAYER>!"
	done

MomDialogueLeaving2:
	ctxt "<...>Oh, heading"
	line "out for a walk?"

	para "Could you try to"
	line "get some firewood"
	cont "for us?"

	para "The fire will need"
	line "some soon to keep"
	cont "us nice and warm"
	cont "tonight!"

	para "<...>And <PLAYER><...>"

	para "<...>"

	para "<...>Just, be safe!"
	done

IntroMomWalksToPlayerFar:
	step_down
	step_down
	step_left
	step_left
	step_left
	step_left
	step_left
	turn_head_down
	step_end

IntroMomWalksToPlayer:
	step_down
	step_down
	step_left
	step_left
	step_left
	step_left
	turn_head_down
	step_end

IntroMomWalksBack:
	step_right
	step_right
	step_right
	step_right
	step_right
	step_up
	step_up
	turn_head_down
	step_end

IntroOutside_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 31, 14, 1, INTRO_CAVE
	warp_def 17, 6, 5, CAPER_CITY

.CoordEvents: db 4
	xy_trigger 1, 9, 4, 0, IntroMomLeavingDialogue, 0, 0
	xy_trigger 1, 9, 5, 0, IntroMomLeavingDialogue, 0, 0
	xy_trigger 2, 22, 10, 0, StartingGameEarthquake, 0, 0
	xy_trigger 2, 22, 11, 0, StartingGameEarthquake, 0, 0

.BGEvents: db 0

.ObjectEvents: db 2
	person_event SPRITE_MOM, 6, 9, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 3, -1, -1, PAL_OW_PLAYER + 8, 0, 0, MomCampsiteTextScript, -1
	person_event SPRITE_FIRE, 6, 11, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MomCampsiteFireScript, -1

