BattleCommand_Spikes: ; 37683
; spikes

	ld hl, wEnemyScreens
	ld a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wPlayerScreens
.okay

; Fails if spikes are already down!

	ld a, [hl]
	and $3
	cp 3
	jr z, .failed

; Nothing else stops it from working.

	inc [hl]

	call AnimateCurrentMove

	ld hl, SpikesText
	jp StdBattleTextBox

.failed
	jp FailSpikes
; 376a0

BattleCommand_LavaPool:
; lavapool
	ld hl, wEnemyScreens
	ld a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wPlayerScreens
.okay
	bit SCREENS_LAVA_POOL, [hl]
	jr nz, .failed
	set SCREENS_LAVA_POOL, [hl]

	call AnimateCurrentMove

	ld hl, LavaPoolText
	jp StdBattleTextBox

.failed
	jp FailLavaPool
