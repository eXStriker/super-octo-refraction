MtEmber_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MtEmberNPC1:
	faceplayer
	opentext
	writetext MtEmberNPC1_Text_2f9e76
	cry MOLTRES
	waitsfx
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon MOLTRES, 50
	startbattle
	reloadmapafterbattle
	setevent EVENT_MOLTRES
	disappear 2
	end

MtEmber_Item_1:
	db ULTRA_BALL, 3

MtEmber_Item_2:
	db MOON_STONE, 1

MtEmberNPC1_Text_2f9e76:
	ctxt "Gyaoo!!!"
	done

MtEmber_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 21, 6, 3, MT_EMBER_ROOM_1
	warp_def 15, 30, 1, MT_EMBER_ROOM_2

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 4
	person_event SPRITE_MOLTRES, 4, 31, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MtEmberNPC1, EVENT_MOLTRES
	person_event SPRITE_POKE_BALL, 4, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MtEmber_Item_1, EVENT_MT_EMBER_ITEM_1
	person_event SPRITE_POKE_BALL, 16, 45, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_ANCIENTPOWER, 0, EVENT_MT_EMBER_ITEM_3
	person_event SPRITE_POKE_BALL, 34, 34, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MtEmber_Item_2, EVENT_MT_EMBER_ITEM_2
