MoragaTMMachine_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

;Change to move relearner

MoragaMoveRelearnerScript:
	faceplayer
	opentext
	checkevent EVENT_MET_MOVE_RELEARNER
	iftrue .go
	writetext MoveRelearnerIntroText
	buttonsound
	setevent EVENT_MET_MOVE_RELEARNER
.go
	special MoveRelearner
	waitbutton
	closetext
	end

MoveRelearnerIntroText:
	ctxt "Hello! I'm the"
	line "Move Relearner!"

	para "I can help your"
	line "#mon remember"

	para "moves that they"
	line "have forgotten."

	para "I can do this for"
	line "you, in exchange"
	cont "for a Heart Scale."

	para "I collect them,"
	line "you see."
	done

MoragaTMMachine_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 3, MORAGA_TOWN
	warp_def $7, $3, 3, MORAGA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_GENTLEMAN, 4, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaMoveRelearnerScript, -1
