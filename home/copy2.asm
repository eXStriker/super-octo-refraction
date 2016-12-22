CopyDataUntil::
; Copy hl to de until hl == bc

; In other words, the source data is
; from hl up to but not including bc,
; and the destination is de.
	ld a, c
	sub l
	ld c, a
	ld a, b
	sbc h
	ld b, a
	inc bc
	jr _CopyBytes

CopyNthStruct::
	rst AddNTimes
	jr _CopyBytes

FarCopyBytes::
; copy bc bytes from a:hl to de
	call StackCallInBankA

; fallthrough
_CopyBytes::
; copy bc bytes from hl to de
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .handleLoop
.loop
	ld a, [hli]
	ld [de], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

ByteFill::
; fill bc bytes with the value of a, starting at hl
	inc b  ; we bail the moment b hits 0, so include the last run
	inc c  ; same thing; include last byte
	jr .HandleLoop
.PutByte
	ld [hli], a
.HandleLoop
	dec c
	jr nz, .PutByte
	dec b
	jr nz, .PutByte
	ret

GetFarByteDE::
	push hl
	ld h, d
	ld l, e
	call GetFarByte
	pop hl
	ret

GetFarByte::
; retrieve a single byte from a:hl, and return it in a.
	; bankswitch to new bank
	call StackCallInBankA
.Function:
	ld a, [hl]
	ret

GetFarWRAMByte::
	call StackCallInWRAMBankA
.Function:
	ld a, [hl]
	ret

GetFarByteHalfword::
; retrieve a byte + halfword combination from a:hl and return in a:hl
	call StackCallInBankA
.Function:
	ld a, [hli]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ret

GetFarHalfword::
; retrieve a halfword from a:hl, and return it in hl.
	call StackCallInBankA
.Function:
	jr GetFarHalfword_read

GetFarWRAMWord::
	call StackCallInWRAMBankA
GetFarHalfword_read:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

FarCopyWRAM::
	call StackCallInWRAMBankA

.Function:
	rst CopyBytes
	ret

DoubleFarCopyWRAM::
; low nybble of a: source bank
; high nybble of a: dest bank
; hl: source addr
; de: dest addr
; bc: copy size
	ld [hBuffer], a
	and $f
	ld [hBuffer2], a
	ld a, [hBuffer]
	swap a
	and $f
	ld [hBuffer3], a
; hBuffer2 = source
; hBuffer3 = dest

	ld a, [rSVBK]
	push af
	inc b
	inc c
	dec c
	jr nz, .noDecB
	dec b
.noDecB
	ld a, b
	ld [hLoopCounter], a
.loop
	ld a, [hBuffer2]
	ld [rSVBK], a
	ld a, [hli]
	ld b, a
	ld a, [hBuffer3]
	ld [rSVBK], a
	ld a, b
	ld [de], a
	inc de
.handleLoop
	dec c
	jr nz, .loop
	ld a, [hLoopCounter]
	dec a
	ld [hLoopCounter], a
	jr nz, .loop

	pop af
	ld [rSVBK], a
	ret