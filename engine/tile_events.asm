CheckWarpCollision::
; Is this tile a warp?
	ld a, [PlayerStandingTile]
	cp $60
	jr z, .warp
	cp $68
	jr z, .warp
	and $f0
	cp $70
	jr z, .warp
	and a
	ret

.warp
	scf
	ret

CheckDirectionalWarp::
; If this is a directional warp, clear carry (press the designated button to warp).
; Else, set carry (immediate warp).
	ld a, [PlayerStandingTile]
	cp $70 ; Warp on down
	jr z, .not_warp
	cp $76 ; Warp on left
	jr z, .not_warp
	cp $78 ; Warp on up
	jr z, .not_warp
	cp $7e ; Warp on right
	jr z, .not_warp
	scf
	ret

.not_warp
	xor a
	ret

CheckWarpFacingDown:
	ld hl, .blocks
	ld a, [PlayerStandingTile]
	jp IsInSingularArray

.blocks
	db $71 ; door
	db $79
	db $7a ; stairs
	db $73
	db $7b ; cave entrance
	db $74
	db $7c ; warp pad
	db $75
	db $7d
	db -1

CheckGrassCollision::
	ld a, [PlayerStandingTile]
	ld hl, .blocks
	jp IsInSingularArray

.blocks
	db $08
	db $18 ; tall grass
	db $14 ; tall grass
	db $28
	db $29
	db $48
	db $49
	db $4a
	db $4b
	db $4c
	db -1

CheckCutCollision:
	ld a, c
	ld hl, .blocks
	jp IsInSingularArray

.blocks
	db $12 ; cut tree
	db $1a ; cut tree
	db $10 ; tall grass
	db $18 ; tall grass
	db $14 ; tall grass
	db $1c ; tall grass
	db -1
