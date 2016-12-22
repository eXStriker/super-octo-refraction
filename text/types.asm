PrintMonTypes:
; Print one or both types of [wCurSpecies]
; on the stats screen at hl.

	push hl
	call GetBaseData
	pop hl

	push hl
	ld a, [BaseType1]
	call PrintType_

	; Single-typed monsters really
	; have two of the same type.
	ld a, [BaseType1]
	ld b, a
	ld a, [BaseType2]
	cp b
	pop hl
	jr z, .hide_type_2

	ld bc, SCREEN_WIDTH
	add hl, bc
	jr PrintType_

.hide_type_2
	; Erase any type name that was here before.
	; Seems to be pointless in localized versions.
	ld a, " "
	ld bc, SCREEN_WIDTH - 3
	add hl, bc
	ld [hl], a
	inc bc
	add hl, bc
	ld bc, 5
	jp ByteFill

PrintMoveType:
; Print the type of move b at hl.

	push hl
	ld a, b
	dec a
	ld bc, MOVE_LENGTH
	ld hl, Moves
	rst AddNTimes
	ld de, wStringBuffer1
	ld a, BANK(Moves)
	call FarCopyBytes
	pop hl

	ld a, [wStringBuffer1 + MOVE_TYPE]
	push af
	push hl
	call PrintType_
	pop hl
	ld de, -16
	add hl, de
	pop af
	and $c0
	ld de, .Physical
	jr z, .okay
	sla a
	ld de, .Special
	jr nc, .okay
	ld de, .Status
.okay
	jp PlaceString

.Physical: db "PH@"
.Special:  db "SP@"
.Status:   db "ST@"

PrintType:
; Print type b at hl.

	ld a, b
PrintType_:
	and $1f

	push hl
	add a
	ld hl, TypeNames
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl

	jp PlaceString

GetTypeName:
; Copy the name of type [wd265] to wStringBuffer1.

	ld a, [wd265]
	and $1f
	ld hl, TypeNames
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wStringBuffer1
	ld bc, 13
	rst CopyBytes
	ret

TypeNames:
	dw .Normal
	dw .Fighting
	dw .Flying
	dw .Poison
	dw .Ground
	dw .Rock
	dw .Bird
	dw .Bug
	dw .Ghost
	dw .Steel
	dw .Fairy
	dw .Gas
	dw .Normal
	dw .Sound
	dw .Tri
	dw .Prism
	dw .Normal
	dw .Normal
	dw .Normal
	dw .CurseType
	dw .Fire
	dw .Water
	dw .Grass
	dw .Electric
	dw .Psychic
	dw .Ice
	dw .Dragon
	dw .Dark

.Normal:    db "Normal@"
.Fighting:  db "Fighting@"
.Flying:    db "Flying@"
.Poison:    db "Poison@"
.CurseType: db "???@"
.Fire:      db "Fire@"
.Water:     db "Water@"
.Grass:     db "Grass@"
.Electric:  db "Electric@"
.Psychic:   db "Psychic@"
.Ice:       db "Ice@"
.Ground:    db "Ground@"
.Rock:      db "Rock@"
.Bird:      db "Bird@"
.Bug:       db "Bug@"
.Ghost:     db "Ghost@"
.Steel:     db "Steel@"
.Dragon:    db "Dragon@"
.Dark:      db "Dark@"
.Gas:       db "Gas@"
.Sound:     db "Sound@"
.Tri:       db "Tri@"
.Prism:     db "Prism@"
.Fairy:     db "Fairy@"
