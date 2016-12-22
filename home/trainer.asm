CheckTrainerBattle:: ; 3600
; Check if any trainer on the map sees the player and wants to battle.
	call StackCallInMapScriptHeaderBank

.Function:
; Skip the player object.
	ld a, 1
	ld de, MapObjects + OBJECT_LENGTH

.loop

; Start a battle if the object:

	push af
	push de

; Has a sprite
	ld hl, MAPOBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

; Is a trainer
	ld hl, MAPOBJECT_COLOR
	add hl, de
	ld a, [hl]
	and $f
	cp PERSONTYPE_TRAINER
	jr nz, .next

; Is visible on the map
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	cp -1
	jr z, .next

; Is facing the player...
	call GetObjectStruct
	call FacingPlayerDistance_bc
	jr nc, .next

; ...within their sight range
	ld hl, MAPOBJECT_PARAMETER
	add hl, de
	ld a, [hl]
	cp b
	jr c, .next

; And hasn't already been beaten
	push bc
	push de
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	pop de
	pop bc
	and a
	jr z, .startbattle

.next
	pop de
	ld hl, OBJECT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	xor a
	ret

.startbattle
	pop de
	pop af
	ld [hLastTalked], a
	ld a, b
	ld [EngineBuffer2], a
	ld a, c
	ld [EngineBuffer3], a
	jr LoadTrainer_continue
; 3674

TalkToTrainer:: ; 3674
	ld a, 1
	ld [EngineBuffer2], a
	ld a, -1
	ld [EngineBuffer3], a

LoadTrainer_continue:: ; 367e
	ld a, [MapScriptHeaderBank]
	ld [EngineBuffer1], a

	ld a, [hLastTalked]
	call GetMapObject

	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [EngineBuffer1]
	call GetFarHalfword
	ld de, wTempTrainerHeader
	ld bc, wTempTrainerHeaderEnd - wTempTrainerHeader
	ld a, [EngineBuffer1]
	call FarCopyBytes
	xor a
	ld [wRunningTrainerBattleScript], a
	scf
	ret
; 36a5

FacingPlayerDistance_bc:: ; 36a5

	push de
	call FacingPlayerDistance
	ld b, d
	ld c, e
	pop de
	ret
; 36ad

FacingPlayerDistance:: ; 36ad
; Return carry if the sprite at bc is facing the player,
; and its distance in d.

	ld hl, OBJECT_NEXT_MAP_X ; x
	add hl, bc
	ld d, [hl]

	ld hl, OBJECT_NEXT_MAP_Y ; y
	add hl, bc
	ld e, [hl]

	ld a, [PlayerStandingMapX]
	cp d
	jr z, .CheckY

	ld a, [PlayerStandingMapY]
	cp e
	jr z, .CheckX

	and a
	ret

.CheckY:
	ld a, [PlayerStandingMapY]
	sub e
	jr z, .NotFacing
	jr nc, .Above

; Below
	cpl
	inc a
	ld d, a
	ld e, OW_UP
	jr .CheckFacing

.Above:
	ld d, a
	ld e, OW_DOWN
	jr .CheckFacing

.CheckX:
	ld a, [PlayerStandingMapX]
	sub d
	jr z, .NotFacing
	jr nc, .Left

; Right
	cpl
	inc a
	ld d, a
	ld e, OW_LEFT
	jr .CheckFacing

.Left:
	ld d, a
	ld e, OW_RIGHT

.CheckFacing:
	call GetSpriteDirection
	cp e
	jr nz, .NotFacing
	scf
	ret

.NotFacing:
	and a
	ret
; 36f5

CheckTrainerFlag:: ; 36f5
	push bc
	ld hl, OBJECT_MAP_OBJECT_INDEX
	add hl, bc
	ld a, [hl]
	call GetMapObject
	ld hl, MAPOBJECT_SCRIPT_POINTER
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MapScriptHeaderBank]
	call GetFarHalfword
	ld d, h
	ld e, l
	push de
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop de
	ld a, c
	and a
	pop bc
	ret
; 3718

PrintWinLossText:: ; 3718
	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr z, .canlose
	ld hl, wWinTextPointer
	jr .ok

.canlose
	ld a, [wBattleResult]
	ld hl, wWinTextPointer
	and $f
	jr z, .ok
	ld hl, wLossTextPointer

.ok
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call .get_text_bank
	call FarPrintText
	call ApplyTilemapInVBlank
	jp WaitPressAorB_BlinkCursor

.get_text_bank
	ld a, [InBattleTowerBattle]
	bit 2, a
	ld a, [MapScriptHeaderBank]
	ret z
	ld a, [wBattleResult]
	and 15
	dec a
	ld a, [wLossTextBank]
	ret z
	ld a, [wWinTextBank]
	ret
