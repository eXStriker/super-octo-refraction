Route57Gym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route57GymSignpost1:
	jumptext Route57GymSignpost1_Text_323f7f

Route57GymSignpost2:
	jumptext Route57GymSignpost1_Text_323f7f

Route57GymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_WHITEBADGE
	iffalse Route57Gym_323dfe
	jumptext Route57GymNPC1_Text_323f97

Route57Gym_323dfe:
	writetext Route57Gym_323dfe_Text_323fa9
	waitbutton
	winlosstext Route57Gym_323dfeText_323fca, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer JOE, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext Route57Gym_323dfe_Text_323e49
	playwaitsfx SFX_TCG2_DIDDLY_5
	setflag ENGINE_WHITEBADGE
	playmusic MUSIC_GYM
	writetext Route57Gym_323dfe_Text_323fec
	waitbutton
	givetm 15 + RECEIVED_TM
	jumptext Route57Gym_323dfe_Text_323e2d

Route57GymSignpost1_Text_323f7f:
	ctxt "Normal Gym"

	para "Leader: Joe"
	done

Route57GymNPC1_Text_323f97:
	ctxt "I'm being normal!"
	done

Route57Gym_323dfe_Text_323fa9:
	ctxt "Hello there, my"
	line "name is Joe, the"

	para "Normal Gym leader"
	line "of Rijon!"

	para "I am so normal,"
	line "that all of the"

	para "abnormal people"
	line "left my Gym."

	para "This place is now"
	line "all mine and very"
	cont "normal."

	para "Well, are you"
	line "ready for a"
	cont "Normal Battle?"
	done

Route57Gym_323dfeText_323fca:
	ctxt "This is abnormal!"

	para "You are killing my"
	line "normal vibes!"

	para "Please, take this"
	line "badge and leave!"
	done

Route57Gym_323dfe_Text_323e49:
	ctxt "<PLAYER> received"
	line "White Badge."
	done

Route57Gym_323dfe_Text_323fec:
	ctxt "Take some of the"
	line "normal home with"
	cont "you!"
	done

Route57Gym_323dfe_Text_323e2d:
	ctxt "TM15 is Hyper"
	line "Beam!"

	para "A strong, but"
	line "normal attack!"
	done

Route57Gym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $13, $a, 5, ROUTE_57
	warp_def $13, $b, 5, ROUTE_57

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 17, 8, SIGNPOST_READ, Route57GymSignpost1
	signpost 17, 13, SIGNPOST_READ, Route57GymSignpost2

	;people-events
	db 1
	person_event SPRITE_BLAINE, 16, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route57GymNPC1, -1
