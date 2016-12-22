SaxifrageGym_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, SetBlocksSaxifrageGym

SetBlocksSaxifrageGym:
	checkevent EVENT_SAXIFRAGE_LIGHT_OFF_1
	sif true
		return
	changeblock 6, 6, $d
	changeblock 8, 6, $1b
	changeblock 6, 8, $e

	checkevent EVENT_SAXIFRAGE_LIGHT_OFF_2
	sif true
		return
	changeblock 4, 4, $1d
	changeblock 4, 6, $e
	changeblock 6, 4, $1c

	checkevent EVENT_SAXIFRAGE_LIGHT_OFF_3
	sif true
		return
	changeblock 2, 0, $5
	changeblock 4, 0, $4
	changeblock 6, 0, $6
	changeblock 2, 2, $10
	changeblock 4, 2, $11
	changeblock 6, 2, $12
	return

SaxifrageGym_Trainer_1:
	trainer EVENT_SAXIFRAGE_GYM_TRAINER_1, GUITARIST, 1, SaxifrageGym_Trainer_1_Text_2faf99, SaxifrageGym_Trainer_1_Text_2fafb3, $0000, .Script

.Script:
	checkevent EVENT_SAXIFRAGE_LIGHT_OFF_3
	iffalse SaxifrageGym_2faf92
	opentext
	writetext SaxifrageGym_Trainer_1_Script_Text_2fafbb
	waitbutton
	setevent EVENT_SAXIFRAGE_GYM_TRAINER_1
	playsound SFX_ENTER_DOOR
	changeblock 2, 0, $5
	changeblock 4, 0, $4
	changeblock 6, 0, $6
	changeblock 2, 2, $10
	changeblock 4, 2, $11
	changeblock 6, 2, $12
	clearevent EVENT_SAXIFRAGE_LIGHT_OFF_3
	reloadmappart
	appear $2
	closetext
	end

SaxifrageGym_Trainer_2:
	trainer EVENT_SAXIFRAGE_GYM_TRAINER_2, GUITARIST, 2, SaxifrageGym_Trainer_2_Text_2fae51, SaxifrageGym_Trainer_2_Text_2fae8c, $0000, .Script

.Script:
	checkevent EVENT_SAXIFRAGE_LIGHT_OFF_2
	sif false
		jumptext SaxifrageGym_2fae4a_Text_2faec1

	opentext
	writetext SaxifrageGym_Trainer_2_Script_Text_2faea1
	waitbutton
	setevent EVENT_SAXIFRAGE_GYM_TRAINER_2
	playsound SFX_ENTER_DOOR
	changeblock 4, 4, $1d
	changeblock 4, 6, $e
	changeblock 6, 4, $1c
	reloadmappart
	clearevent EVENT_SAXIFRAGE_LIGHT_OFF_2
	appear $3
	closetext
	end

SaxifrageGym_Trainer_3:
	trainer EVENT_SAXIFRAGE_GYM_TRAINER_3, GUITARIST, 3, SaxifrageGym_Trainer_3_Text_2fad9e, SaxifrageGym_Trainer_3_Text_2fadb8, $0000, .Script

.Script:
	checkevent EVENT_SAXIFRAGE_LIGHT_OFF_1
	sif false
		jumptext SaxifrageGym_2fad97_Text_2fadee

	opentext
	writetext SaxifrageGym_Trainer_3_Script_Text_2fadc5
	waitbutton
	setevent EVENT_SAXIFRAGE_GYM_TRAINER_3
	playsound SFX_ENTER_DOOR
	changeblock 6, 6, $d
	changeblock 8, 6, $1b
	changeblock 6, 8, $e
	reloadmappart
	clearevent EVENT_SAXIFRAGE_LIGHT_OFF_1
	appear $4
	closetext
	end

SaxifrageGymNPC2:
	checkflag ENGINE_RAUCOUSBADGE
	iftrue .beaten
	jumptextfaceplayer SaxifrageGymNPC2_Text_2fb5bf
	
.beaten
	jumptextfaceplayer SaxifrageGymAdvisorWBadge

SaxifrageGymNPC1:
	faceplayer
	opentext
	checkflag ENGINE_RAUCOUSBADGE
	sif true
		jumptext SaxifrageGymNPC1_Text_2f9617

	writetext SaxifrageGym_2f95e5_Text_2f9676
	waitbutton
	winlosstext SaxifrageGym_2f95e5Text_2f9777, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadtrainer CADENCE, CADENCE_GYM
	startbattle
	reloadmapafterbattle
	playmapmusic
	opentext
	writetext SaxifrageGym_2f95e5_Text_2f97c6
	playwaitsfx SFX_TCG2_DIDDLY_5
	playmusic MUSIC_GYM
	writetext SaxifrageGym_2f95e5_Text_2f97e1
	waitbutton
	givetm 79 + RECEIVED_TM
	setflag ENGINE_RAUCOUSBADGE
	jumptext SaxifrageGym_2f95e5_Text_2f9810

SaxifrageGym_2faf92:
	jumptext SaxifrageGym_2faf92_Text_2fafe2

SaxifrageGymNPC1_Text_2f9617:
	ctxt "I'm going to"
	line "start writing"
	cont "some new songs!"

	para "My #mon can"
	line "help me make the"
	para "perfect rock out"
	line "song!"
	done

SaxifrageGym_Trainer_1_Text_2faf99:
	ctxt "This is the end"
	line "for you!"
	done

SaxifrageGym_Trainer_1_Text_2fafb3:
	ctxt "What?!"
	done

SaxifrageGym_Trainer_1_Script_Text_2fafbb:
	ctxt "I didn't stop you<...>"

	para "But I'm sure our"
	line "leader will!"
	done

SaxifrageGym_Trainer_2_Text_2fae51:
	ctxt "I miss our daily"
	line "jams from back"
	cont "in the old days."

	para "I'll take my aggre-"
	line "ssion out on you!"
	done

SaxifrageGym_Trainer_2_Text_2fae8c:
	ctxt "Not angry enough!"
	done

SaxifrageGym_Trainer_2_Script_Text_2faea1:
	ctxt "I suppose you can"
	line "fight the next"
	cont "guy coming up."
	done

SaxifrageGym_Trainer_3_Text_2fad9e:
	ctxt "Let's turn the"
	line "volume up!"
	done

SaxifrageGym_Trainer_3_Text_2fadb8:
	ctxt "Zapped out!"
	done

SaxifrageGym_Trainer_3_Script_Text_2fadc5:
	ctxt "Let me reveal the"
	line "next Trainer for"
	cont "you."
	done

SaxifrageGymNPC2_Text_2fb5bf:
	ctxt "Hi again!"

	para "This is Cadence."

	para "She started a rock"
	line "band way back."

	para "After their many"
	line "failures, they"
	para "decided to start"
	line "up their own Gym"
	para "specializing in"
	line "Sound #mon."

	para "But there aren't"
	line "enough of those,"

	para "so they threw some"
	line "electric ones into"
	cont "the mix too."
	done

SaxifrageGym_2f95e5_Text_2f9676:
	ctxt "What's up?!"

	para "I'm Cadence."

	para "I use the power of"
	line "sound to enhance"
	para "the capabilities"
	line "of my #mon!"

	para "The power of"
	line "sound and music"
	para "can change how"
	line "one performs!"

	para "Look at you, you"
	line "probably don't"
	para "even know the"
	line "difference between"
	para "a sine wave and"
	line "a square wave!"

	para "No matter. I'm"
	line "taking you down!"
	done

SaxifrageGym_2f95e5Text_2f9777:
	ctxt "Well, it appears"
	line "that my gig is up"
	cont "and I'm rocked out."

	para "Seems you've earned"
	line "yourself the proud"
	cont "Raucous Badge!"
	done

SaxifrageGym_2f95e5_Text_2f97c6:
	ctxt "<PLAYER> received"
	line "Raucous Badge."
	done

SaxifrageGym_2f95e5_Text_2f97e1:
	ctxt "Here's a TM that"
	line "gives you the"
	cont "power of sound!"
	done

SaxifrageGym_2f95e5_Text_2f9810:
	ctxt "TM79 is"
	line "Hyper Voice!"

	para "It's a strong"
	line "sound attack"

	para "that'll make"
	line "your opponent's"
	cont "ears pound!"
	done

SaxifrageGym_2faf92_Text_2fafe2:
	ctxt "So, uh<...>"

	para "Do you have a"
	line "band?"

	para "Can I join?"
	done

SaxifrageGym_2fae4a_Text_2faec1:
	ctxt "Cadence was once"
	line "arrested for dis-"
	cont "turbing the peace."

	para "She was then given"
	line "this gym because"
	para "she was the inmate"
	line "who treated her"
	cont "#mon the best."
	done

SaxifrageGym_2fad97_Text_2fadee:
	ctxt "Good luck buddy!"

	para "You're gonna need"
	line "it, hahaha!"
	done
	
SaxifrageGymAdvisorWBadge:
	ctxt "That battle was"
	line "rambunctious!"
	
	para "I had to put in"
	line "NRR 33 Earplugs!"
	done

SaxifrageGym_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $d, $5, 2, SAXIFRAGE_ISLAND
	warp_def $d, $4, 2, SAXIFRAGE_ISLAND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_PRYCE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SaxifrageGymNPC1, EVENT_SAXIFRAGE_LIGHT_OFF_3
	person_event SPRITE_ROCKER, 5, 5, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 0, SaxifrageGym_Trainer_1, EVENT_SAXIFRAGE_LIGHT_OFF_2
	person_event SPRITE_ROCKER, 7, 7, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 0, SaxifrageGym_Trainer_2, EVENT_SAXIFRAGE_LIGHT_OFF_1
	person_event SPRITE_ROCKER, 9, 3, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 0, SaxifrageGym_Trainer_3, -1
	person_event SPRITE_GYM_GUY, 10, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaxifrageGymNPC2, -1
