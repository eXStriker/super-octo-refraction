FruitTreeScript:: ; 44000
	callasm GetCurTreeFruit
	opentext
	copybytetovar CurFruit
	itemtotext $0, $0
	writetext FruitBearingTreeText
	buttonsound
	callasm TryResetFruitTrees
	callasm CheckFruitTree
	iffalse .fruit
	writetext NothingHereText
	endtext

.fruit
	writetext HeyItsFruitText
	copybytetovar CurFruit
	giveitem ITEM_FROM_MEM
	iffalse .packisfull
	buttonsound
	callasm GiveItemCheckPluralBuffer3
	writetext ObtainedFruitText
	callasm PickedFruitTree
	playwaitsfx SFX_ITEM
	itemnotify
	endtext

.packisfull
	buttonsound
	writetext FruitPackIsFullText
	endtext
; 44041

GetCurTreeFruit: ; 44041
	ld a, [CurFruitTree]
	dec a
	call GetFruitTreeItem
	ld [CurFruit], a
	ret
; 4404c

TryResetFruitTrees: ; 4404c
	ld hl, DailyFlags
	bit 4, [hl]
	ret nz
	jp ResetFruitTrees
; 44055

CheckFruitTree: ; 44055
	ld b, CHECK_FLAG
	call GetFruitTreeFlag
	ld a, c
	ld [hScriptVar], a
	ret
; 4405f

PickedFruitTree: ; 4405f
	ld b, SET_FLAG

GetFruitTreeFlag: ; 44078
	push hl
	push de
	ld a, [CurFruitTree]
	dec a
	ld c, a
	ld hl, FruitTreeFlags
	predef FlagAction
	pop de
	pop hl
	ret
; 4408a

ResetFruitTrees: ; 4406a
	xor a
	ld hl, FruitTreeFlags
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, DailyFlags
	set 4, [hl]
	ret
; 44078

GetFruitTreeItem: ; 4408a
	push hl
	push de
	ld e, a
	ld d, 0
	ld hl, FruitTreeItems
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret
; 44097

FruitTreeItems: ; 44097
	db RED_APRICORN
	db BLU_APRICORN
	db YLW_APRICORN
	db GRN_APRICORN
	db WHT_APRICORN
	db BLK_APRICORN
	db PNK_APRICORN
	db ORNGAPRICORN
	db ORNGAPRICORN
	db ORNGAPRICORN
	db CYANAPRICORN
	db CYANAPRICORN
	db GREYAPRICORN
	db PRPLAPRICORN

	db ORAN_BERRY
	db PECHA_BERRY
	db ORAN_BERRY
	db CHERI_BERRY
	db ORAN_BERRY
	db ASPEAR_BERRY
	db ORAN_BERRY
	db RAWST_BERRY
	db ORAN_BERRY
	db PERSIM_BERRY
	db ORAN_BERRY
	db CHESTO_BERRY
	db SITRUS_BERRY
	db LUM_BERRY
	db SITRUS_BERRY
	db LEPPA_BERRY

; 440b5

FruitBearingTreeText: ; 440b5
	text_jump _FruitBearingTreeText
; 440ba

HeyItsFruitText: ; 440ba
	text_jump _HeyItsFruitText
; 440bf

ObtainedFruitText: ; 440bf
	text_jump _ObtainedFruitText
; 440c4

FruitPackIsFullText: ; 440c4
	text_jump _FruitPackIsFullText
; 440c9

NothingHereText: ; 440c9
	text_jump _NothingHereText
; 440ce
