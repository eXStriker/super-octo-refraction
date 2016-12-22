DreamSequence_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

DreamSequenceNPC1:
	jumptextfaceplayer DreamSequenceNPC1_Text_15bb00

DreamSequenceNPC3:
	jumptextfaceplayer DreamSequenceNPC3_Text_15bf86

DreamSequenceNPC4:
	faceplayer
	opentext
	writetext DreamSequenceNPC4_Text_15be00
	waitbutton
	closetext
	warp DREAM_NEWBARK, 23, 5
	opentext
	jumptext DreamSequenceFiction

DreamSequenceFiction:
	ctxt "Fiction or"
	line "Non-fiction?"
	done

DreamSequenceNPC1_Text_15bb00:
	ctxt "It's mom!"

	para "Where are you?"

	para "I miss you, please"
	line "come home!"

	para "You're all I have!"
	done

DreamSequenceNPC3_Text_15bf86:
	ctxt "Forsake and"
	line "betrayal."

	para "That's all your"
	line "family is known"
	cont "for<...>"
	done

DreamSequenceNPC4_Text_15be00:
	ctxt "You are now in"
	line "dementia."

	para "That is, the"
	line "dream dimension."

	para "You want to awaken"
	line "from your slumber?"

	para "To do that, you"
	line "must encounter a"
	cont "strong epiphany."

	para "I know where you"
	line "can find that."

	para "Relax and go"
	line "wherever your mind"
	cont "takes you<...>"
	done

DreamSequence_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $12, $24, 1, CAPER_CITY
	warp_def $5, $23, 1, DREAM_NEWBARK

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_BIRD, 19, 22, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, DreamSequenceNPC1, -1
	person_event SPRITE_NURSE, 16, 10, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, DreamSequenceNPC3, -1
	person_event SPRITE_NONE, 15, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 4, 0, ObjectEvent, -1
	person_event SPRITE_P0, 25, 25, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PLAYER, 0, 0, DreamSequenceNPC4, -1
