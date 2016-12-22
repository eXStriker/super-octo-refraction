RuinsF4_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, RuinsF4_24eae3

RuinsF4Trap1:
	checkitem GAS_MASK
	iffalse RuinsF4_24ea92
	end

RuinsF4Trap2:
	setevent EVENT_RUINS_F4_TRAP_1
	setevent EVENT_1
	jump RuinsF4_24eae3

RuinsF4Trap3:
	setevent EVENT_RUINS_F4_TRAP_2
	setevent EVENT_2
	jump RuinsF4_24eae3

RuinsF4Trap4:
	setevent EVENT_RUINS_F4_TRAP_3
	setevent EVENT_3
	jump RuinsF4_24eae3

RuinsF4Trap5:
	setevent EVENT_RUINS_F4_TRAP_4
	setevent EVENT_4
	jump RuinsF4_24eae3

RuinsF4Trap6:
	setevent EVENT_RUINS_F4_TRAP_5
	setevent EVENT_5
	jump RuinsF4_24eae3

RuinsF4Trap7:
	setevent EVENT_RUINS_F4_TRAP_6
	setevent EVENT_6
	jump RuinsF4_24eae3

RuinsF4Signpost1:
	opentext
	checkevent EVENT_TELUM_SWITCH
	iftrue RuinsF4_24ee53
	writetext RuinsF4Signpost1_Text_24ee65
	yesorno
	iftrue RuinsF4_24ee59
	closetext
	end

RuinsF4Signpost2:
	checkcode VAR_FACING
	if_equal 2, RuinsF4_24f85c
	checkevent EVENT_RUINS_F4_TRAP_5
	iftrue RuinsF4_102527
	end

RuinsF4Signpost3:
	checkcode VAR_FACING
	if_equal 3, RuinsF4_24f85c
	checkevent EVENT_RUINS_F4_TRAP_6
	iftrue RuinsF4_102527
	end

RuinsF4Signpost4:
	checkcode VAR_FACING
	if_equal DOWN, RuinsF4_24f85c
	checkevent EVENT_RUINS_F4_TRAP_3
	iffalse .end
	scall RuinsF4_102527
	jump RuinsF4Trap5
.end
	end

RuinsF4Signpost5:
	checkcode VAR_FACING
	if_equal DOWN, RuinsF4_24f85c
	checkevent EVENT_RUINS_F4_TRAP_4
	iffalse .end
	scall RuinsF4_102527
	jump RuinsF4Trap4
.end
	end

RuinsF4_Item_1:
	db MAX_REPEL, 3

RuinsF4_24ea92:
	opentext
	writetext RuinsF4_24ea92_Text_24ea9d
	waitbutton
	closetext
	applymovement 0, RuinsF4_24ea92_Movement1
	end

RuinsF4_24ea92_Movement1:
	step_right
	step_end

RuinsF4_24eae3:
	checkevent EVENT_RUINS_F4_TRAP_1
	iffalse RuinsF4_24eb4a
	checkevent EVENT_RUINS_F4_TRAP_2
	iffalse RuinsF4_24eb5b
	changeblock 12, 6, $38
	checkevent EVENT_RUINS_F4_TRAP_3
	iffalse RuinsF4_24eb62
	checkevent EVENT_RUINS_F4_TRAP_4
	iffalse RuinsF4_24eb73
	changeblock 12, 10, $43
	checkevent EVENT_RUINS_F4_TRAP_5
	iffalse RuinsF4_24eb7a
	checkevent EVENT_RUINS_F4_TRAP_6
	iffalse RuinsF4_24eb8b
	changeblock 8, 12, $39
	jump RuinsF4Warp

RuinsF4Warp:
	checkevent EVENT_1
	iftrue RuinsF4_24eb9b
	checkevent EVENT_2
	iftrue RuinsF4_24ebba
	checkevent EVENT_3
	iftrue RuinsF4_24ebd9
	checkevent EVENT_4
	iftrue RuinsF4_24ebf8
	checkevent EVENT_5
	iftrue RuinsF4_24ec17
	checkevent EVENT_6
	iftrue RuinsF4_24ec36
	return

RuinsF4_24ee53:
	jumptext RuinsF4_24ee53_Text_24ee98

RuinsF4_24ee59:
	playsound SFX_ENTER_DOOR
	setevent EVENT_TELUM_SWITCH
	jumptext RuinsF4_24ee59_Text_24eeb4

RuinsF4_24f85c:
	end

RuinsF4_102520:
	checkevent EVENT_RUINS_F4_TRAP_7
	iftrue RuinsF4_102527
	end

RuinsF4_24eb4a:
	changeblock 12, 6, $1
	checkevent EVENT_RUINS_F4_TRAP_2
	iffalse RuinsF4_24eaf3
	changeblock 12, 6, $35
	jump RuinsF4_24eaf3

RuinsF4_24eb5b:
	changeblock 12, 6, $33
	jump RuinsF4_24eaf3

RuinsF4_24eb62:
	changeblock 12, 10, $2b
	checkevent EVENT_RUINS_F4_TRAP_4
	iffalse RuinsF4_24eb03
	changeblock 12, 10, $45
	jump RuinsF4_24eb03

RuinsF4_24eb73:
	changeblock 12, 10, $44
	jump RuinsF4_24eb03

RuinsF4_24eb7a:
	changeblock 8, 12, $1
	checkevent EVENT_RUINS_F4_TRAP_6
	iffalse RuinsF4_24eb13
	changeblock 8, 12, $36
	jump RuinsF4_24eb13

RuinsF4_24eb8b:
	changeblock 8, 12, $33
	jump RuinsF4_24eb13

RuinsF4_102527:
	playsound SFX_JUMP_OVER_LEDGE
	checkcode VAR_FACING
	if_equal 0, RuinsF4_102540
	if_equal 1, RuinsF4_102545
	if_equal 2, RuinsF4_10254a
	if_equal 3, RuinsF4_10254f
	applymovement 0, RuinsF4_102527_Movement1
	end

RuinsF4_102527_Movement1:
	jump_step_down
	step_end

RuinsF4_24eaf3:
	checkevent EVENT_RUINS_F4_TRAP_3
	iffalse RuinsF4_24eb62
	checkevent EVENT_RUINS_F4_TRAP_4
	iffalse RuinsF4_24eb73
	changeblock 12, 10, $43
	checkevent EVENT_RUINS_F4_TRAP_5
	iffalse RuinsF4_24eb7a
	checkevent EVENT_RUINS_F4_TRAP_6
	iffalse RuinsF4_24eb8b
	changeblock 8, 12, $39
	jump RuinsF4Warp

RuinsF4_24eb03:
	checkevent EVENT_RUINS_F4_TRAP_5
	iffalse RuinsF4_24eb7a
	checkevent EVENT_RUINS_F4_TRAP_6
	iffalse RuinsF4_24eb8b
	changeblock 8, 12, $39
	jump RuinsF4Warp

RuinsF4_24eb13:
	jump RuinsF4Warp

RuinsF4_24eb9b:
	clearevent EVENT_1
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF4_1aa4bd

RuinsF4_24ebba:
	clearevent EVENT_2
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF4_1aa4d8

RuinsF4_24ebd9:
	clearevent EVENT_3
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF4_1aa4f3

RuinsF4_24ebf8:
	clearevent EVENT_4
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF4_1aa50e

RuinsF4_24ec17:
	clearevent EVENT_5
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF4_1aa529

RuinsF4_24ec36:
	clearevent EVENT_6
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	jump RuinsF4_1aa544

RuinsF4_102540:
	applymovement 0, RuinsF4_102540_Movement1
	end

RuinsF4_102540_Movement1:
	jump_step_down
	step_end

RuinsF4_102545:
	applymovement 0, RuinsF4_102545_Movement1
	end

RuinsF4_102545_Movement1:
	jump_step_up
	step_end

RuinsF4_10254a:
	applymovement 0, RuinsF4_10254a_Movement1
	end

RuinsF4_10254a_Movement1:
	jump_step_left
	step_end

RuinsF4_10254f:
	applymovement 0, RuinsF4_10254f_Movement1
	end

RuinsF4_10254f_Movement1:
	jump_step_right
	step_end

RuinsF4_1aa4bd:
	showemote 0, 0, 32
	applymovement 0, RuinsF4_1aa529_Movement1
	warp RUINS_F3, 17, 12
	jump RuinsF4Fall

RuinsF4_1aa4d8:
	showemote 0, 0, 32
	applymovement 0, RuinsF4_1aa529_Movement1
	warp RUINS_F3, 17, 13
	jump RuinsF4Fall

RuinsF4_1aa4f3:
	showemote 0, 0, 32
	applymovement 0, RuinsF4_1aa529_Movement1
	warp RUINS_F3, 20, 13
	jump RuinsF4Fall

RuinsF4_1aa50e:
	showemote 0, 0, 32
	applymovement 0, RuinsF4_1aa529_Movement1
	warp RUINS_F3, 21, 13
	jump RuinsF4Fall

RuinsF4_1aa529:
	showemote 0, 0, 32
	applymovement 0, RuinsF4_1aa529_Movement1
	warp RUINS_F3, 12, 18
	jump RuinsF4Fall

RuinsF4Fall:
	playsound SFX_BALL_POOF
	applymovement 0, RuinsF4_1aa451_Movement2
	playsound SFX_STRENGTH
	earthquake 24
	closetext
	end

RuinsF4_1aa451_Movement2:
	show_person
	skyfall
	step_end

RuinsF4_1aa529_Movement1:
	hide_person
	step_end

RuinsF4_1aa544:
	showemote 0, 0, 32
	applymovement 0, RuinsF4_1aa529_Movement1
	warp RUINS_F3, 19, 13
	jump RuinsF4Fall

RuinsF4Signpost1_Text_24ee65:
	ctxt "The switch is on"
	line "and labeled"
	cont "Telum."

	para "Turn it off?"
	done

RuinsF4_24ea92_Text_24ea9d:
	ctxt "This room smells"
	line "very toxic."

	para "It's too hard to"
	line "breathe up here."
	done

RuinsF4_24ee53_Text_24ee98:
	ctxt "The switch is"
	line "already off."
	done

RuinsF4_24ee59_Text_24eeb4:
	ctxt "Turned the switch"
	line "off."
	done

RuinsF4_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $3, $11, 2, RUINS_F3
	warp_def $9, $f, 1, RUINS_F5

	;xy triggers
	db 5
	xy_trigger 0, $2, $e, $0, RuinsF4Trap1, $0, $0
	xy_trigger 0, $a, $c, $0, RuinsF4Trap4, $0, $0
	xy_trigger 0, $a, $d, $0, RuinsF4Trap5, $0, $0
	xy_trigger 0, $c, $8, $0, RuinsF4Trap6, $0, $0
	xy_trigger 0, $d, $9, $0, RuinsF4Trap7, $0, $0

	;signposts
	db 5
	signpost 5, 9, SIGNPOST_READ, RuinsF4Signpost1
	signpost 12, 8, SIGNPOST_READ, RuinsF4Signpost2
	signpost 13, 9, SIGNPOST_READ, RuinsF4Signpost3
	signpost 10, 12, SIGNPOST_READ, RuinsF4Signpost4
	signpost 10, 13, SIGNPOST_READ, RuinsF4Signpost5

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 10, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, RuinsF4_Item_1, EVENT_RUINS_F4_ITEM_1
