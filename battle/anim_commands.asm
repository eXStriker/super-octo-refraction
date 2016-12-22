; Battle animation command interpreter.

PlayBattleAnim:
	ld hl, rIE
	set LCD_STAT, [hl]

	ld a, [rSVBK]
	push af

	ld a, 5
	ld [rSVBK], a

	call _PlayBattleAnim

	pop af
	ld [rSVBK], a

	ld hl, rIE
	res LCD_STAT, [hl]
	ret

_PlayBattleAnim:
	ld c, 4
	call DelayFrames

	call BattleAnimAssignPals
	call BattleAnimRequestPals
	call DelayFrame

	ld hl, hVBlank
	ld a, [hl]
	push af

	ld [hl], 3
	call BattleAnimRunScript

	pop af
	ld [hVBlank], a

	ld a, $1
	ld [hBGMapMode], a

	ld c, 3
	call DelayFrames

	jp WaitSFX

BattleAnimRunScript:
	ld a, [FXAnimIDHi]
	and a
	jr nz, .hi_byte

	call CheckBattleScene
	jr c, .disabled

	call BattleAnimClearHud
	call RunBattleAnimScript

	call BattleAnimAssignPals
	call BattleAnimRequestPals

	xor a
	ld [hSCX], a
	ld [hSCY], a
	call DelayFrame
	call BattleAnimRestoreHuds

.disabled
	ld a, [wNumHits]
	and a
	jr z, .done

	ld l, a
	ld h, 0
	ld de, ANIM_MISS
	add hl, de
	ld a, l
	ld [FXAnimIDLo], a
	ld a, h
	ld [FXAnimIDHi], a

.hi_byte
	call WaitSFX
	call PlayHitSound
	call RunBattleAnimScript

.done
	jp BattleAnim_RevertPals

RunBattleAnimScript:
	call ClearBattleAnims

.playframe
	call RunBattleAnimCommand
	callba ExecuteBGEffects
	call BattleAnim_UpdateOAM_All
	call RequestLYOverrides
	call BattleAnimRequestPals

	ld a, [hDEDCryFlag]
	and a
	jr nz, .playDED

; Speed up Rollout's animation.
	ld a, [FXAnimIDHi]
	or a
	jr nz, .not_rollout

	ld a, [FXAnimIDLo]
	cp ROLLOUT
	jr nz, .not_rollout

	ld a, $2e
	ld b, 5
	ld de, 4
	ld hl, ActiveBGEffects
.find
	cp [hl]
	jr z, .done
	add hl, de
	dec b
	jr nz, .find

.not_rollout
	call DelayFrame

.done
	ld a, [BattleAnimFlags]
	bit 0, a
	jr z, .playframe

	jp BattleAnim_ClearOAM

.playDED
	ld a, $2
	ld [hRunPicAnim], a
	ld a, [FXAnimIDLo]
	cp ROAR
	jr nz, .playCry
	ld a, [rSVBK]
	push af
	ld a, BANK(wPokeAnimCoord)
	ld [rSVBK], a
	ld a, [hBattleTurn]
	and a
	coord de, 12, 0
	ld bc, VBGMap0 + 12
	jr z, .gotRoarCoords
	coord de, 0, 5
	ld bc, VBGMap0 + 5 * BG_MAP_WIDTH
.gotRoarCoords
	ld hl, wPokeAnimCoord
	ld a, e
	ld [hli], a
	ld [hl], d
	ld hl, wPokeAnimDestination
	ld a, c
	ld [hli], a
	ld [hl], b
	pop af
	ld [rSVBK], a
.playCry
	ld a, [hDEDCryFlag]
	call _PlayCry
	xor a
	ld [hRunPicAnim], a
	jr .done

RunOneFrameOfGrowlOrRoarAnim:
	call RunBattleAnimCommand
	callba ExecuteBGEffects
	call BattleAnim_UpdateOAM_All
	call BattleAnimRequestPals
	ld a, [BattleAnimFlags]
	bit 0, a
	ret z
	xor a
	ld [hRunPicAnim], a

; fallthrough
BattleAnim_ClearOAM:
	ld a, [BattleAnimFlags]
	bit 3, a
	call z, ClearSprites
	xor a
	ld [hLYOverridesStart], a
	ld [hLYOverridesEnd], a
	ld [wLCDCPointer], a
	ld hl, wLYOverrides
	ld bc, wLYOverridesEnd - wLYOverrides
	call ByteFill
	ld hl, LYOverridesBackup
	ld bc, LYOverridesBackupEnd - LYOverridesBackup
	jp ByteFill

BattleAnimClearHud:
	call DelayFrame
	call WaitTop
	call ClearActorHud
	ld a, $1
	ld [hBGMapMode], a
	call Delay2
	jp WaitTop

BattleAnimRestoreHuds:
	call DelayFrame
	call WaitTop

	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a

	call UpdateBattleHuds

	pop af
	ld [rSVBK], a

	ld a, $1
	ld [hBGMapMode], a
	call Delay2
	jp WaitTop

BattleAnimRequestPals:
	ld a, [rBGP]
	ld b, a
	ld a, [wBGP]
	cp b
	call nz, BattleAnim_SetBGPals

	ld a, [rOBP0]
	ld b, a
	ld a, [wOBP0]
	cp b
	jp nz, BattleAnim_SetOBPals
	ret

ClearActorHud:
	ld a, [hBattleTurn]
	and a
	jr z, .player

	hlcoord 1, 0
	lb bc, 4, 10
	jp ClearBox

.player
	hlcoord 9, 7
	lb bc, 5, 11
	jp ClearBox

RunBattleAnimCommand:
	call .CheckTimer
	ret nc

; fallthrough
.RunScript:
.loop
	call GetBattleAnimByte

	cp $ff
	jr nz, .not_done_with_anim

; Return from a subroutine.
	ld hl, BattleAnimFlags
	bit 1, [hl]
	jr nz, .do_anim

	set 0, [hl]
	ret

.not_done_with_anim
	cp $d0
	jr nc, .do_anim

	ld [BattleAnimDuration], a
	ret

.do_anim
	call .DoCommand
	ld a, [hDEDCryFlag]
	and a
	jr z, .loop
	ret
; cc293

.CheckTimer
	ld a, [BattleAnimDuration]
	and a
	jr z, .done

	sub 1 ;clears carry (since a > 0)
	ld [BattleAnimDuration], a
	ret

.done
	scf
	ret

.DoCommand
; Execute battle animation command in [BattleAnimByte].
	ld a, [BattleAnimByte]
	sub $d0
	jumptable

BattleAnimCommands::
	dw BattleAnimCmd_Obj
	dw BattleAnimCmd_1GFX
	dw BattleAnimCmd_2GFX
	dw BattleAnimCmd_3GFX
	dw BattleAnimCmd_4GFX
	dw BattleAnimCmd_5GFX
	dw BattleAnimCmd_IncObj
	dw BattleAnimCmd_SetObj
	dw BattleAnimCmd_IncBGEffect
	dw BattleAnimCmd_EnemyFeetObj
	dw BattleAnimCmd_PlayerHeadObj
	dw BattleAnimCmd_CheckPokeball
	dw BattleAnimCmd_Transform
	dw BattleAnimCmd_RaiseSub
	dw BattleAnimCmd_DropSub
	dw BattleAnimCmd_ResetObp0
	dw BattleAnimCmd_Sound
	dw BattleAnimCmd_Cry
	dw BattleAnimCmd_MinimizeOpp
	dw BattleAnimCmd_OAMOn
	dw BattleAnimCmd_OAMOff
	dw BattleAnimCmd_ClearObjs
	dw BattleAnimCmd_E6 ; dummy
	dw BattleAnimCmd_InsObj
	dw BattleAnimCmd_UpdateActorPic
	dw BattleAnimCmd_Minimize
	dw BattleAnimCmd_JumpIfPMode
	dw BattleAnimCmd_CheckCriticalCapture
	dw BattleAnimCmd_ShakeDelay
	dw BattleAnimCmd_ED ; dummy
	dw BattleAnimCmd_JumpAnd
	dw BattleAnimCmd_JumpUntil
	dw BattleAnimCmd_BGEffect
	dw BattleAnimCmd_BGP
	dw BattleAnimCmd_OBP0
	dw BattleAnimCmd_OBP1
	dw BattleAnimCmd_ClearSprites
	dw BattleAnimCmd_DarkenBall
	dw BattleAnimCmd_F6 ; dummy
	dw BattleAnimCmd_ClearFirstBGEffect
	dw BattleAnimCmd_JumpIf
	dw BattleAnimCmd_SetVar
	dw BattleAnimCmd_IncVar
	dw BattleAnimCmd_JumpVar
	dw BattleAnimCmd_Jump
	dw BattleAnimCmd_Loop
	dw BattleAnimCmd_Call
	dw BattleAnimCmd_Ret

BattleAnimCmd_JumpIfPMode:
	ld a, [hBattleTurn]
	and a
	jr nz, .noJump
	call CheckPokemonOnlyMode
	jr nz, .jump
.noJump
	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret
.jump
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

BattleAnimCmd_CheckCriticalCapture:
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld a, [wCatchMon_Critical]
	ld b, a
	pop af
	ld [rSVBK], a
	ld a, b
	ld [BattleAnimVar], a
BattleAnimCmd_ED:
	ret

BattleAnimCmd_ShakeDelay:
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld a, [wCatchMon_NumShakes]
	ld b, a
	pop af
	ld [rSVBK], a
	ld a, b
	add a
	add b
	add a
	add a
	add $30
	ld [BattleAnimDuration], a
	; Hack to break out of the loop
	pop hl
	ret

BattleAnimCmd_Ret:
	ld hl, BattleAnimFlags
	res 1, [hl]
	ld hl, BattleAnimParent
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

BattleAnimCmd_Call:
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	push de
	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, BattleAnimParent
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, BattleAnimFlags
	set 1, [hl]
	ret

BattleAnimCmd_Jump:
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

BattleAnimCmd_Loop:
	call GetBattleAnimByte
	ld hl, BattleAnimFlags
	bit 2, [hl]
	jr nz, .continue_loop
	and a
	jr z, .perpetual
	dec a
	set 2, [hl]
	ld [BattleAnimLoops], a
.continue_loop
	ld hl, BattleAnimLoops
	ld a, [hl]
	and a
	jr z, .return_from_loop
	dec [hl]
.perpetual
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

.return_from_loop
	ld hl, BattleAnimFlags
	res 2, [hl]
	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

BattleAnimCmd_JumpUntil:
	ld hl, wBattleAnimParam
	ld a, [hl]
	and a
	jr z, .dont_jump

	dec [hl]
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

.dont_jump
	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

BattleAnimCmd_SetVar:
	call GetBattleAnimByte
	ld [BattleAnimVar], a
	ret

BattleAnimCmd_IncVar:
	ld hl, BattleAnimVar
	inc [hl]
	ret

BattleAnimCmd_JumpVar:
	call GetBattleAnimByte
	ld hl, BattleAnimVar
	cp [hl]
	jr z, .jump

	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

.jump
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

BattleAnimCmd_JumpIf:
	call GetBattleAnimByte
	ld hl, wBattleAnimParam
	cp [hl]
	jr z, .jump

	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

.jump
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret

BattleAnimCmd_JumpAnd:
	call GetBattleAnimByte
	ld e, a
	ld a, [wBattleAnimParam]
	and e
	jr nz, .jump

	ld hl, BattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret
.jump
	call GetBattleAnimByte
	ld e, a
	call GetBattleAnimByte
	ld d, a
	ld hl, BattleAnimAddress
	ld [hl], e
	inc hl
	ld [hl], d
	ret


BattleAnimCmd_InsObj:
	call GetBattleAnimByte
	; RAM lookup
	call BattleAnimCmd_FindObjIdx
	jr c, BattleAnimCmd_Obj ; If the lookup fails, append the object.
	; Do we have room for this?
	dec e
	jr z, BattleAnimCmd_InsObjFail ; If not, skip spawning (don't waste time in QueueBattleAnimation)

	; Loop to shift the memory array down
	ld hl, AnimObject09
	ld de, AnimObject10
.loop
	push bc
	push hl
	push de
	ld bc, BATTLEANIMSTRUCT_LENGTH
	rst CopyBytes
	pop de
	pop hl
	pop bc
	ld a, l
	cp c
	jr z, .done
	push hl
	ld de, -BATTLEANIMSTRUCT_LENGTH
	add hl, de
	pop de
	jr .loop

.done
	xor a
	ld [hl], a
BattleAnimCmd_Obj:
; index, x, y, param
	call GetBattleAnimByte
	ld [wBattleAnimTemp0], a
	call GetBattleAnimByte
	ld [wBattleAnimTemp1], a
	call GetBattleAnimByte
	ld [wBattleAnimTemp2], a
	call GetBattleAnimByte
	ld [wBattleAnimTemp3], a
	jp QueueBattleAnimation

BattleAnimCmd_InsObjFail:
	call GetBattleAnimByte
	call GetBattleAnimByte
	call GetBattleAnimByte
	jp GetBattleAnimByte

BattleAnimCmd_BGEffect:
	call GetBattleAnimByte
	ld [wBattleAnimTemp0], a
	call GetBattleAnimByte
	ld [wBattleAnimTemp1], a
	call GetBattleAnimByte
	ld [wBattleAnimTemp2], a
	call GetBattleAnimByte
	ld [wBattleAnimTemp3], a
	jpba QueueBGEffect

BattleAnimCmd_BGP:
	call GetBattleAnimByte
	ld [wBGP], a
	ret

BattleAnimCmd_OBP0:
	call GetBattleAnimByte
	ld [wOBP0], a
	ret

BattleAnimCmd_OBP1:
	call GetBattleAnimByte
	ld [wOBP1], a
	ret

BattleAnimCmd_ResetObp0:
	ld a, $e0
	ld [wOBP0], a
	ret

BattleAnimCmd_ClearObjs:
	ld hl, ActiveAnimObjects
	ld a, $a0
.loop
	ld [hl], $0
	inc hl
	dec a
	jr nz, .loop
	ret

BattleAnimCmd_1GFX:
BattleAnimCmd_2GFX:
BattleAnimCmd_3GFX:
BattleAnimCmd_4GFX:
BattleAnimCmd_5GFX:
	ld a, [BattleAnimByte]
	and $f
	ld c, a
	ld hl, wBattleAnimTileDict
	xor a
	ld [wBattleAnimTemp0], a
.loop
	ld a, [wBattleAnimTemp0]
	cp (VTiles1 - VTiles0) / $10 - $31
	ret nc
	call GetBattleAnimByte
	ld [hli], a
	ld a, [wBattleAnimTemp0]
	ld [hli], a
	push bc
	push hl
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, VTiles0 tile $31
	add hl, de
	ld a, [BattleAnimByte]
	call LoadBattleAnimObj
	ld a, [wBattleAnimTemp0]
	add c
	ld [wBattleAnimTemp0], a
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

BattleAnimCmd_IncObj:
	call GetBattleAnimByte
	call BattleAnimCmd_FindObjIdx
	ret c
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleAnimCmd_IncBGEffect:
	call GetBattleAnimByte
	call BattleAnimCmd_FindBGIdx
	ret c
	ld hl, BG_EFFECT_STRUCT_JT_INDEX
	add hl, bc
	inc [hl]
	ret

BattleAnimCmd_SetObj:
	call GetBattleAnimByte
	call BattleAnimCmd_FindObjIdx
	ret c
	call GetBattleAnimByte
	ld hl, BATTLEANIMSTRUCT_ANON_JT_INDEX
	add hl, bc
	ld [hl], a
	ret

BattleAnimCmd_EnemyFeetObj:
	ld hl, wBattleAnimTileDict
.loop
	ld a, [hl]
	and a
	jr z, .okay
	inc hl
	inc hl
	jr .loop

.okay
	ld a, $28
	ld [hli], a
	ld a, $42
	ld [hli], a
	ld a, $29
	ld [hli], a
	ld a, $49
	ld [hl], a

	ld hl, VTiles0 tile $73
	ld de, VTiles2 tile $06
	ld a, $70
	ld [wBattleAnimTemp0], a
	ld a, $7
	call .LoadFootprint
	ld de, VTiles2 tile $31
	ld a, $60
	ld [wBattleAnimTemp0], a
	ld a, $6
	jp .LoadFootprint

.LoadFootprint
	push af
	push hl
	push de
	lb bc, BANK(BattleAnimCmd_EnemyFeetObj), 1
	call Request2bpp
	pop de
	ld a, [wBattleAnimTemp0]
	ld l, a
	ld h, 0
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld bc, 1 tiles
	add hl, bc
	pop af
	dec a
	jr nz, .LoadFootprint
	ret

BattleAnimCmd_PlayerHeadObj:
	ld hl, wBattleAnimTileDict
.loop
	ld a, [hl]
	and a
	jr z, .okay
	inc hl
	inc hl
	jr .loop

.okay
	ld a, $28
	ld [hli], a
	ld a, $35
	ld [hli], a
	ld a, $29
	ld [hli], a
	ld a, $43
	ld [hl], a

	ld hl, VTiles0 tile $66
	ld de, VTiles2 tile $05
	ld a, $70
	ld [wBattleAnimTemp0], a
	ld a, $7
	call .LoadHead
	ld de, VTiles2 tile $31
	ld a, $60
	ld [wBattleAnimTemp0], a
	ld a, $6
.LoadHead
	push af
	push hl
	push de
	lb bc, BANK(BattleAnimCmd_EnemyFeetObj), 2
	call Request2bpp
	pop de
	ld a, [wBattleAnimTemp0]
	ld l, a
	ld h, 0
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld bc, 2 tiles
	add hl, bc
	pop af
	dec a
	jr nz, .LoadHead
	ret

BattleAnimCmd_CheckPokeball:
	callba GetPokeBallWobble
	ld a, c
	ld [BattleAnimVar], a
	ret

BattleAnimCmd_Transform:
	ld a, [rSVBK]
	push af
	ld a, BANK(wCurPartySpecies)
	ld [rSVBK], a
	ld a, [wCurPartySpecies]
	push af

	ld a, [hBattleTurn]
	and a
	jr z, .player

	ld a, [TempBattleMonSpecies]
	ld [wCurPartySpecies], a
	ld de, VTiles0 tile $00
	predef GetFrontpic
	jr .done

.player
	ld a, [TempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld de, VTiles0 tile $00
	predef GetBackpic

.done
	pop af
	ld [wCurPartySpecies], a
	pop af
	ld [rSVBK], a
	ret

BattleAnimCmd_UpdateActorPic:
	ld de, VTiles0 tile $00
	ld a, [hBattleTurn]
	and a
	jr z, .player

	ld hl, VTiles2 tile $00
	lb bc, 0, 7 * 7
	jp Request2bpp

.player
	ld hl, VTiles2 tile $31
	lb bc, 0, 6 * 6
	jp Request2bpp

BattleAnimCmd_RaiseSub:
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a

	ld hl, wDecompressScratch
	ld bc, 7 * 7 tiles
	xor a
	call ByteFill

	ld a, [hBattleTurn]
	and a
	jr z, .player
	
	call .ClearScratch

	ld hl, VTiles2
	ld de, wDecompressScratch
	ld c, 49
	call Request2bpp
	
	ld hl, MonsterSpriteGFX
	ld de, wDecompressScratch
	ld a, BANK(MonsterSpriteGFX)
	call FarDecompress
	
	ld hl, VTiles2 tile (19)
	ld de, wDecompressScratch
	call .CopyTile
	
	ld hl, VTiles2 tile (20)
	ld de, wDecompressScratch + 2 tiles
	call .CopyTile
	
	ld hl, VTiles2 tile (26)
	ld de, wDecompressScratch + 1 tiles
	call .CopyTile
	
	ld hl, VTiles2 tile (27)
	ld de, wDecompressScratch + 3 tiles
	call .CopyTile
	jr .done

.player
	call .ClearScratch

	ld hl, VTiles2 tile (7 * 7)
	ld de, wDecompressScratch
	ld c, 36
	call Request2bpp
	
	ld hl, MonsterSpriteGFX
	ld de, wDecompressScratch
	ld a, BANK(MonsterSpriteGFX)
	call FarDecompress
	
	ld hl, VTiles2 tile (7 * 7 + 16)
	ld de, wDecompressScratch + 4 tiles
	call .CopyTile
	
	ld hl, VTiles2 tile (7 * 7 + 17)
	ld de, wDecompressScratch + 6 tiles
	call .CopyTile
	
	ld hl, VTiles2 tile (7 * 7 + 22)
	ld de, wDecompressScratch + 5 tiles
	call .CopyTile
	
	ld hl, VTiles2 tile (7 * 7 + 23)
	ld de, wDecompressScratch + 7 tiles
	call .CopyTile

.done
	pop af
	ld [rSVBK], a
	ret

.CopyTile
	ld c, 1
	jp Request2bpp
	
.ClearScratch
	ld hl, wDecompressScratch
	ld bc, 36 tiles
	xor a
	jp ByteFill

BattleAnimCmd_MinimizeOpp:
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	call GetMinimizePic
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret

GetMinimizePic:
	ld hl, wDecompressScratch
	ld bc, (7 * 7) tiles
	xor a
	call ByteFill

	ld a, [hBattleTurn]
	and a
	jr z, .player

	ld de, wDecompressScratch tile (3 * 7 + 5)
	call CopyMinimizePic
	ld hl, VTiles2 tile $00
	ld de, wDecompressScratch
	lb bc, BANK(GetMinimizePic), 7 * 7
	ret

.player
	ld de, wDecompressScratch tile (3 * 6 + 4)
	call CopyMinimizePic
	ld hl, VTiles2 tile (7 * 7)
	ld de, wDecompressScratch
	lb bc, BANK(GetMinimizePic), 6 * 6
	ret

CopyMinimizePic:
	ld hl, MinimizePic
	ld bc, 1 tiles
	rst CopyBytes
	ret

MinimizePic: INCBIN "gfx/battle/minimize.2bpp"

BattleAnimCmd_Minimize:
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	call GetMinimizePic
	ld hl, VTiles0 tile $00
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret

BattleAnimCmd_DropSub:
	ld a, [rSVBK]
	push af
	ld a, BANK(wCurPartySpecies)
	ld [rSVBK], a

	ld a, [wCurPartySpecies]
	push af
	ld a, [hBattleTurn]
	and a
	ld hl, DropPlayerSub
	jr z, .farcall
	ld hl, DropEnemySub
.farcall
	ld a, BANK(DropEnemySub)
	call FarCall_hl
	pop af
	ld [wCurPartySpecies], a
	pop af
	ld [rSVBK], a
	ret

BattleAnimCmd_OAMOn:
	xor a
	ld [hOAMUpdate], a
	ret

BattleAnimCmd_OAMOff:
	ld a, $1
	ld [hOAMUpdate], a
	ret

BattleAnimCmd_DarkenBall:
	jpba DarkenBall

BattleAnimCmd_ClearSprites:
	ld hl, BattleAnimFlags
	set 3, [hl]
BattleAnimCmd_E6:
BattleAnimCmd_F6:
BattleAnimCmd_F7:
	ret

BattleAnimCmd_Sound:
	call GetBattleAnimByte
	ld e, a
	srl a
	srl a
	ld [wSFXDuration], a
	call .GetCryTrack
	and 3
	ld [CryTracks], a ; CryTracks

	ld e, a
	ld d, 0
	ld hl, .GetPanning
	add hl, de
	ld a, [hl]
	ld [wStereoPanningMask], a

	call GetBattleAnimByte
	ld e, a
	ld d, 0
	cp SFX_THROW_BALL
	jr nz, .play
	ld a, [FXAnimIDHi]
	and a
	jr z, .play
	ld a, [FXAnimIDLo]
	cp ANIM_THROW_POKE_BALL % $100
	jr nz, .play
	ld a, [rSVBK]
	push af
	ld a, BANK(wCatchMon_Critical)
	ld [rSVBK], a
	ld a, [wCatchMon_Critical]
	and a
	jr z, .pop
	ld e, SFX_KINESIS
.pop
	pop af
	ld [rSVBK], a
.play
	jpba PlayStereoSFX

.GetPanning
	db $f0, $0f, $f0, $0f

.GetCryTrack
	ld a, [hBattleTurn]
	and a
	ld a, e
	ret z
	xor 1
	ret

BattleAnimCmd_Cry:
	call GetBattleAnimByte
	ld c, a
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a

	ld a, [hBattleTurn]
	and a
	jr nz, .enemy

	ld a, $f0
	ld [CryTracks], a ; CryTracks
	ld a, [BattleMonSpecies] ; BattleMonSpecies
	jr .done_cry_tracks

.enemy
	ld a, $0f
	ld [CryTracks], a ; CryTracks
	ld a, [EnemyMonSpecies] ; EnemyMon

.done_cry_tracks
	ld b, a
	push bc
	call LoadCryHeader
	pop bc
	jr c, .ded
	ld hl, CryLength
	dec c
	ld a, $c0
	jr nz, .gotLengthOffset
	ld a, $40
.gotLengthOffset
	add [hl]
	ld [hli], a
	jr nc, .noCarry
	inc [hl]
.noCarry

	ld a, 1
	ld [wStereoPanningMask], a

	callba _PlayCryHeader

.done
	pop af
	ld [rSVBK], a
	ret

.ded
	ld a, b
	ld [hDEDCryFlag], a
	jr .done

PlayHitSound:
	ld a, [wNumHits]
	cp $1
	jr z, .okay
	cp $4
	ret nz

.okay
	ld a, [TypeModifier]
	and $7f
	ret z

	cp 10
	ld de, SFX_DAMAGE
	jr z, .play

	ld de, SFX_SUPER_EFFECTIVE
	jr nc, .play

	ld de, SFX_NOT_VERY_EFFECTIVE

.play
	jp PlaySFX

BattleAnimAssignPals:
	ld a, %11100100
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	jp DmgToCgbObjPals

ClearBattleAnims:
; Clear animation block
	ld hl, wLYOverrides
	ld bc, wBattleAnimEnd - wLYOverrides
	xor a
	call ByteFill

	ld hl, FXAnimIDLo
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, BattleAnimations
	add hl, de
	add hl, de
	call GetBattleAnimPointer
	call BattleAnimAssignPals
	jp DelayFrame

BattleAnim_RevertPals:
	call WaitTop
	ld a, %11100100
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	call DmgToCgbBGPals
	lb de, %11100100, %11100100
	call DmgToCgbObjPals
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call DelayFrame
	ld a, $1
	ld [hBGMapMode], a
	ret

BattleAnim_SetBGPals:
	ld [rBGP], a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, BGPals
	ld de, UnknBGPals
	ld a, [rBGP]
	ld b, a
	ld c, $7
	call CopyPals
	ld hl, OBPals
	ld de, UnknOBPals
	ld a, [rBGP]
	ld b, a
	ld c, $2
	call CopyPals
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret

BattleAnim_SetOBPals:
	ld [rOBP0], a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, OBPals + $10
	ld de, UnknOBPals + $10
	ld a, [rOBP0]
	ld b, a
	ld c, $2
	call CopyPals
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret

BattleAnim_UpdateOAM_All:
	ld a, $0
	ld [wBattleAnimOAMPointerLo], a
	ld hl, ActiveAnimObjects
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .next
	ld c, l
	ld b, h
	push hl
	push de
	call DoBattleAnimFrame
	call BattleAnimOAMUpdate
	pop de
	pop hl
	ret c

.next
	ld bc, BATTLEANIMSTRUCT_LENGTH
	add hl, bc
	dec e
	jr nz, .loop
	ld a, [wBattleAnimOAMPointerLo]
	ld l, a
	ld h, Sprites / $100
.loop2
	ld a, l
	cp SpritesEnd % $100
	ret nc
	xor a
	ld [hli], a
	jr .loop2

BattleAnimCmd_FindObjIdx:
	ld e, 10
	ld bc, ActiveAnimObjects
.loop
	ld hl, BATTLEANIMSTRUCT_INDEX
	add hl, bc
	ld d, [hl]
	ld a, [BattleAnimByte]
	cp d
	ret z
	ld hl, BATTLEANIMSTRUCT_LENGTH
	add hl, bc
	ld c, l
	ld b, h
	dec e
	jr nz, .loop
	scf
	ret

BattleAnimCmd_FindBGIdx:
	ld e, 5
	ld bc, ActiveBGEffects
.loop
	ld hl, BG_EFFECT_STRUCT_FUNCTION
	add hl, bc
	ld d, [hl]
	ld a, [BattleAnimByte]
	cp d
	ret z
	ld hl, BG_EFFECT_STRUCT_LENGTH
	add hl, bc
	ld c, l
	ld b, h
	dec e
	jr nz, .loop
	scf
	ret

BattleAnimCmd_ClearFirstBGEffect:
	xor a
	ld [ActiveBGEffects], a
	ret
