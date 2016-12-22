SoutherlyAirport_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SoutherlyAirportNPC1:
	jumptextfaceplayer SoutherlyAirportNPC1Text

SoutherlyAirportNPC1Text:
	ctxt "Being on a plane"
	line "is exciting!"

	para "There's all sorts"
	line "of #mon around"
	cont "the world."

	para "And I want to see"
	line "as many as I can!"
	done

SoutherlyAirportPilot:
	opentext
	checkitem MYSTERY_TCKT
	iftrue .hasMysteryTicket
	jumptext SoutherlyPilotIntroduceText

.hasMysteryTicket
	checkevent EVENT_PRESENTED_MYSTERY_TICKET
	iffalse .surprisedpilot
	writetext SoutherlyPilotAskText
.asktogo
	yesorno
	iffalse .nogo
	jump .gotozone

.surprisedpilot
	setevent EVENT_PRESENTED_MYSTERY_TICKET
	writetext SoutherlyPilotSurpriseText
	jump .asktogo 

.gotozone
	writetext SoutherlyPilotLeavingText
	waitbutton
	special FadeOutPalettes
	playsound SFX_RAZOR_WIND
	wait 10
	warp MYSTERY_ZONE_AIRPORT, 9, 11
	end

.nogo
	jumptext SoutherlyPilotNoGoText

SoutherlyAirportNPC2:
	jumptextfaceplayer SoutherlyAirportNPC2Text

SoutherlyPilotAskText:
	ctxt "Want to fly to"
	line "the Mystery Zone?"
	done

SoutherlyPilotLeavingText:
	ctxt "Alright, let's"
	line "get going!"
	done

SoutherlyPilotNoGoText:
	ctxt "That's a shame."

	para "I don't get to take"
	line "many people to the"
	cont "Mystery Zone!"
	done 

SoutherlyPilotSurpriseText:
	ctxt "Wait a second."

	para "<...>"

	para "Am I reading this"
	line "right?"

	para "<...>"

	para "Nope, it's genuine."

	para "This is indeed a"
	line "ticket to the"
	cont "Mystery Zone."

	para "The Mystery Zone"
	line "is home to some of"

	para "the best #mon"
	line "Trainers in the"
	cont "world!"

	para "You must be a very"
	line "skilled #mon"
	cont "Trainer!"

	para "Well, I can take"
	line "you there right"
	cont "now."

	para "Want to go?"
	done

SoutherlyPilotIntroduceText:
	ctxt "Hello hello!"

	para "If you ever want"
	line "to fly somewhere,"

	para "come back with a"
	line "plane ticket."

	para "We'll take you"
	line "anywhere in"
	cont "no-time!"
	done

SoutherlyAirportNPC2Text:		 
	ctxt "Hello young one!"

	para "I've been every-"
	line "where!"

	para "Name a region and"
	line "I've been there!"
	done

SoutherlyAirportNPC3:
	jumptextfaceplayer SoutherlyAirportNPC3Text

SoutherlyAirportNPC3Text:		 
	ctxt "Once they rebuild"
	line "the Goldenrod"

	para "Airport, we'll be"
	line "able to fly all"
	cont "way to Johto!"
	done

SoutherlyAirport_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $7, 6, SOUTHERLY_CITY
	warp_def $7, $8, 6, SOUTHERLY_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_YOUNGSTER, 6, 12, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyAirportNPC1, -1
	person_event SPRITE_GRAMPS, 4, 1, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SoutherlyAirportNPC2, -1
	person_event SPRITE_GENTLEMAN, 3, 15, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SoutherlyAirportNPC3, -1
	person_event SPRITE_OFFICER, 2, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SoutherlyAirportPilot, -1
	person_event SPRITE_OFFICER, 2, 6, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SoutherlyAirportPilot, -1
