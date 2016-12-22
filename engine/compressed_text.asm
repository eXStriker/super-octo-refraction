PrintCompressedString::
	; in: a:hl = text stream pointing to the first compressed byte, bc = destination
	; out: a:hl = text stream pointing to the first byte after the compressed data, bc = next destination
	ld [hCompressedTextBank], a
	ld d, 1
.character_loop
	xor a
	push bc
.huffman_loop
	call ReadCompressedTextBit
	adc a
	add a, TextCompressionHuffmanTree & $FF
	ld c, a
	ld a, TextCompressionHuffmanTree >> 8
	adc 0
	ld b, a
	ld a, [bc]
	cp $70
	jr c, .huffman_loop
	call GenerateCompressedTextBuffer
	pop bc
	push de
	ld de, wCompressedTextBuffer
	ld a, [de]
	cp "@"
	jr z, .done
	push hl
	cp "<LNBRK>"
	jr z, .skip_line
	cp "<NEXT>"
	jr z, .skip_two_lines
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	bit 7, d ; PlaceString updates de to point to somewhere in ROM if a finish character (done, prompt) was found
	jr z, .finished_text
	pop de
	jr .character_loop
.finished_text
	ld a, l
	ld [wTextEndPointer], a
	ld a, h
	ld [wTextEndPointer + 1], a
	ld h, d
	ld l, e
	inc hl
.done
	pop de
	ld a, [hCompressedTextBank]
	ret
.skip_two_lines
	ld hl, SCREEN_WIDTH
	add hl, bc
	jr .skip_next_line
.skip_line
	ld h, b
	ld l, c
.skip_next_line
	call GetCurrentColumn
	ld c, a
	ld a, [wInitialTextColumn]
	add a, SCREEN_WIDTH
	sub c
	cp SCREEN_WIDTH + 1
	jr c, .no_line_overflow
	sub SCREEN_WIDTH
.no_line_overflow
	ld c, a
	ld b, 0
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	pop de
	jr .character_loop

ReadCompressedTextBit:
	; result in carry
	dec d
	jr nz, .no_reload
	push af
	ld a, [hCompressedTextBank]
	call GetFarByteAndIncrement
	ld e, a
	pop af
	ld d, 8
.no_reload
	sla e
	ret

ReadCompressedTextBits:
	; in: a = count; out: a = bits
	push bc
	ld c, a
	xor a
.loop
	call ReadCompressedTextBit
	rla
	dec c
	jr nz, .loop
	pop bc
	ret

TextCompressionHuffmanTree:
	; two entries per non-leaf node, starting with the root; first entry is the 0 path, second entry is the 1 path
	; $00 - $6F are non-leaf nodes, $70 - $FF are leaf nodes
	; values $44 - $57 are mapped to $BC - $CF; values $58 - $5B are mapped to $78 - $7B
	; values $7C and $7D represent the subtrees for 64 and 16 special rare values
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $7F, $0B, $0C, $0D, $0E, $0F
	db $10, $A4, $11, $12, $13, $14, $15, $B3, $16, $A0, $17, $18, $19, $AE, $1A, $A8
	db $AD, $1B, $B2, $A7, $1C, $B1, $1D, $1E, $1F, $20, $21, $22, $23, $A3, $24, $AB
	db $E8, $F4, $25, $26, $27, $28, $93, $29, $2A, $2B, $2C, $A2, $B4, $2D, $2E, $2F
	db $C7, $AC, $30, $31, $B6, $80, $A5, $32, $33, $A6, $C9, $E3, $B8, $34, $AF, $35
	db $36, $39, $38, $37, $92, $3A, $CD, $A1, $3B, $87, $3C, $96, $3D, $3E, $88, $8E
	db $9A, $9B, $3F, $40, $D4, $41, $42, $E7, $B5, $43, $81, $44, $79, $8C, $D3, $9D
	db $D2, $C2, $46, $45, $AA, $85, $D6, $47, $7A, $82, $48, $9C, $49, $4A, $BC, $E6
	db $4B, $4C, $D0, $8B, $83, $8F, $4D, $8D, $4E, $E9, $84, $C1, $50, $4F, $86, $9E
	db $9F, $D1, $91, $98, $51, $94, $D5, $CF, $52, $53, $54, $F3, $55, $56, $F7, $FB
	db $F6, $57, $58, $F8, $A9, $B7, $59, $5A, $95, $5B, $8A, $89, $5C, $B9, $F9, $B0
	db $5D, $FF, $5E, $FD, $FE, $FA, $5F, $78, $FC, $60, $C8, $7B, $63, $62, $61, $CC
	db $90, $64, $BD, $BE, $BF, $C0, $66, $65, $67, $68, $CE, $CA, $75, $69, $7C, $6A
	db $99, $CB, $C6, $6B, $6C, $97, $C3, $C5, $DA, $7D

TextCompressionSpecialValues16:
	; one byte per value, it's a simple list
	db $4C, $D7, $D8, $D9, $E4, $E5, $EA, $EB, $EC, $ED, $EE, $EF, $F0, $F1, $F2, $F5

TextCompressionSpecialValues64:
	; count, initial
	db $19, $5C
	db $09, $76
	db $16, $BA
	db $08, $DB

GenerateCompressedTextBuffer:
	; in: a = selected leaf node from Huffman tree
	; out: wCompressedTextBuffer containing printable text
	cp $78
	jr c, .print_byte
	cp $7C
	jr c, .sub_20
	cp $7E
	jr c, .special_values
	cp $BC
	jr c, .print_byte
	cp $D0
	jr nc, .print_byte

.sub_78
	sub $58 ;not a typo

.sub_20
	sub $20

.print_byte
	push hl
.print_byte_after_pushing
	ld hl, wCompressedTextBuffer
	ld [hli], a
	ld [hl], "@"
	pop hl
	ret

.special_values
	rra
	jr c, .special_16
	ld a, 6
	call ReadCompressedTextBits
	push hl
	ld hl, TextCompressionSpecialValues64
.special_value_loop
	cp [hl]
	jr c, .selected_special_value
	sub [hl]
	inc hl
	inc hl
	jr .special_value_loop
.selected_special_value
	inc hl
	add a, [hl]
	jr .print_byte_after_pushing

.special_16
	ld a, 4
	call ReadCompressedTextBits
	push hl
	push de
	ld hl, TextCompressionSpecialValues16
	ld e, a
	ld d, 0
	add hl, de
	pop de
	ld a, [hl]
	jr .print_byte_after_pushing

GetCurrentColumn:
	push hl
	push bc
	push de
	ld hl, $10000 - TileMap
	add hl, bc
	ld b, h
	ld c, l
	ld de, SCREEN_WIDTH
	call Divide16
	pop de
	ld a, c
	pop bc
	pop hl
	ret
