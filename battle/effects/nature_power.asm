BattleCommand_NaturePower:
	call ButtonSound
	ld a, [wTileset]
	dec a
	ld e, a
	ld d, 0
	ld hl, NaturePowerMoves
	add hl, de
	ld a, [hl]
	and a
	jr nz, .okay

.Tileset2Moves
	ld a, [MapGroup]
	cp GROUP_ROUTE_70
	jr z, .snowroute
	cp GROUP_ROUTE_84
	jr z, .snowroute
	cp GROUP_ROUTE_85
	jr z, .fireroute
; any other route
	ld a, ENERGY_BALL
	jr .okay

.snowroute
	ld a, ICE_BEAM
	jr .okay

.fireroute
	ld a, FLAMETHROWER

.okay
	ld [wd265], a
	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld a, [wd265]
	ld [hl], a
	callba UpdateMoveData
	ld hl, NaturePowerText
	jp StdBattleTextBox

NaturePowerMoves::
	db ENERGY_BALL
	db $00
	db ENERGY_BALL
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db HYDRO_PUMP
	db TRI_ATTACK
	db THUNDERBOLT ; 10
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
	db SHADOW_BALL
	db EARTH_POWER
	db EARTH_POWER ; 20
	db POWER_GEM
	db ENERGY_BALL
	db SHADOW_BALL
	db TRI_ATTACK
	db TRI_ATTACK
	db ICE_BEAM
	db POWER_GEM
	db ENERGY_BALL
	db TRI_ATTACK
	db TRI_ATTACK ; 30
	db TRI_ATTACK
	db EARTH_POWER
	db FLAMETHROWER
	db ENERGY_BALL
	db ENERGY_BALL
	db TRI_ATTACK
	db SHADOW_BALL
	db SHADOW_BALL
	db TRI_ATTACK
	db THUNDERBOLT ;40
	db POWER_GEM
	db HYDRO_PUMP
	db POWER_GEM
	db ENERGY_BALL
	db ENERGY_BALL
	db TRI_ATTACK
	db TRI_ATTACK
	db TRI_ATTACK
