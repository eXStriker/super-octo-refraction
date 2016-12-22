MAX_LEVEL EQU 100
MIN_LEVEL EQU 2
EGG_LEVEL EQU 1
NUM_MOVES EQU 4

REST_TURNS EQU 2
MAX_STAT_LEVEL EQU 13
BASE_STAT_LEVEL EQU 7

	const_def
	const ATTACK ;0
	const DEFENSE ;1
	const SPEED ;2
	const SP_ATTACK ; 3
	const SP_DEFENSE ;4
	const ACCURACY ;5
	const EVASION ;6
	const ABILITY
NUM_LEVEL_STATS EQU const_value

; move struct
	const_def
	const MOVE_ANIM
	const MOVE_EFFECT
	const MOVE_POWER
	const MOVE_TYPE
	const MOVE_ACC
	const MOVE_PP
	const MOVE_CHANCE
	const MOVE_LENGTH

; stat constants
const_value SET 1
	const STAT_HP
	const STAT_ATK
	const STAT_DEF
	const STAT_SPD
	const STAT_SATK
	const STAT_SDEF
NUM_STATS EQU const_value
STAT_MIN_NORMAL EQU 5
STAT_MIN_HP EQU 10

; shiny dvs
ATKDEFDV_SHINY EQU $EA
SPDSPCDV_SHINY EQU $AA

; battle classes
const_value SET 1
	const WILD_BATTLE
	const TRAINER_BATTLE

; battle types
	const_def
	const BATTLETYPE_NORMAL
	const BATTLETYPE_CANLOSE
	const BATTLETYPE_DEBUG
	const BATTLETYPE_TUTORIAL
	const BATTLETYPE_FISH
	const BATTLETYPE_ROAMING
	const BATTLETYPE_UNUSED_1
	const BATTLETYPE_SHINY
	const BATTLETYPE_TREE
	const BATTLETYPE_TRAP
	const BATTLETYPE_FORCEITEM
	const BATTLETYPE_CELEBI
	const BATTLETYPE_SUICUNE

; battle variables
	const_def
	const BATTLE_VARS_SUBSTATUS1
	const BATTLE_VARS_SUBSTATUS2
	const BATTLE_VARS_SUBSTATUS3
	const BATTLE_VARS_SUBSTATUS4
	const BATTLE_VARS_SUBSTATUS5
	const BATTLE_VARS_SUBSTATUS1_OPP
	const BATTLE_VARS_SUBSTATUS2_OPP
	const BATTLE_VARS_SUBSTATUS3_OPP
	const BATTLE_VARS_SUBSTATUS4_OPP
	const BATTLE_VARS_SUBSTATUS5_OPP
	const BATTLE_VARS_STATUS
	const BATTLE_VARS_STATUS_OPP
	const BATTLE_VARS_SEMISTATUS
	const BATTLE_VARS_SEMISTATUS_OPP
	const BATTLE_VARS_MOVE_ANIM
	const BATTLE_VARS_MOVE_EFFECT
	const BATTLE_VARS_MOVE_POWER
	const BATTLE_VARS_MOVE_TYPE
	const BATTLE_VARS_MOVE
	const BATTLE_VARS_LAST_COUNTER_MOVE
	const BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	const BATTLE_VARS_LAST_MOVE
	const BATTLE_VARS_LAST_MOVE_OPP

; status
const_value SET 3
	const PSN
	const BRN
	const FRZ
	const PAR
	const SLP ; 7 turns

ALL_STATUS EQU (1 << PSN) + (1 << BRN) + (1 << FRZ) + (1 << PAR) + SLP
SEMISTATUS_TOXIC EQU 0

; substatus
	enum_start 7, -1
	enum SUBSTATUS_IN_LOVE
	enum SUBSTATUS_ROLLOUT
	enum SUBSTATUS_ENDURE
	enum SUBSTATUS_PERISH
	enum SUBSTATUS_IDENTIFIED
	enum SUBSTATUS_PROTECT
	enum SUBSTATUS_CURSE
	enum SUBSTATUS_NIGHTMARE

	enum_start 6, -1
	enum SUBSTATUS_STURDY
	enum SUBSTATUS_UNBURDEN
	enum SUBSTATUS_FLASH_FIRE
	enum SUBSTATUS_TRACED
	enum SUBSTATUS_GUARDING
	enum SUBSTATUS_FINAL_CHANCE
	enum SUBSTATUS_CURLED

	enum_start 7, -1
	enum SUBSTATUS_CONFUSED
	enum SUBSTATUS_FLYING
	enum SUBSTATUS_UNDERGROUND
	enum SUBSTATUS_CHARGED
	enum SUBSTATUS_FLINCHED
	enum SUBSTATUS_IN_LOOP
	enum SUBSTATUS_RAMPAGE
	; enum SUBSTATUS_BIDE

	enum_start 7, -1
	enum SUBSTATUS_LEECH_SEED
	enum SUBSTATUS_RAGE
	enum SUBSTATUS_RECHARGE
	enum SUBSTATUS_SUBSTITUTE
	enum SUBSTATUS_UNKNOWN_1
	enum SUBSTATUS_FOCUS_ENERGY
	enum SUBSTATUS_MIST
	enum SUBSTATUS_X_ACCURACY

	enum_start 7, -1
	enum SUBSTATUS_CANT_RUN
	enum SUBSTATUS_DESTINY_BOND
	enum SUBSTATUS_LOCK_ON
	enum SUBSTATUS_ENCORED
	enum SUBSTATUS_TRANSFORMED
	enum SUBSTATUS_UNKNOWN_2
	enum SUBSTATUS_UNKNOWN_3

; environmental
	enum_start 5, -1
	enum SCREENS_LAVA_POOL
	enum SCREENS_REFLECT
	enum SCREENS_LIGHT_SCREEN
	enum SCREENS_SAFEGUARD
	enum SCREENS_UNUSED
	enum SCREENS_SPIKES

; weather
	const_def
	const WEATHER_NONE
	const WEATHER_RAIN
	const WEATHER_SUN
	const WEATHER_SANDSTORM
	const WEATHER_HAIL

; move effects
	const_def
	const EFFECT_NORMAL_HIT         ; 00
	const EFFECT_SLEEP              ; 01
	const EFFECT_POISON_HIT         ; 02
	const EFFECT_LEECH_HIT          ; 03
	const EFFECT_BURN_HIT           ; 04
	const EFFECT_FREEZE_HIT         ; 05
	const EFFECT_PARALYZE_HIT       ; 06
	const EFFECT_EXPLOSION          ; 07
	const EFFECT_DREAM_EATER        ; 08
	const EFFECT_MIRROR_MOVE        ; 09
	const EFFECT_ATTACK_UP          ; 0a
	const EFFECT_DEFENSE_UP         ; 0b
	const EFFECT_SPEED_UP           ; 0c
	const EFFECT_SP_ATK_UP          ; 0d
	const EFFECT_SP_DEF_UP          ; 0e
	const EFFECT_ACCURACY_UP        ; 0f
	const EFFECT_EVASION_UP         ; 10
	const EFFECT_ALWAYS_HIT         ; 11
	const EFFECT_ATTACK_DOWN        ; 12
	const EFFECT_DEFENSE_DOWN       ; 13
	const EFFECT_SPEED_DOWN         ; 14
	const EFFECT_SP_ATK_DOWN        ; 15
	const EFFECT_SP_DEF_DOWN        ; 16
	const EFFECT_ACCURACY_DOWN      ; 17
	const EFFECT_EVASION_DOWN       ; 18
	const EFFECT_HAZE               ; 19
	const EFFECT_RAMPAGE            ; 1a
	const EFFECT_WHIRLWIND          ; 1b
	const EFFECT_MULTI_HIT          ; 1c
	const EFFECT_CONVERSION         ; 1d
	const EFFECT_FLINCH_HIT         ; 1e
	const EFFECT_HEAL               ; 1f
	const EFFECT_TOXIC              ; 20
	const EFFECT_DUMMY_5            ; 21
	const EFFECT_LIGHT_SCREEN       ; 22
	const EFFECT_TRI_ATTACK         ; 23
	const EFFECT_HURRICANE          ; 24
	const EFFECT_DUMMY_1            ; 25
	const EFFECT_RAZOR_WIND         ; 26
	const EFFECT_DUMMY_4            ; 27
	const EFFECT_STATIC_DAMAGE      ; 28
	const EFFECT_BIND               ; 29
	const EFFECT_TORNADO            ; 2a
	const EFFECT_DOUBLE_HIT         ; 2b
	const EFFECT_JUMP_KICK          ; 2c
	const EFFECT_MIST               ; 2d
	const EFFECT_FOCUS_ENERGY       ; 2e
	const EFFECT_RECOIL_HIT         ; 2f
	const EFFECT_CONFUSE            ; 30
	const EFFECT_ATTACK_UP_2        ; 31
	const EFFECT_DEFENSE_UP_2       ; 32
	const EFFECT_SPEED_UP_2         ; 33
	const EFFECT_SP_ATK_UP_2        ; 34
	const EFFECT_SP_DEF_UP_2        ; 35
	const EFFECT_ACCURACY_UP_2      ; 36
	const EFFECT_EVASION_UP_2       ; 37
	const EFFECT_TRANSFORM          ; 38
	const EFFECT_ATTACK_DOWN_2      ; 39
	const EFFECT_DEFENSE_DOWN_2     ; 3a
	const EFFECT_SPEED_DOWN_2       ; 3b
	const EFFECT_SP_ATK_DOWN_2      ; 3c
	const EFFECT_SP_DEF_DOWN_2      ; 3d
	const EFFECT_ACCURACY_DOWN_2    ; 3e
	const EFFECT_EVASION_DOWN_2     ; 3f
	const EFFECT_REFLECT            ; 40
	const EFFECT_POISON             ; 41
	const EFFECT_PARALYZE           ; 42
	const EFFECT_ATTACK_DOWN_HIT    ; 43
	const EFFECT_DEFENSE_DOWN_HIT   ; 44
	const EFFECT_SPEED_DOWN_HIT     ; 45
	const EFFECT_SP_ATK_DOWN_HIT    ; 46
	const EFFECT_SP_DEF_DOWN_HIT    ; 47
	const EFFECT_ACCURACY_DOWN_HIT  ; 48
	const EFFECT_EVASION_DOWN_HIT   ; 49
	const EFFECT_SKY_ATTACK         ; 4a
	const EFFECT_CONFUSE_HIT        ; 4b
	const EFFECT_TWINEEDLE          ; 4c
	const EFFECT_METEOR_MASH        ; 4d
	const EFFECT_SUBSTITUTE         ; 4e
	const EFFECT_HYPER_BEAM         ; 4f
	const EFFECT_RAGE               ; 50
	const EFFECT_METRONOME          ; 51
	const EFFECT_LEECH_SEED         ; 52
	const EFFECT_SPLASH             ; 53
	const EFFECT_DISABLE            ; 54
	const EFFECT_LEVEL_DAMAGE       ; 55
	const EFFECT_PSYWAVE            ; 56
	const EFFECT_COUNTER            ; 57
	const EFFECT_ENCORE             ; 58
	const EFFECT_DUMMY_2            ; 59
	const EFFECT_CONVERSION2        ; 5a
	const EFFECT_LOCK_ON            ; 5b
	const EFFECT_DEFROST_OPPONENT   ; 5c
	const EFFECT_SLEEP_TALK         ; 5d
	const EFFECT_DESTINY_BOND       ; 5e
	const EFFECT_REVERSAL           ; 5f
	const EFFECT_SPITE              ; 60
	const EFFECT_FALSE_SWIPE        ; 61
	const EFFECT_HEAL_BELL          ; 62
	const EFFECT_PRIORITY_HIT       ; 63
	const EFFECT_DUMMY_3            ; 64
	const EFFECT_THIEF              ; 65
	const EFFECT_MEAN_LOOK          ; 66
	const EFFECT_NIGHTMARE          ; 67
	const EFFECT_FLAME_WHEEL        ; 68
	const EFFECT_CURSE              ; 69
	const EFFECT_WILL_O_WISP ; new  ; 6a
	const EFFECT_PROTECT            ; 6b
	const EFFECT_SPIKES             ; 6c
	const EFFECT_FORESIGHT          ; 6d
	const EFFECT_PERISH_SONG        ; 6e
	const EFFECT_SANDSTORM          ; 6f
	const EFFECT_ENDURE             ; 70
	const EFFECT_ROLLOUT            ; 71
	const EFFECT_SWAGGER            ; 72
	const EFFECT_FURY_CUTTER        ; 73
	const EFFECT_ATTRACT            ; 74
	const EFFECT_RETURN             ; 75
	const EFFECT_DUMMY_9            ; 76
	const EFFECT_FRUSTRATION        ; 77
	const EFFECT_SAFEGUARD          ; 78
	const EFFECT_SACRED_FIRE        ; 79
	const EFFECT_MAGNITUDE          ; 7a
	const EFFECT_BATON_PASS         ; 7b
	const EFFECT_PURSUIT            ; 7c
	const EFFECT_RAPID_SPIN         ; 7d
	const EFFECT_CALM_MIND ; new    ; 7e
	const EFFECT_BULK_UP ; new      ; 7f
	const EFFECT_MORNING_SUN        ; 80
	const EFFECT_SYNTHESIS          ; 81
	const EFFECT_MOONLIGHT          ; 82
	const EFFECT_HIDDEN_POWER       ; 83
	const EFFECT_RAIN_DANCE         ; 84
	const EFFECT_SUNNY_DAY          ; 85
	const EFFECT_STEEL_WING         ; 86
	const EFFECT_METAL_CLAW         ; 87
	const EFFECT_ANCIENTPOWER       ; 88
	const EFFECT_DUMMY_8            ; 89
	const EFFECT_DUMMY_6            ; 8a
	const EFFECT_DUMMY_7            ; 8b
	const EFFECT_TWISTER            ; 8c
	const EFFECT_EARTHQUAKE         ; 8d
	const EFFECT_FUTURE_SIGHT       ; 8e
	const EFFECT_GUST               ; 8f
	const EFFECT_STOMP              ; 90
	const EFFECT_SOLARBEAM          ; 91
	const EFFECT_THUNDER            ; 92
	const EFFECT_TELEPORT           ; 93
	const EFFECT_FLY                ; 95
	const EFFECT_DEFENSE_CURL       ; 96
	const EFFECT_COSMIC_POWER       ; 97
	const EFFECT_HAIL               ; 98
	const EFFECT_FINAL_CHANCE       ; 99
	const EFFECT_METALLURGY         ; 9a
	const EFFECT_VAPORIZE           ; 9b
	const EFFECT_PRISM_SPRAY        ; 9c
	const EFFECT_SPRING_BUDS        ; 9d
	const EFFECT_LAVA_POOL          ; 9e
	const EFFECT_FREEZE_BURN        ; 9f
	const EFFECT_NATURE_POWER       ; a0
	const EFFECT_FLARE_BLITZ        ; a1
	const EFFECT_PAIN_SPLIT         ; a2
	const EFFECT_BELLY_DRUM         ; a3
	const EFFECT_DRAGON_DANCE       ; a4
	const EFFECT_GROWTH             ; a5
	const EFFECT_LAUGHING_GAS       ; a6

; Battle vars used in home/battle.asm
	const_def
	const PLAYER_SUBSTATUS_1
	const ENEMY_SUBSTATUS_1
	const PLAYER_SUBSTATUS_2
	const ENEMY_SUBSTATUS_2
	const PLAYER_SUBSTATUS_3
	const ENEMY_SUBSTATUS_3
	const PLAYER_SUBSTATUS_4
	const ENEMY_SUBSTATUS_4
	const PLAYER_SUBSTATUS_5
	const ENEMY_SUBSTATUS_5
	const PLAYER_STATUS
	const ENEMY_STATUS
	const PLAYER_SEMISTATUS
	const ENEMY_SEMISTATUS
	const PLAYER_MOVE_ANIMATION
	const ENEMY_MOVE_ANIMATION
	const PLAYER_MOVE_EFFECT
	const ENEMY_MOVE_EFFECT
	const PLAYER_MOVE_POWER
	const ENEMY_MOVE_POWER
	const PLAYER_MOVE_TYPE
	const ENEMY_MOVE_TYPE
	const PLAYER_CUR_MOVE
	const ENEMY_CUR_MOVE
	const PLAYER_COUNTER_MOVE
	const ENEMY_COUNTER_MOVE
	const PLAYER_LAST_MOVE
	const ENEMY_LAST_MOVE
	const PLAYER_ABILITY
	const ENEMY_ABILITY

; wBattleAction
	const_def
	const BATTLEACTION_MOVE1
	const BATTLEACTION_MOVE2
	const BATTLEACTION_MOVE3
	const BATTLEACTION_MOVE4
	const BATTLEACTION_SWITCH1
	const BATTLEACTION_SWITCH2
	const BATTLEACTION_SWITCH3
	const BATTLEACTION_SWITCH4
	const BATTLEACTION_SWITCH5
	const BATTLEACTION_SWITCH6
	const BATTLEACTION_A
	const BATTLEACTION_B
	const BATTLEACTION_C
	const BATTLEACTION_D
	const BATTLEACTION_E
	const BATTLEACTION_FORFEIT

	const_def
	const WIN
	const LOSE
	const DRAW
