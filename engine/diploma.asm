_Diploma::
	call Function1dd709
	jp WaitPressAorB_BlinkCursor

Function1dd709:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	ld hl, LZ_1dd805
	ld de, VTiles2
	call Decompress
	ld hl, Tilemap_1ddc4b
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst CopyBytes
	ld de, .string_player
	hlcoord 2, 5
	call PlaceText
	ld de, PlayerName
	hlcoord 9, 5
	call PlaceString
	ld de, .congratulations
	hlcoord 2, 8
	call PlaceText
	call EnableLCD
	call ApplyTilemapInVBlank
	ld b, SCGB_SCROLLINGMENU
	predef GetSGBLayout
	call SetPalettes
	jp DelayFrame

.string_player
	text "Player"
	done

.congratulations
	ctxt "This certifies"
	next "that you have"
	next "completed the"
	next "new #dex."
	next "Congratulations!"
	done

Function1dd7ae:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $7f
	call ByteFill
	ld hl, Tilemap_1dddb3
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst CopyBytes
	ld de, .signature_text
	hlcoord 8, 0
	call PlaceText
	ld de, .play_time_text
	hlcoord 3, 15
	call PlaceText
	hlcoord 12, 15
	ld de, GameTimeHours
	lb bc, 2, 4
	call PrintNum
	ld [hl], $67
	inc hl
	ld de, GameTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	jp PrintNum

.play_time_text
	ctxt "Play Time"
	done

.signature_text
	text "GAME FREAK"
	done

LZ_1dd805: INCBIN "gfx/unknown/1dd805.2bpp.lz"

Tilemap_1ddc4b: INCBIN "gfx/unknown/1ddc4b.tilemap"

Tilemap_1dddb3: INCBIN "gfx/unknown/1dddb3.tilemap"
