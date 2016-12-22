BattleCommand_Transform:
; transform

	call ClearLastMove
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_TRANSFORMED, [hl]
	jr nz, .ButItFailed
	call CheckHiddenOpponent
	jr z, .not_hidden_or_transformed
.ButItFailed
	jpba BattleEffect_ButItFailed
.not_hidden_or_transformed
	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	ld a, $1
	ld [wBattleAnimParam], a
	call CheckSubstituteOpp
	push af ; save flags for later
	jr z, .mimic_substitute
	call CheckUserIsCharging
	call nz, PlaySubstituteAnim
.mimic_substitute
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	set SUBSTATUS_TRANSFORMED, [hl]
	ld a, [hBattleTurn]
	and a
	jr nz, .enemyTurn
	ld hl, EnemyMonSpecies
	ld de, BattleMonSpecies
	xor a
	ld [CurMoveNum], a
	ld [PlayerDisableCount], a
	ld [DisabledMove], a
	jr .got_mon_species
.enemyTurn
	ld hl, BattleMonSpecies
	ld de, EnemyMonSpecies
	xor a
	ld [EnemyDisableCount], a
	ld [EnemyDisabledMove], a
.got_mon_species
	push hl
	ld a, [hli]
	ld [de], a
	inc hl
	inc de
	inc de
	ld bc, NUM_MOVES
	rst CopyBytes
	ld a, [hBattleTurn]
	and a
	jr z, .mimic_enemy_backup
	ld a, [de]
	ld [wEnemyBackupDVs], a
	inc de
	ld a, [de]
	ld [wEnemyBackupDVs + 1], a
	dec de
.mimic_enemy_backup
; copy DVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
; move pointer to stats
	ld bc, BattleMonStats - BattleMonPP
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, BattleMonStructEnd - BattleMonStats
	rst CopyBytes
; init the power points
	ld bc, BattleMonMoves - BattleMonStructEnd
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	ld bc, BattleMonPP - BattleMonStructEnd
	add hl, bc
	ld b, NUM_MOVES
.pp_loop
	ld a, [de]
	inc de
	and a
	jr z, .done_move
	ld a, 5
.done_move
	ld [hli], a
	dec b
	jr nz, .pp_loop
	pop hl
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, EnemyStats
	ld de, PlayerStats
	ld bc, 2 * 5
	call BattleSideCopy
	ld hl, EnemyStatLevels
	ld de, PlayerStatLevels
	ld bc, 8
	call BattleSideCopy
	call CheckBattleScene
	jr c, .mimic_anims
	ld a, [hBattleTurn]
	and a
	ld a, [wPlayerMinimized]
	jr z, .got_byte
	ld a, [wEnemyMinimized]
.got_byte
	and a
	jr nz, .mimic_anims
	callba LoadMoveAnim
	jr .after_anim

.mimic_anims
	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSubNoAnim
.after_anim
	xor a
	ld [wNumHits], a
	ld [FXAnimIDHi], a
	ld a, $2
	ld [wBattleAnimParam], a
	pop af
	call nz, PlaySubstituteAnim
	ld hl, TransformedText
	jp StdBattleTextBox

BattleSideCopy:
; Copy bc bytes from hl to de if it's the player's turn.
; Copy bc bytes from de to hl if it's the enemy's turn.
	ld a, [hBattleTurn]
	and a
	jr z, .copy

; Swap hl and de
	push hl
	ld h, d
	ld l, e
	pop de
.copy
	rst CopyBytes
	ret

PlaySubstituteAnim:
	ld a, SUBSTITUTE
	ld [FXAnimIDLo], a
	jpba PlayUserBattleAnim
