SenecaCavernsB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SenecaCavernsB2FHiddenItem_1:
	dw EVENT_SENECACAVERNSB2F_HIDDENITEM_HP_UP
	db HP_UP

SenecaCavernsB2FNPC1:
	faceplayer
	opentext
	writetext SenecaCavernsB2FNPC1_Text_24dcab
	cry ARTICUNO
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon ARTICUNO, 50
	startbattle
	reloadmapafterbattle
	setevent EVENT_ARTICUNO
	disappear 2
	end

SenecaCavernsB2F_Item_1:
	db LEFTOVERS, 1

SenecaCavernsB2FNPC3:
SenecaCavernsB2FNPC4:
SenecaCavernsB2FNPC5:
SenecaCavernsB2FNPC6:
SenecaCavernsB2FNPC7:
SenecaCavernsB2FNPC8:
	jumpstd strengthboulder

SenecaCavernsB2F_Item_2:
	db RARE_CANDY, 2

SenecaCavernsB2F_Item_3:
	db MAX_REVIVE, 1

SenecaCavernsB2FNPC1_Text_24dcab:
	ctxt "Gyaoo!!!"
	done

SenecaCavernsB2F_MapEventHeader ;filler
	db 0, 0

;warps
	db 10
	warp_def $8, $9, 2, SENECACAVERNSB1F
	warp_def $8, $12, 5, SENECACAVERNSB2F
	warp_def $10, $7, 6, SENECACAVERNSB2F
	warp_def $1e, $4, 2, SENECACAVERNSF1
	warp_def $12, $24, 2, SENECACAVERNSB2F
	warp_def $20, $e, 3, SENECACAVERNSB2F
	warp_def $26, $20, 8, SENECACAVERNSB2F
	warp_def $28, $2, 7, SENECACAVERNSB2F
	warp_def $2e, $a, 10, SENECACAVERNSB2F
	warp_def $2e, $24, 9, SENECACAVERNSB2F

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 30, 2, SIGNPOST_ITEM, SenecaCavernsB2FHiddenItem_1

	;people-events
	db 11
	person_event SPRITE_ARTICUNO, 46, 24, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SenecaCavernsB2FNPC1, EVENT_ARTICUNO
	person_event SPRITE_POKE_BALL, 15, 9, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 3, TM_HIDDEN_POWER, 0, EVENT_SENECACAVERNSB2F_NPC_2
	person_event SPRITE_POKE_BALL, 33, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, SenecaCavernsB2F_Item_1, EVENT_SENECACAVERNSB2F_ITEM_1
	person_event SPRITE_BOULDER, 43, 7, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsB2FNPC3, -1
	person_event SPRITE_BOULDER, 25, 37, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsB2FNPC4, -1
	person_event SPRITE_BOULDER, 33, 31, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsB2FNPC5, -1
	person_event SPRITE_BOULDER, 31, 6, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsB2FNPC6, -1
	person_event SPRITE_BOULDER, 44, 9, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsB2FNPC7, -1
	person_event SPRITE_BOULDER, 39, 30, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SenecaCavernsB2FNPC8, -1
	person_event SPRITE_POKE_BALL, 4, 24, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, SenecaCavernsB2F_Item_2, EVENT_SENECACAVERNSB2F_ITEM_2
	person_event SPRITE_POKE_BALL, 33, 30, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, SenecaCavernsB2F_Item_3, EVENT_SENECACAVERNSB2F_ITEM_3
