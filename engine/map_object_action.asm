Pointers445f:
	dw SetFacingStanding, SetFacingStanding ; 0
	dw Function44b5,      SetFacingCurrent ; 01 standing?
	dw Function44c1,      SetFacingCurrent ; 02 walking?
	dw Function44c1,      SetFacingCurrent ; 03 bumping?
	dw Function4529,      SetFacingCurrent ; 04
	dw Function4539,      SetFacingStanding ; 05
	dw MapObjectAction_Fishing,      MapObjectAction_Fishing ; 06
	dw Function457b,      SetFacingStanding ; 07
	dw Function4582,      Function4582 ; 08
	dw Function4589,      Function4589 ; 09
	dw Function4590,      SetFacingCurrent ; 0a
	dw Function45ab,      SetFacingCurrent ; 0c
	dw Function45be,      Function45be ; 0b
	dw Function45c5,      Function45c5 ; 0d
	dw Function45da,      SetFacingStanding ; 0e
	dw Function45ed,      SetFacingStanding ; 0f
	dw Function44e4,      SetFacingCurrent ; 10
	dw MapObjectAction_Running, SetFacingCurrent
	dw MapObjectAction_FieldMove, MapObjectAction_FieldMove
	dw Function45ed_snow,      SetFacingStanding ; 0f

SetFacingStanding:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], STANDING
	ret

SetFacingCurrent:
	call SidescrollGetSpriteDirection
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

Function44b5:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld a, [hl]
	and 1
	jp z, SetFacingCurrent
	; fallthrough

Function44c1:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit SLIDING, [hl]
	jp nz, SetFacingCurrent

	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	rrca
	rrca
	rrca
	and %11
	ld d, a
	call SidescrollGetSpriteDirection
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

Function44e4:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit SLIDING, [hl]
	jp nz, SetFacingCurrent

	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	add 2
	ld [hl], a

	rrca
	rrca
	rrca
	and %11
	ld d, a

	call GetSpriteDirection
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

Function4529:
	call Function453f
	ld hl, OBJECT_FACING
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

Function4539:
	call Function453f
	jp SetFacingStanding

Function453f:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	and %11110000
	ld e, a

	ld a, [hl]
	inc a
	and %00001111
	ld d, a
	cp 2
	jr c, .ok

	ld d, 0
	ld a, e
	add $10
	and %00110000
	ld e, a

.ok
	ld a, d
	or e
	ld [hl], a

	swap e
	ld d, 0
	ld hl, .Directions
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_FACING
	add hl, bc
	ld [hl], a
	ret

.Directions
	db OW_DOWN, OW_RIGHT, OW_UP, OW_LEFT

MapObjectAction_Fishing:
	call GetSpriteDirection
	rrca
	rrca
	ld d, a
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	cp 72
	ld a, FACING_10
	jr nc, .okay
	ld a, FACING_20
.okay
	add d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

MapObjectAction_FieldMove:
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	cp 16
	ld a, 0
	jr nc, .okay
	inc a
.okay
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

Function457b:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_15
	ret

Function4582:
	; emote
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_EMOTE
	ret

Function4589:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_17
	ret

Function4590:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	ld a, [hl]
	inc a
	and %00011111
	ld [hl], a
	and %00010000
	jp z, SetFacingCurrent
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	set 0, [hl]
	ret

Function45ab:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	and %00011000
	rrca
	rrca
	rrca
	add $18
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret

Function45be:
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_16
	ret

Function45c5:
	ld a, [VariableSprites + SPRITE_BIG_DOLL - SPRITE_VARS]
	ld d, FACING_17
	cp SPRITE_BIG_SNORLAX
	jr z, .ok
	cp SPRITE_BIG_LAPRAS
	jr z, .ok
	ld d, FACING_16

.ok
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], d
	ret

Function45da:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]

	ld hl, OBJECT_FACING_STEP
	add hl, bc
	and %100
	ld a, FACING_1C
	jr z, .ok
	inc a ; FACING_1D
.ok
	ld [hl], a
	ret

Function45ed:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	and %1000
	ld a, FACING_1E
	jr z, .ok
	inc a ; FACING_1F

.ok
	ld [hl], a
	ret

Function45ed_snow:
	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	and %1000
	ld a, FACING_SNOW1
	jr z, .ok
	inc a ; FACING_SNOW2

.ok
	ld [hl], a
	ret

MapObjectAction_Running:
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit SLIDING, [hl]
	jp nz, SetFacingCurrent

	ld hl, OBJECT_STEP_FRAME
	add hl, bc
	inc [hl]
	ld a, [hl]
	rrca
	rrca
	and %11
	ld d, a
	call SidescrollGetSpriteDirection
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	ret
