Elevator::
; Menu for elevator at b:de
	call .CopyElevatorData
	call .FindCurrentFloor
	jr c, .quit
	ld [wElevatorOriginFloor], a
	call Elevator_AskWhichFloor
	jr c, .quit
	ld hl, wElevatorOriginFloor
	cp [hl]
	jr z, .quit
	call Elevator_GoToFloor
	and a
	ret

.quit
	scf
	ret

.CopyElevatorData
	; Load the elevator pointer into WRAM, freeing up the carrying registers.
	ld a, b
	ld [wElevatorPointerBank], a
	ld a, e
	ld [wElevatorPointerLo], a
	ld a, d
	ld [wElevatorPointerHi], a
	; Copy the elevator floors
	ld de, CurElevator
	ld bc, 4
	ld hl, wElevatorPointerLo
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wElevatorPointerBank]
	call GetFarByteAndIncrement ; # of floors
	ld [de], a
	inc de
.loop
	ld a, [wElevatorPointerBank]
	call GetFarByte
	ld [de], a ; Floor Index
	inc de
	add hl, bc
	cp -1
	jr nz, .loop
	ret

.FindCurrentFloor
	ld hl, wElevatorPointerLo
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wElevatorPointerBank]
	call GetFarByteAndIncrement
	ld c, a
	ld a, [BackupMapGroup]
	ld d, a
	ld a, [BackupMapNumber]
	ld e, a
	ld b, 0
.loop2
	ld a, [wElevatorPointerBank]
	call GetFarByte
	cp -1
	jr z, .fail
	inc hl
	inc hl
	ld a, [wElevatorPointerBank]
	call GetFarByteAndIncrement
	cp d
	jr nz, .next1
	ld a, [wElevatorPointerBank]
	call GetFarByteAndIncrement
	cp e
	jr nz, .next2
	jr .done

.next1
	inc hl
.next2
	inc b
	jr .loop2

.done
	xor a
	ld a, b
	ret

.fail
	scf
	ret

Elevator_GoToFloor:
	push af
	ld hl, wElevatorPointerLo
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	pop af
	ld bc, 4
	rst AddNTimes
	inc hl
	ld de, BackupWarpNumber
	ld a, [wElevatorPointerBank]
	ld bc, 3
	jp FarCopyBytes

Elevator_AskWhichFloor:
	call LoadStandardMenuDataHeader
	ld hl, Elevator_WhichFloorText
	call PrintText
	call Elevator_GetCurrentFloorText
	ld hl, Elevator_MenuDataHeader
	call CopyMenuDataHeader
	call InitScrollingMenu
	call UpdateSprites
	xor a
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	call CloseWindow
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .cancel
	xor a
	ld a, [wScrollingMenuCursorPosition]
	ret

.cancel
	scf
	ret

Elevator_WhichFloorText:
	; Which floor?
	text_jump UnknownText_0x1bd2bc

Elevator_GetCurrentFloorText:
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	hlcoord 0, 0
	lb bc, 4, 8
	call TextBox
	hlcoord 1, 2
	ld de, Elevator_CurrentFloorText
	call PlaceString
	hlcoord 4, 4
	call Elevator_GetCurrentFloorString
	pop af
	ld [wOptions], a
	ret

Elevator_CurrentFloorText:
	db "Now on:@"

Elevator_GetCurrentFloorString:
	push hl
	ld a, [wElevatorOriginFloor]
	ld e, a
	ld d, 0
	ld hl, CurElevatorFloors
	add hl, de
	ld a, [hl]
	pop de
	jr GetFloorString

Elevator_MenuDataHeader:
	db $40 ; flags
	db 01, 12 ; start coords
	db 09, 18 ; end coords
	dw Elevator_MenuData2
	db 1 ; default option

Elevator_MenuData2:
	db $10 ; flags
	db 4, 0 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, CurElevator
	dba GetElevatorFloorStrings
	dba NULL
	dba NULL

GetElevatorFloorStrings:
	ld a, [wMenuSelection]
GetFloorString:
	push de
	call FloorToString
	ld d, h
	ld e, l
	pop hl
	jp PlaceString

FloorToString:
	push de
	ld e, a
	ld d, 0
	ld hl, .floors
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ret

.floors
	dw .b4f
	dw .b3f
	dw .b2f
	dw .b1f
	dw ._1f
	dw ._2f
	dw ._3f
	dw ._4f
	dw ._5f
	dw ._6f
	dw ._7f
	dw ._8f
	dw ._9f
	dw ._10f
	dw ._11f
	dw .roof

.b1f
	db "B"
._1f
	db "1F@"
.b2f
	db "B"
._2f
	db "2F@"
.b3f
	db "B"
._3f
	db "3F@"
.b4f
	db "B"
._4f
	db "4F@"
._5f
	db "5F@"
._6f
	db "6F@"
._7f
	db "7F@"
._8f
	db "8F@"
._9f
	db "9F@"
._10f
	db "10F@"
._11f
	db "11F@"
.roof
	db "Roof@"
