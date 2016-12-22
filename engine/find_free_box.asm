FindFreeBox:
	ld a, [wCatchMonSwitchBox]
	inc a
	jr nz, .proceed
	ld hl, .WarningText
	call PrintText
	call YesNoBox
	ret c
.proceed
	ld a, [wCurBox]
	ld b, a
.find_free_box_loop
	cp NUM_BOXES
	jr c, .is_cur_box
	ld a, -1
.is_cur_box
	inc a
	cp b
	ret z
	push bc
	push af
	ld b, a
	callba GetBoxPointer
	ld a, b
	call GetSRAMBank
	ld a, [hl]
	cp MONS_PER_BOX
	call CloseSRAM
	pop bc
	ld a, b
	pop bc
	jr z, .find_free_box_loop
	ld [wCatchMonSwitchBox], a
	ccf
	ret

.WarningText:
	text_jump CatchMon_BoxSwitchWarning
