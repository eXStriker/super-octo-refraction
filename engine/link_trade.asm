LinkCommsBorderGFX: INCBIN "gfx/unknown/16cfc1.2bpp"

_LoadTradeScreenBorder:
	ld de, LinkCommsBorderGFX
	ld hl, VTiles2
	lb bc, BANK(LinkCommsBorderGFX), 70
	jp Get2bpp

Function16d42e:
	ld hl, Tilemap_16d465
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst CopyBytes
	ret

Function16d43b:
	call LoadStandardMenuDataHeader
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call _LoadTradeScreenBorder
	call Function16d42e
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	call ApplyTilemapInVBlank
	call JoyWaitAorB
	jp ExitMenu

Tilemap_16d465: INCBIN "gfx/unknown/16d465.tilemap"

Tilemap_16d5cd: INCBIN "gfx/unknown/16d5cd.tilemap"

Tilemap_16d5f5: INCBIN "gfx/unknown/16d5f5.tilemap"

LinkTextBox:
	ld h, d
	ld l, e
Predef_LinkTextbox:
	push bc
	push hl
	call .draw_border
	pop hl
	pop bc

	ld de, AttrMap - TileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, $7
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .row
	ret

.draw_border
	push hl
	ld a, $30
	ld [hli], a
	inc a
	call .fill_row
	inc a
	ld [hl], a
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
.loop
	push hl
	ld a, $33
	ld [hli], a
	ld a, " "
	call .fill_row
	ld [hl], $34
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .loop

	ld a, $35
	ld [hli], a
	ld a, $36
	call .fill_row
	ld [hl], $37
	ret

.fill_row
	ld d, c
.loop4
	ld [hli], a
	dec d
	jr nz, .loop4
	ret

InitTradeSpeciesList:
	call _LoadTradeScreenBorder
	call Function16d6ae
	callba InitMG_Mobile_LinkTradePalMap
	callba PlaceTradePartnerNamesAndParty
	hlcoord 10, 17
	ld de, .CANCEL
	jp PlaceText

.CANCEL
	text "Cancel"
	done

LinkComms_LoadPleaseWaitTextboxBorderGFX:
	ld de, LinkCommsBorderGFX + $30 tiles
	ld hl, VTiles2 tile $76
	lb bc, BANK(LinkCommsBorderGFX), 8
	jp Get2bpp

Function16d6ae:
	call Function16d42e
	ld hl, Tilemap_16d5cd
	decoord 0, 0
	ld bc, 2 * SCREEN_WIDTH
	rst CopyBytes
	ld hl, Tilemap_16d5f5
	decoord 0, 16
	ld bc, 2 * SCREEN_WIDTH
	rst CopyBytes
	ret

Function16d6ce:
	call LoadStandardMenuDataHeader
	call Function16d6e1
	callba Function87d
	call ExitMenu
	jp ApplyAttrAndTilemapInVBlank

Function16d6e1:
	hlcoord 4, 10
	lb bc, 1, 10
	predef Predef_LinkTextbox
	hlcoord 5, 11
	ld de, .Waiting
	call PlaceText
	call ApplyTilemapInVBlank
	call ApplyAttrAndTilemapInVBlank
	ld c, 50
	jp DelayFrames

.Waiting
	text "WAITING..!"
	done

LinkTradeMenu:
	call .MenuAction

.GetJoypad
	push bc
	push af
	ld a, [hJoyLast]
	and D_PAD
	ld b, a
	ld a, [hJoyPressed]
	and BUTTONS
	or b
	ld b, a
	pop af
	ld a, b
	pop bc
	ld d, a
	ret

.MenuAction
	ld hl, w2DMenuFlags2
	res 7, [hl]
	ld a, [hBGMapMode]
	push af
	call .loop
	pop af
	ld [hBGMapMode], a
	ret

.loop
	call .UpdateCursor
	call .UpdateBGMapAndOAM
	call .loop2
	ret nc
	callba _2DMenuInterpretJoypad
	ret c
	ld a, [w2DMenuFlags1]
	bit 7, a
	ret nz
	call .GetJoypad
	ld b, a
	ld a, [wMenuJoypadFilter]
	and b
	jr z, .loop
	ret

.UpdateBGMapAndOAM
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call ApplyTilemapInVBlank
	pop af
	ld [hOAMUpdate], a
	xor a
	ld [hBGMapMode], a
	ret

.loop2
	call RTC
	call .TryAnims
	ret c
	ld a, [w2DMenuFlags1]
	bit 7, a
	jr z, .loop2
	and a
	ret

.UpdateCursor
	ld hl, wCursorCurrentTile
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	cp $1f
	jr nz, .not_currently_selected
	ld a, [wCursorOffCharacter]
	ld [hl], a
	push hl
	push bc
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld [hl], a
	pop bc
	pop hl

.not_currently_selected
	ld a, [w2DMenuCursorInitY]
	ld b, a
	ld a, [w2DMenuCursorInitX]
	ld c, a
	call Coord2Tile
	ld a, [w2DMenuCursorOffsets]
	swap a
	and $f
	ld c, a
	ld a, [wMenuCursorY]
	ld b, a
	xor a
	dec b
	jr z, .skip
.loop3
	add c
	dec b
	jr nz, .loop3

.skip
	ld c, SCREEN_WIDTH
	rst AddNTimes
	ld a, [w2DMenuCursorOffsets]
	and $f
	ld c, a
	ld a, [wMenuCursorX]
	ld b, a
	xor a
	dec b
	jr z, .skip2
.loop4
	add c
	dec b
	jr nz, .loop4

.skip2
	ld c, a
	add hl, bc
	ld a, [hl]
	cp $1f
	jr z, .cursor_already_there
	ld [wCursorOffCharacter], a
	ld [hl], $1f
	push hl
	push bc
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld [hl], $1f
	pop bc
	pop hl
.cursor_already_there
	ld a, l
	ld [wCursorCurrentTile], a
	ld a, h
	ld [wCursorCurrentTile + 1], a
	ret

.TryAnims
	ld a, [w2DMenuFlags1]
	bit 6, a
	jr z, .skip_anims
	callba PlaySpriteAnimationsAndDelayFrame
.skip_anims
	call JoyTextDelay
	call .GetJoypad
	add a, -1 ; set carry if nonzero
	ret
