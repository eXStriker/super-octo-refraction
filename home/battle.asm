BattleHome::

UserPartyAttr::
	push af
	ld a, [hBattleTurn]
	and a
	jr z, .battlemon
	pop af
	jr OTPartyAttr
.battlemon
	pop af
	; fallthrough

BattlePartyAttr::
; Get attribute a from the active BattleMon's party struct.
	push bc
	ld c, a
	ld b, 0
	ld hl, wPartyMons
	add hl, bc
	ld a, [CurBattleMon]
	call GetPartyLocation
	pop bc
	ret

OpponentPartyAttr::
	push af
	ld a, [hBattleTurn]
	and a
	jr z, .ot
	pop af
	jr BattlePartyAttr
.ot
	pop af
	; fallthrough

OTPartyAttr::
; Get attribute a from the active EnemyMon's party struct.
	push bc
	ld c, a
	ld b, 0
	ld hl, OTPartyMon1Species
	add hl, bc
	ld a, [CurOTMon]
	call GetPartyLocation
	pop bc
	ret

ResetDamage::
	push hl
	push bc
	xor a
	ld hl, CurrentDamageData
	ld bc, CurrentDamageDataEnd - CurrentDamageData
	call ByteFill
	ld a, 1
	ld [wCurDamageDefense + 1], a ;prevent div0
	ld [wCurDamageMovePowerDenominator], a
	ld [wCurDamageModifierNumerator + 2], a
	ld [wCurDamageModifierDenominator + 1], a
	ld a, 100
	ld [wCurDamageItemModifier], a
	pop bc
	pop hl
	ret

ZeroDamage::
	push hl
	ld hl, wCurDamageFlags
	ld a, $c0 ;fixed damage, dirty
	ld [hli], a ;hl = wCurDamageFixedValue
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
	ret

SetDamageDirtyFlag::
	push hl
	ld hl, wCurDamageFlags
	set 6, [hl]
	pop hl
	ret

GetCurrentDamage::
	push hl
	ld hl, wCurDamageFlags
	bit 6, [hl]
	jr z, .clean
	res 6, [hl]
	push bc
	push de
	callba _GetCurrentDamage
	pop de
	pop bc
.clean
	pop hl
	ret

SetPlayerTurn::
	xor a
	ld [hBattleTurn], a
	ret

SetEnemyTurn::
	ld a, 1
	ld [hBattleTurn], a
	ret

UpdateOpponentInParty::
	ld a, [hBattleTurn]
	and a
	jr nz, UpdateBattleMonInParty
	; fallthrough

UpdateEnemyMonInParty::
; Update level, status, current HP

; No wildmons.
	ld a, [wBattleMode]
	dec a
	ret z

	ld a, [CurOTMon]
	ld hl, OTPartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, EnemyMonLevel
	ld bc, EnemyMonMaxHP - EnemyMonLevel

	rst CopyBytes
	ret

UpdateUserInParty::
	ld a, [hBattleTurn]
	and a
	jr nz, UpdateEnemyMonInParty
	; fallthrough

UpdateBattleMonInParty::
; Update level, status, current HP

	ld a, [CurBattleMon]

UpdateBattleMon::
	ld hl, PartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, BattleMonLevel
	ld bc, BattleMonMaxHP - BattleMonLevel
	rst CopyBytes
	ret

RefreshBattleHuds::
	call UpdateBattleHuds
	call Delay2
	jp ApplyTilemapInVBlank

UpdateBattleHuds::
	jpba _UpdateBattleHuds

GetBattleVar::
; Preserves hl.
	push hl
	call GetBattleVarAddr
	pop hl
	ret

GetBattleVarAddr::
; Get variable from pair a, depending on whose turn it is.
; There are 21 variable pairs.

	push bc

	ld hl, .battlevarpairs
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a

; Enemy turn uses the second byte instead.
; This lets battle variable calls be side-neutral.
	ld a, [hBattleTurn]
	and a
	jr z, .getvar
	inc hl

.getvar
; var id
	ld c, [hl]
	ld b, 0

	ld hl, .vars
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hl]

	pop bc
	ret

.battlevarpairs
	dw .substatus1, .substatus2, .substatus3, .substatus4, .substatus5
	dw .substatus1opp, .substatus2opp, .substatus3opp, .substatus4opp, .substatus5opp
	dw .status, .statusopp, .semistatus, .semistatusopp, .animation, .effect, .power, .type
	dw .curmove, .lastcounter, .lastcounteropp, .lastmove, .lastmoveopp

;                       player                     enemy
.substatus1     db PLAYER_SUBSTATUS_1,    ENEMY_SUBSTATUS_1    ; 00
.substatus1opp  db ENEMY_SUBSTATUS_1,     PLAYER_SUBSTATUS_1   ; 01
.substatus2     db PLAYER_SUBSTATUS_2,    ENEMY_SUBSTATUS_2    ; 02
.substatus2opp  db ENEMY_SUBSTATUS_2,     PLAYER_SUBSTATUS_2   ; 03
.substatus3     db PLAYER_SUBSTATUS_3,    ENEMY_SUBSTATUS_3    ; 04
.substatus3opp  db ENEMY_SUBSTATUS_3,     PLAYER_SUBSTATUS_3   ; 05
.substatus4     db PLAYER_SUBSTATUS_4,    ENEMY_SUBSTATUS_4    ; 06
.substatus4opp  db ENEMY_SUBSTATUS_4,     PLAYER_SUBSTATUS_4   ; 07
.substatus5     db PLAYER_SUBSTATUS_5,    ENEMY_SUBSTATUS_5    ; 08
.substatus5opp  db ENEMY_SUBSTATUS_5,     PLAYER_SUBSTATUS_5   ; 09
.status         db PLAYER_STATUS,         ENEMY_STATUS         ; 0a
.statusopp      db ENEMY_STATUS,          PLAYER_STATUS        ; 0b
.semistatus     db PLAYER_SEMISTATUS,     ENEMY_SEMISTATUS     ; 0c
.semistatusopp  db ENEMY_SEMISTATUS,      PLAYER_SEMISTATUS    ; 0d
.animation      db PLAYER_MOVE_ANIMATION, ENEMY_MOVE_ANIMATION ; 0e
.effect         db PLAYER_MOVE_EFFECT,    ENEMY_MOVE_EFFECT    ; 0f
.power          db PLAYER_MOVE_POWER,     ENEMY_MOVE_POWER     ; 10
.type           db PLAYER_MOVE_TYPE,      ENEMY_MOVE_TYPE      ; 11
.curmove        db PLAYER_CUR_MOVE,       ENEMY_CUR_MOVE       ; 12
.lastcounter    db PLAYER_COUNTER_MOVE,   ENEMY_COUNTER_MOVE   ; 13
.lastcounteropp db ENEMY_COUNTER_MOVE,    PLAYER_COUNTER_MOVE  ; 14
.lastmove       db PLAYER_LAST_MOVE,      ENEMY_LAST_MOVE      ; 15
.lastmoveopp    db ENEMY_LAST_MOVE,       PLAYER_LAST_MOVE     ; 16

.vars
	dw wPlayerSubStatus1,             wEnemySubStatus1
	dw wPlayerSubStatus2,             wEnemySubStatus2
	dw wPlayerSubStatus3,             wEnemySubStatus3
	dw wPlayerSubStatus4,             wEnemySubStatus4
	dw wPlayerSubStatus5,             wEnemySubStatus5
	dw BattleMonStatus,               EnemyMonStatus
	dw BattleMonSemistatus,           EnemyMonSemistatus
	dw wPlayerMoveStructAnimation,    wEnemyMoveStructAnimation
	dw wPlayerMoveStructEffect,       wEnemyMoveStructEffect
	dw wPlayerMoveStructPower,        wEnemyMoveStructPower
	dw wPlayerMoveStructType,         wEnemyMoveStructType
	dw CurPlayerMove,                 CurEnemyMove
	dw LastEnemyCounterMove,          LastPlayerCounterMove
	dw LastPlayerMove,                LastEnemyMove

StdBattleTextBox::
; Open a textbox and print battle text at 20:hl.
GLOBAL BattleText
	anonbankpush BattleText

BattleTextBox::
; Open a textbox and print text at hl.
	push hl
	call SpeechTextBox
	call UpdateSprites
	call ApplyTilemap
	pop hl
	jp PrintTextBoxText

GetBattleAnimPointer::
	anonbankpush BattleAnimations

.Function:
	ld a, [hli]
	ld [BattleAnimAddress], a
	ld a, [hl]
	ld [BattleAnimAddress + 1], a
	ret

GetBattleAnimByte::
	anonbankpush BattleAnimations
	
.Function:
	push hl
	push de

	ld hl, BattleAnimAddress
	ld a, [hli]
	ld d, [hl]
	ld e, a

	ld a, [de]
	ld [BattleAnimByte], a
	inc de

	ld a, d
	ld [hld], a
	ld [hl], e

	pop de
	pop hl

	ld a, [BattleAnimByte]
	ret

ApplyBattleMonRingEffect::
	ld hl, PlayerStatLevels
	ld a, [BattleMonItem]
	jr _ApplyHeldRingEffect

ApplyEnemyMonRingEffect::
	ld hl, EnemyStatLevels
	ld a, [EnemyMonItem]
_ApplyHeldRingEffect:
	ld b, a
	jpba ApplyHeldRingEffect

CheckPokemonOnlyMode::
	ld a, [rSVBK]
	ld [hBuffer], a
	ld a, $1
	ld [rSVBK], a
	CheckEngine ENGINE_POKEMON_MODE
	ld a, [hBuffer]
	ld [rSVBK], a
	ret

PokedexEntryBanks::
GLOBAL PokedexEntries1, PokedexEntries2, PokedexEntries3, PokedexEntries4

	db BANK(PokedexEntries1)
	db BANK(PokedexEntries2)
	db BANK(PokedexEntries3)
	db BANK(PokedexEntries4)

CalcUserAbility:
	ld a, [hBattleTurn]
	and a
	jr z, CalcPlayerAbility
CalcEnemyAbility:
	push hl
	ld a, [EnemyMonSpecies]
	ld [wCurSpecies], a
	ld hl, EnemyMonDVs
	call CalcCurMonAbility
	ld [EnemyAbility], a
	pop hl
	ret

CalcTargetAbility:
	ld a, [hBattleTurn]
	and a
	jr z, CalcEnemyAbility
CalcPlayerAbility:
	push hl
	ld a, [BattleMonSpecies]
	ld [wCurSpecies], a
	ld hl, BattleMonDVs
	call CalcCurMonAbility
	ld [PlayerAbility], a
	pop hl
	ret

CalcPartyMonAbility:
; pointer to party struct in hl
	ld a, [hl]
	ld [wCurSpecies], a
	push hl
	push bc
	ld bc, MON_DVS
	add hl, bc
	pop bc
	call CalcCurMonAbility
	pop hl
	ret

GetFirstPartyMonAbility::
	ld hl, wPartySpecies
	ld b, -1
.get_first_nonegg
	inc b
	ld a, [hli]
	cp $ff
	ret z
	cp EGG
	jr z, .get_first_nonegg
	ld [wCurSpecies], a
	ld a, b
	ld hl, PartyMon1DVs
	call GetPartyLocation
CalcCurMonAbility::
	jpba CalcMonAbility

CheckHiddenOpponent:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret

CheckSubstituteOpp:
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret

CheckUserIsCharging:
	ld a, [hBattleTurn]
	and a
	ld a, [wPlayerCharging] ; player
	jr z, .end
	ld a, [wEnemyCharging] ; enemy
.end
	and a
	ret

CheckBattleScene:
; Return carry if battle scene is turned off.
	ld a, [wOptions]
	bit BATTLE_SCENE, a
	jr nz, .off
	and a
	ret
.off
	scf
	ret

BattleCommand_MoveDelay:
; movedelay
; Wait 40 frames.
	ld c, 40
	jp DelayFrames

BattleCommand_RaiseSubNoAnim:
	ld hl, GetMonBackpic
	ld a, [hBattleTurn]
	and a
	jr z, .PlayerTurn
	ld hl, GetMonFrontpic
.PlayerTurn
	xor a
	ld [hBGMapMode], a
	ld a, BANK(BattleCore)
	call FarCall_hl
	jp ApplyTilemapInVBlank

BattleCommand_ClearText:
; cleartext

; Used in multi-hit moves.
	ld hl, ClearTextTerminator
	jp BattleTextBox

ClearTextTerminator:
	db "@"

TryPrintButItFailed:
	ld a, [AlreadyFailed]
	and a
	ret nz

PrintButItFailed:
; 'but it failed!'
	ld hl, ButItFailedText
	jp StdBattleTextBox

EndMoveEffect:
	ld a, [BattleScriptBufferLoc]
	ld l, a
	ld a, [BattleScriptBufferLoc + 1]
	ld h, a
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

GetUserItem:
; Return the effect of the user's item in bc, and its id at hl.
	ld hl, BattleMonItem
	ld de, PlayerAbility
	ld a, [hBattleTurn]
	and a
	jr z, GetItemHeldEffect
	ld hl, EnemyMonItem
	ld de, EnemyAbility
	jr GetItemHeldEffect

GetOpponentItem:
; Return the effect of the opponent's item in bc, and its id at hl.
	ld hl, EnemyMonItem
	ld de, EnemyAbility
	ld a, [hBattleTurn]
	and a
	jr z, GetItemHeldEffect
	ld hl, BattleMonItem
	ld de, PlayerAbility
GetItemHeldEffect:
; Return the effect of item b in bc.
	lb bc, HELD_NONE, 0
	ld a, [de]
	cp ABILITY_KLUTZ
	ret z
	ld a, [hl]
	and a
	ret z
	push hl
	ld hl, ItemAttributes + 2
	dec a
	ld c, a
	ld b, 0
	ld a, NUM_ITEMATTRS
	rst AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarHalfword
	ld b, l
	ld c, h
	pop hl
	ret

SwitchTurn:
	ld a, [hBattleTurn]
	xor 1
	ld [hBattleTurn], a
	ret

GetUserAbility:
	ld a, [hBattleTurn]
	and a
	jr z, GetPlayerAbility
	jr GetEnemyAbility

GetTargetAbility:
	ld a, [hBattleTurn]
	and a
	jr z, GetEnemyAbility
GetPlayerAbility:
	push bc
	ld a, [PlayerAbility]
	ld b, a
	ld a, [EnemyAbility]
	cp ABILITY_MOLD_BREAKER
	jr z, MoldBreakerFilter
	ld a, b
	pop bc
	ret

GetEnemyAbility:
	push bc
	ld a, [EnemyAbility]
	ld b, a
	ld a, [PlayerAbility]
	cp ABILITY_MOLD_BREAKER
	jr z, MoldBreakerFilter
	ld a, b
	pop bc
	ret

MoldBreakerFilter:
; Caution: Don't call this directly!
; Doing so will result in an unbalanced stack!
	push hl
	ld hl, .Abilities
.loop
	ld a, [hli]
	cp $ff
	jr z, .not_broken
	cp b
	jr nz, .loop
	xor a ; ABILITY_NONE
	jr .done

.not_broken
	ld a, b
.done
	pop hl
	pop bc
	ret

.Abilities
	db ABILITY_BATTLE_ARMOR
	db ABILITY_CLEAR_BODY
	db ABILITY_DRY_SKIN
	db ABILITY_FLASH_FIRE
	db ABILITY_HEATPROOF
	db ABILITY_HYPER_CUTTER
	db ABILITY_IMMUNITY
	db ABILITY_INNER_FOCUS
	db ABILITY_INSOMNIA
	db ABILITY_KEEN_EYE
	db ABILITY_LEAF_GUARD
	db ABILITY_LEVITATE
	db ABILITY_LIGHTNINGROD
	db ABILITY_LIMBER
	db ABILITY_MAGMA_ARMOR
	db ABILITY_MARVEL_SCALE
	db ABILITY_MOTOR_DRIVE
	db ABILITY_OBLIVIOUS
	db ABILITY_OWN_TEMPO
	db ABILITY_SAND_VEIL
	db ABILITY_SHIELD_DUST
	db ABILITY_SIMPLE
	db ABILITY_SNOW_CLOAK
	db ABILITY_SOLID_ROCK
	db ABILITY_SOUNDPROOF
	db ABILITY_STURDY
	db ABILITY_SUCTION_CUPS
	db ABILITY_TANGLED_FEET
	db ABILITY_THICK_FAT
	db ABILITY_VITAL_SPIRIT
	db ABILITY_VOLT_ABSORB
	db ABILITY_WATER_ABSORB
	db ABILITY_WATER_VEIL
	db ABILITY_WHITE_SMOKE
	db ABILITY_CONTRARY
	db $ff

GetUserAbility_IgnoreMoldBreaker:
	ld a, [hBattleTurn]
	and a
	ld a, [PlayerAbility]
	ret z
	ld a, [EnemyAbility]
	ret

GetTargetAbility_IgnoreMoldBreaker:
	ld a, [hBattleTurn]
	and a
	ld a, [PlayerAbility]
	ret nz
	ld a, [EnemyAbility]
	ret

CheckAbilityNegatesWeather:
; returns z if the ability causes weather to be ignored
	ld a, [PlayerAbility]
	cp ABILITY_AIR_LOCK
	ret z
	ld a, [EnemyAbility]
	cp ABILITY_AIR_LOCK
	ret

CheckPlayerNaturalCure:
	ld a, [PlayerAbility]
	cp ABILITY_NATURAL_CURE
	ret nz
	ld a, [LastPlayerMon]
	ld hl, PartyMon1Status
	call GetPartyLocation
	ld [hl], 0
	ret

IsSoundBasedMove:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp BUG_BUZZ
	jr z, .soundBased
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	and $3f
	cp SOUND
	jr z, .soundBased
; not sound based
	and a
	ret
.soundBased
	scf
	ret

CheckIfInEagulouParkBattle:
	ld a, [wBattleMode]
	dec a
	ret nz
	ld a, [MapGroup]
	cp GROUP_EAGULOU_CITY
	ret nz
	ld a, [MapNumber]
	sub MAP_EAGULOU_PARK_1
	ret z
	dec a
	ret z
	dec a
	ret