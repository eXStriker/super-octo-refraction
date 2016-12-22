PALPACKET_LENGTH EQU $10

SHINY_ATK_BIT EQU 5
SHINY_DEF_VAL EQU 10
SHINY_SPD_VAL EQU 10
SHINY_SPC_VAL EQU 10
LO_NYBBLE     EQU $0f
HI_NYBBLE     EQU $f0

CheckShininess:: ; 8a68
; Check if a mon is shiny by DVs at bc.
; Return carry if shiny.

	ld l, c
	ld h, b
CheckShininessHL::
; Attack
	ld a, [hl]
	and 1 << SHINY_ATK_BIT
	jr z, .NotShiny

; Defense
	ld a, [hli]
	and LO_NYBBLE
	cp  SHINY_DEF_VAL
	jr nz, .NotShiny

; Speed
	ld a, [hl]
	and HI_NYBBLE
	cp  SHINY_SPD_VAL << 4
	jr nz, .NotShiny

; Special
	ld a, [hl]
	and LO_NYBBLE
	cp  SHINY_SPC_VAL
	jr nz, .NotShiny

.Shiny
	scf
	ret

.NotShiny
	and a
	ret
; 8a88

InitPartyMenuPalettes: ; 8ad1
	ld hl, PalPacket_9c56 + 1
	call CopyFourPalettes
	call InitPartyMenuOBPals
	jp WipeAttrMap
; 8bec


ApplyMonOrTrainerPals: ; 8c1d
	call LoadMonOrTrainerPals
	call WipeAttrMap
ApplyAttrMapAndPals:
	call ApplyAttrMap
ApplyPals: ; 96a4
	ld hl, UnknBGPals
	ld de, BGPals
	ld bc, 16 palettes
	ld a, BANK(BGPals)
	jp FarCopyWRAM
; 96b3

ApplyAttrMap: ; 96b3
	ld a, [rLCDC]
	bit 7, a
	jr z, .UpdateVBank1
	ld a, [hVBlank]
	cp 2
	ret z
	ld a, [hBGMapMode]
	push af
	ld a, $2
	ld [hBGMapMode], a
	call Delay2
	pop af
	ld [hBGMapMode], a
	ret

.UpdateVBank1
	hlcoord 0, 0, AttrMap
	debgcoord 0, 0
	ld b, SCREEN_HEIGHT
	ld a, $1
	ld [rVBK], a
.row
	ld c, SCREEN_WIDTH
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .col
	ld a, BG_MAP_WIDTH - SCREEN_WIDTH
	add e
	jr nc, .okay
	inc d
.okay
	ld e, a
	dec b
	jr nz, .row
	xor a
	ld [rVBK], a
	ret
; 96f3

LoadMonOrTrainerPals:
	ld a, e
	and a
	jr z, .get_trainer
	ld a, [wCurPartySpecies]
	call GetMonPalettePointer
	jr .load_palettes

.get_trainer
	ld a, [TrainerClass]
	call GetTrainerPalettePointer
.load_palettes
	ld de, UnknBGPals
	jp LoadPalette_White_Col1_Col2_Black

ApplyHPBarPals: ; 8c43
	ld a, [wWhichHPBar]
	cp 3
	ret nc
	jumptable
	dw .Enemy
	dw .Player
	dw .PartyMenu

.Enemy
	ld de, BGPals + 2 palettes + 2
	jr .continue_battle

.Player
	ld de, BGPals + 3 palettes + 2
.continue_battle
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	ld bc, 4
	ld a, $5
	call FarCopyWRAM
	ld a, $1
	ld [hCGBPalUpdate], a
	ret

.PartyMenu
	ld e, c
	inc e
	hlcoord 11, 1, AttrMap
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	lb bc, 2, 8
	ld a, e
	jp FillBoxCGB
; 8c8a

LoadStatsScreenPals: ; 8c8a
	ld hl, StatsScreenPals
	ld b, 0
	dec c
	add hl, bc
	add hl, bc
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, [hli]
	ld [UnknBGPals], a
	ld [UnknBGPals + 8 * 2], a
	ld a, [hl]
	ld [UnknBGPals + 1], a
	ld [UnknBGPals + 8 * 2 + 1], a
	pop af
	ld [rSVBK], a
	call ApplyPals
	ld a, $1
	ret
; 8cb4
; 8d55

INCLUDE "engine/cgb.asm"

CopyFourPalettes: ; 9610
	ld de, UnknBGPals
	ld c, $4

CopyPalettes: ; 9615
	push bc
	ld a, [hli]
	push hl
	call GetPredefPal
	call LoadHLPaletteIntoDE
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, CopyPalettes
	ret
; 9625

GetPredefPal: ; 9625
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, Palettes_9df6
	add hl, bc
	ret
; 9630

LoadHLPaletteIntoDE: ; 9630
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld c, $8
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop af
	ld [rSVBK], a
	ret
; 9643

LoadPalette_White_Col1_Col2_Black: ; 9643
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a

	ld a, $7fff % $100
	ld [de], a
	inc de
	ld a, $7fff / $100
	ld [de], a
	inc de

	ld c, 2 * 2
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop

	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de

	pop af
	ld [rSVBK], a
	ret
; 9663

FillBoxCGB: ; 9663
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
; 9673

ResetPals: ; 9673
	push af
	push bc
	push de
	push hl
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, UnknBGPals
	ld c, 8
.loop
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [rSVBK], a
	pop hl
	pop de
	pop bc
	pop af
	ret
; 9699

WipeAttrMap: ; 9699
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	jp ByteFill
; 96a4

CGB_ApplyPartyMenuHPPals: ; 96f3 CGB layout $fc
	ld hl, wHPPals
	ld a, [wSGBPals]
	ld e, a
	ld d, $0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	inc a
	ld e, a
	hlcoord 11, 2, AttrMap
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wSGBPals]
	rst AddNTimes
	lb bc, 2, 8
	ld a, e
	jp FillBoxCGB
; 971a


InitPartyMenuOBPals: ; 971a
	ld hl, Palettes_Pokemon_Menu
	ld de, UnknOBPals
	ld bc, 8 palettes
	ld a, $5
	jp FarCopyWRAM
; 9729

GetBattlemonBackpicPalettePointer: ; 9729
	push de
	callba GetPartyMonDVs
	ld c, l
	ld b, h
	ld a, [TempBattleMonSpecies]
	call GetPlayerOrMonPalettePointer
	pop de
	ret
; 973a

GetEnemyFrontpicPalettePointer: ; 973a
	push de
	callba GetEnemyMonDVs
	ld c, l
	ld b, h
	ld a, [TempEnemyMonSpecies]
	call GetFrontpicPalettePointer
	pop de
	ret
; 974b

GetPlayerOrMonPalettePointer: ; 974b
	and a
	jp nz, GetMonNormalOrShinyPalettePointer
GetPlayerPalettePointer:
	ld a, [wPlayerSpriteSetupFlags]
	bit 2, a
	ld hl, CharPalette
	ret nz
	push de
	CheckEngine ENGINE_POKEMON_MODE
	ld a, [wPlayerCharacteristics]
	jr z, .okay
	ld a, [wTempPlayerCustSelection]
.okay
	swap a
	and $7
	ld l, a
	ld h, 0
	add hl, hl
	ld de, RacePalettes
	add hl, de
	ld de, wBattlePlayerSkinTone
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld hl, wPlayerClothesPalette
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .okay2
	ld hl, wTempPlayerClothesPalette
.okay2
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop de
	ld hl, wBattlePlayerSkinTone
	ret

GetFrontpicPalettePointer: ; 9764
	and a
	jp nz, GetMonNormalOrShinyPalettePointer
	ld a, [TrainerClass]
	and a
	jr z, GetPlayerPalettePointer
GetTrainerPalettePointer: ; 976b
	cp PATROLLER
	jr z, GetPalletPatrollerPointer
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, TrainerPalettes
	add hl, bc
	ret
; 9775

GetPalletPatrollerPointer:
	ld a, [OtherTrainerID]
	dec a
	ld e, a
	ld d, 0
	ld hl, .WhichPatroller
	add hl, de
	ld a, [hl]
	add a
	add a
	ld e, a
	ld d, 0
	ld hl, .WhichPalette
	add hl, de
	ret
.WhichPatroller:
	db 0, 0 ; Black
	db 1, 1, 1 ; Yellow
	db 2, 2, 2 ; Pink
	db 3, 3, 3 ; Blue
	db 4, 4, 4 ; Green
	db 5, 5 ; Red
	db 1 ; Yellow
	db 4 ; Green
	db 3 ; Blue
	db 2 ; Pink

.WhichPalette:

INCLUDE "gfx/trainers/palettepatrollers.pal"

Palettes_979c: ; 979c
	RGB 31, 31, 31
	RGB 25, 25, 25
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 00, 00, 00

GetMonPalettePointer: ; 97ee
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, PokemonPalettes
	add hl, bc
	ret
; 97f9

GetMonNormalOrShinyPalettePointer: ; 97f9
	push bc
	call GetMonPalettePointer
	pop bc
	push hl
	call CheckShininess
	pop hl
	ret nc
	inc hl
	inc hl
	inc hl
	inc hl
	ret
; 9809

ClearBytes: ; 0x9a5b
; clear bc bytes of data starting from de
	push hl
	ld h, d
	ld l, e
	xor a
	call ByteFill
	ld d, h
	ld e, l
	pop hl
	ret

DrawDefaultTiles: ; 0x9a64
; Draw 240 tiles (2/3 of the screen) from tiles in VRAM
	hlbgcoord 0, 0 ; BG Map 0
	ld de, BG_MAP_WIDTH - SCREEN_WIDTH
	ld a, $80 ; starting tile
	ld c, 12 + 1
.line
	ld b, 20
.tile
	ld [hli], a
	inc a
	dec b
	jr nz, .tile
; next line
	add hl, de
	dec c
	jr nz, .line
	ret
; 0x9a7a

PalPacket_9ba6:	db $2b, $00, $24, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9bc6:	db $4c, $00, $4c, $00, $4c, $00, $4c, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c36:	db $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c46:	db $39, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c56:	db $2e, $00, $2f, $00, $30, $00, $31, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9c66:	db $1a, $00, $1a, $00, $1a, $00, $1a, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9ca6:	db $33, $00, $34, $00, $1b, $00, $1f, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9cb6:	db $1b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PalPacket_9cc6:	db $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Palettes_9df6: ; 9df6
	RGB 31, 31, 31
	RGB 22, 25, 19
	RGB 16, 21, 30
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 27, 28, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 28, 19
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 24, 24
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 23, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 21, 27
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 24, 16
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 25, 30, 26
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 25, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 19
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 26, 19
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 27, 28, 27
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 30, 23
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 24, 29
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 23, 29
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 25, 23, 20
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 26, 18
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 21, 18
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 25, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 22, 21, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 22, 25, 21
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 22
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 20
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 26, 26
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 14, 09
	RGB 15, 20, 20
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 28, 22
	RGB 15, 20, 20
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 07, 07
	RGB 02, 03, 03
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 17
	RGB 16, 14, 19
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 18, 20, 27
	RGB 11, 15, 23
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 10
	RGB 26, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 25, 29
	RGB 14, 19, 25
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 27, 22, 24
	RGB 21, 15, 23
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 28, 20, 15
	RGB 21, 14, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 20, 26, 16
	RGB 09, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 24
	RGB 28, 15, 21
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 28, 14
	RGB 26, 20, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 21, 22
	RGB 15, 15, 18
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 19, 13
	RGB 14, 12, 17
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 18, 21
	RGB 10, 12, 18
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 22, 15, 16
	RGB 17, 02, 05
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 20, 20
	RGB 05, 16, 16
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 15, 19
	RGB 14, 04, 12
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 20, 17, 18
	RGB 18, 13, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 21, 16
	RGB 12, 12, 10
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 25, 29
	RGB 30, 22, 24
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 23, 16
	RGB 29, 14, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 18, 18, 18
	RGB 10, 10, 10
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 15
	RGB 00, 23, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 15
	RGB 31, 23, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 15
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 26, 19
	RGB 27, 20, 14
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 20, 10
	RGB 21, 00, 04
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 20, 10
	RGB 21, 00, 04
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 26, 16
	RGB 16, 12, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 28, 26
	RGB 12, 22, 26
	RGB 03, 16, 14

	RGB 31, 31, 31
	RGB 15, 28, 26
	RGB 23, 24, 24
	RGB 00, 00, 00

	RGB 31, 31, 24
	RGB 07, 27, 19
	RGB 26, 20, 10
	RGB 19, 12, 08

	RGB 31, 31, 31
	RGB 31, 28, 14
	RGB 31, 13, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 18, 21
	RGB 10, 12, 18
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 23, 21, 16
	RGB 12, 12, 10
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 00
	RGB 07, 11, 15
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 21, 22
	RGB 26, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 27, 04
	RGB 24, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 13, 25
	RGB 24, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 19, 29
	RGB 24, 20, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 24
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 21, 25, 29
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 20, 26, 16
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 31, 28, 14
	RGB 18, 18, 18
	RGB 16, 10, 07

	RGB 31, 31, 31
	RGB 18, 18, 18
	RGB 26, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 22, 24
	RGB 28, 15, 21
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 26, 20, 00
	RGB 16, 19, 29
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 02, 30
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 13, 04
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 28, 04, 02
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 18, 23, 31
	RGB 15, 20, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 24, 20, 11
	RGB 18, 13, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 25, 30, 00
	RGB 25, 30, 00

	RGB 00, 00, 00
	RGB 08, 11, 11
	RGB 21, 21, 21
	RGB 31, 31, 31

Palettes_a8be: ; a8be
; HP Pals
	RGB 30, 26, 15
	RGB 00, 23, 00

	RGB 30, 26, 15
	RGB 31, 21, 00

	RGB 30, 26, 15
	RGB 31, 00, 00

Palettes_a8ca: ; a8ca
	RGB 30, 26, 15
	RGB 04, 17, 31
; a8ce

; a8ce
INCLUDE "gfx/pics/palette_pointers.asm"
; b0ce

; b0ce
INCLUDE "gfx/trainers/palette_pointers.asm"
; b1de

LoadMapPals: ; b1de
	callba LoadSpecialMapPalette
	jr c, .got_pals

	ld a, [wPermission]
	and 7
	ld e, a
	ld d, 0
	ld hl, .TilesetColorsPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [TimeOfDayPal]
	and 3
	add a
	add a
	add a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld e, l
	ld d, h
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, UnknBGPals
	ld b, 8
.outer_loop
	ld a, [de]
	push de
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, TilesetBGPalette
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld c, 1 palettes
.inner_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .inner_loop
	pop de
	inc de
	dec b
	jr nz, .outer_loop
	pop af
	ld [rSVBK], a

.got_pals
	ld a, [TimeOfDayPal]
	and $3
	ld bc, 8 palettes
	ld hl, MapObjectPals
	rst AddNTimes
	push hl
	ld de, UnknOBPals
	ld bc, 8 palettes
	ld a, $5 ; BANK(UnknOBPals)
	call FarCopyWRAM
	pop hl
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .setMonColour
	call SetPlayerColor
	call SetPlayerRace
	jr .continue
.setMonColour
	ld a, [wPokeonlyMonPalette]
	ld bc, 1 palettes
	rst AddNTimes
	inc hl
	inc hl
	ld de, UnknOBPals + 2
	ld bc, 4
	ld a, $5
	call FarCopyWRAM
.continue

	ld a, [MapGroup]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, RoofPals
	add hl, de
	ld a, [TimeOfDayPal]
	and 3
	cp DARKNESS
	ret z
	cp NITE
	jr c, .morn_day
	inc hl
	inc hl
	inc hl
	inc hl
.morn_day
	ld de, UnknBGPals + 6 palettes + 2
	ld bc, 4
	ld a, $5
	jp FarCopyWRAM
; b279

.TilesetColorsPointers: ; b279
	dw TilesetColors1
	dw TilesetColors1
	dw TilesetColors1
	dw TilesetColors2
	dw TilesetColors3
	dw TilesetColors4
	dw TilesetColors2
	dw TilesetColors3
; b289

RacePalettes:
	RGB 31, 21, 09
	RGB 31, 27, 17
	RGB 30, 24, 15
	RGB 28, 21, 13
	RGB 24, 16, 08
	RGB 17, 10, 04
	RGB 10, 06, 03

SetPlayerRace:
	ld a, [wPlayerCharacteristics]
	swap a
	and 7
	ld hl, RacePalettes
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld d, h
	ld e, l

	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	ld de, UnknOBPals + 2
	jr SetPlayerColorTOD

SetPlayerColor:
	ld a, [wPlayerClothesPalette]
	ld l, a
	ld a, [wPlayerClothesPalette + 1]
	ld h, a
	ld de, UnknOBPals + 4
SetPlayerColorTOD:
	push de
	;Change colors based on lightning
	ld a, [TimeOfDayPal]
	and 3
	cp NITE
	jr c, .setColors
	call nz, ColorNight
	call ColorNight
.setColors
	pop de
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a

	pop af
	ld [rSVBK], a
	ret

IncreaseColor:
	cp 31
	ret nc
	cp 4
	ret c
	cp 8
	jr c, .increaseOne
	cp 16
	jr c, .increaseTwo
	inc a
.increaseTwo
	inc a
.increaseOne
	inc a
	ret

ColorNight:
	call GetRed
	call IncreaseColor
	srl a
	ld e, a

	call GetGreen
	call IncreaseColor

	add 3
	srl a
	ld b, a
	and 7
	add a
	swap a
	add e
	ld e, a

	ld a, b
	srl a
	srl a
	srl a
	ld d, a

	call GetBlue
	cp 2
	jr c, .skipBlue
	sub 2
	add a
	add a
	add d
	ld d, a

.skipBlue
	ld h, d
	ld l, e
	ret
;hl: Color
;a: Result
GetRed:
	ld a, l
	and $1f
	ret

GetGreen:
	ld a, l
	swap a
	srl a
	and $7
	ld b, a

	ld a, h
	and 3
	add a
	add a
	add a
	add b
	ret

GetBlue:
	ld a, h
	srl a
	srl a
	ret

TilesetColors1: ; b289
	db $00, $01, $02, $28, $04, $05, $06, $07
	db $08, $09, $0a, $28, $0c, $0d, $0e, $0f
	db $10, $11, $12, $29, $14, $15, $16, $17
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f

TilesetColors2: ; b289
	db $20, $21, $22, $23, $24, $25, $26, $07
	db $20, $21, $22, $23, $24, $25, $26, $07
	db $10, $11, $12, $13, $14, $15, $16, $07
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $07

TilesetColors3: ; b289
	db $00, $01, $02, $03, $04, $05, $06, $07
	db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
	db $10, $11, $12, $13, $14, $15, $16, $17
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f

TilesetColors4: ; b289
	db $00, $01, $02, $03, $04, $05, $06, $07
	db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
	db $10, $11, $12, $13, $14, $15, $16, $17
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f
; b309

Palette_b311: ; b311 not mobile
	RGB 31, 31, 31
	RGB 17, 19, 31
	RGB 14, 16, 31
	RGB 00, 00, 00

; b319

TilesetBGPalette: ; b319
INCLUDE "tilesets/bg.pal"

MapObjectPals:: ; b469
INCLUDE "tilesets/ob.pal"

RoofPals: ; b569
INCLUDE "tilesets/roof.pal"

Palettes_b641: ; b641
	RGB 27, 31, 27
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 07, 06
	RGB 20, 02, 03
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 10, 31, 09
	RGB 04, 14, 01
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 22, 16, 08
	RGB 13, 07, 01
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 15, 31, 31
	RGB 05, 17, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 11, 11, 19
	RGB 07, 07, 12
	RGB 00, 00, 00

; b681

Palettes_Pokemon_Menu:
;Orange
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 30, 15, 00
	RGB 00, 00, 00

;Blue
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 09, 04, 31
	RGB 00, 00, 00

;Green
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 07, 23, 03
	RGB 00, 00, 00

;Brown
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 15, 10, 03
	RGB 00, 00, 00

;Red
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 31, 07, 00
	RGB 00, 00, 00

;Gray
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 14, 14, 10
	RGB 00, 00, 00

;Yellow
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 31, 28, 00
	RGB 00, 00, 00

;Purple
	RGB 28, 31, 16
	RGB 31, 21, 09
	RGB 26, 00, 26
	RGB 00, 00, 00

Palettes_b681: ; b681
	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 10, 14, 20
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 27, 31, 27
	RGB 31, 19, 10
	RGB 31, 07, 04
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 07, 07, 07

	RGB 31, 31, 31
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 07, 07, 07

; b729

MalePokegearPals: ; b729
	RGB 31, 31, 31
	RGB 05, 17, 31
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 09, 19, 31
	RGB 03, 09, 29

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 24, 18, 07
	RGB 20, 15, 03

	RGB 31, 31, 31
	RGB 25, 12, 09
	RGB 15, 07, 00
	RGB 00, 00, 00

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 25, 12, 09
	RGB 31, 31, 31

	RGB 22, 31, 10
	RGB 18, 25, 05
	RGB 15, 07, 00
	RGB 25, 12, 09

	RGB 25, 12, 09
	RGB 09, 19, 31
	RGB 03, 09, 29
	RGB 02, 05, 17

	RGB 31, 31, 31
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 25, 04, 00

; b7a9

Palettes_b7a9: ; b7a9
	RGB 31, 31, 31
	RGB 24, 25, 28
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 10, 06
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 31, 00
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 15, 31
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 21, 31
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 11
	RGB 31, 31, 06
	RGB 24, 24, 09
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 16, 19, 29
	RGB 25, 22, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 30, 10, 06
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 12, 25, 01
	RGB 30, 10, 06
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 06
	RGB 20, 15, 03
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 06
	RGB 15, 21, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 06
	RGB 20, 15, 03
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 24, 21
	RGB 31, 13, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 00, 00, 00

; b829
GetPartySpritePalPointer:
	push de
	callba GetCurPartySpritePalIndex
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, Palettes_Pokemon_Menu
	add hl, de
	pop de
	ret

GetBallPackPal:
	ld a, [wMenuSelection]

; fallthrough
LoadBallPal:
	push de
	ld hl, PokeBallPals
	ld e, 5
	call IsInArray
	inc hl
	pop de
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call LoadPalette_White_Col1_Col2_Black
	pop af
	ld [rSVBK], a
	ret

GetBallAnimPal_: ; cd249 (33:5249)
	ld de, UnknOBPals + 2 palettes
	ld a, [wCurItem] ; CurItem
	call LoadBallPal
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret

PokeBallPals:
	db MASTER_BALL
	RGB 27, 01, 29
	RGB 18, 01, 21
	db ULTRA_BALL
	RGB 31, 29, 03
	RGB 01, 01, 01
	db GREAT_BALL
	RGB 27, 00, 00
	RGB 02, 08, 28
	db POKE_BALL
	RGB 31, 31, 31
	RGB 27, 00, 00
	db DIVE_BALL
	RGB 02, 21, 27
	RGB 31, 00, 00
	db FAST_BALL
	RGB 31, 29, 03
	RGB 31, 00, 00
	db FRIEND_BALL
	RGB 10, 30, 02
	RGB 30, 00, 00
	db SHINY_BALL
	RGB 31, 29, 03
	RGB 31, 17, 00
	db QUICK_BALL
	RGB 31, 29, 03
	RGB 04, 21, 31
	db DUSK_BALL
	RGB 00, 15, 00
	RGB 28, 09, 00
	db REPEAT_BALL
	RGB 30, 25, 03
	RGB 31, 00, 00
	db TIMER_BALL
	RGB 31, 08, 08
	RGB 08, 08, 08
	db PARK_BALL
	RGB 16, 31, 04
	RGB 02, 11, 02
	db EAGULOU_BALL
	RGB 31, 31, 31
	RGB 20, 17, 08
	db -1
	RGB 31, 31, 31
	RGB 27, 00, 00

DarkenBall:
	ld a, [rSVBK]
	push af
	ld a, BANK(UnknOBPals)
	ld [rSVBK], a
	ld hl, UnknOBPals + 2 palettes + 2
	ld c, 2
.loop
	push bc
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ColorNight
	pop de
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld h, d
	ld l, e
	ld [hli], a
	pop bc
	dec c
	jr nz, .loop
	pop af
	ld [rSVBK], a
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
