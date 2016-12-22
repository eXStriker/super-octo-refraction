FarCall_Pointer::
; Call a:[hl]
; Preserves other registers
	ld [hBuffer], a
	ld a, [hROMBank]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr FarCall_RetrieveBankAndCallFunction

FarCall_hl::
; Call a:hl
; Preserves other registers
	ld [hBuffer], a
	ld a, [hROMBank]
	push af
	jr FarCall_RetrieveBankAndCallFunction

FarPointerCall_AfterIsInArray::
	inc hl

; fallthrough
FarPointerCall::
	ld a, [hROMBank]
	push af
	ld a, [hli]
	ld [hBuffer], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr FarCall_RetrieveBankAndCallFunction

StackFarCall::
; Call the following dba pointer on the stack
; Preserves a, bc, de, hl
	ld [hFarCallSavedA], a
	ld a, l
	ld [hPredefTemp], a
	ld a, h
	ld [hPredefTemp + 1], a

	pop hl
	ld a, [hli]
	ld [hBuffer], a
	add a
	jr c, .noPush
	inc hl
	inc hl
	push hl
	dec hl
	dec hl
.noPush
	ld a, [hROMBank]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
FarCall_RetrieveBankAndCallFunction:
	ld a, [hBuffer]
	and $7f
	rst Bankswitch
	call RetrieveHLAndCallFunction

ReturnFarCall::
; We want to retain the contents of f.
; To do this, we use tricky kewl stack manip!!11!!1!.
	ld [hBuffer], a
	push af
	push hl
	ld hl, sp + 2 ; flags of a
	ld a, [hli] ; read
	inc l ; inc hl
	ld [hl], a ; and write to the flags of the saved bank
	pop hl
	pop af
	pop af
	rst Bankswitch
	ld a, [hBuffer]
	ret

StackCallInBankB:
	ld a, b
	jr StackCallInBankA

ProtectedBankStackCall:
	ld a, [hROMBank]
	
; fallthrough
StackCallInBankA:
	ld [hBuffer], a
	ld a, h
	ld [hPredefTemp + 1], a
	ld a, l
	ld [hPredefTemp], a
	pop hl
	ld a, [hROMBank]
	push af
	jr FarCall_RetrieveBankAndCallFunction

StackCallInMapScriptHeaderBank::
	ld a, [MapScriptHeaderBank]
	jr StackCallInBankA

SafeStackCallInWramBankA:
	ld [hBuffer], a
	jr StackCallInWRAMBankA_continue

RunFunctionInWRA6::
	ld a, BANK(wDecompressScratch)

StackCallInWRAMBankA:
	ld [hBuffer], a
	ld a, h
	ld [hPredefTemp + 1], a
	ld a, l
	ld [hPredefTemp], a

StackCallInWRAMBankA_continue:
	pop hl
	ld a, [rSVBK]
	push af
	ld a, [hBuffer]
	ld [rSVBK], a
	call RetrieveHLAndCallFunction
	ld [hBuffer], a
	pop af
	ld [rSVBK], a
	ld a, [hBuffer]
	ret

RetrieveHLAndCallFunction:
	push hl
	ld hl, hPredefTemp
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hFarCallSavedA]
	ret

StackCallInVBK1:
	ld a, h
	ld [hPredefTemp + 1], a
	ld a, l
	ld [hPredefTemp], a
SafeStackCallInVBK1:
	pop hl
	ld a, [rVBK]
	push af
	ld a, 1
	ld [rVBK], a
	call RetrieveHLAndCallFunction
	pop af
	ld [rVBK], a
	ret
