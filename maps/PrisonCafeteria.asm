PrisonCafeteria_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PrisonCafeteriaHiddenItem_1:
	dw EVENT_PRISON_CAFETERIA_HIDDENITEM_CAGE_KEY
	db CAGE_KEY

PrisonCafeteriaNPC1:
	jumptextfaceplayer PrisonCafeteriaNPC1_Text_2548bb

PrisonCafeteriaNPC2:
	jumptextfaceplayer PrisonCafeteriaNPC2_Text_2549af

PrisonCafeteriaNPC3:
	jumptextfaceplayer PrisonCafeteriaNPC3_Text_254948

PrisonCafeteriaNPC4:
	jumptextfaceplayer PrisonCafeteriaNPC4_Text_2548fc

PrisonCafeteria_Item_1:
	db BURGER, 1

PrisonCafeteria_Item_2:
	db BURGER, 1

PrisonCafeteria_Item_3:
	db SODA_POP, 1

PrisonCafeteria_Item_4:
	db FRIES, 1

PrisonCafeteria_Item_5:
	db BURGER, 1

PrisonCafeteriaNPC1_Text_2548bb:
	ctxt "I prepare the food"
	line "in the Cafeteria."

	para "I wouldn't eat this"
	line "slop myself, haha."
	done

PrisonCafeteriaNPC2_Text_2549af:
	ctxt "-coughs-"

	para "The food got stuck"
	line "in my throat again"
	cont "due to my cold."

	para "I've heard rumors"
	line "of something warm"
	para "and fluffy being"
	line "hidden somewhere"
	cont "in the prison."

	para "Maybe it would"
	line "keep me warm."
	done

PrisonCafeteriaNPC3_Text_254948:
	ctxt "It's tough to stay"
	line "healthy with the"
	cont "slop they give us."

	para "It's very greasy,"
	line "and often gives me"
	cont "heartburn."
	done

PrisonCafeteriaNPC4_Text_2548fc:
	ctxt "Munch<...>"

	para "I'm surprised the"
	line "food is so good."

	para "After all, we're"
	line "mere inmates!"
	done

PrisonCafeteria_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $8, $0, 5, PRISON_F2
	warp_def $9, $0, 6, PRISON_F2

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 15, 16, SIGNPOST_ITEM, PrisonCafeteriaHiddenItem_1

	;people-events
	db 9
	person_event SPRITE_CLERK, 3, 20, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonCafeteriaNPC1, -1
	person_event SPRITE_POKEFAN_M, 11, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonCafeteriaNPC2, -1
	person_event SPRITE_SUPER_NERD, 3, 12, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonCafeteriaNPC3, -1
	person_event SPRITE_ROCKER, 6, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PrisonCafeteriaNPC4, -1
	person_event SPRITE_POKE_BALL, 4, 19, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, PrisonCafeteria_Item_1, EVENT_PRISON_CAFETERIA_ITEM_1
	person_event SPRITE_POKE_BALL, 13, 3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, PrisonCafeteria_Item_2, EVENT_PRISON_CAFETERIA_ITEM_2
	person_event SPRITE_POKE_BALL, 13, 13, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, PrisonCafeteria_Item_3, EVENT_PRISON_CAFETERIA_ITEM_3
	person_event SPRITE_POKE_BALL, 8, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, PrisonCafeteria_Item_4, EVENT_PRISON_CAFETERIA_ITEM_4
	person_event SPRITE_POKE_BALL, 13, 19, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, PrisonCafeteria_Item_5, EVENT_PRISON_CAFETERIA_ITEM_5
