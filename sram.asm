SRAM_Begin EQU $a000
SRAM_End   EQU $c000
GLOBAL SRAM_Begin, SRAM_End

SECTION "SRAM Bank 0", SRAM [$a000], BANK [0]
sScratch:: ds $310

sBattleTowerPartyBackup:: ds 2 + PARTY_LENGTH * (PARTYMON_STRUCT_LENGTH + 2 * PKMN_NAME_LENGTH + 1)

sBuildNumber:: ds 2

SECTION "RTC", SRAM [$ac60], BANK [0]
sRTCStatusFlags:: ds 8
sLuckyNumberDay:: ds 1
sLuckyIDNumber:: ds 2

SECTION "Backup Save", SRAM [$b200], BANK [0]
sBackupOptions:: ds OptionsEnd - wOptions

s0_b208:: ds 1

sBackupGameData::
sBackupPlayerData::  ds wPlayerDataEnd - wPlayerData
sBackupMapData::     ds wMapDataEnd - wMapData
sBackupPokemonData:: ds wPokemonDataEnd - wPokemonData
sBackupGameDataEnd::

; bd83
	ds $197
; bf0d

sBackupChecksum:: ds 2
s0_bf0f:: ds 1
sStackTop:: ds 2


SECTION "SRAM Bank 1", SRAM [$a000], BANK [1]

sOptions:: ds OptionsEnd - wOptions

s1_a008:: ds 1 ; loaded with 99, used to check save corruption

sGameData::
sPlayerData::  ds wPlayerDataEnd - wPlayerData
sMapData::     ds wMapDataEnd - wMapData
sPokemonData:: ds wPokemonDataEnd - wPokemonData
sGameDataEnd::

; ab83
	ds $197
; ad0d

sChecksum::   ds 2
s1_ad0f::     ds 1 ; loaded with 0x7f, used to check save corruption

; ad10
	box sBox
; b160

	ds $f4
sLinkBattleResults:: ds $c

sLinkBattleStats:: ; b260
sLinkBattleWins::   ds 2
sLinkBattleLosses:: ds 2 ; b262
sLinkBattleDraws::  ds 2 ; b264
link_battle_record: MACRO
\1Name:: ds NAME_LENGTH +- 1
\1ID:: ds 2
\1Wins:: ds 2
\1Losses:: ds 2
\1Draws:: ds 2
endm
sLinkBattleRecord::
sLinkBattleRecord1:: link_battle_record sLinkBattleRecord1
sLinkBattleRecord2:: link_battle_record sLinkBattleRecord2
sLinkBattleRecord3:: link_battle_record sLinkBattleRecord3
sLinkBattleRecord4:: link_battle_record sLinkBattleRecord4
sLinkBattleRecord5:: link_battle_record sLinkBattleRecord5
sLinkBattleStatsEnd::

sHallOfFame:: ; b2c0
; temporary until I can find a way to macrofy it
	hall_of_fame sHallOfFame01
	hall_of_fame sHallOfFame02
	hall_of_fame sHallOfFame03
	hall_of_fame sHallOfFame04
	hall_of_fame sHallOfFame05
	hall_of_fame sHallOfFame06
	hall_of_fame sHallOfFame07
	hall_of_fame sHallOfFame08
	hall_of_fame sHallOfFame09
	hall_of_fame sHallOfFame10
	hall_of_fame sHallOfFame11
	hall_of_fame sHallOfFame12
	hall_of_fame sHallOfFame13
	hall_of_fame sHallOfFame14
	hall_of_fame sHallOfFame15
	hall_of_fame sHallOfFame16
	hall_of_fame sHallOfFame17
	hall_of_fame sHallOfFame18
	hall_of_fame sHallOfFame19
	hall_of_fame sHallOfFame20
	hall_of_fame sHallOfFame21
	hall_of_fame sHallOfFame22
	hall_of_fame sHallOfFame23
	hall_of_fame sHallOfFame24
	hall_of_fame sHallOfFame25
	hall_of_fame sHallOfFame26
	hall_of_fame sHallOfFame27
	hall_of_fame sHallOfFame28
	hall_of_fame sHallOfFame29
	hall_of_fame sHallOfFame30

; x = 1
; rept NUM_HOF_TEAMS
; ; PRINTT("{x}\n")
; if STRLEN({x}) == 2
	; PRINTT(STRSUB({x},2,1))
	; hall_of_fame STRCAT("sHallOfFame0", STRSUB({x},2,1))
; else
	; PRINTT(STRSUB({x},2,2))
	; hall_of_fame STRCAT("sHallOfFame", STRSUB({x},2,2))
; endc
; x = x + 1
; endr
sHallOfFameEnd::

sMobileEventIndex:: ds 1 ; be3c

	ds 7

sMobileEventIndexBackup:: ds 1

; data of the BattleTower must be in SRAM because you can save and leave between battles
sBattleTowerChallengeState:: ds 1
; 0: normal
; 2: battle tower

sBattleTower::
sBT_CurStreak:: ds 1
sBTChoiceOfLvlGroup:: ds 1
sBTOpponentIndices:: ds 7
sBTMonsSelected:: ds 3 * 7
sBT_OTTrainer:: battle_tower_struct sBT_OT
sBT_TrainerTextIndex:: ds 2
sBT_WinStreak:: ds 1
sBattleTowerEnd::

SECTION "Boxes 1-7", SRAM [$a000], BANK [2]
	box sBox1
	box sBox2
	box sBox3
	box sBox4
	box sBox5
	box sBox6
	box sBox7

SECTION "Boxes 8-14", SRAM [$a000], BANK [3]
	box sBox8
	box sBox9
	box sBox10
	box sBox11
	box sBox12
	box sBox13
	box sBox14
