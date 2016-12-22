AcquaExitChamber_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, SetCaperCityAsPokecenter

SetCaperCityAsPokecenter:
	blackoutmod CAPER_CITY
	return

AcquaExitChamberNPC1:
	faceplayer
	opentext
	checkevent EVENT_ACQUA_BERRY_MAN
	iftrue AcquaExitChamber_174de3
	writetext AcquaExitChamberNPC1_Text_174df2
	yesorno
	iffalse AcquaExitChamber_174de9
	writetext AcquaExitChamberNPC1_Text_174e72
	buttonsound
	verbosegiveitem ORAN_BERRY, 1
	iffalse AcquaExitChamber_174ded
	setevent EVENT_ACQUA_BERRY_MAN
	writetext AcquaExitChamberNPC1_Text_174ebf
	endtext

AcquaExitChamber_174de3:
	writetext AcquaExitChamberNPC1_Text_174ebf
	endtext

AcquaExitChamber_174de9:
	writetext AcquaExitChamber_174de9_Text_174f2f
	endtext

AcquaExitChamber_174ded:
	closetext
	end

AcquaExitChamberNPC1_Text_174df2:
	ctxt "What ho and"
	line "what ho!"

	para "A fellow traveler!"

	para "Would you like"
	line "me to share one"
	cont "of my treasures?"
	done

AcquaExitChamberNPC1_Text_174e72:
	ctxt "It's a Berry!"

	para "An Oran Berry to"
	line "be specific!"

	para "#mon love to"
	line "eat these!"
	done

AcquaExitChamberNPC1_Text_174ebf:
	ctxt "Attaching Berries"
	line "to your #mon"
	cont "can save you"
	cont "during a battle."

	para "Using it won't"
	line "even waste a turn!"
	done

AcquaExitChamber_174de9_Text_174f2f:
	ctxt "Gah, well I'll"
	line "keep it<...>"
	done

AcquaExitChamber_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $b, $3, 2, CAPER_CITY
	warp_def $3, $5, 0, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_FISHING_GURU, 7, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, AcquaExitChamberNPC1, -1


