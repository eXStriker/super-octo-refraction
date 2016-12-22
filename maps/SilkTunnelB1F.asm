SilkTunnelB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilkTunnelB1F_Trainer_1:
	trainer EVENT_SILK_TUNNEL_B1F_TRAINER_1, HIKER, 8, SilkTunnelB1F_Trainer_1_Text_37d76c, SilkTunnelB1F_Trainer_1_Text_37d799, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SilkTunnelB1F_Trainer_1_Script_Text_37d7cf

SilkTunnelB1F_Trainer_2:
	trainer EVENT_SILK_TUNNEL_B1F_TRAINER_2, HIKER, 7, SilkTunnelB1F_Trainer_2_Text_37d6ec, SilkTunnelB1F_Trainer_2_Text_37d70e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SilkTunnelB1F_Trainer_2_Script_Text_37d71f

SilkTunnelB1F_Trainer_1_Text_37d76c:
	ctxt "It's not too often"
	line "that we see your"
	cont "kind in here."
	done

SilkTunnelB1F_Trainer_1_Text_37d799:
	ctxt "You share the same"
	line "ambitions though,"
	cont "I respect that."
	done

SilkTunnelB1F_Trainer_1_Script_Text_37d7cf:
	ctxt "Exploring is"
	line "always exciting,"
	cont "but tiring too."
	done

SilkTunnelB1F_Trainer_2_Text_37d6ec:
	ctxt "How far down are"
	line "you going down?"
	done

SilkTunnelB1F_Trainer_2_Text_37d70e:
	ctxt "Wow."

	para "That's low."
	done

SilkTunnelB1F_Trainer_2_Script_Text_37d71f:
	ctxt "Who knows what"
	line "unseen caverns"

	para "lie right below"
	line "our feet?"
	done

SilkTunnelB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $2, $4, 8, SILK_TUNNEL_B2F
	warp_def $5, $7, 5, SILK_TUNNEL_1F
	warp_def $7, $d, 3, SILK_TUNNEL_B2F
	warp_def $3, $7, 4, SILK_TUNNEL_B2F
	warp_def $f, $17, 7, SILK_TUNNEL_1F
	warp_def $b, $19, 6, SILK_TUNNEL_B2F
	warp_def $3, $19, 6, SILK_TUNNEL_1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_HIKER, 13, 8, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, SilkTunnelB1F_Trainer_1, -1
	person_event SPRITE_HIKER, 2, 16, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, SilkTunnelB1F_Trainer_2, -1
