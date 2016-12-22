Pokegear_LoadGFX:
	call ClearVBank1
	ld hl, TownMapGFX
	ld de, VTiles2
	ld a, BANK(TownMapGFX)
	call FarDecompress
	ld hl, PokegearSpritesGFX
	ld de, VTiles0
	call Decompress
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	call GetPlayerIcon
	call RunFunctionInWRA6

.Function:
; standing sprite
	ld hl, wDecompressScratch
	ld de, VTiles0 tile $10
	ld bc, 4 tiles
	rst CopyBytes
; walking sprite
	ld hl, wDecompressScratch + 12 tiles
	ld de, VTiles0 tile $14
	ld bc, 4 tiles
	rst CopyBytes
	ret

TownMap_GetCurrentLandmark:
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp SPECIAL_MAP
	ret nz
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	jp GetWorldMapLocation

TownMap_InitCursorAndPlayerIconPositions:
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp SPECIAL_MAP
	jr nz, .LoadLandmark
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation
.LoadLandmark
	ld [wPokegearMapPlayerIconLandmark], a
	ld [wPokegearMapCursorLandmark], a
	ret

InitPokegearTilemap:
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, TileMapEnd - TileMap
	ld a, $4f
	call ByteFill
	ld a, [wcf64]
	and $3
	call .Map

	callba TownMapPals
	ld a, [wcf65]
	and a
	jr nz, .kanto_0
	xor a
	ld [hBGMapAddress], a
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	call .UpdateBGMap
	ld a, $90
	jr .finish

.kanto_0
	xor a
	ld [hBGMapAddress], a
	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	call .UpdateBGMap
	xor a
.finish
	ld [hWY], a
	ld a, [wcf65]
	and 1
	xor 1
	ld [wcf65], a
	ret

.UpdateBGMap
	ld a, $2
	ld [hBGMapMode], a
	call Delay2
	jp ApplyTilemapInVBlank

.Map
	call PokegearMap_RegionCheck
	call PokegearMap
	ld a, $7
	ld bc, $12
	hlcoord 1, 2
	call ByteFill
	hlcoord 0, 2
	ld [hl], $6
	hlcoord 19, 2
	ld [hl], $17
	ld a, [wPokegearMapCursorLandmark]
	jp PokegearMap_UpdateLandmarkName

PokegearMap_RegionCheck:
	ld a, [InitalFlypoint]
	ld e, REGION_MYSTERY
	cp $ff
	ret z ; landmark ID of $ff defaults to Mystery Zone
	ld e, 0
	ld hl, .Thresholds
.loop
	cp [hl]
	ret c
	inc e
	inc hl
	jr .loop

.Thresholds:
	db RIJON_LANDMARK
	db JOHTO_LANDMARK
	db KANTO_LANDMARK
	db SEVII_LANDMARK
	db TUNOD_LANDMARK
	db MYSTERY_LANDMARK
	db $ff

PokegearMap_Init:
	call InitPokegearTilemap
	ld a, [wPokegearMapPlayerIconLandmark]
	call PokegearMap_InitPlayerIcon
	ld a, [wPokegearMapCursorLandmark]
	call PokegearMap_InitCursor
	ld a, c
	ld [wPokegearMapCursorObjectPointer], a
	ld a, b
	ld [wPokegearMapCursorObjectPointer + 1], a
	ld hl, wJumptableIndex
	inc [hl]
	ret

PokegearMap_InitPlayerIcon:
	push af
	depixel 0, 0
	ld a, SPRITE_ANIM_INDEX_RED_WALK
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $10
	pop af
	ld e, a
	push bc
	callba GetLandmarkCoords
	pop bc
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], e
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d
	ret

PokegearMap_InitCursor:
	push af
	depixel 0, 0
	ld a, SPRITE_ANIM_INDEX_0D
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $4
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL
	pop af
	push bc
	call PokegearMap_UpdateCursorPosition
	pop bc
	ret

PokegearMap_UpdateLandmarkName:
	push af
	hlcoord 0, 0
	lb bc, 1, 20
	call ClearBox
	pop af
	ld e, a
	push de
	callba GetLandmarkName
	pop de
	ld hl, wStringBuffer1
	jr .handleLoop

.loop
	inc hl
.handleLoop
	ld a, [hl]
	cp "@"
	jr z, .end
	cp "%"
	jr z, .line_break
	cp "¯"
	jr nz, .loop
.line_break
	ld [hl], "<LNBRK>"

.end
	ld de, wStringBuffer1
	hlcoord 1, 0
	jp PlaceString

PokegearMap_UpdateCursorPosition:
	push bc
	ld e, a
	callba GetLandmarkCoords
	pop bc
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], e
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d
	ret

PokegearSpritesGFX: INCBIN "gfx/misc/pokegear_sprites.2bpp.lz"

.InJohto
; if in Johto or on the S.S. Aqua, set carry

; otherwise clear carry
	ld a, [wPokegearMapPlayerIconLandmark]
	cp KANTO_LANDMARK
	jr c, .johto
.kanto
	and a
	ret

.johto
	scf
	ret

GetPokegearMapLimits:
	call PokegearMap_RegionCheck
	ld a, e
	and a
	jr z, .farawayCheck
.setlimits
	ld d, 0
	ld hl, .limits
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
	
.farawayCheck
	push de
	push bc
	ld hl, EventFlags
	ld de, EVENT_FARAWAY_UNLOCKED
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop bc
	pop de
	jr z, .setlimits
	ld e, 7 ;New Limits for Naljo
	jr .setlimits

.limits
	db HEATH_VILLAGE, ROUTE_87 ; Naljo
	db SEASHORE_CITY, SENECA_CAVERNS ; Rijon
	db ROUTE_47, GOLDENROD_CAPE ; Johto
	db SAFFRON_CITY, SAFFRON_CITY ; Kanto
	db EMBER_BROOK, KINDLE_ROAD ; Sevii
	db TUNOD_WATERWAY, SOUTHERLY_CITY ; Tunod
	db MYSTERY_ZONE, MYSTERY_ZONE ; Mystery Zone
	db HEATH_VILLAGE, FARAWAY_ISLAND ; Naljo Faraway Unlocked

_TownMap:
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]

	ld a, [hInMenu]
	push af
	ld a, $1
	ld [hInMenu], a

	ld a, [VramState]
	push af
	xor a
	ld [VramState], a

	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call Pokegear_LoadGFX
	callba ClearSpriteAnims
	ld a, 8
	call SkipMusic
	call EnableLCD
	ld a, $e3
	ld [rLCDC], a
	call TownMap_GetCurrentLandmark
	ld [InitalFlypoint], a
	ld [wd003], a
	xor a
	ld [hBGMapMode], a
	call .InitTilemap
	call ApplyAttrAndTilemapInVBlank
	ld a, [InitalFlypoint]
	call PokegearMap_InitPlayerIcon
	ld a, [wd003]
	call PokegearMap_InitCursor
	ld a, c
	ld [wd004], a
	ld a, b
	ld [wd005], a
	lb bc, SCGB_POKEGEAR_PALS, 0
	predef GetSGBLayout
	call SetPalettes
	ld a, %11100100
	call DmgToCgbObjPal0
	call DelayFrame
	call GetPokegearMapLimits
	call .loop
	pop af
	ld [VramState], a
	pop af
	ld [hInMenu], a
	pop af
	ld [wOptions], a
	jp ClearBGPalettes

.loop
	call JoyTextDelay
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	ret nz

	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .pressed_up

	ld a, [hl]
	and D_DOWN
	jr nz, .pressed_down
.loop2
	push de
	callba PlaySpriteAnimations
	pop de
	call DelayFrame
	jr .loop

.pressed_up
	ld hl, wd003
	ld a, [hl]
	cp d
	jr c, .okay
	ld a, e
	dec a
	ld [hl], a

.okay
	inc [hl]
	jr .next

.pressed_down
	ld hl, wd003
	ld a, [hl]
	cp e
	jr nz, .okay2
	ld a, d
	inc a
	ld [hl], a

.okay2
	dec [hl]

.next
	push de
	ld a, [wd003]
	call PokegearMap_UpdateLandmarkName
	ld a, [wd004]
	ld c, a
	ld a, [wd005]
	ld b, a
	ld a, [wd003]
	call PokegearMap_UpdateCursorPosition
	pop de
	jr .loop2

.InitTilemap
	call PokegearMap_RegionCheck
	call PokegearMap
	ld a, [wd003]
	call PokegearMap_UpdateLandmarkName
	jpba TownMapPals

PokegearMap:
	push de
	call LoadTownMapGFX
	pop de

; fallthrough
LoadMapTilemap:
	ld d, 0
	ld hl, PokegearTilemapPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	coord de, 0, 1 ; strats
	jp Decompress

PokegearTilemapPointers:
	dw NaljoMap
	dw RijonMap
	dw JohtoMap
	dw KantoMap
	dw SeviiMap
	dw TunodMap
	dw TunodMap

LoadTownMapGFX:
	ld hl, TownMapGFX
	ld de, VTiles2
	lb bc, BANK(TownMapGFX), $30
	jp DecompressRequest2bpp

_FlyMap:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], $1
	xor a
	ld [hBGMapMode], a
	callba ClearSpriteAnims
	call LoadTownMapGFX
	ld de, FlyMapLabelBorderGFX
	ld hl, VTiles2 tile $30
	lb bc, BANK(FlyMapLabelBorderGFX), 6
	call Request1bpp
	call FlyMap
	ld b, SCGB_POKEGEAR_PALS
	ld c, 1
	predef GetSGBLayout
	call SetPalettes
.loop
	call JoyTextDelay
	ld a, [hJoyPressed]
	bit B_BUTTON_F, a
	jr nz, .pressedB
	bit A_BUTTON_F, a
	jr nz, .pressedA
	call FlyMapScroll
	call GetMapCursorCoordinates
	callba PlaySpriteAnimations
	call DelayFrame
	jr .loop

.pressedB
	ld a, -1
	jr .exit

.pressedA
	ld a, [InitalFlypoint]
	inc a
.exit
	ld [InitalFlypoint], a
	pop af
	ld [hInMenu], a
	call ClearBGPalettes
	ld a, $90
	ld [hWY], a
	xor a
	ld [hBGMapAddress], a
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	ld a, [InitalFlypoint]
	ld e, a
	ret

InitFlyMapCursor:
	ld a, [StartFlypoint]
	ld e, a
	ld a, [EndFlypoint]
	ld d, a
	jr FlyMapScroll_ScrollNext

FlyMapScroll:
	ld a, [StartFlypoint]
	ld e, a
	ld a, [EndFlypoint]
	ld d, a
	ld a, [hJoyLast]
	bit D_DOWN_F, a
	jr nz, FlyMapScroll_ScrollPrev
	bit D_UP_F, a
	ret z

FlyMapScroll_ScrollNext:
	ld hl, InitalFlypoint
	ld a, [hl]
	cp d
	jr nz, .NotAtEndYet
	ld [hl], e
	jr .wrapAroundNext
.NotAtEndYet
	inc [hl]
.wrapAroundNext
	call CheckIfVisitedFlypoint
	jr z, FlyMapScroll_ScrollNext
	jr FlyMapScroll_Done

FlyMapScroll_ScrollPrev:
	ld hl, InitalFlypoint
	ld a, [hl]
	cp e
	jr nz, .NotAtStartYet
	ld [hl], d
	jr .wrapAroundPrev
.NotAtStartYet
	dec [hl]
.wrapAroundPrev
	call CheckIfVisitedFlypoint
	jr z, FlyMapScroll_ScrollPrev
FlyMapScroll_Done:
	call TownMapBubble
	call ApplyTilemapInVBlank
	xor a
	ld [hBGMapMode], a
	ret

TownMapBubble:
; Print the name of the default flypoint
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, " "
	call ByteFill

	call .Name
; Up/down arrows
	hlcoord 19, 0
	ld [hl], $34
	ret

.Name
; We need the map location of the default flypoint
	ld a, [InitalFlypoint]
	ld hl, Flypoints
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld e, [hl]
	callba GetLandmarkName
	hlcoord 1, 0
	ld de, wStringBuffer1
	jp PlaceString

GetMapCursorCoordinates:
	ld a, [InitalFlypoint]
	ld hl, Flypoints
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld e, [hl]
	callba GetLandmarkCoords
	ld a, [wd003]
	ld c, a
	ld a, [wd004]
	ld b, a
	ld hl, $4
	add hl, bc
	ld [hl], e
	ld hl, $5
	add hl, bc
	ld [hl], d
	ret

CheckIfVisitedFlypoint:
; Check if the flypoint loaded in [hl] has been visited yet.
	push bc
	push de
	push hl
	ld c, [hl]
	inc c
	ld hl, VisitedSpawns
	ld b, CHECK_FLAG
	predef FlagAction
	pop hl
	pop de
	pop bc
	ret

Flypoints:
; landmark, spawn point
	const_def
flypoint: MACRO
	const FLY_\1
	db \1
ENDM
; Naljo
	flypoint CAPER_CITY
	flypoint OXALIS_CITY
	flypoint SPURGE_CITY
	flypoint HEATH_VILLAGE
	flypoint LAUREL_CITY
	flypoint TORENIA_CITY
	flypoint PHACELIA_TOWN
	flypoint ACANIA_DOCKS
	flypoint SAXIFRAGE_ISLAND
	flypoint PHLOX_TOWN
	flypoint CHAMPION_ISLE

RIJON_FLYPOINT EQU const_value
	flypoint SEASHORE_CITY
	flypoint GRAVEL_TOWN
	flypoint MERSON_CITY
	flypoint HAYWARD_CITY
	flypoint OWSAURI_CITY
	flypoint MORAGA_TOWN
	flypoint JAERU_CITY
	flypoint BOTAN_CITY
	flypoint CASTRO_VALLEY
	flypoint EAGULOU_CITY
	flypoint RIJON_LEAGUE
	flypoint SENECA_CAVERNS

JOHTO_FLYPOINT EQU const_value
	flypoint AZALEA_TOWN
	flypoint GOLDENROD_CITY
KANTO_FLYPOINT EQU const_value ;None
	flypoint SAFFRON_CITY
SEVII_FLYPOINT EQU const_value
TUNOD_FLYPOINT EQU const_value
	flypoint SOUTHERLY_CITY

	db -1

FlyMap:
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
; If we're not in a valid location, i.e. Pokecenter floor 2F,

; the backup map information is used
	cp SPECIAL_MAP
	jr nz, .CheckRegion
	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation
.CheckRegion
	cp TUNOD_LANDMARK
	jr nc, .TunodFlyMap
	cp JOHTO_LANDMARK
	jr nc, .JohtoFlyMap
	cp RIJON_LANDMARK
	jr nc, .RijonFlyMap

	push af
	ld a, FLY_CAPER_CITY - 1
	ld [InitalFlypoint], a
	inc a
	ld [StartFlypoint], a
	ld a, FLY_CHAMPION_ISLE
	ld [EndFlypoint], a
	ld e, 0 ; naljo
	jr .MapHud

.RijonFlyMap
	push af
	ld a, FLY_SEASHORE_CITY - 1
	ld [InitalFlypoint], a
	inc a 
	ld [StartFlypoint], a
	ld a, FLY_SENECA_CAVERNS
	ld [EndFlypoint], a
	ld e, 1 ; rijon
	jr .MapHud

;ADD A CHECK IF NEITHER ARE AVAILABLE!
.JohtoFlyMap
	push af
	ld a, FLY_AZALEA_TOWN
	ld [StartFlypoint], a
	ld [InitalFlypoint], a
	ld a, FLY_GOLDENROD_CITY
	ld [EndFlypoint], a
	ld e, 2
	jr .MapHud

.TunodFlyMap
	push af
	ld a, FLY_SOUTHERLY_CITY
	ld [StartFlypoint], a
	ld [InitalFlypoint], a
	ld a, FLY_SOUTHERLY_CITY
	ld [EndFlypoint], a
	ld e, 5

.MapHud
	call LoadMapTilemap
	call InitFlyMapCursor
	call TownMapBubble
	call TownMapPals
	hlbgcoord 0, 0 ; BG Map 0
	call TownMapBGUpdate
	call TownMapMon
	ld a, c
	ld [wd003], a
	ld a, b
	ld [wd004], a
	pop af
	jp TownMapPlayerIcon

ShowMonNestLocations:
; e: Current landmark
	ld a, [InitalFlypoint]
	push af
	ld a, [wd003]
	push af
	ld a, e
	ld [InitalFlypoint], a
	call ClearSprites
	xor a
	ld [hBGMapMode], a
	ld a, $1
	ld [hInMenu], a
	ld de, PokedexNestIconGFX
	ld hl, VTiles0 tile $7f
	lb bc, BANK(PokedexNestIconGFX), 1
	call Request2bpp
	call GetPlayerIcon
	ld de, wDecompressScratch
	ld hl, VTiles0 tile $78
	ld c, 4
	call Request2bppInWRA6
	call LoadTownMapGFX
	call PokegearMap_RegionCheck
	ld a, e
	ld [wd003], a
	call PokegearMap
	call .GFX_Update
	lb bc, SCGB_POKEGEAR_PALS, 0
	predef GetSGBLayout
	call SetPalettes
	xor a
	ld [hBGMapMode], a
	call .GetAndPlaceNest
.loop
	call JoyTextDelay
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON | B_BUTTON
	jr nz, .a_b
	ld a, [hJoypadDown]
	and SELECT
	jr nz, .select
	call .LeftRightInput
	call .BlinkNestIcons
	jr .next

.select
	call .HideNestsShowPlayer
.next
	call DelayFrame
	jr .loop

.a_b
	call ClearSprites
	pop af
	ld [wd003], a
	pop af
	ld [InitalFlypoint], a
	ret

.GFX_Update
	call .PlaceString_MonsNest
	call TownMapPals
	hlbgcoord 0, 0
	jp TownMapBGUpdate

.LeftRightInput
	ld a, [wStatusFlags]
	bit 6, a ; hall of fame
	ret z
	bit D_LEFT_F, [hl]
	jr nz, .left
	bit D_RIGHT_F, [hl]
	ret z
.right
	call ClearSprites
	ld a, [wd003]
	inc a
	cp REGION_MYSTERY
	jr c, .UpdateGFX
	xor a
	jr .UpdateGFX

.left
	call ClearSprites
	ld a, [wd003]
	and a
	jr nz, .okay
	ld a, REGION_MYSTERY
.okay
	dec a
.UpdateGFX
	ld [wd003], a
	ld e, a
	call LoadMapTilemap
	call .GFX_Update
.GetAndPlaceNest
	ld a, [wd003]
	ld e, a
	callba FindNest ; load nest landmarks into TileMap[0,0]
	decoord 0, 0
	ld hl, Sprites
.nestloop
	ld a, [de]
	and a
	jr z, .done_nest
	push de
	ld e, a
	push hl
	callba GetLandmarkCoords
	pop hl
	; load into OAM
	ld a, d
	sub 4
	ld [hli], a
	ld a, e
	sub 4
	ld [hli], a
	ld a, $7f ; nest icon in this context
	ld [hli], a
	xor a
	ld [hli], a
	; next
	pop de
	inc de
	jr .nestloop

.done_nest
	ld hl, Sprites
	decoord 0, 0
	ld bc, SpritesEnd - Sprites
	rst CopyBytes
	ret

.BlinkNestIcons
	ld a, [hVBlankCounter]
	ld e, a
	and $f
	ret nz
	ld a, e
	and $10
	jr nz, .copy_sprites
	jp ClearSprites

.copy_sprites
	hlcoord 0, 0
	ld de, Sprites
	ld bc, SpritesEnd - Sprites
	rst CopyBytes
	ret

.PlaceString_MonsNest
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call GetPokemonName
	hlcoord 2, 0
	call PlaceString
	ld h, b
	ld l, c
	ld de, .String_SNest
	jp PlaceString

.String_SNest
	db "'s nest@"

.HideNestsShowPlayer
	call .CheckPlayerLocation
	ret c
	ld a, [InitalFlypoint]
	ld e, a
	callba GetLandmarkCoords
	ld c, e
	ld b, d
	ld de, .PlayerOAM
	ld hl, Sprites
.ShowPlayerLoop
	ld a, [de]
	cp $80
	jr z, .clear_oam
	add b
	ld [hli], a
	inc de
	ld a, [de]
	add c
	ld [hli], a
	inc de
	ld a, [de]
	add $78 ; where the player's sprite is loaded
	ld [hli], a
	inc de
	xor a
	ld [hli], a
	jr .ShowPlayerLoop

.clear_oam
	ld hl, Sprites + 4 * 4
	ld bc, SpritesEnd - (Sprites + 4 * 4)
	xor a
	jp ByteFill

.PlayerOAM
	db -1 * 8, -1 * 8,  0 ; top left
	db -1 * 8,  0 * 8,  1 ; top right
	db  0 * 8, -1 * 8,  2 ; bottom left
	db  0 * 8,  0 * 8,  3 ; bottom right
	db $80 ; terminator

.CheckPlayerLocation
; Don't show the player's sprite if you're
; not in the same region as what's currently
; on the screen.
	ld a, [InitalFlypoint]
	cp KANTO_LANDMARK
	jr c, .johto
.kanto
	ld a, [wd003]
	and a
	jr z, .clear
	jr .ok

.johto
	ld a, [wd003]
	and a
	jr nz, .clear
.ok
	and a
	ret

.clear
	ld hl, Sprites
	ld bc, SpritesEnd - Sprites
	xor a
	call ByteFill
	scf
	ret

TownMapBGUpdate:
; Update BG Map tiles and attributes

; BG Map address
	ld a, l
	ld [hBGMapAddress], a
	ld a, h
	ld [hBGMapAddress + 1], a
; BG Map mode 2 (palettes)
	ld a, 2
	ld [hBGMapMode], a
; The BG Map is updated in seconds, so we wait
; 2 frames to update the whole screen's palettes.
	call Delay2
; Update BG Map tiles
	call ApplyTilemapInVBlank
; Turn off BG Map update
	xor a
	ld [hBGMapMode], a
	ret
; 91eff

TownMapPals:
; Assign palettes based on tile ids
	hlcoord 0, 0
	decoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
.loop
; Current tile
	ld a, [hli]
	push hl
; HP/borders use palette 0
	cp $60
	jr nc, .pal0
; The palette data is condensed to nybbles,

; least-significant first.
	ld hl, TownMapPalMap
	srl a
	jr c, .odd
; Even-numbered tile ids take the bottom nybble...
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld a, [hl]
	and %111
	jr .update

.odd
; ...and odd ids take the top.
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld a, [hl]
	swap a
	and %111
	jr .update

.pal0
	xor a
.update
	pop hl
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

TownMapPalMap:
	dn 4, 1, 2, 1, 2, 4, 4, 4, 6, 6, 4, 3, 7, 3, 5, 6
	dn 1, 4, 4, 4, 4, 7, 4, 4, 6, 6, 7, 7, 7, 7, 4, 4
	dn 4, 1, 2, 1, 2, 4, 4, 4, 4, 7, 6, 4, 6, 6, 6, 6
	dn 0, 0, 0, 0, 4, 4, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0
	dn 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3
	dn 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0

TownMapMon:
; Draw the FlyMon icon at town map location in
; Get FlyMon species
	ld a, [wCurPartyMon]
	ld hl, wPartySpecies
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	ld [wd265], a
; Get FlyMon icon
	ld e, 8 ; starting tile in VRAM
	callba GetSpeciesIcon
; Animation/palette
	depixel 0, 0
	ld a, SPRITE_ANIM_INDEX_00
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $8
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL
	ret

TownMapPlayerIcon:
; Draw the player icon at town map location in a
	push af
	call GetPlayerIcon
; Standing icon
	ld de, wDecompressScratch
	ld hl, VTiles0 tile $10
	ld c, 4 ; # tiles
	call Request2bppInWRA6
; Walking icon
	ld de, wDecompressScratch + 12 tiles
	ld hl, VTiles0 tile $14
	ld c, 4
	call Request2bppInWRA6
; Animation/palette
	depixel 0, 0
	ld a, SPRITE_ANIM_INDEX_BLUE_WALK
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], $10
	pop af
	ld e, a
	push bc
	callba GetLandmarkCoords
	pop bc
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld [hl], e
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld [hl], d
	ret

NaljoMap: INCBIN "gfx/misc/naljo.bin.lz"
RijonMap: INCBIN "gfx/misc/rijon.bin.lz"
JohtoMap: INCBIN "gfx/misc/johto.bin.lz"
KantoMap: INCBIN "gfx/misc/kanto.bin.lz"
SeviiMap: INCBIN "gfx/misc/seviiislands.bin.lz"
TunodMap: INCBIN "gfx/misc/tunod.bin.lz"

PokedexNestIconGFX: INCBIN "gfx/pokegear/dexmap_nest_icon.2bpp"
FlyMapLabelBorderGFX: INCBIN "gfx/pokegear/flymap_label_border.2bpp"
