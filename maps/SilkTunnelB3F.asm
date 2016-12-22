SilkTunnelB3F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilkTunnelB3F_Trainer_1:
	trainer EVENT_SILK_TUNNEL_B3F_TRAINER_1, HIKER, 10, SilkTunnelB3F_Trainer_1_Text_37da01, SilkTunnelB3F_Trainer_1_Text_37da3c, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SilkTunnelB3F_Trainer_1_Script_Text_37da4a

SilkTunnelB3F_Trainer_2:
	trainer EVENT_SILK_TUNNEL_B3F_TRAINER_2, HIKER, 11, SilkTunnelB3F_Trainer_2_Text_37d8c2, SilkTunnelB3F_Trainer_2_Text_37d8f2, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SilkTunnelB3F_Trainer_2_Script_Text_37d8f8

SilkTunnelB3F_Item_1:
	db MAX_ETHER, 1

SilkTunnelB3F_Item_2:
	db DUSK_STONE, 1

SilkTunnelB3F_Trainer_3:
	trainer EVENT_SILK_TUNNEL_B3F_TRAINER_3, PICNICKER, 7, SilkTunnelB3F_Trainer_3_Text_37d95f, SilkTunnelB3F_Trainer_3_Text_37d98e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext SilkTunnelB3F_Trainer_3_Script_Text_37d9a1

SilkTunnelB3F_Trainer_1_Text_37da01:
	ctxt "Hey there!"

	para "I like collecting"
	line "rocks, including"
	cont "these ones!"
	done

SilkTunnelB3F_Trainer_1_Text_37da3c:
	ctxt "Darn it all."
	done

SilkTunnelB3F_Trainer_1_Script_Text_37da4a:
	ctxt "Geodes and"
	line "Geodude, eh?"
	done

SilkTunnelB3F_Trainer_2_Text_37d8c2:
	ctxt "Those are some"
	line "cool shoes."

	para "All terrain,"
	line "right?"
	done

SilkTunnelB3F_Trainer_2_Text_37d8f2:
	ctxt "Ack!"
	done

SilkTunnelB3F_Trainer_2_Script_Text_37d8f8:
	ctxt "How much did those"
	line "shoes cost?"

	para "The economy in"
	line "your region must"
	cont "be out of control."
	done

SilkTunnelB3F_Trainer_3_Text_37d95f:
	ctxt "Call me weird,"
	line "but I find this"
	cont "place relaxing."
	done

SilkTunnelB3F_Trainer_3_Text_37d98e:
	ctxt "Most of the time!"
	done

SilkTunnelB3F_Trainer_3_Script_Text_37d9a1:
	ctxt "If you ignore the"
	line "Zubat and such,"
	cont "this tunnel is a"
	cont "great place to"
	cont "unwind."
	done

SilkTunnelB3F_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $19, $21, 5, CAPER_CITY
	warp_def $3, $1b, 7, SILK_TUNNEL_B2F
	warp_def $b, $17, 2, SILK_TUNNEL_B2F
	warp_def $21, $1b, 1, SILK_TUNNEL_B4F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_HIKER, 16, 37, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 5, SilkTunnelB3F_Trainer_1, -1
	person_event SPRITE_HIKER, 17, 9, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, SilkTunnelB3F_Trainer_2, -1
	person_event SPRITE_POKE_BALL, 21, 22, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 1, 0, SilkTunnelB3F_Item_1, EVENT_SILK_TUNNEL_B3F_ITEM_1
	person_event SPRITE_PICNICKER, 26, 16, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 2, 2, SilkTunnelB3F_Trainer_3, -1
	person_event SPRITE_POKE_BALL, 12, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, SilkTunnelB3F_Item_2, EVENT_SILK_TUNNEL_B3F_ITEM_2
