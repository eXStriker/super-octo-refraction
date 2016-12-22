RijonLeagueDaichi_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RijonLeagueDaichiNPC1:
	faceplayer
	opentext
	writetext RijonLeagueDaichiNPC1_Text_2f4922
	waitbutton
	winlosstext RijonLeagueDaichiNPC1Text_2f4ab1, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	checkcode VAR_BADGES
	if_greater_than 19, .rematch
	loadtrainer DAICHI, 1
.battle
	startbattle
	reloadmapafterbattle
	playmapmusic
	setevent EVENT_0
	opentext
	writetext RijonLeagueDaichiNPC1_Text_2f4acb
	waitbutton
	closetext
	playsound SFX_JUMP_KICK
	applymovement 2, RijonLeagueDaichiNPC1_Movement1
	disappear 2
	end

.rematch
	loadtrainer DAICHI, 2
	jump .battle

RijonLeagueDaichiNPC1_Movement1:
	teleport_from
	remove_person
	step_end

RijonLeagueDaichiNPC1_Text_2f4922:
	ctxt "The ground we walk"
	line "has been shared by"

	para "many who have come"
	line "before us." 

	para "There were"
	line "challengers and"

	para "champions before"
	line "you and I, and"

	para "once we're gone"
	line "there will cont-"
	cont "inue to be more."

	para "Our existence"
	line "appears to be"

	para "insignificant in"
	line "comparison to the"

	para "seemingly timeless"
	line "floor beneath our"
	cont "feet."

	para "To be solid like"
	line "the ground is to"
	cont "be eternal."

	para "To be solid is to"
	line "change the nature"

	para "of our ephemeral"
	line "existence, and to"

	para "do that, temporary"
	line "beings like you"

	para "and I must cherish"
	line "the beauty of the"
	cont "present."

	para "Ground yourself in"
	line "this moment, do"
	cont "not falter!"

	done

RijonLeagueDaichiNPC1Text_2f4ab1:
	ctxt "To be grounded is"
	line "to be balanced,"

	para "and to be balanced"
	line "is to understand"

	para "the difference"
	line "between the reck-"
	cont "less nature of"

	para "sheer power and"
	line "the discipline"

	para "needed to resist"
	line "all opposition."
	done

RijonLeagueDaichiNPC1_Text_2f4acb:
	ctxt "You have one more"
	line "opponent before"

	para "you can contest"
	line "the title of"
	cont "Champion."

	para "Best wishes to"
	line "you."
	done

RijonLeagueDaichi_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $2, 1, INTRO_OUTSIDE
	warp_def $1, $5, 3, RIJON_LEAGUE_MURA

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_DAICHI, 2, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, RijonLeagueDaichiNPC1, -1
