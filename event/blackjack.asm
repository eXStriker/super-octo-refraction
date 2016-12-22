GameCornerBlackjack::
	opentext
	special Special_DisplayCoinCaseBalance
	writetext BlackjackWelcome
	yesorno
	iffalse BlackjackDontPlay

.choseplayblackjack
	writetext BetAmountText
	loadmenudata BlackjackBetMenu
	verticalmenu
	closewindow
	iffalse BlackjackDontPlay
	callasm SetBetType
	callasm BlackjackPlaceBet
	if_equal 2, BlackjackNotEnoughCoins

.blackjackprepare
	playsound $22
	special Special_DisplayCoinCaseBalance
	waitsfx
	callasm BlackjackInit

.blackjackloop
	writetext BlackjackWhatToDo
	loadmenudata BlackjackMenu
	verticalmenu
	closewindow
	if_equal 1, .hit
	if_equal 2, .stand
	if_equal 3, .doubledown
	if_equal 4, .yourhand
	if_equal 5, .dealerhand
	jump .blackjackloop
	end

.cantdoubledown
	writetext CardGameNotEnoughCoinsText
	waitbutton
	jump .blackjackloop

.doubledown
	callasm BlackjackBetMain
	if_equal 2, .cantdoubledown
	playsound $22
	special Special_DisplayCoinCaseBalance
	waitsfx
	callasm DoubleDown
	callasm BlackjackHit
	callasm CountPlayerCards
	writetext DisplayCount
	waitbutton
	if_equal 1, .playerbust
	jump .stand

.yourhand
	callasm DisplayCards
	writetext DisplayCardHand
	waitbutton
	jump .blackjackloop

.dealerhand
	callasm DisplayDealerCards
	writetext BlackjackDealersHandText
	waitbutton
	jump .blackjackloop

.hit
	callasm BlackjackHit
	callasm CountPlayerCards
	writetext DisplayCount
	waitbutton
	if_equal 0, .blackjackloop
	jump .playerbust

.stand
	callasm BlackjackStand
	writetext DealerDisplaysWholeDeck
	waitbutton
	callasm GetFullDealerHand
	writetext DisplayCardHand
	waitbutton
	writetext DisplayDealerCount
	waitbutton
	callasm CheckIfDealerBusted
	if_equal 1, .dealerbusted
	callasm CountPlayerCards
	writetext DisplayCount
	waitbutton
	callasm DetermineBlackjackWinner
	if_equal 1, .win
	if_equal 2, .push
	writetext BadHandText
	playwaitsfx SFX_WRONG
	special Special_DisplayCoinCaseBalance
	waitbutton
	jump .blackjackaskplayagain

.dealerbusted
	writetext DealerBustedText
	waitbutton
.win
	writetext YouWonText
	playwaitsfx SFX_DEX_FANFARE_170_199
	playsound SFX_TRANSACTION
	callasm BlackjackWonCoins
	special Special_DisplayCoinCaseBalance
	waitbutton
	jump .blackjackaskplayagain

.push
	writetext PushText
	playsound SFX_TRANSACTION
	callasm BlackjackPushCoins
	special Special_DisplayCoinCaseBalance
	waitbutton

.blackjackaskplayagain
	writetext CardGamePlayAgain
	yesorno
	iftrue .choseplayblackjack
	closetext
	end

.playerbust
	writetext BlackjackBustedText
	playwaitsfx SFX_WRONG
	writetext CardGamePlayAgain
	yesorno
	iftrue .choseplayblackjack
	closetext
	end

DoubleDown:
	ld hl, TempNumber + 1
	set 2, [hl]
	ret

BlackjackGetBetAmount:
	ld a, [TempNumber + 1]
	and 3
	ld hl, BlackjackBets
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ret

BlackjackPlaceBet:
	ld a, [hScriptVar]
	dec a
	ld [TempNumber + 1], a
BlackjackBetMain:
	call BlackjackGetBetAmount
	ld c, a
	ld [hMoneyTemp + 1], a
	xor a
	ld [hMoneyTemp], a

	ld bc, hMoneyTemp
	callba CheckCoins

	jr c, .two
	jr z, .one
	xor a
	ld [hScriptVar], a
	jpba TakeCoins
	ret
.one
	ld a, 1
	ld [hScriptVar], a
	jpba TakeCoins
	ret
.two
	ld a, 2
	ld [hScriptVar], a
	ret

BlackjackWonCoins:
	call BlackjackGetBetAmount
	sla a
	jr BlackjackGiveCoins

BlackjackPushCoins:
	call BlackjackGetBetAmount
BlackjackGiveCoins:
	ld l, a
	ld h, 0
	push hl
	ld hl, TempNumber + 1
	bit 2, [hl]
	pop hl
	jr z, .nodoubledown
	add hl, hl
.nodoubledown
	ld a, l
	ld [hMoneyTemp + 1], a
	ld a, h
	ld [hMoneyTemp], a

	ld bc, hMoneyTemp
	jpba GiveCoins
	ret

SetBetType:
	ld a, [hScriptVar]
	dec a
	ld [TempNumber + 1], a
	ret

CheckIfDealerBusted:
	xor a
	ld [hScriptVar], a
	ld a, [TempNumber]
	cp 22
	jr nc, .dealerbusted
	ret

.dealerbusted
	ld a, 1
	ld [hScriptVar], a
	ret

BlackjackStand:
.drawto17
	call BlackjackGetDealerCard
	jr nc, .drawto17
	ret

GetFullDealerHand:
	ld hl, wDealerCardHand
	jp DisplayCardsMain

BlackjackHit:
	xor a
	ld [hScriptVar], a
	call BlackjackGetPlayerCard
	call CountPlayerCards
	cp 22
	jr nc, .playerbust
	jp BlackjackGetDealerCard

.playerbust
	ld a, 1
	ld [hScriptVar], a
	ret

DetermineBlackjackWinner:
	ld a, [TempNumber]
	ld b, a
	push bc
	call CountDealerCards
	pop bc
	ld a, [TempNumber]  ;a: dealer b: yours
	cp b
	jr z, .push
	jr c, .win
	xor a
	ld [hScriptVar], a
	ret

.push
	ld a, 2
	ld [hScriptVar], a
	ret

.win
	ld a, 1
	ld [hScriptVar], a
	ret

BlackjackInit:
	call InitializeDeck
	call BlackjackGetPlayerCard
	call BlackjackGetPlayerCard
	call BlackjackGetDealerCard
	jp BlackjackGetDealerCardFaceDown

CountDealerCards:
	ld hl, wDealerCardHand
	jp CountCards

CountPlayerCards:
	ld hl, wYourCardHand

CountCards:
	ld b, 0 ;Ace
	ld c, 0 ;Sum
.loop
	ld a, [hli]
	cp $ff
	jr z, .checkAce
	and $f
	inc a
	inc a

	cp 10 ;Face card
	jr nc, .facecard

.addcard
	add c
	ld c, a
	jr .loop

.checkAce
	ld a, c
	cp 12 ;Dont add ace bonus if it'll exceed 21
	jr nc, .end

	ld a, 1 ;Check if an ace was encountered
	cp b
	jr nz, .end

	ld a, c ;If all checks out, add 10
	add 10
	ld [TempNumber], a
	ret

.end
	ld a, c
	ld [TempNumber], a
	ret

.facecard
	cp 14
	jr z, .blackjackace
	ld a, 10
	jr .addcard

.blackjackace
	ld a, 1
	ld b, 1
	jr .addcard

BlackjackGetPlayerCard:
	ld hl, wYourCardHand
	lb bc, 0, 11
	jp GetCardFromDeck

BlackjackGetDealerCard:
	ld hl, wDealerCardHand
	call CountCards
	cp 17
	jr nc, .stand ;Stand on 17
	ld hl, wDealerCardHand
	lb bc, 1, 11
	call GetCardFromDeck
	xor a
	ret

.stand
	ld hl, DealerStandsText
	ld b, BANK(DealerStandsText)
	call MapTextbox
	call WaitButton
	scf
	ret

BlackjackGetDealerCardFaceDown:
	ld hl, wDealerCardHand
	lb bc, 2, 11
	jp GetCardFromDeck


BlackjackNotEnoughCoins:
	jumptext BlackjackNotEnoughCoinsText

BlackjackDontPlay:
	closetext
	end

BlackjackWelcome:
	ctxt "Welcome to"
	line "Blackjack!"

	para "Want to play?"
	done

BlackjackNotEnoughCoinsText:
	ctxt "You don't have"
	line "enough coins."
	done

DisplayCount:
	ctxt "Your total: @"
	deciram TempNumber, 1, 0
	ctxt ""
	done

DisplayDealerCount:
	ctxt "Dealer total: @"
	deciram TempNumber, 1, 0
	ctxt ""
	done


BlackjackBustedText:
	ctxt "You busted!"
	done

BlackjackWhatToDo:
	ctxt "What do you want"
	line "to do?"
	done

BlackjackDealersHandText:
	ctxt "? <STRBF1>"
	done

DealerStandsText:
	ctxt "Dealer stands."
	done

PushText:
	ctxt "Push!"
	done

YouWonText:
	ctxt "You won!"
	done

DealerDisplaysWholeDeck:
	ctxt "Dealer reveals the"
	line "face down card."
	done

DealerBustedText:
	ctxt "The dealer busted!"
	done

BetAmountText:
	ctxt "How much do you"
	line "want to bet?"
	done

BlackjackMenu:
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 15 ; end coords
	dw BlackjackOptions
	db 1 ; default option

BlackjackOptions:
	db $80
	db $5
	db "Hit@"
	db "Stand@"
	db "Double Down@"
	db "Your hand@"
	db "Dealer's hand@"

BlackjackBetMenu:
	db $40 ; flags
	db 00, 00 ; start coords
	db 9, 7 ; end coords
	dw BlackjackBetOptions
	db 1 ; default option

BlackjackBetOptions:
	db $80
	db $4
	db "10@"
	db "25@"
	db "50@"
	db "100@"

BlackjackBets:
	db 10
	db 25
	db 50
	db 100
