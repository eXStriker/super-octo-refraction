LongTunnelSidescroll_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

LongTunnelSidescrollNPC1:
	faceplayer
	opentext
	checkitem RIJON_PASS
	iftrue LongTunnelSidescroll_112ce7
	checkevent EVENT_ROUTE_73_GUARD
	iftrue LongTunnelSidescroll_112ce1
	jumptext LongTunnelSidescrollNPC1_Text_112dbd

LongTunnelSidescroll_Item_1:
	db MINING_PICK, 5

LongTunnelSidescroll_112ce7:
	writetext LongTunnelSidescroll_112ce7_Text_112eff
	buttonsound
	takeitem RIJON_PASS, 1
	writetext LongTunnelSidescroll_112ce7_Text_112f26
	waitbutton
	closetext
	applymovement 2, RijonTunnelMovement
	disappear 2
	setevent EVENT_RIJON_GUARD
	end

RijonTunnelMovement:
	step_right
	step_up
	step_up
	step_right
	step_up
	step_up
	step_up
	step_end

LongTunnelSidescroll_112ce1:
	jumptext LongTunnelSidescrollNPC1_Text_112ea0

LongTunnelSidescrollNPC1_Text_112dbd:
	ctxt "Hello."

	para "I can't let you"
	line "through without"
	cont "a Rijon Pass."

	para "Come back when"
	line "you have one."
	done

LongTunnelSidescrollNPC1_Text_112ea0:
	ctxt "Rijon Pass is"
	line "required to pass."
	done

LongTunnelSidescroll_112ce7_Text_112eff:
	ctxt "<PLAYER> handed the"
	line "Rijon Pass to"
	cont "the guard."
	done

LongTunnelSidescroll_112ce7_Text_112f26:
	ctxt "Let me verify"
	line "this card<...>"

	para "It looks like you"
	line "are good to go!"

	para "Enjoy the Rijon"
	line "region!"
	done

LongTunnelSidescroll_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $5, $6, 3, LONG_TUNNEL_PATH
	warp_def $5, $54, 6, CAPER_CITY
	warp_def $5, $62, 5, LONG_TUNNEL_PATH

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 17, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, LongTunnelSidescrollNPC1, EVENT_RIJON_GUARD
	person_event SPRITE_POKE_BALL, 6, 26, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, LongTunnelSidescroll_Item_1, EVENT_LONG_TUNNEL_SIDESCROLL_ITEM_1
