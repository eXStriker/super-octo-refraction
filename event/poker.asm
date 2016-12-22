poker_reward: macro
	dw \1 ;Text
	dw \2 ;Payout
	dw \3 ;Sound FX
	endm

GameCornerPoker::
	opentext
	special Special_DisplayCoinCaseBalance
	writetext PokerWelcome
	yesorno
	iffalse PokerDontPlay
.choseToPlayPoker
	checkcoins 10
	if_equal 2, PokerNotEnoughCoins
	takecoins 10
	playsound SFX_TRANSACTION
	special Special_DisplayCoinCaseBalance
	waitsfx
	callasm InitializeDeck
	callasm GetPokerHand
	writetext PokerHoldWhichText

.displayCardMenu
	callasm GetCardMenu
	loadmenudata wPokerMenu
	verticalmenu
	closewindow
	if_equal 0, .drawMoreCards
	callasm HoldCard
	jump .displayCardMenu
	special Special_DisplayCoinCaseBalance
	end

.drawMoreCards
	callasm GetPokerHand
	callasm DisplayCards
	writetext DisplayCardHand
	waitbutton
	callasm CheckPokerHand
	callasm GivePokerReward
	waitsfx
	iffalse .noPrize
	playsound SFX_TRANSACTION
	special Special_DisplayCoinCaseBalance
.noPrize
	writetext CardGamePlayAgain
	yesorno
	iftrue .choseToPlayPoker
	closetext
	end

GivePokerReward:
	ld a, [hScriptVar]
	ld hl, PokerRewards
	ld bc, 6
	rst AddNTimes
	ld e, l
	ld d, h
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	ld b, BANK(GivePokerReward)

	push de
	call MapTextbox
	pop de

	;Give coins
	ld a, [de]
	inc de
	ld [hMoneyTemp + 1], a
	ld a, [de]
	inc de
	ld [hMoneyTemp], a
	ld bc, hMoneyTemp


	;Play sfx
	ld a, [de]
	ld e, a
	ld d, 0
	call PlaySFX

	jpba GiveCoins
	ret

CheckPokerHand:
	xor a ;Clear hash table
	ld [hScriptVar], a
	ld bc, 17
	ld hl, wYourCardHand + 5 ;Hash table
	call ByteFill

	;Set first suit
	ld hl, wYourCardHand + 18 ;Flags
	set 0, [hl] ;Default flush

	ld de, wYourCardHand
	ld a, [de]
	and $30
	ld b, a
	ld c, 5

.loop
	ld a, [de]
	inc de

;Check for flush
	push af
	and $30
	cp b
	jr z, .matchingsuit
	ld hl, wYourCardHand + 18 ;Flags
	res 0, [hl] ;Flush failed
.matchingsuit ;Create hash table
	pop af
	and $f
	push bc
	ld hl, wYourCardHand + 5
	ld c, a
	ld b, 0
	add hl, bc
	inc [hl]
	ld a, [hl]
	pop bc
	dec c
	jr nz, .loop

.checkforpairs
	ld bc, 13
	ld hl, wYourCardHand + 5

.pairloop
	ld a, [hli]
	push hl
	ld hl, wYourCardHand + 18
	cp 4
	jp z, .fourOfAKind
	cp 3
	jp z, .threeOfAKind
	cp 2
	jp z, .twoOfAKind
.paircheckend
	pop hl
	dec c
	jr nz, .pairloop

;Check for straight
	ld hl, wYourCardHand + 5
	ld c, 10
	ld a, [wYourCardHand + 17]
	and a
	jr nz, .acestraight

	ld c, 10

.findfirstcardloop
	dec c
	jr z, .checkPokerFlags
	ld a, [hli]
	and a
	jr z, .findfirstcardloop

	ld a, 2
	cp c
	jr nz, .notRoyal
	push hl
	ld hl, wYourCardHand + 18
	set 7, [hl]
	pop hl

.notRoyal

;Found first card in hash table, check if any succeed it.
	ld c, 4
.straightLoop
	ld a, [hli]
	and a
	jr z, .checkPokerFlags
	dec c
	jr nz, .straightLoop

	ld b, 5
	call .changeReward

	;It's a straight
	ld hl, wYourCardHand + 18
	bit 0, [hl]
	jr nz, .straightflush

.checkPokerFlags
	ld hl, wYourCardHand + 18
	bit 0, [hl]
	ret z
	ld b, 4
	jp .changeReward

.acestraight ;Check ace low straight
	ld a, [hli]
	and a
	jr z, .findfirstcardloop ;2 isn't in hand so you can't do an ace low straight
	ld c, 3
	jr .straightLoop

.straightflush
	ld b, 8
	call .changeReward
	bit 7, [hl]
	ret z
	ld b, 9

.changeReward ;takes b
	ld a, [hScriptVar]
	cp b
	ret nc
	ld a, b
	ld [hScriptVar], a
	ret

.fourOfAKind
	ld hl, wYourCardHand + 18
	set 5, [hl]
	ld b, 7
	call .changeReward
	jp .paircheckend

.twoOfAKind
	ld hl, wYourCardHand + 18
	bit 3, [hl]
	jr nz, .fullhouse
	bit 1, [hl]
	jr nz, .twopair
	set 1, [hl]
	ld b, 1
	call .changeReward
	jp .paircheckend

.threeOfAKind
	ld hl, wYourCardHand + 18
	set 3, [hl]
	bit 1, [hl]
	jr nz, .fullhouse
	ld b, 3
	call .changeReward
	jp .paircheckend

.fullhouse
	set 4, [hl]
	ld b, 6
	call .changeReward
	jp .paircheckend

.twopair
	set 2, [hl]
	ld b, 2
	call .changeReward
	jp .paircheckend

;Flags:
;0 - Flush
;1 - Pair
;2 - Two Pair
;3 - Three of a Kind
;4 - Full House
;5 - Four of a Kind
;7 - Royal Potential

HoldCard:
	ld a, [hScriptVar]
	dec a
	ld c, a
	ld b, 0
	ld hl, wYourCardHand
	add hl, bc
	ld a, [hl]
	bit 7, [hl]
	jr z, .turnOn
	res 7, [hl]
	ret

.turnOn
	set 7, [hl]
	ret

GetPokerHand:
.loop
	lb bc, 0, 5
	ld hl, wYourCardHand

	call GetCardFromDeck
	jr nc, .loop
	ret

GetCardMenu: ;Preparees a card menu
	ld hl, wYourCardHand
	ld de, wStringBuffer1
	ld a, $80
	ld [de], a
	inc de
	ld a, 5
	ld [de], a
	inc de

.loop
	call DisplayCard
	jr nc, .setMenuHeader
	inc de
	jr .loop

.setMenuHeader
	ld hl, PokerMenu
	ld de, wPokerMenu
	ld bc, $7
	rst CopyBytes
	ld a, [hScriptVar]
	ld [wPokerMenu + 7], a
	ret

PokerNotEnoughCoins:
	jumptext CardGameNotEnoughCoinsText

PokerDontPlay:
	closetext
	end

PokerMenu:
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 8 ; end coords
	dw wStringBuffer1
	db 1 ; default option

PokerWelcome:
	ctxt "Welcome to Poker!"

	para "Want to play?"
	done

PokerHoldWhichText:
	ctxt "Press A to"
	line "discard a card."

	para "Press B to draw."
	done

PairText:
	ctxt "Pair"
	done

TwoPairText:
	ctxt "Two Pair"
	done

ThreeofaKindText:
	ctxt "Three of a kind"
	done

FourofaKindText:
	ctxt "Four of a kind"
	done

StraightText:
	ctxt "Straight"
	done

FlushText:
	ctxt "Flush"
	done

FullHouseText:
	ctxt "Full House"
	done

StraightFlushText:
	ctxt "Straight Flush"
	done

RoyalFlushText:
	ctxt "ROYAL FLUSH!"
	done

PokerRewards:
	poker_reward BadHandText, 0, SFX_WRONG
	poker_reward PairText, 10, SFX_ITEM
	poker_reward TwoPairText, 20, SFX_FANFARE_2
	poker_reward ThreeofaKindText, 30, SFX_DEX_FANFARE_LESS_THAN_20
	poker_reward FlushText, 65, SFX_DEX_FANFARE_170_199
	poker_reward StraightText, 40, SFX_DEX_FANFARE_140_169
	poker_reward FullHouseText, 100, SFX_DEX_FANFARE_200_229
	poker_reward FourofaKindText, 250, SFX_DEX_FANFARE_230_PLUS
	poker_reward StraightFlushText, 1000, SFX_DEX_FANFARE_230_PLUS
	poker_reward RoyalFlushText, 2500, SFX_DEX_FANFARE_230_PLUS
