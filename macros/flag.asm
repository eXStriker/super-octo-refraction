; define engine flags
; location, bit
def_engine_flag: MACRO
	const \1
\1_ADDRESS EQUS "\2"
\1_BIT EQU \3
ENDM

; define engine flags
; location, bit
engine_flag: MACRO
	dwb \1_ADDRESS, 1 << \1_BIT
ENDM

;\1 = event index
CheckEngine: MACRO
	ld a, [\1_ADDRESS]
	bit \1_BIT, a
ENDM

;\1 = event index
CheckEngineForceReuseA: MACRO
	bit \1_BIT, a
ENDM

;\1 = event index
CheckEngineHL: MACRO
	ld hl, \1_ADDRESS
	bit \1_BIT, [hl]
ENDM

;\1 = event index
CheckEngineForceReuseHL: MACRO
	bit \1_BIT, [hl]
ENDM

;\1 = event index
CheckAndSetEngine: MACRO
	ld hl, \1_ADDRESS
	bit \1_BIT, [hl]
	set \1_BIT, [hl]
ENDM

;\1 = event index
CheckAndResetEngine: MACRO
	ld hl, \1_ADDRESS
	bit \1_BIT, [hl]
	res \1_BIT, [hl]
ENDM

;\1 = event index
CheckAndSetEngineA: MACRO
	ld a, [\1_ADDRESS]
	bit \1_BIT, a
	set \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
CheckAndResetEngineA: MACRO
	ld a, [\1_ADDRESS]
	bit \1_BIT, a
	res \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
CheckAndSetEngineForceReuseHL: MACRO
	bit \1_BIT, [hl]
	set \1_BIT, [hl]
ENDM

;\1 = event index
CheckAndResetEngineForceReuseHL: MACRO
	bit \1_BIT, [hl]
	res \1_BIT, [hl]
ENDM

;\1 = event index
CheckAndSetEngineForceReuseA: MACRO
	bit \1_BIT, a
	set \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
CheckAndResetEngineForceReuseA: MACRO
	bit \1_BIT, a
	res \1_BIT, a
	ld [\1_ADDRESS], a
ENDM

;\1 = event index
SetEngine: MACRO
	ld hl, \1_ADDRESS
	set \1_BIT, [hl]
ENDM

;\1 = event index
SetEngineForceReuseHL: MACRO
	set \1_BIT, [hl]
ENDM

;\1 = event index
ResetEngine: MACRO
	ld hl, \1_ADDRESS
	res \1_BIT, [hl]
ENDM

;\1 = event index
ResetEngineForceReuseHL: MACRO
	res \1_BIT, [hl]
ENDM
