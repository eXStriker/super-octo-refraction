GoldenrodCape_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodCapeHiddenItem_1:
	dw EVENT_GOLDENROD_CAPE_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

GoldenrodCape_Item_1:
	db MINING_PICK, 5

;	Removing until givefossil command is fixed
;	checkitem FOSSIL_CASE
;	iffalse .skip
;	copybytetovar wFossilCaseCount
;	if_greater_than (FOSSIL_CASE_SIZE - 1), .skip
;	disappear LAST_TALKED
;.skip
;	opentext
;	givefossil
;	endtext

GoldenrodCapeNPC2:
	jumpstd smashrock

GoldenrodCape_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $6, $13, 1, GOLDENROD_CAPE_GATE
	warp_def $7, $13, 2, GOLDENROD_CAPE_GATE
	warp_def $3, $1f, 8, CAPER_CITY
	warp_def $3, $20, 8, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 11, 20, SIGNPOST_ITEM, GoldenrodCapeHiddenItem_1

	;people-events
	db 3
	person_event SPRITE_POKE_BALL, 5, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_BLIZZARD, 0, EVENT_GOT_TM14
	person_event SPRITE_POKE_BALL, 19, 15, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, GoldenrodCape_Item_1, EVENT_GOLDENROD_CAPE_ITEM_1
	person_event SPRITE_ROCK, 7, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, GoldenrodCapeNPC2, -1
