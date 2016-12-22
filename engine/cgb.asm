; Replaces the functionality of sgb.asm to work with CGB hardware.

GetSGBLayout:: ; 8d59
	ld a, b
	cp SCGB_RAM
	jr nz, .not_ram
	ld a, [SGBPredef]
.not_ram
	cp SCGB_PARTY_MENU_HP_PALS
	jp z, CGB_ApplyPartyMenuHPPals
	call ResetPals
	jumptable
; jumptable
	dw _CGB_BattleGrayscale
	dw _CGB_BattleColors
	dw _CGB_PokegearPals
	dw _CGB_StatsScreenHPPals
	dw _CGB_Pokedex
	dw _CGB_SlotMachine
	dw _CGB_ScrollingMenu
	dw _CGB_MapPals
	dw _CGB0a
	dw _CGB0b
	dw _CGB0e
	dw _CGB_PokedexSearchOption
	dw _CGB_Pokepic
	dw _CGB_PackPals
	dw _CGB_TrainerCard
	dw _CGB17
	dw _CGB18
	dw _CGB19
	dw _CGB1a
	dw _CGB1b
	dw _CGB_FrontpicPals
	dw _CGB_SecondLogoIntroPals
; 8db8

_CGB_BattleGrayscale: ; 8db8
	ld hl, PalPacket_9c66
	ld de, UnknBGPals
	ld c, $4
	call CopyPalettes
	ld hl, PalPacket_9c66
	ld de, UnknBGPals + 4 palettes
	ld c, $4
	call CopyPalettes
	ld hl, PalPacket_9c66
	ld de, UnknOBPals
	ld c, $2
	call CopyPalettes
	jr _CGB_FinishBattleScreenLayout

_CGB_BattleColors: ; 8ddb
	ld de, UnknBGPals
	call GetBattlemonBackpicPalettePointer
	push hl
	call LoadPalette_White_Col1_Col2_Black
	call GetEnemyFrontpicPalettePointer
	push hl
	call LoadPalette_White_Col1_Col2_Black
	ld a, [EnemyHPPal]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld a, [PlayerHPPal]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palettes_a8ca
	call LoadPalette_White_Col1_Col2_Black
	ld de, UnknOBPals
	pop hl
	call LoadPalette_White_Col1_Col2_Black
	pop hl
	call LoadPalette_White_Col1_Col2_Black
	ld a, SCGB_BATTLE_COLORS
	ld [SGBPredef], a
	call ApplyPals
_CGB_FinishBattleScreenLayout: ; 8e23
	call InitPartyMenuBGPal7
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $2
	call ByteFill
	hlcoord 0, 4, AttrMap
	lb bc, 8, 10
	ld a, $0
	call FillBoxCGB
	hlcoord 10, 0, AttrMap
	lb bc, 7, 10
	ld a, $1
	call FillBoxCGB
	hlcoord 0, 0, AttrMap
	lb bc, 4, 10
	ld a, $2
	call FillBoxCGB
	hlcoord 10, 7, AttrMap
	lb bc, 5, 10
	ld a, $3
	call FillBoxCGB
	hlcoord 10, 11, AttrMap
	lb bc, 1, 9
	ld a, $4
	call FillBoxCGB
	hlcoord 0, 12, AttrMap
	ld bc, 6 * SCREEN_WIDTH
	ld a, $7
	call ByteFill
	ld hl, Palettes_979c
	ld de, UnknOBPals + 2 palettes
	ld bc, 6 palettes
	ld a, $5
	call FarCopyWRAM
	jp ApplyAttrMap
; 8e85


InitPartyMenuBGPal7: ; 8e85
	ld hl, Palette_b311
	ld de, UnknBGPals + 8 * 7
	jr InitPartyMenuBGPal7_Continue
; 8e9f

InitPartyMenuBGPal0: ; 8e9f
	ld hl, Palette_b311
	ld de, UnknBGPals
InitPartyMenuBGPal7_Continue:
	ld bc, 1 palettes
	ld a, $5
	jp FarCopyWRAM


_CGB_PokegearPals: ; 8eb9
	ld a, c
	and a
	push af
	ld hl, MalePokegearPals
	ld de, UnknBGPals
	ld bc, 8 palettes
	ld a, $5
	call FarCopyWRAM
	ld de, UnknOBPals
	pop af
	jr z, .skip
	call GetPartySpritePalPointer
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
.skip
	xor a
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8edb

_CGB_StatsScreenHPPals: ; 8edb
	ld de, UnknBGPals
	ld a, [wcda1]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld a, [wCurPartySpecies]
	ld bc, TempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palettes_a8ca
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palette8f52
	ld de, UnknBGPals + 8 * 3
	ld bc, 4 palettes
	ld a, $5
	call FarCopyWRAM
	call WipeAttrMap

	hlcoord 0, 0, AttrMap
	lb bc, 8, SCREEN_WIDTH
	ld a, $1
	call FillBoxCGB

	hlcoord 10, 16, AttrMap
	ld bc, 10
	ld a, $2
	call ByteFill

	hlcoord 11, 5, AttrMap
	lb bc, 2, 2
	ld a, $3
	call FillBoxCGB

	hlcoord 13, 5, AttrMap
	lb bc, 2, 2
	ld a, $4
	call FillBoxCGB

	hlcoord 15, 5, AttrMap
	lb bc, 2, 2
	ld a, $5
	call FillBoxCGB

	hlcoord 17, 5, AttrMap
	lb bc, 2, 2
	ld a, $6
	call FillBoxCGB

	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8f52

Palette8f52: ; 8f52
	RGB 31, 31, 31
	RGB 31, 19, 31
	RGB 31, 15, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 31, 14
	RGB 17, 31, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 17, 31, 31
	RGB 17, 31, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 19, 00
	RGB 31, 15, 00
	RGB 00, 00, 00
; 8f6a

StatsScreenPals: ; 8f6a
	RGB 31, 19, 31
	RGB 21, 31, 14
	RGB 17, 31, 31
	RGB 31, 19, 00
; 8f70

_CGB_Pokedex: ; 8f70
	ld de, UnknBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [wCurPartySpecies]
	cp $ff
	jr nz, .is_pokemon
	ld hl, Palette8fba
	call LoadHLPaletteIntoDE
	jr .got_palette

.is_pokemon
	call GetMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
.got_palette
	call WipeAttrMap
	hlcoord 1, 1, AttrMap
	lb bc, 7, 7
	ld a, $1
	call FillBoxCGB
	call InitPartyMenuOBPals
	ld hl, Palette8fc2
	ld de, UnknOBPals + 7 palettes
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8fba

Palette8fba: ; 8fba
	RGB 11, 23, 00
	RGB 07, 17, 00
	RGB 06, 16, 03
	RGB 05, 12, 01

Palette8fc2: ; 8fc2
	RGB 00, 00, 00
	RGB 11, 23, 00
	RGB 07, 17, 00
	RGB 00, 00, 00
; 8fca

_CGB17: ; 8fca
	ld de, UnknBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [wCurPartySpecies]
	cp $ff
	jr nz, .GetMonPalette
	ld hl, Palette9036
	call LoadHLPaletteIntoDE
	jr .Resume

.GetMonPalette
	ld bc, TempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
.Resume
	call WipeAttrMap
	hlcoord 1, 4, AttrMap
	lb bc, 7, 7
	ld a, $1
	call FillBoxCGB
	call InitPartyMenuOBPals
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
_CGB16_Dummy: ; 903e
	ret
; 9009

Palette9036: ; 9036
	RGB 31, 15, 00
	RGB 23, 12, 00
	RGB 15, 07, 00
	RGB 00, 00, 00
; 903e

_CGB_SlotMachine: ; 906e
	ld hl, Palettes_b7a9
	ld de, UnknBGPals
	ld bc, $80
	ld a, $5
	call FarCopyWRAM
	call WipeAttrMap
	hlcoord 0, 2, AttrMap
	lb bc, 10, 3
	ld a, $2
	call FillBoxCGB
	hlcoord 17, 2, AttrMap
	lb bc, 10, 3
	ld a, $2
	call FillBoxCGB
	hlcoord 0, 4, AttrMap
	lb bc, 6, 3
	ld a, $3
	call FillBoxCGB
	hlcoord 17, 4, AttrMap
	lb bc, 6, 3
	ld a, $3
	call FillBoxCGB
	hlcoord 0, 6, AttrMap
	lb bc, 2, 3
	ld a, $4
	call FillBoxCGB
	hlcoord 17, 6, AttrMap
	lb bc, 2, 3
	ld a, $4
	call FillBoxCGB
	hlcoord 4, 2, AttrMap
	lb bc, 2, 12
	ld a, $1
	call FillBoxCGB
	hlcoord 3, 2, AttrMap
	lb bc, 10, 1
	ld a, $1
	call FillBoxCGB
	hlcoord 16, 2, AttrMap
	lb bc, 10, 1
	ld a, $1
	call FillBoxCGB
	hlcoord 0, 12, AttrMap
	ld bc, $78
	ld a, $7
	call ByteFill
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 90f8

_CGB_ScrollingMenu: ; 91ad
	ld hl, Palettes_b641
	ld de, UnknBGPals
	ld bc, 16 palettes
	ld a, $5
	call FarCopyWRAM

	ld hl, PalPacket_9cb6
	call CopyFourPalettes
	call WipeAttrMap
	jp ApplyAttrMap
; 91c8

_CGB_MapPals: ; 91c8
	call LoadMapPals
	ld a, SCGB_MAPPALS
	ld [SGBPredef], a
	ret
; 91d1

_CGB0a: ; 91d1
	ld hl, PalPacket_9c56
	call CopyFourPalettes
	call InitPartyMenuBGPal0
	call InitPartyMenuBGPal7
	call InitPartyMenuOBPals
	jp ApplyAttrMap
; 91e4

_CGB0b: ; 91e4
	ld de, UnknBGPals
	ld a, c
	and a
	jr z, .pokemon
	ld a, $1a
	call GetPredefPal
	call LoadHLPaletteIntoDE
	jr .got_palette

.pokemon
	ld hl, PartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	rst AddNTimes
	ld c, l
	ld b, h
	ld a, [PlayerHPPal]
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palettes_979c
	ld de, UnknOBPals + 2 palettes
	ld bc, 6 palettes
	ld a, $5
	call FarCopyWRAM

.got_palette
	call WipeAttrMap
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9228

_CGB18: ; 925e
	ld hl, PalPacket_9bc6
	call CopyFourPalettes
	ld de, UnknOBPals
	ld a, $4c
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, UnknOBPals
	ld a, $1f
	ld [hli], a
	ld a, $0
	ld [hl], a
	pop af
	ld [rSVBK], a
	call WipeAttrMap
	jp ApplyAttrMap
; 9289

_CGB_TrainerCard: ; 9289
	ld de, UnknBGPals
	ld a, [wPlayerGender]
	bit 0, a
	ld hl, .boycard
	jr z, .boy
	ld hl, .girlcard
.boy
	call LoadPalette_White_Col1_Col2_Black
	xor a
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, UnknOBPals
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
; setup all leader and badge pals into wTrainerCardLeaderPals
	ld de, wTrainerCardLeaderPals
	ld hl, .leaderlist
	ld b, 20
.loop
	ld a, [hli]
	push bc
	push hl
	call GetTrainerPalettePointer
	ld c, 2 * 2
.loop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop2
	pop hl
	pop bc
	dec b
	jr nz, .loop
	ld hl, .badgepals
	ld de, wTrainerCardBadgePals
	ld bc, 20 * 4
	rst CopyBytes
	pop af
	ld [rSVBK], a
	ld a, $24
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
.leaderlist
	db JOSIAH, RINJI, BROOKLYN, EDISON, ANDRE, AYAKA, CADENCE, BRUCE ; Naljo
	db KARPMAN, LILY, SPARKY, LOIS, KOJI, SHERYL, JOE, WHITNEY ; Rijon - use Whitney for Silver's pal for now
	db BUGSY, WHITNEY, SABRINA, ERNEST ; Extra 4
.boycard
	RGB 14, 16, 31
	RGB 07, 05, 29
.girlcard
	RGB 25, 17, 20
	RGB 26, 02, 19
.badgepals
	; Pyre Badge
	RGB 30, 19, 04
	RGB 30, 06, 04
	; Nature Badge
	RGB 14, 30, 00
	RGB 07, 17, 06
	; Charm Badge
	RGB 30, 14, 22
	RGB 18, 09, 24
	; Midnight Badge
	RGB 17, 17, 28
	RGB 06, 10, 24
	; Muscle Badge
	RGB 28, 19, 10
	RGB 18, 08, 06
	; Smog Badge
	RGB 24, 09, 24
	RGB 11, 01, 11
	; Raucous Badge
	RGB 30, 26, 04
	RGB 16, 14, 25
	; Naljo Badge
	RGB 21, 14, 09
	RGB 14, 06, 04
	; Marine Badge
	RGB 15, 21, 30
	RGB 08, 10, 30
	; Hail Badge
	RGB 14, 27, 30
	RGB 08, 15, 11
	; Sprout Badge
	RGB 22, 27, 01
	RGB 04, 15, 06
	; Sparky Badge
	RGB 30, 30, 03
	RGB 17, 05, 17
	; Fist Badge
	RGB 30, 21, 04
	RGB 17, 08, 05
	; Psi Badge
	RGB 30, 27, 00
	RGB 22, 15, 00
	; White Badge
	RGB 30, 30, 30
	RGB 22, 21, 21
	; Star Badge
	RGB 30, 09, 01
	RGB 20, 04, 02
	; Hive Badge
	RGB 30, 13, 06
	RGB 28, 04, 04
	; Plain Badge
	RGB 30, 26, 04
	RGB 17, 19, 18
	; Marsh Badge
	RGB 27, 18, 03
	RGB 11, 07, 09
	; Blaze Badge
	RGB 30, 25, 06
	RGB 30, 11, 00
; 9373

_CGB0e: ; 9373
	ld de, UnknBGPals
	ld a, $10
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [PlayerHPPal]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, Palettes_a8be
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	hlcoord 11, 1, AttrMap
	lb bc, 2, 9
	ld a, $1
	call FillBoxCGB
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 93a6

_CGB_PokedexSearchOption: ; 93ba
	ld de, UnknBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 93d3

_CGB_PackPals: ; 93d3
; pack pals
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	ld hl, .ChrisPackPals
	jr z, .got_gender
	ld a, [wPlayerGender]
	bit 0, a
	jr z, .got_gender
	ld hl, .KrisPackPals
.got_gender
	ld de, UnknBGPals
	ld bc, 8 palettes ; 6 palettes?
	ld a, $5
	call FarCopyWRAM
	call WipeAttrMap
	hlcoord 0, 0, AttrMap
	lb bc, 1, 10
	ld a, $1
	call FillBoxCGB
	hlcoord 10, 0, AttrMap
	lb bc, 1, 10
	ld a, $2
	call FillBoxCGB
	hlcoord 7, 2, AttrMap
	lb bc, 9, 1
	ld a, $3
	call FillBoxCGB
	hlcoord 0, 7, AttrMap
	lb bc, 3, 5
	ld a, $4
	call FillBoxCGB
	hlcoord 0, 3, AttrMap
	lb bc, 3, 5
	ld a, $5
	call FillBoxCGB
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9439

.ChrisPackPals: ; 9439
	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 11, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 31, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 19, 07
	RGB 07, 19, 07
	RGB 00, 00, 00
; 9469

.KrisPackPals: ; 9469
	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 15, 15, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 31, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 19, 07
	RGB 07, 19, 07
	RGB 00, 00, 00
; 9499

_CGB_Pokepic: ; 9499
	call _CGB_MapPals
	ld bc, TempMonDVs
	ld a, [wCurPartySpecies]
	call GetMonNormalOrShinyPalettePointer
	ld a, [rSVBK]
	push af
	ld a, BANK(UnknBGPals)
	ld [rSVBK], a
	ld de, UnknBGPals + 7 palettes
	call LoadPalette_White_Col1_Col2_Black
	pop af
	ld [rSVBK], a
	ld bc, SCREEN_WIDTH
	hlcoord 0, 0, AttrMap
	ld a, [wMenuBorderTopCoord]
	rst AddNTimes
	ld a, [wMenuBorderLeftCoord]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [wMenuBorderTopCoord]
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	inc a
	sub b
	ld b, a
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	ld a, [wMenuBorderRightCoord]
	sub c
	inc a
	ld c, a
	ld a, 7
	call FillBoxCGB
	call ApplyAttrMapAndPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 94fa

_CGB_SecondLogoIntroPals:
	ld de, UnknBGPals
	ld a, $4e
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld hl, SecondLogoIntroPal
	ld de, UnknBGPals + 1 palettes
	call LoadHLPaletteIntoDE
	ld hl, GSIntroYellowPal
	ld de, UnknOBPals
	call LoadHLPaletteIntoDE
	ld hl, GSIntroYellowPal
	call LoadHLPaletteIntoDE
	jp WipeAttrMap

_CGB19: ; 94fa
	ld de, UnknBGPals
	ld a, $4e
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld hl, CrystalIntroPalette
	ld de, UnknOBPals
	call LoadHLPaletteIntoDE
	ld hl, CrystalIntroPalette
	ld de, UnknOBPals + 1 palettes
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	jp ApplyAttrMapAndPals
; 9521

CrystalIntroPalette: ; 9521
	RGB 31, 31, 31
	RGB 13, 11, 00
	RGB 23, 12, 28
	RGB 00, 00, 00

GSIntroYellowPal: ; 9521
	RGB 31, 31, 31
	RGB 25, 30, 00
	RGB 25, 30, 00
	RGB 25, 30, 00

SecondLogoIntroPal:
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 23, 12, 28
; 9529

_CGB1a: ; 9529
	ld de, UnknBGPals
	ld a, [wCurPartySpecies]
	ld bc, TempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	jp ApplyAttrMapAndPals
; 9555

_CGB1b: ; 9555
	ld hl, PalPacket_9cc6
	call CopyFourPalettes
	ld hl, Palettes_b681
	ld de, UnknOBPals
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
	ld de, UnknOBPals + 7 palettes
	ld a, $1c
	call GetPredefPal
	call LoadHLPaletteIntoDE
	jp WipeAttrMap
; 9578

_CGB_FrontpicPals: ; 9578
	ld de, UnknBGPals
	ld a, [wCurPartySpecies]
	ld bc, TempMonDVs
	call GetFrontpicPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	jp ApplyAttrMapAndPals
; 9591
