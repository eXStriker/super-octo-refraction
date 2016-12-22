PhaceliaTM20_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhaceliaTM20NPC1:
	faceplayer
	opentext
	checkevent EVENT_GET_TM20
	iftrue PhaceliaTM20_398054
	writetext PhaceliaTM20NPC1_Text_39805a
	waitbutton
	givetm 20 + RECEIVED_TM
	setevent EVENT_GET_TM20
	closetext
	end

PhaceliaTM20_398054:
	jumptext PhaceliaTM20_398054_Text_3980ae

PhaceliaTM20NPC1_Text_39805a:
	ctxt "Andre's tough,"
	line "right?"

	para "This move will"
	line "help your #mon"
	cont "endure even his"
	cont "toughest moves."
	done

PhaceliaTM20_398054_Text_3980ae:
	ctxt "TM20 is Endure!"

	para "When it uses this"
	line "move, it won't get"
	cont "knocked out by"
	cont "your foe's next"
	cont "move."
	done

PhaceliaTM20_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 8, PHACELIA_TOWN
	warp_def $7, $3, 8, PHACELIA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_COOLTRAINER_M, 4, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhaceliaTM20NPC1, -1
