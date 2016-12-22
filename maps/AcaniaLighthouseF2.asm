AcaniaLighthouseF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaLighthouseF2NPC1:
	faceplayer
	opentext
	checkevent EVENT_GIVEN_HM03
	iftrue AcaniaLighthouseF2_24c313
	writetext AcaniaLighthouseF2NPC1_Text_24c319
	waitbutton
	givetm 99 + RECEIVED_TM
	setevent EVENT_GIVEN_HM03
	writetext AcaniaLighthouseF2HMExplanation
	waitbutton
	closetext
	end

AcaniaLighthouseF2NPC2:
	opentext
	writetext AcaniaLighthouseF2NPC2_Text_24c60a
	yesorno
	iffalse AcaniaLighthouseF2_24c602
	checkpokemontype WATER
	anonjumptable
	dw .nope
	dw AcaniaLighthouseF2_24c5ea
	dw AcaniaLighthouseF2_24c602

.nope
	jumptext AcaniaLighthouseF2NPC2_Text_24c6b8

AcaniaLighthouseF2NPC3:
	jumptext AcaniaLighthouseF2NPC3_Text_24c50e

AcaniaLighthouseF2_24c313:
	jumptext AcaniaLighthouseF2_24c313_Text_24c496

AcaniaLighthouseF2_24c602:
	closetext
	end

AcaniaLighthouseF2_24c5ea:
	giveitem DUBIOUS_DISC, 1
	iffalse AcaniaLighthouseF2_24c604
	writetext AcaniaLighthouseF2_24c5ea_Text_24c6d1
	disappear 3
	waitbutton
	setevent EVENT_ACANIA_LIGHTHOUSE_FIRE
	jumptext AcaniaLighthouseF2_24c5ea_Text_24c6e3

AcaniaLighthouseF2_24c604:
	jumptext AcaniaLighthouseF2_24c604_Text_24c76f
	
AcaniaLighthouseF2HMExplanation:
	ctxt "HM03 is Surf."
	
	para "It's a move that"
	line "lets #mon swim"
	cont "across the water."
	done 

AcaniaLighthouseF2NPC1_Text_24c319:
	ctxt "Hello young one!"

	para "Nobu sent you?"

	para "<...>"

	para "Have I seen the"
	line "Naljo Guardian,"
	cont "Varaneous?"

	para "Yes, I did."

	para "I'm in charge of"
	line "this lighthouse"
	cont "and I see all."

	para "Varaneous went"
	line "to Saxifrage,"

	para "the prison island"
	line "in the southeast."

	para "It looks like it's"
	line "going to awaken"

	para "Fambaco, who's been"
	line "sleeping there"
	cont "for centuries."

	para "Hmm... it looks"
	line "like you need help"
	cont "getting there."

	para "This HM should"
	line "be of help to you."
	done

AcaniaLighthouseF2NPC2_Text_24c60a:
	ctxt "The fire's keeping"
	line "the lighthouse"
	cont "bright."

	para "Better not mess"
	line "with it!"

	para "Wait a second<...>"

	para "There appears to"
	line "be something"
	cont "inside of this."

	para "Douse the fire"
	line "with a Water"
	cont "#mon?"
	done

AcaniaLighthouseF2NPC2_Text_24c6b8:
	ctxt "This isn't a"
	line "Water #mon."
	done

AcaniaLighthouseF2NPC3_Text_24c50e:
	ctxt "The fire's keeping"
	line "the lighthouse"
	cont "bright."

	para "Better not mess"
	line "with it!"
	done

AcaniaLighthouseF2_24c313_Text_24c496:
	ctxt "I appreciate you"
	line "taking your time"

	para "to talk to this"
	line "old man, who has"
	para "nothing but this"
	line "lighthouse left<...>"
	done

AcaniaLighthouseF2_24c5ea_Text_24c6d1:
	ctxt "Doused the fire!"
	done

AcaniaLighthouseF2_24c5ea_Text_24c6e3:
	ctxt "Wow, it's a"
	line "Dubious Disc!"

	para "It must have been"
	line "pretty sturdy to"

	para "survive that"
	line "harsh fire<...>"

	para "There must be a"
	line "reason as to why"
	para "somebody tried to"
	line "burn this<...>"
	done

AcaniaLighthouseF2_24c604_Text_24c76f:
	ctxt "Free up some"
	line "space first."
	done

AcaniaLighthouseF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $7, $9, 3, ACANIA_LIGHTHOUSE_F1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 14
	person_event SPRITE_SAGE, 13, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AcaniaLighthouseF2NPC1, -1
	person_event SPRITE_FIRE, 6, 17, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC2, EVENT_ACANIA_LIGHTHOUSE_FIRE
	person_event SPRITE_FIRE, 11, 17, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 15, 17, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 15, 12, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 15, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 15, 2, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 11, 2, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 6, 2, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 2, 17, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 2, 12, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 2, 7, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
	person_event SPRITE_FIRE, 2, 2, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 0, 0, 0, AcaniaLighthouseF2NPC3, -1
