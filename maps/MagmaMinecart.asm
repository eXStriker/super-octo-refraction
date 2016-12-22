MagmaMinecart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaMinecartSignpost1:
	opentext
	writetext MagmaMinecartSignpost1_Text_146760
	waitbutton
	writetext MagmaMinecartSignpost1_Text_14677e
	loadmenudata MagmaMinecartMenuDataHeader
	verticalmenu
	closewindow
	if_equal 1, MagmaMinecart_146890
	if_equal 2, MagmaMinecart_146898
	if_equal 3, MagmaMinecart_1468a0
	closetext
	end

MagmaMinecartMenuDataHeader:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80 ; flags
	db 4 ; items
	db "Acqua Mines@"
	db "Clathrite Tunnel@"
	db "Mound Cave@"
	db "Cancel@"

MagmaMinecart_Item_1:
	db CONFUSEGUARD, 1

MagmaMinecartNPC1:
	jumpstd smashrock

MagmaMinecart_146890:
	warp ACQUA_START, 28, 35
	closetext
	end

MagmaMinecart_146898:
	warp CLATHRITE_1F, 20, 37
	closetext
	end

MagmaMinecart_1468a0:
	warp MOUND_B3F, 8, 57
	closetext
	end

MagmaMinecartSignpost1_Text_146760:
	ctxt "This mine cart"
	line "seems stable!"
	done

MagmaMinecartSignpost1_Text_14677e:
	ctxt "Where do you want"
	line "to go?"
	done

MagmaMinecart_MapEventHeader:: db 0, 0

.Warps: db 1
	warp_def 7, 5, 2, MAGMA_ROOMS

.CoordEvents: db 0

.BGEvents: db 1
	signpost 14, 12, SIGNPOST_READ, MagmaMinecartSignpost1

.ObjectEvents: db 2
	person_event SPRITE_POKE_BALL, 7, 10, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PLAYER, 1, 0, MagmaMinecart_Item_1, EVENT_MAGMA_MINECART_ITEM_1
	person_event SPRITE_ROCK, 4, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, MagmaMinecartNPC1, -1
