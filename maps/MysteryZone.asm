MysteryZone_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MysteryZone_Item_1:
	db CAGE_KEY, 2

MysteryZone_Item_2:
	db TRADE_STONE, 1

MysteryZoneSignpost:
	jumptext MysteryZoneSignpostText

MysteryZoneSignpostText:
	text "Mystery Zone"
	line "Airport"
	done

MysteryZone_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 29, 15, 1, MYSTERY_ZONE_AIRPORT
	warp_def 29, 16, 1, MYSTERY_ZONE_AIRPORT
	warp_def 7, 17, 1, MYSTERY_ZONE_LEAGUE_LOBBY

.CoordEvents: db 0

.BGEvents: db 1
	signpost 29, 13, SIGNPOST_READ, MysteryZoneSignpost

.ObjectEvents: db 2
	person_event SPRITE_POKE_BALL, 20, 11, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MysteryZone_Item_1, EVENT_MYSTERY_ZONE_ITEM_1
	person_event SPRITE_POKE_BALL, 20, 25, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, MysteryZone_Item_2, EVENT_MYSTERY_ZONE_ITEM_2
