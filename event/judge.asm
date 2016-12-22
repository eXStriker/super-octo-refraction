DVJudgeScript:
	faceplayer
	opentext
	callasm Stats_Judge
	endtext

Stats_Judge::
	ld hl, .Intro
	call PrintText
	call YesNoBox
	jr c, .cancel
	ld hl, .Which
	call PrintText

	callba SelectMonFromParty
	jr c, .cancel

	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg

	call IsAPokemon
	jr c, .no_mon
	ld hl, .InitJudge
	call PrintText
	call ReadDVs
	call GetDVTotal
	call JudgeDVTotal
	ld hl, .Incidentally
	call PrintText
	call GetMaxDV
	push bc
	call InformMaxDVs
	pop bc
	call JudgeMaxDV
	ld hl, .Conclude
	call PrintText
	call GetMinDV
	call InformMinDVs
	ld hl, .Finish
	jp PrintText

.no_mon
	ld hl, .NotPokemon
	jp PrintText

.cancel
	ld hl, .Cancel
	jp PrintText

.egg
	ld hl, .Egg
	jp PrintText

.Intro
	text_jump JudgeText_Intro

.Which
	text_jump JudgeText_Which

.InitJudge
	text_jump JudgeText_InitJudge

.Incidentally
	text_jump JudgeText_Incidentally

.Conclude
	text_jump JudgeText_Conclude

.Finish
	text_jump JudgeText_Finish

.Cancel
	text_jump JudgeText_Cancel

.Egg
	text_jump JudgeText_Egg

.NotPokemon
	text_jump JudgeText_NotPokemon

ReadDVs:
	ld a, MON_DVS
	call GetPartyParamLocation
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	ld hl, wd003
	ld b, 0
; Attack
	ld a, d
	and $f0
	swap a
	ld [hli], a
	srl a
	rl b
; Defense
	ld a, d
	and $f
	ld [hli], a
	srl a
	rl b
; Speed
	ld a, e
	and $f0
	swap a
	ld [hli], a
	srl a
	rl b
; Special
	ld a, e
	and $f
	ld [hl], a
	srl a
	rl b
; HP
	ld a, b
	ld [wd002], a
	ret

GetDVTotal:
; Return to b
	ld hl, wd002
	ld b, 5
	xor a
.loop
	add [hl]
	inc l
	dec b
	jr nz, .loop
	ld b, a
	ret

GetMinDV:
; Find DVs equal to zero
; Return flag array c
	xor a
	jr FindDVEqualToA

GetMaxDV:
; Find DVs equal to max
; Return flag array c
	ld hl, wd002
	ld b, 5
	xor a
.loop
	cp [hl]
	jr nc, .skip
	ld a, [hl]
.skip
	inc l
	dec b
	jr nz, .loop
; We found the max value, now let's get which ones are equal.
FindDVEqualToA:
	ld hl, wd002
	lb bc, 5, 0
	jr .handleLoop

.loop2
	srl c
.handleLoop
	cp [hl]
	jr nz, .skip2
	set 4, c
.skip2
	inc l
	dec b
	jr nz, .loop2
	ld b, a
	ret

JudgeMaxDV:
	ld hl, MaxDVTextArray
	jr JudgeTextArray_handleLoop

JudgeDVTotal:
	ld hl, DVTotalTextArray
	jr JudgeTextArray_handleLoop

JudgeTextArray_loop
	inc hl
	inc hl
JudgeTextArray_handleLoop
	ld a, [hli]
	cp b
	jr c, JudgeTextArray_loop
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(JudgeText_AbsoluteWorst)
	jp FarPrintText

InformMaxDVs:
	ld hl, Max_WhichStatTexts
	jr Judge_PrintStatText

InformMinDVs:
	ld hl, Min_WhichStatTexts
Judge_PrintStatText:
; Flag array d
; Text array hl
	ld d, c
	lb bc, 0, 5
.loop
	srl d
	jr nc, .next
	push de
	push hl
	push bc
	ld a, c
	ld hl, .StatNames
	call GetNthStringBasedOnLengthDeltas
	pop bc
	pop hl
	push hl
	push bc
	ld e, b
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(JudgeMinStats_FirstStatText)
	call FarPrintText
	pop bc
	pop hl
	pop de
	inc b
.next
	dec c
	jr nz, .loop
	ret

.StatNames
	add_name "Special"
	add_name "Speed"
	add_name "Defense"
	add_name "Attack"
	add_name "HP"

DVTotalTextArray:
	dbw  0, JudgeText_AbsoluteWorst
	dbw 19, JudgeText_Poor
	dbw 34, JudgeText_Unremarkable
	dbw 49, JudgeText_Decent
	dbw 74, JudgeText_Strong
	dbw 75, JudgeText_Perfect

Max_WhichStatTexts
	dw JudgeMaxStats_FirstStatText
	dw JudgeMaxStats_SecondStatText
	dw JudgeMaxStats_ThirdStatText
	dw JudgeMaxStats_FourthStatText
	dw JudgeMaxStats_FifthStatText

MaxDVTextArray:
	dbw  6, JudgeMaxDVText_Decent
	dbw 11, JudgeMaxDVText_Good
	dbw 14, JudgeMaxDVText_Fantastic
	dbw 15, JudgeMaxDVText_Perfect

Min_WhichStatTexts
	dw JudgeMinStats_FirstStatText
	dw JudgeMinStats_SecondStatText
	dw JudgeMinStats_ThirdStatText
	dw JudgeMinStats_FourthStatText
	dw JudgeMinStats_FifthStatText
