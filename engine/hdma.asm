Function104000::
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteTilemap
	xor a
	ld [rVBK], a
	ld hl, wDecompressScratch
	call Function10419d
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	jp Function10419d

HDMATransferTileMapToWRAMBank3::
	call CallInSafeGFXMode

.Function
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteTilemap
	ld a, $0
	ld [rVBK], a
	ld hl, wDecompressScratch
	jp Function10419d

HDMATransferAttrMapToWRAMBank3:
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	jp Function10419d

ReloadMapPart::
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteTilemap
	di
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	call Function1041c1
	ld a, $0
	ld [rVBK], a
	ld hl, wDecompressScratch
	call Function1041c1
	pop af
	ld [rVBK], a
	reti

Function104099:
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteTilemap
	call DelayFrame
	di
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	call Function1041c1
	ld a, $0
	ld [rVBK], a
	ld hl, wDecompressScratch
	call Function1041c1
	pop af
	ld [rVBK], a
	reti

Function1040d4:
	call CallInSafeGFXMode

.Function
	ld a, $1
	ld [rVBK], a
	ld a, BANK(wDecompressScratch2)
	ld [rSVBK], a
	ld de, wDecompressScratch2
	ld a, [hBGMapAddress + 1]
	ld [rHDMA1], a
	ld a, [hBGMapAddress]
	ld [rHDMA2], a
	ld a, d
	ld [rHDMA3], a
	ld a, e
	ld [rHDMA4], a
	ld a, $23
	ld [hDMATransfer], a
	jr WaitDMATransfer

Function10419d:
	ld a, h
	ld [rHDMA1], a
	ld a, l
	ld [rHDMA2], a
	ld a, [hBGMapAddress + 1]
	and $1f
	ld [rHDMA3], a
	ld a, [hBGMapAddress]
	ld [rHDMA4], a

	ld a, $23
	ld [hDMATransfer], a
	; fallthrough

WaitDMATransfer:
	jr .handleLoop
.loop
	call DelayFrame
.handleLoop
	ld a, [hDMATransfer]
	and a
	jr nz, .loop
	ret

Function1040fb:
	call CallInSafeGFXMode

.Function
	ld a, $1
	ld [rVBK], a
	ld a, BANK(wDecompressScratch2)
	ld [rSVBK], a
	ld hl, wDecompressScratch2
	jp Function10419d

Function104110::
; OpenText
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteTilemap

	di
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	call Function1041b7
	xor a
	ld [rVBK], a
	ld hl, wDecompressScratch
	call Function1041b7
	pop af
	ld [rVBK], a
	reti

CallInSafeGFXMode:
	pop hl

	ld a, [hBGMapMode]
	push af
	ld a, [hMapAnims]
	push af
	xor a
	ld [hBGMapMode], a
	ld [hMapAnims], a
	ld a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ld [rSVBK], a
	ld a, [rVBK]
	push af

	call _hl_

	pop af
	ld [rVBK], a
	pop af
	ld [rSVBK], a
	pop af
	ld [hMapAnims], a
	pop af
	ld [hBGMapMode], a
	ret

HDMAHBlankTransferTileMap_DuringDI:
	call CallInSafeGFXMode

.Function
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteTilemap
	xor a
	ld [rVBK], a
	ld hl, wDecompressScratch
	jr Function1041c1

HDMAHBlankTransferAttrMap_DuringDI:
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	jr Function1041c1

Function104148:
	call CallInSafeGFXMode

.Function
	decoord 0, 0, AttrMap
	ld hl, wBackupAttrMap
	call CutAndPasteAttrMap
	ld c, $ff
	decoord 0, 0
	ld hl, wDecompressScratch
	call CutAndPasteMap
	ld a, $1
	ld [rVBK], a
	ld hl, wBackupAttrMap
	call Function1041c1
	xor a
	ld [rVBK], a
	ld hl, wDecompressScratch

Function1041c1:
	ld a, [hBGMapAddress + 1]
	ld d, a
	ld a, [hBGMapAddress]
	ld e, a
	ld c, $23
	ld a, h
	ld [rHDMA1], a
	ld a, l
	and $f0
	ld [rHDMA2], a
	ld a, d
	and $1f
	ld [rHDMA3], a
	ld a, e
	and $f0
	ld [rHDMA4], a
	ld a, [rLY]
	add c ; calculate end LY
	cp $80 ; is the end LY greater than the max LY
	call nc, DI_DelayFrame ; if so, delay a frame to reset the LY
	set 7, c
.waitHBlank
	ld a, [rSTAT]
	and $3
	jr nz, .waitHBlank
	ld hl, rHDMA5
	ld [hl], c
	ld a, $ff
.waitHDMALoop
	cp [hl]
	jr nz, .waitHDMALoop
	ret

Function1041b7:
; hBGMapAddress -> de
; $24 -> c
; $7b --> b
	ld a, [hBGMapAddress + 1]
	ld d, a
	ld a, [hBGMapAddress]
	ld e, a
	lb bc, $7b, $24
	jr asm_10420b

CopySolidFontUsingHDMA:
	ld hl, wDecompressScratch
	ld de, VTiles1
	ld c, $80
	; fallthrough

DoHBlankHDMATransfer:
; LY magic
	ld b, $7f
asm_10420b:
	ld a, h
	ld [rHDMA1], a
	ld a, l
	and $f0 ; high nybble
	ld [rHDMA2], a
	ld a, d
	and $1f ; lower 5 bits
	ld [rHDMA3], a
	ld a, e
	and $f0 ; high nybble
	ld [rHDMA4], a
	dec c ; c = number of LYs needed
	ld e, c
	set 7, e ; hblank dma transfers
	di
	ld a, [rLY]
	add c ; calculate end LY
	cp b ; is the end LY greater than the max LY
	call nc, DI_DelayFrame ; if so, delay a frame to reset the LY

	lb bc, %11, rSTAT & $ff
.noHBlankWait
	ld a, [$ff00+c]
	and b
	jr z, .noHBlankWait
.hBlankWaitLoop
	ld a, [$ff00+c]
	and b
	jr nz, .hBlankWaitLoop
	ld hl, rHDMA5
	ld [hl], e
	ld a, $ff
.waitForHDMA
	cp [hl]
	jr nz, .waitForHDMA
	reti

CutAndPasteTilemap:
	ld c, " "
	jr CutAndPasteMap

CutAndPasteAttrMap:
	ld c, $0
	; fallthrough

CutAndPasteMap:
; back up the value of c to hMapObjectIndexBuffer
	ld a, [hMapObjectIndexBuffer]
	push af
	ld a, c
	ld [hMapObjectIndexBuffer], a

; for each row on the screen
	ld c, SCREEN_HEIGHT
.loop1
; for each tile in the row
	ld b, SCREEN_WIDTH
.loop2
; copy from de to hl
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop2

; load the original value of c into hl 12 times
	ld a, [hMapObjectIndexBuffer]
	ld b, 12
.loop3
	ld [hli], a
	dec b
	jr nz, .loop3

	dec c
	jr nz, .loop1

; restore the original value of hMapObjectIndexBuffer
	pop af
	ld [hMapObjectIndexBuffer], a
	ret

Function104303:
	call CallInSafeGFXMode

.Function
	ld hl, wDecompressScratch
	decoord 0, 0
	call Function10433a
	ld hl, wDecompressScratch + $80
	decoord 0, 0, AttrMap
	call Function10433a
	di
	ld a, $1
	ld [rVBK], a
	ld c, $8
	ld hl, wDecompressScratch + $80
	debgcoord 0, 0, VBGMap1
	call DoHBlankHDMATransfer
	xor a
	ld [rVBK], a
	ld c, $8
	ld hl, wDecompressScratch
	debgcoord 0, 0, VBGMap1
	call DoHBlankHDMATransfer

	reti

Function10433a:
	ld b, 4
.outer_loop
	ld c, SCREEN_WIDTH
.inner_loop
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .inner_loop
	ld a, l
	add $20 - SCREEN_WIDTH
	ld l, a
	ld a, h
	adc $0
	ld h, a
	dec b
	jr nz, .outer_loop
	ret

DI_DelayFrame:
	; I have no idea of what's going on here, but this function is being called while not in di mode
	; this is a duct-tape fix and should probably be replaced eventually
	ld a, [rLY]
	push hl
	ld hl, wInitialLY
	ld [hl], a
.loop
	ld a, [rLY]
	and a
	jr z, .done
	cp [hl]
	jr nc, .loop
.done
	pop hl
	ret
