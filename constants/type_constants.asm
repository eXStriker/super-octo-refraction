	const_def
	const PHYSICAL ; 00
	const SPECIAL  ; 40
	const STATUS   ; 80

	const_def
	const NORMAL
	const FIGHTING
	const FLYING
	const POISON
	const GROUND
	const ROCK
	const BIRD
	const BUG
	const GHOST
	const STEEL
	const FAIRY_T
	const GAS
	const TYPE_12
	const SOUND
	const TRI_T
	const PRISM_T

UNUSED_TYPES EQU const_value
	const TYPE_16
	const TYPE_17
	const TYPE_18
	const CURSE_T
UNUSED_TYPES_END EQU const_value

	const FIRE
	const WATER
	const GRASS
	const ELECTRIC
	const PSYCHIC
	const ICE
	const DRAGON
	const DARK

TYPES_END EQU const_value

IF (TYPES_END % 4) != 0
MATCHUP_TABLE_WIDTH EQU (TYPES_END >> 2) + 1
ELSE
MATCHUP_TABLE_WIDTH EQU (TYPES_END >> 2)
ENDC

	const_def
	const IMM
	const NVE
	const NTL
	const SE_
