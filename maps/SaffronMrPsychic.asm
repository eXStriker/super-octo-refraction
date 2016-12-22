SaffronMrPsychic_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronMrPsychicNPC1:
	faceplayer
	opentext
	checkevent EVENT_MR_PSYCHIC
	iftrue SaffronMrPsychic_2f6318
	writetext SaffronMrPsychicNPC1_Text_2f631e
	waitbutton
	givetm 29 + RECEIVED_TM
	setevent EVENT_MR_PSYCHIC
	closetext
	end

SaffronMrPsychic_2f6318:
	jumptext SaffronMrPsychic_2f6318_Text_2f633f

SaffronMrPsychicNPC1_Text_2f631e:
	ctxt "You were expecting"
	line "this, right?"
	done

SaffronMrPsychic_2f6318_Text_2f633f:
	ctxt "TM29 is Psychic."

	para "It may lower the"
	line "target's Special"
	cont "Defense."
	done

SaffronMrPsychic_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 3, SAFFRON_CITY
	warp_def $7, $3, 3, SAFFRON_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_FISHING_GURU, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaffronMrPsychicNPC1, -1
