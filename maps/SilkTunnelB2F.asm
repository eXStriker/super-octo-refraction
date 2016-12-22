SilkTunnelB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilkTunnelB2F_Trainer_1:
	trainer EVENT_SILK_TUNNEL_B2F_TRAINER_1, HIKER, 9, SilkTunnelB2F_Trainer_1_Text_37d814, SilkTunnelB2F_Trainer_1_Text_37d836, $0000, .Script

.Script:
	end_if_just_battled
	opentext
	writetext SilkTunnelB2F_Trainer_1_Script_Text_37d87a
	endtext

SilkTunnelB2F_Trainer_1_Text_37d814:
	ctxt "I've been training"
	line "my team, look."
	done

SilkTunnelB2F_Trainer_1_Text_37d836:
	ctxt "Well we never met"
	line "before, but you"

	para "remind me of"
	line "someone I once"
	cont "met."
	done

SilkTunnelB2F_Trainer_1_Script_Text_37d87a:
	ctxt "I once battled a"
	line "child with lots of"

	para "potential like"
	line "you."
	done

SilkTunnelB2F_MapEventHeader ;filler
	db 0, 0

;warps
	db 7
	warp_def $3, $5, 8, SILK_TUNNEL_B1F
	warp_def $d, $5, 3, SILK_TUNNEL_B3F
	warp_def $7, $d, 3, SILK_TUNNEL_B1F
	warp_def $f, $13, 4, SILK_TUNNEL_B1F
	warp_def $3, $19, 5, SILK_TUNNEL_B3F
	warp_def $b, $19, 6, SILK_TUNNEL_B1F
	warp_def $e, $19, 2, SILK_TUNNEL_B3F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_HIKER, 11, 16, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, SilkTunnelB2F_Trainer_1, -1
