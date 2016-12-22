AcquaStart_MapScriptHeader;trigger count
	db 0
; callback count
	db 0

AcquaStart_ForcedWildShinx:
	loadwildmon SHINX, 2
	startbattle
	reloadmapafterbattle
	dotrigger $1
	wildon
	end

AcquaStartSignpost1:
	opentext
	checkevent EVENT_MOUND_CAVE_RIVAL
	iffalse .brokencart
	writetext AcquaStartMinecartStableText
	waitbutton
	writetext AcquaStartMinecartWhereText
	loadmenudata AcquaMinesMinecartMenuDataHeader
	verticalmenu
	closewindow
	if_equal 1, AcquaMinecart_Mound
	if_equal 2, AcquaMinecart_Clathrite
	if_equal 3, AcquaMinecart_Magma
	closetext
	end

.brokencart
	writetext AcquaStart_BrokenCartText
	endtext

AcquaMinesMinecartMenuDataHeader:
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 19 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80 ; flags
	db 4 ; items
	db "Mound Cave@"
	db "Clathrite Tunnel@"
	db "Firelight Caverns@"
	db "Cancel@"

AcquaMinecart_Mound:
	warp MOUND_B3F, 8, 57
	closetext
	end

AcquaMinecart_Clathrite:
	warp CLATHRITE_1F, 20, 37
	closetext
	end

AcquaMinecart_Magma:
	warp MAGMA_MINECART, 12, 13
	closetext
	end

AcquaStartNPC1:
	faceplayer
	refreshscreen 0
	pokepic LARVITAR
	cry LARVITAR
	waitbutton
	closepokepic
	opentext
	writetext AcquaStartNPC1_Text_18060e
	yesorno
	iffalse AcquaStart_180180
	setevent EVENT_ACQUA_LARVITAR
	writetext AcquaStartNPC1_Text_180a30
	buttonsound
	waitsfx
	disappear 2
	pokenamemem LARVITAR, 0
	writetext AcquaStartNPC1_Text_1806c8
	playwaitsfx SFX_CAUGHT_MON
	buttonsound
	givepoke LARVITAR, 5, NO_ITEM, 0
	closetext
	end

AcquaStart_Item_1:
	db MAX_REVIVE, 1

AcquaStart_180180:
	jumptext AcquaStart_180180_Text_180668

AcquaStartMinecartStableText:
	ctxt "This mine cart"
	line "seems stable!"
	done

AcquaStartMinecartWhereText:
	ctxt "Where do you want"
	line "to go?"
	done

AcquaStartNPC1_Text_18060e:
	ctxt "This Larvitar is"
	line "blocking you."

	para "<...>"
	line "It looks lonely."

	para "Maybe it wants to"
	line "tag along."

	para "Want to bring it"
	line "along with you?"
	done

AcquaStartNPC1_Text_180a30:
	ctxt "Odd<...>"

	para "The Larvitar"
	line "is holding a"
	cont "# Ball."

	para "<PLAYER> put"
	line "Larvitar into the"
	cont "# Ball."
	done

AcquaStartNPC1_Text_1806c8:
	ctxt "<PLAYER> received"
	line "<STRBF1>!"
	done

AcquaStart_180180_Text_180668:
	ctxt "You're on your own"
	line "then."
	done

AcquaStart_BrokenCartText:
	ctxt "The minecart is"
	line "broken!"
	done

AcquaStart_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 5, 37, 1, ACQUA_TUTORIAL
	warp_def 1, 3, 1, ACQUA_ROOM

.CoordEvents: db 1
	xy_trigger 0, 2, 35, $0, AcquaStart_ForcedWildShinx, $0, $0

.BGEvents: db 1
	signpost 36, 28, SIGNPOST_READ, AcquaStartSignpost1

.ObjectEvents: db 3
	person_event SPRITE_LARVITAR, 17, 32, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, AcquaStartNPC1, EVENT_ACQUA_LARVITAR
	person_event SPRITE_POKE_BALL, 8, 16, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, AcquaStart_Item_1, EVENT_ACQUA_START_ITEM_1
	person_event SPRITE_POKE_BALL, 28, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_BODY_SLAM, 0, EVENT_ACQUA_TM76

