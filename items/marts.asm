Marts:
	dw Mart0
	dw Mart1
	dw Mart2
	dw Mart3
	dw Mart4
	dw Mart5
	dw Mart6
	dw Mart7
	dw Mart8
	dw Mart9
	dw Mart10
	dw Mart11
	dw Mart12
	dw Mart13
	dw Mart14
	dw Mart15
	dw Mart16
	dw Mart17
	dw Mart18
	dw Mart19
	dw Mart20
	dw Mart21
	dw Mart22
	dw Mart23
	dw Mart24
	dw Mart25
	dw Mart26
	dw Mart27
	dw Mart28
	dw Mart29
	dw Mart30
	dw Mart31
	dw Mart32
	dw Mart33
	dw Mart34
MartsEnd

DefaultMart:
Mart0:
	db 5 ; # items
	db POKE_BALL
	db POTION
	db ANTIDOTE
	db ESCAPE_ROPE
	db REPEL
	db $ff

Mart1:
	db 7 ; # items
	db BRICK_PIECE
	db POKE_BALL
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db BURN_HEAL
	db REPEL
	db $ff

Mart2:
	db 7 ; # items
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SPECIAL
	db X_ACCURACY
	db GUARD_SPEC
	db DIRE_HIT
	db $ff

Mart3:
	db 8 ; # items
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db MOOMOO_MILK
	db $ff

Mart4:
	db 3 ; # items
	db BURGER
	db FRIES
	db SODA_POP
	db $ff

Mart5:
	db 5 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ESCAPE_ROPE
	db REPEL
	db POKE_DOLL
	db $ff

Mart6:
	db 8 ; # items
	db MINING_PICK
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db ESCAPE_ROPE
	db REPEL
	db $ff

Mart7:
	db 10 ; # items
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db REVIVE
	db $ff

Mart8:
	db 8 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db PARLYZ_HEAL
	db AWAKENING
	db ANTIDOTE
	db SUPER_REPEL
	db ESCAPE_ROPE
	db REVIVE
	db $ff

Mart9:
	db 7 ; # items
	db MINING_PICK
	db ULTRA_BALL
	db GREAT_BALL
	db HYPER_POTION
	db SUPER_POTION
	db SUPER_REPEL
	db X_DEFEND
	db $ff

Mart10:
	db 5 ; # items
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db $ff

Mart11:
	db 8 ; # items
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db FULL_HEAL
	db REVIVE
	db MAX_REPEL
	db ESCAPE_ROPE
	db $ff

Mart12:
	db 9 ; # items
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db MAX_REPEL
	db ESCAPE_ROPE
	db REVIVE
	db ANTIDOTE
	db FULL_HEAL
	db X_ACCURACY
	db $ff

Mart13:
	db 8 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db ICE_HEAL
	db SUPER_REPEL
	db $ff

Mart14:
	db 8 ; # items
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db FULL_HEAL
	db MAX_POTION
	db REVIVE
	db ELIXIR
	db $ff

Mart15:
	db 3 ; # items
	db TINYMUSHROOM
	db POKE_BALL
	db POTION
	db $ff

Mart16:
	db 7 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db SUPER_REPEL
	db REVIVE
	db $ff

Mart17:
	db 9 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db REVIVE
	db MAX_REPEL
	db X_DEFEND
	db X_ATTACK
	db $ff

Mart18:
	db 8 ; # items
	db ULTRA_BALL
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db $ff

Mart19:
	db 7 ; # items
	db WATER_STONE
	db POKE_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db $ff

Mart20:
	db 9 ; # items
	db FIRE_STONE
	db GREAT_BALL
	db ULTRA_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db FULL_HEAL
	db X_DEFEND
	db X_ATTACK
	db DIRE_HIT
	db $ff

Mart21:
	db 8 ; # items
	db LEAF_STONE
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db MAX_REPEL
	db FULL_HEAL
	db PARLYZ_HEAL
	db AWAKENING
	db $ff

Mart22:
	db 7 ; # items
	db THUNDERSTONE
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db REVIVE
	db PARLYZ_HEAL
	db FULL_HEAL
	db $ff

Mart23:
	db 6 ; # items
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db REVIVE
	db $ff

Mart24:
	db 3 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db $ff

Mart25:
	db 6 ; # items
	db FULL_HEAL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db $ff

Mart26:
	db 5 ; # items
	db REPEL
	db SUPER_REPEL
	db MAX_REPEL
	db ESCAPE_ROPE
	db POKE_DOLL
	db $ff

Mart27:
	db 5 ; # items
	db HP_UP
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db $ff

Mart28:
	db 7 ; # items
	db X_ACCURACY
	db GUARD_SPEC
	db DIRE_HIT
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SPECIAL
	db $ff

Mart29:
	db 6 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db PARLYZ_HEAL
	db AWAKENING
	db SUPER_REPEL
	db ESCAPE_ROPE
	db $ff

Mart30:
	db 7 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db X_ATTACK
	db X_DEFEND
	db $ff

Mart31:
	db 5 ; # items
	db EAGULOU_BALL
	db ULTRA_BALL
	db MAX_POTION
	db ESCAPE_ROPE
	db MAX_REPEL
	db $ff

Mart32:
	db 7 ; # items
	db ULTRA_BALL
	db MAX_REPEL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db REVIVE
	db FULL_HEAL
	db $ff

Mart33:
	db 4 ; # items
	db ENERGYPOWDER
	db ENERGY_ROOT
	db HEAL_POWDER
	db REVIVAL_HERB
	db $ff
	
Mart34:
	db 7 ; # items
	db ULTRA_BALL
	db MAX_POTION
	db FULL_RESTORE
	db BURN_HEAL
	db FULL_HEAL
	db MAX_REPEL
	db ELIXIR
	db $ff

BattleTowerMart:
	db 16
	db PROTEIN,       1
	db CALCIUM,       1
	db IRON,          1
	db CARBOS,        1
	db HP_UP,         1
	db POISON_GUARD, 16
	db BURN_GUARD,   16
	db FREEZE_GUARD, 16
	db SLEEP_GUARD,  16
	db PRZ_GUARD,    16
	db BRIGHTPOWDER, 48
	db FOCUS_BAND,   48
	db SCOPE_LENS,   48
	db RAZOR_CLAW,   48
	db RAZOR_FANG,   48
	db RARE_CANDY,   48
	db $ff
