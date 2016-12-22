GoldenrodSwitches_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodSwitchesSignpost1:
	opentext
	writetext GoldenrodSwitchesSignpost1_Text_32693d
	yesorno
	iftrue GoldenrodSwitches_3268cf
	closetext
	end

GoldenrodSwitchesSignpost2:
	opentext
	writetext GoldenrodSwitchesSignpost2_Text_3268a5
	yesorno
	iftrue GoldenrodSwitches_326837
	closetext
	end

GoldenrodSwitchesSignpost3:
	opentext
	writetext GoldenrodSwitchesSignpost3_Text_3267c7
	yesorno
	iftrue GoldenrodSwitches_326758
	closetext
	end

GoldenrodSwitchesSignpost4:
	opentext
	writetext GoldenrodSwitchesSignpost4_Text_3269da
	yesorno
	iftrue GoldenrodSwitches_326986
	closetext
	end

GoldenrodSwitches_Item_1:
	db METAL_COAT, 1

GoldenrodSwitches_3268cf:
	playsound SFX_ENTER_DOOR
	checkevent EVENT_2
	iffalse GoldenrodSwitches_3268e2
	changeblock 16, 6, $3e
	clearevent EVENT_2
	jump GoldenrodSwitches_3268ec

GoldenrodSwitches_326837:
	playsound SFX_ENTER_DOOR
	checkevent EVENT_0
	iffalse GoldenrodSwitches_32684a
	changeblock 2, 6, $3e
	clearevent EVENT_0
	jump GoldenrodSwitches_326854

GoldenrodSwitches_326758:
	playsound SFX_ENTER_DOOR
	checkevent EVENT_0
	iffalse GoldenrodSwitches_32676b
	changeblock 2, 6, $3e
	clearevent EVENT_0
	jump GoldenrodSwitches_326775

GoldenrodSwitches_326986:
	playsound SFX_ENTER_DOOR
	checkevent EVENT_2
	iffalse GoldenrodSwitches_326999
	changeblock 16, 6, $3e
	clearevent EVENT_2
	jump GoldenrodSwitches_3269a3

GoldenrodSwitches_3268e2:
	changeblock 16, 6, $2d
	setevent EVENT_2
	jump GoldenrodSwitches_3268ec

GoldenrodSwitches_3268ec:
	checkevent EVENT_3
	iffalse GoldenrodSwitches_3268fc
	changeblock 1, 5, $3e
	clearevent EVENT_3
	jump GoldenrodSwitches_326906

GoldenrodSwitches_32684a:
	changeblock 2, 6, $2d
	setevent EVENT_0
	jump GoldenrodSwitches_326854

GoldenrodSwitches_326854:
	checkevent EVENT_1
	iffalse GoldenrodSwitches_326864
	changeblock 10, 6, $3e
	clearevent EVENT_1
	jump GoldenrodSwitches_32686e

GoldenrodSwitches_32676b:
	changeblock 2, 6, $2d
	setevent EVENT_0
	jump GoldenrodSwitches_326775

GoldenrodSwitches_326775:
	checkevent EVENT_2
	iffalse GoldenrodSwitches_326785
	changeblock 16, 6, $3e
	clearevent EVENT_2
	jump GoldenrodSwitches_32678f

GoldenrodSwitches_326999:
	changeblock 16, 6, $2d
	setevent EVENT_2
	jump GoldenrodSwitches_3269a3

GoldenrodSwitches_3269a3:
	checkevent EVENT_5
	iffalse GoldenrodSwitches_3269b3
	changeblock 16, 10, $3e
	clearevent EVENT_5
	jump GoldenrodSwitches_3269bd

GoldenrodSwitches_3268fc:
	changeblock 2, 10, $2d
	setevent EVENT_3
	jump GoldenrodSwitches_326906

GoldenrodSwitches_326906:
	checkevent EVENT_4
	iffalse GoldenrodSwitches_326916
	changeblock 10, 10, $3e
	clearevent EVENT_4
	jump GoldenrodSwitches_326920

GoldenrodSwitches_326864:
	changeblock 10, 6, $2d
	setevent EVENT_1
	jump GoldenrodSwitches_32686e

GoldenrodSwitches_32686e:
	checkevent EVENT_6
	iffalse GoldenrodSwitches_32687e
	changeblock 6, 8, $3d
	clearevent EVENT_6
	jump GoldenrodSwitches_326888

GoldenrodSwitches_326785:
	changeblock 16, 6, $2d
	setevent EVENT_2
	jump GoldenrodSwitches_32678f

GoldenrodSwitches_32678f:
	checkevent EVENT_4
	iffalse GoldenrodSwitches_32679f
	changeblock 10, 10, $3e
	clearevent EVENT_4
	jump GoldenrodSwitches_3267a9

GoldenrodSwitches_3269b3:
	changeblock 16, 10, $2d
	setevent EVENT_5
	jump GoldenrodSwitches_3269bd

GoldenrodSwitches_3269bd:
	checkevent EVENT_7
	iffalse GoldenrodSwitches_3269cd
	changeblock 18, 12, $3d
	clearevent EVENT_7
	jump GoldenrodSwitches_3269d7

GoldenrodSwitches_326916:
	changeblock 10, 10, $2d
	setevent EVENT_4
	jump GoldenrodSwitches_326920

GoldenrodSwitches_326920:
	checkevent EVENT_5
	iffalse GoldenrodSwitches_326930
	changeblock 16, 10, $3e
	clearevent EVENT_5
	jump GoldenrodSwitches_32693a

GoldenrodSwitches_32687e:
	changeblock 6, 8, $2d
	setevent EVENT_6
	jump GoldenrodSwitches_326888

GoldenrodSwitches_326888:
	checkevent EVENT_7
	iffalse GoldenrodSwitches_326898
	changeblock 18, 12, $3d
	clearevent EVENT_7
	jump GoldenrodSwitches_3268a2

GoldenrodSwitches_32679f:
	changeblock 10, 10, $2d
	setevent EVENT_4
	jump GoldenrodSwitches_3267a9

GoldenrodSwitches_3267a9:
	checkevent EVENT_6
	iffalse GoldenrodSwitches_3267ba
	changeblock 6, 8, $3d
	clearevent EVENT_6
	jump GoldenrodSwitches_3267c4

GoldenrodSwitches_3269cd:
	changeblock 18, 12, $2d
	setevent EVENT_7
	jump GoldenrodSwitches_3269d7

GoldenrodSwitches_3269d7:
	reloadmappart
	closetext
	end

GoldenrodSwitches_326930:
	changeblock 16, 10, $2d
	setevent EVENT_5
	jump GoldenrodSwitches_32693a

GoldenrodSwitches_32693a:
	reloadmappart
	closetext
	end

GoldenrodSwitches_326898:
	changeblock 18, 12, $2d
	setevent EVENT_7
	jump GoldenrodSwitches_3268a2

GoldenrodSwitches_3268a2:
	reloadmappart
	closetext
	end

GoldenrodSwitches_3267ba:
	changeblock 6, 8, $2d
	setevent EVENT_6
	jump GoldenrodSwitches_3267c4

GoldenrodSwitches_3267c4:
	reloadmappart
	closetext
	end

GoldenrodSwitchesSignpost1_Text_32693d:
	ctxt "It's labeled"
	line "Switch 3"

	para "Press it?"
	done

GoldenrodSwitchesSignpost2_Text_3268a5:
	ctxt "It's labeled"
	line "Switch 2"

	para "Press it?"
	done

GoldenrodSwitchesSignpost3_Text_3267c7:
	ctxt "It's labeled"
	line "Switch 1"

	para "Press it?"
	done

GoldenrodSwitchesSignpost4_Text_3269da:
	ctxt "It's labeled"
	line "Switch 4"

	para "Press it?"
	done

GoldenrodSwitches_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $3, $17, 6, GOLDENROD_UNDERGROUND
	warp_def $a, $16, 1, GOLDENROD_STORAGE
	warp_def $a, $17, 2, GOLDENROD_STORAGE

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 1, 2, SIGNPOST_READ, GoldenrodSwitchesSignpost1
	signpost 1, 10, SIGNPOST_READ, GoldenrodSwitchesSignpost2
	signpost 1, 16, SIGNPOST_READ, GoldenrodSwitchesSignpost3
	signpost 11, 20, SIGNPOST_READ, GoldenrodSwitchesSignpost4

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 13, 0, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, GoldenrodSwitches_Item_1, EVENT_GOLDENROD_SWITCHES_ITEM_1
