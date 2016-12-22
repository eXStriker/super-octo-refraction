TreasureBag::
	call ClearScreen
	call DisableLCD
	ld a, "─"
	coord hl, 0, 0
	ld bc, SCREEN_WIDTH
	call ByteFill ; for now
	call PrintTreasureBagItems
	ld hl, w2DMenuCursorInitY
	ld a, 2
	ld [hli], a ; cursor init y
	xor a
	ld [hli], a ; cursor init x
	ld a, 5
	ld [hli], a ; num rows
	ld a, 2
	ld [hli], a ; num cols
	ld a, %1111
	ld [hli], a ; flags 1
	xor a
	ld [hli], a ; flags 2
	ln a, 2, 10
	ld [hli], a ; cursor offsets
	ld a, B_BUTTON | D_LEFT | D_RIGHT | D_UP | D_DOWN
	ld [hli], a ; joypad filter
	ld a, 1
	ld [hli], a ; cursor y
	ld [hli], a ; cursor x
	ld a, " "
	ld [hli], a ; cursor off character
	ld a, (TileMap + 2 * SCREEN_WIDTH + 1) & $ff
	ld [hli], a
	ld [hl], (TileMap + 2 * SCREEN_WIDTH + 1) >> 8 ; cursor cur tile address
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	call EnableLCD
	call DelayFrame
.updateBagDesc
	call UpdateTreasureBagDesc
.treasureBagLoop
	call DoMenuJoypadLoop
	ld a, [w2DMenuFlags2]
	bit 7, a
	jr nz, .treasureBagLoop
	ld a, [hJoyPressed]
	cp B_BUTTON
	jr nz, .updateBagDesc
.done
	ld de, SFX_READ_TEXT_2
	jp PlaySFX

PrintTreasureBagItems:
	ld de, wTreasureBag
	ld hl, VTiles2
	lb bc, 0, 0
	jr .handleLoop
.loop
	inc de
	push de ; treasure bag
	push bc ; item count
	push hl ; vtile address
	ld [wd265], a
	call GetItemName
	ld hl, wMisc
	call CopyName2
	pop hl ; retrieve vtile address
	push hl ; push again for later
	ld de, wMisc
	lb bc, 0, 9
	predef PlaceVWFString
	pop hl ; popped just to get to bc
	pop bc ; count
	push hl ; save vtile address again
	ld a, c
	cp 5
	coord hl, 1, 2
	jr c, .firstColumn
	coord hl, 11, 2 
	sub 5
.firstColumn
	push bc ; protect from AddNTimes
	ld bc, SCREEN_WIDTH * 2
	rst AddNTimes
	pop bc ; restore
; write to tilemap
	ld a, b
	ld d, 9
.fillIncLoop
	ld [hli], a
	inc a
	dec d
	jr nz, .fillIncLoop
	ld b, a
	pop hl ; restore vtile
	ld a, 9 * $10
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	pop de ; restore bag
	inc c
.handleLoop
	ld a, [de]
	cp $ff
	jr nz, .loop
	ret

UpdateTreasureBagDesc:
	ld a, [wMenuCursorX]
	dec a
	ld c, 5
	call SimpleMultiply
	ld c, a
	ld a, [wMenuCursorY]
	dec a
	add c
	ld hl, wTreasureBagCount
	cp [hl]
	jp nc, SpeechTextBox
	inc a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hl]
	ld [wMenuSelection], a
	jpba UpdateItemDescription