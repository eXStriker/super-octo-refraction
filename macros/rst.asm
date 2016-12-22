FarCall    EQU $08
Bankswitch EQU $10
AddNTimes  EQU $18
Predef     EQU $20
JumpTable  EQU $28
CopyBytes  EQU $30

callba: MACRO ; bank, address
	rst FarCall
	dbw BANK(\1), \1
	ENDM

jpba: MACRO
	rst FarCall
	dbw BANK(\1) | $80, \1
	ENDM

jumptable: MACRO
	rst JumpTable
	if _NARG > 0
	dw \1 | $8000
	endc
	ENDM

bankpushcall: MACRO
	rst FarCall
	db BANK(\1)
	dw \2
	ENDM

bankpushjp: MACRO
	rst FarCall
	db BANK(\1) | $80
	dw \2
	ENDM

anonbankpush: MACRO
	rst FarCall
	db BANK(\1) | $80
	dw .anonPtr\@
.anonPtr\@
	ENDM