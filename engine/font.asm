_LoadStandardFont::
	ld de, Font
	ld hl, VTiles1
	lb bc, BANK(Font), $80
	ld a, [rLCDC]
	bit 7, a
	jp z, Copy1bpp

	ld de, Font
	ld hl, VTiles1
	lb bc, BANK(Font), $20
	call Get1bpp
	ld de, Font + $20 * LEN_1BPP_TILE
	ld hl, VTiles1 tile $20
	lb bc, BANK(Font), $20
	call Get1bpp
	ld de, Font + $40 * LEN_1BPP_TILE
	ld hl, VTiles1 tile $40
	lb bc, BANK(Font), $20
	call Get1bpp
	ld de, Font + $60 * LEN_1BPP_TILE
	ld hl, VTiles1 tile $60
	lb bc, BANK(Font), $20
	jp Get1bpp

_LoadFontsExtra1::
	ld de, .SolidBlackTile
	ld hl, VTiles2 tile $60
	lb bc, BANK(_LoadFontsExtra1), 1
	call Get1bpp
	ld de, FontExtra + 3 tiles
	ld hl, VTiles2 tile $63
	lb bc, BANK(FontExtra), $16
	call Get2bpp
	jr LoadFrame

.SolidBlackTile
rept 8
	db $ff
endr

_LoadFontsExtra2::
	ld de, GFX_f9424
	ld hl, VTiles2 tile $61
	lb bc, BANK(GFX_f9424), 1
	jp Get2bpp

_LoadFontsBattleExtra::
	ld de, FontBattleExtra
	ld hl, VTiles2 tile $60
	lb bc, BANK(FontBattleExtra), $19
	call Get2bpp

LoadFrame:
	call GetFramePointer
	lb bc, BANK(Frames), TILES_PER_FRAME
	call Get1bpp
	ld hl, VTiles2 tile $7f
	ld de, TextBoxSpaceGFX
	lb bc, BANK(TextBoxSpaceGFX), 1
	jp Get1bpp

GetFramePointer:
	ld a, [TextBoxFrame]
	and 7
	ld bc, TILES_PER_FRAME * LEN_1BPP_TILE
	ld hl, Frames
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $79
	ret

LoadBattleFontsHPBar:
	ld de, FontBattleExtra
	ld hl, VTiles2 tile $60
	lb bc, BANK(FontBattleExtra), $c
	call Get2bpp
	ld hl, VTiles2 tile $70
	ld de, FontBattleExtra + $10 * LEN_2BPP_TILE
	lb bc, BANK(FontBattleExtra), 3
	call Get2bpp
	call LoadFrame

LoadHPBar:
	ld de, EnemyHPBarBorderGFX
	ld hl, VTiles2 tile $6c
	lb bc, BANK(EnemyHPBarBorderGFX), 4
	call Get1bpp
	ld de, HPExpBarBorderGFX
	ld hl, VTiles2 tile $73
	lb bc, BANK(HPExpBarBorderGFX), 6
	call Get1bpp
	ld de, ExpBarGFX
	ld hl, VTiles2 tile $55
	lb bc, BANK(ExpBarGFX), 9
	jp Get2bpp

Functionfb53e:
	call _LoadFontsBattleExtra
	ld de, EnemyHPBarBorderGFX
	ld hl, VTiles2 tile $6c
	lb bc, BANK(EnemyHPBarBorderGFX), 4
	call Get1bpp
	ld de, HPExpBarBorderGFX
	ld hl, VTiles2 tile $78
	lb bc, BANK(HPExpBarBorderGFX), 1
	call Get1bpp
	ld de, HPExpBarBorderGFX + 3 * LEN_1BPP_TILE
	ld hl, VTiles2 tile $76
	lb bc, BANK(HPExpBarBorderGFX), 2
	call Get1bpp
	ld de, ExpBarGFX
	ld hl, VTiles2 tile $55
	lb bc, BANK(ExpBarGFX), 8
	call Get2bpp

Functionfb571:
	ld de, GFX_f89b0
	ld hl, VTiles2 tile $31
	lb bc, BANK(GFX_f89b0), $11
	jp Get2bpp
