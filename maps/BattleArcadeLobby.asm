BattleArcadeLobby_MapScriptHeader:

;trigger count
	db 0
;callback count
	db 0

BattleArcadeLobbyInstructionsNPC:
	jumptextfaceplayer BattleArcadeLobbyInstructionsNPC_Text

BattleArcadeLobbyBattleNPC:
	opentext
	special PlaceMoneyTopRight
	writetext BattleArcadeLobbyBattleNPC_Text_Enter
	loadmenudata BattleArcadeLobby_EnterMenu
	verticalmenu
	closewindow
	anonjumptable
	dw .come_back_later
	dw .enter
	dw .instructions
	dw .come_back_later
.instructions
	writetext BattleArcadeLobbyBattleNPC_Text_Instructions
	waitbutton
	writetext BattleArcadeLobbyBattleNPC_Text_EnterInsist
	yesorno
	sif false
.come_back_later
		jumptext BattleArcadeLobby_Text_ComeBackLater
.enter
	checkcode VAR_PARTYCOUNT
	sif <, 3
		jumptext BattleArcadeLobby_Text_RequireThreePokemon
	callasm BattleArcadeLobby_LegalityCheck
	sif <, 3
		jumptext BattleArcadeLobby_Text_NotLevelForty
	checkmoney 0, 500
	sif =, 2
		jumptext BattleArcadeLobby_Text_NeedMoreMoney
	takemoney 0, 500
	waitsfx ;wait for the text's "click" sound to end
	special PlaceMoneyTopRight
	playwaitsfx SFX_TRANSACTION
.selection_loop
	writetext BattleArcadeLobby_Text_SelectParty
	waitbutton
	callasm BattleArcadeLobby_LegalityCheck
	callasm ChooseThreePartyMonsForBattle
	sif false, then
		writetext BattleArcadeLobby_Text_CancelChallenge
		yesorno
		iffalse .selection_loop
		givemoney 0, 500
		jumptext BattleArcadeLobby_Text_Refund
	sendif
	writetext BattleArcadeLobby_Text_EnterToBegin
	waitbutton
	closetext
	applymovement PLAYER, .entrance_movement
	special ClearBGPalettes
	warpsound
	waitsfx
	warp BATTLE_ARCADE_BATTLEROOM, 4, 7
	applymovement PLAYER, .approach_machine
	farscall MainArcadeScript
	applymovement PLAYER, .leave_machine
	warpsound
	waitsfx
	warp BATTLE_ARCADE_LOBBY, 5, 0
	applymovement PLAYER, .exit_movement
	spriteface PLAYER, UP
	jumptext BattleArcadeLobby_Text_ThanksForPlaying
.entrance_movement
	step_right
	step_right
	step_right
	step_up
	step_up
	step_up
	remove_person
	step_end
.exit_movement
	step_down
	step_down
	step_down
	step_left
	step_left
	step_left
	step_end
.approach_machine
	step_left
	step_left
	step_up
	step_up
	step_up
	step_left
	step_end
.leave_machine
	step_right
	step_down
	step_down
	step_down
	step_right
	step_right
	turn_head_down
	remove_person
	step_end

BattleArcadeLobby_EnterMenu:
	db $40 ;flags (?)
	db 4, 4 ;start coordinates (y, x)
	db 11, 19 ;end coordinates (y, x) -- final y - initial y = 2 * items + 1, final x - initial x = longest item + 3
	dw .options
	db 1 ;default option
.options
	db $a0 ;flags 2.0 (??)
	db 3 ;option count
	db "Enter arcade@"
	db "Instructions@"
	db "Cancel@"

BattleArcadeLobbyRedeemNPC:
	opentext
	writetext BattleArcadeLobbyRedeemNPC_Text_Redeem
	waitbutton
	closetext
	callasm BattleArcadeRedeemMenu
	end

BattleArcadeRedeemMenu:
	call LoadStandardMenuDataHeader

	call ClearScreen
	call HideSprites

	xor a
	ld [wMenuScrollPosition], a
	inc a
	ld [wBattleArcadeMenuCursorBuffer], a
	ld a, "│"
	coord hl, 0, 11
	ld [hli], a
	ldcoord_a 19, 11
	ld de, .TicketsString
	call PlaceText
.loop
	ld hl, wBattleArcadeTickets

	ld b, 0
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]

	coord hl, 11, 11
	ld a, 7
	ld [hDigitsFlags], a
	predef PrintBigNumber

.choseNo
	ld hl, BattleArcadeReedemMenuDataHeader
	call CopyMenuDataHeader
	call InitScrollingMenu
	ld a, [wBattleArcadeMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	call ScrollingMenu
	cp B_BUTTON
	jp z, CloseWindow
	ld a, [wMenuCursorY]
	ld [wBattleArcadeMenuCursorBuffer], a
	ld a, [wMenuSelection]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, BattleArcadeLobby_SoYouWantPrizeText
	call PrintText
	call YesNoBox
	jr c, .choseNo ; chose no
	ld a, [wMenuSelection]
	cp MYSTERY_TCKT
	jr nz, .notMysteryTicket
	ld hl, EventFlags + (EVENT_GET_MYSTERY_TICKET / 8)
	bit (EVENT_GET_MYSTERY_TICKET % 8), [hl]
	jr nz, .alreadyHaveMysteryTicket
	ld de, 300 ; price
	jr .gotPrice
.notMysteryTicket
	ld a, [MenuSelectionQuantity]
	ld e, a
	ld d, 0
.gotPrice
	ld hl, wBattleArcadeTickets
	ld a, [hli]
	and a
	jr nz, .enoughTickets
	ld a, [hli]
	cp d
	jr c, .notEnoughTickets
	jr nz, .enoughTickets
	ld a, [hli]
	cp e
	jr c, .notEnoughTickets
.enoughTickets
	ld a, [wMenuSelection]
	cp MYSTERY_TCKT
	jr nz, .not_buying_mystery_ticket
	ld hl, EventFlags + (EVENT_GET_MYSTERY_TICKET / 8)
	set (EVENT_GET_MYSTERY_TICKET % 8), [hl]
.not_buying_mystery_ticket
	ld hl, wBattleArcadeTickets + 2
	ld a, [hl]
	sub e
	ld [hld], a
	ld a, [hl]
	sbc d
	ld [hld], a
	ld a, [hl]
	sbc 0
	ld [hl], a

	ld a, [wMenuSelection]
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	ld hl, NumItems
	call ReceiveItem
	ld de, SFX_TRANSACTION
	call WaitPlaySFX
	ld hl, BattleArcadeLobby_HereYouAreThankYouText
	call PrintText
	call WaitButton
	jp .loop
.alreadyHaveMysteryTicket
	ld hl, BattleArcadeLobby_AlreadyHaveItemText
	jr .printFailureTextAndLoop
.notEnoughTickets
	ld hl, BattleArcadeLobby_YouDontHaveEnoughTicketsText
.printFailureTextAndLoop
	call PrintText
	call WaitButton
	jp .choseNo

.TicketsString
	ctxt "Tickets:"
	done

BattleArcadeReedemMenuDataHeader:
	db $40 ; flags
	db 01, 01 ; start coords
	db 09, 18 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db %10100000 ; flags
	db 4, SCREEN_WIDTH + 13 ; rows, columns
	db 2 ; horizontal spacing
	dba BattleArcadePrizesAndCosts
	dba PlaceMenuItemName
	dba PlaceMenuItemTicketPrice
	dba UpdateItemDescription

BattleArcadePrizesAndCosts:
	db 14
	db LUCKY_PUNCH,   20
	db RARE_CANDY,    25
	db EVERSTONE,     30
	db CORONETSTONE,  40
	db SILVERPOWDER,  50
	db RAZOR_FANG,    55
	db RAZOR_CLAW,    60
	db DRAGON_FANG,   75
	db FRIEND_BALL,  100
	db MAX_REVIVE,   120
	db MAX_ELIXIR,   150
	db PP_UP,        200
	db SACRED_ASH,   250
	db MYSTERY_TCKT,   0
	db $ff

PlaceMenuItemTicketPrice:
	ld h, d
	ld l, e
	ld de, MenuSelectionQuantity
	ld a, [de]
	and a ; mystery ticket price
	jr nz, .useQuantity
	ld a, "3"
	ld [hli], a
	ld a, "0"
	ld [hli], a
	ld [hl], a
	ret
.useQuantity
	lb bc, 1, 3
	jp PrintNum

BattleArcadeLobby_SoYouWantPrizeText:
	ctxt "So you want"
	line "<STRBF1>?"
	done

BattleArcadeLobby_HereYouAreThankYouText:
	ctxt "Here you are."
	line "Thank you!"
	done

BattleArcadeLobby_YouDontHaveEnoughTicketsText:
	ctxt "You don't have"
	line "enough tickets."
	done

BattleArcadeLobby_AlreadyHaveItemText:
	ctxt "Sorry, only one"
	line "Mystery Tckt per"
	cont "person."
	done

BattleArcadeLobby_Door:
	jumptext BattleArcadeLobby_Text_Door

BattleArcadeLobby_HighScoreDisplay:
	jumptext BattleArcadeLobby_Text_HighScores

BattleArcadeLobbyInstructionsNPC_Text:
	ctxt "The battles you"
	line "encounter are"
	cont "completely"
	cont "randomized!"

	para "The more fights"
	line "you win in a"
	cont "row, the more"
	cont "Arcade Tickets"
	cont "you get."

	para "You can exchange"
	line "them for some"
	cont "cool stuff!"
	done

BattleArcadeLobbyRedeemNPC_Text_Redeem:
	ctxt "Welcome!"

	para "We can redeem your"
	line "Arcade Tickets"
	cont "for prizes here!"

	done

BattleArcadeLobbyBattleNPC_Text_Enter:
	ctxt "Welcome to the"
	line "Battle Arcade!"

	para "It costs ¥500"
	line "per try. Would"
	cont "you like to"
	cont "enter?"
	done

BattleArcadeLobbyBattleNPC_Text_Instructions:
	ctxt "You will face a"
	line "series of random"

	para "parties until your"
	line "party faints and"
	cont "you can't continue."

	para "Your PP will be"
	line "restored between"

	para "battles, but your"
	line "party will not be"
	cont "otherwise healed."

	para "The parties will"
	line "be generated"

	para "randomly at the"
	line "start of every"

	para "battle, and they"
	line "will slowly rise"

	para "in difficulty as"
	line "you progress."

	para "At the end of"
	line "every round, your"

	para "performance in"
	line "battle will be"

	para "scored, and you"
	line "will receive a"

	para "number of points"
	line "based on it. The"

	para "amount of points"
	line "you receive every"

	para "round will be"
	line "multiplied by the"

	para "round number, so"
	line "a longer streak"

	para "will yield much"
	line "higher scores."

	para "When you finish"
	line "your battles,"

	para "your total score"
	line "will be shown,"

	para "and you will"
	line "receive one"

	para "Arcade Ticket for"
	line "every 300 points."

	para "You can exchange"
	line "those tickets on"

	para "the counter on"
	line "the right for"
	cont "various prizes."

	done

BattleArcadeLobbyBattleNPC_Text_EnterInsist:
	ctxt "So, do you want to"
	line "enter? It costs"
	cont "¥500 per try."
	done

BattleArcadeLobby_Text_ComeBackLater:
	ctxt "OK then, come"
	line "back some other"
	cont "time!"
	done

BattleArcadeLobby_Text_RequireThreePokemon:
	ctxt "You must have"
	line "at least three"

	para "#mon in your"
	line "team to enter."

	para "You can use the"
	line "computer nearby"

	para "to organize your"
	line "team."
	done

BattleArcadeLobby_Text_NeedMorePoints:
	ctxt "You don't have"
	line "enough tickets."
	done

BattleArcadeLobby_Text_NotLevelForty:
	ctxt "Sorry, your"
	line "#mon must be"

	para "at least level 40"
	line "to participate."

	para "You can use the"
	line "computer nearby"

	para "to organize your"
	line "team."
	done

BattleArcadeLobby_Text_SelectParty:
	ctxt "Please select the"
	line "#mon you want"
	cont "to battle with."
	done

BattleArcadeLobby_Text_EnterToBegin:
	ctxt "Wonderful!"

	para "Please enter the"
	line "arcade room to"

	para "begin your"
	line "battles!"
	done

BattleArcadeLobby_Text_AlreadyHaveItem:
	ctxt "You already have"
	line "this item."
	done

BattleArcadeLobby_Text_NeedMoreMoney:
	ctxt "Sorry, you don't"
	line "have enough money"
	cont "to enter."
	done

BattleArcadeLobby_Text_ThanksForPlaying:
	ctxt "Thanks for"
	line "playing, come"
	cont "again!"
	done

BattleArcadeLobby_Text_CancelChallenge:
	ctxt "Are you sure you"
	line "want to leave?"
	done

BattleArcadeLobby_Text_Refund:
	ctxt "Your ¥500 will now"
	line "be refunded."

	para "We hope you enter"
	line "the challenge next"
	cont "time. Come again!"
	done

BattleArcadeLobby_Text_Door:
	ctxt "It is locked!"
	line "A sign on it says,"

	para "BATTLE ARCADE"
	line "PLAYERS ONLY"
	done

BattleArcadeLobby_Text_HighScores:
	start_asm
	push bc
	ld hl, wBattleArcadeMaxScore
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	push hl
	ld hl, wStringBuffer1
	ld a, $8a
	ld [hDigitsFlags], a
	predef PrintBigNumber
	ld bc, 0
	pop hl
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, 3
	ld [hDigitsFlags], a
	ld hl, wStringBuffer3
	predef PrintBigNumber
	ld a, "@"
	ld [wStringBuffer1 + 10], a
	ld [wStringBuffer3 + 3], a
	pop bc
	ld hl, .text
	ret
.text
	ctxt "Current Arcade"
	line "high scores:"

	para "Score: <STRBF1>"
	line "Rounds won:   <STRBF3>"
	done

BattleArcadeLobby_LegalityCheck:
	ld hl, wPartyCount
	ld a, [hli]
	ld c, a
	ld d, a
	ld b, 0
.loop_species
	sla b
	ld a, [hli]
	and a
	jr z, .checked_species
	inc a
	jr z, .checked_species
	cp EGG + 1 ; a has been incremented
	jr z, .checked_species
	set 0, b
.checked_species
	dec c
	jr nz, .loop_species
	ld c, d
	push bc
	ld b, 0
	ld de, wPartyMon2 - wPartyMon1
	ld hl, PartyMon1Level
.loop_level
	sla b
	ld a, [hl]
	add hl, de
	cp 40
	jr c, .checked_level
	set 0, b
.checked_level
	dec c
	jr nz, .loop_level
	ld a, b
	pop bc
	and b
	ld b, 0
	ld d, b
.loop_bits
	rrca
	jr nc, .no_increment
	inc d
.no_increment
	rl b
	dec c
	jr nz, .loop_bits
	ld a, d
	ld [hScriptVar], a
	ld a, b
	ld [wBattleTowerLegalPokemonFlags], a
	ret

BattleArcadeLobby_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 9, 5, 1, ROUTE_86
	warp_def 9, 6, 1, ROUTE_86

.CoordEvents: db 0

.BGEvents: db 2
	signpost 0, 5, SIGNPOST_READ, BattleArcadeLobby_Door
	signpost 2, 4, SIGNPOST_READ, BattleArcadeLobby_HighScoreDisplay

.ObjectEvents: db 3
	person_event SPRITE_LASS, 5, 6, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, BattleArcadeLobbyInstructionsNPC, -1
	person_event SPRITE_RECEPTIONIST, 1, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, BattleArcadeLobbyRedeemNPC, -1
	person_event SPRITE_RECEPTIONIST, 1, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, BattleArcadeLobbyBattleNPC, -1
