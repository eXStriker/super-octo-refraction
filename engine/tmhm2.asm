TMHMPocket:
	ld a, $1
	ld [hInMenu], a
	call TMHM_PocketLoop
	ld a, $0
	ld [hInMenu], a
	ret nc
	call PlaceHollowCursor
	call ApplyTilemapInVBlank
	ld a, [wCurItem]
	dec a
	ld [wCurItemQuantity], a
	ld hl, TMsHMs
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wItemQuantityBuffer], a
	scf
	ret

AskTeachTMHM:
	ld hl, wOptions
	ld a, [hl]
	push af
	res NO_TEXT_SCROLL, [hl]
	ld a, [wCurItem]
	ld [wd265], a
	predef GetTMHMMove
	ld a, [wCurTMHM]
	ld [wPutativeTMHMMove], a
	call GetMoveName
	call CopyName1
	ld hl, Text_BootedTM ; Booted up a TM
	ld a, [wCurItem]
	cp HM01
	jr c, .TM
	ld hl, Text_BootedHM ; Booted up an HM
.TM
	call PrintText
	ld hl, Text_ItContained
	call PrintText
	call YesNoBox
	pop bc
	ld a, b
	ld [wOptions], a
	ret

ChooseMonToLearnTMHM:
	ld hl, wStringBuffer2
	ld de, wTMHMMoveNameBackup
	ld bc, 12
	rst CopyBytes
	call ClearBGPalettes
ChooseMonToLearnTMHM_NoRefresh:
	callba LoadPartyMenuGFX
	callba InitPartyMenuWithCancel
	callba InitPartyMenuGFX
	ld a, $3 ; TeachWhichPKMNString
	ld [wPartyMenuActionText], a
.loopback
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call ApplyTilemapInVBlank
	call SetPalettes
	call DelayFrame
	callba PartyMenuSelect
	push af
	ld a, [wCurPartySpecies]
	cp EGG
	pop bc ; now contains the former contents of af
	jr z, .egg
	push bc
	ld hl, wTMHMMoveNameBackup
	ld de, wStringBuffer2
	ld bc, 12
	rst CopyBytes
	pop af ; now contains the original contents of af
	ret

.egg
	push hl
	push de
	push bc
	push af
	ld de, SFX_WRONG
	call PlayWaitSFX
	pop af
	pop bc
	pop de
	pop hl
	jr .loopback

TeachTMHM:
	predef CanLearnTMHMMove

	push bc
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	pop bc

	ld a, c
	and a
	jr nz, .compatible
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld hl, Text_TMHMNotCompatible
	call PrintText
	jr .nope

.compatible
	call KnowsMove
	jr c, .nope

	predef LearnMove
	ld a, b
	and a
	jr z, .nope

	ld a, [wCurItem]
	call IsHM
	ret c

	ld c, HAPPINESS_LEARNMOVE
	callba ChangeHappiness
.learned_move
	scf
	ret
.nope
	and a
	ret

Text_BootedTM:
	; Booted up a TM.
	text_jump UnknownText_0x1c0373

Text_BootedHM:
	; Booted up an HM.
	text_jump UnknownText_0x1c0384

Text_ItContained:
	; It contained @ . Teach @ to a #mon?
	text_jump UnknownText_0x1c0396

Text_TMHMNotCompatible:
	; is not compatible with @ . It can't learn @ .
	text_jump UnknownText_0x1c03c2

TMHM_PocketLoop:
	xor a
	ld [hBGMapMode], a
	call TMHM_DisplayPocketItems
	ld a, 2
	ld [w2DMenuCursorInitY], a
	dec a
	ld [w2DMenuNumCols], a
	ld a, 7
	ld [w2DMenuCursorInitX], a
	dec a
	sub d
	cp 6
	jr nz, .okay
	dec a
.okay
	ld [w2DMenuNumRows], a
	ld a, $c
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	ld a, $20
	ld [w2DMenuCursorOffsets], a
	ld a, A_BUTTON | B_BUTTON | D_UP | D_DOWN | D_LEFT | D_RIGHT
	ld [wMenuJoypadFilter], a
	ld a, [wTMHMPocketCursor]
	inc a
	ld [wMenuCursorY], a
	ld a, $1
	ld [wMenuCursorX], a
	jr TMHM_ShowTMMoveDescription

TMHM_JoypadLoop:
	call DoMenuJoypadLoop
	ld b, a
	ld a, [wMenuCursorY]
	dec a
	ld [wTMHMPocketCursor], a
	xor a
	ld [hBGMapMode], a
	ld a, [w2DMenuFlags2]
	bit 7, a
	jr nz, TMHM_ScrollPocket
	ld a, b
	ld [wMenuJoypad], a
	bit A_BUTTON_F, a
	jr nz, TMHM_ChooseTMorHM
	bit B_BUTTON_F, a
	jr nz, TMHM_ExitPack
	bit D_RIGHT_F, a
	jr nz, TMHM_ExitPocket
	bit D_LEFT_F, a
	jr nz, TMHM_ExitPocket
TMHM_ShowTMMoveDescription:
	hlcoord 0, 12
	lb bc, 4, SCREEN_WIDTH - 2
	call TextBox
	call TMHM_CheckHoveringOverCancel
	jr nc, TMHM_JoypadLoop
	call TMHM_GetCurrentTMFromCursorPosition
	inc c
	ld a, c
	ld [wd265], a
	ld [wCurItem], a
	predef GetTMHMMove
	ld a, [wd265]
	ld [wCurSpecies], a
	hlcoord 1, 14
	call PrintMoveDesc
	jr TMHM_JoypadLoop

TMHM_ChooseTMorHM:
	call TMHM_PlaySFX_ReadText2
	call TMHM_CheckHoveringOverCancel
	jr nc, _TMHM_ExitPack ; our cursor was hovering over CANCEL
	ret

TMHM_CheckHoveringOverCancel:
	push de
	call CountTMsHMs
	ld a, [wMenuCursorY]
	ld b, a
	ld a, [wTMHMPocketScrollPosition]
	add b
	dec a
	cp c
	pop de
	ret

TMHM_ExitPack:
	call TMHM_PlaySFX_ReadText2
_TMHM_ExitPack:
	ld a, $2
	ld [wMenuJoypad], a
TMHM_ExitPocket:
	and a
	ret

TMHM_ScrollPocket:
	ld a, b
	bit 7, a
	jr nz, .skip
	ld hl, wTMHMPocketScrollPosition
	ld a, [hl]
	and a
	jp z, TMHM_JoypadLoop
	dec [hl]
.done
	call TMHM_DisplayPocketItems
	jr TMHM_ShowTMMoveDescription

.skip
	call TMHM_CheckHoveringOverCancel
	jp z, TMHM_JoypadLoop
	ret nc

	ld hl, wTMHMPocketScrollPosition
	inc [hl]
	jr .done

GetBit:
; e: Bitmask
; hl: address
; returns bit in a
	ld a, e
	and a
	jr nz, .dontIncrease
	inc hl
	ld e, 1
.dontIncrease
	ld a, [hl]
	and e
	sla e
	ret

GetNthTMInBag:
	push bc
	ld e, c
	ld d, 0
	ld b, CHECK_FLAG
	ld hl, TMsHMs
	call BigFlagAction
	ld e, c
	pop bc
	ret

TMHM_DisplayPocketItems:
	hlcoord 5, 2
	lb bc, 10, 15
	ld a, " "
	call ClearBox
	call TMHM_GetCurrentTMFromPocketPosition
	call GetNthTMInBag
	ld d, $5
.loop2
	ld a, c
	cp NUM_TMS + NUM_HMS + 1
	jr nc, .NotTMHM
	inc c

	call GetBit
	and a
	jr z, .loop2
	ld b, a
	ld a, c
	ld [wd265], a
	push hl
	push de
	push bc
	call TMHMPocket_GetCurrentLineCoord
	push hl
	ld a, [wd265]
	cp NUM_TMS + 1
	jr nc, .HM
	ld de, wd265
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	jr .okay

.HM
	push af
	sub NUM_TMS
	ld [wd265], a
	ld [hl], "H"
	inc hl
	ld de, wd265
	lb bc, PRINTNUM_RIGHTALIGN | 1, 2
	call PrintNum
	pop af
	ld [wd265], a
.okay
	predef GetTMHMMove
	ld a, [wd265]
	ld [wPutativeTMHMMove], a
	call GetMoveName
	pop hl
	ld bc, 3
	add hl, bc
	push hl
	call PlaceString
	pop hl
	pop bc
	ld a, c
	push bc
	cp NUM_TMS + 1
	jr nc, .hm2
	pop bc
	push bc
.hm2
	pop bc
	pop de
	pop hl
	dec d
	jr nz, .loop2
	ret

.NotTMHM
	call TMHMPocket_GetCurrentLineCoord
	inc hl
	inc hl
	inc hl
	push de
	ld de, TMHM_String_Cancel
	call PlaceString
	ld a, $ff
	ld [wCurItem], a
	pop de
	ret

TMHMPocket_GetCurrentLineCoord:
	hlcoord 5, 0
	ld bc, 2 * SCREEN_WIDTH
	ld a, 6
	sub d
	rst AddNTimes
	ret

TMHM_String_Cancel:
	db "Cancel@"

TMHM_GetCurrentTMFromCursorPosition:
	push de
	ld a, [wTMHMPocketScrollPosition]
	ld d, a
	ld a, [wMenuCursorY]
	add d
	jr TMHM_GetCurrentTM

TMHM_GetCurrentTMFromPocketPosition:
	push de
	ld a, [wTMHMPocketScrollPosition]
	inc a
TMHM_GetCurrentTM:
	ld d, a
	ld hl, TMsHMs
	ld c, -1
	jr .handleLoop
.outerLoop
	jr nc, .noDecrement
	dec d
	jr z, .done
.noDecrement
	ld a, b
	add c
	ld c, a
.handleLoop
	ld b, $8
	ld a, [hli]
.innerLoop
	inc c
	dec b
	srl a
	jr z, .outerLoop
	jr nc, .innerLoop
	dec d
	jr nz, .innerLoop
.done
	pop de
	ret

Tutorial_TMHMPocket:
	hlcoord 9, 3
	push de
	ld de, TMHM_String_Cancel
	call PlaceString
	pop de
	ret

TMHM_PlaySFX_ReadText2:
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

.CheckHaveRoomForTMHM
	ld a, [wd265]
	dec a
	ld hl, TMsHMs
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	inc a
	cp NUM_TMS * 2
	ret nc
	ld [hl], a
	ret

CountTMsHMs:
	push de
	ld b, TMsHMsEnd - TMsHMs
	ld hl, TMsHMs
	call CountSetBits
	pop de
	ret

PrintMoveDesc:
	push hl
	ld hl, MoveDescriptions
	ld a, [wCurSpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	jp PlaceText

KnowsMove:
	ld a, MON_MOVES
	call GetPartyParamLocation
	ld a, [wPutativeTMHMMove]
	ld b, a
	ld c, NUM_MOVES
.loop
	ld a, [hli]
	cp b
	jr z, .knows_move
	dec c
	jr nz, .loop
	and a
	ret

.knows_move
	ld hl, .Text_knows
	call PrintText
	scf
	ret

.Text_knows
	; knows @ .
	text_jump UnknownText_0x1c5ea8

TMHMLearnsets: INCLUDE "data/tmhmlearnsets.asm"
