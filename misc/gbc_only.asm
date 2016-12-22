GBCOnlyScreen:
	ld de, MUSIC_NONE
	call PlayMusic

	call ClearTileMapNoDelay

	ld hl, GBCOnlyGFX
	call DecompressWRA6

	ld de, $d000
	ld hl, VTiles2
	lb bc, BANK(GBCOnlyGFX), $54
	ld a, hRequested2bpp & $ff
	call Get1or2bppDMG

	ld de, Font
	ld hl, VTiles1
	lb bc, BANK(Font), $80
	ld a, hRequested1bpp & $ff
	call Get1or2bppDMG

	call DrawGBCOnlyScreen

	xor a
	ld [hVBlank], a
	call DMGCompatBGMapTransfer
	ld a, 7
	ld [hVBlank], a
	call DelayFrame
	ld a, $e4
	ld [rBGP], a
	ld bc, 15600

; better luck next time
.loop
	call DelayFrame
	dec bc
	ld a, b
	or c
	jr nz, .loop
.easterEgg
	call Random
	ld c, 8
	call DelayFrames
	ld a, [hRandomAdd]
	ld [rBGP], a
	jr .easterEgg

DrawGBCOnlyScreen:

	call DrawGBCOnlyBorder

	; Pokemon
	hlcoord 3, 2
	lb bc, 14, 4
	ld a, $8
	call DrawGBCOnlyGraphic

	; Crystal
	hlcoord 5, 6
	lb bc, 10, 2
	ld a, $40
	call DrawGBCOnlyGraphic

	ld de, GBCOnlyString
	hlcoord 1, 10
	jp PlaceText

DrawGBCOnlyBorder:

	hlcoord 0, 0
	ld [hl], 0 ; top-left

	inc hl
	ld a, 1 ; top
	call .FillRow

	ld [hl], 2 ; top-right

	hlcoord 0, 1
	ld a, 3 ; left
	call .FillColumn

	hlcoord 19, 1
	ld a, 4 ; right
	call .FillColumn

	hlcoord 0, 17
	ld [hl], 5 ; bottom-left

	inc hl
	ld a, 6 ; bottom
	call .FillRow

	ld [hl], 7 ; bottom-right
	ret

.FillRow
	ld c, SCREEN_WIDTH - 2
.next_column
	ld [hli], a
	dec c
	jr nz, .next_column
	ret

.FillColumn
	ld de, SCREEN_WIDTH
	ld c, SCREEN_HEIGHT - 2
.next_row
	ld [hl], a
	add hl, de
	dec c
	jr nz, .next_row
	ret

DrawGBCOnlyGraphic:
	ld de, SCREEN_WIDTH
.y
	push bc
	push hl
.x
	ld [hli], a
	inc a
	dec b
	jr nz, .x
	pop hl
	add hl, de
	pop bc
	dec c
	jr nz, .y
	ret

GBCOnlyString:
	ctxt "This Game Pak is"
	next "designed only for"
	next "use on the"
	next "Game Boy Color."
	done

GBCOnlyGFX: INCBIN "gfx/misc/gbc_only.w112.2bpp.lz"
