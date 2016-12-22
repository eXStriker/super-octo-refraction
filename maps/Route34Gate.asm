Route34Gate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route34GateHiddenItem_1:
	dw EVENT_ROUTE_34_GATE_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route34GateNPC1:
	faceplayer
	opentext
	checkevent EVENT_TM88
	iftrue Route34Gate_322f8f
	writetext Route34GateNPC1_Text_322f95
	waitbutton
	givetm 88 + RECEIVED_TM
	setevent EVENT_TM88
	closetext
	end

Route34GateNPC2:
	faceplayer
	opentext
	writetext Route34GateNPC2_Text_32302a
	cry BUTTERFREE
	waitsfx
	endtext

Route34Gate_322f8f:
	jumptext Route34Gate_322f8f_Text_322fe8

Route34GateNPC1_Text_322f95:
	ctxt "Oh, honey. You're"
	line "not from Johto?"

	para "I have a TM that"
	line "you can take as"
	cont "a welcome gift."
	done

Route34GateNPC2_Text_32302a:
	ctxt "Butterfree:"
	line "Freeh!"
	done

Route34Gate_322f8f_Text_322fe8:
	ctxt "TM88 is Signal"
	line "Beam, my"
	cont "Butterfree's"
	cont "favorite move!"
	done

Route34Gate_MapEventHeader ;filler
	db 0, 0

;warps
	db 6
	warp_def $4, $0, 6, ROUTE_47
	warp_def $5, $0, 6, ROUTE_47
	warp_def $0, $e, 1, ROUTE_34
	warp_def $0, $f, 2, ROUTE_34
	warp_def $7, $e, 1, ILEX_FOREST
	warp_def $7, $f, 1, ILEX_FOREST

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 1, 19, SIGNPOST_ITEM, Route34GateHiddenItem_1

	;people-events
	db 2
	person_event SPRITE_TEACHER, 3, 19, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route34GateNPC1, -1
	person_event SPRITE_BUTTERFREE, 4, 19, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, Route34GateNPC2, -1
