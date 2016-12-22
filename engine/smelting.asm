	const_def
	const ORE_ZINC
	const ORE_COPPER
	const ORE_LEAD
	const ORE_IRON
	const ORE_BRONZE
	const ORE_SILVER
	const ORE_RUTHENIUM
	const ORE_GOLD
	const ORE_COBALT
	const ORE_PRISM

Smelting:
	opentext
	checkitem ORE
	iffalse .noore
	checkitem COAL
	iftrue .coalandore

.smeltore
	playwaitsfx SFX_BURN
	takeitem ORE, 1
	callasm ChooseOre
	if_equal $ff, .failedSmelt
	if_equal ORE_ZINC, .givezinc
	if_equal ORE_COPPER, .givecopper
	if_equal ORE_LEAD, .givelead
	if_equal ORE_IRON, .giveiron
	if_equal ORE_BRONZE, .givebronze
	if_equal ORE_SILVER, .givesilver
	if_equal ORE_RUTHENIUM, .giveruthenium
	if_equal ORE_GOLD, .givegold
	if_equal ORE_COBALT, .givecobalt
	if_equal ORE_PRISM, .giveprism

.smeltingFinish
	writetext GotOreText
	waitbutton
	givesmeltingEXP
	closetext
	end

.coalandore
	writetext ChooseSmeltText

	loadmenudata WhichToSmelt
	verticalmenu
	closewindow
	if_equal $1, .smeltore
	if_equal $2, .smeltcoal

	closetext
	end

.givezinc
	givemoney 0, 10
	jump .smeltingFinish

.givecopper
	givemoney 0, 25
	jump .smeltingFinish

.givelead
	givemoney 0, 50
	jump .smeltingFinish

.giveiron
	givemoney 0, 200
	jump .smeltingFinish

.givebronze
	givemoney 0, 500
	jump .smeltingFinish

.givesilver
	givemoney 0, 1000
	jump .smeltingFinish

.giveruthenium
	givemoney 0, 3500
	jump .smeltingFinish

.givegold
	givemoney 0, 5000
	jump .smeltingFinish

.givecobalt
	givemoney 0, 7500
	jump .smeltingFinish

.giveprism
	givemoney 0, 10000
	jump .smeltingFinish

.failedSmelt
	writetext FailedSmeltText
	endtext

.noore
	checkitem COAL
	iftrue .smeltcoal

	writetext NoOreText
	endtext

.smeltcoal
	checkitem SOOT_SACK
	iffalse .nosootsack

	playwaitsfx SFX_BURN
	takeitem COAL, 1
	callasm ExtractAsh
	writetext CollectedAshText
	waitbutton

	random 4
	if_equal 2, .giveexpfromcoal

	closetext
	end

.giveexpfromcoal
	givesmeltingEXP
	closetext
	end

.nosootsack
	writetext NoSootSackText
	endtext

ExtractAsh:
	ld a, [SmeltingLevel]
	ld b, 10
	add a, b
	ld b, a
.random
	call Random
	cp b
	jr nc, .random

	ld b, a
	ld a, 10
	add a, b

	ld [TempNumber], a
	ld [hMoneyTemp + 1], a
	xor a

	ld [TempNumber + 1], a
	ld [hMoneyTemp], a
	ld bc, hMoneyTemp
	jpba GiveAsh


ChooseOre:
	ld hl, OrePercentChances
.randomloop
	call Random
	cp 100
	jr nc, .randomloop
	inc a ; 1 <= a <= 100
	push af
	push bc

	ld b, a ;Chosen Ore Index: 60
	ld a, [SmeltingLevel] ;Smelting Level: 82
	ld c, a ; c = 82
	ld a, 100 ;a = 100
	sbc a, c ; a = 100 - 82 = 18
	srl a ;a = 9
	ld c, a
	ld a, 100
	sbc a, c ;100 - 9 = 91 (So any index from 91 + should return carry)
	cp b
	jr c, .notHighEnoughLvl

	pop bc
	pop af
	ld b, a
.prob_bracket_loop
	ld a, [hli]
	cp b
	jr nc, .got_it
	inc hl
	jr .prob_bracket_loop
.got_it
	ld a, [hl]
	push af
	ld [hScriptVar], a
	ld hl, OreNames
	call GetNthString
	ld de, wStringBuffer1
	ld bc, 12
	rst CopyBytes

	ld hl, OrePrices
	pop af
	sla a
	ld c, a
	ld b, 0
	add hl, bc

	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld hl, TempNumber
	ld a, b
	ld [hli], a
	ld a, c
	ld [hl], a
	ret

.notHighEnoughLvl
	pop af
	pop bc
	ld a, $ff
	ld [hScriptVar], a
	ret

OrePrices:
	dw 10
	dw 25
	dw 50
	dw 200
	dw 500
	dw 1000
	dw 3500
	dw 5000
	dw 7500
	dw 10000

WhichToSmelt:
	db $40 ; flags
	db 04, 00 ; start coords
	db 11, 9 ; end coords
	dw .MenuDataSmelt
	db 1 ; default option

.MenuDataSmelt:
	db $80 ; flags
	db 3 ; items
	db "Ore@"
	db "Coal@"
	db "Cancel@"

ChooseSmeltText::
	ctxt "Which would you"
	line "like to smelt?"
	done

FailedSmeltText::
	ctxt "You failed at"
	line "smelting this ore."
	done

GotOreText::
	ctxt "You smelted a"
	line "<STRBF1> Ore!"

	para "Got coins worth"
	line "¥@"
	deciram TempNumber, 2, 0
	ctxt "!"
	done

NoOreText::
	ctxt "You need Ore or"
	line "Coal to smelt."
	done

CollectedAshText::
	ctxt "You were able to"
	line "collect @"
	deciram hMoneyTemp, 2, 0
	ctxt " ash!"
	done

NoSootSackText:
	ctxt "You can't hold"
	line "onto ash without"
	cont "a Soot Sack."
	done

OreNames:
	db "Zinc@" ;10
	db "Copper@" ;25
	db "Lead@" ;50
	db "Iron@" ;200
	db "Bronze@" ;500
	db "Silver@" ;1000
	db "Ruthenium@" ;3500
	db "Gold@" ;5000
	db "Cobalt@" ;7500
	db "Prism@" ;10000

OrePercentChances: ; 2a1cb Reveal a new ore every X
	;ALL LEVELS
	db 11,  ORE_ZINC ;11%
	db 22,  ORE_COPPER ;11%
	db 32,  ORE_LEAD ;10%
	db 42,  ORE_IRON ;10%
	db 52,  ORE_BRONZE ;10%
	;LEVEL 4
	db 55,  ORE_SILVER ;3%
	db 56,  ORE_LEAD ;1%
	;LEVEL 12
	db 58,  ORE_RUTHENIUM  ;2%
	db 59,  ORE_COPPER  ;1%
	db 60,  ORE_BRONZE  ;1%
	;LEVEL 20
	db 62,  ORE_GOLD  ;2%
	db 63,  ORE_LEAD  ;1%
	db 65,  ORE_ZINC  ;2%
	;LEVEL 30
	db 67,  ORE_COBALT  ;2%
	db 69,  ORE_COPPER  ;2%
	db 71,  ORE_LEAD  ;2%
	db 73,  ORE_IRON  ;2%
	db 74,  ORE_RUTHENIUM  ;1%
	db 75,  ORE_GOLD  ;1%
	;LEVEL 50
	db 76,  ORE_PRISM  ;1%
	db 77,  ORE_ZINC  ;1%
	db 78,  ORE_COPPER  ;1%
	db 79,  ORE_LEAD  ;1%
	db 80,  ORE_IRON  ;1%
	db 81,  ORE_BRONZE  ;1%
	db 85,  ORE_SILVER  ;4%
	db 87,  ORE_RUTHENIUM  ;2%
	db 88,  ORE_GOLD  ;1%
	db 89,  ORE_COBALT  ;1%
	db 91,  ORE_ZINC  ;2%
	db 93,  ORE_RUTHENIUM  ;2%
	db 94,  ORE_SILVER  ;1%
	db 96,  ORE_GOLD  ;2%
	db 98,  ORE_SILVER  ;2%
	db 99,  ORE_RUTHENIUM  ;1%
	db 100, ORE_COBALT, ;1%

;Zinc: 16%
;Copper: 15%
;Lead: 14%
;Iron: 13%
;Bronze: 12%
;Silver: 11%
;Ruthenium: 8%
;Gold: 6%
;Cobalt: 4%
;Prism: 1%
