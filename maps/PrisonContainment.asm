PrisonContainment_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PrisonContainmentItem:
	db CAGE_KEY, 1

PrisonContainment_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 5, 2, 3, PRISON_ELECTRIC_CHAIR
	warp_def 5, 3, 3, PRISON_ELECTRIC_CHAIR

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 1
	person_event SPRITE_POKE_BALL, 2, 1, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PrisonContainmentItem, EVENT_PRISON_ELECTRIC_CHAIR_KEY

