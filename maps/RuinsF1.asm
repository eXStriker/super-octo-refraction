ruinsPit: macro
	dw \1 ; Flag
	db \2 ; Y
	db \3 ; X
	db \4 ; Permissions
	endm

RuinsF1_MapScriptHeader;trigger count
	db 1
	maptrigger .Trigger0

 ;callback count
	db 1
	dbw MAPCALLBACK_TILES, RuinsF1Blocks

.Trigger0
	callasm F1CheckJump
	callasm F1CheckPit
	end

F1GetFacingDirection:
	ld a, [PlayerDirection]
	and $c
	rrca
	rrca
	ret

F1CheckJump:
	ld a, [hJoyPressed]
	cp A_BUTTON
	ret nz
	call F1GetFacingDirection
	push af
	ld hl, YCoord
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop af
	push de
	jumptable

.Jumptable
	dw .down
	dw .up
	dw .left
	dw .right

.down 
	pop de
	inc e
	jr .checkTile
.up 
	pop de
	dec e
	jr .checkTile
.left 
	pop de
	dec d
	jr .checkTile
.right 
	pop de
	inc d

.checkTile
	ld hl, RuinsF1PitTable
	call F1ReadPitTable
	ret nc

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld b, CHECK_FLAG
	push hl
	ld hl, EventFlags
	predef EventFlagAction
	pop hl
	ret z

	inc hl
	inc hl ;Check facing permissions

	call F1GetFacingDirection
	ld b, a
	ld c, DOWN
	ld d, [hl]

.facingCheck
	ld a, b
	bit 3, d
	jr z, .facingOK
	cp c
	ret z
.facingOK
	sla d
	inc c
	ld a, c
	cp 4
	jr nz, .facingCheck

	ld a, BANK(Ruins_TryJump)
	ld de, Ruins_TryJump
	jp F1SetPriorityJump

F1SetPriorityJump:
	ld [wPriorityScriptBank], a
	ld hl, wPriorityScriptAddr
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	ld hl, ScriptFlags
	set 3, [hl]
	ret

F1ReadPitTable: ;e: Y, d: X, set carry if it was found. Returns address of entry in hl
	inc hl
	inc hl
.loop
	ld a, [hli]
	cp -1
	jr z, .none

	ld b, a
	ld a, e
	cp b
	jr nz, .badCoord

	ld a, [hl]
	ld b, a
	ld a, d
	cp b
	jr nz, .badCoord 
	scf
rept 3
	dec hl
endr
	ret
.none
	and a
	ret

.badCoord
rept 4
	inc hl
endr
	jr .loop

F1CheckPit:
	ld hl, YCoord
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, RuinsF1PitTable
	call F1ReadPitTable
	ret nc

	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld b, SET_FLAG
	ld hl, EventFlags
	predef EventFlagAction

	ld a, BANK(RuinsF1_TriggeredTrap)
	ld de, RuinsF1_TriggeredTrap
	jp F1SetPriorityJump

RuinsF1Blocks:
	clearevent EVENT_2
	jump RuinsTrapSet0

RuinsF1Trap21:
	checkevent EVENT_TELUM_SWITCH
	iffalse RuinsF1_24e5c9
	end

RuinsF1Trap22:
	disappear 5
	setevent EVENT_0
	end

RuinsF1MurumSwitch:
	opentext
	checkevent EVENT_MURUM_SWITCH
	sif true
		jumptext RuinsF1MurumSwitch_Text_SwitchIsOff
	writetext RuinsF1MurumSwitch_Text_SwitchIsOn
	yesorno
	sif false, then
		closetext
		end
	sendif
	playsound SFX_ENTER_DOOR
	setevent EVENT_MURUM_SWITCH
	jumptext RuinsF1MurumSwitch_Text_TurnedSwitchOff

RuinsF1_Item_1:
	db PP_UP, 1

RuinsF1_Item_2:
	db RED_JEWEL, 1

RuinsF1_PaletteYellow:
	trainer EVENT_RUINS_F1_TRAINER_1, PATROLLER, 5, RuinsF1_PaletteYellow_Text_BeforeBattle, RuinsF1_PaletteYellow_Text_BattleWon, $0000, .Script

.Script
	end_if_just_battled
	jumptext RuinsF1_PaletteYellow_Script_Text_AfterBattle

RuinsF1Arrow:
	jumptext RuinsF1Arrow_Text

RuinsF1_TriggeredTrap:
	setevent EVENT_1
	; fallthrough

RuinsTrapSet0:
	checkevent EVENT_RUINS_F1_TRAP_1
	iffalse RuinsF1_24e371
	checkevent EVENT_RUINS_F1_TRAP_2
	iffalse RuinsF1_24e382
	changeblock 4, 8, $43

RuinsTrapSet1:
	checkevent EVENT_RUINS_F1_TRAP_3
	iffalse RuinsF1_24e389
	checkevent EVENT_RUINS_F1_TRAP_4
	iffalse RuinsF1_24e39a
	changeblock 14, 6, $43

RuinsTrapSet2:
	checkevent EVENT_RUINS_F1_TRAP_5
	iffalse RuinsF1_24e3a1
	checkevent EVENT_RUINS_F1_TRAP_6
	iffalse RuinsF1_24e3b2
	changeblock 28, 10, $42

RuinsTrapSet3:
	checkevent EVENT_RUINS_F1_TRAP_7
	iffalse RuinsF1_24e355
	changeblock 36, 8, $34

RuinsTrapSet4:
	checkevent EVENT_RUINS_F1_TRAP_8
	iffalse RuinsF1_24e35c
	changeblock 36, 12, $33

RuinsTrapSet5:
	checkevent EVENT_RUINS_F1_TRAP_9
	iffalse RuinsF1_24e363
	changeblock 36, 16, $34

RuinsTrapSet6:
	checkevent EVENT_RUINS_F1_TRAP_10
	iffalse RuinsF1_24e36a
	changeblock 36, 20, $33

RuinsTrapSet7:
	checkevent EVENT_RUINS_F1_TRAP_11
	iffalse RuinsF1_24e3b9
	checkevent EVENT_RUINS_F1_TRAP_12
	iffalse RuinsF1_24e3ca
	changeblock 36, 28, $3b

RuinsTrapSet8:
	checkevent EVENT_RUINS_F1_TRAP_13
	iffalse RuinsF1_24e3d1
	checkevent EVENT_RUINS_F1_TRAP_14
	iffalse RuinsF1_24e3e2
	changeblock 8, 26, $38

RuinsTrapSet9:
	checkevent EVENT_RUINS_F1_TRAP_15
	iffalse RuinsF1_24e3e9
	changeblock 8, 24, $35

RuinsTrapSet10:
	checkevent EVENT_RUINS_F1_TRAP_16
	iffalse RuinsF1_24e3f0

RuinsTrapSet11:
	checkevent EVENT_RUINS_F1_TRAP_17
	iffalse RuinsF1_24e401
	changeblock 7, 24, $3c

RuinsTrapSet12:
	checkevent EVENT_RUINS_F1_TRAP_18
	iffalse RuinsF1_24e408
	checkevent EVENT_RUINS_F1_TRAP_19
	iffalse RuinsF1_24e423
	checkevent EVENT_RUINS_F1_TRAP_20
	iffalse RuinsF1_24e434
	changeblock 6, 26, $3f
	checkevent EVENT_2
	iffalse RuinsF1_24e351
	jump RuinsF1_24e210

RuinsF1_24e5c9:
	checkevent EVENT_0
	iftrue RuinsF1_24e5d2
	end

RuinsF1_24e371:
	changeblock 4, 8, $2b
	checkevent EVENT_RUINS_F1_TRAP_2
	iffalse RuinsTrapSet1
	changeblock 4, 8, $45
	jump RuinsTrapSet1

RuinsF1_24e382:
	changeblock 4, 8, $44
	jump RuinsTrapSet1

RuinsF1_24e389:
	changeblock 14, 6, $2b
	checkevent EVENT_RUINS_F1_TRAP_4
	iffalse RuinsTrapSet2
	changeblock 14, 6, $45
	jump RuinsTrapSet2

RuinsF1_24e39a:
	changeblock 14, 6, $44
	jump RuinsTrapSet2

RuinsF1_24e3a1:
	changeblock 28, 10, $2f
	checkevent EVENT_RUINS_F1_TRAP_6
	iffalse RuinsTrapSet3
	changeblock 28, 10, $46
	jump RuinsTrapSet3

RuinsF1_24e3b2:
	changeblock 28, 10, $47
	jump RuinsTrapSet3

RuinsF1_24e355:
	changeblock 36, 8, $1
	jump RuinsTrapSet4

RuinsF1_24e35c:
	changeblock 36, 12, $1
	jump RuinsTrapSet5

RuinsF1_24e363:
	changeblock 36, 16, $1
	jump RuinsTrapSet6

RuinsF1_24e36a:
	changeblock 36, 20, $1
	jump RuinsTrapSet7

RuinsF1_24e3b9:
	changeblock 36, 28, $1
	checkevent EVENT_RUINS_F1_TRAP_12
	iffalse RuinsTrapSet8
	changeblock 36, 28, $36
	jump RuinsTrapSet8

RuinsF1_24e3ca:
	changeblock 36, 28, $34
	jump RuinsTrapSet8

RuinsF1_24e3d1:
	changeblock 8, 26, $1
	checkevent EVENT_RUINS_F1_TRAP_14
	iffalse RuinsTrapSet9
	changeblock 8, 26, $33
	jump RuinsTrapSet9

RuinsF1_24e3e2:
	changeblock 8, 26, $35
	jump RuinsTrapSet9

RuinsF1_24e3e9:
	changeblock 8, 24, $1
	jump RuinsTrapSet10

RuinsF1_24e3f0:
	changeblock 6, 24, $1
	checkevent EVENT_RUINS_F1_TRAP_17
	iffalse RuinsTrapSet11
	changeblock 6, 24, $35
	jump RuinsTrapSet11

RuinsF1_24e401:
	changeblock 6, 24, $36
	jump RuinsTrapSet12

RuinsF1_24e408:
	changeblock 6, 26, $1
	checkevent EVENT_RUINS_F1_TRAP_19
	iffalse RuinsF1_24e43b
	changeblock 6, 26, $35
	checkevent EVENT_RUINS_F1_TRAP_20
	iffalse RuinsF1_24e348
	changeblock 6, 26, $3c
	jump RuinsF1_24e348

RuinsF1_24e423:
	changeblock 6, 26, $33
	checkevent EVENT_RUINS_F1_TRAP_20
	iffalse RuinsF1_24e348
	changeblock 6, 26, $39
	jump RuinsF1_24e348

RuinsF1_24e434:
	changeblock 6, 26, $38
	jump RuinsF1_24e348

RuinsF1_24e351:
	setevent EVENT_2
	return

RuinsF1_24e210:
	playsound SFX_ENTER_DOOR
	jump RuinsF1_1a9b10

RuinsF1_24e5d2:
	playsound SFX_VICEGRIP
	appear $5
	applymovement 5, .movement
	end
.movement
	fast_slide_step_left
	fast_slide_step_left
	step_end

Ruins_TryJump:
	checkevent EVENT_JUMPING_SHOES
	sif false
		end
	playsound SFX_JUMP_OVER_LEDGE
	checkcode VAR_FACING
	sif >, 3
		writebyte 0
	anonjumptable
	dw .facing_down
	dw .facing_up
	dw .facing_left
	dw .facing_right
.facing_down
	applymovement 0, .down_movement
	end
.facing_up
	applymovement 0, .up_movement
	end
.facing_left
	applymovement 0, .left_movement
	end
.facing_right
	applymovement 0, .right_movement
	end
.down_movement
	jump_step_down
	step_end
.up_movement
	jump_step_up
	step_end
.left_movement
	jump_step_left
	step_end
.right_movement
	jump_step_right
	step_end

RuinsF1_24e43b:
	checkevent EVENT_RUINS_F1_TRAP_20
	iffalse RuinsF1_24e348
	changeblock 6, 26, $36
	; fallthrough

RuinsF1_24e348:
	checkevent EVENT_2
	iffalse RuinsF1_24e351
	jump RuinsF1_24e210

RuinsF1_1a9b10:
	callasm AnchorBGMap
	callasm BGMapAnchorTopLeft

	showemote 0, 0, 32
	applymovement 0, .movement
	random 16
	anonjumptable
	dw RuinsF1_Warp0
	dw RuinsF1_Warp1
	dw RuinsF1_Warp2
	dw RuinsF1_Warp3
	dw RuinsF1_Warp4
	dw RuinsF1_Warp5
	dw RuinsF1_Warp6
	dw RuinsF1_Warp7
	dw RuinsF1_Warp8
	dw RuinsF1_Warp7
	dw RuinsF1_Warp8
	dw RuinsF1_Warp9
	dw RuinsF1_Warp10
	dw RuinsF1_Warp1
	dw RuinsF1_Warp2
	dw RuinsF1_Warp1
.movement
	hide_person
	step_end

RuinsF1_Warp0:
	warp RUINS_B1F, 8, 8
	jump RuinsF1_Warp

RuinsF1_Warp1:
	warp RUINS_B1F, 9, 8
	jump RuinsF1_Warp

RuinsF1_Warp2:
	warp RUINS_B1F, 8, 9
	jump RuinsF1_Warp

RuinsF1_Warp3:
	warp RUINS_B1F, 4, 10
	jump RuinsF1_Warp

RuinsF1_Warp4:
	warp RUINS_B1F, 5, 8
	jump RuinsF1_Warp

RuinsF1_Warp5:
	warp RUINS_B1F, 10, 5
	jump RuinsF1_Warp

RuinsF1_Warp6:
	warp RUINS_B1F, 8, 4
	jump RuinsF1_Warp

RuinsF1_Warp7:
	warp RUINS_B1F, 15, 10
	jump RuinsF1_Warp

RuinsF1_Warp8:
	warp RUINS_B1F, 14, 9
	jump RuinsF1_Warp

RuinsF1_Warp9:
	warp RUINS_B1F, 11, 15
	jump RuinsF1_Warp

RuinsF1_Warp10:
	warp RUINS_B1F, 8, 14
	; fallthrough

RuinsF1_Warp:
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

RuinsF1PitTable:
	ruinsPit EVENT_RUINS_F1_TRAP_1, 8, 4, 0
	ruinsPit EVENT_RUINS_F1_TRAP_2, 8, 5, 0
	ruinsPit EVENT_RUINS_F1_TRAP_3, 6, 14, 0
	ruinsPit EVENT_RUINS_F1_TRAP_4, 6, 15, 0
	ruinsPit EVENT_RUINS_F1_TRAP_5, 11, 28, 0
	ruinsPit EVENT_RUINS_F1_TRAP_6, 10, 28, 0
	ruinsPit EVENT_RUINS_F1_TRAP_7, 8, 37, FACE_RIGHT
	ruinsPit EVENT_RUINS_F1_TRAP_8, 12, 36, FACE_LEFT
	ruinsPit EVENT_RUINS_F1_TRAP_9, 16, 37, FACE_RIGHT
	ruinsPit EVENT_RUINS_F1_TRAP_10, 20, 36, FACE_LEFT
	ruinsPit EVENT_RUINS_F1_TRAP_11, 28, 37, FACE_RIGHT
	ruinsPit EVENT_RUINS_F1_TRAP_12, 29, 37, FACE_DOWN | FACE_RIGHT
	ruinsPit EVENT_RUINS_F1_TRAP_13, 27, 8, 0
	ruinsPit EVENT_RUINS_F1_TRAP_14, 26, 8, 0
	ruinsPit EVENT_RUINS_F1_TRAP_15, 25, 8, 0
	ruinsPit EVENT_RUINS_F1_TRAP_16, 25, 7, 0
	ruinsPit EVENT_RUINS_F1_TRAP_17, 25, 6, 0
	ruinsPit EVENT_RUINS_F1_TRAP_18, 26, 6, 0
	ruinsPit EVENT_RUINS_F1_TRAP_19, 27, 6, 0
	ruinsPit EVENT_RUINS_F1_TRAP_20, 27, 7, 0
	db -1, -1, -1, -1

RuinsF1MurumSwitch_Text_SwitchIsOn:
	ctxt "The switch is on"
	line "and labeled"
	cont "Murum."

	para "Turn it off?"
	done

RuinsF1_PaletteYellow_Text_BeforeBattle:
	ctxt "We're down to two,"
	line "but we're not"
	cont "going to stop!"

	para "We've developed a"
	line "strong partnership"

	para "that'll make me and"
	line "Green rich!"
	done

RuinsF1_PaletteYellow_Text_BattleWon:
	ctxt "That shouldn't have"
	line "happened again<...>"
	done

RuinsF1_PaletteYellow_Script_Text_AfterBattle:
	ctxt "Please stop."

	para "If we find the"
	line "stone turtle,"

	para "we can steal its"
	line "orb and harness"
	cont "the orb's energy."

	para "With that, we can"
	line "make any #mon"
	cont "even stronger!"
	done

RuinsF1Arrow_Text:
	ctxt "This arrow smells"
	line "poisonous."

	para "Better not touch"
	line "it."
	done

RuinsF1MurumSwitch_Text_SwitchIsOff:
	ctxt "The switch is"
	line "already off."
	done

RuinsF1MurumSwitch_Text_TurnedSwitchOff:
	ctxt "Turned the switch"
	line "off."
	done

RuinsF1_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $1f, $12, 3, RUINS_OUTSIDE
	warp_def $1f, $13, 6, RUINS_OUTSIDE
	warp_def $1d, $3, 17, RUINS_B1F
	warp_def $9, $b, 1, RUINS_F2

	;xy triggers
	db 2
	xy_trigger 0, $6, $24, $0, RuinsF1Trap21, $0, $0
	xy_trigger 0, $b, $24, $0, RuinsF1Trap22, $0, $0

	;signposts
	db 1
	signpost 1, 31, SIGNPOST_READ, RuinsF1MurumSwitch

	;people-events
	db 5
	person_event SPRITE_P0, -3, -3, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 1, RuinsF1_Item_1, EVENT_RUINS_F1_ITEM_1
	person_event SPRITE_POKE_BALL, 2, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, RuinsF1_Item_2, EVENT_RUINS_F1_ITEM_2
	person_event SPRITE_PALETTE_PATROLLER, 22, 7, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_YELLOW, 2, 2, RuinsF1_PaletteYellow, EVENT_RUINS_F1_TRAINER_1
	person_event SPRITE_FAMICOM, 5, 38, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, RuinsF1Arrow, EVENT_0
	person_event SPRITE_POKE_BALL, 14, 25, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_DRAGONBREATH, 0, EVENT_GET_TM24
