	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32, $13, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e
.frame2
	db $01 ; bitmask
	db $3f, $40, $39, $41, $42, $43, $44, $45, $46, $05, $47, $3a, $48, $49, $4a, $4b, $4c, $3e, $4d, $4e, $4f, $50, $51, $52
.frame3
	db $02 ; bitmask
	db $53, $54, $55, $40, $39, $56, $57, $58, $42, $43, $59, $44, $45, $46, $05, $47, $3a, $48, $49, $4a, $3e, $5a, $5b, $5c, $5d, $5e, $5f, $60, $61
.frame4
	db $03 ; bitmask
	db $05, $62, $63, $40, $39, $05, $64, $58, $42, $43, $65, $44, $45, $46, $05, $47, $3a, $48, $49, $4a, $4b, $4c, $3e, $66, $67, $39, $4d, $4e, $4f, $5c, $68, $69, $50, $51, $52, $5f, $6a, $6b
.frame5
	db $04 ; bitmask
	db $6c, $6d, $6e, $6f, $39, $70, $71, $72, $73, $74
.frame6
	db $04 ; bitmask
	db $6c, $75, $6e, $76, $77, $70, $78, $79, $7a, $7b
