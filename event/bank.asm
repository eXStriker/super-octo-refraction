Special_SpurgeMartBank:
	ld a, [hInMenu]
	push af
	ld a, $1
	ld [hInMenu], a
	ld hl, WelcomeToSpurgeATMText
	call PrintText
	call SpurgeBank_CheckIfBankInitialized
	call SpurgeBank_AccessBank
	ld hl, LoggingOutText
	call PrintText
	pop af
	ld [hInMenu], a
	ret

SpurgeBank_CheckIfBankInitialized:
	ld hl, wBankSavingMoney
	bit 7, [hl]
	set 7, [hl]
	ret nz
	ld hl, SpurgeBankExplanationText
	call PrintText
	call EnableOrDisableDirectDepositing
	ld hl, BankAccountHasBeenCreatedText
	call PrintText
	ld de, SFX_SAVE
	jp PlayWaitSFX

SpurgeBank_AccessBank:
	ld hl, SpurgeBankWhatWouldYouLikeToDoText
	call PrintText
	ld hl, SpurgeBankMenuDataHeader
	call LoadMenuDataHeader
	call VerticalMenu
	call CloseWindow
	ret c
	ld a, [wMenuCursorY]
	cp 4
	ret nc
	call .DoMenuChoice
	jr SpurgeBank_AccessBank

.DoMenuChoice:
	dec a
	jr z, .handleDeposit
	dec a
	jr z, .handleWithdraw
	jp SpurgeBank_EnableOrDisableDirectDepositing
	
.handleDeposit
	call SpurgeBank_DepositMoney
	jr .handleDepositOrWithdrawAftermessage
.handleWithdraw
	call SpurgeBank_WithdrawMoney
.handleDepositOrWithdrawAftermessage
	ld hl, TransactionCancelledText
	jp nc, PrintText
	ld hl, TransactionCompletedText
	call PrintText
	ld de, SFX_TRANSACTION
	jp PlayWaitSFX

SpurgeBankMenuDataHeader:
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 10 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2:
	db $80 ; flags
	db 4 ; items
SpurgeBank_DepositString:
	db "Deposit@"
SpurgeBank_WithdrawString:
	db "Withdraw@"
	db "Change@"
	db "Cancel@"

SpurgeBank_DepositMoney:
	ld hl, wBankMoney + 2
	ld bc, Money
	call SpurgeBank_Compare999999MinusHLAndBC
	ld de, SpurgeBank_DepositString
	ld hl, HowMuchDoYouWantToDepositText
	ld bc, CantDepositNothingText
	call SpurgeBank_DoBankInterface
; end of function
.DepositMoney:
	ld de, Money
	ld bc, wStringBuffer2
	callba CompareMoney
	ld hl, YouDontHaveThatMuchMoneyText
	ret c
	call BackupSpurgeBankHandledMoney
	ld bc, wBankMoney
	ld de, wStringBuffer2
	callba GiveMoney
	ld hl, WouldExceedBankAccountLimitText
	jr c, SpurgeBank_RestoreBackupMoney
	ld de, Money
	ld bc, wBankMoney
	and a
	ret

SpurgeBank_WithdrawMoney:
	ld hl, Money + 2
	ld bc, wBankMoney
	call SpurgeBank_Compare999999MinusHLAndBC
	ld de, SpurgeBank_WithdrawString
	ld hl, HowMuchDoYouWantToWithdrawText
	ld bc, CantWithdrawNothingText
	call SpurgeBank_DoBankInterface
; end of function
.WithdrawMoney:
	call BackupSpurgeBankHandledMoney
	ld de, wBankMoney
	ld bc, wStringBuffer2
	callba CompareMoney
	ld hl, DontHaveEnoughMoneyInAccountText
	jr c, SpurgeBank_RestoreBackupMoney
	ld bc, Money
	ld de, wStringBuffer2
	callba GiveMoney
	ld hl, NotEnoughRoomInWalletText
	ret c
	ld de, wBankMoney
	ld bc, Money
	and a
	ret

SpurgeBank_Compare999999MinusHLAndBC:
	ld de, wStringBuffer2 + 8
	push de
	ld a, (999999 & $ff)
	sub [hl]
	ld [de], a
	dec de
	dec hl
	ld a, ((999999 >> 8) & $ff)
	sbc [hl]
	ld [de], a
	dec de
	dec hl
	ld a, ((999999 >> 16) & $ff)
	sbc [hl]
	ld [de], a
	ld h, b
	ld l, c
	ld bc, 3
	push hl
	push bc
	call StringCmp
	pop bc
	pop hl
	pop de
	ret c
	ret z
	rst CopyBytes
	ret

BackupSpurgeBankHandledMoney:
	ld hl, wStringBuffer2
	ld de, wStringBuffer2 + 3
	ld bc, 3
	rst CopyBytes
	ret

SpurgeBank_RestoreBackupMoney:
	ld hl, wStringBuffer2 + 3
	ld de, wStringBuffer2
	ld bc, 3
	rst CopyBytes
	ret

SpurgeBank_EnableOrDisableDirectDepositing:
	ld hl, AskEnableDirectDepositingText
	call PrintText

; fallthrough
EnableOrDisableDirectDepositing:
	call YesNoBox
	ld hl, wBankSavingMoney
	jr c, .doNotSaveMoney
	ld de, .EnPrefix
	set 0, [hl]
	jr .printText
.doNotSaveMoney
	ld de, .DisPrefix
	res 0, [hl]
.printText
	push af
	call CopyName1
	ld hl, DirectDepositingHasBeenEnDisabledText
	call PrintText
	pop af
	ret c
	ld hl, DirectDepositingQuickExplanationText
	jp PrintText
	
.DisPrefix:
	db "dis@"
.EnPrefix:
	db "en@"

SpurgeBank_DoBankInterface:
	push bc
	push hl
	push de
	xor a
	ld hl, wStringBuffer2
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $5
	ld [wMomBankDigitCursorPosition], a
	ld hl, BankInterfacePseudoMenuDataHeader
	call LoadMenuDataHeader
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 6, 18
	call TextBox
	hlcoord 1, 2
	ld de, .SavedString
	call PlaceText
	hlcoord 12, 2
	ld de, wBankMoney
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	hlcoord 1, 4
	ld de, .HeldString
	call PlaceText
	hlcoord 12, 4
	ld de, Money
	lb bc, PRINTNUM_MONEY | 3, 6
	call PrintNum
	pop de
	hlcoord 1, 6
	call PlaceString
	hlcoord 12, 6
	ld de, wStringBuffer2
	lb bc, PRINTNUM_MONEY | PRINTNUM_LEADINGZEROS | 3, 6
	call PrintNum
	call ApplyTilemap
	call UpdateSprites
	pop hl
	pop bc
	pop de
.bankInterfaceLoop
	push bc
	push hl
	push de
	call PrintInstantText
	call BankJoypadLoop
	jr c, .cancelTransaction
	ld hl, wStringBuffer2
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr z, .cantPerformTransactionWithSpecifiedMoneyAsZero
	pop hl
	push hl
	call _hl_
	jr nc, .applyTransaction
.printErrorMessage
	call PrintText
	pop de
	pop hl
	pop bc
	jr .bankInterfaceLoop

.cantPerformTransactionWithSpecifiedMoneyAsZero
	ld hl, sp + 4
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .printErrorMessage

.applyTransaction
	push bc
	ld bc, wStringBuffer2 + 3
	callba TakeMoney
	pop de
	ld hl, wStringBuffer2
	ld bc, 3
	rst CopyBytes
	add sp, $6
	scf
	jr .closeWindow

.cancelTransaction
	add sp, $6
	and a
.closeWindow
	jp CloseWindow

.SavedString
	text "Saved"
	done

.HeldString
	text "Held"
	done

BankInterfacePseudoMenuDataHeader:
	db $40 ; tile backup
	db 0, 0 ; start coords
	db 7, 19 ; end coords
	dw 0
	db 1 ; default option
	
BankJoypadLoop:
.loop
	call JoyTextDelay
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .pressedB
	ld a, [hl]
	and A_BUTTON
	jr nz, .pressedA
	call .DPadAction
	xor a
	ld [hBGMapMode], a
	hlcoord 12, 5
	ld bc, 7
	ld a, " "
	call ByteFill
	hlcoord 12, 6
	ld de, wStringBuffer2
	lb bc, PRINTNUM_MONEY | PRINTNUM_LEADINGZEROS | 3, 6
	call PrintNum
	hlcoord 13, 5
	ld a, [wMomBankDigitCursorPosition]
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld [hl], "▼"
	call ApplyTilemapInVBlank
	jr .loop

.pressedB
	scf
	ret

.pressedA
	and a
	ret

.DPadAction:
	ld hl, hJoyLast
	ld a, [hl]
	rlca
	jr c, .decrementdigit
	rlca
	jr c, .incrementdigit
	rlca
	jr c, .movecursorleft
	rlca
	ret nc

; move cursor right
	ld hl, wMomBankDigitCursorPosition
	ld a, [hl]
	cp 5
	ret nc
	inc [hl]
	ret

.movecursorleft
	ld hl, wMomBankDigitCursorPosition
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

.incrementdigit
	call .getdigitquantity
	callba GiveMoney
	ld de, wStringBuffer2
	ld hl, wStringBuffer2 + 6
	ld bc, 3
	push hl
	push de
	push bc
	call StringCmp
	pop bc
	pop de
	pop hl
	ret c
	rst CopyBytes
	ret

.decrementdigit
	call .getdigitquantity
	jpba TakeMoney

.getdigitquantity
	ld hl, .DigitQuantities
	ld a, [wMomBankDigitCursorPosition]
	ld bc, 3
	rst AddNTimes
	ld b, h
	ld c, l
	ld de, wStringBuffer2
	ret

.DigitQuantities
	dt 100000
	dt 10000
	dt 1000
	dt 100
	dt 10
	dt 1

WelcomeToSpurgeATMText:
	text_jump _WelcomeToSpurgeATMText

SpurgeBankExplanationText:	
	text_jump _SpurgeBankExplanationText

DirectDepositingHasBeenEnDisabledText:
	text_jump _DirectDepositingHasBeenEnDisabledText

BankAccountHasBeenCreatedText:
	text_jump _BankAccountHasBeenCreatedText

SpurgeBankWhatWouldYouLikeToDoText:
	text_jump _SpurgeBankWhatWouldYouLikeToDoText

TransactionCompletedText:
	text_jump _TransactionCompletedText

TransactionCancelledText:
	text_jump _TransactionCancelledText

HowMuchDoYouWantToDepositText:
	text_jump _HowMuchDoYouWantToDepositText

YouDontHaveThatMuchMoneyText:
	text_jump _YouDontHaveThatMuchMoneyText

WouldExceedBankAccountLimitText:
	text_jump _WouldExceedBankAccountLimitText

HowMuchDoYouWantToWithdrawText:
	text_jump _HowMuchDoYouWantToWithdrawText

DontHaveEnoughMoneyInAccountText:
	text_jump _DontHaveEnoughMoneyInAccountText

NotEnoughRoomInWalletText:
	text_jump _NotEnoughRoomInWalletText

AskEnableDirectDepositingText:
	text_jump _AskEnableDirectDepositingText

CantDepositNothingText:
	text_jump _CantDepositNothingText

CantWithdrawNothingText:
	text_jump _CantWithdrawNothingText

DirectDepositingQuickExplanationText:
	text_jump _DirectDepositingQuickExplanationText
	
LoggingOutText:
	text_jump _LoggingOutText
