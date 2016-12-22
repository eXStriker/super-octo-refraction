EffectCommands2::

INCLUDE "battle/effects/willowisp.asm"
INCLUDE "battle/effects/transform.asm"
INCLUDE "battle/effects/metronome.asm"
INCLUDE "battle/effects/mirror_move.asm"
INCLUDE "battle/effects/sleep_talk.asm"
INCLUDE "battle/effects/nature_power.asm"

BattleCommand_CheckObedience:
; checkobedience

	call CheckUserIsCharging
	ret nz

	; Enemy can't disobey unless truant
	ld a, [hBattleTurn]
	and a
	jr z, .normal_checks

	; If we've already checked this turn
	ld a, [wEnemyAlreadyDisobeyed]
	and a
	ret nz

	xor a
	ld [wEnemyAlreadyDisobeyed], a

	; Truant!!
	ld a, [EnemyAbility]
	cp ABILITY_TRUANT
	ret nz

	ld a, [EnemyTurnsTaken]
	bit 0, a
	ret z
	inc a
	ld [EnemyTurnsTaken], a

	ld hl, LoafingAroundText
	call StdBattleTextBox
	xor a
	ld [LastEnemyMove], a
	ld [LastPlayerCounterMove], a

	; Break Encore too.
	ld hl, wEnemySubStatus5
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [EnemyEncoreCount], a

	jp EndMoveEffect

.normal_checks
	; If we've already checked this turn
	ld a, [AlreadyDisobeyed]
	and a
	ret nz

	xor a
	ld [AlreadyDisobeyed], a

	; Truant!!
	ld a, [PlayerAbility]
	cp ABILITY_TRUANT
	jr nz, .not_truant

	ld a, [PlayerTurnsTaken]
	bit 0, a
	jr z, .not_truant
	inc a
	ld [PlayerTurnsTaken], a
	ld hl, LoafingAroundText
	jp .printDisobeyText

.not_truant

	; No obedience in link battles
	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [InBattleTowerBattle]
	bit 0, a
	ret nz
	; If the monster's id doesn't match the player's,
	; some conditions need to be met.
	ld a, MON_ID
	call BattlePartyAttr

	ld a, [PlayerID]
	cp [hl]
	jr nz, .obeylevel
	inc hl
	ld a, [PlayerID + 1]
	cp [hl]
	ret z

.obeylevel
	; The maximum obedience level is constrained by owned badges:
	; min(100, 20 + 10 * #badges)
	ld hl, wNaljoBadges
	ld b, 3
	ld a, 20
.loop
	ld c, 8
	ld d, [hl]
.loop2
	srl d
	jr nc, .next
	add 10
	cp MAX_LEVEL
	jr nc, .getlevel
.next
	dec c
	jr nz, .loop2
	inc hl
	dec b
	jr nz, .loop
.getlevel
; c = obedience level
; d = monster level
; b = c + d

	ld b, a
	ld c, a

	ld a, [BattleMonLevel]
	ld d, a

	add b
	ld b, a

; No overflow (this should never happen)
	jr nc, .checklevel
	ld b, $ff

.checklevel
; If the monster's level is lower than the obedience level, it will obey.
	ld a, c
	cp d
	ret nc

; Random number from 0 to obedience level + monster level
.rand1
	call BattleRandom
	cp b
	jr nc, .rand1

; The higher above the obedience level the monster is,
; the more likely it is to disobey.
	cp c
	ret c

; Sleep-only moves have separate handling, and a higher chance of
; being ignored. Lazy monsters like their sleep.
	call IgnoreSleepOnly
	ret c

; Another random number from 0 to obedience level + monster level
.rand2
	call BattleRandom
	cp b
	jr nc, .rand2

; A second chance.
	cp c
	jr c, .monUsedInstead

; No hope of using a move now.

; b = number of levels the monster is above the obedience level
	ld a, d
	sub c
	ld b, a

; The chance of napping is the difference out of 256.
	call BattleRandom
	sub b
	jr c, .monNaps

; The chance of not hitting itself is the same.
	cp b
	jr nc, .monDoesNothing

	ld hl, WontObeyText
	call StdBattleTextBox
	callba HitConfusion
	jp .endDisobedience

.monNaps
	call BattleRandom
	and SLP
	jr z, .monNaps

	ld [BattleMonStatus], a

	ld hl, BeganToNapText
	jr .printDisobeyText

.monDoesNothing
	call BattleRandom
	and 3

	ld hl, LoafingAroundText
	and a
	jr z, .printDisobeyText

	ld hl, WontObeyText
	dec a
	jr z, .printDisobeyText

	ld hl, TurnedAwayText
	dec a
	jr z, .printDisobeyText

	ld hl, IgnoredOrdersText

.printDisobeyText
	call StdBattleTextBox
	jp .endDisobedience

.monUsedInstead

; Can't use another move if the monster only has one!
	ld a, [BattleMonMoves + 1]
	and a
	jr z, .monDoesNothing

; Don't bother trying to handle Disable.
	ld a, [DisabledMove]
	and a
	jr nz, .monDoesNothing

	ld hl, BattleMonPP
	ld de, BattleMonMoves
	ld b, 0
	ld c, NUM_MOVES

.getTotalPPLoop
	ld a, [hli]
	and $3f ; exclude pp up
	add b
	ld b, a

	dec c
	jr z, .checkMovePP

; Stop at undefined moves.
	inc de
	ld a, [de]
	and a
	jr nz, .getTotalPPLoop

.checkMovePP
	ld hl, BattleMonPP
	ld a, [CurMoveNum]
	ld e, a
	ld d, 0
	add hl, de

; Can't use another move if only one move has PP.
	ld a, [hl]
	and $3f
	cp b
	jr z, .monDoesNothing

; Make sure we can actually use the move once we get there.
	ld a, 1
	ld [AlreadyDisobeyed], a

	ld a, [w2DMenuNumRows]
	ld b, a

; Save the move we originally picked for afterward.
	ld a, [CurMoveNum]
	ld c, a
	push af

.randomMoveLoop
	call BattleRandom
	and 3 ; TODO NUM_MOVES

	cp b
	jr nc, .randomMoveLoop

; Not the move we were trying to use.
	cp c
	jr z, .randomMoveLoop

; Make sure it has PP.
	ld [CurMoveNum], a
	ld hl, BattleMonPP
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	and $3f
	jr z, .randomMoveLoop

; Use it.
	ld a, [CurMoveNum]
	ld c, a
	ld b, 0
	ld hl, BattleMonMoves
	add hl, bc
	ld a, [hl]
	ld [CurPlayerMove], a

	call SetPlayerTurn
	callba UpdateMoveDataAndDoMove

; Restore original move choice.
	pop af
	ld [CurMoveNum], a

.endDisobedience
	xor a
	ld [LastPlayerMove], a
	ld [LastEnemyCounterMove], a

	; Break Encore too.
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [PlayerEncoreCount], a

	jp EndMoveEffect

IgnoreSleepOnly:

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp SLEEP_TALK
	jr z, .checkSleep
	and a
	ret

.checkSleep
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret z

; 'ignored orders…sleeping!'
	ld hl, IgnoredSleepingText
	call StdBattleTextBox

	call EndMoveEffect

	scf
	ret

BattleCommand_Critical:
; critical

; Determine whether this attack's hit will be critical.

	xor a
	ld [wCriticalHitOrOHKO], a

; Moves with no base power can never crit
	ld a, BATTLE_VARS_MOVE_POWER
	call GetBattleVar
	and a
	ret z

; Battle Armor prevents crits
	call GetTargetAbility
	cp ABILITY_BATTLE_ARMOR
	ret z

; Check held items that increase the crit level (stored in c)
	ld a, [hBattleTurn]
	and a
	ld hl, EnemyMonItem
	ld a, [EnemyMonSpecies]
	jr nz, .Item
	ld hl, BattleMonItem
	ld a, [BattleMonSpecies]

.Item
	ld c, 0

	cp CHANSEY
	jr nz, .FocusEnergy
	ld a, [hl]
	cp LUCKY_PUNCH
	jr nz, .FocusEnergy

; +2 critical level
	ld c, 2

.FocusEnergy
; Focus Energy increases the crit level
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_FOCUS_ENERGY, a
	jr z, .CheckCritical

; +2 critical level
	inc c
	inc c

.CheckCritical
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, .Criticals
	push bc
	call IsInSingularArray
	pop bc
	jr nc, .ScopeLens

; +1 critical level
	inc c

.ScopeLens
	push bc
	call GetUserItem ; this is in ROM0
	ld a, b
	cp HELD_CRITICAL_UP ; Increased critical chance. Only Scope Lens has this.
	pop bc
	jr nz, .SuperLuck

; +1 critical level
	inc c
.SuperLuck
	call GetUserAbility
	cp ABILITY_SUPER_LUCK
	jr nz, .Tally

; +1 critical level
	inc c
.Tally
	ld a, c
	cp 3
	jr nc, .always
	ld hl, .Chances
	ld b, 0
	add hl, bc
	call BattleRandom
	and [hl]
	ret nz
.always
	ld a, 1
	ld [wCriticalHitOrOHKO], a
	ret

.Criticals
	db KARATE_CHOP, RAZOR_LEAF, SLASH, AEROBLAST, CROSS_CHOP, SKY_ATTACK, SHADOW_CLAW, NIGHT_SLASH, PSYCHO_CUT, $ff
.Chances
	; chance for each critical level is 1/(n+1), where n is the number below. n+1 must be a power of 2.
	db 15, 7, 1 ;1/16 (6.25%), 1/8 (12.5%), 1/2 (50%)

INCLUDE "battle/used_move_text.asm"

BattleCommand_ClearMissDamage:
; clearmissdamage
	ld a, [AttackMissed]
	and a
	ret z

	jp ZeroDamage

BattleCommand_Recoil:
; recoil

	ld hl, BattleMonMaxHP
	ld a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, EnemyMonMaxHP
.got_hp
	ld a, [hli]
	ld b, a
	ld a, [hld]
	ld c, a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	jr z, .Struggle
	call GetUserAbility
	cp ABILITY_ROCK_HEAD
	ret z
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp DOUBLE_EDGE
	jr z, .ThirdRecoil
	cp FLARE_BLITZ
	jr z, .ThirdRecoil
	cp BRAVE_BIRD
	jr z, .ThirdRecoil
	call GetCurrentDamage
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
; get 1/4 damage or 1 HP, whichever is greater
	srl b
	rr c
	srl b
	rr c
	ld a, b
	or c
	jr nz, .min_damage
	inc c
.min_damage
	ld a, [hli]
	ld [wCurHPAnimMaxHP + 1], a
	ld a, [hld]
	ld [wCurHPAnimMaxHP], a
	dec hl
	ld a, [hl]
	ld [wCurHPAnimOldHP], a
	sub c
	ld [hld], a
	ld [wCurHPAnimNewHP], a
	ld a, [hl]
	ld [wCurHPAnimOldHP + 1], a
	sbc b
	ld [hl], a
	ld [wCurHPAnimNewHP + 1], a
	jr nc, .dont_ko
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wCurHPAnimNewHP
	ld [hli], a
	ld [hl], a
.dont_ko
	hlcoord 10, 9
	ld a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .animate_hp_bar
	hlcoord 2, 2
	xor a
.animate_hp_bar
	ld [wWhichHPBar], a
	predef AnimateHPBar
	call RefreshBattleHuds
	ld hl, RecoilText
	jp StdBattleTextBox

.Struggle
	callba GetQuarterMaxHP
	callba SubtractHPFromUser
	call UpdateUserInParty
	ld hl, RecoilText
	jp StdBattleTextBox

.ThirdRecoil ;1/3 of HP instead of 1/4
	call GetCurrentDamage
	ld a, [wCurDamage]
	ld [hDividend], a
	ld a, [wCurDamage + 1]
	ld [hDividend + 1], a
	ld a, 3
	ld [hDivisor], a
	ld b, 2
	predef Divide
	ld a, [hQuotient + 2]
	ld c, a
	ld a, [hQuotient + 1]
	ld b, a
	or c
	jr z, .min_damage
	inc c
	jr .min_damage

BattleCommand_CheckCharge:
; checkcharge

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_CHARGED, [hl]
	ret z
	res SUBSTATUS_CHARGED, [hl]
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	ld b, charge_command
	jpba SkipToBattleCommand

UsedContactMove:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld hl, ContactMoves
	jp IsInSingularArray

ContactMoves:
	db POUND
	db KARATE_CHOP
	db DRAIN_PUNCH
	db FIRE_PUNCH
	db ICE_PUNCH
	db SCRATCH
	db CUT
	db WING_ATTACK
	db FLY
	db BRAVE_BIRD
	db VINE_WHIP
	db STOMP
	db DOUBLE_KICK
	db HEADBUTT
	db AQUA_JET
	db TACKLE
	db BODY_SLAM
	db WRAP
	db TAKE_DOWN
	db DOUBLE_EDGE
	db BITE
	db IRON_HEAD
	db PECK
	db DRILL_PECK
	db ZEN_HEADBUTT
	db COUNTER
	db SEISMIC_TOSS
	db STRENGTH
	db DIG
	db QUICK_ATTACK
	db RAGE
	db HEAD_SMASH
	db ASTONISH
	db LICK
	db THUNDER_FANG
	db WATERFALL
	db BULLET_PUNCH
	db LEECH_LIFE
	db DIZZY_PUNCH
	db WILD_CHARGE
	db X_SCISSOR
	db NIGHT_SLASH
	db METEOR_MASH
	db DRAGON_CLAW
	db SLASH
	db STRUGGLE
	db SHADOW_CLAW
	db THIEF
	db AERIAL_ACE
	db FLAME_WHEEL
	db FLAIL
	db REVERSAL
	db MACH_PUNCH
	db FEINT_ATTACK
	db PLAY_ROUGH
	db OUTRAGE
	db ROLLOUT
	db SPARK
	db FURY_CUTTER
	db STEEL_WING
	db RETURN
	db FRUSTRATION
	db MEGAHORN
	db PURSUIT
	db RAPID_SPIN
	db IRON_TAIL
	db METAL_CLAW
	db CROSS_CHOP
	db CRUNCH
	db ROCK_SMASH
	db POISON_JAB
	db -1

BattleCommand_CheckPowder:
	ld a, [AttackMissed]
	and a
	ret nz
	call PowderCheck
	ret nc
	ld a, $1
	ld [AttackMissed], a
	ret

PowderCheck:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	ld hl, PowderMoves
.loop
	ld a, [hli]
	cp $ff
	jr z, PowderCheck_fail
	cp b
	jr nz, .loop
CheckForGrassTyping:
	ld hl, EnemyMonType
	ld a, [hBattleTurn]
	and a
	jr z, .got_type
	ld hl, BattleMonType
.got_type
	ld a, [hli]
	cp GRASS
	jr z, .grass
	ld a, [hl]
	cp GRASS
	jr nz, PowderCheck_fail
.grass
	scf
	ret

PowderCheck_fail:
	and a
	ret

PowderMoves:
	db COTTON_SPORE
	db POISONPOWDER
	db SLEEP_POWDER
	db STUN_SPORE
	db $ff

ClearLastMove:
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a

	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ret

CheckUserMove:
; Return z if the user has move a.
	ld b, a
	ld de, BattleMonMoves
	ld a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, EnemyMonMoves
.ok
	ld c, NUM_MOVES
.loop
	ld a, [de]
	inc de
	cp b
	ret z

	dec c
	jr nz, .loop

	ld a, 1
	and a
	ret

UpdateMoveDataAndResetTurn:
	callba UpdateMoveData
	;fallthrough

ResetTurn:
	ld hl, wPlayerCharging
	ld a, [hBattleTurn]
	and a
	jr z, .player
	ld hl, wEnemyCharging

.player
	xor a
	ld [AlreadyDisobeyed], a
	inc a
	ld [hl], a
	callba DoMove
	jp EndMoveEffect
