AcaniaTM63_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AcaniaTM63NPC1:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM63
	iftrue AcaniaTM63_24c150
	writetext AcaniaTM63NPC1_Text_24c156
	waitbutton
	givetm 63 + RECEIVED_TM
	setevent EVENT_GOT_TM63
	closetext
	end

AcaniaTM63_24c150:
	jumptext AcaniaTM63_24c150_Text_24c1a9

AcaniaTM63NPC1_Text_24c156:
	ctxt "Paralysis."

	para "It can do wonders"
	line "in changing the"
	para "outcome of battles"
	line "with #mon."

	para "See for yourself."
	done

AcaniaTM63_24c150_Text_24c1a9:
	ctxt "TM63 contains"
	line "Thunder Wave!"

	para "It'll paralyze the"
	line "foe, unless - of"

	para "course - the foe"
	line "is a Ground-type!"
	done

AcaniaTM63_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 8, ACANIA_DOCKS
	warp_def $7, $3, 8, ACANIA_DOCKS

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_COOLTRAINER_M, 3, 2, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_YELLOW, 0, 0, AcaniaTM63NPC1, -1
