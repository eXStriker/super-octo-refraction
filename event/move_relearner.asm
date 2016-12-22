MoveRelearner:
	ld a, HEART_SCALE
	ld [wCurItem], a
	ld hl, NumItems
	call CheckItem
	jp nc, .cancel
	ld hl, .IntroText
	call PrintText
	call YesNoBox
	jp c, .cancel
	ld hl, .WhichMonText
	call PrintText
	call JoyWaitAorB

	ld b, $6
	callba SelectMonFromParty
	jr c, .cancel

	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg

	call IsAPokemon
	jr c, .no_mon


	call GetRelearnableMoves
	jr z, .no_moves

.menuloop
	ld hl, .WhichMoveText
	call PrintText
	call JoyWaitAorB
	call ChooseMoveToLearn
	jr c, .cancelMoveLearn

	ld a, [wMenuSelection]
	ld [wd265], a
	call GetMoveName
	ld de, wStringBuffer1
	call CopyName1
	ld b, 0
	predef LearnMove
	ld a, b
	and a
	push af
	call CloseSubmenu
	call SpeechTextBox
	pop af
	jr z, .reloadmenu
	
	ld a, HEART_SCALE
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, NumItems
	call TossItem

	ld hl, .HandedOverOneHeartScaleText
	call PrintText
	call JoyWaitAorB

.cancel
	ld hl, .ComeAgainText
	jp PrintText

.reloadmenu
	jp .menuloop
	
.cancelMoveLearn
	call CloseSubmenu
	jr .cancel

.egg
	ld hl, .EggText
	jp PrintText

.no_mon
	ld hl, .NotMonText
	jp PrintText

.no_moves
	ld hl, .NoMovesToLearnText
	jp PrintText

.IntroText
	text_jump MoveRelearner_IntroText

.WhichMonText
	text_jump MoveRelearner_WhichMonText

.WhichMoveText
	text_jump MoveRelearner_WhichMoveText

.HandedOverOneHeartScaleText
	text_jump MoveRelearner_HandedOverOneHeartScaleText

.ComeAgainText
	text_jump MoveRelearner_ComeAgainText

.EggText
	text_jump MoveRelearner_EggText

.NotMonText
	text_jump MoveRelearner_NotMonText

.NoMovesToLearnText
	text_jump MoveRelearner_NoMovesToLearnText

GetRelearnableMoves:
	; Get moves relearnable by CurPartyMon
	; Returns z if no moves can be relearned.
	ld hl, wd002
	xor a
	ld [hli], a
	ld [hl], $ff
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartySpecies], a
	push af
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [CurPartyLevel], a
	ld b, 0
	ld de, wd002 + 1
.loop
	push bc
	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarHalfword
.skip_evos
	ld a, BANK(EvosAttacks)
	call GetFarByteAndIncrement
	and a
	jr nz, .skip_evos
.loop_moves
	ld a, BANK(EvosAttacks)
	call GetFarByteAndIncrement
	and a
	jr z, .done

	ld c, a
	ld a, [CurPartyLevel]
	cp c
	jr c, .done
	ld a, BANK(EvosAttacks)
	call GetFarByteAndIncrement
.okay
	ld c, a
	call CheckAlreadyInList
	jr c, .loop_moves
	call CheckPokemonAlreadyKnowsMove
	jr c, .loop_moves
	ld a, c
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	pop bc
	inc b
	push bc
	jr .loop_moves
.done
	callba GetPreEvolution
	pop bc
	jr c, .loop
	pop af
	ld [wCurPartySpecies], a
	ld a, b
	ld [wd002], a
	and a
	ret

CheckAlreadyInList:
	push hl
	push de
	push bc
	ld a, c
	ld hl, wd002 + 1
	call IsInSingularArray
	pop bc
	pop de
	pop hl
	ret

CheckPokemonAlreadyKnowsMove:
	; Check if move c is in the selected pokemon's movepool already.
	; Returns carry if yes.
	push hl
	push bc
	ld a, MON_MOVES
	call GetPartyParamLocation
	ld b, NUM_MOVES
.loop
	ld a, [hli]
	cp c
	jr z, .yes
	dec b
	jr nz, .loop
	and a
	jr .done
.yes
	scf
.done
	pop bc
	pop hl
	ret

ChooseMoveToLearn:
; Open a full-screen scrolling menu
; Number of items stored in wd002
; List of items stored in wd002 + 1
; Print move names, PP, details, and descriptions
; Enable Up, Down, A, and B
; Up scrolls up
; Down scrolls down
; A confirms selection
; B backs out
	call FadeToMenu
	callba BlankScreen
	call UpdateSprites
	ld hl, .MenuDataHeader
	call CopyMenuDataHeader
	xor a
	ld [wMenuCursorBuffer], a
	ld a, 1
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	call SpeechTextBox
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .carry
	ld a, [wMenuSelection]
	ld [wPutativeTMHMMove], a
	and a
	ret

.carry
	scf
	ret

.MenuDataHeader
	db $40 ; flags
	db 01, 01 ; start coords
	db 11, 19 ; end coords
	dw .menudata2
	db 1 ; default option

.menudata2
	db $30 ; pointers
	db 5, 8 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wd002
	dba .PrintMoveName
	dba .PrintDetails
	dba .PrintMoveDesc

.PrintMoveName
	push de
	ld a, [wMenuSelection]
	ld [wd265], a
	call GetMoveName
	pop hl
	jp PlaceString

.PrintDetails
	ld hl, wStringBuffer1
	ld bc, wStringBuffer2 - wStringBuffer1
	ld a, " "
	call ByteFill
	ld a, [wMenuSelection]
	cp $ff
	ret z
	push de
	dec a
	ld bc, MOVE_LENGTH
	ld hl, Moves + MOVE_TYPE
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld [wd265], a
	; get move type
	and $3f
	; 5 characters
	ld c, a
	add a
	add a
	add c
	ld c, a
	ld b, 0
	ld hl, .Types
	add hl, bc
	ld d, h
	ld e, l

	ld hl, wStringBuffer1
	call PlaceString
	ld hl, wStringBuffer1 + 4
	ld [hl], "/"
	; get move class
	ld a, [wd265]
	and $c0
	rlca
	rlca
	ld c, a
	add a
	add a
	add c
	ld c, a
	ld b, 0
	ld hl, .Classes
	add hl, bc
	ld d, h
	ld e, l

	ld hl, wStringBuffer1 + 5
	call PlaceString
	ld hl, wStringBuffer1 + 9
	ld [hl], "/"

	ld a, [wMenuSelection]
	dec a
	ld bc, MOVE_LENGTH
	ld hl, Moves + MOVE_PP
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld [EngineBuffer1], a
	ld hl, wStringBuffer1 + 10
	ld de, EngineBuffer1
	lb bc, 1, 2
	call PrintNum
	ld hl, wStringBuffer1 + 12
	ld [hl], "@"

	ld hl, SCREEN_WIDTH - 5
	pop de
	add hl, de
	push de
	ld de, wStringBuffer1
	call PlaceString
	pop de
	ret

.Types
	db "Norm@"
	db "Figh@"
	db " Fly@"
	db "Pois@"
	db "Grnd@"
	db "Rock@"
	db "Bird@"
	db " Bug@"
	db "Ghst@"
	db " Stl@"
	db " Fry@"

	db " Gas@"
	db "Wind@"
	db " Snd@"
	db " Tri@"
	db "Prsm@"
	db "Tp16@"
	db "Tp17@"
	db "Tp18@"
	db "Crse@"

	db "Fire@"
	db "Watr@"
	db "Gras@"
	db "Elec@"
	db "Psyc@"
	db " Ice@"
	db "Drgn@"
	db "Dark@"
.Classes
	db "Phys@"
	db "Spec@"
	db "Stat@"

.PrintMoveDesc
	push de
	call SpeechTextBox
	ld a, [wMenuSelection]
	cp $ff
	pop de
	ret z
	ld [wCurSpecies], a
	hlcoord 1, 14
	jpba PrintMoveDesc
