Function84000:
	ld hl, OverworldMap
	ld bc, $40c
	xor a
	call ByteFill
	xor a
	ld [rSB], a
	ld [rSC], a
	ld [wPrinterDataJumptableIndex], a
	ld hl, wc2d4
	set 0, [hl]
	ld a, [GBPrinter]
	ld [wcbfb], a
	xor a
	ld [wJumptableIndex], a
	ret

PrinterFunctionJumptable:
	dw Function84077
	dw Function84143
	dw PrinterDelaySix
	dw Function84099
	dw ContinuePrintingIfNoError
	dw Function8412e
	dw Function840c5
	dw ContinuePrintingIfNoError
	dw PrinterDelaySix
	dw Function840de
	dw ContinuePrintingIfNoError
	dw PrinterDelaySix
	dw CheckPrintFinishedNormally
	dw DonePrinting
	dw IncrementJumptableIndex
	dw PrinterDelaySix
	dw Function84103
	dw SetJumptableIndexToOne
	dw FinalizePrinting
	dw _FinalizePrinting


IncrementJumptableIndex:
	ld hl, wJumptableIndex
	inc [hl]
	ret

DecrementJumptableIndex:
	ld hl, wJumptableIndex
	dec [hl]
	ret

DonePrinting:
	xor a
	ld [wPrinterStatus2], a
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

SetJumptableIndexToOne:
	ld a, $1
	ld [wJumptableIndex], a
	ret

Function84077:
	call ClearAllPrinterData
	ld hl, Unknown_842b7
	call CopyIntoPrinterData
	xor a
	ld [wca8e], a
	ld [wca8f], a
	ld a, [wcf65]
	ld [wca81], a
	call IncrementJumptableIndex
	call Function841c3
	ld a, $1
	ld [wPrinterTextIndex], a
	ret

Function84099:
	call ClearAllPrinterData
	ld hl, wca81
	ld a, [hl]
	and a
	jr z, Function840c5
	ld hl, Unknown_842c3
	call CopyIntoPrinterData
	call Function84260
	ld a, $80
	ld [wca8e], a
	ld a, $2
	ld [wca8f], a
	call Function84219
	call IncrementJumptableIndex
	call Function841c3
	ld a, $2
	ld [wPrinterTextIndex], a
	ret

Function840c5:
	ld a, $6
	ld [wJumptableIndex], a
	ld hl, Unknown_842c9
	call CopyIntoPrinterData
	xor a
	ld [wca8e], a
	ld [wca8f], a
	call IncrementJumptableIndex
	jp Function841c3

Function840de:
	call ClearAllPrinterData
	ld hl, Unknown_842bd
	call CopyIntoPrinterData
	call Function84249
	ld a, $4
	ld [wca8e], a
	xor a
	ld [wca8f], a
	call Function84219
	call IncrementJumptableIndex
	call Function841c3
	ld a, $3
	ld [wPrinterTextIndex], a
	ret

Function84103:
	call ClearAllPrinterData
	ld hl, Unknown_842b7
	call CopyIntoPrinterData
	xor a
	ld [wca8e], a
	ld [wca8f], a
	ld a, [wcf65]
	ld [wca81], a
	call IncrementJumptableIndex
	jp Function841c3

PrinterDelaySix:
	ld hl, wPrinterDelay
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	jp IncrementJumptableIndex

Function8412e:
	ld hl, wPrinterDelay
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	ld hl, wca81
	dec [hl]
	call DecrementJumptableIndex
	jp DecrementJumptableIndex

Function84143:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatus1]
	cp $ff
	jr nz, .printer_connected
	ld a, [wPrinterStatus2]
	cp $ff
	jr z, .printer_error

.printer_connected
	ld a, [wPrinterStatus1]
	cp $81
	jr nz, .printer_error
	ld a, [wPrinterStatus2]
	and a
	jr nz, .printer_error
	ld hl, wc2d4
	set 1, [hl]
	ld a, $5
	ld [wca8a], a
	jp IncrementJumptableIndex

.printer_error
	ld a, $ff
	ld [wPrinterStatus1], a
	ld [wPrinterStatus2], a
	ld a, $e
	ld [wJumptableIndex], a
	ret

ContinuePrintingIfNoError:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatus2]
	and $f0
	jr nz, .printer_error
	ld a, [wPrinterStatus2]
	and $1
	jr nz, .printer_done
	jp IncrementJumptableIndex
.printer_done
	jp DecrementJumptableIndex
.printer_error
	ld a, $12
	ld [wJumptableIndex], a
	ret

CheckPrintFinishedNormally:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatus2]
	and $f3
	ret nz
	jp IncrementJumptableIndex

FinalizePrinting:
	call IncrementJumptableIndex
	; fallthrough

_FinalizePrinting:
	ld a, [wPrinterDataJumptableIndex]
	and a
	ret nz
	ld a, [wPrinterStatus2]
	and $f0
	ret nz
	xor a
	ld [wJumptableIndex], a
	ret

Function841c3:
	ld a, [wPrinterDataJumptableIndex]
	and a
	jr nz, Function841c3
	xor a
	ld [wca8c], a
	ld [wca8d], a
	ld a, $1
	ld [wPrinterDataJumptableIndex], a
	ld a, $88
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

CopyIntoPrinterData:
	ld a, [hli]
	ld [wPrinterData1], a
	ld a, [hli]
	ld [wPrinterData2], a
	ld a, [hli]
	ld [wPrinterData3], a
	ld a, [hli]
	ld [wPrinterData4], a
	ld a, [hli]
	ld [wPrinterData5], a
	ld a, [hl]
	ld [wPrinterData6], a
	ret

ClearAllPrinterData:
	xor a
	ld hl, wPrinterData1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wca8e], a
	ld [wca8f], a
	ld hl, OverworldMap
	ld bc, $280
	jp ByteFill

Function84219:
	ld hl, 0
	ld bc, $4
	ld de, wPrinterData1
	call Function8423c
	ld a, [wca8e]
	ld c, a
	ld a, [wca8f]
	ld b, a
	ld de, OverworldMap
	call Function8423c
	ld a, l
	ld [wPrinterData5], a
	ld a, h
	ld [wPrinterData6], a
	ret

Function8423c:
	ld a, [de]
	inc de
	add l
	jr nc, .asm_84242
	inc h
.asm_84242
	ld l, a
	dec bc
	ld a, c
	or b
	jr nz, Function8423c
	ret

Function84249:
	ld a, $1
	ld [OverworldMap], a
	ld a, [wcbfa]
	ld [wc801], a
	ld a, $e4
	ld [wc802], a
	ld a, [wcbfb]
	ld [wc803], a
	ret

Function84260:
	ld a, [wca81]
	xor $ff
	ld d, a
	ld a, [wcf65]
	inc a
	add d
	ld hl, wca90
	ld de, $28
.asm_84271
	and a
	jr z, .asm_84278
	add hl, de
	dec a
	jr .asm_84271
.asm_84278
	ld e, l
	ld d, h
	ld hl, OverworldMap
	ld c, $28
.asm_8427f
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $f
	ld d, a
	and $8
	ld a, d
	jr nz, .asm_84297
	or $90
	jr .asm_84299
.asm_84297
	or $80
.asm_84299
	ld d, a
	lb bc, $21, 1
	call Request2bpp
	pop hl
	ld de, $10
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .asm_8427f
	ret

Unknown_842b7: db  1, 0, $00, 0,  1, 0
Unknown_842bd: db  2, 0, $04, 0,  0, 0
Unknown_842c3: db  4, 0, $80, 2,  0, 0
Unknown_842c9: db  4, 0, $00, 0,  4, 0
Unknown_842cf: db  8, 0, $00, 0,  8, 0 ; unused
Unknown_842d5: db 15, 0, $00, 0, 15, 0 ; unused


_PrinterReceive::
	ld a, [wPrinterDataJumptableIndex]
	jumptable

.Jumptable

	dw PrinterReceiveNop
	dw PrinterSend33
	dw PrinterSendData1
	dw PrinterSendData2
	dw PrinterSendData3
	dw PrinterSendData4
	dw Function84361
	dw PrinterSendData5
	dw PrinterSendData6
	dw PrinterSendZero
	dw PrinterReceiveStatus1
	dw PrinterGetStatusAndStop
	dw PrinterSend33
	dw PrinterSend0F
	dw PrinterSendZero
	dw PrinterSendZero
	dw PrinterSendZero
	dw PrinterSend0F
	dw PrinterSendZero
	dw PrinterSendZero
	dw PrinterReceiveStatus1
	dw PrinterGetStatusAndStop
	dw PrinterSend33
	dw PrinterSend08
	dw PrinterSendZero
	dw PrinterSendZero
	dw PrinterSendZero
	dw PrinterSend08
	dw PrinterSendZero
	dw PrinterSendZero
	dw PrinterReceiveStatus1
	dw PrinterGetStatusAndStop


PrinterReceiveIncrementIndex:
	ld hl, wPrinterDataJumptableIndex
	inc [hl]
PrinterReceiveNop:
	ret

PrinterSend33:
	ld a, $33
	jr PrinterSendIncrement

PrinterSendData1:
	ld a, [wPrinterData1]
	jr PrinterSendIncrement

PrinterSendData2:
	ld a, [wPrinterData2]
	jr PrinterSendIncrement

PrinterSendData3:
	ld a, [wPrinterData3]
	jr PrinterSendIncrement

PrinterSendData4:
	ld a, [wPrinterData4]
	jr PrinterSendIncrement

Function84361:
	ld hl, wca8e
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	jr z, .asm_84388
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
	ld a, [wca8c]
	ld e, a
	ld a, [wca8d]
	ld d, a
	ld hl, OverworldMap
	add hl, de
	inc de
	ld a, e
	ld [wca8c], a
	ld a, d
	ld [wca8d], a
	ld a, [hl]
	jp PrinterSendByte
.asm_84388
	call PrinterReceiveIncrementIndex
	; fallthrough

PrinterSendData5:
	ld a, [wPrinterData5]
	jr PrinterSendIncrement

PrinterSendData6:
	ld a, [wPrinterData6]
	jr PrinterSendIncrement

PrinterReceiveStatus1:
	ld a, [rSB]
	ld [wPrinterStatus1], a
PrinterSendZero:
	xor a
	jr PrinterSendIncrement

PrinterSend0F:
	ld a, $f
	jr PrinterSendIncrement

PrinterSend08:
	ld a, $8
PrinterSendIncrement:
	call PrinterSendByte
	jp PrinterReceiveIncrementIndex

PrinterSendByte:
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

PrinterGetStatusAndStop:
	ld a, [rSB]
	ld [wPrinterStatus2], a
	xor a
	ld [wPrinterDataJumptableIndex], a
	ret

Function84559:
	call PrinterClearJoypad
	; fallthrough

Function843f0:
.asm_843f0
	call JoyTextDelay
	call Function846f6
	jr c, .asm_8440f
	ld a, [wJumptableIndex]
	bit 7, a
	jr nz, .asm_8440d
	jumptable PrinterFunctionJumptable
	call CheckPrinterError
	call ShowPrinterStatus
	call DelayFrame
	jr .asm_843f0

.asm_8440d
	and a
	ret

.asm_8440f
	scf
	ret

ResetPrinterControlData:
	xor a
	ld [wc2d4], a
	ld [wPrinterDataJumptableIndex], a
	ret

Function84425:
	call ReturnToMapFromSubmenu
	jp RestartMapMusic

PrintDexEntry:
	ld a, [wcf65]
	push af
	ld hl, VTiles1
	ld de, FontInversed
	lb bc, BANK(FontInversed), $80
	call Request1bpp
	xor a
	ld [hPrinter], a
	call PlayPrinterMusic
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	call Function84000
	ld a, $10
	ld [wcbfa], a
	callba PrintPage1
	call ClearTileMap
	ld a, $e4
	call DmgToCgbBGPals
	call DelayFrame
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $8
	ld [wcf65], a
	call PrinterClearJoypad
	call Function843f0
	jr c, .asm_8449d
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	call Function84000
	ld a, $3
	ld [wcbfa], a
	callba PrintPage2
	call PrinterClearJoypad
	ld a, $4
	ld [wcf65], a
	call Function843f0

.asm_8449d
	pop af
	ld [hVBlank], a
	call ResetPrinterControlData
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	ld c, $8
.asm_844ae
	call LowVolume
	call DelayFrame
	dec c
	jr nz, .asm_844ae
	pop af
	ld [wcf65], a
	ret

PrintPCBox:
	ld a, [wcf65]
	push af
	ld a, $9
	ld [wcf65], a
	ld a, e
	ld [wd004], a
	ld a, d
	ld [wd005], a
	ld a, b
	ld [wd006], a
	ld a, c
	ld [wd007], a
	xor a
	ld [hPrinter], a
	ld [wd003], a
	call PlayPrinterMusic
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	xor a
	ld [hBGMapMode], a
	call Function84817
	ld a, $10
	call Function84419
	call Function84559
	jr c, .asm_84545
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	call Function8486f
	xor a
	call Function84419
	call Function84559
	jr c, .asm_84545
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	call Function84893
	xor a
	call Function84419
	call Function84559
	jr c, .asm_84545
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	call Function848b7
	ld a, $3
	call Function84419
	call Function84559
.asm_84545
	pop af
	ld [hVBlank], a
	call ResetPrinterControlData
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	pop af
	ld [wcf65], a
	ret

Function845db:
	ld a, [wcf65]
	push af
	xor a
	ld [hPrinter], a
	call PlayPrinterMusic
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	xor a
	ld [hBGMapMode], a
	ld a, $13
	call Function84419
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $9
	ld [wcf65], a
	call Function843f0
	pop af
	ld [hVBlank], a
	call ResetPrinterControlData
	call Function84735
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	pop af
	ld [wcf65], a
	ret

Function16dac:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " "
	call ByteFill
	hlcoord 7, 11
	ld a, $31
	ld [hGraphicStartTile], a
	lb bc, 7, 7
	predef_jump PlaceGraphic

PrintPartymon:
	ld a, [wcf65]
	push af
	xor a
	ld [hPrinter], a
	call PlayPrinterMusic
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	xor a
	ld [hBGMapMode], a
	callba Function1dc381
	ld a, $10
	call Function84419
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $8
	ld [wcf65], a
	call PrinterClearJoypad
	call Function843f0
	jr c, .asm_84671
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	callba Function1dc47b
	ld a, $3
	call Function84419
	ld a, $9
	ld [wcf65], a
	call PrinterClearJoypad
	call Function843f0

.asm_84671
	pop af
	ld [hVBlank], a
	call ResetPrinterControlData
	call Function84735
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	pop af
	ld [wcf65], a
	ret

_PrintDiploma:
	ld a, [wcf65]
	push af
	callba Function1dd709
	xor a
	ld [hPrinter], a
	call PlayPrinterMusic
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $10
	call Function84419
	call PrinterClearJoypad
	ld a, $9
	ld [wcf65], a
	call Function843f0
	jr c, .asm_846e2
	call ResetPrinterControlData
	ld c, 12
	call DelayFrames
	call LoadTileMapToTempTileMap
	xor a
	ld [hBGMapMode], a
	callba Function1dd7ae
	ld a, $3
	call Function84419
	call Call_LoadTempTileMapToTileMap
	call PrinterClearJoypad
	ld a, $9
	ld [wcf65], a
	call Function843f0

.asm_846e2
	pop af
	ld [hVBlank], a
	call ResetPrinterControlData
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	pop af
	ld [wcf65], a
	ret

Function846f6:
	ld a, [hJoyDown]
	and B_BUTTON
	jr nz, .asm_846fe
	and a
	ret

.asm_846fe
	ld a, [wca80]
	cp $c
	jr nz, .asm_84722
.asm_84705
	ld a, [wPrinterDataJumptableIndex]
	and a
	jr nz, .asm_84705
	ld a, $16
	ld [wPrinterDataJumptableIndex], a
	ld a, $88
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_8471c
	ld a, [wPrinterDataJumptableIndex]
	and a
	jr nz, .asm_8471c

.asm_84722
	ld a, $1
	ld [hPrinter], a
	scf
	ret

Function84419:
	push af
	call Function84000
	pop af
	ld [wcbfa], a
	; fallthrough

Function84728:
	hlcoord 0, 0
	ld de, wca90
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst CopyBytes
	ret

Function84735:
	ld hl, wca90
	decoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst CopyBytes
	ret

PrinterClearJoypad:
	xor a
	ld [hJoyReleased], a
	ld [hJoyPressed], a
	ld [hJoyDown], a
	ld [hJoyLast], a
	ret

PlayPrinterMusic:
	ld de, MUSIC_PRINTER
	jp PlayMusic2

CheckPrinterError:
	ld a, [wPrinterStatus1]
	inc a
	jr nz, .printer_connected
	ld a, [wPrinterStatus2]
	inc a
	jr z, .error_2

.printer_connected
	ld a, [wPrinterStatus2]
	and %11100000
	ret z ; no error

	bit 7, a
	jr nz, .error_1
	bit 6, a
	jr nz, .error_4
	ld a, 6 ; error 3
	jr .load_text_index

.error_4
	ld a, 7 ; error 4
	jr .load_text_index

.error_1
	ld a, 4 ; error 1
	jr .load_text_index

.error_2
	ld a, 5 ; error 2

.load_text_index
	ld [wPrinterTextIndex], a
	ret

ShowPrinterStatus:
	ld a, [wPrinterTextIndex]
	and a
	ret z
	push af
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 5
	lb bc, 10, 18
	call TextBox
	pop af
	ld e, a
	ld d, 0
	ld hl, PrinterStatusStringPointers
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 1, 7
	ld a, BANK(GBPrinterStrings)
	call FarText
	hlcoord 2, 15
	ld de, .press_B_to_cancel
	call PlaceText
	ld a, $1
	ld [hBGMapMode], a
	xor a
	ld [wPrinterTextIndex], a
	ret

.press_B_to_cancel
	ctxt "Press B to Cancel"
	done

PrinterStatusStringPointers:
	dw String_Printer_Blank ; @
	dw String_Printer_CheckingLink
	dw String_Printer_Transmitting
	dw String_Printer_Printing
	dw String_Printer_Error1
	dw String_Printer_Error2
	dw String_Printer_Error3
	dw String_Printer_Error4

Function84817:
	xor a
	ld [wd002], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call Printer_PlaceEmptyBoxSlotString
	hlcoord 0, 0
	ld bc, 9 * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call Printer_PlaceSideBorders
	call Printer_PlaceTopBorder
	hlcoord 4, 3
	ld de, .String_PokemonList
	call PlaceText
	ld a, [wd007]
	ld bc, BOX_NAME_LENGTH
	ld hl, wBoxNames
	rst AddNTimes
	ld d, h
	ld e, l
	hlcoord 6, 5
	call PlaceString
	ld a, $1
	call Function849c6
	hlcoord 2, 9
	ld c, $3
	jr Function848e7

.String_PokemonList
	ctxt "#mon list"
	done

Function8486f:
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call Printer_PlaceEmptyBoxSlotString
	call Printer_PlaceSideBorders
	ld a, [wd003]
	and a
	ret nz
	ld a, $4
	call Function849c6
	hlcoord 2, 0
	ld c, $6
	jr Function848e7

Function84893:
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call Printer_PlaceEmptyBoxSlotString
	call Printer_PlaceSideBorders
	ld a, [wd003]
	and a
	ret nz
	ld a, $a
	call Function849c6
	hlcoord 2, 0
	ld c, $6
	jr Function848e7

Function848b7:
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill
	call Printer_PlaceEmptyBoxSlotString
	hlcoord 1, 15
	lb bc, 2, 18
	call ClearBox
	call Printer_PlaceSideBorders
	call Printer_PlaceBottomBorders
	ld a, [wd003]
	and a
	ret nz
	ld a, $10
	call Function849c6
	hlcoord 2, 0
	ld c, $5
	; fallthrough

Function848e7:
	ld a, [wd006]
	call GetSRAMBank
	; fallthrough

Function848ed:
	ld a, c
	and a
	jp z, CloseSRAM
	dec c
	ld a, [de]
	cp $ff
	jp z, Function84981
	ld [wd265], a
	ld [wCurPartySpecies], a
	push bc
	push hl
	push de
	push hl
	ld bc, $10
	ld a, " "
	call ByteFill
	pop hl
	push hl
	call GetBasePokemonName
	pop hl
	push hl
	call PlaceString
	ld a, [wCurPartySpecies]
	cp EGG
	pop hl
	jr z, .ok2
	ld bc, $b
	add hl, bc
	call Function8498a
	ld bc, $9
	add hl, bc
	ld a, "/"
	ld [hli], a
	push hl
	ld c, $e
	ld a, " "
	call ByteFill
	pop hl
	push hl
	ld a, [wd004]
	ld l, a
	ld a, [wd005]
	ld h, a
	ld bc, $372
	add hl, bc
	ld bc, $b
	ld a, [wd002]
	rst AddNTimes
	ld e, l
	ld d, h
	pop hl
	push hl
	call PlaceString
	pop hl
	ld bc, $b
	add hl, bc
	push hl
	ld a, [wd004]
	ld l, a
	ld a, [wd005]
	ld h, a
	ld c, $35
	add hl, bc
	ld c, $20
	ld a, [wd002]
	rst AddNTimes
	ld a, [hl]
	pop hl
	call PrintFullLevel
.ok2
	ld hl, wd002
	inc [hl]
	pop de
	pop hl
	ld bc, $3c
	add hl, bc
	pop bc
	inc de
	jp Function848ed

Function84981:
	ld a, $1
	ld [wd003], a
	jp CloseSRAM

Function8498a:
	push hl
	ld a, [wd004]
	ld l, a
	ld a, [wd005]
	ld h, a
	ld bc, $2b
	add hl, bc
	ld c, $20
	ld a, [wd002]
	rst AddNTimes
	ld de, TempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [wd002]
	ld [wCurPartyMon], a
	ld a, $3
	ld [wMonType], a
	callba GetGender
	ld a, $7f
	jr c, .asm_849c3
	ld a, $ef
	jr nz, .asm_849c3
	ld a, $f5
.asm_849c3
	pop hl
	ld [hli], a
	ret

Function849c6:
	push hl
	ld e, a
	ld d, $0
	ld a, [wd004]
	ld l, a
	ld a, [wd005]
	ld h, a
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ret

Printer_PlaceTopBorder:
	hlcoord 0, 0
	ld a, "┌"
	ld [hli], a
	ld a, "─"
	ld c, SCREEN_WIDTH - 2
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], "┐"
	ret

Printer_PlaceSideBorders:
	hlcoord 0, 0
	ld de, SCREEN_WIDTH - 1
	ld c, SCREEN_HEIGHT
	ld a, "│"
.loop
	ld [hl], a
	add hl, de
	ld [hli], a
	dec c
	jr nz, .loop
	ret

Printer_PlaceBottomBorders:
	hlcoord 0, 17
	ld a, "└"
	ld [hli], a
	ld a, "─"
	ld c, SCREEN_WIDTH - 2
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], "┘"
	ret

Printer_PlaceEmptyBoxSlotString:
	hlcoord 2, 0
	ld c, $6
.loop
	push bc
	push hl
	ld de, .two_spaces_six_dashes
	call PlaceText
	pop hl
	ld bc, 3 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

.two_spaces_six_dashes
	text "  ------"
	done
