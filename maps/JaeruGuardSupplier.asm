JaeruGuardSupplier_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

JaeruGuardGoldTokenExchange:
	faceplayer
	opentext
	writetext JaeruGuardSupplier_Text_Introduction
	closetext
	loadmenudata GuardMenu
	verticalmenu
	closewindow
	addvar -1
	sif >, 5
		jumptext JaeruGuardSupplier_Text_SaidNo
	opentext
	loadarray .items, 1
	readarray 0
	itemtotext 0, 0
	writetext JaeruGuardSupplier_Text_ConfirmItem
	yesorno
	sif false
		jumptext JaeruGuardSupplier_Text_SaidNo
	sendif
	takeitem GOLD_TOKEN, 5
	sif false
		jumptext JaeruGuardSupplier_Text_NotEnoughTokens
	sendif
	writetext JaeruGuardSupplier_Text_Transaction
	waitbutton
	readarray 0
	verbosegiveitem ITEM_FROM_MEM, 1
	end
.items
	db POISON_GUARD
	db BURN_GUARD
	db FREEZE_GUARD
	db SLEEP_GUARD
	db PRZ_GUARD
	db CONFUSEGUARD

GuardMenu:
	db $40 ; flags
	db 00, 05 ; start coords
	db 15, 19 ; end coords
	dw GuardMenuOptions
	db 1 ; default option

GuardMenuOptions:
	db $80
	db $7
	db "Poison Guard@"
	db "Burn Guard@"
	db "Freeze Guard@"
	db "Sleep Guard@"
	db "Prz Guard@"
	db "ConfuseGuard@"
	db "Cancel@"

JaeruGuardNPC:
	jumptextfaceplayer JaeruGuardNPC_Text

JaeruGuardSupplier_Text_Introduction:
	ctxt "Hello!"

	para "I have these rare"
	line "items that can"

	para "stop your #mon"
	line "from being affec-"

	cont "ted by certain"
	cont "status conditions!"

	para "I'll let you have"
	line "any of these for"

	para "five Gold Tokens"
	line "each!"

	para "Which one would"
	line "you like?"
	prompt

JaeruGuardNPC_Text:
	ctxt "My dad became a"
	line "Gold Token"
	cont "collector."

	para "They made a finite"
	line "amount of them, so"

	para "they're incredibly"
	line "sought out by"

	para "collectors from"
	line "around the world."
	done

JaeruGuardSupplier_Text_ConfirmItem:
	ctxt "So, you want the"
	line "<STRBF3>?"

	para "That will be five"
	line "Gold Tokens."
	done

JaeruGuardSupplier_Text_NotEnoughTokens:
	ctxt "But you don't have"
	line "enough Gold"
	cont "Tokens!"
	done

JaeruGuardSupplier_Text_Transaction:
	ctxt "Thank you!"
	done

JaeruGuardSupplier_Text_SaidNo:
	ctxt "Come back if you"
	line "change your mind!"
	done

JaeruGuardSupplier_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 6, JAERU_CITY
	warp_def $7, $3, 6, JAERU_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_GRAMPS, 4, 5, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, JaeruGuardGoldTokenExchange, -1
	person_event SPRITE_SUPER_NERD, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, JaeruGuardNPC, -1
