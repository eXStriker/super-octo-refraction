	const_def
	const DEXSTATE_MAIN_SCR
	const DEXSTATE_UPDATE_MAIN_SCR
	const DEXSTATE_DEX_ENTRY_SCR
	const DEXSTATE_UPDATE_DEX_ENTRY_SCR
	const DEXSTATE_REINIT_DEX_ENTRY_SCR
	const DEXSTATE_SEARCH_SCR
	const DEXSTATE_UPDATE_SEARCH_SCR
	const DEXSTATE_SEARCH_RESULTS_SCR
	const DEXSTATE_UPDATE_SEARCH_RESULTS_SCR
	const DEXSTATE_EXIT

Pokedex:
	ld a, [hWX]
	ld l, a
	ld a, [hWY]
	ld h, a
	push hl
	ld a, [hSCX]
	push af
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	ld a, [hInMenu]
	push af
	ld a, $1
	ld [hInMenu], a

	xor a
	ld [hMapAnims], a
	call InitPokedex
	jr .handleLoop

.loop
	jumptable PokedexJumptable
.handleLoop
	call DelayFrame
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .loop
	ld de, SFX_READ_TEXT_2
	call PlayWaitSFX
	call ClearSprites

	pop af
	ld [hInMenu], a
	pop af
	ld [VramState], a
	pop af
	ld [wOptions], a
	pop af
	ld [hSCX], a
	pop hl
	ld a, l
	ld [hWX], a
	ld a, h
	ld [hWY], a
	ret

PokedexJumptable:
	dw Pokedex_InitMainScreen
	dw Pokedex_UpdateMainScreen
	dw Pokedex_InitDexEntryScreen
	dw Pokedex_UpdateDexEntryScreen
	dw Pokedex_ReinitDexEntryScreen
	dw Pokedex_InitSearchScreen
	dw Pokedex_UpdateSearchScreen
	dw Pokedex_InitSearchResultsScreen
	dw Pokedex_UpdateSearchResultsScreen
	dw Pokedex_Exit

InitPokedex:
	call ClearBGPalettes
	call ClearSprites
	call ClearTileMap
	call Pokedex_LoadGFX

	xor a
	ld [wJumptableIndex], a
	ld [wDexEntryPrevJumptableIndex], a
	ld [wcf65], a
	ld [wcf66], a
	ld hl, wPokedexDataStart
	ld bc, wPokedexDataEnd - wPokedexDataStart
	call ByteFill

	call Pokedex_OrderMonsByMode
	call Pokedex_InitCursorPosition
	call Pokedex_GetLandmark
	call DrawDexEntryScreenRightEdge
	jp Pokedex_ResetBGMapMode

Pokedex_InitCursorPosition:
	ld hl, wPokedexDataStart
	ld a, [wLastDexEntry]
	and a
	jr z, .done
	cp NUM_POKEMON + 1
	jr nc, .done

	ld b, a
	ld a, [wDexListingEnd]
	cp $8
	jr c, .only_one_page

	sub $7
	ld c, a
.loop1
	ld a, b
	cp [hl]
	jr z, .done
	inc hl
	ld a, [wDexListingScrollOffset]
	inc a
	ld [wDexListingScrollOffset], a
	dec c
	jr nz, .loop1

.only_one_page
	ld c, $7
.loop2
	ld a, b
	cp [hl]
	jr z, .done
	inc hl
	ld a, [wDexListingCursor]
	inc a
	ld [wDexListingCursor], a
	dec c
	jr nz, .loop2

.done
	ret

Pokedex_GetLandmark:
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation

	cp SPECIAL_MAP
	jr nz, .load

	ld a, [BackupMapGroup]
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
	call GetWorldMapLocation

.load
	ld [wDexCurrentLocation], a
	ret

Pokedex_IncrementDexPointer:
	ld hl, wJumptableIndex
	inc [hl]
	ret

Pokedex_Exit:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

Pokedex_InitMainScreen:
	xor a
	ld [hBGMapMode], a
	call ClearSprites
	xor a
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	call DrawPokedexListWindow
	hlcoord 0, 17
	ld de, String_START_SEARCH
	call Pokedex_PlaceString
	ld a, 7
	ld [wDexListingHeight], a
	call Pokedex_PrintListing
	call Pokedex_SetBGMapMode_3ifDMG_4ifCGB
	call Pokedex_ResetBGMapMode
	call Pokedex_DrawMainScreenBG
	ld a, $5
	ld [hSCX], a
	ld a, $4a
	ld [hWX], a
	xor a
	ld [hWY], a
	call ApplyTilemapInVBlank

	call Pokedex_ResetBGMapMode
	ld a, -1
	ld [wCurPartySpecies], a
	ld a, SCGB_POKEDEX
	call Pokedex_GetSGBLayout
	call Pokedex_UpdateCursorOAM
	call DrawPokedexListWindow
	hlcoord 0, 17
	ld de, String_START_SEARCH
	call Pokedex_PlaceString
	ld a, 7
	ld [wDexListingHeight], a
	call Pokedex_PrintListing
	jp Pokedex_IncrementDexPointer

Pokedex_UpdateMainScreen:
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .b
	ld a, [hl]
	and A_BUTTON
	jr nz, .a
	ld a, [hl]
	and START
	jr nz, .start
	call Pokedex_ListingHandleDPadInput
	ret nc
	call Pokedex_UpdateCursorOAM
	xor a
	ld [hBGMapMode], a
	call Pokedex_PrintListing
	call Pokedex_SetBGMapMode3
	jp Pokedex_ResetBGMapMode

.a
	call Pokedex_GetSelectedMon
	call Pokedex_CheckSeen
	ret z
	ld a, DEXSTATE_DEX_ENTRY_SCR
	ld [wJumptableIndex], a
	ld a, DEXSTATE_MAIN_SCR
	ld [wDexEntryPrevJumptableIndex], a
	ret

.start
	call Pokedex_BlackOutBG
	ld a, DEXSTATE_SEARCH_SCR
	ld [wJumptableIndex], a
	xor a
	ld [hSCX], a
	ld a, $a7
	ld [hWX], a
	jp DelayFrame

.b
	ld a, DEXSTATE_EXIT
	ld [wJumptableIndex], a
	ret

Pokedex_InitDexEntryScreen:
	call LowVolume
	xor a
	ld [wPokedexStatus], a
	xor a
	ld [hBGMapMode], a
	call ClearSprites
	call Pokedex_LoadCurrentFootprint
	call Pokedex_DrawDexEntryScreenBG
	call Pokedex_InitArrowCursor
	call Pokedex_GetSelectedMon
	ld [wLastDexEntry], a
	callba DisplayDexEntry
	call Pokedex_DrawFootprint
	call ApplyTilemapInVBlank
	ld a, $a7
	ld [hWX], a
	call Pokedex_GetSelectedMon
	ld [wCurPartySpecies], a
	ld a, SCGB_POKEDEX
	call Pokedex_GetSGBLayout
	xor a
	ld [hBGMapMode], a
	call ApplyTilemapInVBlank
	ld a, [wCurPartySpecies]
	call PlayCry
	jp Pokedex_IncrementDexPointer

Pokedex_UpdateDexEntryScreen:
	ld de, DexEntryScreen_ArrowCursorData
	call Pokedex_MoveArrowCursor
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .return_to_prev_screen
	ld a, [hl]
	and A_BUTTON
	jr nz, .do_menu_action
	call Pokedex_NextOrPreviousDexEntry
	ret nc
	jp Pokedex_IncrementDexPointer

.do_menu_action
	ld a, [wDexArrowCursorPosIndex]
	jumptable DexEntryScreen_MenuActionJumptable
	ret

.return_to_prev_screen
	ld a, [LastVolume]
	and a
	jr z, .max_volume
	ld a, $77
	ld [LastVolume], a

.max_volume
	call MaxVolume
	ld a, [wDexEntryPrevJumptableIndex]
	ld [wJumptableIndex], a
	ret

Pokedex_Page:
	ld a, [wPokedexStatus]
	xor $1
	ld [wPokedexStatus], a
	call Pokedex_GetSelectedMon
	ld [wLastDexEntry], a
	callba DisplayDexEntry
	jp ApplyTilemapInVBlank

Pokedex_ReinitDexEntryScreen:
; Reinitialize the Pokédex entry screen after changing the selected mon.
	call Pokedex_BlackOutBG
	xor a
	ld [wPokedexStatus], a
	xor a
	ld [hBGMapMode], a
	call Pokedex_DrawDexEntryScreenBG
	call Pokedex_InitArrowCursor
	call Pokedex_LoadCurrentFootprint
	call Pokedex_GetSelectedMon
	ld [wLastDexEntry], a
	callba DisplayDexEntry
	call Pokedex_DrawFootprint
	call Pokedex_LoadSelectedMonTiles
	call ApplyTilemapInVBlank
	call Pokedex_GetSelectedMon
	ld [wCurPartySpecies], a
	ld a, SCGB_POKEDEX
	call Pokedex_GetSGBLayout
	xor a
	ld [hBGMapMode], a
	call ApplyTilemapInVBlank
	ld a, [wCurPartySpecies]
	call PlayCry
	ld hl, wJumptableIndex
	dec [hl]
	ret

DexEntryScreen_ArrowCursorData:
	db D_RIGHT | D_LEFT, 4
	dwcoord 1, 17
	dwcoord 6, 17
	dwcoord 11, 17
	dwcoord 15, 17

DexEntryScreen_MenuActionJumptable:
	dw Pokedex_Page
	dw .Area
	dw .Cry
	dw .Print

.Area
	ld a, [MapGroup]
	cp GROUP_MYSTERY_ZONE
	jr z, .inMysteryZone

	call Pokedex_BlackOutBG
	xor a
	ld [hSCX], a
	call DelayFrame
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	call Pokedex_GetSelectedMon
	ld a, [wDexCurrentLocation]
	ld e, a
	callba ShowMonNestLocations
	call Pokedex_BlackOutBG
	call DelayFrame
	xor a
	ld [hBGMapMode], a
	ld a, $90
	ld [hWY], a
	ld a, $5
	ld [hSCX], a
	call DelayFrame
	call Pokedex_RedisplayDexEntry
	call Pokedex_LoadSelectedMonTiles
	call ApplyTilemapInVBlank
	call Pokedex_GetSelectedMon
	ld [wCurPartySpecies], a
	ld a, SCGB_POKEDEX
	jp Pokedex_GetSGBLayout

.inMysteryZone
	ld de, SFX_WRONG
	call PlayWaitSFX
	ret

.Cry
	call Pokedex_GetSelectedMon
	ld a, [wd265]
	jp _PlayCry

.Print
	call Pokedex_ApplyPrintPals
	xor a
	ld [hSCX], a
	ld a, [wcf65]
	push af
	ld a, [wDexEntryPrevJumptableIndex]
	push af
	ld a, [wJumptableIndex]
	push af
	callba PrintDexEntry
	pop af
	ld [wJumptableIndex], a
	pop af
	ld [wDexEntryPrevJumptableIndex], a
	pop af
	ld [wcf65], a
	call ClearBGPalettes
	call DisableLCD
	call Pokedex_LoadInvertedFont
	call Pokedex_RedisplayDexEntry
	call EnableLCD
	call ApplyTilemapInVBlank
	ld a, $5
	ld [hSCX], a
	jp Pokedex_ApplyUsualPals

Pokedex_RedisplayDexEntry:
	call Pokedex_DrawDexEntryScreenBG
	call Pokedex_GetSelectedMon
	callba DisplayDexEntry
	jp Pokedex_DrawFootprint

Pokedex_InitSearchScreen:
	xor a
	ld [hBGMapMode], a
	call ClearSprites
	call Pokedex_DrawSearchScreenBG
	call Pokedex_InitArrowCursor
	ld a, NORMAL + 1
	ld [wDexSearchMonType1], a
	xor a
	ld [wDexSearchMonType2], a
	call Pokedex_PlaceSearchScreenTypeStrings
	xor a
	ld [wDexSearchSlowpokeFrame], a
	callba DoDexSearchSlowpokeFrame
	call ApplyTilemapInVBlank
	ld a, SCGB_POKEDEX_SEARCH_OPTION
	call Pokedex_GetSGBLayout
	jp Pokedex_IncrementDexPointer

Pokedex_UpdateSearchScreen:
	ld de, .ArrowCursorData
	call Pokedex_MoveArrowCursor
	call Pokedex_UpdateSearchMonType
	call c, Pokedex_PlaceSearchScreenTypeStrings
	ld hl, hJoyPressed
	ld a, [hl]
	and START | B_BUTTON
	jr nz, .cancel
	ld a, [hl]
	and A_BUTTON
	ret z
	ld a, [wDexArrowCursorPosIndex]
	jumptable

.MenuActionJumptable
	dw .MenuAction_MonSearchType
	dw .MenuAction_MonSearchType
	dw .MenuAction_BeginSearch
	dw .MenuAction_Cancel

.cancel
	call Pokedex_BlackOutBG
	ld a, DEXSTATE_MAIN_SCR
	ld [wJumptableIndex], a
	ret

.ArrowCursorData
	db D_UP | D_DOWN, 4
	dwcoord 2, 4
	dwcoord 2, 6
	dwcoord 2, 13
	dwcoord 2, 15

.MenuAction_MonSearchType
	call Pokedex_NextSearchMonType
	jp Pokedex_PlaceSearchScreenTypeStrings

.MenuAction_BeginSearch
	call Pokedex_SearchForMons
	callba AnimateDexSearchSlowpoke
	ld a, [wDexSearchResultCount]
	and a
	jr nz, .show_search_results

; No mon with matching types was found.
	call Pokedex_OrderMonsByMode
	call Pokedex_DisplayTypeNotFoundMessage
	xor a
	ld [hBGMapMode], a
	call Pokedex_DrawSearchScreenBG
	call Pokedex_InitArrowCursor
	call Pokedex_PlaceSearchScreenTypeStrings
	jp ApplyTilemapInVBlank

.show_search_results
	ld [wDexListingEnd], a
	ld a, [wDexListingScrollOffset]
	ld [wSearchBackupDexListingScrollOffset], a
	ld a, [wDexListingCursor]
	ld [wSearchBackupDexListingCursor], a
	ld a, [wLastDexEntry]
	ld [wcf65], a
	xor a
	ld [wDexListingScrollOffset], a
	ld [wDexListingCursor], a
	call Pokedex_BlackOutBG
	ld a, DEXSTATE_SEARCH_RESULTS_SCR
	ld [wJumptableIndex], a
	ret

.MenuAction_Cancel
	call Pokedex_BlackOutBG
	ld a, DEXSTATE_MAIN_SCR
	ld [wJumptableIndex], a
	ret

Pokedex_InitSearchResultsScreen:
	xor a
	ld [hBGMapMode], a
	xor a
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call Pokedex_SetBGMapMode4
	call Pokedex_ResetBGMapMode
	call DrawPokedexSearchResultsWindow
	call Pokedex_PlaceSearchResultsTypeStrings

	ld a, [wDexSearchMonType2]
	push af
	ld a, 4
	ld [wDexListingHeight], a
	call Pokedex_PrintListing
	pop af
	ld [wDexSearchMonType2], a

	call Pokedex_SetBGMapMode3
	call Pokedex_ResetBGMapMode
	call Pokedex_DrawSearchResultsScreenBG
	ld a, $5
	ld [hSCX], a
	ld a, $4a
	ld [hWX], a
	xor a
	ld [hWY], a
	call ApplyTilemapInVBlank
	call Pokedex_ResetBGMapMode
	call DrawPokedexSearchResultsWindow
	call Pokedex_PlaceSearchResultsTypeStrings
	call Pokedex_UpdateSearchResultsCursorOAM
	ld a, $ff
	ld [wCurPartySpecies], a
	ld a, SCGB_POKEDEX
	call Pokedex_GetSGBLayout
	jp Pokedex_IncrementDexPointer

Pokedex_UpdateSearchResultsScreen:
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .return_to_search_screen
	ld a, [hl]
	and A_BUTTON
	jr nz, .go_to_dex_entry
	call Pokedex_ListingHandleDPadInput
	ret nc
	call Pokedex_UpdateSearchResultsCursorOAM
	xor a
	ld [hBGMapMode], a
	call Pokedex_PrintListing
	call Pokedex_SetBGMapMode3
	jp Pokedex_ResetBGMapMode

.go_to_dex_entry
	call Pokedex_GetSelectedMon
	call Pokedex_CheckSeen
	ret z
	ld a, DEXSTATE_DEX_ENTRY_SCR
	ld [wJumptableIndex], a
	ld a, DEXSTATE_SEARCH_RESULTS_SCR
	ld [wDexEntryPrevJumptableIndex], a
	ret

.return_to_search_screen
	ld a, [wSearchBackupDexListingScrollOffset]
	ld [wDexListingScrollOffset], a
	ld a, [wSearchBackupDexListingCursor]
	ld [wDexListingCursor], a
	ld a, [wcf65]
	ld [wLastDexEntry], a
	call Pokedex_BlackOutBG
	call ClearSprites
	call Pokedex_OrderMonsByMode
	ld a, DEXSTATE_SEARCH_SCR
	ld [wJumptableIndex], a
	xor a
	ld [hSCX], a
	ld a, $a7
	ld [hWX], a
	ret

Pokedex_NextOrPreviousDexEntry:
	ld a, [wDexListingCursor]
	ld [wBackupDexListingCursor], a
	ld a, [wDexListingScrollOffset]
	ld [wBackupDexListingPage], a
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .up
	ld a, [hl]
	and D_DOWN
	jr nz, .down
	and a
	ret

.up
	ld a, [wDexListingHeight]
	ld d, a
	ld a, [wDexListingEnd]
	ld e, a
	call Pokedex_ListingMoveCursorUp
	jr nc, .nope
	call Pokedex_GetSelectedMon
	call Pokedex_CheckSeen
	jr nz, .yep
	jr .up

.down
	ld a, [wDexListingHeight]
	ld d, a
	ld a, [wDexListingEnd]
	ld e, a
	call Pokedex_ListingMoveCursorDown
	jr nc, .nope
	call Pokedex_GetSelectedMon
	call Pokedex_CheckSeen
	jr z, .down

.yep
	scf
	ret

.nope
	ld a, [wBackupDexListingCursor]
	ld [wDexListingCursor], a
	ld a, [wBackupDexListingPage]
	ld [wDexListingScrollOffset], a
	and a
	ret

Pokedex_ListingHandleDPadInput:
; Handles D-pad input for a list of Pokémon.
	ld a, [wDexListingHeight]
	ld d, a
	ld a, [wDexListingEnd]
	ld e, a
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, Pokedex_ListingMoveCursorUp
	ld a, [hl]
	and D_DOWN
	jr nz, Pokedex_ListingMoveCursorDown
	ld a, d
	cp e
	jr nc, Pokedex_ListingPosStayedSame
	ld a, [hl]
	and D_LEFT
	jr nz, Pokedex_ListingMoveUpOnePage
	ld a, [hl]
	and D_RIGHT
	jr nz, Pokedex_ListingMoveDownOnePage
Pokedex_ListingPosStayedSame:
	and a
	ret

Pokedex_ListingMoveCursorUp:
	ld hl, wDexListingCursor
	ld a, [hl]
	and a
	jr z, .try_scrolling
	dec [hl]
	jr Pokedex_ListingPosChanged
.try_scrolling
	ld hl, wDexListingScrollOffset
	ld a, [hl]
	and a
	jr z, Pokedex_ListingPosStayedSame
	dec [hl]
	jr Pokedex_ListingPosChanged

Pokedex_ListingMoveCursorDown:
	ld hl, wDexListingCursor
	ld a, [hl]
	inc a
	cp e
	jr nc, Pokedex_ListingPosStayedSame
	cp d
	jr nc, .try_scrolling
	inc [hl]
	jr Pokedex_ListingPosChanged
.try_scrolling
	ld hl, wDexListingScrollOffset
	add [hl]
	cp e
	jr nc, Pokedex_ListingPosStayedSame
	inc [hl]
	jr Pokedex_ListingPosChanged

Pokedex_ListingMoveUpOnePage:
	ld hl, wDexListingScrollOffset
	ld a, [hl]
	and a
	jr z, Pokedex_ListingPosStayedSame
	cp d
	jr nc, .not_near_top
; If we're already less than page away from the top, go to the top.
	xor a
	ld [hl], a
	jr Pokedex_ListingPosChanged
.not_near_top
	sub d
	ld [hl], a
	jr Pokedex_ListingPosChanged

Pokedex_ListingMoveDownOnePage:
; When moving down a page, the return value always report a change in position.
	ld hl, wDexListingScrollOffset
	ld a, d
	add a
	add [hl]
	jr c, .near_bottom
	cp e
	jr c, .not_near_bottom
.near_bottom
	ld a, e
	sub d
	ld [hl], a
	jr Pokedex_ListingPosChanged
.not_near_bottom
	ld a, [hl]
	add d
	ld [hl], a
Pokedex_ListingPosChanged:
	scf
	ret

Pokedex_FillColumn:
; Fills a column starting at HL, going downwards.
; B is the height of the column and A is the tile it's filled with.
	push de
	ld de, SCREEN_WIDTH
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	pop de
	ret

Pokedex_DrawMainScreenBG:
; Draws the left sidebar and the bottom bar on the main screen.
	hlcoord 0, 17
	ld de, String_START_SEARCH
	call Pokedex_PlaceString
	ld a, $32
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	hlcoord 0, 0
	lb bc, 7, 7
	call Pokedex_PlaceBorder
	hlcoord 0, 9
	lb bc, 6, 7
	call Pokedex_PlaceBorder
	hlcoord 1, 11
	ld de, .string_seen
	call PlaceText
	ld hl, PokedexSeen
	ld b, EndPokedexSeen - PokedexSeen
	call CountSetBits
	ld de, wd265
	hlcoord 5, 12
	lb bc, 1, 3
	call PrintNum
	hlcoord 1, 14
	ld de, .string_own
	call PlaceText
	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	call CountSetBits
	ld de, wd265
	hlcoord 5, 15
	lb bc, 1, 3
	call PrintNum
	hlcoord 8, 1
	ld b, 7
	ld a, $5a
	call Pokedex_FillColumn
	hlcoord 8, 10
	ld b, 6
	ld a, $5a
	call Pokedex_FillColumn
	hlcoord 8, 0
	ld [hl], $59
	hlcoord 8, 8
	ld [hl], $53
	hlcoord 8, 9
	ld [hl], $54
	hlcoord 8, 16
	ld [hl], $5b
	jp Pokedex_PlaceFrontpicTopLeftCorner

.string_seen
	text "Seen"
	done

.string_own
	text "Own"
	done

String_START_SEARCH:
	db $3b, $41, $42, $43, $4b, $4c, $4d, $4e, $3c, $ff ; START > SEARCH

Pokedex_DrawDexEntryScreenBG:
	call Pokedex_FillBackgroundColor2
	hlcoord 0, 0
	lb bc, 15, 18
	call Pokedex_PlaceBorder
	hlcoord 19, 0
	ld [hl], $34
	hlcoord 19, 1
	ld a, " "
	ld b, 15
	call Pokedex_FillColumn
	ld [hl], $39
	hlcoord 1, 10
	ld bc, 19
	ld a, $61
	call ByteFill
	hlcoord 1, 17
	ld bc, 18
	ld a, " "
	call ByteFill
	hlcoord 9, 7
	ld de, .Height
	call Pokedex_PlaceString
	hlcoord 9, 9
	ld de, .Weight
	call PlaceText
	hlcoord 0, 17
	ld [hl], $3b
	inc hl
	ld de, .MenuItems
	call PlaceText
	jp Pokedex_PlaceFrontpicTopLeftCorner

.Height
	db "HT  ?", $5e, "??", $5f, $ff ; HT  ?'??"
.Weight
	ctxt "WT   ???lb"
	done
.MenuItems
	ctxt " Page Area Cry Prnt"
	done

Pokedex_DrawSearchScreenBG:
	call Pokedex_FillBackgroundColor2
	hlcoord 0, 2
	lb bc, 14, 18
	call Pokedex_PlaceBorder
	hlcoord 0, 1
	ld de, .Title
	call Pokedex_PlaceString
	ld a, $3d
	ldcoord_a 8, 4
	ldcoord_a 8, 6
	inc a
	ldcoord_a 17, 4
	ldcoord_a 17, 6
	hlcoord 3, 4
	ld de, .Types
	call PlaceText
	hlcoord 3, 13
	ld de, .Menu
	jp PlaceText

.Title
	db $3b, " Search ", $3c, $ff
.Types
	ctxt "Type1"
	next "Type2"
	done

.Menu
	ctxt "Begin Search"
	next "Cancel"
	done

Pokedex_DrawSearchResultsScreenBG:
	call Pokedex_FillBackgroundColor2
	hlcoord 0, 0
	lb bc, 7, 7
	call Pokedex_PlaceBorder
	hlcoord 0, 11
	lb bc, 5, 18
	call Pokedex_PlaceBorder
	hlcoord 1, 12
	ld de, .BottomWindowText
	call PlaceText
	ld de, wDexSearchResultCount
	hlcoord 1, 16
	lb bc, 1, 3
	call PrintNum
	hlcoord 8, 0
	ld [hl], $59
	hlcoord 8, 1
	ld b, 7
	ld a, $5a
	call Pokedex_FillColumn
	hlcoord 8, 8
	ld [hl], $53
	hlcoord 8, 9
	ld [hl], $69
	hlcoord 8, 10
	ld [hl], $6a
	jp Pokedex_PlaceFrontpicTopLeftCorner

.BottomWindowText
	ctxt "Search Results"
	next "  Type"
	next "    found!"
	done

Pokedex_PlaceSearchResultsTypeStrings:
	ld a, [wDexSearchMonType1]
	hlcoord 0, 14
	call Pokedex_PlaceTypeString
	ld a, [wDexSearchMonType1]
	ld b, a
	ld a, [wDexSearchMonType2]
	and a
	ret z
	cp b
	ret z
	hlcoord 2, 15
	call Pokedex_PlaceTypeString
	hlcoord 1, 15
	ld [hl], "/"
	ret

Pokedex_FillBackgroundColor2:
	hlcoord 0, 0
	ld a, $32
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	jp ByteFill

Pokedex_PlaceFrontpicTopLeftCorner:
	hlcoord 1, 1
Pokedex_PlaceFrontpicAtHL:
	xor a
	ld b, $7
.row
	ld c, $7
	push af
	push hl
.col
	ld [hli], a
	add $7
	dec c
	jr nz, .col
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop af
	inc a
	dec b
	jr nz, .row
	ret

Pokedex_PlaceString:
.loop
	ld a, [de]
	cp -1
	ret z
	inc de
	ld [hli], a
	jr .loop

Pokedex_PlaceBorder:
	push hl
	ld a, $33
	ld [hli], a
	ld d, $34
	call .FillRow
	ld a, $35
	ld [hl], a
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
.loop
	push hl
	ld a, $36
	ld [hli], a
	ld d, $7f
	call .FillRow
	ld a, $37
	ld [hl], a
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .loop
	ld a, $38
	ld [hli], a
	ld d, $39
	call .FillRow
	ld a, $3a
	ld [hl], a
	ret

.FillRow
	ld e, c
.row_loop
	ld a, e
	and a
	ret z
	ld a, d
	ld [hli], a
	dec e
	jr .row_loop

Pokedex_PrintListing:
; Prints the list of Pokémon on the main Pokédex screen.
	ld c, 11
; Clear (2 * [wDexListingHeight] + 1) by 11 box starting at 0,1
	hlcoord 0, 1
	ld a, [wDexListingHeight]
	add a
	inc a
	ld b, a
	ld a, " "
	call FillBoxWithByte

; Load de with wPokedexDataStart + [wDexListingScrollOffset]
	ld a, [wDexListingScrollOffset]
	ld e, a
	ld d, $0
	ld hl, wPokedexDataStart
	add hl, de
	ld e, l
	ld d, h
	hlcoord 0, 2
	ld a, [wDexListingHeight]
.loop
	push af
	ld a, [de]
	ld [wd265], a
	push de
	push hl
	call .PrintEntry
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop de
	inc de
	pop af
	dec a
	jr nz, .loop
	jp Pokedex_LoadSelectedMonTiles

.PrintEntry
; Prints one entry in the list of Pokémon on the main Pokédex screen.
	and a
	ret z
	call Pokedex_PrintNumberIfOldMode
	call Pokedex_PlaceDefaultStringIfNotSeen
	ret c
	call Pokedex_PlaceCaughtSymbolIfCaught
	push hl
	call GetPokemonName
	pop hl
	jp PlaceString

;wd265: Pokemon
;Returns the Naljo ID
Pokedex_GetNaljoNum:
	ld a, [wd265]
	ld hl, NaljoPokedexOrder
	ld b, a
	ld c, 1
.loop
	ld a, [hli]
	cp b
	jr z, .gotNaljoNum
	inc c
	ld a, c
	cp NUM_POKEMON + 1
	jr nz, .loop
	xor a ;Not found
	jr .end
.gotNaljoNum
	ld a, c
	cp LIBABEEL
	jr c, .end
	dec a
.end
	ld [wDexSearchMonType2], a
	ret

Pokedex_PrintNumberIfOldMode:
	push hl
	ld de, -SCREEN_WIDTH
	add hl, de

	push hl
	call Pokedex_GetNaljoNum
	pop hl
	and a
	jr z, .question_marks

	ld de, wDexSearchMonType2
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	pop hl
	ret

.question_marks
	ld de, .ThreeQuestionMarks
	call PlaceText
	pop hl
	ret

.ThreeQuestionMarks
	text "???"
	done

Pokedex_PlaceCaughtSymbolIfCaught:
	call Pokedex_CheckCaught
	jr nz, .place_caught_symbol
	inc hl
	ret

.place_caught_symbol
	ld a, $4f
	ld [hli], a
	ret

Pokedex_PlaceDefaultStringIfNotSeen:
	call Pokedex_CheckSeen
	ret nz
	inc hl
	ld de, .NameNotSeen
	call PlaceText
	scf
	ret

.NameNotSeen:
	text "-----"
	done

Pokedex_DrawFootprint:
	hlcoord 18, 1
	ld a, $62
	ld [hli], a
	ld [hl], $63
	hlcoord 18, 2
	ld a, $64
	ld [hli], a
	ld [hl], $65
	ret

Pokedex_GetSelectedMon:
; Gets the species of the currently selected Pokémon. This corresponds to the
; position of the cursor in the main listing, but this function can be used
; on all Pokédex screens.
	ld a, [wDexListingCursor]
	ld hl, wDexListingScrollOffset
	add [hl]
	ld e, a
	ld d, $0
	ld hl, wPokedexDataStart
	add hl, de
	ld a, [hl]
	ld [wd265], a
	ret

Pokedex_CheckCaught:
	push hl
	ld hl, CheckCaughtMon
	jr Pokedex_CheckCaughtSeen

Pokedex_CheckSeen:
	push hl
	ld hl, CheckSeenMon
Pokedex_CheckCaughtSeen:
	push de
	ld a, [wd265]
	dec a
	call _hl_
	pop de
	pop hl
	ret

Pokedex_OrderMonsByMode:
	ld hl, wPokedexDataStart
	ld bc, wPokedexMetadata - wPokedexDataStart
	xor a
	call ByteFill
	ld de, NaljoPokedexOrder
	ld hl, wPokedexDataStart
	ld c, NUM_POKEMON
.loopnew
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loopnew
	jp .FindLastSeen

.FindLastSeen
	ld hl, wPokedexDataStart + NUM_POKEMON - 1
	ld d, NUM_POKEMON - 1
	ld e, d
.loopfindend
	ld a, [hld]
	ld [wd265], a
	call Pokedex_CheckSeen
	jr nz, .foundend
	dec d
	dec e
	jr nz, .loopfindend
.foundend
	ld a, d
	inc a
	cp LIBABEEL
	jr nz, .skipEggCheck
	dec a
.skipEggCheck
	ld [wDexListingEnd], a
	ret

INCLUDE "data/pokedex/dex_order.asm"

Pokedex_UpdateSearchMonType:
	ld a, [wDexArrowCursorPosIndex]
	cp 2
	jr nc, .no_change
	ld hl, hJoyLast
	ld a, [hl]
	and D_LEFT
	jr nz, Pokedex_PrevSearchMonType
	ld a, [hl]
	and D_RIGHT
	jr nz, Pokedex_NextSearchMonType
.no_change
	and a
	ret

Pokedex_PrevSearchMonType:
	ld a, [wDexArrowCursorPosIndex]
	and a
	jr nz, .type2

	ld hl, wDexSearchMonType1
	ld a, [hl]
	cp $1
	jr z, .wrap_around
	dec [hl]
	jr .done

.type2
	ld hl, wDexSearchMonType2
	ld a, [hl]
	and a
	jr z, .wrap_around
	dec [hl]
	jr .done

.wrap_around
	ld [hl], $14

.done
	scf
	ret

Pokedex_NextSearchMonType:
	ld a, [wDexArrowCursorPosIndex]
	and a
	jr nz, .type2

	ld hl, wDexSearchMonType1
	ld a, [hl]
	cp $14
	jr nc, .type1_wrap_around
	inc [hl]
	jr .done
.type1_wrap_around
	ld [hl], $1
	jr .done

.type2
	ld hl, wDexSearchMonType2
	ld a, [hl]
	cp $14
	jr nc, .type2_wrap_around
	inc [hl]
	jr .done
.type2_wrap_around
	ld [hl], 0

.done
	scf
	ret

Pokedex_PlaceSearchScreenTypeStrings:
	xor a
	ld [hBGMapMode], a
	hlcoord 9, 3
	lb bc, 4, 8
	ld a, " "
	call FillBoxWithByte
	ld a, [wDexSearchMonType1]
	hlcoord 9, 4
	call Pokedex_PlaceTypeString
	ld a, [wDexSearchMonType2]
	hlcoord 9, 6
	call Pokedex_PlaceTypeString
	ld a, $1
	ld [hBGMapMode], a
	ret

Pokedex_PlaceTypeString:
	cp (.TypeStringsEnd - .TypeStrings) / 8
	ret nc
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, .TypeStrings
	add hl, de
	pop de
	ld bc, 8
	rst CopyBytes
	ret

.TypeStrings
	db "  ----  "
	db " Normal "
	db "  Fire  "
	db " Water  "
	db " Grass  "
	db "Electric"
	db "  Ice   "
	db "Fighting"
	db " Poison "
	db " Ground "
	db " Flying "
	db "Psychic "
	db "  Bug   "
	db "  Rock  "
	db " Ghost  "
	db " Dragon "
	db "  Dark  "
	db " Steel  "
	db " Fairy  "
	db "  Gas   "
	db " Sound  "
.TypeStringsEnd

Pokedex_SearchForMons:
	ld a, [wDexSearchMonType2]
	and a
	call nz, .Search
	ld a, [wDexSearchMonType1]
	and a
	ret z

.Search
	dec a
	ld e, a
	ld d, 0
	ld hl, .TypeConversionTable
	add hl, de
	ld a, [hl]
	ld [wDexConvertedMonType], a
	ld hl, wPokedexDataStart
	ld de, wPokedexDataStart
	ld c, NUM_POKEMON
	xor a
	ld [wDexSearchResultCount], a
.loop
	push bc
	ld a, [hl]
	and a
	jr z, .next_mon
	ld [wd265], a
	ld [wCurSpecies], a
	call Pokedex_CheckCaught
	jr z, .next_mon
	push hl
	push de
	call GetBaseData
	pop de
	pop hl
	ld a, [wDexConvertedMonType]
	ld b, a
	ld a, [BaseType1]
	cp b
	jr z, .match_found
	ld a, [BaseType2]
	cp b
	jr nz, .next_mon

.match_found
	ld a, [wd265]
	ld [de], a
	inc de
	ld a, [wDexSearchResultCount]
	inc a
	ld [wDexSearchResultCount], a

.next_mon
	inc hl
	pop bc
	dec c
	jr nz, .loop

	ld l, e
	ld h, d
	ld a, [wDexSearchResultCount]
	ld c, 0

.zero_remaining_mons
	cp NUM_POKEMON
	ret z
	ld [hl], c
	inc hl
	inc a
	jr .zero_remaining_mons

.TypeConversionTable
	db NORMAL
	db FIRE
	db WATER
	db GRASS
	db ELECTRIC
	db ICE
	db FIGHTING
	db POISON
	db GROUND
	db FLYING
	db PSYCHIC
	db BUG
	db ROCK
	db GHOST
	db DRAGON
	db DARK
	db STEEL
	db FAIRY_T
	db GAS
	db SOUND

Pokedex_DisplayTypeNotFoundMessage:
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 12
	lb bc, 4, 18
	call Pokedex_PlaceBorder
	ld de, .TypeNotFound
	hlcoord 1, 14
	call PlaceText
	ld a, $1
	ld [hBGMapMode], a
	ld c, $80
	jp DelayFrames

.TypeNotFound
	ctxt "The specified type"
	next "was not found."
	done

Pokedex_UpdateCursorOAM:
	call Pokedex_PutNewModeABCModeCursorOAM
	jp Pokedex_PutScrollbarOAM

Pokedex_PutOldModeCursorOAM:
	ld hl, .CursorOAM
	ld a, [wDexListingCursor]
	or a
	jr nz, .okay
	ld hl, .CursorAtTopOAM
.okay
	jp Pokedex_LoadCursorOAM

.CursorOAM
	db $18, $47, $30, $07
	db $10, $47, $31, $07
	db $10, $4f, $32, $07
	db $10, $57, $32, $07
	db $10, $5f, $32, $07
	db $10, $67, $33, $07
	db $10, $7e, $33, $27
	db $10, $86, $32, $27
	db $10, $8e, $32, $27
	db $10, $96, $32, $27
	db $10, $9e, $31, $27
	db $18, $9e, $30, $27
	db $20, $47, $30, $47
	db $28, $47, $31, $47
	db $28, $4f, $32, $47
	db $28, $57, $32, $47
	db $28, $5f, $32, $47
	db $28, $67, $33, $47
	db $28, $7e, $33, $67
	db $28, $86, $32, $67
	db $28, $8e, $32, $67
	db $28, $96, $32, $67
	db $28, $9e, $31, $67
	db $20, $9e, $30, $67
	db $ff

.CursorAtTopOAM
; OAM data for when the cursor is at the top of the list. The tiles at the top
; are cut off so they don't show up outside the list area.
	db $18, $47, $30, $07
	db $10, $47, $34, $07
	db $10, $4f, $35, $07
	db $10, $57, $35, $07
	db $10, $5f, $35, $07
	db $10, $67, $36, $07
	db $10, $7e, $36, $27
	db $10, $86, $35, $27
	db $10, $8e, $35, $27
	db $10, $96, $35, $27
	db $10, $9e, $34, $27
	db $18, $9e, $30, $27
	db $20, $47, $30, $47
	db $28, $47, $31, $47
	db $28, $4f, $32, $47
	db $28, $57, $32, $47
	db $28, $5f, $32, $47
	db $28, $67, $33, $47
	db $28, $7e, $33, $67
	db $28, $86, $32, $67
	db $28, $8e, $32, $67
	db $28, $96, $32, $67
	db $28, $9e, $31, $67
	db $20, $9e, $30, $67
	db $ff

Pokedex_PutNewModeABCModeCursorOAM:
	ld hl, .CursorOAM
	jp Pokedex_LoadCursorOAM

.CursorOAM
	db $18, $47, $30, $07
	db $10, $47, $31, $07
	db $10, $4f, $32, $07
	db $10, $57, $32, $07
	db $10, $5f, $33, $07
	db $10, $80, $33, $27
	db $10, $88, $32, $27
	db $10, $90, $32, $27
	db $10, $98, $31, $27
	db $18, $98, $30, $27
	db $20, $47, $30, $47
	db $28, $47, $31, $47
	db $28, $4f, $32, $47
	db $28, $57, $32, $47
	db $28, $5f, $33, $47
	db $28, $80, $33, $67
	db $28, $88, $32, $67
	db $28, $90, $32, $67
	db $28, $98, $31, $67
	db $20, $98, $30, $67
	db $ff

Pokedex_UpdateSearchResultsCursorOAM:
	ld hl, .CursorOAM
	jp Pokedex_LoadCursorOAM

.CursorOAM
	db $18, $47, $30, $07
	db $10, $47, $31, $07
	db $10, $4f, $32, $07
	db $10, $57, $32, $07
	db $10, $5f, $32, $07
	db $10, $67, $33, $07
	db $10, $7e, $33, $27
	db $10, $86, $32, $27
	db $10, $8e, $32, $27
	db $10, $96, $32, $27
	db $10, $9e, $31, $27
	db $18, $9e, $30, $27
	db $20, $47, $30, $47
	db $28, $47, $31, $47
	db $28, $4f, $32, $47
	db $28, $57, $32, $47
	db $28, $5f, $32, $47
	db $28, $67, $33, $47
	db $28, $7e, $33, $67
	db $28, $86, $32, $67
	db $28, $8e, $32, $67
	db $28, $96, $32, $67
	db $28, $9e, $31, $67
	db $20, $9e, $30, $67
	db $ff

Pokedex_LoadCursorOAM:
	ld de, Sprites
.loop
	ld a, [hl]
	cp $ff
	ret z
	ld a, [wDexListingCursor]
	and $7
	swap a
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	jr .loop

Pokedex_PutScrollbarOAM:
; Writes the OAM data for the scrollbar in the new mode and ABC mode.
	push de
	ld a, [wDexListingEnd]
	dec a
	ld e, a
	ld a, [wDexListingCursor]
	ld hl, wDexListingScrollOffset
	add [hl]
	cp e
	jr z, .asm_4133f
	ld hl, $0
	ld bc, $79
	rst AddNTimes
	ld e, l
	ld d, h
	ld b, $0
	ld a, d
	or e
	jr z, .asm_41341
	ld a, [wDexListingEnd]
	ld c, a
.asm_41333
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	jr c, .asm_41341
	inc b
	jr .asm_41333
.asm_4133f
	ld b, $79
.asm_41341
	ld a, $14
	add b
	pop hl
	ld [hli], a
	ld a, $a1
	ld [hli], a
	ld a, $f
	ld [hli], a
	ld [hl], $0
	ret

Pokedex_InitArrowCursor:
	xor a
	ld [wDexArrowCursorPosIndex], a
	ld [wDexArrowCursorDelayCounter], a
	ld [wDexArrowCursorBlinkCounter], a
	ret

Pokedex_MoveArrowCursor:
; bc = [de] - 1
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec a
	ld c, a
	inc de
	call Pokedex_BlinkArrowCursor

	ld hl, hJoyPressed
	ld a, [hl]
	and D_LEFT | D_UP
	and b
	jr nz, .move_left_or_up
	ld a, [hl]
	and D_RIGHT | D_DOWN
	and b
	jr nz, .move_right_or_down
	ld a, [hl]
	and SELECT
	and b
	jr nz, .select
	call Pokedex_ArrowCursorDelay
	jr c, .no_action
	ld hl, hJoyLast
	ld a, [hl]
	and D_LEFT | D_UP
	and b
	jr nz, .move_left_or_up
	ld a, [hl]
	and D_RIGHT | D_DOWN
	and b
	jr nz, .move_right_or_down
	jr .no_action

.move_left_or_up
	ld a, [wDexArrowCursorPosIndex]
	and a
	jr z, .no_action
	call Pokedex_GetArrowCursorPos
	ld [hl], " "
	ld hl, wDexArrowCursorPosIndex
	dec [hl]
	jr .update_cursor_pos

.move_right_or_down
	ld a, [wDexArrowCursorPosIndex]
	cp c
	jr nc, .no_action
	call Pokedex_GetArrowCursorPos
	ld [hl], " "
	ld hl, wDexArrowCursorPosIndex
	inc [hl]

.update_cursor_pos
	call Pokedex_GetArrowCursorPos
	ld [hl], "▶"
	ld a, 12
	ld [wDexArrowCursorDelayCounter], a
	xor a
	ld [wDexArrowCursorBlinkCounter], a
	scf
	ret

.no_action
	and a
	ret

.select
	call Pokedex_GetArrowCursorPos
	ld [hl], " "
	ld a, [wDexArrowCursorPosIndex]
	cp c
	jr c, .update
	ld a, -1
.update
	inc a
	ld [wDexArrowCursorPosIndex], a
	jr .update_cursor_pos

Pokedex_GetArrowCursorPos:
	ld a, [wDexArrowCursorPosIndex]
	add a
	ld l, a
	ld h, 0
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Pokedex_BlinkArrowCursor:
	ld hl, wDexArrowCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $8
	jr z, .blink_on
	call Pokedex_GetArrowCursorPos
	ld [hl], " "
	ret

.blink_on
	call Pokedex_GetArrowCursorPos
	ld [hl], "▶"
	ret

Pokedex_ArrowCursorDelay:
; Updates the delay counter set when moving the arrow cursor.
; Returns whether the delay is active in carry.
	ld hl, wDexArrowCursorDelayCounter
	ld a, [hl]
	and a
	ret z

	dec [hl]
	scf
	ret

Pokedex_BlackOutBG:
; Make BG palettes black so that the BG becomes all black.
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, UnknBGPals
	ld bc, $40
	xor a
	call ByteFill
	pop af
	ld [rSVBK], a
	; fallthrough

Pokedex_ApplyPrintPals:
	ld a, $ff
	call DmgToCgbBGPals
	ld a, $ff
	call DmgToCgbObjPal0
	jp DelayFrame

Pokedex_GetSGBLayout:
	ld b, a
	predef GetSGBLayout
	; fallthrough

Pokedex_ApplyUsualPals:
; This applies the palettes used for most Pokédex screens.
	ld a, $e4
	call DmgToCgbBGPals
	ld a, $e0
	jp DmgToCgbObjPal0

Pokedex_LoadSelectedMonTiles:
; Loads the tiles of the currently selected Pokémon.
	call Pokedex_GetSelectedMon
	call Pokedex_CheckSeen
	jr z, .QuestionMark
	ld a, [wd265]
	ld [wCurPartySpecies], a
	call GetBaseData
	ld de, VTiles2
	predef_jump GetFrontpic

.QuestionMark
	ld hl, QuestionMarkLZ
	ld de, VTiles2
	lb bc, BANK(QuestionMarkLZ), 7 * 7
	jp DecompressRequest2bpp

Pokedex_LoadCurrentFootprint:
	call Pokedex_GetSelectedMon
Pokedex_LoadAnyFootprint:
	ld a, [wd265]
	dec a
	and ($ff ^ $07) ; $f8 ; $1f << 3
	srl a
	srl a
	srl a
	ld e, 0
	ld d, a
	ld a, [wd265]
	dec a
	and 7
	swap a ; * $10
	ld l, a
	ld h, 0
	add hl, de
	ld de, Footprints
	add hl, de

	push hl
	ld e, l
	ld d, h
	ld hl, VTiles2 tile $62
	lb bc, BANK(Footprints), 2
	call Request1bpp
	pop hl

	; Whoever was editing footprints forgot to fix their
	; tile editor. Now each bottom half is 8 tiles off.
	ld de, 8 tiles
	add hl, de

	ld e, l
	ld d, h
	ld hl, VTiles2 tile $64
	lb bc, BANK(Footprints), 2
	jp Request1bpp

Pokedex_LoadGFX:
	call DisableLCD
Pokedex_LoadGFX2:
	ld hl, VTiles2
	ld bc, $31 tiles
	xor a
	call ByteFill
	call Pokedex_LoadInvertedFont
	call LoadFontsExtra
	ld hl, VTiles2 tile $60
	ld bc, $20 tiles
	call Pokedex_InvertTiles
	ld hl, PokedexLZ
	ld de, VTiles2 tile $31
	call Decompress
	ld hl, PokedexSlowpokeLZ
	ld de, VTiles0
	call Decompress
	ld a, 6
	call SkipMusic
	jp EnableLCD

Pokedex_LoadInvertedFont:
	call LoadStandardFont
	ld hl, VTiles1
	ld bc, $80 tiles
	; fallthrough

Pokedex_InvertTiles:
.loop
	ld a, [hl]
	xor $ff
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

PokedexLZ: INCBIN "gfx/pokedex/pokedex.2bpp.lz"

PokedexSlowpokeLZ: INCBIN "gfx/pokedex/slowpoke.2bpp.lz"

_NewPokedexEntry:
	xor a
	ld [hBGMapMode], a
	call DrawDexEntryScreenRightEdge
	call Pokedex_ResetBGMapMode
	call DisableLCD
	call LoadStandardFont
	call LoadFontsExtra
	call Pokedex_LoadGFX2
	call Pokedex_LoadAnyFootprint
	ld a, [wd265]
	ld [wCurPartySpecies], a
	call Pokedex_DrawDexEntryScreenBG
	call Pokedex_DrawFootprint
	hlcoord 0, 17
	ld [hl], $3b
	inc hl
	ld bc, 19
	ld a, " "
	call ByteFill
	callba DisplayDexEntry
	call EnableLCD
	call ApplyTilemapInVBlank
	call GetBaseData
	ld de, VTiles2
	predef GetFrontpic
	ld a, SCGB_POKEDEX
	call Pokedex_GetSGBLayout
	call DelayFrame
	ld a, [wCurPartySpecies]
	jp PlayCry

Pokedex_SetBGMapMode_3ifDMG_4ifCGB:
	call Pokedex_SetBGMapMode4
	; fallthrough

Pokedex_SetBGMapMode3:
	ld a, $3
	ld [hBGMapMode], a
	ld c, 3
	jp DelayFrames

Pokedex_SetBGMapMode4:
	ld a, $4
	ld [hBGMapMode], a
	ld c, 3
	jp DelayFrames

Pokedex_ResetBGMapMode:
	xor a
	ld [hBGMapMode], a
	ret

_MapMysteryZoneTextPokedex:
	text_jump MapMysteryZoneText

DrawPokedexListWindow:
	ld a, $32
	hlcoord 0, 17
	ld bc, 12
	call ByteFill
	hlcoord 0, 1
	lb bc, 15, 11
	call ClearBox
	ld a, $34
	hlcoord 0, 0
	ld bc, 11
	call ByteFill
	ld a, $39
	hlcoord 0, 16
	ld bc, 11
	call ByteFill
	hlcoord 5, 0
	ld [hl], $3f
	hlcoord 5, 16
	ld [hl], $40

; no scroll bar
	hlcoord 11, 0
	ld [hl], $66
	ld a, $67
	hlcoord 11, 1
	ld b, SCREEN_HEIGHT - 3
	call Bank77_FillColumn
	ld [hl], $68
	ret

DrawPokedexSearchResultsWindow:
	ld a, $34
	hlcoord 0, 0
	ld bc, 11
	call ByteFill
	ld a, $39
	hlcoord 0, 10
	ld bc, 11
	call ByteFill
	hlcoord 5, 0
	ld [hl], $3f
	hlcoord 5, 10
	ld [hl], $40
	hlcoord 11, 0
	ld [hl], $66
	ld a, $67
	hlcoord 11, 1
	ld b, SCREEN_HEIGHT / 2
	call Bank77_FillColumn
	ld [hl], $68
	ld a, $34
	hlcoord 0, 11
	ld bc, 11
	call ByteFill
	ld a, $39
	hlcoord 0, 17
	ld bc, 11
	call ByteFill
	hlcoord 11, 11
	ld [hl], $66
	ld a, $67
	hlcoord 11, 12
	ld b, 5
	call Bank77_FillColumn
	ld [hl], $68
	hlcoord 0, 12
	lb bc, 5, 11
	call ClearBox
	ld de, .esults_D
	hlcoord 0, 12
	jp PlaceText

.esults_D
; (Search R)
	ctxt "esults<NEXT>"
; (### foun)
	next "d!"
	done

DrawDexEntryScreenRightEdge:
	ld a, [hBGMapAddress]
	ld l, a
	ld a, [hBGMapAddress + 1]
	ld h, a
	push hl
	inc hl
	ld a, l
	ld [hBGMapAddress], a
	ld a, h
	ld [hBGMapAddress + 1], a
	hlcoord 19, 0
	ld [hl], $66
	hlcoord 19, 1
	ld a, $67
	ld b, 15
	call Bank77_FillColumn
	ld [hl], $68
	hlcoord 19, 17
	ld [hl], $3c
	xor a
	ld b, SCREEN_HEIGHT
	hlcoord 19, 0, AttrMap
	call Bank77_FillColumn
	call ApplyAttrAndTilemapInVBlank
	pop hl
	ld a, l
	ld [hBGMapAddress], a
	ld a, h
	ld [hBGMapAddress + 1], a
	ret

Bank77_FillColumn:
	push de
	ld de, SCREEN_WIDTH
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	pop de
	ret
