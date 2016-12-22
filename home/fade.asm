; Functions to fade the screen in and out.

FadeBGToLightestColor::
	ld de, BGPals
	ld h, d
	ld l, e
	ld b, %1
	jr FadeInPals

FadeBGToDarkestColor::
	ld de, BGPals + 6
	ld hl, BGPals
	ld b, %1
	jr FadeInPals

FadeOBJToWhite::
	ld hl, OBPals
	ld de, WhitePal
	ld b, %10
	jr FadeInPals

;FadeOBJToLightestColor::
;	ld de, OBPals
;	ld h, d
;	ld l, e
;	ld b, %10
;	jr FadeInPals

FadeOBJToDarkestColor::
	ld de, OBPals + 6
	ld hl, OBPals
	ld b, %10
	jr FadeInPals

FadeToLightestColor:: ; 4dd
	ld de, BGPals
	ld h, d
	ld l, e
	jr FadeBothPalsCommon

FadeToDarkestColor:: ; 4b6
	ld de, BGPals + 6
	ld hl, BGPals
	jr FadeBothPalsCommon

FadeToWhite::
	ld de, WhitePal
	ld hl, BGPals
FadeBothPalsCommon:
	ld b, %11
	
FadeInPals::
; Smoothly fade in pals to the colour offset at hl
; lower 7 bits of c = delay time per frame
; if bit 7 is set, delay every c counts
	ld a, [rSVBK]
	push af
	ld a, BANK(BGPals)
	ld [rSVBK], a
	ld a, c
	ld [hBuffer], a
	ld a, b
	ld b, 0
	push hl
	ld hl, BGPalsBuffer2
	rra
	push af
	call c, .CopyPalColourToBuffer
	pop af
	rra
	call c, .CopyPalColourToBuffer
	pop hl
	ld a, [hBuffer]
	ld c, a
	ld de, BGPalsBuffer2
	callba RelativeFade
	pop af
	ld [rSVBK], a
	ret

.CopyPalColourToBuffer:
	push de
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	ld e, a
	ld d, c
	
	ld a, 8 * 4
	ld c, a
	add b
	ld b, a
.loop
	ld a, d
	ld [hli], a
	ld a, e
	res 7, a
	ld [hli], a
	dec c
	jr nz, .loop
	pop de
	bit 7, d
	jr z, .nextPal
	ld a, 8 palettes
	add e
	ld e, a
	ret nc
	inc d
	ret
.nextPal
	inc de
	inc de
	ret

FadeOutBGPals::
	ld b, 8 * 4
	ld hl, BGPals
	ld de, UnknBGPals
	jr FadeOutPals_Common

FadeOutOBJPals::
	ld b, 8 * 4
	ld hl, OBPals
	ld de, UnknOBPals
	jr FadeOutPals_Common

FadeOutPals::
	ld b, 16 * 4
	ld hl, BGPals
	ld de, UnknBGPals

FadeOutPals_Common::
; Rotate palettes to the left and fill with loaded colors from the right
; If we're already at the rightmost color, fill with the rightmost color
	ld a, [rSVBK]
	push af
	ld a, BANK(UnknBGPals)
	ld [rSVBK], a
	callba RelativeFade
	pop af
	ld [rSVBK], a
	ret
; 517

WhitePal:
	RGB 31, 31, 31
	RGB 31, 31, 31
