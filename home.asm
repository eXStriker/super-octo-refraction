SECTION "NULL", ROM0[0]
NULL::

INCLUDE "rst.asm"
INCLUDE "interrupts.asm"
INCLUDE "home/highhome.asm"
INCLUDE "home/crash.asm"
INCLUDE "home/hp_pal.asm"

PlayFaintingCry::
	call PlayFaintingCry2
	jp WaitSFX

SECTION "Version", ROM0[$FC]
BuildNumber:: bigdw BUILD_NUMBER
VersionNumber::
	db VERSION_MAJOR
	db VERSION_MINOR

SECTION "Header", ROM0[$100]

Start::
	nop
	jp _Start

	rept ($150 - $104)
		db $00 ; zero-filling the header for rgbfix, since it clashes with $ff padding otherwise
	endr

SECTION "Home", ROM0[$150]

INCLUDE "home/init.asm"
INCLUDE "home/vblank.asm"
INCLUDE "home/delay.asm"
INCLUDE "home/rtc.asm"
INCLUDE "home/fade.asm"
INCLUDE "home/lcd.asm"
INCLUDE "home/time.asm"
INCLUDE "home/serial.asm"
INCLUDE "home/joypad.asm"
INCLUDE "home/decompress.asm"
INCLUDE "home/palettes.asm"
INCLUDE "home/copy.asm"
INCLUDE "home/text.asm"
INCLUDE "home/video.asm"
INCLUDE "home/map_objects.asm"
INCLUDE "home/sine.asm"
INCLUDE "home/movement.asm"
INCLUDE "home/menu2.asm"
INCLUDE "home/tilemap.asm"
INCLUDE "home/menu.asm"
INCLUDE "home/handshake.asm"
INCLUDE "home/game_time.asm"
INCLUDE "home/stopwatch.asm"
INCLUDE "home/map.asm"
INCLUDE "home/count_events.asm"

INCLUDE "home/predef.asm"
INCLUDE "home/farcall.asm"
INCLUDE "home/window.asm"

INCLUDE "home/flag.asm"
INCLUDE "home/jumptable.asm"

DisableSpriteUpdates::
	xor a
	ld [hMapAnims], a
	ld [wSpriteUpdatesEnabled], a
	ld a, [VramState]
	res 0, a
	ld [VramState], a
	ret

EnableSpriteUpdates::
	ld a, $1
	ld [wSpriteUpdatesEnabled], a
	ld [hMapAnims], a
	ld a, [VramState]
	set 0, a
	ld [VramState], a
	ret

INCLUDE "home/string.asm"
INCLUDE "home/item.asm"
INCLUDE "home/random.asm"
INCLUDE "home/sram.asm"
INCLUDE "home/double_speed.asm"

ClearSprites::
; Erase OAM data
	ld hl, Sprites
	ld b, SpritesEnd - Sprites
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

HideSprites::
; Set all OAM y-positions to 160 to hide them offscreen
	ld hl, Sprites
	ld b, (SpritesEnd - Sprites) / 4 ; number of OAM structs
HideBSpritesFromHL:
	ld de, 4 ; length of an OAM struct
	ld a, 8 * 20 ; y
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

INCLUDE "home/copy2.asm"

LoadTileMapToTempTileMap::
; Load TileMap into TempTileMap
	ld a, [rSVBK]
	push af
	ld a, BANK(TempTileMap)
	ld [rSVBK], a
	hlcoord 0, 0
	decoord 0, 0, TempTileMap
	ld bc, TileMapEnd - TileMap
	rst CopyBytes
	pop af
	ld [rSVBK], a
	ret

Call_LoadTempTileMapToTileMap::
	xor a
	ld [hBGMapMode], a
	call LoadTempTileMapToTileMap
	ld a, 1
	ld [hBGMapMode], a
	ret

LoadTempTileMapToTileMap::
; Load TempTileMap into TileMap
	ld a, [rSVBK]
	push af
	ld a, BANK(TempTileMap)
	ld [rSVBK], a
	hlcoord 0, 0, TempTileMap
	decoord 0, 0
	ld bc, TileMapEnd - TileMap
	rst CopyBytes
	pop af
	ld [rSVBK], a
	ret

CopyName1::
; Copies the name from de to wStringBuffer2
	ld hl, wStringBuffer2

CopyName2::
; Copies the name from de to hl
	push bc
	ld b, "@"
.loop
	ld a, [de]
	inc de
	ld [hli], a
	cp b
	jr nz, .loop
	pop bc
	ret

IsInArray::
; Find value a for every e bytes in array hl.
; Return index in b and carry if found.

	ld b, 0
	ld d, b
	ld c, a
	jr .handleLoop

.loop
	inc b
	add hl, de
.handleLoop
	ld a, [hl]
	cp -1
	jr z, .notInArray
	cp c
	jr nz, .loop
; in array
	scf
	ret
.notInArray
	and a
	ret

IsHMMove::
	ld hl, HMMoves

; fallthrough
IsInSingularArray::
; Find value a in array hl
; Return index in b and carry if found
	ld b, l ; save original count in b
	ld d, $ff
	ld e, a
.loop
	ld a, [hli]
	cp d
	jr z, .notInArray
	cp e
	jr nz, .loop
; in array
	dec hl
	ld a, l
	sub b ; subtract the current offset with the original offset to get the index
	ld b, a
	scf
	ret

.notInArray
	and a
	ret

HMMoves:
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db ROCK_SMASH
	db WATERFALL
	db $ff

INCLUDE "home/math.asm"

PrintLetterDelay::
; Wait before printing the next letter.

; The text speed setting in wOptions is actually a frame count:
; 	fast: 1 frame
; 	mid:  3 frames
; 	slow: 5 frames

; TextBoxFlags[!0] and A or B override text speed with a one-frame delay.
; wOptions[4] and TextBoxFlags[!1] disable the delay.
; non-scrolling text?
	ld a, [wOptions]
	bit NO_TEXT_SCROLL, a
	ret nz
	and %11
	ret z

	ld a, [TextBoxFlags]
	bit 1, a
	ret z

	ld a, $1
	ld [hBGMapHalf], a
	push hl
	push de
	push bc
; force fast scroll?
	ld a, [TextBoxFlags]
	bit 0, a
	ld a, 1
	jr z, .updateDelay
; text speed
	ld a, [wOptions]
	and %11
	dec a
	ld b, 1
	jr z, .updateDelay_B
	dec a
	ld b, 3
	jr z, .updateDelay_B
	ld b, 5
.updateDelay_B
	ld a, b
.updateDelay
	ld [wTextDelayFrames], a
.textDelayLoop
	ld a, [wTextDelayFrames]
	and a
	jr z, .done
	call DelayFrame
	call GetJoypad
; Finish execution if A or B is pressed
	ld a, [hJoyDown]
	and A_BUTTON | B_BUTTON
	jr z, .textDelayLoop
.done
	jp PopOffBCDEHLAndReturn

QueueScript::
; Push pointer hl in the current bank to wQueuedScriptBank.
	ld a, [hROMBank]

FarQueueScript::
; Push pointer a:hl to wQueuedScriptBank.
	ld [wQueuedScriptBank], a
	ld a, l
	ld [wQueuedScriptAddr], a
	ld a, h
	ld [wQueuedScriptAddr + 1], a
	ret

StringCmp::
; Compare c bytes at de and hl.
; Return z if they all match.
.loop
	ld a, [de]
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, .loop
	ret

ScrollingMenu::
	call CopyMenuData2
	anonbankpush _ScrollingMenu

	call _InitScrollingMenu
	call .UpdatePalettes
	call _ScrollingMenu
	ld a, [wMenuJoypad]
	ret

.UpdatePalettes
	ld hl, VramState
	bit 0, [hl]
	jp nz, UpdateTimePals

SetPalettes::
; Inits the Palettes
	push de
	ld a, %11100100
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	call DmgToCgbObjPals
	pop de
	ret

ClearPalettes::
; Make all palettes white
	ld a, BANK(BGPals)
	call StackCallInWRAMBankA

.Function:
; Fill BGPals and OBPals with $ffff (white)
	ld hl, BGPals
	ld bc, 16 palettes
	ld a, $ff
	call ByteFill
; Request palette update
	ld a, 1
	ld [hCGBPalUpdate], a
	ret

CountSetBits::
; Count the number of set bits in b bytes starting from hl.
; Return in a, c and [wd265].

	ld c, 0
.next
	ld a, [hli]
	ld e, a
	ld d, 8

.count
	srl e
	ld a, 0
	adc c
	ld c, a
	dec d
	jr nz, .count

	dec b
	jr nz, .next

	ld a, c
	ld [wd265], a
	ret

GetWeekday::
	lb bc, 6, 0 ; Jan 1, 2000 is Saturday
.yearloop
	ld a, [CurYear]
	cp c
	jr z, .yeardone
	ld a, b
	cp 7
	jr c, .nomod
	sub 7
.nomod
	inc b
	ld a, c
	inc c
	call IsLeapYear
	jr nc, .yearloop
	inc b
	jr .yearloop
.yeardone
	ld a, [CurMonth]
	ld e, a
	cp 2 ; February
	jr c, .skipleapcheck
	ld a, c
	call IsLeapYear
	jr nc, .skipleapcheck
	inc b
.skipleapcheck
	ld d, 0
	ld hl, MonthOffsets
	add hl, de
	ld a, [hl]
	add b
	ld b, a
	ld a, [CurDay]
	add b
.mod
	sub 7
	jr nc, .mod
	add 7
	ret

MonthOffsets:
	; jan feb mar apr may jun jul aug sep oct nov dec
	db  0,  3,  3,  6,  1,  4,  6,  2,  5,  0,  3,  5

INCLUDE "home/pokedex_flags.asm"

INCLUDE "home/get_names.asm"

InitScrollingMenu::
	ld a, [wMenuBorderTopCoord]
	dec a
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	sub b
	ld d, a
	ld a, [wMenuBorderLeftCoord]
	dec a
	ld c, a
	ld a, [wMenuBorderRightCoord]
	sub c
	ld e, a
	push de
	call Coord2Tile
	pop bc
	jp TextBox

GetJoypadForQuantitySelectionMenus::
	call DelayFrame

	ld a, [hInMenu]
	push af
	ld a, $1
	ld [hInMenu], a
	call JoyTextDelay
	pop af
	ld [hInMenu], a

	ld a, [hJoyLast]
	and D_RIGHT + D_LEFT + D_UP + D_DOWN
	ld c, a
	ld a, [hJoyPressed]
	and A_BUTTON + B_BUTTON + SELECT + START
	or c
	ld c, a
	ret

INCLUDE "home/stone_queue.asm"

INCLUDE "home/trainer.asm"

IsAPokemon::
; Return carry if species a is not a Pokemon.
	and a
	jr z, .NotAPokemon
	cp EGG
	jr z, .Pokemon
	cp NUM_POKEMON + 1
	jr c, .Pokemon

.NotAPokemon
	scf
	ret

.Pokemon:
	and a
	ret

PrepMonFrontpic::
	ld a, $1
	ld [wBoxAlignment], a
	; fallthrough

_PrepMonFrontpic::
	ld a, [wCurPartySpecies]
	call IsAPokemon
	jr c, .not_pokemon

	push hl
	ld de, VTiles2
	predef GetFrontpic
	pop hl
	xor a
	ld [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	xor a
	ld [wBoxAlignment], a
	ret

.not_pokemon
	xor a
	ld [wBoxAlignment], a
	inc a
	ld [wCurPartySpecies], a
	ret

INCLUDE "home/cry.asm"

PrintLevel::
; Print TempMonLevel at hl

	ld a, [TempMonLevel]
	ld [hl], "<LV>"
	inc hl

; How many digits?
	ld c, 2
	cp 100
	jr c, PrintLevelNumber

; 3-digit numbers overwrite the :L.
	dec hl
	inc c
	jr PrintLevelNumber

PrintFullLevel::
; Print :L and all 3 digits
	ld [hl], "<LV>"
	inc hl
	ld c, 3
PrintLevelNumber::
	ld [wd265], a
	ld de, wd265
	ld b, PRINTNUM_RIGHTALIGN | 1
	jp PrintNum

GetBaseData::
	anonbankpush BaseData
	
.Function:
	push hl
	push de
	push bc

; Egg doesn't have BaseData
	ld a, [wCurSpecies]
	cp EGG
	jr z, .egg

; Get BaseData
	dec a
	ld bc, BaseData1 - BaseData0
	ld hl, BaseData
	ld de, CurBaseData
	call CopyNthStruct
	jr .end

.egg
; ????
	ld de, UnknownEggPic

; Sprite dimensions
	ld a, $55
	ld [BasePicSize], a

; ????
	ld hl, BasePadding
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d

.end
; Replace Pokedex # with species
	ld a, [wCurSpecies]
	ld [BaseDexNo], a
	jp PopOffBCDEHLAndReturn

PrintBCDNumber::
	jpba _PrintBCDNumber

GetPartyParamLocation::
; Get the location of parameter a from wCurPartyMon in hl
	push bc
	ld hl, wPartyMons
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartyMon]
	call GetPartyLocation
	pop bc
	ret

INCLUDE "home/battle.asm"

RequestLYOverrides::

	ld a, [wLCDCPointer]
	and a
	ret z

	ld a, LYOverridesBackup % $100
	ld [hRequestedVTileSource], a
	ld a, LYOverridesBackup / $100
	ld [hRequestedVTileSource + 1], a

	ld a, wLYOverrides % $100
	ld [hRequestedVTileDest], a
	ld a, wLYOverrides / $100
	ld [hRequestedVTileDest + 1], a

	ld a, (wLYOverridesEnd - wLYOverrides) / 16
	ld [hLYOverrideStackCopyAmount], a
	ret

CancelMapSign::
	ld a, $80
	ld [wMapSignRoutineIdx], a
	xor a
	ld [wMapSignTimer], a
	ld a, SCREEN_HEIGHT_PX
	ld [rWY], a
	ld [hWY], a
	ret

INCLUDE "home/audio.asm"
INCLUDE "home/ded.asm"

DMGCompatBGMapTransfer::
; transfer 6 rows instead of 9 rows so it'll be normal speed compatible
	ld a, [hBGMapMode]
	push af
	ld a, 5
	ld [hBGMapMode], a
	inc a ; 6
	ld [hTilesPerCycle], a
	xor a
	ld [hBGMapHalf], a
	call DelayFrame
	ld a, 6
	ld [hBGMapHalf], a
	call DelayFrame
	ld a, 12
	ld [hBGMapHalf], a
	call DelayFrame
	pop af
	ld [hBGMapMode], a
	ret

PlaceVWFString:
; place vwf string at de to hl with options b and tilecount c
; uses wDecompressScratch as scratch space
	call RunFunctionInWRA6

.Function:
	bit 7, d
	jr nz, .sourceInRAM
	push hl
	ld hl, wDecompressScratch2
	call CopyName2
	pop hl
	ld de, wDecompressScratch2
.sourceInRAM
	push hl
	push bc
	ld a, h
	cp SRAM_Begin >> 8
	jr nc, .notInVRAM
	ld hl, wDecompressScratch
.notInVRAM
	ld a, c
	and a
	jr z, .skipBufferClear
	push bc
	push hl
	bit 3, b
	push af
	swap c
	ld a, $f
	and c
	ld b, a
	ld a, $f0
	and c
	ld c, a
	pop af
	jr nz, .is2bpp
	srl b
	rr c
.is2bpp
	xor a
	call ByteFill
	pop hl
	pop bc
.skipBufferClear
	callba _PlaceVWFString
	push hl
	ld hl, sp + 5
	ld a, [hld]
	cp SRAM_Begin >> 8
	jr nc, .done
	push bc
	ld d, a
	ld a, [hld]
	ld e, a
	ld a, [hld]
	ld b, a
	ld c, [hl]
	ld h, d
	ld l, e
	bit 3, b
	ld b, BANK(_PlaceVWFString)
	ld de, wDecompressScratch
	jr z, .get1bpp
	call Get2bpp
	jr .doneVCopy
.get1bpp
	call Get1bpp
.doneVCopy
	pop bc
.done
	pop hl
	add sp, $4
	ret
