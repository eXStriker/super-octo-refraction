; Functions to copy data from ROM.

LoadFontsExtra::
	callba _LoadFontsExtra1
LoadFontsExtra2::
	jpba _LoadFontsExtra2

FarCopyFontToHL::
; Copy the entirety of Font to hl
; doubling each byte in the process.
	anonbankpush Font

; switcheroo, de <> hl
	ld de, Font
	ld bc, FontEnd - Font
	inc b
	inc c
	jr .handleLoop

.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

SwapDEAndHL:
	push de
	ld h, d
	ld l, e
	pop hl
	ret

DecompressRequest2bpp::
; Decompress lz data from b:hl to scratch space at 6:d000, then copy c tiles to de.
	push de
	push bc
	ld a, b
	call FarDecompressWRA6
	pop bc
	pop hl
	ld de, wDecompressScratch

; fallthrough
Request2bppInWRA6:
	ld a, [hROMBank]
	ld b, a
	call RunFunctionInWRA6

Get2bpp::
	ld a, [rLCDC]
	bit 7, a
	jr nz, Request2bpp

Copy2bpp::
; copy c 2bpp tiles from b:de to hl
; must be called in di/disable LCD!!!
	call StackCallInBankB
	
.Function:
	call WriteVCopyRegistersToHRAM
	ld b, c
	jp _Serve2bppRequest

; fallthrough
Request2bpp::
; Load 2bpp at b:de to occupy c tiles of hl.
	call StackCallInBankB

.Function
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a

	call WriteVCopyRegistersToHRAM
	ld a, [rLY]
	cp $88
	jr c, .handleLoop
; fallthrough to vblank copy handler if LY is too high
.loop
	ld a, [hTilesPerCycle]
	sub $10
	ld [hTilesPerCycle], a
	jr c, .copyRemainingTilesAndExit
	jr nz, .copySixteenTilesAndContinue
.copyRemainingTilesAndExit
	add $10
	ld [hRequested2bpp], a
	xor a
	ld [hTilesPerCycle], a
	call DelayFrame
	ld a, [hRequested2bpp]
	and a
	jr z, .clearTileCountAndFinish
.addUncopiedTilesToCount
	ld b, a
	ld a, [hTilesPerCycle]
	add b
	ld [hTilesPerCycle], a
	xor a
	ld [hRequested2bpp], a
	jr .handleLoop
.clearTileCountAndFinish
	xor a
	ld [hTilesPerCycle], a
	jr .done
.copySixteenTilesAndContinue
	ld a, $10
	ld [hRequested2bpp], a
	call DelayFrame
	ld a, [hRequested2bpp]
	and a
	jr nz, .addUncopiedTilesToCount
.handleLoop
	call HBlankCopy2bpp
	jr c, .loop
.done

	pop af
	ld [hBGMapMode], a
	ret

Get1bpp::
	ld a, [rLCDC]
	bit 7, a
	jr nz, Request1bpp

Copy1bpp::
; copy c 1bpp tiles from b:de to hl
	ld a, b
	call StackCallInBankA

.Function
	call WriteVCopyRegistersToHRAM
	ld b, c
	jp _Serve1bppRequest

Request1bpp::
; Load 1bpp at b:de to occupy c tiles of hl.
	call StackCallInBankB

.Function:
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a

	call WriteVCopyRegistersToHRAM
	ld a, [rLY]
	cp $88
	jr c, .handleLoop
; fallthrough to vblank copy handler if LY is too high
.loop
	ld a, [hTilesPerCycle]
	sub $10
	ld [hTilesPerCycle], a
	jr c, .copyRemainingTilesAndExit
	jr nz, .copySixteenTilesAndContinue
.copyRemainingTilesAndExit
	add $10
	ld [hRequested1bpp], a
	xor a
	ld [hTilesPerCycle], a
	call DelayFrame
	ld a, [hRequested1bpp]
	and a
	jr z, .clearTileCountAndFinish
.addUncopiedTilesToCount
	ld b, a
	ld a, [hTilesPerCycle]
	add b
	ld [hTilesPerCycle], a
	xor a
	ld [hRequested1bpp], a
	jr .handleLoop

.clearTileCountAndFinish
	xor a
	ld [hTilesPerCycle], a
	jr .done

.copySixteenTilesAndContinue
	ld a, $10
	ld [hRequested1bpp], a
	call DelayFrame
	ld a, [hRequested1bpp]
	and a
	jr nz, .addUncopiedTilesToCount
.handleLoop
	call HBlankCopy1bpp
	jr c, .loop
.done
	pop af
	ld [hBGMapMode], a
	ret

HBlankCopy1bpp:
	di
	ld [hSPBuffer], sp
	ld hl, hRequestedVTileDest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ld h, d
	ld l, e
	jr .innerLoop

.outerLoop
	ld a, [rLY]
	cp $88
	jr nc, ContinueHBlankCopy
.innerLoop
	pop bc
	pop de
.waithblank2
	ld a, [rSTAT]
	and 3
	jr z, .waithblank2
.waithblank
	ld a, [rSTAT]
	and 3
	jr nz, .waithblank
	ld a, c
	ld [hli], a
	ld [hli], a
	ld a, b
	ld [hli], a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hli], a
	rept 2
	pop de
	ld a, e
	ld [hli], a
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hli], a
	endr
	ld a, [hTilesPerCycle]
	dec a
	ld [hTilesPerCycle], a
	jr nz, .outerLoop
	jr DoneHBlankCopy

ContinueHBlankCopy:
	ld [hRequestedVTileSource], sp
	ld sp, hl
	ld [hRequestedVTileDest], sp
	scf
DoneHBlankCopy:
	ld a, [hSPBuffer]
	ld l, a
	ld a, [hSPBuffer + 1]
	ld h, a
	ld sp, hl
	reti

WriteVCopyRegistersToHRAM:
	ld a, e
	ld [hRequestedVTileSource], a
	ld a, d
	ld [hRequestedVTileSource + 1], a
	ld a, l
	ld [hRequestedVTileDest], a
	ld a, h
	ld [hRequestedVTileDest + 1], a
	ld a, c
	ld [hTilesPerCycle], a
	ret

VRAMToVRAMCopy::
	lb bc, %11, rSTAT & $ff ; predefine bitmask and rSTAT source for speed and size
	jr .waitNoHBlank2
.outerLoop2
	ld a, [rLY]
	cp $88
	jr nc, ContinueHBlankCopy
.waitNoHBlank2
	ld a, [$ff00+c]
	and b
	jr z, .waitNoHBlank2
.waitHBlank2
	ld a, [$ff00+c]
	and b
	jr nz, .waitHBlank2
	rept 7
	pop de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	endr
	pop de
	ld a, e
	ld [hli], a
	ld [hl], d
	inc hl
	ld a, l
	and $f
	jr nz, .waitNoHBlank2
	ld a, [hTilesPerCycle]
	dec a
	ld [hTilesPerCycle], a
	jr nz, .outerLoop2
	jp DoneHBlankCopy

Get1or2bppDMG:
	ld [hFarCallSavedA], a
	call StackCallInBankB
	
.Function:
	ld b, a
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	ld a, [hVBlank]
	push af
	ld a, 6
	ld [hVBlank], a
	call WriteVCopyRegistersToHRAM
	ld c, b
.loop
	ld a, [hTilesPerCycle]
	sub $8
	ld [hTilesPerCycle], a
	jr c, .copyRemainingTilesAndExit
	jr nz, .copyEightTilesAndContinue
.copyRemainingTilesAndExit
	add $8
	ld [$ff00+c], a
	xor a
	ld [hTilesPerCycle], a
	call DelayFrame
	ld a, [$ff00+c]
	and a
	jr z, .clearTileCountAndFinish
.addUncopiedTilesToCount
	ld b, a
	ld a, [hTilesPerCycle]
	add b
	ld [hTilesPerCycle], a
	jr .loop
.clearTileCountAndFinish
	xor a
	ld [hTilesPerCycle], a
	jr .done
.copyEightTilesAndContinue
	ld a, $8
	ld [$ff00+c], a
	call DelayFrame
	ld a, [$ff00+c]
	and a
	jr nz, .addUncopiedTilesToCount
	jr .loop
.done
	pop af
	ld [hVBlank], a
	pop af
	ld [hBGMapMode], a
	ret
