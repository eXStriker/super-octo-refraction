FindItemInBallScript::
	callasm .TryReceiveItem
	iffalse .no_room
	disappear LAST_TALKED
	opentext
	callasm .CheckforPlural
	iftrue .FindItemInBallScriptPlural
	writetext .text_found
	callasm SFXChannelsOff
	playwaitsfx SFX_ITEM
	itemnotify
	endtext

.no_room
	opentext
	writetext .text_found
	waitbutton
	writetext .text_bag_full
	endtext

.text_found
	start_asm
	ld hl, .PlayerFoundItemText
	ld de, .MonFoundItemText
	jr .GetTextBasedOnTreasureBagFlag

.text_found_plural
	start_asm
	ld hl, .FoundItemTextPlural
	ld de, .MonFoundItemTextPlural
	jr .GetTextBasedOnTreasureBagFlag

.text_bag_full
	start_asm
	ld hl, .PlayerCantCarryAnyMoreItems
	ld de, .MonCantCarryAnyMoreItems
	
; fallthrough
.GetTextBasedOnTreasureBagFlag
	CheckEngine ENGINE_USE_TREASURE_BAG
	ret z
	push de
	ld a, [PartyMon1HP]
	ld d, a
	ld a, [PartyMon1HP + 1]
	or d
	ld de, wPartyMonNicknames
	jr nz, .gotName
	ld de, wPartyMonNicknames + NAME_LENGTH
.gotName
	call CopyName1
	pop hl
	ret
	
.PlayerFoundItemText
	text_jump UnknownText_0x1c0a1c

.MonFoundItemText
	text_jump MonFoundItemText

.FoundItemTextPlural
	text_jump FoundItemTextPlural

.MonFoundItemTextPlural
	text_jump MonFoundItemTextPlural

.PlayerCantCarryAnyMoreItems
	text_jump UnknownText_0x1c0a2c

.MonCantCarryAnyMoreItems
	text_jump MonCantCarryAnyMoreItems

.TryReceiveItem
	xor a
	ld [hScriptVar], a
	ld a, [wCurItemBallContents]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, wStringBuffer3
	call CopyName2
	ld a, [wCurItemBallContents]
	ld [wCurItem], a
	ld a, [wCurItemBallQuantity]
	ld [wItemQuantityChangeBuffer], a
	callba GiveItemCheckPluralBuffer3
	ld hl, NumItems
	call ReceiveItem
	ret nc
	ld a, $1
	ld [hScriptVar], a
	ret

.FindItemInBallScriptPlural
	writetext .text_found_plural
	callasm SFXChannelsOff
	playwaitsfx SFX_ITEM
	callasm ItemNotifyFromMem
	endtext

.CheckforPlural
	xor a
	ld [hScriptVar], a
	ld a, [wItemQuantityChangeBuffer]
	dec a
	ret z
	ld a, 1
	ld [hScriptVar], a
	ld hl, wStringBuffer3
	ld de, wStringBuffer1
	ld bc, 15
	rst CopyBytes
	ret

FindTMorHMScript:
	callasm .TryReceiveTM
	iffalse .no_room
	disappear LAST_TALKED
	opentext
	writetext .text_found
	callasm SFXChannelsOff
	playwaitsfx SFX_GET_TM
	jumptext .text_put_tm_in_pocket

.no_room
	opentext
	writetext .text_found
	waitbutton
	jumptext .text_bag_full

.text_found
	text_jump FoundTMContainingMoveText

.text_put_tm_in_pocket
	text_jump PutTMInTMPocketText

.text_bag_full
	text_jump ButPlayerHasTMAlreadyText

.TryReceiveTM:
	xor a
	ld [hScriptVar], a
	ld a, [wCurItemBallContents]
	ld [wd265], a
	predef GetTMHMMove
	call GetMoveName
	ld hl, wStringBuffer3
	call CopyName2

	ld hl, wStringBuffer1
	ld a, [wCurItemBallContents]
	ld [wCurItem], a
	cp NUM_TMS + 1
	ld a, "T"
	jr c, .okay
	ld a, [wCurItemBallContents]
	sub NUM_TMS
	ld [wCurItemBallContents], a
	ld a, "H"
.okay
	ld [hli], a
	ld [hl], "M"
	inc hl
	ld de, wCurItemBallContents
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld [hl], "@"
	ld a, [wCurItem]
	dec a
	ld c, a
	ld hl, TMsHMs
	ld b, CHECK_FLAG
	predef FlagAction
	ld a, c
	and a
	ret nz
	ld a, [wCurItem]
	dec a
	ld c, a
	ld hl, TMsHMs
	ld b, SET_FLAG
	predef FlagAction
	ld a, $1
	ld [hScriptVar], a
	ret
