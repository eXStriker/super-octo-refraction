BattleCommand_CalmMind:
; calmmind
	call ResetMiss
	call BattleCommand_SpecialAttackUp
	call BattleCommand_StatUpMessage

	call ResetMiss
	call BattleCommand_SpecialDefenseUp
	jp BattleCommand_StatUpMessage

BattleCommand_BulkUp:
; bulkup
	call ResetMiss
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage

	call ResetMiss
	call BattleCommand_DefenseUp
	jp BattleCommand_StatUpMessage

BattleCommand_CosmicPower:
; cosmicpower
	call ResetMiss
	call BattleCommand_DefenseUp
	call BattleCommand_StatUpMessage

	call ResetMiss
	call BattleCommand_SpecialDefenseUp
	jp BattleCommand_StatUpMessage

BattleCommand_DragonDance:
	call ResetMiss
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage

	call ResetMiss
	call BattleCommand_SpeedUp
	jp BattleCommand_StatUpMessage

BattleCommand_Growth:
	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .SunBoost

	call ResetMiss
	call BattleCommand_AttackUp
	call BattleCommand_StatUpMessage

	call ResetMiss
	call BattleCommand_SpecialAttackUp
	jp BattleCommand_StatUpMessage

.SunBoost
	call ResetMiss
	call BattleCommand_AttackUp2
	call BattleCommand_StatUpMessage

	call ResetMiss
	call BattleCommand_SpecialAttackUp2
	jp BattleCommand_StatUpMessage
