SilphCo_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilphCoNPC1:
	jumptextfaceplayer SilphCoNPC1_Text_16cc29

SilphCoNPC2:
	jumptextfaceplayer SilphCoNPC2_Text_16e4e7

SilphCoNPC3:
	faceplayer
	opentext
	;playmusic MUSIC_BLUE
	checkevent EVENT_WON_AGAINST_BLUE
	iffalse SilphCo_16c9c1
	jumptext SilphCoNPC3_Text_16c9ff

SilphCoNPC4:
	checkevent EVENT_MET_BLUE
	iffalse SilphCo_16d98e
	jumptext SilphCoNPC4_Text_16dc99

SilphCoNPC6:
	jumptextfaceplayer SilphCoNPC2_Text_16e4e7

SilphCoNPC7:
	jumptextfaceplayer SilphCoNPC7_Text_16cc54

SilphCo_16c9c1:
	checkevent EVENT_APPROACHED_SILPH_WORKER
	iffalse SilphCo_16c9d3
	writetext SilphCo_16c9c1_Text_16ca34
	yesorno
	iftrue SilphCo_16c9dc
	playmusic MUSIC_VIRIDIAN_CITY
	closetext
	end

SilphCo_16d98e:
	setevent EVENT_SILPH_WORKER_NOT_UPSTAIRS
	setevent EVENT_MET_BLUE
	opentext
	writetext SilphCo_16d98e_Text_16da01
	waitbutton
	closetext
	spriteface 0, 3
	showemote 0, 0, 32
	;playmusic MUSIC_BLUE
	appear $6
	applymovement 6, SilphCo_16d98e_Movement1
	spriteface 6, 2
	opentext
	writetext SilphCo_16d98e_Text_16da84
	waitbutton
	closetext
	disappear 7
	follow 6, 0
	applymovement 6, SilphCo_16d98e_Movement2
	stopfollow
	warpfacing UP, SILPH_CO, 7, 39
	opentext
	writetext SilphCo_16d98e_Text_16c1c0
	waitbutton
	closetext
	showemote 1, 4, 32
	setevent EVENT_BLUE_NOT_ON_FIRST_FLOOR
	setevent EVENT_SEEKING_OUT_SILPH_WORKER
	spriteface PLAYER, LEFT
	spriteface 4, RIGHT
	jumptext SilphCo_16d98e_Text_16c2ca

SilphCo_16d98e_Movement1:
	step_left
	step_left
	step_down
	step_left
	step_left
	step_end

SilphCo_16d98e_Movement2:
	step_right
	step_right
	step_right
	step_up
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_up
	step_up
	step_up
	step_end

SilphCo_16c9d3:
	writetext SilphCo_16c9d3_Text_16ca56
	waitbutton
	playmusic MUSIC_VIRIDIAN_CITY
	closetext
	end

SilphCo_16c9dc:
	writetext SilphCo_16c9dc_Text_16ca88
	waitbutton
	winlosstext SilphCo_16c9dcText_16ca95, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer BLUE, 1
	startbattle
	reloadmapafterbattle
	playmapmusic
	;playmusic MUSIC_BLUE
	opentext
	setevent EVENT_WON_AGAINST_BLUE
	jumptext SilphCo_16c9dc_Text_16cab8

SilphCoNPC1_Text_16cc29:
	ctxt "Slacking off is"
	line "bad, I love work!"
	done

SilphCoNPC2_Text_16e4e7:
	ctxt "Sorry, I can't"
	line "let you up here."
	done

SilphCoNPC3_Text_16c9ff:
	ctxt "Thank you again"
	line "for that great"
	cont "battle!"

	para "I need to refine"
	line "my skills."

	para "I've always wanted"
	line "to visit Alola's"
	cont "battle tree."

	para "I'd be able to"
	line "practice against"

	para "all sorts of"
	line "trainers there!"
	done

SilphCoNPC4_Text_16dc99:
	ctxt "Welcome to Silph"
	line "Co."
	done

SilphCoNPC7_Text_16cc54:
	ctxt "You're not"
	line "allowed down"
	cont "here."
	done

SilphCo_16c9c1_Text_16ca34:
	ctxt "Oh hey, are you"
	line "up for a battle?"
	done

SilphCo_16d98e_Text_16da01:
	ctxt "Welcome to Silph"
	line "Co."

	para "I'm afraid we dont"
	line "offer tours so I'm"

	para "afraid I'm going"
	line "to have to ask you"
	cont "to<...>"

	para "???: Wait, dont"
	line "leave just yet!"
	done

SilphCo_16d98e_Text_16da84:
	ctxt "Allow me to intro-"
	line "duce myself<...>"

	para "My name's Mr. Oak."

	para "I've heard about"
	line "you before<...>"

	para "Lance is your"
	line "father right?"

	para "After I fought"
	line "him, I became"

	para "the champion for"
	line "a short time"

	para "until that Red"
	line "got in the way."

	para "While I still"
	line "battle on the"

	para "side, I've become"
	line "more interested"

	para "in developing"
	line "environmentally"
	cont "friendly projects."

	para "I studied abroad"
	line "in Kalos, and"

	para "when I returned, I"
	line "was offered this"
	cont "position."

	para "Gramps had some"
	line "pretty strong"
	cont "connections!"

	para "Come, let me show"
	line "you my latest"
	cont "project."
	done

SilphCo_16d98e_Text_16c1c0:
	ctxt "We've gone through"
	line "several proto-"

	para "types when trying"
	line "to develop the"
	cont "perfect #ball."

	para "Since I took over,"
	line "I made the company"

	para "environmentally"
	line "friendly."

	para "It delayed the"
	line "retail version of"
	cont "the Master Ball."

	para "However, I think"
	line "we're finally"
	cont "there!"

	para "We finished the"
	line "first retail"

	para "version of this"
	line "ball and<...>"
	done

SilphCo_16d98e_Text_16c2ca:
	ctxt "Wait<...> this isn't"
	line "right."

	para "It's missing a"
	line "chip<...> the guy"

	para "in charge of that"
	line "said he did this"
	cont "already!"

	para "<PLAYER>, is it?"

	para "I'm sorry, but can"
	line "you go look for"
	cont "him?"

	para "He's probably"
	line "somewhere in"
	cont "Saffron City."

	para "Thank you, and if"
	line "you find him, I"

	para "might make it"
	line "worth your while."
	done

SilphCo_16c9d3_Text_16ca56:
	ctxt "Please find that"
	line "guy, this needs"
	cont "to be finished!"
	done

SilphCo_16c9dc_Text_16ca88:
	ctxt "Let's do it!"
	done

SilphCo_16c9dcText_16ca95:
	ctxt "Wow, you're"
	line "really something"
	cont "else!"
	done

SilphCo_16c9dc_Text_16cab8:
	ctxt "You're really"
	line "strong, it's"

	para "very noble of"
	line "how you treat"
	cont "your #mon."

	para "If you want, I'll"
	line "let you have"

	para "access to the"
	line "basement."

	para "That's where we"
	line "grow the apricorns"

	para "to make Master"
	line "Balls."

	para "Only the most"
	line "skilled of ball"

	para "makers can even"
	line "have a chance at"

	para "making Master"
	line "Balls."

	para "The fruit tree is"
	line "almost extinct,"

	para "so we need to"
	line "make sure that"

	para "only trustworthy"
	line "people handle it."
	done

SilphCo_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $7, $2, 7, SAFFRON_CITY
	warp_def $7, $3, 7, SAFFRON_CITY
	warp_def $0, $d, 4, SILPH_CO
	warp_def $e, $d, 3, SILPH_CO
	warp_def $e, $b, 6, SILPH_CO
	warp_def $20, $b, 5, SILPH_CO
	warp_def $6, $f, 1, SILPH_CO_B1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 7
	person_event SPRITE_YOUNGSTER, 39, 8, $7, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SilphCoNPC1, EVENT_SILPH_WORKER_NOT_UPSTAIRS
	person_event SPRITE_OFFICER, 32, 13, $3, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, SilphCoNPC2, -1
	person_event SPRITE_BLUE, 39, 6, $7, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SilphCoNPC3, -1
	person_event SPRITE_RECEPTIONIST, 2, 3, $6, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, SilphCoNPC4, -1
	person_event SPRITE_BLUE, 3, 8, $6, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_BLUE_NOT_ON_FIRST_FLOOR
	person_event SPRITE_OFFICER, 1, 13, $2, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SilphCoNPC6, EVENT_SEEKING_OUT_SILPH_WORKER
	person_event SPRITE_OFFICER, 6, 15, $2, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SilphCoNPC7, EVENT_WON_AGAINST_BLUE
