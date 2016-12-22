Predef_StartBattle:
	call Function8c26d
	ld a, [rBGP]
	ld [wBGP], a
	ld a, [rOBP0]
	ld [wOBP0], a
	ld a, [rOBP1]
	ld [wOBP1], a
	call DelayFrame
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], 3
	jr .handleLoop

.loop
	jumptable FlashyTransitionJumptable
	call DelayFrame
.handleLoop
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop

	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a

	ld hl, UnknBGPals
	ld bc, 8 palettes
	xor a
	call ByteFill

	pop af
	ld [rSVBK], a

	ld a, %11111111
	ld [wBGP], a
	call DmgToCgbBGPals
	call DelayFrame
	xor a
	ld [wLCDCPointer], a
	ld [hLYOverridesStart], a
	ld [hLYOverridesEnd], a
	ld [hSCY], a

	ld a, $1
	ld [rSVBK], a
	ld hl, rIE
	res LCD_STAT, [hl]
	pop af
	ld [hVBlank], a
	jp DelayFrame

Function8c26d:
	callba AnchorBGMap
	call DelayFrame
	call FillOffscreenPortionOfBGMapWithTile60Attr0
	call UpdateSprites
	call DelayFrame
	call LoadTrainerBattlePokeballTiles
	ld b, 3
	call SafeCopyTilemapAtOnce
	ld a, SCREEN_HEIGHT_PX
	ld [hWY], a
	call DelayFrame
	xor a
	ld [hBGMapMode], a
	ld hl, wJumptableIndex
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	jp WipeLYOverrides

FillOffscreenPortionOfBGMapWithTile60Attr0:
	lb de, 1, 0
	call .FillOffscreenPortionOfBGMap
	lb de, 0, $60
.FillOffscreenPortionOfBGMap:
	ld a, d
	ld [rVBK], a
	ld hl, VBGMap0 + SCREEN_WIDTH
	lb bc, %11, rSTAT & $ff
	ld d, SCREEN_HEIGHT
.loop
	ld a, [$ff00+c]
	and b
	jr z, .loop
.waitHBlank
	ld a, [$ff00+c]
	and b
	jr nz, .waitHBlank
	ld a, e
	di
	rept BG_MAP_WIDTH - SCREEN_WIDTH
	ld [hli], a
	endr
	ei
	ld a, SCREEN_WIDTH
	add l
	ld l, a
	dec d
	jr nz, .loop
	ret

LoadTrainerBattlePokeballTiles:
; Load the tiles used in the Pokeball Graphic that fills the screen
; at the start of every Trainer battle.
	ld de, TrainerBattlePokeballTiles
	ld hl, VTiles1 tile $7e
	lb bc, BANK(TrainerBattlePokeballTiles), 2
	call Request2bpp

	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a

	ld de, TrainerBattlePokeballTiles
	ld hl, VTiles4 tile $7e
	lb bc, BANK(TrainerBattlePokeballTiles), 2
	call Request2bpp

	pop af
	ld [rVBK], a
	ret

TrainerBattlePokeballTiles:
INCBIN "gfx/overworld/trainer_battle_pokeball_tiles.2bpp"

FlashyTransitionJumptable:
	dw StartTrainerBattle_DetermineWhichAnimation ; 00

	; Animation 1: cave
	dw StartTrainerBattle_LoadPokeBallGraphics ; 01
	dw StartTrainerBattle_SetUpBGMap ; 02
	dw StartTrainerBattle_Flash ; 03
	dw StartTrainerBattle_Flash ; 04
	dw StartTrainerBattle_Flash ; 05
	dw StartTrainerBattle_NextScene ; 06
	dw StartTrainerBattle_SetUpForWavyOutro ; 07
	dw StartTrainerBattle_SineWave ; 08

	; Animation 2: cave, stronger
	dw StartTrainerBattle_LoadPokeBallGraphics ; 09
	dw StartTrainerBattle_SetUpBGMap ; 0a
	dw StartTrainerBattle_Flash ; 0b
	dw StartTrainerBattle_Flash ; 0c
	dw StartTrainerBattle_Flash ; 0d
	dw StartTrainerBattle_NextScene ; 0e
	; There is no setup for this one
	dw StartTrainerBattle_ZoomToBlack ; 0f

	; Animation 3: no cave
	dw StartTrainerBattle_LoadPokeBallGraphics ; 10
	dw StartTrainerBattle_SetUpBGMap ; 11
	dw StartTrainerBattle_Flash ; 12
	dw StartTrainerBattle_Flash ; 13
	dw StartTrainerBattle_Flash ; 14
	dw StartTrainerBattle_NextScene ; 15
	dw StartTrainerBattle_SetUpForSpinOutro ; 16
	dw StartTrainerBattle_SpinToBlack ; 17

	; Animation 4: no cave, stronger
	dw StartTrainerBattle_LoadPokeBallGraphics ; 18
	dw StartTrainerBattle_SetUpBGMap ; 19
	dw StartTrainerBattle_Flash ; 1a
	dw StartTrainerBattle_Flash ; 1b
	dw StartTrainerBattle_Flash ; 1c
	dw StartTrainerBattle_NextScene ; 1d
	dw StartTrainerBattle_SetUpForRandomScatterOutro ; 1e
	dw StartTrainerBattle_SpeckleToBlack ; 1f

	; Animation 5: gym leader, elite four, or champion
	dw StartTrainerBattle_LoadPokeBallGraphics ; 20
	dw StartTrainerBattle_SetUpBGMap ; 21
	dw StartTrainerBattle_Flash ; 22
	dw StartTrainerBattle_Flash ; 23
	dw StartTrainerBattle_Flash ; 24
	dw StartTrainerBattle_NextScene ; 25
	dw StartTrainerBattle_SetUpForTrainerPortrait ; 26
	dw StartTrainerBattle_LoadTrainerPortrait ; 27
	dw StartTrainerBattle_FadeToWhite ; 28

	; All animations jump to here.
	dw StartTrainerBattle_Finish ; 29

StartTrainerBattle_DetermineWhichAnimation:
; The screen flashes a different number of
; times depending on the level of your lead
; Pokemon relative to the opponent's.
	ld a, [OtherTrainerClass]
	and a
	jr z, .normal
	callba IsJohtoGymLeader
	jr nc, .normal
	ld a, $20
	ld [wJumptableIndex], a
	ret

.normal
	ld de, 0
	ld a, [BattleMonLevel]
	add 3
	ld hl, EnemyMonLevel
	cp [hl]
	jr nc, .okay
	set 0, e
.okay
	ld a, [wPermission]
	cp CAVE
	jr z, .okay2
	cp PERM_5
	jr z, .okay2
	cp DUNGEON
	jr z, .okay2
	set 1, e
.okay2
	ld hl, .StartingPoints
	add hl, de
	ld a, [hl]
	ld [wJumptableIndex], a
	ret

.StartingPoints
	db $01, $09
	db $10, $18

StartTrainerBattle_Finish:
	call ClearSprites
	ld a, $80
	ld [wJumptableIndex], a
	ret

StartTrainerBattle_SetUpBGMap:
	call StartTrainerBattle_NextScene
	xor a
	ld [wcf64], a
	ld [hBGMapMode], a
	ret

StartTrainerBattle_Flash:
	ld a, [wTimeOfDayPalset]
	cp %11111111 ; dark cave
	jr z, .done
	ld c, 1 << 7 | 3
	call FadeBGToDarkestColor
	ld c, 1 << 7 | 3
	call FadeOutBGPals

.done
	xor a
	ld [wcf64], a
	; fallthrough

StartTrainerBattle_NextScene:
	ld hl, wJumptableIndex
	inc [hl]
	ret

StartTrainerBattle_SetUpForWavyOutro:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	ld a, BANK(wLYOverrides)
	ld [rSVBK], a

	call StartTrainerBattle_NextScene

	ld a, rSCX & $ff
	ld [wLCDCPointer], a
	xor a
	ld [hLYOverridesStart], a
	ld a, $90
	ld [hLYOverridesEnd], a
	xor a
	ld [wcf64], a
	ld [wcf65], a
	ld hl, rIE
	set LCD_STAT, [hl]
	ret

StartTrainerBattle_SineWave:
	ld a, [wcf64]
	cp $60
	jr c, StartTrainerBattle_DoSineWave
	; fallthrough

StartTrainerBattle_EndScene:
	ld a, $29
	ld [wJumptableIndex], a
	ret

StartTrainerBattle_DoSineWave:
	ld hl, wcf65
	ld a, [hl]
	inc [hl]
	dec hl
	ld d, [hl]
	add [hl]
	ld [hl], a
	ld a, wLYOverridesEnd - wLYOverrides
	ld bc, wLYOverrides
	ld e, $0

.loop
	push af
	push de
	ld a, e
	call Sine
	ld [bc], a
	inc bc
	pop de
	ld a, e
	add $2
	ld e, a
	pop af
	dec a
	jr nz, .loop
	ret

StartTrainerBattle_SetUpForSpinOutro:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	ld a, BANK(wLYOverrides)
	ld [rSVBK], a
	call StartTrainerBattle_NextScene
	xor a
	ld [wcf64], a
	ret

spintable_entry: MACRO
	db \1
	dw .wedge\2
	dwcoord \3, \4
ENDM

; quadrants
	const_def
	const UPPER_LEFT
	const UPPER_RIGHT
	const LOWER_LEFT
	const LOWER_RIGHT

StartTrainerBattle_SpinToBlack:
	xor a
	ld d, a
	ld [hBGMapMode], a
	ld a, [wcf64]
	ld e, a
	ld hl, .spintable
rept 5
	add hl, de
endr
	ld a, [hli]
	cp -1
	jr z, .end
	ld [wcf65], a
	call .load
	ld a, $1
	ld [hBGMapMode], a
	call Delay2
	ld hl, wcf64
	inc [hl]
	ret

.end
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	jr StartTrainerBattle_EndScene

.spintable
	spintable_entry UPPER_LEFT,  1,  1,  6
	spintable_entry UPPER_LEFT,  2,  0,  3
	spintable_entry UPPER_LEFT,  3,  1,  0
	spintable_entry UPPER_LEFT,  4,  5,  0
	spintable_entry UPPER_LEFT,  5,  9,  0
	spintable_entry UPPER_RIGHT, 5, 10,  0
	spintable_entry UPPER_RIGHT, 4, 14,  0
	spintable_entry UPPER_RIGHT, 3, 18,  0
	spintable_entry UPPER_RIGHT, 2, 19,  3
	spintable_entry UPPER_RIGHT, 1, 18,  6
	spintable_entry LOWER_RIGHT, 1, 18, 11
	spintable_entry LOWER_RIGHT, 2, 19, 14
	spintable_entry LOWER_RIGHT, 3, 18, 17
	spintable_entry LOWER_RIGHT, 4, 14, 17
	spintable_entry LOWER_RIGHT, 5, 10, 17
	spintable_entry LOWER_LEFT,  5,  9, 17
	spintable_entry LOWER_LEFT,  4,  5, 17
	spintable_entry LOWER_LEFT,  3,  1, 17
	spintable_entry LOWER_LEFT,  2,  0, 14
	spintable_entry LOWER_LEFT,  1,  1, 11
	db -1

.load
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	push hl
	ld a, [de]
	ld c, a
	inc de
.loop1
	ld [hl], $ff
	ld a, [wcf65]
	rra
	jr nc, .leftside
	inc hl
	jr .okay1
.leftside
	dec hl
.okay1
	dec c
	jr nz, .loop1
	pop hl
	ld a, [wcf65]
	bit 1, a
	ld bc, SCREEN_WIDTH
	jr z, .upper
	ld bc, -SCREEN_WIDTH
.upper
	add hl, bc
	ld a, [de]
	inc de
	cp -1
	ret z
	and a
	jr z, .loop
	ld c, a
.loop2
	ld a, [wcf65]
	rra
	jr nc, .leftside2
	dec hl
	jr .okay2
.leftside2
	inc hl
.okay2
	dec c
	jr nz, .loop2
	jr .loop

.wedge1: db 2, 3, 5, 4, 9, -1
.wedge2: db 1, 1, 2, 2, 4, 2, 4, 2, 3, -1
.wedge3: db 2, 1, 3, 1, 4, 1, 4, 1, 4, 1, 3, 1, 2, 1, 1, 1, 1, -1
.wedge4: db 4, 1, 4, 0, 3, 1, 3, 0, 2, 1, 2, 0, 1, -1
.wedge5: db 4, 0, 3, 0, 3, 0, 2, 0, 2, 0, 1, 0, 1, 0, 1, -1

StartTrainerBattle_SetUpForRandomScatterOutro:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	ld a, BANK(wLYOverrides)
	ld [rSVBK], a
	call StartTrainerBattle_NextScene
	ld a, $10
	ld [wcf64], a
	ld a, $1
	ld [hBGMapMode], a
	ret

StartTrainerBattle_SpeckleToBlack:
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ld c, $c
.loop
	push bc
	call .BlackOutRandomTile
	pop bc
	dec c
	jr nz, .loop
	ret

.done
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	jp StartTrainerBattle_EndScene

.BlackOutRandomTile
.y_loop
	call Random
	cp SCREEN_HEIGHT
	jr nc, .y_loop
	ld b, a

.x_loop
	call Random
	cp SCREEN_WIDTH
	jr nc, .x_loop
	ld c, a

	hlcoord 0, -1
	ld de, SCREEN_WIDTH
	inc b

.row_loop
	add hl, de
	dec b
	jr nz, .row_loop
	add hl, bc

; If the tile has already been blacked out,
; sample a new tile
	ld a, [hl]
	cp $ff
	jr z, .y_loop
	ld [hl], $ff
	ret

waitHBlank: macro
.waitNo\@
	ld a, [rSTAT]
	and 3
	jr z, .waitNo\@
.wait\@
	ld a, [rSTAT]
	and 3
	jr nz, .wait\@
endm

StartTrainerBattle_SetUpForTrainerPortrait:
	call ClearSprites
	ld a, [OtherTrainerClass]
	ld [TrainerClass], a

; gfx stuff starts here

	ld a, $1
	ld [rVBK], a
	ld de, VTiles1
	callba GetTrainerPic_NoWaitBGMap

	xor a
	ld [hBGMapMode], a
	inc a
	ld [rVBK], a
	ld de, .VS_Graphic
	ld hl, VTiles1 tile $40
	lb bc, BANK(StartTrainerBattle_LoadTrainerPortrait), $40
	call Get2bpp

; tilemap stuff starts here

	xor a
	ld [rVBK], a
	hlbgcoord 20, 5
	ld bc, BG_MAP_WIDTH - 12
	lb de, 8, $7f
.bgloop
	call .fill12
	dec d
	jr nz, .bgloop

	hlbgcoord 20, 5
	ld bc, BG_MAP_WIDTH - 7
	lb de, 7, $80
	di
.trainerpicloop
	push de
	bit 0, e
	jr nz, .skipwait
	waitHBlank
.skipwait
	ld a, e
	rept 6
	ld [hli], a
	add d
	endr
	ld [hli], a
	add hl, bc
	pop de
	inc e
	ld a, e
	cp $87
	jr nz, .trainerpicloop
	ei

	callba Battle_GetTrainerName
	ld hl, wStringBuffer1
	ld c, 12
.findterminatorloop
	ld a, [hli]
	cp "@"
	jr z, .fillterminator
	dec c
	jr nz, .findterminatorloop
	jr .skipterminatorloop
.fillterminator
	ld a, " "
	dec hl
.fillterminatorloop
	ld [hli], a
	dec c
	jr nz, .fillterminatorloop
.skipterminatorloop
	hlbgcoord 20, 12
	di
	ld [hSPBuffer], sp
	ld sp, wStringBuffer1
	pop bc
	pop de
	waitHBlank
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	rept 3
	pop de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	endr
	pop de
	ld a, e
	ld [hli], a
	ld [hl], d
	ld a, [hSPBuffer]
	ld l, a
	ld a, [hSPBuffer + 1]
	ld h, a
	ld sp, hl
	ei

; attrmap stuff starts here

	ld a, $1
	ld [rVBK], a
	hlbgcoord 20, 5
	ld bc, BG_MAP_WIDTH - 12
	lb de, 7, $e
.bgattrloop
	call .fill12
	dec d
	jr nz, .bgattrloop
	ld e, $6
	call .fill12
	xor a
	ld [rVBK], a

; palette stuff starts here

	ld e, 0
	callba LoadMonOrTrainerPals

	ld a, [rSVBK]
	push af
	ld a, BANK(UnknBGPals)
	ld [rSVBK], a
	ld hl, .Palette
	ld de, OBPals
	ld bc, 1 palettes
	rst CopyBytes
	ld hl, UnknBGPals
	ld de, BGPals + 6 palettes
	ld bc, 1 palettes
	rst CopyBytes
	pop af
	ld [rSVBK], a

	ld a, $1
	ld [hCGBPalUpdate], a
	jp StartTrainerBattle_NextScene

.fill12
	di
	waitHBlank
	ld a, e
	rept 12
	ld [hli], a
	endr
	add hl, bc
	reti

.VS_Graphic: INCBIN "gfx/battle/vs_gfx.w64.interleave.2bpp"
.Palette:
	RGB 31, 31, 31
	RGB 08, 19, 28
	RGB 31, 06, 06
	RGB 00, 00, 00

VS_TIME                  EQU 255
VS_POS_X                 EQU 25
VS_POS_Y                 EQU 56
VS_SHAKE_RADIUS_INIT     EQU 20
VS_SHAKE_RADIUS          EQU 3
VS_SHAKE_RATE            EQU 2
VS_SCROLL_RATE           EQU 11

polarstruct: macro
	db (ATAN2(\1, \2) >> 24) % $100
	db \3 ; sqrt(\1 ** 2 + \2 ** 2) * 4
endm

VSInitPolarPos:
	polarstruct -24.0, -28.0, 148
	polarstruct -24.0, -20.0, 125
	polarstruct -24.0, -12.0, 107
	polarstruct -24.0,  -4.0, 97
	polarstruct -24.0,   4.0, 97
	polarstruct -24.0,  12.0, 107
	polarstruct -24.0,  20.0, 125
	polarstruct -24.0,  28.0, 148
	polarstruct  -8.0, -28.0, 116
	polarstruct  -8.0, -20.0, 86
	polarstruct  -8.0, -12.0, 58
	polarstruct  -8.0,  -4.0, 36
	polarstruct  -8.0,   4.0, 36
	polarstruct  -8.0,  12.0, 58
	polarstruct  -8.0,  20.0, 86
	polarstruct  -8.0,  28.0, 116
	polarstruct   8.0, -28.0, 116
	polarstruct   8.0, -20.0, 86
	polarstruct   8.0, -12.0, 58
	polarstruct   8.0,  -4.0, 36
	polarstruct   8.0,   4.0, 36
	polarstruct   8.0,  12.0, 58
	polarstruct   8.0,  20.0, 86
	polarstruct   8.0,  28.0, 116
	polarstruct  24.0, -28.0, 148
	polarstruct  24.0, -20.0, 125
	polarstruct  24.0, -12.0, 107
	polarstruct  24.0,  -4.0, 97
	polarstruct  24.0,   4.0, 97
	polarstruct  24.0,  12.0, 107
	polarstruct  24.0,  20.0, 125
	polarstruct  24.0,  28.0, 148

StartTrainerBattle_LoadTrainerPortrait:
	xor a
	ld [rLYC], a
	ld hl, rLCDC
	set 2, [hl] ; 8x16 sprites
	ld a, BANK(wLYOverrides)
	ld [rSVBK], a
	ld a, $5
	ld [hBGMapMode], a
	dec a ; ld a, $4
	ld [hBGMapHalf], a
	ld a, 10
	ld [hTilesPerCycle], a
	ld a, 40
	ld [wcf64], a

; background swipe + imploding vs

	hlbgcoord 0, 4
	ld e, 20
.initswipeloop
	push de
	push hl
	call .updatevs
	call StartTrainerBattle_UpdateScroll
	call DelayFrame
	pop hl
	push hl
	ld bc, (TileMap + SCREEN_WIDTH * 4) - (VBGMap0 + BG_MAP_WIDTH * 4)
	add hl, bc
	ld bc, SCREEN_WIDTH
	lb de, $7a, $7f
	call .copy9nowait
	ld [hl], $7a
	ld bc, BG_MAP_WIDTH
	pop hl
	push hl
	lb de, $7a, $7f
	call .copy9
	ld [hl], $7a

; attr map time
	ld a, 1
	ld [rVBK], a
	pop hl
	push hl
	lb de, $6, $6
	call .copy9
	ld [hl], $46
	xor a
	ld [rVBK], a
	ld hl, wcf64
	dec [hl]
	pop hl
	inc hl
	pop de
	dec e
	jr nz, .initswipeloop

; slide in trainer pic and name

	xor a
	ld hl, wcf66
	ld [hli], a
	ld [hl], a
	ld a, 40
	ld [rLYC], a
	ld a, 1 << 6 ; LYC interrupt
	ld [rSTAT], a
	di
	ld hl, LCD_VSTrick
	ld de, LCD
	ld bc, LCD_VSTrickEnd - LCD_VSTrick
	rst CopyBytes
	ei
	ld hl, rIE
	set LCD_STAT, [hl]
	ld e, 20
.slideinloop
	push de
	ld hl, wcf66
	ld a, [hl]
	add 3
	ld [hli], a
	ld a, [hl]
	sub 8
	ld [hl], a
	call .updatevs
.notdoneyet
	call StartTrainerBattle_UpdateScroll
	jr nc, .notdoneyet
	pop de
	ld a, e
	dec a ; don't delay the last frame
	call nz, DelayFrame
	ld hl, wcf64
	dec [hl]
	dec e
	jr nz, .slideinloop

	ld a, VS_TIME
	ld [wcf64], a
	jp StartTrainerBattle_NextScene

.copy9
	waitHBlank
.copy9nowait
	ld [hl], d
	add hl, bc
	rept 8
	ld [hl], e
	add hl, bc
	endr
	ret
	

.calcimplode
	ld hl, wcf65
	call GetDemoSine
	bit 7, a
	ld [hl], 0
	jr z, .notminus
	inc [hl]
	cpl
.notminus
	ld hl, 0
	ld b, l
	rst AddNTimes
	ld c, h
	ld h, b
	ld l, b
	ld a, [wcf64]
	add 4
	rst AddNTimes
	rept 3
	srl h
	rr l
	endr
	ret

.updatevs
	ld c, 32
	ld hl, VSInitPolarPos
	ld de, Sprites
.vsupdateloop
	call StartTrainerBattle_UpdateScroll
	push bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld a, [wcf64]
	add a
	add a
	add b
	ld b, a
	push bc
	call .calcimplode
	ld a, h
	and a
	jr nz, .over1
	ld a, [wcf65]
	and a
	ld a, VS_POS_Y + 24
	jr nz, .sub1
	add l
	jr c, .over1
	jr .skip1
.sub1
	sub l
	jr nc, .skip1
.over1
	xor a
.skip1
	ld [de], a
	inc de
	pop bc
	ld a, b
	add 64 ; turn into cos
	call .calcimplode
	ld a, h
	and a
	jr nz, .over2
	ld a, [wcf65]
	and a
	ld a, VS_POS_X + 28
	jr nz, .sub2
	add l
	jr c, .over2
	jr .skip2
.sub2
	sub l
	jr nc, .skip2
.over2
	xor a
.skip2
	ld [de], a
	inc de
	pop hl
	pop bc
	ld a, $80
	sub c
	add a
	ld [de], a
	inc de
	ld a, $8
	ld [de], a
	inc de
	dec c
	jr nz, .vsupdateloop
	ret

StartTrainerBattle_UpdateScroll:
	ld a, [rLYC]
	and a
	ret z
	ld b, a
	ld a, [rLY]
	cp b
	jr nc, .scrolled
.retnocarry
	xor a
	ret
.scrolled
	cp 40 ; start of trainer pic
	jr nc, .gt40
	ld a, 40
	ld [rLYC], a
	ld a, [wcf66]
	ld [wLYOverrides], a
	jr .retnocarry
.gt40
	cp 96 ; start of trainer name
	jr nc, .gt96
	ld a, 96
	ld [rLYC], a
	ld a, [wcf67]
	ld [wLYOverrides], a
	jr .retnocarry
.gt96
	cp 104 ; end of trick
	jr nc, .gt104
	ld a, 104
	ld [rLYC], a
	xor a
	ld [wLYOverrides], a
	jr .retnocarry
.gt104
	xor a
	ld [wLYOverrides], a
	inc a
	ld [rLYC], a
	scf
	ret

StartTrainerBattle_LoadPokeBallGraphics:
	ld a, [OtherTrainerClass]
	and a
	jp z, StartTrainerBattle_NextScene ; don't need to be here if wild

	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	inc b
	inc c
	jr .handleLoop

.loop
; set all pals to 7
	ld a, [hl]
	or %00000111
	ld [hli], a
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop

	ld de, PokeBallTransition
	hlcoord 2, 1

	ld b, SCREEN_WIDTH - 4
.loop2
	push hl
	ld c, 2
.loop3
	push hl
	ld a, [de]
	inc de
.loop4
; Loading is done bit by bit
	and a
	jr z, .done
	sla a
	jr nc, .no_load
	ld [hl], $fe
.no_load
	inc hl
	jr .loop4

.done
	pop hl
	push bc
	ld bc, (SCREEN_WIDTH - 4) / 2
	add hl, bc
	pop bc
	dec c
	jr nz, .loop3

	pop hl
	push bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop2

	ld hl, .daypals
	ld a, [TimeOfDayPal]
	and (1 << 2) - 1
	cp 3
	jr nz, .daytime
	ld hl, .nightpals
.daytime
	ld a, [rSVBK]
	push af
	ld a, $5 ; WRAM5 = palettes
	ld [rSVBK], a
	call .copypals
	push hl
	ld de, UnknBGPals + 7 palettes
	ld bc, 1 palettes
	rst CopyBytes
	pop hl
	ld de, BGPals + 7 palettes
	ld bc, 1 palettes
	rst CopyBytes
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	call DelayFrame
	call CopyTilemapAtOnce
	jp StartTrainerBattle_NextScene

.copypals
	ld de, UnknBGPals + 7 palettes
	call .copy
	ld de, BGPals + 7 palettes

.copy
	push hl
	ld bc, 1 palettes
	rst CopyBytes
	pop hl
	ret

.daypals
	RGB 31, 18, 29
	RGB 31, 11, 15
	RGB 31, 05, 05
	RGB 07, 07, 07

.nightpals
	RGB 31, 18, 29
	RGB 31, 05, 05
	RGB 31, 05, 05
	RGB 31, 05, 05

PokeBallTransition:
	db %00000011, %11000000
	db %00001111, %11110000
	db %00111100, %00111100
	db %00110000, %00001100
	db %01100000, %00000110
	db %01100011, %11000110
	db %11000110, %01100011
	db %11111100, %00111111
	db %11111100, %00111111
	db %11000110, %01100011
	db %01100011, %11000110
	db %01100000, %00000110
	db %00110000, %00001100
	db %00111100, %00111100
	db %00001111, %11110000
	db %00000011, %11000000

WipeLYOverrides:
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a

	ld hl, wLYOverrides
	call .wipe
	ld hl, LYOverridesBackup
	call .wipe

	pop af
	ld [rSVBK], a
	ret

.wipe
	xor a
	ld c, SCREEN_HEIGHT_PX
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

zoombox: macro
; width, height, start y, start x
	db \1, \2
	dwcoord \3, \4
endm

StartTrainerBattle_FadeToWhite:
	ld a, [wcf64]
	cp VS_TIME
	jr z, .first_frame
	cp 65
	call c, .fade2white
	ld hl, wcf68
	dec [hl]
	jr nz, .skipshake
	ld a, VS_SHAKE_RATE
	ld [hl], a
	call Random
	ld c, a
	call GetDemoSine
	bit 7, a
	ld b, 0
	jr z, .notminus
	ld b, $ff
.notminus
	ld c, a
	ld a, [wcf65]
	ld hl, 0
	call AddNTimes
	ld a, VS_POS_Y
	add h
	ld d, a
	ld a, c
	add 64 ; turn into cos
	call GetDemoSine
	bit 7, a
	ld b, 0
	jr z, .notminus2
	ld b, $ff
.notminus2
	ld c, a
	ld a, [wcf65]
	ld hl, 0
	call AddNTimes
	ld a, VS_POS_X
	add h
	ld e, a
	call .position_vs
	ld a, [wcf65]
	cp VS_SHAKE_RADIUS
	jr z, .skipshake
	dec a
	ld [wcf65], a
.skipshake
	ld hl, wcf69
	dec [hl]
	jr nz, .skipscroll
	ld a, VS_SCROLL_RATE
	ld [hl], a
	ld hl, wcf66
	inc [hl]
	inc hl
	dec [hl]
.skipscroll
	jr .notdoneyet
.first_frame
	ld a, 1
	ld [wcf68], a
	ld a, VS_SCROLL_RATE
	ld [wcf69], a
	ld a, VS_SHAKE_RADIUS_INIT
	ld [wcf65], a
	lb de, VS_POS_Y, VS_POS_X
	call .position_vs
.notdoneyet
	call StartTrainerBattle_UpdateScroll
	jr nc, .notdoneyet
	ld hl, wcf64
	dec [hl]
	ret nz

	ld hl, rLCDC
	res 2, [hl] ; 8x8 sprites
	xor a
	ld [rLYC], a
	ld a, 1 << 3 ; HBlank interrupt
	ld [rSTAT], a
	ld c, 15
	call DelayFrames
	ld a, $29
	ld [wJumptableIndex], a
	jp LoadLCDCode

.fade2white
	rra
	ld hl, BGPals
	jr nc, .bgp
	ld hl, OBPals
	ld a, 1
	ld [hCGBPalUpdate], a
.bgp
	ld d, 32
.loop2
	call StartTrainerBattle_UpdateScroll
	ld a, [hl]
	and $1f
	cp $1f
	jr z, .skip
	inc a
.skip
	ld c, a
	inc hl
	ld a, [hld]
	and $3
	ld b, a
	ld a, [hl]
	and $e0
	or b
	cp $e3
	jr z, .skip2
	and $e0
	add $20
	jr nc, .skip2
	inc b
.skip2
	or c
	ld [hli], a
	ld a, [hl]
	and $7c
	cp $7c
	jr z, .skip3
	add $4
.skip3
	or b
	ld [hli], a
	dec d
	jr nz, .loop2
	ret

.position_vs
	call StartTrainerBattle_UpdateScroll
	ld hl, Sprites
	ld b, 4
.ploop
	push de
	ld c, 8
.ploop2
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	inc hl
	inc hl
	ld a, e
	add 8
	ld e, a
	dec c
	jr nz, .ploop2
	pop de
	ld a, d
	add 16
	ld d, a
	dec b
	jr nz, .ploop
	ret

StartTrainerBattle_ZoomToBlack:
	callba BattleStart_HideAllSpritesExceptBattleParticipants
	ld de, .boxes
	jr .handleLoop
.loop
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	xor a
	ld [hBGMapMode], a
	dec a
	call FillBoxWithByte
	call ApplyTilemapInVBlank
.handleLoop
	ld a, [de]
	cp -1
	jr nz, .loop
	jp StartTrainerBattle_EndScene

.boxes
	zoombox  4,  2,  8, 8
	zoombox  6,  4,  7, 7
	zoombox  8,  6,  6, 6
	zoombox 10,  8,  5, 5
	zoombox 12, 10,  4, 4
	zoombox 14, 12,  3, 3
	zoombox 16, 14,  2, 2
	zoombox 18, 16,  1, 1
	zoombox 20, 18,  0, 0
	db -1

.Copy
	ld a, $ff
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret
