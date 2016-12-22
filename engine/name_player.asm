ShowPlayerNamingChoices:
	ld hl, ChrisNameMenuHeader
	ld a, [wPlayerGender]
	bit 0, a
	jr z, .GotGender
	ld hl, KrisNameMenuHeader
.GotGender
	call LoadMenuDataHeader
	call VerticalMenu
	ld a, [wMenuCursorY]
	dec a
	call CopyNameFromMenu
	jp CloseWindow

ChrisNameMenuHeader:
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 10 ; end coords
	dw .MaleNames
	db 1 ; ????
	db 0 ; default option

.MaleNames
	db $91 ; flags
	db 5 ; items
	db "New Name@"
MalePlayerNameArray:
	db "Adam@"
	db "Jacob@"
	db "Bruce@"
	db "Caleb@"
	db 2 ; displacement
	db " Name @" ; title

KrisNameMenuHeader:
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 10 ; end coords
	dw .FemaleNames
	db 1 ; ????
	db 0 ; default option

.FemaleNames
	db $91 ; flags
	db 5 ; items
	db "New Name@"
FemalePlayerNameArray:
	db "Cyan@"
	db "Maria@"
	db "Laura@"
	db "Bella@"
	db 2 ; displacement
	db " Name @" ; title
