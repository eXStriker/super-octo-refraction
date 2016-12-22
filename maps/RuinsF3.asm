RuinsF3_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, RuinsF3Blocks

RuinsF3Blocks:
	checkevent EVENT_RUINS_RANDOM_BALL_PICKED
	iftrue .pickedRandomAlready
	scall RuinsF3_24e8c6

.pickedRandomAlready
	checkevent EVENT_MURUM_SWITCH
	iffalse RuinsF3_24e854
	changeblock 18, 4, 1
	jump RuinsF3_24e854

RuinsF3Trap1:
	setevent EVENT_RUINS_F3_TRAP_1
	setevent EVENT_3
	jump RuinsF3_24e854

RuinsF3Trap2:
	setevent EVENT_RUINS_F3_TRAP_2
	setevent EVENT_4
	jump RuinsF3_24e854

RuinsF3Trap3:
	setevent EVENT_RUINS_F3_TRAP_3
	setevent EVENT_7
	jump RuinsF3_24e854

RuinsF3Trap4:
	setevent EVENT_RUINS_F3_TRAP_4
	setevent EVENT_6
	jump RuinsF3_24e854

RuinsF3Trap5:
	setevent EVENT_RUINS_F3_TRAP_5
	setevent EVENT_1
	jump RuinsF3_24e854

RuinsF3Trap6:
	setevent EVENT_RUINS_F3_TRAP_6
	setevent EVENT_2
	jump RuinsF3_24e854

RuinsF3Signpost1:
	checkevent EVENT_RUINS_F3_TRAP_5
	iffalse .end
	checkcode VAR_FACING
	if_equal UP, RuinsF3_24f85c
	jump RuinsF3_102520
.end
	end

RuinsF3Signpost2:
	checkevent EVENT_RUINS_F3_TRAP_6
	iffalse .end
	checkcode VAR_FACING
	if_equal DOWN, RuinsF3_24f85c
	jump RuinsF3_102520
.end
	end

RuinsF3Signpost3:
	checkcode VAR_FACING
	if_equal 3, RuinsF3_24f85c
	jump RuinsF3_102520

RuinsF3_Item_1:
	db PEARL, 1

RuinsF3NPC2:
	disappear 4
	setevent EVENT_RUINS_OPENED_BALL_3
	checkevent EVENT_RUINS_RANDOM_BALL_IS_3
	jump RuinsF3_24ec57

RuinsF3NPC3:
	disappear 5
	setevent EVENT_RUINS_OPENED_BALL_2
	checkevent EVENT_RUINS_RANDOM_BALL_IS_2
	jump RuinsF3_24ec57

RuinsF3NPC4:
	disappear 6
	setevent EVENT_RUINS_OPENED_BALL_1
	checkevent EVENT_RUINS_RANDOM_BALL_IS_1
	jump RuinsF3_24ec57

RuinsF3_24e854:
	setevent EVENT_0
	checkevent EVENT_RUINS_F3_TRAP_5
	iffalse RuinsF3_24e8f3
	changeblock 8, 2, $33
	checkevent EVENT_RUINS_F3_TRAP_6
	iffalse RuinsF3_24e8fa
	changeblock 10, 2, $35
	checkevent EVENT_RUINS_F3_TRAP_1
	iffalse RuinsF3_24e901
	checkevent EVENT_RUINS_F3_TRAP_2
	iffalse RuinsF3_24e912
	changeblock 22, 14, $38
	checkevent EVENT_RUINS_F3_TRAP_7
	iffalse RuinsF3_24e919
	changeblock 22, 16, $36
	checkevent EVENT_RUINS_F3_TRAP_4
	iffalse RuinsF3_24e920
	checkevent EVENT_RUINS_F3_TRAP_3
	iffalse RuinsF3_24e931
	changeblock 10, 18, $38
	jump RuinsF3Warp

RuinsF3_24f85c:
	end

RuinsF3Gap1:
	checkevent EVENT_RUINS_F3_TRAP_4
	iftrue RuinsF3_102520
	end

RuinsF3Gap2:
	checkevent EVENT_RUINS_F3_TRAP_3
	iftrue RuinsF3_102520
	end

RuinsF3Gap3:
	checkcode VAR_FACING
	if_equal LEFT, .end
	checkevent EVENT_RUINS_F3_TRAP_1
	iffalse .end
	checkevent EVENT_JUMPING_SHOES
	iffalse .end
	scall RuinsF3_102520
	jump RuinsF3Trap2
.end
	end
	
RuinsF3Gap4:
	checkcode VAR_FACING
	if_equal LEFT, .end
	checkevent EVENT_RUINS_F3_TRAP_2
	iffalse .end
	checkevent EVENT_JUMPING_SHOES
	iffalse .end
	scall RuinsF3_102520
	jump RuinsF3Trap1
.end
	end

RuinsF3_102520:
	checkevent EVENT_JUMPING_SHOES
	iftrue RuinsF3_102527
	end

RuinsF3_24ecbd:
	opentext
	giveitem BROWN_JEWEL, 1
	iffalse RuinsF3_24ecd2
	jump RuinsF3_24ecc7

RuinsF3_24ec57:
	iftrue RuinsF3_24ecbd
	random 9
	iffalse RuinsF3_103105
	if_equal 1, RuinsF3_103112
	if_equal 2, RuinsF3_10311f
	if_equal 3, RuinsF3_10312c
	if_equal 4, RuinsF3_10312c
	if_equal 5, RuinsF3_10312c
	if_equal 6, RuinsF3_24ecb0
	if_equal 7, RuinsF3_24ecb0
	if_equal 8, RuinsF3_24ecb0
	jump RuinsF3_103105

RuinsF3_24ecb0:
	jump RuinsF3_103139

RuinsF3_103105:
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon MISDREAVUS, 40
	startbattle
	reloadmapafterbattle
	end

RuinsF3_24e8f3:
	changeblock 8, 2, $1
	jump RuinsF3_24e861

RuinsF3_24e8fa:
	changeblock 10, 2, $1
	jump RuinsF3_24e86b

RuinsF3_24e901:
	changeblock 22, 14, $1
	checkevent EVENT_RUINS_F3_TRAP_2
	iffalse RuinsF3_24e87b
	changeblock 22, 14, $35
	jump RuinsF3_24e87b

RuinsF3_24e912:
	changeblock 22, 14, $33
	jump RuinsF3_24e87b

RuinsF3_24e919:
	changeblock 22, 16, $1
	jump RuinsF3_24e885

RuinsF3_24e920:
	changeblock 10, 18, $1
	checkevent EVENT_RUINS_F3_TRAP_3
	iffalse RuinsF3Warp
	changeblock 10, 18, $35
	jump RuinsF3Warp

RuinsF3_24e931:
	changeblock 10, 18, $33
	jump RuinsF3Warp

RuinsF3_24e8c6:
	setevent EVENT_RUINS_RANDOM_BALL_PICKED
	random 3
	iffalse RuinsF3_24e8d6
	if_equal 1, RuinsF3_24e8da
	setevent EVENT_RUINS_RANDOM_BALL_IS_3
	return

RuinsF3_102527:
	playsound SFX_JUMP_OVER_LEDGE
	checkcode VAR_FACING
	if_equal 0, RuinsF3_102540
	if_equal 1, RuinsF3_102545
	if_equal 2, RuinsF3_10254a
	if_equal 3, RuinsF3_10254f
	applymovement 0, RuinsF3_102527_Movement1
	end

RuinsF3_102527_Movement1:
	jump_step_down
	step_end

RuinsF3_24ecd2:
	jumptext RuinsF3_24ecd2_Text_24ecf4

RuinsF3_24ecc7:
	writetext RuinsF3_24ecc7_Text_24ecd8
	playwaitsfx SFX_DEX_FANFARE_50_79
	closetext
	end

RuinsF3_103112:
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon SWABLU, 40
	startbattle
	reloadmapafterbattle
	end

RuinsF3_10311f:
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon METANG, 40
	startbattle
	reloadmapafterbattle
	end

RuinsF3_10312c:
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon GOLBAT, 40
	startbattle
	reloadmapafterbattle
	end

RuinsF3_103139:
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_TRAP
	loadwildmon YANMA, 40
	startbattle
	reloadmapafterbattle
	end

RuinsF3_24e861:
	checkevent EVENT_RUINS_F3_TRAP_6
	iffalse RuinsF3_24e8fa
	changeblock 10, 2, $35
	checkevent EVENT_RUINS_F3_TRAP_1
	iffalse RuinsF3_24e901
	checkevent EVENT_RUINS_F3_TRAP_2
	iffalse RuinsF3_24e912
	changeblock 22, 14, $38
	checkevent EVENT_RUINS_F3_TRAP_7
	iffalse RuinsF3_24e919
	changeblock 22, 16, $36
	checkevent EVENT_RUINS_F3_TRAP_4
	iffalse RuinsF3_24e920
	checkevent EVENT_RUINS_F3_TRAP_3
	iffalse RuinsF3_24e931
	changeblock 10, 18, $38
	jump RuinsF3Warp

RuinsF3_24e86b:
	checkevent EVENT_RUINS_F3_TRAP_1
	iffalse RuinsF3_24e901
	checkevent EVENT_RUINS_F3_TRAP_2
	iffalse RuinsF3_24e912
	changeblock 22, 14, $38
	checkevent EVENT_RUINS_F3_TRAP_7
	iffalse RuinsF3_24e919
	changeblock 22, 16, $36
	checkevent EVENT_RUINS_F3_TRAP_4
	iffalse RuinsF3_24e920
	checkevent EVENT_RUINS_F3_TRAP_3
	iffalse RuinsF3_24e931
	changeblock 10, 18, $38
	jump RuinsF3Warp

RuinsF3_24e87b:
	checkevent EVENT_RUINS_F3_TRAP_7
	iffalse RuinsF3_24e919
	changeblock 22, 16, $36
	checkevent EVENT_RUINS_F3_TRAP_4
	iffalse RuinsF3_24e920
	checkevent EVENT_RUINS_F3_TRAP_3
	iffalse RuinsF3_24e931
	changeblock 10, 18, $38
	jump RuinsF3Warp

RuinsF3_24e885:
	checkevent EVENT_RUINS_F3_TRAP_4
	iffalse RuinsF3_24e920
	checkevent EVENT_RUINS_F3_TRAP_3
	iffalse RuinsF3_24e931
	changeblock 10, 18, $38
	jump RuinsF3Warp

RuinsF3Warp:
	checkevent EVENT_1
	iftrue RuinsF3_24e941
	checkevent EVENT_2
	iftrue RuinsF3_24e960
	checkevent EVENT_3
	iftrue RuinsF3_24e97f
	checkevent EVENT_4
	iftrue RuinsF3_24e99e
	checkevent EVENT_5
	iftrue RuinsF3_24e9bd
	checkevent EVENT_6
	iftrue RuinsF3_24e9dc
	checkevent EVENT_7
	iftrue RuinsF3_24e9fb
	return

RuinsF3_24e941:
	clearevent EVENT_1
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa400

RuinsF3_24e960:
	clearevent EVENT_2
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa41b

RuinsF3_24e97f:
	clearevent EVENT_3
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa436

RuinsF3_24e99e:
	clearevent EVENT_4
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa451

RuinsF3_24e9bd:
	clearevent EVENT_5
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa46c

RuinsF3_24e9dc:
	clearevent EVENT_6
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa487

RuinsF3_24e9fb:
	clearevent EVENT_7
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF3_1aa4a2

RuinsF3_24e8d6:
	setevent EVENT_RUINS_RANDOM_BALL_IS_1
	return

RuinsF3_24e8da:
	setevent EVENT_RUINS_RANDOM_BALL_IS_2
	return

RuinsF3_102540:
	applymovement 0, RuinsF3_102540_Movement1
	end

RuinsF3_102540_Movement1:
	jump_step_down
	step_end

RuinsF3_102545:
	applymovement 0, RuinsF3_102545_Movement1
	end

RuinsF3_102545_Movement1:
	jump_step_up
	step_end

RuinsF3_10254a:
	applymovement 0, RuinsF3_10254a_Movement1
	end

RuinsF3_10254a_Movement1:
	jump_step_left
	step_end

RuinsF3_10254f:
	applymovement 0, RuinsF3_10254f_Movement1
	end

RuinsF3_10254f_Movement1:
	jump_step_right
	step_end

RuinsF3_1aa400:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa400_Movement1
	warp RUINS_F2, 10, 8
	jump RuinsF3Fall

RuinsF3_1aa400_Movement1:
	hide_person
	step_end

RuinsF3_1aa41b:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa41b_Movement1
	warp RUINS_F2, 12, 9
	jump RuinsF3Fall

RuinsF3_1aa41b_Movement1:
	hide_person
	step_end

RuinsF3_1aa41b_Movement2:
	show_person
	skyfall
	step_end

RuinsF3_1aa436:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa436_Movement1
	warp RUINS_F2, 19, 20
	jump RuinsF3Fall

RuinsF3_1aa436_Movement1:
	hide_person
	step_end

RuinsF3Fall:
	playsound SFX_BALL_POOF
	applymovement 0, RuinsF3_1aa451_Movement2
	playsound SFX_STRENGTH
	earthquake 24
	closetext
	end

RuinsF3_1aa451:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa451_Movement1
	warp RUINS_F2, 19, 21
	jump RuinsF3Fall

RuinsF3_1aa451_Movement1:
	hide_person
	step_end

RuinsF3_1aa451_Movement2:
	show_person
	skyfall
	step_end

RuinsF3_1aa46c:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa46c_Movement1
	warp RUINS_F2, 20, 23
	jump RuinsF3Fall

RuinsF3_1aa46c_Movement1:
	hide_person
	step_end

RuinsF3_1aa46c_Movement2:
	show_person
	skyfall
	step_end

RuinsF3_1aa487:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa487_Movement1
	warp RUINS_F2, 9, 22
	jump RuinsF3Fall

RuinsF3_1aa487_Movement1:
	hide_person
	step_end

RuinsF2_TryJump1:
	checkevent EVENT_RUINS_F2_TRAP_3
	iftrue RuinsF3_102520
	end

RuinsF2_TryJump2:
	checkevent EVENT_RUINS_F2_TRAP_4
	iftrue RuinsF3_102520
	end

RuinsF3_1aa4a2:
	showemote 0, 0, 32
	applymovement 0, RuinsF3_1aa4a2_Movement1
	warp RUINS_F2, 9, 23
	jump RuinsF3Fall

RuinsF3_1aa4a2_Movement1:
	hide_person
	step_end

RuinsF3_24ecd2_Text_24ecf4:
	ctxt "No room for this!"
	done

RuinsF3_24ecc7_Text_24ecd8:
	ctxt "You found the"
	line "Brown Jewel!"
	done

RuinsF3_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 19, 3, 2, RUINS_F2
	warp_def 7, 19, 1, RUINS_F4

.CoordEvents: db 6
	xy_trigger 0, 14, 22, 0, RuinsF3Trap1, 0, 0
	xy_trigger 0, 15, 22, 0, RuinsF3Trap2, 0, 0
	xy_trigger 0, 19, 10, 0, RuinsF3Trap3, 0, 0
	xy_trigger 0, 18, 10, 0, RuinsF3Trap4, 0, 0
	xy_trigger 0, 2, 8, 0, RuinsF3Trap5, 0, 0
	xy_trigger 0, 3, 10, 0, RuinsF3Trap6, 0, 0

.BGEvents: db 6
	signpost 2, 8, SIGNPOST_READ, RuinsF3Signpost1
	signpost 3, 10, SIGNPOST_READ, RuinsF3Signpost2
	signpost 18, 10, SIGNPOST_READ, RuinsF3Gap1
	signpost 19, 10, SIGNPOST_READ, RuinsF3Gap2
	signpost 14, 22, SIGNPOST_READ, RuinsF3Gap3
	signpost 15, 22, SIGNPOST_READ, RuinsF3Gap4

.ObjectEvents: db 5
	person_event SPRITE_POKE_BALL, 19, 23, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 3, TM_SANDSTORM, 0, EVENT_RUINS_F3_NPC_1
	person_event SPRITE_POKE_BALL, 18, 15, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, RuinsF3_Item_1, EVENT_RUINS_F3_ITEM_1
	person_event SPRITE_POKE_BALL, 2, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, RuinsF3NPC2, EVENT_RUINS_OPENED_BALL_1
	person_event SPRITE_POKE_BALL, 2, 3, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, RuinsF3NPC3, EVENT_RUINS_OPENED_BALL_2
	person_event SPRITE_POKE_BALL, 2, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, RuinsF3NPC4, EVENT_RUINS_OPENED_BALL_3

