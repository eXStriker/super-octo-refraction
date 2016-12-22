RuinsF2_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, RuinsF2_TriggeredTrap

RuinsF2Blocks:
	clearevent EVENT_6
	jump RuinsF2_TriggeredTrap

RuinsF2Trap1:
	setevent EVENT_RUINS_F2_TRAP_1
	setevent EVENT_1
	jump RuinsF2_TriggeredTrap

RuinsF2Trap3:
	setevent EVENT_RUINS_F2_TRAP_5
	setevent EVENT_5
	jump RuinsF2_TriggeredTrap

RuinsF2Trap6:
	setevent EVENT_RUINS_F2_TRAP_3
	setevent EVENT_3
	jump RuinsF2_TriggeredTrap

RuinsF2Trap7:
	setevent EVENT_RUINS_F2_TRAP_4
	setevent EVENT_4
	jump RuinsF2_TriggeredTrap

RuinsF2Trap4:
	checkevent EVENT_TELUM_SWITCH
	iffalse RuinsF2_24e715
	end

RuinsF2Trap5:
	disappear 4
	setevent EVENT_0
	end

RuinsF2_Item_1:
	db GAS_MASK, 1

RuinsF2_Item_2:
	db BLUE_JEWEL, 1

RuinsF2Arrow:
	jumptext RuinsF2Arrow_Text

RuinsF2Warp:
	checkevent EVENT_6
	sif true, then
		changeblock 12, 14, $35
		checkevent EVENT_1
		iftrue RuinsF2_Event1Set
		checkevent EVENT_2
		iftrue RuinsF2_Event2Set
		checkevent EVENT_3
		iftrue RuinsF2_Event3Set
		checkevent EVENT_4
		iftrue RuinsF2_Event4Set
		checkevent EVENT_5
		iftrue RuinsF2_Event5Set
	selse
		setevent EVENT_6
	sendif
	return

RuinsF2_TriggeredTrap:
	checkevent EVENT_RUINS_F2_TRAP_1
	iffalse RuinsF2_Trap1NotSet
	changeblock 2, 4, $33
	checkevent EVENT_RUINS_F2_TRAP_2
	iffalse RuinsF2_Trap2NotSet
	changeblock 26, 4, $34
	checkevent EVENT_RUINS_F2_TRAP_3
	iffalse RuinsF2_Trap3NotSet
	checkevent EVENT_RUINS_F2_TRAP_4
	iffalse RuinsF2_Trap4NotSet
	changeblock 24, 16, $38
	checkevent EVENT_RUINS_F2_TRAP_5
	iffalse RuinsF2_Trap5NotSet
	jump RuinsF2Warp

RuinsF2_CheckTrap2:
	checkevent EVENT_RUINS_F2_TRAP_2
	iffalse RuinsF2_Trap2NotSet
	changeblock 26, 4, $34
RuinsF2_CheckTrap3:
	checkevent EVENT_RUINS_F2_TRAP_3
	iffalse RuinsF2_Trap3NotSet
	checkevent EVENT_RUINS_F2_TRAP_4
	iffalse RuinsF2_Trap4NotSet
	changeblock 24, 16, $38
RuinsF2_CheckTrap5:
	checkevent EVENT_RUINS_F2_TRAP_5
	iffalse RuinsF2_Trap5NotSet
	changeblock 12, 14, $35
	jump RuinsF2Warp

RuinsF2_Trap1NotSet:
	changeblock 2, 4, $1
	jump RuinsF2_CheckTrap2

RuinsF2_Trap2NotSet:
	changeblock 26, 4, $1
	jump RuinsF2_CheckTrap3

RuinsF2_Trap3NotSet:
	changeblock 24, 16, $1
	checkevent EVENT_RUINS_F2_TRAP_5
	sif true
		changeblock 24, 16, $35
	jump RuinsF2_CheckTrap5

RuinsF2_Trap4NotSet:
	changeblock 24, 16, $33
	jump RuinsF2_CheckTrap5

RuinsF2_Trap5NotSet:
	changeblock 12, 14, $1
	jump RuinsF2Warp

RuinsF2_24e715:
	checkevent EVENT_0
	iftrue RuinsF2_24e71e
	end

RuinsF2_24e71e:
	playsound SFX_VICEGRIP
	appear $4
	clearevent EVENT_0
	applymovement 4, .movement
	end
.movement
	fast_slide_step_right
	fast_slide_step_right
	step_end

RuinsPrepareFall:
	playsound SFX_ENTER_DOOR
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft
	showemote 0, 0, 32
	applymovement 0, .movement
	end
.movement
	hide_person
	step_end

RuinsF2_Event1Set:
	clearevent EVENT_1
	scall RuinsPrepareFall
	warp RUINS_F1, 3, 3
	jump RuinsF2Fall

RuinsF2_Event2Set:
	clearevent EVENT_2
	scall RuinsPrepareFall
	warp RUINS_F1, 36, 8
	; fallthrough

RuinsF2Fall:
	playsound SFX_BALL_POOF
	applymovement 0, .movement
	playsound SFX_STRENGTH
	earthquake 24
	closetext
	end
.movement
	show_person
	skyfall
	step_end

RuinsF2_Event3Set:
	clearevent EVENT_3
	scall RuinsPrepareFall
	warp RUINS_F1, 36, 17
	jump RuinsF2Fall

RuinsF2_Event4Set:
	clearevent EVENT_4
	scall RuinsPrepareFall
	warp RUINS_F1, 36, 18
	jump RuinsF2Fall

RuinsF2_Event5Set:
	clearevent EVENT_5
	scall RuinsPrepareFall
	warp RUINS_F1, 23, 14
	jump RuinsF2Fall

RuinsF2Arrow_Text:
	ctxt "This arrow smells"
	line "poisonous."

	para "Better not touch"
	line "it."
	done

RuinsF2_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $b, $13, 4, RUINS_F1
	warp_def $13, $5, 1, RUINS_F3

	;xy triggers
	db 6
	xy_trigger 0, $4, $2, $0, RuinsF2Trap1, $0, $0
	xy_trigger 0, $f, $c, $0, RuinsF2Trap3, $0, $0
	xy_trigger 0, $10, $18, $0, RuinsF2Trap6, $0, $0
	xy_trigger 0, $11, $18, $0, RuinsF2Trap7, $0, $0
	xy_trigger 0, $6, $3, $0, RuinsF2Trap4, $0, $0
	xy_trigger 0, $a, $5, $0, RuinsF2Trap5, $0, $0

	;signposts
	db 2
	signpost 16, 24, SIGNPOST_READ, RuinsF2_TryJump1
	signpost 17, 24, SIGNPOST_READ, RuinsF2_TryJump2

	;people-events
	db 3
	person_event SPRITE_POKE_BALL, 17, 29, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 1, 0, RuinsF2_Item_1, EVENT_RUINS_F2_ITEM_1
	person_event SPRITE_POKE_BALL, 9, 27, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, RuinsF2_Item_2, EVENT_RUINS_F2_ITEM_2
	person_event SPRITE_SNES, 5, 1, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, RuinsF2Arrow, EVENT_0
