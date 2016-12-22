	const_def
	const BGSQUARE_SIX
	const BGSQUARE_FOUR
	const BGSQUARE_TWO
	const BGSQUARE_SEVEN
	const BGSQUARE_FIVE
	const BGSQUARE_THREE

; BG effects for use in battle animations.

ExecuteBGEffects:
	ld hl, ActiveBGEffects
	ld e, 5
.loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call DoBattleBGEffectFunction
	pop de
	pop hl
.next
	ld bc, 4
	add hl, bc
	dec e
	jr nz, .loop
	ret

QueueBGEffect:
	ld hl, ActiveBGEffects
	ld e, 5
.loop
	ld a, [hl]
	and a
	jr z, .load
	ld bc, 4
	add hl, bc
	dec e
	jr nz, .loop
	scf
	ret

.load
	ld c, l
	ld b, h
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld a, [wBattleAnimTemp0]
	ld [hli], a
	ld a, [wBattleAnimTemp1]
	ld [hli], a
	ld a, [wBattleAnimTemp2]
	ld [hli], a
	ld a, [wBattleAnimTemp3]
	ld [hl], a
	ret

BattleBGEffect_End:
EndBattleBGEffect:
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld [hl], 0
	ret

DoBattleBGEffectFunction:
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld a, [hl]
	jumptable

BattleBGEffects:
	dw BattleBGEffect_End
	dw BattleBGEffect_FlashInverted
	dw BattleBGEffect_FlashWhite
	dw BattleBGEffect_WhiteHues
	dw BattleBGEffect_BlackHues
	dw BattleBGEffect_AlternateHues
	dw BattleBGEffect_06
	dw BattleBGEffect_07
	dw BattleBGEffect_08
	dw BattleBGEffect_HideMon
	dw BattleBGEffect_ShowMon
	dw BattleBGEffect_EnterMon
	dw BattleBGEffect_ReturnMon
	dw BattleBGEffect_Surf
	dw BattleBGEffect_Whirlpool
	dw BattleBGEffect_Teleport
	dw BattleBGEffect_NightShade
	dw BattleBGEffect_FeetFollow
	dw BattleBGEffect_HeadFollow
	dw BattleBGEffect_DoubleTeam
	dw BattleBGEffect_AcidArmor
	dw BattleBGEffect_RapidFlash
	dw BattleBGEffect_16
	dw BattleBGEffect_17
	dw BattleBGEffect_18
	dw BattleBGEffect_19
	dw BattleBGEffect_1a
	dw BattleBGEffect_1b
	dw BattleBGEffect_1c
	dw BattleBGEffect_1d
	dw BattleBGEffect_1e
	dw BattleBGEffect_1f
	dw BattleBGEffect_20
	dw BattleBGEffect_21
	dw BattleBGEffect_BounceDown
	dw BattleBGEffect_Dig
	dw BattleBGEffect_Tackle
	dw BattleBGEffect_25
	dw BattleBGEffect_26
	dw BattleBGEffect_27
	dw BattleBGEffect_28
	dw BattleBGEffect_Psychic
	dw BattleBGEffect_2a
	dw BattleBGEffect_2b
	dw BattleBGEffect_2c
	dw BattleBGEffect_2d
	dw BattleBGEffect_2e
	dw BattleBGEffect_2f
	dw BattleBGEffect_30
	dw BattleBGEffect_31
	dw BattleAnim_ResetLCDStatCustom
	dw BattleBGEffect_VibrateMon
	dw BattleBGEffect_WobbleMon
	dw BattleBGEffect_35
	dw BattleBGEffect_SlideInMon
	dw BattleBGEffect_SlideOutMon

BattleBGEffects_AnonJumptable:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	jp Jumptable

BattleBGEffects_IncrementJumptable:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleBGEffect_FlashInverted:
	ld de, .inverted
	jr BattleBGEffect_FlashContinue

.inverted
	db %11100100 ; 3210
	db %00011011 ; 0123

BattleBGEffect_FlashWhite:
	ld de, .white
	jr BattleBGEffect_FlashContinue

.white
	db %11100100 ; 3210
	db %00000000 ; 0000

BattleBGEffect_FlashContinue:
; current timer, flash duration, number of flashes
	ld a, $1
	ld [wBattleAnimTemp0], a
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .init
	dec [hl]
	ret

.init
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .apply_pal
	jp EndBattleBGEffect

.apply_pal
	dec a
	ld [hl], a
	and 1
	ld l, a
	ld h, 0
	add hl, de
	ld a, [hl]
	ld [wBGP], a
	ret

BattleBGEffect_WhiteHues:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	jp c, EndBattleBGEffect
	ld [wBGP], a
	ret

.Pals
	db %11100100
	db %11100000
	db %11010000
	db -1


BattleBGEffect_BlackHues:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	jp c, EndBattleBGEffect
	ld [wBGP], a
	ret

.Pals
	db %11100100
	db %11110100
	db %11111000
	db -1


BattleBGEffect_AlternateHues:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	jp c, EndBattleBGEffect
	ld [wBGP], a
	ld [wOBP1], a
	ret

.Pals
	db %11100100
	db %11111000
	db %11111100
	db %11111000
	db %11100100
	db %10010000
	db %01000000
	db %10010000
	db -2

BattleBGEffect_06:
	ld de, .PalsCGB
	call BattleBGEffect_GetNthDMGPal
	ld [wOBP0], a
	ret

.PalsCGB
	db %11100100
	db %10010000
	db -2

BattleBGEffect_07:
	ld de, .PalsCGB
	call BattleBGEffect_GetNthDMGPal
	ld [wOBP0], a
	ret

.PalsCGB
	db %11100100
	db %11011000
	db -2

BattleBGEffect_08:
	ld de, .Pals
	call BattleBGEffect_GetNthDMGPal
	ld [wBGP], a
	ret

.Pals
	db %00011011
	db %01100011
	db %10000111
	db -2

BattleBGEffect_HideMon:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_side
	hlcoord 12, 0
	lb bc, 7, 7
	jr .got_pointer

.player_side
	hlcoord 2, 6
	lb bc, 6, 6
.got_pointer
	call ClearBox
	pop bc
	xor a
	ld [hBGMapHalf], a
	ld a, $1
	ld [hBGMapMode], a
	ret

DisableBGUpdates_EndBattleBGEffect:
	xor a
	ld [hBGMapMode], a
	jp EndBattleBGEffect

BattleBGEffect_ShowMon:
	call BGEffect_CheckFlyDigStatus
	jr z, .not_flying
	jp EndBattleBGEffect

.not_flying
	call BGEffect_CheckBattleTurn
	jr nz, .player_side
	ld de, .EnemyData
	jr .got_pointer

.player_side
	ld de, .PlayerData
.got_pointer
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	jp BattleBGEffect_RunPicResizeScript

.PlayerData
	db  0, $31, 0
	db -1
.EnemyData
	db  3, $00, 3
	db -1

BattleBGEffect_FeetFollow:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	call BGEffect_CheckFlyDigStatus
	jr z, .not_flying_digging
	ld hl, wNumActiveBattleAnims
	inc [hl]
	jp EndBattleBGEffect

.not_flying_digging
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	ld a, ANIM_OBJ_PLAYERFEETFOLLOW
	ld [wBattleAnimTemp0], a
	ld a, 16 * 8 + 4
	jr .okay

.player_turn
	ld a, ANIM_OBJ_ENEMYFEETFOLLOW
	ld [wBattleAnimTemp0], a
	ld a, 6 * 8
.okay
	ld [wBattleAnimTemp1], a
	ld a, 8 * 8
	ld [wBattleAnimTemp2], a
	xor a
	ld [wBattleAnimTemp3], a
	call _QueueBattleAnimation
	pop bc
	ret

.one
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn_2
	hlcoord 12, 6
	lb bc, 1, 7
	jr .okay2

.player_turn_2
	hlcoord 2, 6
	lb bc, 1, 6
.okay2
	call ClearBox
	ld a, $1
	ld [hBGMapMode], a
	pop bc
	ret

BattleBGEffect_HeadFollow:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	call BGEffect_CheckFlyDigStatus
	jr z, .not_flying_digging
	ld hl, wNumActiveBattleAnims
	inc [hl]
	jp EndBattleBGEffect

.not_flying_digging
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	ld a, ANIM_OBJ_BA
	ld [wBattleAnimTemp0], a
	ld a, 16 * 8 + 4
	jr .okay

.player_turn
	ld a, ANIM_OBJ_BB
	ld [wBattleAnimTemp0], a
	ld a, 6 * 8
.okay
	ld [wBattleAnimTemp1], a
	ld a, 8 * 8
	ld [wBattleAnimTemp2], a
	xor a
	ld [wBattleAnimTemp3], a
	call _QueueBattleAnimation
	pop bc
	ret

.one
	call BattleBGEffects_IncrementJumptable
	push bc
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn_2
	hlcoord 12, 5
	lb bc, 2, 7
	jr .okay2

.player_turn_2
	hlcoord 2, 6
	lb bc, 2, 6
.okay2
	call ClearBox
	ld a, $1
	ld [hBGMapMode], a
	pop bc
	ret

_QueueBattleAnimation:
	jpba QueueBattleAnimation

BattleBGEffect_27:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw .four

.zero
	call BattleBGEffects_IncrementJumptable
	call BGEffect_CheckBattleTurn
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	ld a, $8
	jr z, .okay
	ld a, $9
.okay
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], a
	ret

.one
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	jr z, .user_2
	hlcoord 0, 6
	lb de, 8, 6
.row1
	push de
	push hl
.col1
	inc hl
	ld a, [hld]
	ld [hli], a
	dec d
	jr nz, .col1
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec e
	jr nz, .row1
	jr .okay2

.user_2
	hlcoord 19, 0
	lb de, 8, 7
.row2
	push de
	push hl
.col2
	dec hl
	ld a, [hli]
	ld [hld], a
	dec d
	jr nz, .col2
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec e
	jr nz, .row2
.okay2
	xor a
	ld [hBGMapHalf], a
	inc a
	ld [hBGMapMode], a
	call BattleBGEffects_IncrementJumptable
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	dec [hl]
	ret

.four
	xor a
	ld [hBGMapMode], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, EndBattleBGEffect
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], $1
	ret

BattleBGEffect_EnterMon:
	call BGEffect_CheckBattleTurn
	ld de, .EnemyData
	jr z, .gotData
	ld de, .PlayerData
.gotData
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	jp BattleBGEffect_RunPicResizeScript

.PlayerData
	db  2, $31, 2
	db  1, $31, 1
	db  0, $31, 0
	db -1
.EnemyData
	db  5, $00, 5
	db  4, $00, 4
	db  3, $00, 3
	db -1
; c83a8

BattleBGEffect_ReturnMon: ; c83a8 (32:43a8)
	call BGEffect_CheckBattleTurn
	ld de, .EnemyData
	jr z, .gotData
	ld de, .PlayerData
.gotData
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	jp BattleBGEffect_RunPicResizeScript

.PlayerData
	db  0, $31, 0
	db -2, $66, 0
	db  1, $31, 1
	db -2, $44, 1
	db  2, $31, 2
	db -2, $22, 2
	db -3, $00, 0
	db -1
.EnemyData
	db  3, $00, 3
	db -2, $77, 3
	db  4, $00, 4
	db -2, $55, 4
	db  5, $00, 5
	db -2, $33, 5
	db -3, $00, 0
	db -1

BattleBGEffect_SlideInMon:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	xor $1
	ld [hl], a
	ret z ; delay an extra frame
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	cp 8
	;jr z, .waitOnceMore
	;cp 9
	jr z, .end
	push bc
	ld e, a
	ld d, 0
	inc a
	ld [hl], a
	coord hl, 0, 6
	add hl, de
	ld d, 7 * 7 + 6 * 5
	ld e, a
	ld bc, SCREEN_WIDTH
.columnLoop
	push hl
	push de
	ld e, 6
.placeTileLoop
	ld a, d
	cp 7 * 7
	jr nc, .okay
	ld a, " "
.okay
	ld [hl], a
	add hl, bc
	inc d
	dec e
	jr nz, .placeTileLoop
	pop de
	pop hl
	dec hl
	ld a, d
	sub 6
	ld d, a
	dec e
	jr nz, .columnLoop
	pop bc
.wait
	xor a
	ld [hBGMapHalf], a
	inc a
	ld [hBGMapMode], a
	ret
.end
	xor a
	ld [hBGMapMode], a
	jp EndBattleBGEffect
.waitOnceMore
	inc [hl]
	jr .wait

BattleBGEffect_SlideOutMon:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	xor $1
	ld [hl], a
	ret z ; delay an extra frame
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp 8
	;jr z, .wait
	;cp 9
	jr z, .end
	coord hl, 0, 6
	push bc
	ld b, 6
	ld de, SCREEN_WIDTH
.loop
	push hl
	ld c, 8
.loop2
	inc hl
	ld a, [hld]
	ld [hli], a
	dec c
	jr nz, .loop2
	pop hl

	add hl, de
	dec b
	jr nz, .loop
	pop bc
.wait
	xor a
	ld [hBGMapHalf], a
	inc a
	ld [hBGMapMode], a
	ret
.end
	xor a
	ld [hBGMapMode], a
	jp EndBattleBGEffect

BattleBGEffect_RunPicResizeScript:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffects_IncrementJumptable
	dw BattleBGEffects_IncrementJumptable
	dw .restart
	dw DisableBGUpdates_EndBattleBGEffect

.zero
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld e, [hl]
	ld d, $0
	inc [hl]
	ld a, [wBattleAnimTemp1]
	ld l, a
	ld a, [wBattleAnimTemp2]
	ld h, a
	add hl, de
	add hl, de
	add hl, de
	ld a, [hl]
	cp -1
	jp z, DisableBGUpdates_EndBattleBGEffect
	cp -2
	jr z, .clear
	cp -3
	jr z, .skip
	call .PlaceGraphic
.skip
	call BattleBGEffects_IncrementJumptable
	ld a, $1
	ld [hBGMapMode], a
	ret

.clear
	call .ClearBox
	jr .zero

.restart
	xor a
	ld [hBGMapMode], a
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], $0
	ret

.ClearBox
; get dims
	push bc
	inc hl
	ld a, [hli]
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	ld b, a
; get coords
	ld e, [hl]
	ld d, 0
	ld hl, .Coords
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ClearBox
	pop bc
	ret

.PlaceGraphic
; get dims
	push bc
	push hl
	ld e, [hl]
	ld d, 0
	ld hl, .BGSquares
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, a
	and $f
	ld c, a
	ld a, b
	swap a
	and $f
	ld b, a
; store pointer
	ld e, [hl]
	inc hl
	ld d, [hl]
; get byte
	pop hl
	inc hl
	ld a, [hli]
	ld [wBattleAnimTemp0], a
; get coord
	push de
	ld e, [hl]
	ld d, 0
	ld hl, .Coords
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
; fill box
.row
	push bc
	push hl
	ld a, [wBattleAnimTemp0]
	ld b, a
.col
	ld a, [de]
	add b
	ld [hli], a
	inc de
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	pop bc
	ret

.Coords
	dwcoord  2,  6
	dwcoord  3,  8
	dwcoord  4, 10
	dwcoord 12,  0
	dwcoord 13,  2
	dwcoord 14,  4

.BGSquares
bgsquare: MACRO
	dn \1,\2
	dw \3
endm

	bgsquare 6, 6, .SixBySix
	bgsquare 4, 4, .FourByFour
	bgsquare 2, 2, .TwoByTwo
	bgsquare 7, 7, .SevenBySeven
	bgsquare 5, 5, .FiveByFive
	bgsquare 3, 3, .ThreeByThree

.SixBySix
	db $00, $06, $0c, $12, $18, $1e
	db $01, $07, $0d, $13, $19, $1f
	db $02, $08, $0e, $14, $1a, $20
	db $03, $09, $0f, $15, $1b, $21
	db $04, $0a, $10, $16, $1c, $22
	db $05, $0b, $11, $17, $1d, $23

.FourByFour
	db $00, $0c, $12, $1e
	db $02, $0e, $14, $20
	db $03, $0f, $15, $21
	db $05, $11, $17, $23

.TwoByTwo
	db $00, $1e
	db $05, $23

.SevenBySeven
	db $00, $07, $0e, $15, $1c, $23, $2a
	db $01, $08, $0f, $16, $1d, $24, $2b
	db $02, $09, $10, $17, $1e, $25, $2c
	db $03, $0a, $11, $18, $1f, $26, $2d
	db $04, $0b, $12, $19, $20, $27, $2e
	db $05, $0c, $13, $1a, $21, $28, $2f
	db $06, $0d, $14, $1b, $22, $29, $30

.FiveByFive
	db $00, $07, $15, $23, $2a
	db $01, $08, $16, $24, $2b
	db $03, $0a, $18, $26, $2d
	db $05, $0c, $1a, $28, $2f
	db $06, $0d, $1b, $29, $30

.ThreeByThree
	db $00, $15, $2a
	db $03, $18, $2d
	db $06, $1b, $30

BattleBGEffect_Surf:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	lb de, 2, 2
	call InitSurfWaves

.one
	ld a, [wLCDCPointer]
	and a
	ret z
	push bc
	call .RotatewSurfWaveBGEffect
	pop bc
	ret

.RotatewSurfWaveBGEffect
	ld hl, wSurfWaveBGEffect
	ld de, wSurfWaveBGEffect + 1
	ld c, wSurfWaveBGEffectEnd - wSurfWaveBGEffect - 1
	ld a, [hl]
	push af
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [hl], a
	ld de, LYOverridesBackup
	ld hl, wSurfWaveBGEffect
	ld bc, $0
.loop2
	ld a, [hLYOverridesStart]
	cp e
	jr nc, .load_zero
	push hl
	add hl, bc
	ld a, [hl]
	pop hl
	jr .okay

.load_zero
	xor a
.okay
	ld [de], a
	ld a, c
	inc a
	and $3f
	ld c, a
	inc de
	ld a, e
	cp $5f
	jr c, .loop2
	ret

BattleBGEffect_Whirlpool:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffect_WavyScreenFX
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	ld [wLCDCPointer], a
	xor a
	ld [hLYOverridesStart], a
	ld a, $5e
	ld [hLYOverridesEnd], a
	lb de, 2, 2
	jp Functionc8f2e

BattleBGEffect_30:
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	jp EndBattleBGEffect

BattleBGEffect_31:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld e, a
	add $4
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and $f0
	swap a
	xor $ff
	add $4
	ld d, a
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTemp0], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, .done
	inc [hl]
	inc [hl]
	jp Functionc8f9a

.done
	call BattleBGEffects_ClearLYOverrides
	jp EndBattleBGEffect

BattleBGEffect_Psychic:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	ld [wLCDCPointer], a
	xor a
	ld [hLYOverridesStart], a
	ld a, $5f
	ld [hLYOverridesEnd], a
	lb de, 6, 5
	call Functionc8f2e
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $3
	ret nz
	jp BattleBGEffect_WavyScreenFX

BattleBGEffect_Teleport:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffect_WavyScreenFX
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	lb de, 6, 5
	jp Functionc8f2e

BattleBGEffect_NightShade:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw BattleBGEffect_WavyScreenFX
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld e, [hl]
	ld d, 2
	jp Functionc8f2e

BattleBGEffect_DoubleTeam:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $10
	jp nc, BattleBGEffects_IncrementJumptable
	inc [hl]
	jp .UpdateLYOverrides

.three
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $ff
	jp z, BattleBGEffects_IncrementJumptable
	dec [hl]
	jp .UpdateLYOverrides

.two
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld d, $2
	call Sine
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	add [hl]
	call .UpdateLYOverrides
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	add $4
	ld [hl], a
.four
	ret

.UpdateLYOverrides
	ld e, a
	xor $ff
	inc a
	ld d, a
	ld h, LYOverridesBackup / $100
	ld a, [hLYOverridesStart]
	ld l, a
	ld a, [hLYOverridesEnd]
	sub l
	srl a
	push af
.loop
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	dec a
	jr nz, .loop
	pop af
	ret nc
	ld [hl], e
	ret

BattleBGEffect_AcidArmor:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld e, [hl]
	ld d, 2
	call Functionc8f2e
	ld h, $d2
	ld a, [hLYOverridesEnd]
	ld l, a
	ld [hl], $0
	dec l
	ld [hl], $0
	ret

.one
	ld a, [hLYOverridesEnd]
	ld l, a
	ld h, $d2
	ld e, l
	ld d, h
	dec de
.loop
	ld a, [de]
	dec de
	ld [hld], a
	ld a, [hLYOverridesStart]
	cp l
	jr nz, .loop
	ld [hl], $90
	ld a, [hLYOverridesEnd]
	ld l, a
	ld a, [hl]
	cp $1
	jr c, .okay
	cp $90
	jr z, .okay
	ld [hl], $0
.okay
	dec l
	ld a, [hl]
	cp $2
	ret c
	cp $90
	ret z
	ld [hl], $0
	ret

BattleBGEffect_21:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $1
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and $3f
	ld d, a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cp d
	ret nc
	call Functionc901b
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	and $3
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	add [hl]
	ld [hl], a
	ret

BattleBGEffect_Dig:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $2
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
	dec [hl]
	ret

.next
	ld [hl], $10
	call BattleBGEffects_IncrementJumptable
.two
	ld a, [hLYOverridesStart]
	ld l, a
	ld a, [hLYOverridesEnd]
	sub l
	dec a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	cp [hl]
	ret c
	ld a, [hl]
	push af
	and $7
	jr nz, .skip
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	dec [hl]
.skip
	pop af
	call Functionc901b
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	inc [hl]
	inc [hl]
	ret

BattleBGEffect_Tackle:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw Tackle_BGEffect25_2d_one
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	call BGEffect_CheckBattleTurn
	jr nz, .player_side
	ld a, 2
	jr .okay

.player_side
	ld a, -2
.okay
	ld [hl], a
	ret

BattleBGEffect_25:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw Tackle_BGEffect25_2d_one
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms2
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	call BGEffect_CheckBattleTurn
	jr nz, .player_side
	ld a,  2
	jr .okay

.player_side
	ld a, -2
.okay
	ld [hl], a
	ret

Tackle_BGEffect25_2d_one:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp -8
	jr z, .reached_limit
	cp  8
	jr nz, .finish
.reached_limit
	call BattleBGEffects_IncrementJumptable
.finish
	call Functionc88a5
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	add [hl]
	ld [hl], a
	ret

Tackle_BGEffect25_2d_two:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_c8893
	call BattleBGEffects_IncrementJumptable
.asm_c8893
	call Functionc88a5
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	xor $ff
	inc a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	add [hl]
	ld [hl], a
	ret

Functionc88a5:
	push af
	ld a, [FXAnimIDHi] ; FXAnimIDHi
	or a
	jr nz, .not_rollout
	ld a, [FXAnimIDLo] ; FXAnimID
	cp ROLLOUT
	jr z, .rollout
.not_rollout
	pop af
	jp Functionc900b

.rollout
	ld a, [hLYOverridesStart]
	ld d, a
	ld a, [hLYOverridesEnd]
	sub d
	ld d, a
	ld h, LYOverridesBackup / $100
	ld a, [hSCY]
	or a
	jr nz, .skip1
	ld a, [hLYOverridesStart]
	or a
	jr z, .skip2
	dec a
	ld l, a
	ld [hl], $0
	jr .skip2

.skip1
	ld a, [hLYOverridesEnd]
	dec a
	ld l, a
	ld [hl], $0
.skip2
	ld a, [hSCY]
	ld l, a
	ld a, [hLYOverridesStart]
	sub l
	jr nc, .skip3
	xor a
	dec d
.skip3
	ld l, a
	pop af
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

BattleBGEffect_2d:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw BGEffect2d_2f_zero
	dw Tackle_BGEffect25_2d_one
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

BGEffect2d_2f_zero:
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	ld a, -2
	jr .okay

.player_turn
	ld a, 2
.okay
	ld [hl], a
	ret

BattleBGEffect_2f:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw BGEffect2d_2f_zero
	dw Tackle_BGEffect25_2d_one
	dw GenericDummyFunction
	dw Tackle_BGEffect25_2d_two
	dw BattleAnim_ResetLCDStatCustom

BattleBGEffect_26:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld d, $8
	call Sine
	call Functionc900b
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	add $4
	ld [hl], a
	ret

BattleBGEffect_2c:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	xor a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hli], a
	ld [hl], a
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld d, $6
	call Sine
	push af
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld d, $2
	call Sine
	ld e, a
	pop af
	add e
	call Functionc900b
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	add $8
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	add $2
	ld [hl], a
	ret

BattleBGEffect_28:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw .two

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	jp BattleBGEffect_SetLCDStatCustoms1

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $20
	ret nc
	inc [hl]
	ld d, a
	ld e, 4
	jp Functionc8f2e

.two
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, BattleAnim_ResetLCDStatCustom
	dec [hl]
	ld d, a
	ld e, 4
	jp Functionc8f2e

BattleBGEffect_BounceDown:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCY & $ff
	call BattleBGEffect_SetLCDStatCustoms2
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $20
	ret

.one
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	cp $38
	ret nc
	push af
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld d, $10
	call Cosine
	add $10
	ld d, a
	pop af
	add d
	call Functionc901b
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	inc [hl]
	inc [hl]
	ret

BattleBGEffect_2a:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw GenericDummyFunction
	dw .two
	dw .three
	dw GenericDummyFunction
	dw BattleBGEffects_ResetVideoHRAM

.zero
	call BattleBGEffects_IncrementJumptable
	ld a, $e4
	call BattleBGEffects_SetLYOverrides
	ld a, rBGP & $ff ; huh? we're not on DMG...
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld a, [hLYOverridesStart]
	ld l, a
	ld h, $d2
.loop
	ld a, [hLYOverridesEnd]
	cp l
	jr z, .done
	xor a
	ld [hli], a
	jr .loop

.done
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ret

.two
	call .GetLYOverride
	jr c, .SetLYOverridesBackup

.next
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ld a, [hLYOverridesStart]
	inc a
	ld [hLYOverridesStart], a
.finish
	jp BattleBGEffects_IncrementJumptable

.three
	call .GetLYOverride
	jr nc, .finish
	call .SetLYOverridesBackup
	ld a, [hLYOverridesEnd]
	dec a
	ld l, a
	ld [hl], e
	ret

.SetLYOverridesBackup
	ld e, a
	ld a, [hLYOverridesStart]
	ld l, a
	ld a, [hLYOverridesEnd]
	sub l
	srl a
	ld h, LYOverridesBackup / $100
.loop2
	ld [hl], e
	inc hl
	inc hl
	dec a
	jr nz, .loop2
	ret

.GetLYOverride
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
	srl a
	srl a
	srl a
	ld e, a
	ld d, 0
	ld hl, .data
	add hl, de
	ld a, [hl]
	cp $ff
	ret

.data
	db $00, $40, $90, $e4
	db -1

BattleBGEffect_2b:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $40
	ret

.one
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	jp z, BattleAnim_ResetLCDStatCustom
	dec [hl]
	srl a
	srl a
	srl a
	and $f
	ld d, a
	ld e, a
	jp Functionc8f2e

BattleBGEffect_1c:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	jumptable

.Jumptable
	dw .cgb_zero
	dw .cgb_one
	dw .cgb_two

.cgb_zero
	call BattleBGEffects_IncrementJumptable
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ret

.cgb_one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld e, a
	and $7
	ret nz
	ld a, e
	and $18
	sla a
	swap a
	sla a
	ld e, a
	ld d, 0
	call BGEffect_CheckBattleTurn
	jr nz, .player_2
	ld hl, .CGB_DMGEnemyData
	add hl, de
	ld a, [hli]
	push hl
	call BGEffects_LoadBGPal1_OBPal0
	pop hl
	ld a, [hl]
	jp BGEffects_LoadBGPal0_OBPal1

.player_2
	ld hl, .CGB_DMGEnemyData
	add hl, de
	ld a, [hli]
	push hl
	call BGEffects_LoadBGPal0_OBPal1
	pop hl
	ld a, [hl]
	jp BGEffects_LoadBGPal1_OBPal0

.cgb_two
	ld a, $e4
	call BGEffects_LoadBGPal0_OBPal1
	ld a, $e4
	call BGEffects_LoadBGPal1_OBPal0
	jp EndBattleBGEffect

.CGB_DMGEnemyData
	db $e4, $e4
	db $f8, $90
	db $fc, $40
	db $f8, $90
.DMG_PlayerData
	db $e4, $e4
	db $90, $f8
	db $40, $fc
	db $90, $f8

BattleBGEffect_RapidFlash:
	ld de, .FlashPals
	jp BGEffect_RapidCyclePals

.FlashPals
	db $e4, $6c, $fe

BattleBGEffect_16:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $90, $40, $ff

BattleBGEffect_17:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $f8, $fc, $ff

BattleBGEffect_18:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $90, $40, $90, $fe

BattleBGEffect_19:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $f8, $fc, $f8, $fe

BattleBGEffect_1a:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $f8, $fc, $f8, $e4, $90, $40, $90, $fe

BattleBGEffect_1b:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $fc, $e4, $00, $fe

BattleBGEffect_1d:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $e4, $90, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $90, $e4, $ff

BattleBGEffect_1e:
	ld de, .Pals
	jp BGEffect_RapidCyclePals

.Pals
	db $00, $40, $90, $e4, $ff

BattleBGEffect_VibrateMon:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	call BattleBGEffect_SetLCDStatCustoms1
	ld a, [hLYOverridesEnd]
	inc a
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], $1
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $20
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and a
	jp z, BattleAnim_ResetLCDStatCustom
	dec [hl]
	and $1
	ret nz
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	xor $ff
	inc a
	ld [hl], a
	jp Functionc900b

BattleBGEffect_WobbleMon:
	call BattleBGEffects_AnonJumptable
.anon_dw
	dw .zero
	dw .one
	dw BattleAnim_ResetLCDStatCustom

.zero
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_ClearLYOverrides
	ld a, rSCX & $ff
	ld [wLCDCPointer], a
	xor a
	ld [hLYOverridesStart], a
	ld a, $37
	ld [hLYOverridesEnd], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
	ret

.one
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $40
	jp nc, BattleAnim_ResetLCDStatCustom
	ld d, $6
	call Sine
	call Functionc900b
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	add $2
	ld [hl], a
	ret

BattleBGEffect_2e:
	call Functionc8d0b
	jr c, .xor_a
	bit 7, a
	jr z, .okay
.xor_a
	xor a
.okay
	push af
	call DelayFrame
	pop af
	ld [hSCY], a
	xor $ff
	inc a
	ld [AnimObject01_YOffset], a
	ret

BattleBGEffect_1f:
	call Functionc8d0b
	jr nc, .skip
	xor a
.skip
	ld [hSCX], a
	ret

BattleBGEffect_20:
	call Functionc8d0b
	jr nc, .skip
	xor a
.skip
	ld [hSCY], a
	ret

Functionc8d0b:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .okay
	call EndBattleBGEffect
	scf
	ret

.okay
	dec [hl]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .every_16_frames
	dec [hl]
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and a
	ret

.every_16_frames
	ld a, [hl]
	swap a
	or [hl]
	ld [hl], a
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	xor $ff
	inc a
	ld [hl], a
	and a
	ret

BattleBGEffect_35:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	cp $40
	jr nc, .finish
	ld d, $6
	call Sine
	ld [hSCX], a
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	add $2
	ld [hl], a
	ret

.finish
	xor a
	ld [hSCX], a
	ret

BattleBGEffect_GetNthDMGPal:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .zero
	dec [hl]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	jp BattleBGEffect_GetNextDMGPal

.zero
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld [hl], a
	jp BattleBGEffect_GetFirstDMGPal

BGEffect_RapidCyclePals:
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	ld a, [hl]
	jumptable

.Jumptable_CGB
	dw .zero_cgb
	dw .one_cgb
	dw .two_cgb
	dw .three_cgb
	dw .four_cgb

.zero_cgb
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn_cgb
	call BattleBGEffects_IncrementJumptable
	call BattleBGEffects_IncrementJumptable
.player_turn_cgb
	call BattleBGEffects_IncrementJumptable
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	ld [hl], $0
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld [hl], a
	ret

.one_cgb
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .okay_1_cgb
	dec [hl]
	ret

.okay_1_cgb
	ld a, [hl]
	swap a
	or [hl]
	ld [hl], a
	call BattleBGEffect_GetFirstDMGPal
	jr c, .okay_2_cgb
	jp BGEffects_LoadBGPal0_OBPal1

.okay_2_cgb
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	dec [hl]
	ret

.two_cgb
	ld a, $e4
	call BGEffects_LoadBGPal0_OBPal1
	jp EndBattleBGEffect

.three_cgb
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .okay_3_cgb
	dec [hl]
	ret

.okay_3_cgb
	ld a, [hl]
	swap a
	or [hl]
	ld [hl], a
	call BattleBGEffect_GetFirstDMGPal
	jr c, .okay_4_cgb
	jp BGEffects_LoadBGPal1_OBPal0

.okay_4_cgb
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	dec [hl]
	ret

.four_cgb
	ld a, $e4
	call BGEffects_LoadBGPal1_OBPal0
	jp EndBattleBGEffect

BGEffects_LoadBGPal0_OBPal1:
	ld h, a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, h
	push bc
	push af
	ld hl, BGPals ; BGPals
	ld de, UnknBGPals ; wd000
	ld b, a
	ld c, $1
	call CopyPals
	ld hl, OBPals + 8
	ld de, UnknOBPals + 8
	pop af
	ld b, a
	ld c, $1
	call CopyPals
	pop bc
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret

BGEffects_LoadBGPal1_OBPal0:
	ld h, a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, h
	push bc
	push af
	ld hl, BGPals + 8
	ld de, UnknBGPals + 8
	ld b, a
	ld c, $1
	call CopyPals
	ld hl, OBPals ; OBPals
	ld de, UnknOBPals ; wd040
	pop af
	ld b, a
	ld c, $1
	call CopyPals
	pop bc
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret

BattleBGEffect_GetFirstDMGPal:
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld a, [hl]
	inc [hl]
BattleBGEffect_GetNextDMGPal:
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	cp -1
	jr z, .quit
	cp -2
	jr nz, .repeat
	ld a, [de]
	ld hl, BG_EFFECT_STRUCT_03
	add hl, bc
	ld [hl], $0
.repeat
	and a
	ret

.quit
	scf
	ret

BattleBGEffects_ResetVideoHRAM:
	xor a
	ld [wLCDCPointer], a
	ld a, %11100100
	ld [rBGP], a
	ld [wBGP], a
	ld [wOBP1], a
	ld [hLYOverridesStart], a
	ld [hLYOverridesEnd], a
	; fallthrough

BattleBGEffects_ClearLYOverrides:
	xor a
BattleBGEffects_SetLYOverrides:
	ld hl, wLYOverrides ; wListPointer
	ld e, $99
.loop1
	ld [hli], a
	dec e
	jr nz, .loop1
	ld hl, LYOverridesBackup
	ld e, $91
.loop2
	ld [hli], a
	dec e
	jr nz, .loop2
	ret

BattleBGEffect_SetLCDStatCustoms1:
	ld [wLCDCPointer], a
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	lb de, $00, $36
	jr .okay

.player_turn
	lb de, $2f, $5e
.okay
	ld a, d
	ld [hLYOverridesStart], a
	ld a, e
	ld [hLYOverridesEnd], a
	ret

BattleBGEffect_SetLCDStatCustoms2:
	ld [wLCDCPointer], a
	call BGEffect_CheckBattleTurn
	jr nz, .player_turn
	lb de, $00, $36
	jr .okay

.player_turn
	lb de, $2d, $5e
.okay
	ld a, d
	ld [hLYOverridesStart], a
	ld a, e
	ld [hLYOverridesEnd], a
	ret

BattleAnim_ResetLCDStatCustom:
	xor a
	ld [hLYOverridesStart], a
	ld [hLYOverridesEnd], a
	call BattleBGEffects_ClearLYOverrides
	xor a
	ld [wLCDCPointer], a
	jp EndBattleBGEffect

Functionc8f2e:
	push bc
	xor a
	ld [wBattleAnimTemp0], a
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	ld a, $80
	ld [wBattleAnimTemp3], a
	ld bc, LYOverridesBackup
.loop
	ld a, [hLYOverridesStart]
	cp c
	jr nc, .next
	ld a, [hLYOverridesEnd]
	cp c
	jr c, .next
	ld a, [wBattleAnimTemp2]
	ld d, a
	ld a, [wBattleAnimTemp0]
	call Sine
	ld [bc], a
.next
	inc bc
	ld a, [wBattleAnimTemp1]
	ld hl, wBattleAnimTemp0
	add [hl]
	ld [hl], a
	ld hl, wBattleAnimTemp3
	dec [hl]
	jr nz, .loop
	pop bc
	ret

InitSurfWaves:
	push bc
	xor a
	ld [wBattleAnimTemp0], a
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	ld a, $40
	ld [wBattleAnimTemp3], a
	ld bc, wSurfWaveBGEffect
.loop
	ld a, [wBattleAnimTemp2]
	ld d, a
	ld a, [wBattleAnimTemp0]
	call Sine
	ld [bc], a
	inc bc
	ld a, [wBattleAnimTemp1]
	ld hl, wBattleAnimTemp0
	add [hl]
	ld [hl], a
	ld hl, wBattleAnimTemp3
	dec [hl]
	jr nz, .loop
	pop bc
	ret

Functionc8f9a:
	push bc
	ld [wBattleAnimTemp3], a
	ld a, e
	ld [wBattleAnimTemp1], a
	ld a, d
	ld [wBattleAnimTemp2], a
	call .GetLYOverrideBackupAddrOffset
	ld hl, LYOverridesBackup
	add hl, de
	ld c, l
	ld b, h
.loop
	ld a, [wBattleAnimTemp3]
	and a
	jr z, .done
	dec a
	ld [wBattleAnimTemp3], a
	push af
	ld a, [wBattleAnimTemp2]
	ld d, a
	ld a, [wBattleAnimTemp1]
	push hl
	call Sine
	ld e, a
	pop hl
	ld a, [hLYOverridesEnd]
	cp c
	jr c, .skip1
	ld a, e
	ld [bc], a
	inc bc
.skip1
	ld a, [hLYOverridesStart]
	cp l
	jr nc, .skip2
	ld [hl], e
	dec hl
.skip2
	ld a, [wBattleAnimTemp1]
	add $4
	ld [wBattleAnimTemp1], a
	pop af
	jr .loop

.done
	pop bc
	and a
	ret

.GetLYOverrideBackupAddrOffset
	ld a, [hLYOverridesStart]
	ld e, a
	ld a, [wBattleAnimTemp0]
	add e
	ld e, a
	ld d, $0
	ret

BattleBGEffect_WavyScreenFX:
	push bc
	ld a, [hLYOverridesStart]
	ld l, a
	inc a
	ld e, a
	ld h, $d2
	ld d, h
	ld a, [hLYOverridesEnd]
	sub l
	and a
	jr z, .done
	ld c, a
	ld a, [hl]
	push af
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [hl], a
.done
	pop bc
	ret

Functionc900b:
	push af
	ld h, $d2
	ld a, [hLYOverridesStart]
	ld l, a
	ld a, [hLYOverridesEnd]
	sub l
	ld d, a
	pop af
.asm_c9016
	ld [hli], a
	dec d
	jr nz, .asm_c9016
	ret

Functionc901b:
	push af
	ld e, a
	ld a, [hLYOverridesStart]
	ld l, a
	ld a, [hLYOverridesEnd]
	sub l
	sub e
	ld d, a
	ld h, $d2
	ld a, [hLYOverridesStart]
	ld l, a
	ld a, $90
.asm_c902c
	ld [hli], a
	dec e
	jr nz, .asm_c902c
	pop af
	xor $ff
.asm_c9033
	ld [hli], a
	dec d
	jr nz, .asm_c9033
	ret

BGEffect_CheckBattleTurn:
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hBattleTurn]
	and $1
	xor [hl]
	ret

BGEffect_CheckFlyDigStatus:
	ld hl, BG_EFFECT_STRUCT_BATTLE_TURN
	add hl, bc
	ld a, [hBattleTurn]
	and $1
	xor [hl]
	jr nz, .player
	ld a, [wEnemySubStatus3] ; EnemySubStatus3
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret

.player
	ld a, [wPlayerSubStatus3] ; PlayerSubStatus3
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret
