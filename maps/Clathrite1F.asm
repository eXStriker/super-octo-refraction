Clathrite1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Clathrite1FSignpost1:
	opentext
	writetext Clathrite1FSignpost1_Text_11e760
	waitbutton
	writetext Clathrite1FSignpost1_Text_11e77e
	loadmenudata ClathriteMinecartMenuDataHeader
	verticalmenu
	closewindow
	if_equal 1, Clathrite1F_11eb90
	if_equal 2, Clathrite1F_11eb98
	if_equal 3, Clathrite1F_11eba0
	closetext
	end

ClathriteMinecartMenuDataHeader:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80 ; flags
	db 4 ; items
	db "Acqua Mines@"
	db "Mound Cave@"
	db "Firelight Caverns@"
	db "Cancel@"

Clathrite1F_11eb90:
	warp ACQUA_START, 28, 35
	closetext
	end

Clathrite1F_11eb98:
	warp MOUND_B3F, 8, 57
	closetext
	end

Clathrite1F_11eba0:
	warp MAGMA_MINECART, 12, 13
	closetext
	end

Clathrite1FSignpost1_Text_11e760:
	ctxt "This mine cart"
	line "seems stable!"
	done

Clathrite1FSignpost1_Text_11e77e:
	ctxt "Where do you want"
	line "to go?"
	done

Clathrite1F_MapEventHeader:: db 0, 0

.Warps: db 8
	warp_def 31, 37, 7, CLATHRITE_1F
	warp_def 13, 7, 4, CLATHRITE_B1F
	warp_def 11, 23, 2, CLATHRITE_B1F
	warp_def 9, 23, 4, RUINS_OUTSIDE
	warp_def 15, 9, 1, ROUTE_84
	warp_def 33, 3, 9, ROUTE_72_GATE
	warp_def 17, 37, 1, CLATHRITE_1F
	warp_def 19, 39, 1, ROUTE_71B

.CoordEvents: db 0

.BGEvents: db 1
	signpost 38, 20, SIGNPOST_READ, Clathrite1FSignpost1

.ObjectEvents: db 1
	person_event SPRITE_POKE_BALL, 30, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_HAIL, 0, EVENT_GOT_TM09
