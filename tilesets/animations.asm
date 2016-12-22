_AnimateTileset::
; Iterate over a given pointer array of
; animation functions (one per frame).

; Typically in wra1, vra0

	ld a, [TilesetAnim]
	ld e, a
	ld a, [TilesetAnim + 1]
	ld d, a

	ld a, [hTileAnimFrame]
	ld l, a
	inc a
	ld [hTileAnimFrame], a

	ld h, 0
	add hl, hl
	add hl, hl
	add hl, de

; 2-byte parameter
; All functions take input de.
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

; Function address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	jp hl

Tileset03Anim:

	dw VTiles2 tile $14, AnimateWaterTile
	dw VTiles2 tile $09, WriteTileToBuffer_Bank1
	dw wTileAnimBuffer, ScrollTileDown
	dw VTiles2 tile $09, WriteTileFromBuffer_Bank1
	dw NULL,  TileAnimationPalette
	dw NULL,  WaitTileAnimation
	dw VTiles2 + $30,  AnimateFlowerTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset00Anim:
Tileset02Anim:
Tileset34Anim:
Tileset35Anim:
	dw VTiles2 tile $14, AnimateWaterTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  TileAnimationPalette
	dw NULL,  WaitTileAnimation
	dw VTiles2 + $30,  AnimateFlowerTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset31Anim:
	dw VTiles2 tile $0c,  ForestTreeLeftAnimation
	dw VTiles2 tile $0f,  ForestTreeRightAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw VTiles2 tile $0c,  ForestTreeLeftAnimation2
	dw VTiles2 tile $0f,  ForestTreeRightAnimation2
	dw VTiles2 + $30,  AnimateFlowerTile
	dw VTiles2 tile $14, AnimateWaterTile
	dw NULL,  TileAnimationPalette
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset01Anim:
	dw VTiles2 tile $14, AnimateWaterTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  TileAnimationPalette
	dw NULL,  WaitTileAnimation
	dw VTiles2 + $30,  AnimateFlowerTile
	dw WhirlpoolFrames1, AnimateWhirlpoolTile
	dw WhirlpoolFrames2, AnimateWhirlpoolTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset08Anim:
Tileset28Anim:
Tileset44Anim:
Tileset45Anim:
	dw VTiles2 tile $14, AnimateWaterTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  TileAnimationPalette
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset14Anim:
	dw VTiles2 tile $38,  SafariFountainAnim2
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw VTiles2 tile $5b,  SafariFountainAnim1
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset33Anim:
	dw VTiles2 tile $2,  SafariFountainAnim2
	dw NULL,  MagmaPaletteAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw VTiles2 tile $3,  SafariFountainAnim1
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset24Anim:
Tileset21Anim:
Tileset48Anim:
Tileset49Anim:
Tileset50Anim:
Tileset51Anim:
Tileset52Anim:
Tileset53Anim:
	dw VTiles2 tile $14, WriteTileToBuffer
	dw NULL,  FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileRightLeft
	dw NULL,  FlickeringCaveEntrancePalette
	dw VTiles2 tile $14, WriteTileFromBuffer
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  TileAnimationPalette
	dw NULL,  FlickeringCaveEntrancePalette
	dw VTiles2 tile $40, WriteTileToBuffer
	dw NULL,  FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileDown
	dw NULL,  FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileDown
	dw NULL,  FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileDown
	dw NULL,  FlickeringCaveEntrancePalette
	dw VTiles2 tile $40, WriteTileFromBuffer
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  DoneTileAnimation

Tileset17Anim:
	dw VTiles2 tile $2e, AnimateMeterTile
	dw NULL,  WaitTileAnimation
	dw VTiles2 tile $2f, AnimateWaterTile
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset42Anim:
	dw VTiles2 tile $14, AnimateWaterTile
	dw VTiles2 tile $02, WriteTileToBuffer
	dw wTileAnimBuffer,  ScrollTileDown
	dw VTiles2 tile $02, WriteTileFromBuffer
	dw VTiles2 tile $03, WriteTileToBuffer
	dw wTileAnimBuffer,  ScrollTileUp
	dw VTiles2 tile $03, WriteTileFromBuffer
	; dw NULL,  TileAnimationPalette
	dw NULL,  WaitTileAnimation
	dw VTiles2 tile $12, WriteTileToBuffer
	dw wTileAnimBuffer,  ScrollTileLeft
	dw VTiles2 tile $12, WriteTileFromBuffer
	dw VTiles2 tile $13, WriteTileToBuffer
	dw wTileAnimBuffer,  ScrollTileRight
	dw VTiles2 tile $13, WriteTileFromBuffer
	dw NULL,  StandingTileFrame8
	dw NULL,  DoneTileAnimation

Tileset27Anim:
	dw VTiles2 tile $14, WriteTileToBuffer
	dw NULL,  FlickeringCaveEntrancePalette
	dw wTileAnimBuffer, ScrollTileRightLeft
	dw NULL,  FlickeringCaveEntrancePalette
	dw VTiles2 tile $14, WriteTileFromBuffer
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  TileAnimationPalette
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  WaitTileAnimation
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  WaitTileAnimation
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  WaitTileAnimation
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  WaitTileAnimation
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  WaitTileAnimation
	dw NULL,  FlickeringCaveEntrancePalette
	dw NULL,  DoneTileAnimation

Tileset30Anim:
Tileset04Anim:
Tileset05Anim:
Tileset06Anim:
Tileset07Anim:
Tileset10Anim:
Tileset11Anim:
Tileset12Anim:
Tileset13Anim:
Tileset16Anim:
Tileset18Anim:
Tileset19Anim:
Tileset20Anim:
Tileset22Anim:
Tileset26Anim:
Tileset32Anim:
Tileset36Anim:
Tileset37Anim:
Tileset38Anim:
Tileset39Anim:
Tileset40Anim:
Tileset41Anim:
Tileset43Anim:
Tileset46Anim:
Tileset25Anim:
Tileset15Anim:
Tileset29Anim:
Tileset23Anim:
Tileset09Anim:
Tileset47Anim:
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  WaitTileAnimation
	dw NULL,  DoneTileAnimation

DoneTileAnimation:
; Reset the animation command loop.
	xor a
	ld [hTileAnimFrame], a
	; fallthrough

WaitTileAnimation:
; Do nothing this frame.
	ret

StandingTileFrame8:
	ld a, [TileAnimationTimer]
	inc a
	and a, 7
	ld [TileAnimationTimer], a
	ret

ScrollTileRightLeft:
; Scroll right for 4 ticks, then left for 4 ticks.
	ld a, [TileAnimationTimer]
	inc a
	and 7
	ld [TileAnimationTimer], a
	and 4
	jr z, ScrollTileRight
	; fallthrough

ScrollTileLeft:
	ld h, d
	ld l, e
	ld c, 4
.loop
	rept 4
	ld a, [hl]
	rlca
	ld [hli], a
	endr
	dec c
	jr nz, .loop
	ret

ScrollTileRight:
	ld h, d
	ld l, e
	ld c, 4
.loop
	rept 4
	ld a, [hl]
	rrca
	ld [hli], a
	endr
	dec c
	jr nz, .loop
	ret

ScrollTileUpDown:
; Scroll up for 4 ticks, then down for 4 ticks.
	ld a, [TileAnimationTimer]
	inc a
	and 7
	ld [TileAnimationTimer], a
	and 4
	jr nz, ScrollTileDown
	; fallthrough

ScrollTileUp:
	ld h, d
	ld l, e
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld bc, $e
	add hl, bc
	ld a, 4
.loop
	ld c, [hl]
	ld [hl], e
	dec hl
	ld b, [hl]
	ld [hl], d
	dec hl
	ld e, [hl]
	ld [hl], c
	dec hl
	ld d, [hl]
	ld [hl], b
	dec hl
	dec a
	jr nz, .loop
	ret

ScrollTileDown:
	ld h, d
	ld l, e
	ld de, $e
	push hl
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop hl
	ld a, 4
.loop
	ld b, [hl]
	ld [hl], d
	inc hl
	ld c, [hl]
	ld [hl], e
	inc hl
	ld d, [hl]
	ld [hl], b
	inc hl
	ld e, [hl]
	ld [hl], c
	inc hl
	dec a
	jr nz, .loop
	ret

AnimateFountain:
	ld hl, .frames
	ld a, [TileAnimationTimer]
	and 7
	add a
	add l
	ld l, a
	jr nc, .okay
	inc h
.okay
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp WriteTile

.frames
	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame1

.frame1 INCBIN "gfx/tilesets/fountain/1.2bpp"
.frame2 INCBIN "gfx/tilesets/fountain/2.2bpp"
.frame3 INCBIN "gfx/tilesets/fountain/3.2bpp"
.frame4 INCBIN "gfx/tilesets/fountain/4.2bpp"
.frame5 INCBIN "gfx/tilesets/fountain/5.2bpp"

AnimateWaterTile:
; Draw a water tile for the current frame in VRAM tile at de.
	ld a, [TileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1

; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a

	add WaterTileFrames % $100
	ld l, a
	ld a, 0
	adc WaterTileFrames / $100
	ld h, a

	jp WriteTile

WaterTileFrames: INCBIN "gfx/tilesets/water.2bpp"

AnimateMeterTile:
; Draw a meter tile for the current frame in VRAM tile at de.
	ld a, [TileAnimationTimer]

; 4 tile graphics, updated every other frame.
	and 3 << 1

; 2 x 8 = 16 bytes per tile
	add a
	add a
	add a

	add MeterTileFrames % $100
	ld l, a
	ld a, 0
	adc MeterTileFrames / $100
	ld h, a

	jp WriteTile

MeterTileFrames: INCBIN "gfx/tilesets/meter.2bpp"

ForestTreeLeftAnimation:
; Only during the Celebi event.
	ld a, [wCelebiEvent]
	bit 2, a
	ret z

	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	jr GetForestTreeLeftSourceAndWriteTile

ForestTreeLeftAnimation2:
; Only during the Celebi event.
	ld a, [wCelebiEvent]
	bit 2, a
	ret z

	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	xor 2
GetForestTreeLeftSourceAndWriteTile:
	add a
	add a
	add a
	ld hl, ForestTreeLeftFrames
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	jp WriteTile

ForestTreeRightAnimation:
; Only during the Celebi event.
	ld a, [wCelebiEvent]
	bit 2, a
	ret z

	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	jr GetForestTreeRightSourceAndWriteTile

ForestTreeRightAnimation2:
; Only during the Celebi event.
	ld a, [wCelebiEvent]
	bit 2, a
	ret z

	ld a, [TileAnimationTimer]
	call GetForestTreeFrame
	xor 2
GetForestTreeRightSourceAndWriteTile:
	add a
	add a
	add a
	add ForestTreeRightFrames % $100
	ld l, a
	ld a, 0
	adc ForestTreeRightFrames / $100
	ld h, a
	jp WriteTile

ForestTreeLeftFrames:
	INCBIN "gfx/tilesets/forest-tree/1.2bpp"
	INCBIN "gfx/tilesets/forest-tree/2.2bpp"

ForestTreeRightFrames:
	INCBIN "gfx/tilesets/forest-tree/3.2bpp"
	INCBIN "gfx/tilesets/forest-tree/4.2bpp"

GetForestTreeFrame:
; Return 0 if a is even, or 2 if odd.
	rra
	sbc a
	and 5
	rra ; 5 becomes 2 and carry, 0 becomes 0 and no carry
	ret

AnimateFlowerTile:
; No parameters.

; Alternate tile graphic every other frame
	ld a, [TileAnimationTimer]
	and 1 << 1
	inc a
	swap a ; << 4 (16 bytes)
	ld hl, FlowerTileFrames
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	jp WriteTile

FlowerTileFrames:
	INCBIN "gfx/tilesets/flower/dmg_1.2bpp"
	INCBIN "gfx/tilesets/flower/cgb_1.2bpp"
	INCBIN "gfx/tilesets/flower/dmg_2.2bpp"
	INCBIN "gfx/tilesets/flower/cgb_2.2bpp"

SafariFountainAnim1:
; Splash in the bottom-right corner of the fountain.
	ld a, [TileAnimationTimer]
	and 6
	srl a
	inc a
	inc a
	and 3
	swap a
	ld hl, SafariFountainFrames
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	jp WriteTile

SafariFountainAnim2:
; Splash in the top-left corner of the fountain.
	ld a, [TileAnimationTimer]
	and 6
	add a
	add a
	add a
	ld hl, SafariFountainFrames
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	jp WriteTile

SafariFountainFrames:
	INCBIN "gfx/tilesets/safari/1.2bpp"
	INCBIN "gfx/tilesets/safari/2.2bpp"
	INCBIN "gfx/tilesets/safari/3.2bpp"
	INCBIN "gfx/tilesets/safari/4.2bpp"

AnimateSproutPillarTile:
; Read from struct at de:
; 	Destination (VRAM)
;	Address of the first tile in the frame array

	ld a, [TileAnimationTimer]
	and 7

; Get frame index a
	add .frames & $ff
	ld l, a
	ld a, 0
	add .frames >> 8
	ld h, a
	ld a, [hl]

; Destination
	ld h, d
	ld l, e
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

; Add the frame index to the starting address
	add [hl]
	inc hl
	ld h, [hl]
	ld l, a
	jr nc, WriteTile
	inc h
	jr WriteTile

.frames
	db $00, $10, $20, $30, $40, $30, $20, $10

StandingTileFrame:
	ld hl, TileAnimationTimer
	inc [hl]
	ret

AnimateWhirlpoolTile:
; Update whirlpool tile using struct at de.

; Struct:
; 	VRAM address
;	Address of the first tile

; Only does one of 4 tiles at a time.

; de = VRAM address
	ld h, d
	ld l, e
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
; Tile address is now at hl.

; Get the tile for this frame.
	ld a, [TileAnimationTimer]
	and %11 ; 4 frames x2
	swap a  ; * 16 bytes per tile

	add [hl]
	inc hl
	ld h, [hl]
	ld l, a
	jr nc, WriteTile
	inc h
	jr WriteTile

WriteTileFromBuffer_Bank1:
	call SafeStackCallInVBK1
WriteTileFromBuffer:
; Write tiledata at wTileAnimBuffer to de.
	ld hl, wTileAnimBuffer
	jr WriteTile

WriteTileToBuffer_Bank1:
	call SafeStackCallInVBK1
WriteTileToBuffer:
; Write tiledata de to wTileAnimBuffer.
	ld h, d
	ld l, e

	ld de, wTileAnimBuffer

; fallthrough
WriteTile:
; Write one 8x8 tile ($10 bytes) from hl to de.
; double speed allows us to do a simple unrolled 16 byte copy
; abusing inc e for speed

rept 15
	ld a, [hli]
	ld [de], a
	inc e
endr
	ld a, [hl]
	ld [de], a
	ret

TileAnimationPalette:
; Transition between color values 0-2 for color 0 in palette 3.

; We don't want to mess with non-standard palettes.
	ld a, [rBGP] ; BGP
	cp %11100100
	ret nz

; Only update on even frames.
	ld a, [TileAnimationTimer]
	ld e, a
	rra ; odd
	ret c

; Ready for BGPD input...
	ld a, $80 | (3 palettes)
	ld [rBGPI], a

	ld a, BANK(UnknBGPals)
	call SafeStackCallInWramBankA

; Update color 0 in order 0 1 2 1

	ld a, e
	and %110 ; frames 0 2 4 6
	ld hl, UnknBGPals + 3 palettes
	jr z, ApplyTilesetAnimation_SingleColor
	and 2
	xor 2
	add 2
	add l
	ld l, a
	jr ApplyTilesetAnimation_SingleColor

MagmaPaletteAnimation:
; We don't want to mess with non-standard palettes.
	ld a, [rBGP]
	cp %11100100
	ret nz

; Only update every four frames
	ld a, [TileAnimationTimer]
	ld e, a
	and 3
	ret nz

	ld a, BANK(UnknBGPals)
	call SafeStackCallInWramBankA

; Ready for BGPD input...
	ld a, $80 | (1 palettes + 4) ; auto-increment, pal 1 color 2
	ld [rBGPI], a
	ld a, e
	and %100
	srl a
	add (1 palettes + 2)
	ld l, a
	ld h, UnknBGPals >> 8
	jr ApplyTilesetAnimation_SingleColor

FlickeringCaveEntrancePalette:
; We don't want to mess with non-standard palettes.
	ld a, [rBGP]
	cp %11100100
	ret nz
; We only want to be here if we're in a dark cave.
	ld a, [wTimeOfDayPalset]
	cp $ff ; 3,3,3,3
	ret nz

	ld a, BANK(UnknBGPals)
	call SafeStackCallInWramBankA
; Ready for BGPD input...
	ld a, $80 | (4 palettes) ; auto-increment, index $20 (pal 4 color 0)
	ld [rBGPI], a
	ld a, [hVBlankCounter]
	and %00000010
	add 4 palettes
	ld l, a
	ld h, UnknBGPals >> 8
ApplyTilesetAnimation_SingleColor:
	ld a, [hli]
	ld [rBGPD], a
	ld a, [hli]
	ld [rBGPD], a
	ret

WhirlpoolFrames1: dw VTiles2 tile $20, WhirlpoolTiles1
WhirlpoolFrames2: dw VTiles2 tile $35, WhirlpoolTiles2

WhirlpoolTiles1: INCBIN "gfx/tilesets/whirlpool/1.2bpp"
WhirlpoolTiles2: INCBIN "gfx/tilesets/whirlpool/2.2bpp"
