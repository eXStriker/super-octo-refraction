PhaceliaPoliceF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaPoliceF2Signpost1:
	jumptext PhaceliaPoliceF2Signpost1_Text_2f7453

PhaceliaPoliceF2NPC1:
	faceplayer
	opentext
	checkevent EVENT_ARRESTED_PALETTE_BLACK
	iftrue PhaceliaPoliceF2_2f73de
	jumptext PhaceliaPoliceF2NPC1_Text_2f73e4

PhaceliaPoliceF2_2f73de:
	jumptext PhaceliaPoliceF2_2f73de_Text_2f7405

PhaceliaPoliceF2Signpost1_Text_2f7453:
	ctxt "Naljo Police"

	para "To Protect and to"
	line "Serve"
	done

PhaceliaPoliceF2NPC1_Text_2f73e4:
	ctxt "Please find a"
	line "Pallet Patroller."
	done

PhaceliaPoliceF2_2f73de_Text_2f7405:
	ctxt "Hey, thanks for"
	line "helping me out."

	para "Hopefully we can"
	line "lock them all up"
	cont "one day very soon."
	done

PhaceliaPoliceF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $3, $5, 3, PHACELIA_POLICE_F1

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 2, 2, SIGNPOST_READ, PhaceliaPoliceF2Signpost1

	;people-events
	db 1
	person_event SPRITE_OFFICER, 1, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, PhaceliaPoliceF2NPC1, -1
