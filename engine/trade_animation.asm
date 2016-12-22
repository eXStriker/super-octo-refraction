TradeAnimation:
	xor a
	ld [wcf66], a
	ld hl, wPlayerTrademonSenderName
	ld de, wOTTrademonSenderName
	call LinkTradeAnim_LoadTradePlayerNames
	ld hl, wPlayerTrademonSpecies
	ld de, wOTTrademonSpecies
	call LinkTradeAnim_LoadTradeMonSpecies
	ld de, .data_28f3f
	jr RunTradeAnimSequence

.data_28f3f
	tradeanim_setup_givemon_scroll
	tradeanim_show_givemon_data
	tradeanim_do_givemon_scroll
	tradeanim_wait_80
	tradeanim_wait_96
	tradeanim_poof
	tradeanim_rocking_ball
	tradeanim_enter_link_tube
	tradeanim_wait_anim
	tradeanim_bulge_through_tube
	tradeanim_wait_anim
	tradeanim_1e
	tradeanim_give_trademon_sfx
	tradeanim_tube_to_ot
	tradeanim_sent_to_ot_text
	tradeanim_scroll_out_right

	tradeanim_ot_sends_text_1
	tradeanim_ot_bids_farewell
	tradeanim_wait_40
	tradeanim_scroll_out_right
	tradeanim_get_trademon_sfx
	tradeanim_tube_to_player
	tradeanim_enter_link_tube
	tradeanim_drop_ball
	tradeanim_exit_link_tube
	tradeanim_wait_anim
	tradeanim_show_getmon_data
	tradeanim_poof
	tradeanim_wait_anim
	tradeanim_1d
	tradeanim_animate_frontpic
	tradeanim_wait_80_if_ot_egg
	tradeanim_1e
	tradeanim_take_care_of_text
	tradeanim_scroll_out_right
	tradeanim_end

TradeAnimationPlayer2:
	xor a
	ld [wcf66], a
	ld hl, wOTTrademonSenderName
	ld de, wPlayerTrademonSenderName
	call LinkTradeAnim_LoadTradePlayerNames
	ld hl, wOTTrademonSpecies
	ld de, wPlayerTrademonSpecies
	call LinkTradeAnim_LoadTradeMonSpecies
	ld de, .data_28f7e
	jr RunTradeAnimSequence

.data_28f7e
	tradeanim_ot_sends_text_2
	tradeanim_ot_bids_farewell
	tradeanim_wait_40
	tradeanim_scroll_out_right
	tradeanim_get_trademon_sfx
	tradeanim_tube_to_ot
	tradeanim_enter_link_tube
	tradeanim_drop_ball
	tradeanim_exit_link_tube
	tradeanim_wait_anim
	tradeanim_show_getmon_data
	tradeanim_poof
	tradeanim_wait_anim
	tradeanim_1d
	tradeanim_animate_frontpic
	tradeanim_wait_180_if_ot_egg
	tradeanim_1e
	tradeanim_take_care_of_text
	tradeanim_scroll_out_right

	tradeanim_setup_givemon_scroll
	tradeanim_show_givemon_data
	tradeanim_do_givemon_scroll
	tradeanim_wait_40
	tradeanim_poof
	tradeanim_rocking_ball
	tradeanim_enter_link_tube
	tradeanim_wait_anim
	tradeanim_bulge_through_tube
	tradeanim_wait_anim
	tradeanim_1e
	tradeanim_give_trademon_sfx
	tradeanim_tube_to_player
	tradeanim_sent_to_ot_text
	tradeanim_scroll_out_right
	tradeanim_end

RunTradeAnimSequence:
	ld hl, wTradeAnimPointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [hMapAnims]
	push af
	xor a
	ld [hMapAnims], a
	ld hl, VramState
	ld a, [hl]
	push af
	res 0, [hl]
	ld hl, wOptions
	ld a, [hl]
	push af
	set 4, [hl]
	call .TradeAnimLayout
	ld a, [wcf66]
	and a
	jr nz, .anim_loop
	ld de, MUSIC_TRADE
	call PlayMusic2
.anim_loop
	call DoTradeAnimation
	jr nc, .anim_loop
	pop af
	ld [wOptions], a
	pop af
	ld [VramState], a
	pop af
	ld [hMapAnims], a
	ret

.TradeAnimLayout
	xor a
	ld [wJumptableIndex], a
	call ClearBGPalettes
	call ClearSprites
	call ClearTileMap
	call DisableLCD
	call LoadFontsBattleExtra
	callba ClearSpriteAnims
	ld a, $1
	ld [rVBK], a
	ld hl, VTiles0
	ld bc, SRAM_Begin - VTiles0
	xor a
	call ByteFill
	ld a, $0
	ld [rVBK], a
	hlbgcoord 0, 0
	ld bc, SRAM_Begin - VBGMap0
	ld a, " "
	call ByteFill
	ld hl, TradeGameBoyLZ
	ld de, VTiles2 tile $31
	call Decompress
	ld hl, TradeArrowGFX
	ld de, VTiles1 tile $6d
	ld bc, $10
	ld a, BANK(TradeArrowGFX)
	call FarCopyBytes
	ld hl, TradeArrowGFX + $10
	ld de, VTiles1 tile $6e
	ld bc, $10
	ld a, BANK(TradeArrowGFX)
	call FarCopyBytes
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	callba GetTrademonFrontpic
	call EnableLCD
	call LoadTradeBallAndCableGFX
	ld a, [wPlayerTrademonSpecies]
	ld de, VTiles0
	call TradeAnim_GetFrontpic
	ld a, [wOTTrademonSpecies]
	ld de, VTiles0 tile $31
	call TradeAnim_GetFrontpic
	ld a, [wPlayerTrademonSpecies]
	ld de, wPlayerTrademonSpeciesName
	call TradeAnim_GetNickname
	ld a, [wOTTrademonSpecies]
	ld de, wOTTrademonSpeciesName
	call TradeAnim_GetNickname
	jp TradeAnim_NormalDMGPals

DoTradeAnimation:
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .finished
	jumptable .JumpTable
	callba PlaySpriteAnimations
	ld hl, wcf65
	inc [hl]
	call DelayFrame
	and a
	ret

.finished
	call LoadStandardFont
	scf
	ret

.JumpTable
	dw TradeAnim_Next               ; 00
	dw TradeAnim_ShowGivemonData    ; 01
	dw TradeAnim_ShowGetmonData     ; 02
	dw TradeAnim_EnterLinkTube      ; 03
	dw TradeAnim_04                 ; 04
	dw TradeAnim_ExitLinkTube       ; 05
	dw TradeAnim_TubeToOT1          ; 06
	dw TradeAnim_TubeToOT2          ; 07
	dw TradeAnim_TubeToOT3          ; 08
	dw TradeAnim_TubeToOT4          ; 09
	dw TradeAnim_TubeToOT5          ; 0a
	dw TradeAnim_TubeToOT6          ; 0b
	dw TradeAnim_TubeToOT7          ; 0c
	dw TradeAnim_TubeToOT8          ; 0d
	dw TradeAnim_TubeToPlayer1      ; 0e
	dw TradeAnim_TubeToPlayer2      ; 0f
	dw TradeAnim_TubeToPlayer3      ; 10
	dw TradeAnim_TubeToPlayer4      ; 11
	dw TradeAnim_TubeToPlayer5      ; 12
	dw TradeAnim_TubeToPlayer6      ; 13
	dw TradeAnim_TubeToPlayer7      ; 14
	dw TradeAnim_TubeToPlayer8      ; 15
	dw TradeAnim_SentToOTText       ; 16
	dw TradeAnim_OTBidsFarewell     ; 17
	dw TradeAnim_TakeCareOfText     ; 18
	dw TradeAnim_OTSendsText1       ; 19
	dw TradeAnim_OTSendsText2       ; 1a
	dw TradeAnim_SetupGivemonScroll ; 1b
	dw TradeAnim_DoGivemonScroll    ; 1c
	dw TradeAnim_1d                 ; 1d
	dw TradeAnim_1e                 ; 1e
	dw TradeAnim_ScrollOutRight     ; 1f
	dw TradeAnim_ScrollOutRight2    ; 20
	dw TraideAnim_Wait80            ; 21
	dw TraideAnim_Wait40            ; 22
	dw TradeAnim_RockingBall        ; 23
	dw TradeAnim_DropBall           ; 24
	dw TradeAnim_WaitAnim           ; 25
	dw TradeAnim_WaitAnim2          ; 26
	dw TradeAnim_Poof               ; 27
	dw TradeAnim_BulgeThroughTube   ; 28
	dw TradeAnim_GiveTrademonSFX    ; 29
	dw TradeAnim_GetTrademonSFX     ; 2a
	dw TradeAnim_End                ; 2b
	dw TradeAnim_AnimateFrontpic    ; 2c
	dw TradeAnim_Wait96             ; 2d
	dw TradeAnim_Wait80IfOTEgg      ; 2e
	dw TradeAnim_Wait180IfOTEgg     ; 2f

NextTradeAnim:
	ld hl, wJumptableIndex
	inc [hl]
	ret

TradeAnim_Next:
	ld hl, wTradeAnimPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	ld [wJumptableIndex], a
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

TradeAnim_End:
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

TradeAnim_TubeToOT1:
	ld a, $ed
	call Function292f6
	ld a, [wLinkTradeSendmonSpecies]
	ld [wd265], a
	xor a
	depixel 5, 11, 4, 0
	ld b, $0
	jr Function2914e

TradeAnim_TubeToPlayer1:
	ld a, $ee
	call Function292f6
	ld a, [wLinkTradeGetmonSpecies]
	ld [wd265], a
	ld a, $2
	depixel 9, 18, 4, 4
	ld b, $4

Function2914e:
	push bc
	push de
	push bc
	push de
	push af
	call DisableLCD
	callba ClearSpriteAnims
	hlbgcoord 20, 3
	ld bc, $c
	ld a, $60
	call ByteFill
	pop af
	call Function29281
	xor a
	ld [hSCX], a
	ld a, $7
	ld [hWX], a
	ld a, $70
	ld [hWY], a
	call EnableLCD
	call LoadTradeBubbleGFX
	pop de
	ld a, SPRITE_ANIM_INDEX_11
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_0B
	add hl, bc
	pop bc
	ld [hl], b
	pop de
	ld a, SPRITE_ANIM_INDEX_12
	call _InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_0B
	add hl, bc
	pop bc
	ld [hl], b
	call ApplyTilemapInVBlank
	ld b, SCGB_1B
	predef GetSGBLayout
	ld a, %11100100 ; 3,2,1,0
	call DmgToCgbBGPals
	ld a, %11010000
	call DmgToCgbObjPal0
	call NextTradeAnim
	ld a, $5c
	ld [wcf64], a
	ret

TradeAnim_TubeToOT2:
	call TradeAnim_TubeFlashBGPals
	ld a, [hSCX]
	add $2
	ld [hSCX], a
	cp $50
	ret nz
	ld a, $1
	call Function29281
	jp NextTradeAnim

TradeAnim_TubeToOT3:
	call TradeAnim_TubeFlashBGPals
	ld a, [hSCX]
	add $2
	ld [hSCX], a
	cp $a0
	ret nz
	ld a, $2
	call Function29281
	jp NextTradeAnim

TradeAnim_TubeToOT4:
	call TradeAnim_TubeFlashBGPals
	ld a, [hSCX]
	add $2
	ld [hSCX], a
	and a
	ret nz
	jp NextTradeAnim

TradeAnim_TubeToPlayer3:
	call TradeAnim_TubeFlashBGPals
	ld a, [hSCX]
	sub $2
	ld [hSCX], a
	cp $b0
	ret nz
	ld a, $1
	call Function29281
	jp NextTradeAnim

TradeAnim_TubeToPlayer4:
	call TradeAnim_TubeFlashBGPals
	ld a, [hSCX]
	sub $2
	ld [hSCX], a
	cp $60
	ret nz
	xor a
	call Function29281
	jp NextTradeAnim

TradeAnim_TubeToPlayer5:
	call TradeAnim_TubeFlashBGPals
	ld a, [hSCX]
	sub $2
	ld [hSCX], a
	and a
	ret nz
	jp NextTradeAnim

TradeAnim_TubeToOT6:
TradeAnim_TubeToPlayer6:
	ld a, $80
	ld [wcf64], a
	jp NextTradeAnim

TradeAnim_TubeToOT8:
TradeAnim_TubeToPlayer8:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	callba ClearSpriteAnims
	hlbgcoord 0, 0
	ld bc, SRAM_Begin - VBGMap0
	ld a, " "
	call ByteFill
	xor a
	ld [hSCX], a
	ld a, $90
	ld [hWY], a
	call EnableLCD
	call LoadTradeBallAndCableGFX
	call ApplyTilemapInVBlank
	call TradeAnim_NormalDMGPals
	jp TradeAnim_Next

TradeAnim_TubeToOT5:
TradeAnim_TubeToOT7:
TradeAnim_TubeToPlayer2:
TradeAnim_TubeToPlayer7:
	call TradeAnim_TubeFlashBGPals
	ld hl, wcf64
	ld a, [hl]
	and a
	jp z, NextTradeAnim
	dec [hl]
	ret

TradeAnim_GiveTrademonSFX:
	call TradeAnim_Next
	ld de, SFX_GIVE_TRADEMON
	jp PlaySFX

TradeAnim_GetTrademonSFX:
	call TradeAnim_Next
	ld de, SFX_GET_TRADEMON
	jp PlaySFX

Function29281:
	and 3
	jumptable

Jumptable_2928f:
	dw Function29297
	dw Function292af
	dw Function292be
	dw Function29297

Function29297:
	call ShowTrademonDetails_ClearTileMap
	hlcoord 9, 3
	ld [hl], $5b
	inc hl
	ld bc, 10
	ld a, $60
	call ByteFill
	hlcoord 3, 2
	jr Function292ec

Function292af:
	call ShowTrademonDetails_ClearTileMap
	hlcoord 0, 3
	ld bc, SCREEN_WIDTH
	ld a, $60
	jp ByteFill

Function292be:
	call ShowTrademonDetails_ClearTileMap
	hlcoord 0, 3
	ld bc, $11
	ld a, $60
	call ByteFill
	hlcoord 17, 3
	ld a, $5d
	ld [hl], a

	ld a, $61
	ld de, SCREEN_WIDTH
	ld c, $3
.loop
	add hl, de
	ld [hl], a
	dec c
	jr nz, .loop

	add hl, de
	ld a, $5f
	ld [hld], a
	ld a, $5b
	ld [hl], a
	hlcoord 10, 6
	; fallthrough

Function292ec:
	ld de, TradeGameBoyTilemap
	lb bc, 8, 6
	jp TradeAnim_CopyBox

Function292f6:
	push af
	call ClearBGPalettes
	call WaitTop
	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	call ClearTileMap
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, "─"
	call ByteFill
	hlcoord 0, 1
	ld de, wLinkPlayer1Name
	call PlaceString
	ld hl, wLinkPlayer2Name
	ld de, 0
.find_name_end_loop
	ld a, [hli]
	cp "@"
	jr z, .done
	dec de
	jr .find_name_end_loop

.done
	hlcoord 0, 4
	add hl, de
	ld de, wLinkPlayer2Name
	call PlaceString
	hlcoord 7, 2
	ld bc, 6
	pop af
	call ByteFill
	call ApplyTilemapInVBlank
	call WaitTop
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	jp ClearTileMap

TradeAnim_EnterLinkTube:
	call ClearTileMap
	call WaitTop
	ld a, $a0
	ld [hSCX], a
	call DelayFrame
	hlcoord 8, 2
	ld de, Tilemap_298f7
	lb bc, 3, 12
	call TradeAnim_CopyBox
	call ApplyTilemapInVBlank
	ld b, SCGB_1B
	predef GetSGBLayout
	ld a, %11100100 ; 3,2,1,0
	call DmgToCgbBGPals
	lb de, %11100100, %11100100 ; 3,2,1,0, 3,2,1,0
	call DmgToCgbObjPals
	ld de, SFX_POTION
	call PlaySFX
	jp NextTradeAnim

TradeAnim_04:
	ld a, [hSCX]
	and a
	jr z, .done
	add $4
	ld [hSCX], a
	ret

.done
	ld c, 80
	call DelayFrames
	jp TradeAnim_Next

TradeAnim_ExitLinkTube:
	ld a, [hSCX]
	cp $a0
	jr z, .asm_2939c
	sub $4
	ld [hSCX], a
	ret

.asm_2939c
	call ClearTileMap
	xor a
	ld [hSCX], a
	jp TradeAnim_Next

TradeAnim_SetupGivemonScroll:
	ld a, $8f
	ld [hWX], a
	ld a, $88
	ld [hSCX], a
	ld a, $50
	ld [hWY], a
	jp TradeAnim_Next

TradeAnim_DoGivemonScroll:
	ld a, [hWX]
	cp $7
	jr z, .done
	sub $4
	ld [hWX], a
	ld a, [hSCX]
	sub $4
	ld [hSCX], a
	ret

.done
	ld a, $7
	ld [hWX], a
	xor a
	ld [hSCX], a
	jp TradeAnim_Next

TradeAnim_1d:
	ld a, $7
	ld [hWX], a
	ld a, $50
	ld [hWY], a
	jp TradeAnim_Next

TradeAnim_1e:
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	jp TradeAnim_Next

TradeAnim_ScrollOutRight:
	call WaitTop
	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	call ApplyTilemapInVBlank
	ld a, $7
	ld [hWX], a
	xor a
	ld [hWY], a
	call DelayFrame
	call WaitTop
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	call ClearTileMap
	jp NextTradeAnim

TradeAnim_ScrollOutRight2:
	ld a, [hWX]
	cp $a1
	jr nc, .done
	add $4
	ld [hWX], a
	ret

.done
	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	call ApplyTilemapInVBlank
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	jp TradeAnim_Next

TradeAnim_ShowGivemonData:
	call ShowPlayerTrademonDetails
	ld a, [wPlayerTrademonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wPlayerTrademonDVs]
	ld [TempMonDVs], a
	ld a, [wPlayerTrademonDVs + 1]
	ld [TempMonDVs + 1], a
	ld b, SCGB_1A
	predef GetSGBLayout
	ld a, %11100100
	call DmgToCgbBGPals
	call TradeAnim_ShowGivemonFrontpic

	ld a, [wPlayerTrademonSpecies]
	call _PlayCry
	jp TradeAnim_Next

TradeAnim_ShowGetmonData:
	call ShowOTTrademonDetails
	ld a, [wOTTrademonSpecies]
	ld [wCurPartySpecies], a
	ld a, [wOTTrademonDVs]
	ld [TempMonDVs], a
	ld a, [wOTTrademonDVs + 1]
	ld [TempMonDVs + 1], a
	ld b, SCGB_1A
	predef GetSGBLayout
	ld a, %11100100
	call DmgToCgbBGPals
	call TradeAnim_ShowGetmonFrontpic
	jp TradeAnim_Next

TradeAnim_AnimateFrontpic:
	callba AnimateTrademonFrontpic
	jp TradeAnim_Next

TradeAnim_GetFrontpic:
	push de
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	pop de
	predef_jump GetFrontpic

TradeAnim_GetNickname:
	push de
	ld [wd265], a
	call GetPokemonName
	ld hl, wStringBuffer1
	pop de
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

TradeAnim_ShowGivemonFrontpic:
	ld de, VTiles0
	jr TradeAnim_ShowFrontpic

TradeAnim_ShowGetmonFrontpic:
	ld de, VTiles0 tile $31
TradeAnim_ShowFrontpic:
	call DelayFrame
	ld hl, VTiles2
	lb bc, 10, $31
	call Request2bpp
	call WaitTop
	call ShowTrademonDetails_ClearTileMap
	hlcoord 7, 2
	xor a
	ld [hGraphicStartTile], a
	lb bc, 7, 7
	predef PlaceGraphic
	jp ApplyTilemapInVBlank

TraideAnim_Wait80:
	ld c, 80
	call DelayFrames
	jp TradeAnim_Next

TraideAnim_Wait40:
	ld c, 40
	call DelayFrames
	jp TradeAnim_Next

TradeAnim_Wait96:
	ld c, 96
	call DelayFrames
	jp TradeAnim_Next

TradeAnim_Wait80IfOTEgg:
	call IsOTTrademonEgg
	ret nz
	ld c, 80
	jp DelayFrames

TradeAnim_Wait180IfOTEgg:
	call IsOTTrademonEgg
	ret nz
	ld c, 180
	jp DelayFrames

IsOTTrademonEgg:
	call TradeAnim_Next
	ld a, [wOTTrademonSpecies]
	cp EGG
	ret

ShowPlayerTrademonDetails:
	ld de, wPlayerTrademonSpecies
	ld a, [de]
	cp EGG
	jr z, ShowTrademonDetails_SetUpEggUI
	call ShowTrademonDetails_SetUpUI
	ld de, wPlayerTrademonSpecies
	call ShowTrademonDetails_PrintSpeciesNo
	ld de, wPlayerTrademonSpeciesName
	call ShowTrademonDetails_PrintSpeciesName
	ld a, [wPlayerTrademonCaughtData]
	ld de, wPlayerTrademonOTName
	call ShowTrademonDetails_PrintOTName
	ld de, wPlayerScreens
	call ShowTrademonDetails_PrintOTID
	jp ShowTrademonDetails_Finish

ShowOTTrademonDetails:
	ld de, wOTTrademonSpecies
	ld a, [de]
	cp EGG
	jr z, ShowTrademonDetails_SetUpEggUI
	call ShowTrademonDetails_SetUpUI
	ld de, wOTTrademonSpecies
	call ShowTrademonDetails_PrintSpeciesNo
	ld de, wOTTrademonSpeciesName
	call ShowTrademonDetails_PrintSpeciesName
	ld a, [wOTTrademonCaughtData]
	ld de, wOTTrademonOTName
	call ShowTrademonDetails_PrintOTName
	ld de, wOTTrademonID
	call ShowTrademonDetails_PrintOTID
	jp ShowTrademonDetails_Finish

ShowTrademonDetails_SetUpUI:
	call WaitTop
	call ShowTrademonDetails_ClearTileMap
	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	hlcoord 3, 0
	lb bc, 6, 13
	call TextBox
	hlcoord 4, 0
	ld de, .UI
	jp PlaceText

.UI
	text "─── №."
	next ""
	next "OT/"
	next "<ID>№."
	done

ShowTrademonDetails_SetUpEggUI:
	call WaitTop
	call ShowTrademonDetails_ClearTileMap
	ld a, VBGMap1 / $100
	ld [hBGMapAddress + 1], a
	hlcoord 3, 0
	lb bc, 6, 13
	call TextBox
	hlcoord 4, 2
	ld de, .EggUI
	call PlaceText
	jp ShowTrademonDetails_Finish

.EggUI
	text "EGG"
	next "OT/?????"
	next "<ID>№.?????"
	done

ShowTrademonDetails_Finish:
	call ApplyTilemapInVBlank
	call WaitTop
	ld a, VBGMap0 / $100
	ld [hBGMapAddress + 1], a
	ret

ShowTrademonDetails_PrintSpeciesNo:
	hlcoord 10, 0
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	ld [hl], " "
	ret

ShowTrademonDetails_PrintSpeciesName:
	hlcoord 4, 2
	jp PlaceString

ShowTrademonDetails_PrintOTName:
	cp 3
	jr c, .gender_okay
	xor a

.gender_okay
	push af
	hlcoord 7, 4
	call PlaceString
	inc bc
	pop af
	ld hl, .GenderCharacters
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [bc], a
	ret

.GenderCharacters
	db " "
	db "♂"
	db "♀"

ShowTrademonDetails_PrintOTID:
	hlcoord 7, 6
	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	jp PrintNum

TradeAnim_RockingBall:
	depixel 10, 11, 4, 0
	ld a, SPRITE_ANIM_INDEX_0E
	call _InitSpriteAnimStruct
	call TradeAnim_Next
	ld a, $20
	ld [wcf64], a
	ret

TradeAnim_DropBall:
	depixel 10, 11, 4, 0
	ld a, SPRITE_ANIM_INDEX_0E
	call _InitSpriteAnimStruct
	ld hl, $b
	add hl, bc
	ld [hl], $1
	ld hl, $7
	add hl, bc
	ld [hl], $dc
	call TradeAnim_Next
	ld a, $38
	ld [wcf64], a
	ret

TradeAnim_Poof:
	depixel 10, 11, 4, 0
	ld a, SPRITE_ANIM_INDEX_0F
	call _InitSpriteAnimStruct
	call TradeAnim_Next
	ld a, $10
	ld [wcf64], a
	ld de, SFX_BALL_POOF
	jp PlaySFX

TradeAnim_BulgeThroughTube:
	ld a, %11100100 ; 3,2,1,0
	call DmgToCgbObjPal0
	depixel 5, 11
	ld a, SPRITE_ANIM_INDEX_10
	call _InitSpriteAnimStruct
	call TradeAnim_Next
	ld a, $40
	ld [wcf64], a
	ret

Function29676:
	ld hl, SPRITEANIMSTRUCT_0B
	add hl, bc
	ld a, [hl]
	jumptable

Jumptable_29686:
	dw Function2969a
	dw Function296a4
	dw Function296af
	dw Function296bd
	dw Function296cf
	dw Function296dd
	dw Function296f2

Function29694:
	ld hl, SPRITEANIMSTRUCT_0B
	add hl, bc
	inc [hl]
	ret

Function2969a:
	call Function29694
	ld hl, $c
	add hl, bc
	ld [hl], $80
	ret

Function296a4:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	call Function29694

Function296af:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $94
	jr nc, .asm_296ba
	inc [hl]
	ret
.asm_296ba
	call Function29694

Function296bd:
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $4c
	jr nc, .asm_296c8
	inc [hl]
	ret
.asm_296c8
	ld h, b
	ld l, c
	ld [hl], $0
	ret

Function296cf:
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $2c
	jr z, .asm_296da
	dec [hl]
	ret
.asm_296da
	call Function29694

Function296dd:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_296e8
	dec [hl]
	ret
.asm_296e8
	call Function29694
	ld hl, $c
	add hl, bc
	ld [hl], $80
	ret

Function296f2:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	ld [bc], a
	ret

TradeAnim_SentToOTText:
	ld a, [wLinkMode]
	cp LINK_TIMECAPSULE
	jr z, .time_capsule
	ld c, 189
	call DelayFrames
	ld hl, .was_sent_to
	call PrintText
	ld c, 128
	call DelayFrames
	jr .delay_next

.time_capsule
	ld hl, .was_sent_to
	call PrintText
.delay_next
	call TradeAnim_Delay80
	jp TradeAnim_Next

.was_sent_to
	; was sent to @ .
	text_jump UnknownText_0x1bc6e9

TradeAnim_OTBidsFarewell:
	ld hl, .bids_farewell_to
	call PrintText
	call TradeAnim_Delay80
	ld hl, .dot
	call PrintText
	call TradeAnim_Delay80
	jp TradeAnim_Next

.bids_farewell_to
	; bids farewell to
	text_jump UnknownText_0x1bc703

.dot
	; .
	text_jump UnknownText_0x1bc719

TradeAnim_TakeCareOfText:
	call WaitTop
	hlcoord 0, 10
	ld bc, 8 * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call ApplyTilemapInVBlank
	ld hl, .take_good_care_of_mon
	call PrintText
	call TradeAnim_Delay80
	jp TradeAnim_Next

.take_good_care_of_mon
	; Take good care of @ .
	text_jump UnknownText_0x1bc71f

TradeAnim_OTSendsText1:
	ld hl, .for_players_mon
	call PrintText
	call TradeAnim_Delay80
	ld hl, .other_sends_mon
	call PrintText
	call TradeAnim_Delay80
	ld c, 14
	call DelayFrames
	jp TradeAnim_Next

.for_players_mon
	; For @ 's @ ,
	text_jump UnknownText_0x1bc739

.other_sends_mon
	; sends @ .
	text_jump UnknownText_0x1bc74c

TradeAnim_OTSendsText2:
	ld hl, .will_trade_mon
	call PrintText
	call TradeAnim_Delay80
	ld hl, .for_others_mon
	call PrintText
	call TradeAnim_Delay80
	ld c, 14
	call DelayFrames
	jp TradeAnim_Next

.will_trade_mon
	; will trade @ @
	text_jump UnknownText_0x1bc75e

.for_others_mon
	; for @ 's @ .
	text_jump UnknownText_0x1bc774

TradeAnim_Delay80:
	ld c, 80
	jp DelayFrames

ShowTrademonDetails_ClearTileMap:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " "
	jp ByteFill

TradeAnim_CopyBox:
; copy b-by-c box from de to hl
.row
	push bc
	push hl
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

TradeAnim_NormalDMGPals:
	ld a, %11100100
	call DmgToCgbObjPal0
	ld a, %11100100
	jp DmgToCgbBGPals

LinkTradeAnim_LoadTradePlayerNames:
	push de
	ld de, wLinkPlayer1Name
	ld bc, NAME_LENGTH
	rst CopyBytes
	pop hl
	ld de, wLinkPlayer2Name
	ld bc, NAME_LENGTH
	rst CopyBytes
	ret

LinkTradeAnim_LoadTradeMonSpecies:
	ld a, [hl]
	ld [wLinkTradeSendmonSpecies], a
	ld a, [de]
	ld [wLinkTradeGetmonSpecies], a
	ret

TradeAnim_TubeFlashBGPals:
	ld a, [wcf65]
	and $7
	ret nz
	ld a, [rBGP]
	xor %00111100
	jp DmgToCgbBGPals

LoadTradeBallAndCableGFX:
	call DelayFrame
	ld de, TradeBallGFX
	ld hl, VTiles0 tile $62
	lb bc, BANK(TradeBallGFX), $6
	call Request2bpp
	ld de, TradePoofGFX
	ld hl, VTiles0 tile $68
	lb bc, BANK(TradePoofGFX), $c
	call Request2bpp
	ld de, TradeCableGFX
	ld hl, VTiles0 tile $74
	lb bc, BANK(TradeCableGFX), $4
LoadTradeAnimationGFX_SetAnimDictTo62:
	call Request2bpp
	xor a
	ld hl, wSpriteAnimDict
	ld [hli], a
	ld [hl], $62
	ret

LoadTradeBubbleGFX:
	call DelayFrame
	ld e, $3
	callba LoadPokemonIcon
	ld de, TradeBubbleGFX
	ld hl, VTiles0 tile $72
	lb bc, BANK(TradeBubbleGFX), $4
	jr LoadTradeAnimationGFX_SetAnimDictTo62

TradeAnim_WaitAnim:
TradeAnim_WaitAnim2:
	ld hl, wcf64
	ld a, [hl]
	and a
	jp z, TradeAnim_Next
	dec [hl]
	ret

TradeGameBoyTilemap:
; 6x8
	db $31, $32, $32, $32, $32, $33
	db $34, $35, $36, $36, $37, $38
	db $34, $39, $3a, $3a, $3b, $38
	db $3c, $3d, $3e, $3e, $3f, $40
	db $41, $42, $43, $43, $44, $45
	db $46, $47, $43, $48, $49, $4a
	db $41, $43, $4b, $4c, $4d, $4e
	db $4f, $50, $50, $50, $51, $52

Tilemap_298f7:
; 12x3
	db $43, $55, $56, $53, $53, $53, $53, $53, $53, $53, $53, $53
	db $43, $57, $58, $54, $54, $54, $54, $54, $54, $54, $54, $54
	db $43, $59, $5a, $43, $43, $43, $43, $43, $43, $43, $43, $43

TradeArrowGFX:  INCBIN "gfx/trade/arrow.2bpp"
TradeCableGFX:  INCBIN "gfx/trade/cable.2bpp"
TradeBubbleGFX: INCBIN "gfx/trade/bubble.2bpp"
TradeGameBoyLZ: INCBIN "gfx/trade/game_boy.2bpp.lz"
TradeBallGFX:   INCBIN "gfx/trade/ball.2bpp"
TradePoofGFX:   INCBIN "gfx/trade/poof.2bpp"
