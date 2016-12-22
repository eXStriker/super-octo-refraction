CastroMansion_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroMansionHiddenItem_1:
	dw EVENT_CASTRO_MANSION_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

CastroMansion_Item_1:
	db ULTRA_BALL, 3

CastroMansion_Item_2:
	db MAGNET, 1

CastroMansionNPC1:
	jumptextfaceplayer CastroMansionNPC1_Text_109207

CastroMansionNPC1_Text_109207:
	ctxt "What?"

	para "This dump is"
	line "being renovated."

	para "I am on break, so"
	line "please let me be."
	done

CastroMansion_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $17, $e, 2, CASTRO_VALLEY
	warp_def $17, $f, 2, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 7, 7, SIGNPOST_ITEM, CastroMansionHiddenItem_1

	;people-events
	db 3
	person_event SPRITE_POKE_BALL, 17, 12, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PLAYER, 1, 0, CastroMansion_Item_1, EVENT_CASTRO_MANSION_ITEM_1
	person_event SPRITE_POKE_BALL, 17, 17, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, CastroMansion_Item_2, EVENT_CASTRO_MANSION_ITEM_2
	person_event SPRITE_FISHER, 14, 2, SPRITEMOVEDATA_SPINRANDOM_SLOW, 1, 1, -1, -1, PAL_OW_RED, 0, 0, CastroMansionNPC1, -1
