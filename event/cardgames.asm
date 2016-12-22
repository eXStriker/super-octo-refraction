InitializeDeck:
	ld a, $ff
	ld bc, 29
	ld hl, wCardDeck
	jp ByteFill

GetCardFromDeck: ;Takes a card out of the deck and places it into your hand
	;Let's see if there's any space
	
.checknextslot
	ld a, [hli]
	cp $80
	jr nc, .ok
	dec c
	jr nz, .checknextslot
	scf
	ret
.ok
	dec hl
	push bc
	push hl
.pickCardLoop
	call Random
	cp 52
	jr nc, .pickCardLoop ;Outside the bounds
	ld e, a
	ld d, 0
	ld hl, wCardDeck
	ld b, CHECK_FLAG
	push de
	push hl
	call FlagAction
	ld a, c
	pop hl
	pop de
	and a
	jr z, .pickCardLoop ;Card has already been chosen so check again.
	
	ld a, e
	push af
	ld b, RESET_FLAG
	call FlagAction ;Take card out of the deck
	
	pop af
	ld c, 13
	call SimpleDivide ;Quotent is suit, remainder is num
	sla b
	sla b
	sla b
	sla b
	add a, b
	pop hl
	ld [hl], a
	ld de, wStringBuffer1
	call DisplayCard
	pop bc
	ld hl, DrewCardText	
	ld a, 1
	cp b
	jr nz, .playerCard
	ld hl, DrewDealerCardFaceDownText
	
.playerCard
	ld a, 2
	cp b
	jr nz, .finishCard
	ld hl, DrewDealerCardText

.finishCard
	ld b, BANK(DrewCardText)
	call MapTextbox 
	call WaitButton
	xor a
	ret

	;hl: Hand position
	;de: String position
	
DisplayCard: ;return carry if not at the end
	ld a, [hl]
	cp $ff
	jr z, .endOfHand

	and $f ;Place Card Number
	push hl
	ld hl, CardNums
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de

	pop hl ;Check if it's 10, if so add 0 to the string
	ld a, [hl]
	push hl
	and $f
	cp 8 ;Indexer of Card 10
	jr nz, .notten ;Ten uses 2 characters
	ld a, "0"
	ld [de], a
	inc de

.notten ;Place suit
	pop hl
	ld a, [hl]
	and $30
	srl a
	srl a
	srl a
	srl a
	push hl
	ld hl, CardSuits
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	pop hl
	ld a, [hl]
	and $80 ;Upper bit determines if you're holding it or not.
	jr z, .notholding
	ld a, " "
	ld [de], a
	inc de
	ld a, "D"
	ld [de], a
	inc de

.notholding
	ld a, "@"
	ld [de], a

	inc hl
	scf
	ret

.endOfHand
	ld a, "@"
	ld [de], a
	xor a
	ret

DisplayDealerCards:
	ld hl, wDealerCardHand + 1 ;Hide first one in blackjack
	jp DisplayCardsMain

DisplayCards: ;Takes all of your cards and writes to StringBuffer1
	ld hl, wYourCardHand
DisplayCardsMain:
	ld de, wStringBuffer1

.loop
	call DisplayCard
	ret nc
	ld a, " "
	ld [de], a
	inc de
	jr .loop

CardGameNotEnoughCoinsText:
	ctxt "You don't have"
	line "enough coins."
	done

DrewCardText:
	ctxt "You drew a <STRBF1>."
	done

DrewDealerCardText:
	ctxt "Dealer drew a <STRBF1>."
	done

DrewDealerCardFaceDownText:
	ctxt "Dealer drew a"
	line "card."
	done

DisplayCardHand:
	ctxt "<STRBF1>"
	done

CardGamePlayAgain:
	ctxt "Play again?"
	done

BadHandText:
	ctxt "No luck this time."
	done


CardNums:
	db "2"
	db "3"
	db "4"
	db "5"
	db "6"
	db "7"
	db "8"
	db "9"
	db "1" ;Ten
	db "J"
	db "Q"
	db "K"
	db "A"

CardSuits:
	db "♥" ;Fire
	db "♦" ;Grass
	db "♠" ;Electric
	db "♣" ;Water
