ScriptConditional::
	; in: b = condition (0: false, 1: true, 2: less than, 3: greater than, 4: equal, 5: not equal)
	call ScriptCheckCondition
	jr nc, .skip
	call PeekScriptByte
	cp then_command
	ret nz
.done
	jp GetScriptByte
.skip
	call PeekScriptByte
	cp then_command
	jr nz, SkipScriptCommand
	call GetScriptByte
.loop
	call SkipScriptCommand
	call PeekScriptByte
	cp selse_command
	jr z, .done
	cp sendif_command
	jr nz, .loop
	jr .done

ScriptCmdWithArrayArgsSkip:
	call GetScriptHalfword
	ld a, h
	jr CmdWithArrayArgs_ReturnPoint

SkipScriptCommand:
	call PeekScriptByte
SkipScriptCommand_NoPeek:
	srl a
	push af
	ld hl, ScriptCommandSizes
	add a, l
	ld l, a
	jr nc, .no_carry
	inc h
.no_carry
	pop af
	ld a, [hl]
	jr c, .lower_nibble
	swap a
.lower_nibble
	and 15
	jr z, SkipScriptCommand_SpecialSkip
CmdWithArrayArgs_ReturnPoint:
	ld hl, ScriptPos 
	add [hl]
	ld [hli], a
	ret nc
	inc [hl]
	ret
SkipScriptCommand_SpecialSkip:
	call PeekScriptByte
	dec a
	ld hl, VariableSizeScriptCommands
	ld e, 3
	call IsInArray
	jp c, CallLocalPointer_AfterIsInArray
	ld a, 9
	jp Crash ;if we can't find the script command, the script is broken and no valid action can be taken, so crash intentionally

ScriptCheckCondition:
	ld a, [hScriptVar]
	ld c, a
	ld a, b
	cp 2
	jr c, .simple_check
	push af
	call GetScriptByte
	ld b, a
	pop af
.simple_check
	jumptable
	dw .false
	dw .true
	dw .less_than
	dw .greater_than
	dw .equal
	dw .not_equal
.false
	ld a, c
.compare_1
	cp 1
	ret
.true
	xor a
	cp c
	ret
.less_than
	ld a, c
	cp b
	ret
.greater_than
	ld a, b
	cp c
	ret
.equal
	ld a, b
	sub c
	jr .compare_1
.not_equal
	ld a, b
	sub c
	add a, -1
	ret

ScriptCommandSizes:
	;  0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
	dn 3, 4, 3, 3, 4, 3, 4, 4, 3, 3, 4, 4, 2, 2, 4, 2 ;00
	dn 3, 3, 4, 1, 2, 2, 2, 2, 2, 3, 3, 4, 2, 2, 3, 3 ;10
	dn 3, 2, 5, 5, 5, 3, 3, 3, 3, 3, 1, 2, 2, 0, 3, 1 ;20
	dn 1, 3, 3, 3, 3, 3, 3, 1, 1, 4, 3, 5, 3, 2, 2, 3 ;30
	dn 3, 3, 1, 4, 1, 1, 1, 1, 1, 0, 4, 3, 1, 1, 3, 1 ;40
	dn 3, 4, 3, 1, 1, 2, 1, 1, 1, 2, 1, 1, 0, 3, 1, 1 ;50
	dn 2, 2, 2, 5, 1, 1, 1, 2, 4, 3, 1, 3, 3, 2, 2, 3 ;60
	dn 1, 4, 2, 2, 5, 3, 3, 2, 4, 4, 1, 1, 3, 2, 3, 1 ;70
	dn 4, 1, 1, 2, 3, 1, 1, 2, 2, 2, 2, 3, 1, 3, 1, 1 ;80
	dn 2, 1, 3, 3, 2, 1, 3, 1, 2, 2, 2, 4, 3, 3, 4, 1 ;90
	dn 1, 6, 2, 3, 3, 4, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1 ;a0
	dn 2, 1, 2, 0, 3, 2, 3, 3, 3, 1, 1, 3, 1, 2, 1, 0 ;b0
	dn 4, 4, 4, 5, 3, 2, 2, 5, 1, 3, 0, 3, 3, 1, 3, 0 ;c0
	dn 2, 1, 1, 1, 1, 1, 7, 2, 1, 1, 0, 0, 0, 0, 0, 0 ;d0
	dn 2, 2, 2, 4, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;e0
	dn 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;f0

VariableSizeScriptCommands:
	; note: subtracting 1 from the command so we can eventually add a $ff command if it exists
	dbw givepoke_command - 1, ScriptGivePokeCommandSkip
	dbw loadwildmon_command - 1, ScriptLoadWildMonCommandSkip
	dbw siffalse_command - 1, ScriptSimpleConditionalSkip
	dbw siftrue_command - 1, ScriptSimpleConditionalSkip
	dbw sifgt_command - 1, ScriptParameterizedConditionalSkip
	dbw siflt_command - 1, ScriptParameterizedConditionalSkip
	dbw sifeq_command - 1, ScriptParameterizedConditionalSkip
	dbw sifne_command - 1, ScriptParameterizedConditionalSkip
	dbw cmdwitharrayargs_command - 1, ScriptCmdWithArrayArgsSkip
	dbw divideop_command - 1, ScriptDivideOpSkip
	db -1

ScriptGivePokeCommandSkip:
	; if the fourth byte is 0, this command takes up 4 bytes. Otherwise, it takes up 8 bytes.
	call GetScriptWord
	ld a, e
	and a
	ret z
	jp GetScriptWord

ScriptLoadWildMonCommandSkip:
	; if the third byte's upper bit is set, this command takes up 8 bytes. Otherwise, it takes up 3 bytes.
	call GetScriptThreeBytes
	bit 7, e
	ret z
	call GetScriptByte
	jp GetScriptWord

ScriptDivideOpSkip:
	; if the lower 2 bits 2nd byte is less than 2, skip an extra byte
	call GetScriptHalfword
	ld a, h
	and %11
	cp 2
	jp c, GetScriptByte
	ret
	
ScriptSimpleConditionalSkip:
	call GetScriptByte
	jr ScriptConditionalSkip

ScriptParameterizedConditionalSkip:
	call GetScriptHalfword
	; fallthrough

ScriptConditionalSkip:
	call PeekScriptByte
	cp then_command
	jp nz, SkipScriptCommand
	call GetScriptByte
	; fallthrough

ScriptSkipPastEndIf::
	call PeekScriptByte
	cp sendif_command
	jp z, GetScriptByte
	call SkipScriptCommand_NoPeek
	jr ScriptSkipPastEndIf

CreateScriptCommandWithCustomArguments:
	call GetScriptByte ; skip length
	ld hl, wScriptArrayCommandBuffer
	call GetScriptByte
	ld [hli], a ; script command
	push hl
	ld hl, AllowedCustomScriptCommands
	ld e, 4
	call IsInArray
	jr c, .noCrash
	ld [hCrashSavedA], a
	ld a, 10
	jp Crash
.noCrash
	inc hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	call GetScriptByte ; which to substitute with args
	ld b, a
.loop
	ld a, e
	and %11 ; current arg length
	inc a
	srl b
	push bc
	jr c, .useArg
	ld c, a
.writeScriptArgsLoop
	call GetScriptByte
	ld [hli], a
	dec c
	jr nz, .writeScriptArgsLoop
	jr .finishLoop
.useArg
	push de
	push hl
	push af
	callba GetScriptArrayPointer
	ld d, h
	ld e, l
	pop af
	pop hl
	ld c, a
.writeCustomArgsLoop
	ld a, [ScriptBank]
	call GetFarByteDE
	inc de
	ld [hli], a
	dec c
	jr nz, .writeCustomArgsLoop
	pop de
.finishLoop
	pop bc
	srl d
	rr e
	srl d
	rr e
	call ScriptCommandCustomArgsVariableLengthCheck
	jr c, .done
	dec c
	jr nz, .loop
.done
	ld [hl], end_command
	ret

ScriptCommandCustomArgsVariableLengthCheck:
	push hl
	push de
	push bc
	ld hl, ScriptCommandCustomArgs_VariableLengthCommands
	ld e, 3
	ld a, [wScriptArrayCommandBuffer]
	call IsInArray
	pop bc
	push bc
	call c, CallLocalPointer_AfterIsInArray
	pop bc
	pop de
	pop hl
	ret

AllowedCustomScriptCommands:
	customarraycmd givepoke, 6, 1, 1, 1, 1, 2, 2
	customarraycmd takeitem, 2, 1, 1
	customarraycmd giveitem, 2, 1, 1
	customarraycmd warp, 3, 2, 1, 1
	customarraycmd warpmod, 2, 1, 2
	db -1

ScriptCommandCustomArgs_VariableLengthCommands:
	dbw givepoke_command, .GivePokeCheck
	db -1

.GivePokeCheck:
	ld a, c
	cp 3
	ret nz
	ld a, [wScriptArrayCommandBuffer + 4]
	and a
	ret nz
	scf
	ret
