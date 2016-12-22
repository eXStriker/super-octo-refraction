TrainerCard:
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	ld hl, wOptions
	ld a, [hl]
	push af
	set 4, [hl]
	call .InitRAM
	jr .handleLoop
.loop
	jumptable .Jumptable
	call DelayFrame
	call Joypad
.handleLoop
	call UpdateTime
	call JoyTextDelay
	ld a, [hJoyLast]
	and B_BUTTON
	jr nz, .quit
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
.quit
	call TrainerCard_ResetTrick
	pop af
	ld [wOptions], a
	pop af
	ld [VramState], a
	ret

.InitRAM
	call ClearBGPalettes
	call ClearSprites
	call ClearTileMap
	call ApplyTilemapInVBlank
	ld b, SCGB_TRAINER_CARD
	predef GetSGBLayout
	call SetPalettes
	call ApplyTilemapInVBlank
	ld hl, wJumptableIndex
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.Jumptable
	dw TrainerCard_Page1_LoadGFX
	dw TrainerCard_Page1_Joypad
	dw TrainerCard_Page2_LoadGFX
	dw TrainerCard_Page2_Joypad
	dw TrainerCard_Quit

TrainerCard_IncrementJumptable:
	ld hl, wJumptableIndex
	inc [hl]
	ret

TrainerCard_Quit:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

TrainerCard_Page1_LoadGFX:
	call ClearSprites
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld d, 16
	call TrainerCard_InitBorder
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call ByteFill
	hlcoord 13, 2, AttrMap
	lb bc, 7, 5
	ld a, 1
	call FillBoxWithByte
	ld b, 2
	call SafeCopyTilemapAtOnce
	ld a, [wPlayerCharacteristics]
	and $f
	cp $c
	jr nc, .PalettePatroller
	ld bc, 7 * 7 tiles
	ld hl, PlayerPics
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $00
	lb bc, BANK(PlayerPics), 7 * 7
	jr .WritePlayerGFX
.PalettePatroller
	ld de, PlayerPalettePatroller
	ld hl, VTiles2 tile $00
	lb bc, BANK(PlayerPalettePatroller), 7 * 7
.WritePlayerGFX
	call Request2bpp
	ld de, CardGFX
	ld hl, VTiles1 tile $4a
	lb bc, BANK(CardGFX), 6
	call Request2bpp
	ld de, CardStatusGFX
	ld hl, VTiles2 tile $37
	lb bc, BANK(CardStatusGFX), 5
	call Request2bpp
	ld de, EnemyHPBarBorderGFX
	ld hl, VTiles2 tile $79
	lb bc, BANK(EnemyHPBarBorderGFX), 4
	call Request1bpp
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	ld hl, wDecompressScratch
	lb bc, $ff, 9
.bargfxloop
	xor a
	ld d, 4
.bargfxloop2
	ld [hli], a
	dec d
	jr nz, .bargfxloop2
	ld d, 3
.bargfxloop3
	ld a, $ff
	ld [hli], a
	ld a, b
	ld [hli], a
	dec d
	jr nz, .bargfxloop3
	xor a
	ld d, 6
.bargfxloop4
	ld [hli], a
	dec d
	jr nz, .bargfxloop4
	srl b
	dec c
	jr nz, .bargfxloop
	ld de, wDecompressScratch
	ld hl, VTiles2 tile $3c
	lb bc, BANK(TrainerCard), 9
	call Request2bpp
	ld de, .TrainerCardSkillStrings
	ld hl, VTiles2 tile $45
	lb bc, 0, $22
	predef PlaceVWFString
	pop af
	ld [rSVBK], a
	ld a, $45
	; Money
	hlcoord 1, 3
	ld b, 4
	call .fillinc
	; Time
	hlcoord 1, 5
	ld b, 3
	call .fillinc
	; Badges
	hlcoord 1, 7
	ld b, 5
	call .fillinc
	; Mining
	hlcoord 1, 9
	ld de, MiningLevel
	lb bc, 4, $67
	call .printskill
	; Jeweling
	hlcoord 1, 11
	ld de, JewelingLevel
	lb bc, 6, $6c
	call .printskill
	; Smelting
	hlcoord 1, 13
	ld de, SmeltingLevel
	lb bc, 6, $71
	call .printskill
	; Crafting
	hlcoord 1, 15
	ld de, BallMakingLevel
	lb bc, 6, $76
	call .printskill
	hlcoord 11, 1
	ld de, .ID_No
	call TrainerCardSetup_PlaceTilemapString
	hlcoord 2, 1
	ld de, PlayerName
	call PlaceString
	hlcoord 14, 1
	ld de, PlayerID
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	call PrintNum
	hlcoord 5, 3
	ld de, Money
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	hlcoord 1, 2
	ld de, .HorizontalDivider
	call TrainerCardSetup_PlaceTilemapString
	hlcoord 12, 2
	lb bc, 7, 7
	xor a
	ld [hGraphicStartTile], a
	predef PlaceGraphic
	ld hl, wNaljoBadges
	ld b, 3
	call CountSetBits
	ld de, wd265
	hlcoord 9, 7
	lb bc, 1, 2
	call PrintNum
	hlcoord 11, 7
	ld [hl], "▶"
	call TrainerCard_Page1_PrintGameTime
	hlcoord 14, 0
	ld de, .StatusTilemap
	call TrainerCardSetup_PlaceTilemapString
	ld b, 2
	call SafeCopyTilemapAtOnce
	ld a, 1
	ld [hBGMapMode], a
	jp TrainerCard_IncrementJumptable

.fillinc
	ld [hli], a
	inc a
	dec b
	jr nz, .fillinc
	ret

.printskill
	push bc
	push hl
	call .fillinc
	ld [hLoopCounter], a
	pop hl
	push hl
	ld bc, 8
	add hl, bc
	ld a, $7b
	ld [hli], a
	lb bc, PRINTNUM_RIGHTALIGN | 1, 3
	push de
	call PrintNum
	pop de
	ld a, [de]
	cp 100
	jp nc, .lv100
	ld a, 13 * 8
	ld [hMultiplicand], a
	xor a
	ld [hMultiplicand + 1], a
	ld [hMultiplicand + 2], a
	inc de
	ld a, [de]
	ld [hMultiplier], a
	predef Multiply
	dec de
	call ProtectedGetCraftingEXPForLevel
	ld [hDivisor], a
	ld b, $2
	predef Divide
	ld a, [hQuotient + 2]
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld c, 13
.barloop
	sub 8
	jr c, .barloop2
	ld [hl], $44
	inc hl
	dec c
	jr z, .bardone
	jr .barloop
.barloop2
	add 8 + $3c
	ld [hli], a
	dec c
	jr z, .bardone
	ld a, $3c
.barloop3
	ld [hli], a
	dec c
	jr nz, .barloop3
.bardone
	push hl
	ld hl, wcf67
	ld a, " " + $30
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], ("/" + $30) % $100
	inc hl
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], "@"
	ld hl, wcf67
	lb bc, 1, 3
	inc de
	push de
	call PrintNum
	pop de
	dec de
	call ProtectedGetCraftingEXPForLevel
	push af
	ld hl, sp + 1
	ld d, h
	ld e, l
	ld hl, wcf67 + 4
	lb bc, PRINTNUM_RIGHTALIGN | 1, 3
	call PrintNum
	pop af
	ld hl, wcf67
	ld b, 7
.adjloop
	ld a, [hl]
	sub $30
	ld [hli], a
	dec b
	jr nz, .adjloop
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	ld hl, wDecompressScratch
	ld bc, 80
	xor a
	call ByteFill
	pop af
	ld [rSVBK], a

	ld de, wcf67
	ld hl, sp + 2
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, VTiles2
	add hl, bc
	lb bc, 5, 5
	predef PlaceVWFString
	pop hl
	pop bc
	ld a, c
	ld b, 5
	call .fillinc
	ld a, [hLoopCounter]
	ret
.lv100
	pop hl
	pop bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld bc, 13
	ld a, $44
	call ByteFill
	inc hl
	ld d, h
	ld e, l
	ld hl, .max
	ld bc, 3
	rst CopyBytes
	ld a, [hLoopCounter]
	ret

.max:
	db "max"

.TrainerCardSkillStrings
	db "┘Money<LNBRK>"
	db "┘Time<LNBRK>"
	db "┘Badges<LNBRK>"
	db "┘Mining<LNBRK>"
	db "┘Jeweling<LNBRK>"
	db "┘Smelting<LNBRK>"
	db "┘Crafting<LNBRK>@"

.ID_No
	db $ce, $cf, $ff ; ID NO

.HorizontalDivider
	db $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cd, $ff ; ________>

.StatusTilemap
	db $37, $38, $39, $3a, $3b, $ff

ProtectedGetCraftingEXPForLevel:
	ld a, [de]
	push de
	push bc
	callba GetCraftingEXPForLevel
	pop bc
	pop de
	ret

TrainerCard_Page1_Joypad:
	call TrainerCard_Page1_PrintGameTime
	ld hl, hJoyLast
	ld a, [hl]
	and D_RIGHT | A_BUTTON
	jr nz, .pressed_right_a
	ret

.pressed_right_a
	ld a, $2
	ld [wJumptableIndex], a
	ret

TrainerCard_Page2_LoadGFX:
	call ClearSprites
	ld hl, rLCDC
	set 2, [hl] ; 8x16 sprites
	hlcoord 0, 0
	ld d, 16
	call TrainerCard_InitBorder
	ld b, 3
	call SafeCopyTilemapAtOnce
	xor a
	ld [hBGMapMode], a
	ld de, LeaderGFX
	ld hl, VTiles2 tile $29
	lb bc, BANK(LeaderGFX), $56
	call Request2bpp
	ld a, 1
	ld [rVBK], a
	ld de, LeaderGFX2
	ld hl, VTiles2 tile $00
	lb bc, BANK(LeaderGFX2), 120
	call Request2bpp
	xor a
	ld [rVBK], a
	ld de, BadgeGFX
	ld hl, VTiles0 tile $00
	lb bc, BANK(BadgeGFX), $70
	call Request2bpp
	hlcoord 1, 1
	ld de, .status
	call PlaceString
	ld a, $20 ; xflip
	ldcoord_a 1, 1, AttrMap
	ld hl, wNaljoBadges
	ld b, 3
	call CountSetBits
	ld de, wd265
	hlcoord 17, 1
	lb bc, 1, 2
	call PrintNum
; attr layout
	ld a, 2
	hlcoord 3, 3, AttrMap
	call .fillleaderattr
	ld a, 3
	hlcoord 7, 3, AttrMap
	call .fillleaderattr
	ld a, 4
	hlcoord 11, 3, AttrMap
	call .fillleaderattr
	ld a, 5
	hlcoord 15, 3, AttrMap
	call .fillleaderattr
	hlcoord 2, 2, AttrMap
	xor a
	ld e, 2
.numloop
	ld bc, 16
	call ByteFill
	ld bc, SCREEN_WIDTH * 3 - 16
	add hl, bc
	dec e
	jr nz, .numloop
	ld a, 8
	ld e, 3
.numloop2
	ld bc, 16
	call ByteFill
	ld bc, SCREEN_WIDTH * 3 - 16
	add hl, bc
	dec e
	jr nz, .numloop2
; turn this on first
	xor a
	ld [hPalTrick], a
	ld a, 3
	ld [hVBlank], a ; VBlank3 will turn on LCD interrupts while updating sound
	ld a, 15
	ld [rLYC], a
	ld a, 1 << 6 ; LYC interrupt
	ld [rSTAT], a
	di
	ld a, $c3 ; jp
	ld [LCD], a
	ld a, LCD_LeaderPal % $100
	ld [LCD + 1], a
	ld a, LCD_LeaderPal / $100
	ld [LCD + 2], a
	ld hl, rIE
	set LCD_STAT, [hl]
	ld hl, rIF
	res LCD_STAT, [hl]
	ei
; tile layout
	hlcoord 2, 2
	ld a, $29
	ld b, 2
	call TrainerCard_Page2_3_PlaceLeadersFaces
	xor a
	ld [wcf64], a
	ld b, 3
	call TrainerCard_Page2_3_PlaceLeadersFaces
	ld a, BANK(wTrainerCardLeaderPals)
	ld [rSVBK], a
	ld a, BANK(wNaljoBadges)
	ld hl, wNaljoBadges
	call GetFarWRAMByte
	ld [wTempBadges], a
	inc hl
	ld a, BANK(wNaljoBadges)
	call GetFarWRAMWord
	ld a, l
	ld [wTempBadges + 1], a
	ld a, h
	ld [wTempBadges + 2], a
	call TrainerCard_Page2_3_OAMUpdate
	hlcoord 14, 0
	ld de, .BadgesTilemap
	call TrainerCardSetup_PlaceTilemapString
	ld a, 2
	ld [hBGMapMode], a
	call Delay2
	ld a, 1
	ld [hBGMapMode], a
	call Delay2
	xor a
	ld [hBGMapMode], a
	jp TrainerCard_IncrementJumptable

.fillleaderattr
	lb bc, 6, 3
	call FillBoxWithByte
	or $8 ; the rest 3 rows are in bank 1
	lb bc, 8, 3
	jp FillBoxWithByte

.status
	db "▶Status@"

.BadgesTilemap:
	db $79, $7a, $7b, $7c, $7d, $ff ; "BADGES"

TrainerCard_Page2_Joypad:
	ld hl, wcf67
	inc [hl]
	call TrainerCard_Page2_3_AnimateBadges
	ld hl, hJoyLast
	ld a, [hl]
	and A_BUTTON
	jr nz, .Quit
	ld a, [hl]
	and D_LEFT
	ret z

.d_left
	call TrainerCard_ResetTrick
	xor a
	ld [wJumptableIndex], a
	ret

.Quit
	call TrainerCard_ResetTrick
	ld a, $4
	ld [wJumptableIndex], a
	ret

TrainerCard_ResetTrick:
	hlcoord 0, 0
	ld d, 16
	call TrainerCard_InitBorder
	call ClearSprites
	ld a, 1
	ld [hBGMapMode], a
	ld c, 3
	call DelayFrames
	di
	xor a
	ld [rLYC], a
	ld [hVBlank], a
	ld [rSVBK], a
	ld [hBGMapMode], a
	ld a, 1 << 3 ; HBlank interrupt
	ld [rSTAT], a
	call LoadLCDCode
	ld hl, rIE
	res LCD_STAT, [hl]
	ld hl, rIF
	res LCD_STAT, [hl]
	ei
	ld hl, rLCDC
	res 2, [hl] ; 8x8 sprites
	ret

TrainerCardSetup_PlaceTilemapString:
	jr .handleLoop
.loop
	inc de
	ld [hli], a
.handleLoop
	ld a, [de]
	cp $ff
	jr nz, .loop
	ret

TrainerCard_InitBorder:
	ld e, 20
.loop1
	ld a, $ca
	ld [hli], a
	dec e
	jr nz, .loop1

.loop3
	ld a, $ca
	ld [hli], a

	ld e, 18
	ld a, " "
.loop4
	ld [hli], a
	dec e
	jr nz, .loop4

	ld a, $ca
	ld [hli], a
	dec d
	jr nz, .loop3

	ld e, 20
.loop6
	ld a, $ca
	ld [hli], a
	dec e
	jr nz, .loop6
	ret

TrainerCard_Page2_3_PlaceLeadersFaces:
	ld c, 4
.loop
	rept 4
	ld [hli], a
	inc a
	endr
	ld de, SCREEN_WIDTH - 3
	add hl, de
	rept 3
	ld [hli], a
	inc a
	endr
	add hl, de
	rept 3
	ld [hli], a
	inc a
	endr
	ld de, SCREEN_WIDTH * -2
	add hl, de
	dec c
	jr nz, .loop
	ld de, (SCREEN_WIDTH * 3) - 16
	add hl, de
	dec b
	jr nz, TrainerCard_Page2_3_PlaceLeadersFaces
	ret

TrainerCard_Page1_PrintGameTime:
	hlcoord 5, 5
	ld de, GameTimeHours
	lb bc, 2, 4
	call PrintNum
	ld a, ":"
	ld [hli], a
	ld de, GameTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld a, [wcf67]
	and $1f
	ret nz
	hlcoord 9, 5
	ld a, [hl]
	xor $e3 ; $7F <--> $9C
	ld [hl], a
	ret

TrainerCard_Page2_3_AnimateBadges:
	ld a, [wcf67]
	and $7
	ret nz
	ld a, [wcf64]
	inc a
	and $7
	ld [wcf64], a

TrainerCard_Page2_3_OAMUpdate:
	ld hl, TrainerCard_BadgesOAM
	ld de, Sprites
	ld a, [wTempBadges]
	ld c, a
	ld b, 8
	call .loop
	ld a, [wTempBadges + 1]
	ld c, a
	ld b, 8
	call .loop
	ld a, [wTempBadges + 2]
	ld c, a
	ld b, 4

.loop
	srl c
	push bc
	jr nc, .skip_badge
	push hl
	ld a, [hli] ; y
	ld b, a
	ld a, [hli] ; x
	ld c, a
	ld a, [hli] ; pal
	ld [wcf66], a
	ld a, [wcf64]
	add l
	ld l, a
	jr nc, .nocarry
	inc h
.nocarry
	ld a, [hl]
	ld [wcf65], a
	and $80
	ld hl, .facing1
	jr z, .loop2
	ld hl, .facing2
.loop2
	ld a, [hli]
	cp $ff
	jr z, .done
	add b
	ld [de], a
	inc de

	ld a, [hli]
	add c
	ld [de], a
	inc de

	ld a, [wcf65]
	and $7f
	add [hl]
	ld [de], a
	inc hl
	inc de

	ld a, [wcf66]
	add [hl]
	ld [de], a
	inc hl
	inc de
	jr .loop2
.done
	pop hl
.skip_badge
	ld bc, $b ; 3 + 2 * 4
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

.facing1
	; y, x, tile, OAM attributes
	db 0, 0, 0, 0
	db 0, 8, 2, 0
	db -1

.facing2
	db 0, 0, 2, X_FLIP
	db 0, 8, 0, X_FLIP
	db -1

TrainerCard_BadgesOAM:
; Template OAM data for each badge on the trainer card.
; Format:
	; y, x, palette
	; cycle 1: face tile, in1 tile, in2 tile, in3 tile
	; cycle 2: face tile, in1 tile, in2 tile, in3 tile

	; Pyre Badge
	db $28, $18, 0
	db $00, $50, $54, $50 | $80
	db $00, $50, $54, $50 | $80

	; Nature Badge
	db $28, $38, 1
	db $04, $50, $54, $50 | $80
	db $04, $50, $54, $50 | $80

	; Charm Badge
	db $28, $58, 2
	db $08, $50, $54, $50 | $80
	db $08, $50, $54, $50 | $80

	; Midnight Badge
	db $28, $78, 3
	db $0c, $50, $54, $50 | $80
	db $58, $50, $54, $50 | $80

	; Muscle Badge
	db $40, $18, 0
	db $10, $50, $54, $50 | $80
	db $5c, $50, $54, $50 | $80

	; Smog Badge
	db $40, $38, 1
	db $14, $50, $54, $50 | $80
	db $14, $50, $54, $50 | $80

	; Raucous Badge
	db $40, $58, 2
	db $18, $50, $54, $50 | $80
	db $18, $50, $54, $50 | $80

	; Naljo Badge
	db $40, $78, 3
	db $1c, $50, $54, $50 | $80
	db $1c, $50, $54, $50 | $80

	; Marine Badge
	db $58, $18, 0
	db $20, $50, $54, $50 | $80
	db $60, $50, $54, $50 | $80

	; Hail Badge
	db $58, $38, 1
	db $24, $50, $54, $50 | $80
	db $24, $50, $54, $50 | $80

	; Sprout Badge
	db $58, $58, 2
	db $28, $50, $54, $50 | $80
	db $28, $50, $54, $50 | $80

	; Sparky Badge
	db $58, $78, 3
	db $2c, $50, $54, $50 | $80
	db $64, $50, $54, $50 | $80

	; Fist Badge
	db $70, $18, 0
	db $30, $50, $54, $50 | $80
	db $68, $50, $54, $50 | $80

	; Psi Badge
	db $70, $38, 1
	db $34, $50, $54, $50 | $80
	db $34, $50, $54, $50 | $80

	; White Badge
	db $70, $58, 2
	db $38, $50, $54, $50 | $80
	db $6c, $50, $54, $50 | $80

	; Star Badge
	db $70, $78, 3
	db $3c, $50, $54, $50 | $80
	db $3c, $50, $54, $50 | $80

	; Hive Badge
	db $88, $18, 0
	db $40, $50, $54, $50 | $80
	db $40, $50, $54, $50 | $80

	; Plain Badge
	db $88, $38, 1
	db $44, $50, $54, $50 | $80
	db $44, $50, $54, $50 | $80

	; Marsh Badge
	db $88, $58, 2
	db $48, $50, $54, $50 | $80
	db $48, $50, $54, $50 | $80

	; Blaze Badge
	db $88, $78, 3
	db $4c, $50, $54, $50 | $80
	db $4c, $50, $54, $50 | $80

CardGFX: INCBIN "gfx/misc/trainer_card.2bpp"
CardStatusGFX: INCBIN "gfx/misc/card_status.2bpp"

LeaderGFX:  INCBIN "gfx/misc/leaders.w24.2bpp"
LeaderGFX2: INCBIN "gfx/misc/leaders_2.w24.2bpp"
BadgeGFX:   INCBIN "gfx/misc/badges.w32.interleave.2bpp"
