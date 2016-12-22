SilkTunnelB5F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilkTunnelB5FHiddenItem_1:
	dw EVENT_SILK_TUNNEL_B5F_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

SilkTunnelB5F_Item_1:
	db CAGE_KEY, 1

SilkTunnelB5F_Item_3:
	db TRADE_STONE, 1

SilkTunnelB5F_Item_4:
	db CAGE_KEY, 1

SilkTunnelB5F_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $2, $10, 2, SILK_TUNNEL_B4F

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 11, 4, SIGNPOST_ITEM, SilkTunnelB5FHiddenItem_1

	;people-events
	db 4
	person_event SPRITE_POKE_BALL, 17, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, SilkTunnelB5F_Item_1, EVENT_SILK_TUNNEL_B5F_ITEM_1
	person_event SPRITE_POKE_BALL, 3, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 3, TM_SOLARBEAM, 0, EVENT_SILK_TUNNEL_B5F_ITEM_2
	person_event SPRITE_POKE_BALL, 16, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, SilkTunnelB5F_Item_3, EVENT_SILK_TUNNEL_B5F_ITEM_3
	person_event SPRITE_POKE_BALL, 7, 3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, SilkTunnelB5F_Item_4, EVENT_SILK_TUNNEL_B5F_ITEM_4
