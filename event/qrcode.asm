WriteQRCode:
	ld a, [hScriptVar]
	ld hl, QRCodePointers
	add a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DecompressWRA6
	call RunFunctionInWRA6
	
.Function:
	ld de, wDecompressScratch
	ld hl, VTiles1
	lb bc, BANK(WriteQRCode), 16
	call Request1bpp
	hlcoord 8, 13
	ld de, SCREEN_WIDTH - 4
	ld a, $80
	ld b, 4
.drawBoxOuter
	ld c, 4
.drawBoxInner
	ld [hli], a
	inc a
	dec c
	jr nz, .drawBoxInner
	add hl, de
	dec b
	jr nz, .drawBoxOuter
	ret

QRCodePointers:
	dw QRCode1
	dw QRCode2
	dw QRCode3
	dw QRCode4
	dw QRCode5
	dw QRCode6
	dw QRCode7
	
QRCode1: INCBIN "gfx/qrcodes/1.1bpp.lz"
QRCode2: INCBIN "gfx/qrcodes/2.1bpp.lz"
QRCode3: INCBIN "gfx/qrcodes/3.1bpp.lz"
QRCode4: INCBIN "gfx/qrcodes/4.1bpp.lz"
QRCode5: INCBIN "gfx/qrcodes/5.1bpp.lz"
QRCode6: INCBIN "gfx/qrcodes/6.1bpp.lz"
QRCode7: INCBIN "gfx/qrcodes/7.1bpp.lz"
