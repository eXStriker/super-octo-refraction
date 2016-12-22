; Event scripting commands.

EnableScriptMode::
	push af
	ld a, SCRIPT_READ
	ld [ScriptMode], a
	pop af
	ret

ScriptEvents::
	call StartScript
.loop
	ld a, [ScriptMode]
	jumptable .modes
	call CheckScript
	jr nz, .loop
	ret

.modes
	dw StopScript
	dw RunScriptCommand
	dw WaitScriptMovement
	dw WaitScript

WaitScript:
	call StopScript

	ld hl, ScriptDelay
	dec [hl]
	ret nz

	callba ReleaseAllMapObjects

	ld a, SCRIPT_READ
	ld [ScriptMode], a
	jp StartScript

WaitScriptMovement:
	call StopScript

	ld hl, VramState
	bit 7, [hl]
	ret nz

	callba ReleaseAllMapObjects

	ld a, SCRIPT_READ
	ld [ScriptMode], a
	jp StartScript

RunScriptCommand:
	call GetScriptByte
	cp (ScriptCommandTableEnd - ScriptCommandTable) / 2
	jr c, .go
	ld [hCrashSavedA], a
	ld a, 9
	jp Crash
.go
	jumptable
ScriptCommandTable:
	dw Script_scall ;0
	dw Script_farscall
	dw Script_ptcall
	dw Script_jump
	dw Script_farjump
	dw Script_ptjump
	dw Script_if_equal
	dw Script_if_not_equal
	dw Script_iffalse ;8
	dw Script_iftrue
	dw Script_if_greater_than
	dw Script_if_less_than
	dw Script_jumpstd
	dw Script_callstd
	dw Script_callasm
	dw Script_special
	dw Script_ptcallasm ;10
	dw Script_checkmaptriggers
	dw Script_domaptrigger
	dw Script_checktriggers
	dw Script_dotrigger
	dw Script_writebyte
	dw Script_addvar
	dw Script_random
	dw Script_readarrayhalfword ;18
	dw Script_copybytetovar
	dw Script_copyvartobyte
	dw Script_loadvar
	dw Script_checkcode
	dw Script_writevarcode
	dw Script_writecode
	dw Script_giveitem
	dw Script_takeitem ;20
	dw Script_checkitem
	dw Script_givemoney
	dw Script_takemoney
	dw Script_checkmoney
	dw Script_givecoins
	dw Script_takecoins
	dw Script_checkcoins
	dw Script_writehalfword ;28
	dw Script_pushhalfword
	dw Script_pushhalfwordvar
	dw Script_checktime
	dw Script_checkpoke
	dw Script_givepoke
	dw Script_giveegg
	dw Script_givefossil
	dw Script_takefossil ;30
	dw Script_checkevent
	dw Script_clearevent
	dw Script_setevent
	dw Script_checkflag
	dw Script_clearflag
	dw Script_setflag
	dw Script_wildon
	dw Script_wildoff ;38
	dw Script_warpmod
	dw Script_blackoutmod
	dw Script_warp
	dw Script_readmoney
	dw Script_readcoins
	dw Script_RAM2MEM
	dw Script_pokenamemem
	dw Script_itemtotext ;40
	dw Script_mapnametotext
	dw Script_trainertotext
	dw Script_stringtotext
	dw Script_itemnotify
	dw Script_pocketisfull
	dw Script_opentext
	dw Script_refreshscreen
	dw Script_closetext ;48
	dw Script_cmdwitharrayargs
	dw Script_farwritetext
	dw Script_writetext
	dw Script_repeattext
	dw Script_yesorno
	dw Script_loadmenudata
	dw Script_closewindow
	dw Script_jumptextfaceplayer ;50
	dw Script_farjumptext
	dw Script_jumptext
	dw Script_waitbutton
	dw Script_buttonsound
	dw Script_pokepic
	dw Script_closepokepic
	dw Script__2dmenu
	dw Script_verticalmenu ;58
	dw Script_scrollingmenu
	dw Script_randomwildmon
	dw Script_loadmemtrainer
	dw Script_loadwildmon
	dw Script_loadtrainer
	dw Script_startbattle
	dw Script_reloadmapafterbattle
	dw Script_catchtutorial ;60
	dw Script_trainertext
	dw Script_trainerflagaction
	dw Script_winlosstext
	dw Script_scripttalkafter
	dw Script_end_if_just_battled
	dw Script_check_just_battled
	dw Script_setlasttalked
	dw Script_applymovement ;68
	dw Script_applymovement2
	dw Script_faceplayer
	dw Script_faceperson
	dw Script_variablesprite
	dw Script_disappear
	dw Script_appear
	dw Script_follow
	dw Script_stopfollow ;70
	dw Script_moveperson
	dw Script_writepersonxy
	dw Script_loademote
	dw Script_showemote
	dw Script_spriteface
	dw Script_follownotexact
	dw Script_earthquake
	dw Script_changemap ;78
	dw Script_changeblock
	dw Script_reloadmap
	dw Script_reloadmappart
	dw Script_writecmdqueue
	dw Script_delcmdqueue
	dw Script_playmusic
	dw Script_encountermusic
	dw Script_musicfadeout ;80
	dw Script_playmapmusic
	dw Script_dontrestartmapmusic
	dw Script_cry
	dw Script_playsound
	dw Script_waitsfx
	dw Script_warpsound
	dw Script_passtoengine
	dw Script_newloadmap ;88
	dw Script_pause
	dw Script_deactivatefacing
	dw Script_priorityjump
	dw Script_warpcheck
	dw Script_ptpriorityjump
	dw Script_return
	dw Script_end
	dw Script_reloadandreturn ;90
	dw Script_end_all
	dw Script_pokemart
	dw Script_elevator
	dw Script_trade
	dw Script_pophalfwordvar
	dw Script_swaphalfword
	dw Script_swaphalfwordvar
	dw Script_pushbyte ;98
	dw Script_fruittree
	dw Script_swapbyte
	dw Script_loadarray
	dw Script_verbosegiveitem
	dw Script_verbosegiveitem2
	dw Script_swarm
	dw Script_halloffame
	dw Script_credits ;a0
	dw Script_warpfacing
	dw Script_battletowertext
	dw Script_landmarktotext
	dw Script_trainerclassname
	dw Script_name
	dw Script_wait
	dw Script_loadscrollingmenudata
	;Custom Prism
	dw Script_backupcustchar ;a8
	dw Script_restorecustchar
	dw Script_giveminingEXP
	dw Script_givesmeltingEXP
	dw Script_givejewelingEXP
	dw Script_giveballmakingEXP
	dw Script_giveTM
	dw Script_checkash
	dw Script_itemplural ;b0
	dw Script_pullvar
	dw Script_setplayersprite
	dw Script_setplayercolor
	dw Script_loadsignpost
	dw Script_checkpokemontype
	dw Script_giveorphanpoints
	dw Script_takeorphanpoints
	dw Script_checkorphanpoints ;b8
	dw Script_startmirrorbattle
	dw Script_comparevartobyte
	dw Script_backupsecondpokemon
	dw Script_restoresecondpokemon
	dw Script_vartohalfwordvar
	dw Script_pullhalfwordvar ;reloadpalette
	dw Script_divideop ;giverolls
	dw Script_givearcadetickets ;c0
	dw Script_takearcadetickets
	dw Script_checkarcadetickets
	dw Script_checkarcadehighscore
	dw Script_checkarcademaxround
	dw Script_switch ;increasejewellinglevel
	dw Script_multiplyvar ;increaseballmakinglevel
	dw Script_showFX ;showFX
	dw Script_minpartylevel ;c8
	dw Script_scriptjumptable
	dw Script_anonjumptable
	dw Script_givebattlepoints
	dw Script_takebattlepoints
	dw Script_checkbattlepoints
	dw Script_playwaitsfx
	dw Script_scriptstartasm
	dw Script_copystring ;d0
	dw Script_endtext
	dw Script_pushvar
	dw Script_popvar
	dw Script_swapvar
	dw Script_getweekday
	dw Script_milosswitch
	dw Script_QRCode
	dw Script_selse ;d8
	dw Script_sendif ;sendif, does nothing by itself
	dw Script_siffalse
	dw Script_siftrue
	dw Script_sifgt
	dw Script_siflt
	dw Script_sifeq
	dw Script_sifne
	dw Script_readarray ;e0
	dw Script_giveTMnomessage
	dw Script_findpokemontype
	dw Script_startpokeonly
	dw Script_endpokeonly
	dw Script_readhalfwordbyindex
ScriptCommandTableEnd:

StartScript:
	ld hl, ScriptFlags
	set SCRIPT_RUNNING, [hl]
Script_sendif:
Script_nop:
	ret

CheckScript:
	ld hl, ScriptFlags
	bit SCRIPT_RUNNING, [hl]
	ret

StopScript:
	ld hl, ScriptFlags
	res SCRIPT_RUNNING, [hl]
	ret

GetScriptByteOrVar:
	; returns the script byte if non-zero, or the script variable otherwise
	call GetScriptByte
	and a
	ret nz
	ld a, [hScriptVar]
	ret

Script_callasm:
; script command 0xe
; parameters:
;     asm (AsmPointerParam)

	call GetScriptByte
	ld b, a
	call GetScriptHalfword
	ld a, b
	jp FarCall_hl

Script_special:
; script command 0xf
; parameters:
;     predefined_script (MultiByteParam)

	call GetScriptByte
	ld e, a
	jpba Special

Script_ptcallasm:
; script command 0x10
; parameters:
;     asm (PointerToAsmPointerParam)

	call GetScriptHalfword
	jp FarPointerCall

Script_jumptextfaceplayer:
; script command 0x51
; parameters:
;     text_pointer (RawTextPointerLabelParam)

	ld a, [ScriptBank]
	call LoadScriptTextPointer
	ld b, BANK(JumpTextFacePlayerScript)
	ld hl, JumpTextFacePlayerScript
	jp ScriptJump

Script_jumptext:
; script command 0x53
; parameters:
;     text_pointer (RawTextPointerLabelParam)

	ld a, [ScriptBank]
	call LoadScriptTextPointer
	ld b, BANK(JumpTextScript)
	ld hl, JumpTextScript
	jp ScriptJump

Script_farjumptext:
; script command 0x52
; parameters:
;     text_pointer (PointerLabelBeforeBank)

	call GetScriptByte
	call LoadScriptTextPointer
	ld b, BANK(JumpTextScript)
	ld hl, JumpTextScript
	jp ScriptJump

Script_jumptextnoreopen:
; script command 0x53
; parameters:
;     text_pointer (RawTextPointerLabelParam)

	ld a, [ScriptBank]
	call LoadScriptTextPointer
	ld b, BANK(JumpTextNoReopenScript)
	ld hl, JumpTextNoReopenScript
	jp ScriptJump

LoadScriptTextPointer:
	ld [wScriptTextBank], a
	call GetScriptHalfwordOrVar_HL
	ld a, l
	ld [wScriptTextAddr], a
	ld a, h
	ld [wScriptTextAddr + 1], a
	ret

JumpTextFacePlayerScript:
	faceplayer
JumpTextScript:
	opentext
JumpTextNoReopenScript:
	repeattext
	endtext

Script_writetext:
; script command 0x4c
; parameters:
;     text_pointer (RawTextPointerLabelParam)

	call GetScriptHalfword
	ld a, [ScriptBank]
	ld b, a
	jp MapTextbox

Script_farwritetext:
; script command 0x4b
; parameters:
;     text_pointer (PointerLabelBeforeBank)

	call GetScriptByte
	ld b, a
	call GetScriptHalfword
	jp MapTextbox

Script_repeattext:
; script command 0x4d

	ld hl, wScriptTextBank
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp MapTextbox

Script_buttonsound:
; script command 0x55

	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call ApplyTilemapInVBlank
	call ButtonSound
	pop af
	ld [hOAMUpdate], a
	ret

Script_yesorno:
; script command 0x4e

	call YesNoBox
	ld a, FALSE
	jr c, .no
	inc a ; TRUE
.no
	ld [hScriptVar], a
	ret

Script_closewindow:
; script command 0x50

	call CloseWindow
	jp UpdateSprites

Script_pokepic:
; script command 0x56
; parameters:
;     pokemon (PokemonParam)

	call GetScriptByte
	ld b, a
	and a
	jr nz, .ok
	ld a, [hScriptVar]
.ok
	ld [wCurPartySpecies], a
	jpba Pokepic

Script_closepokepic:
; script command 0x57

	jpba ClosePokepic

Script_verticalmenu:
; script command 0x59

	ld a, [ScriptBank]
	ld hl, VerticalMenu
	call FarCall_hl
	ld a, [wMenuCursorY]
	jr nc, .ok
	xor a
.ok
	ld [hScriptVar], a
	ret

Script__2dmenu:
; script command 0x58

	ld a, [ScriptBank]
	ld hl, _2DMenu
	call FarCall_hl
	ld a, [wMenuCursorBuffer]
	jr nc, .ok
	xor a
.ok
	ld [hScriptVar], a
	ret

Script_battletowertext:
; script command 0xa4
; parameters:
;     pointer (PointerLabelBeforeBank)
;     memory (SingleByteParam)

	call SetUpTextBox
	call GetScriptByte
	ld c, a
	jpba BattleTowerText

Script_itemplural:
	ld a, [hScriptVar]
	dec a
	jp z, GetScriptByte
	call GetScriptStringBuffer
	jr GiveItemCheckPluralMain

Script_verbosegiveitem:
; script command 0x9e
; parameters:
;     item (ItemLabelByte)
;     quantity (DecimalParam)

	call Script_giveitem
	call CurItemName
	ld de, wStringBuffer1
	ld a, 1
	call CopyConvertedText
	ld b, BANK(GiveItemScript)
	ld de, GiveItemScript
	jp ScriptCall

GiveItemCheckPlural:: ; returns -1 if more than 1 item
	ld a, [wItemQuantityChangeBuffer]
	cp 2
	ret c
	ld hl, wStringBuffer4
	call GiveItemCheckPluralMain

	ld hl, wStringBuffer4
	ld de, wStringBuffer1
	ld bc, 15
	rst CopyBytes

	ld b, BANK(GiveItemScriptPlural)
	ld hl, GiveItemScriptPlural
	jp ScriptJump

GiveItemCheckPluralBuffer3::
	ld a, [wItemQuantityChangeBuffer]
	cp 2
	ret c
	ld hl, wStringBuffer3
GiveItemCheckPluralMain:
.loop
	ld a, [hli]
	cp "@"
	jr nz, .loop

	dec hl
	dec hl
	push hl

	ld a, [wCurItem]
	ld hl, .pluraledgecases
	ld de, 3
	call IsInArray
	pop de
	jp c, CallLocalPointer_AfterIsInArray

	ld a, [de]
	cp "o"
	jr z, .spluralsuffix
	cp "s"
	jr z, .spluralsuffix
	cp "y"
	jr z, .ypluralsuffix

.normalpluralsuffix
	inc de
	ld hl, .normalpluralsuffixtext
	jr .copy

.spluralsuffix:
	inc de
	ld hl, .spluralsuffixtext
	jr .copy

.guardspec
	ld hl, .guardspecsuffixtext
	jr .copy

.fpluralsuffix:
	ld hl, .fpluralsuffixtext
	jr .copy

.ypluralsuffix:
	ld hl, .ypluralsuffixtext
.copy
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .copy
.nopluralsuffix
	ret

.kegofbeer
	ld l, e
	ld h, d
	ld de, -7
	add hl, de
	ld e, l
	ld d, h
	ld hl, .kegofbeersuffixtext
	jr .copy

.pluraledgecases
	dbw LUCKY_PUNCH,  .spluralsuffix      ; Lucky Punch'es'
	dbw GUARD_SPEC,   .guardspec          ; Guard Spec's'.
	dbw SILVER_LEAF,  .fpluralsuffix      ; Silver Lea'ves'
	dbw GOLD_LEAF,    .fpluralsuffix      ; Gold Lea'ves'
	dbw FRIES,        .nopluralsuffix     ; Fries''
	dbw BLACKGLASSES, .nopluralsuffix     ; BlackGlasses''
	dbw LEFTOVERS,    .nopluralsuffix     ; Leftovers''
	dbw CAGE_KEY,     .normalpluralsuffix ; Cage Key's'
	dbw SACRED_ASH,   .spluralsuffix      ; Sacred Ash'es'
	dbw SAFE_GOGGLES, .nopluralsuffix     ; Safe Goggles''
	dbw LIGHT_CLAY,   .normalpluralsuffix ; Light Clay's'
	dbw KEG_OF_BEER,  .kegofbeer          ; Keg's' of Beer
	db $ff

.ypluralsuffixtext:
	db "i"
.spluralsuffixtext:
	db "e"
.normalpluralsuffixtext:
	db "s@"

.guardspecsuffixtext:
	db "s.@"

.fpluralsuffixtext:
	db "ves@"

.kegofbeersuffixtext:
	db "s of Beer@"

GiveItemScript:
	pushvar
	callasm GiveItemCheckPlural
	popvar
	writetext ReceivedItemText
	iffalse .Full
	waitsfx
	playwaitsfx SFX_ITEM
	waitbutton
	itemnotify
	end

.Full
	buttonsound
	pocketisfull
	end

GiveItemScriptPlural:
	popvar
	writetext _ReceivedItemTextPlural
	iffalse .Full
	waitsfx
	playwaitsfx SFX_ITEM
	waitbutton
	callasm ItemNotifyFromMem
	end

.Full
	buttonsound
	pocketisfull
	end

ReceivedItemText:
	text_jump UnknownText_0x1c4719

_ReceivedItemTextPlural:
	text_jump ReceivedItemTextPlural

Script_verbosegiveitem2:
; script command 0x9f
; parameters:
;     item (ItemLabelByte)
;     var (SingleByteParam)

	call GetScriptByte
	cp -1
	jr nz, .ok
	ld a, [hScriptVar]
.ok
	ld [wCurItem], a
	call GetScriptByte
	call GetVarAction
	ld a, [de]
	ld [wItemQuantityChangeBuffer], a
	ld hl, NumItems
	call ReceiveItem
	ld a, TRUE
	jr c, .ok2
	xor a
.ok2
	ld [hScriptVar], a
	call CurItemName
	ld de, wStringBuffer1
	ld a, 1
	call CopyConvertedText
	ld b, BANK(GiveItemScript)
	ld de, GiveItemScript
	jp ScriptCall

Script_itemnotify:
	call CurItemName
	call GetPocketName
	CheckEngine ENGINE_USE_TREASURE_BAG
	ld b, BANK(PutItemInPocketText)
	ld hl, PutItemInPocketText
	jr z, .gotText
	ld hl, PutItemInPocketText_Pokeonly
.gotText
	jp MapTextbox

ItemNotifyFromMem::
	call GetPocketName
	ld b, BANK(PutItemInPocketText)
	ld hl, PutItemInPocketText
	jp MapTextbox

Script_pocketisfull:
; script command 0x46

	call GetPocketName
	call CurItemName
	ld b, BANK(PocketIsFullText)
	ld hl, PocketIsFullText
	jp MapTextbox

GetPocketName:
	CheckEngine ENGINE_USE_TREASURE_BAG
	ld de, .TreasureBag
	jr nz, .copyName
	callba CheckItemPocket
	ld a, [wItemAttributeParamBuffer]
	dec a
	ld hl, .Pockets
	and 3
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
.copyName
	ld hl, wStringBuffer3
	jp CopyName2

.Pockets
	dw .Item
	dw .Key
	dw .Ball
	dw .TM

.Item
	db "Item Pocket@"
.Key
	db "Key Pocket@"
.Ball
	db "Ball Pocket@"
.TM
	db "TM Pocket@"
.TreasureBag
	db "Treasure Bag@"

CurItemName:
	ld a, [wCurItem]
	ld [wd265], a
	jp GetItemName

PutItemInPocketText:
	text_jump UnknownText_0x1c472c

PutItemInPocketText_Pokeonly:
	text_jump _PutItemInPocketText_Pokeonly

PocketIsFullText:
	text_jump UnknownText_0x1c474b

Script_pokemart:
; script command 0x94
; parameters:
;     dialog_id (SingleByteParam)
;     mart_id (MultiByteParam)

	call GetScriptByte
	ld c, a
	call GetScriptByte
	ld e, a
	ld a, [ScriptBank]
	ld b, a
	jpba OpenMartDialog

Script_elevator:
; script command 0x95
; parameters:
;     floor_list_pointer (PointerLabelParam)

	xor a
	ld [hScriptVar], a
	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	ld a, [ScriptBank]
	ld b, a
	callba Elevator
	ret c
	ld a, TRUE
	ld [hScriptVar], a
	ret

Script_trade:
; script command 0x96
; parameters:
;     trade_id (SingleByteParam)

	call GetScriptByte
	ld e, a
	jpba NPCTrade

Script_fruittree:
; script command 0x9b
; parameters:
;     tree_id (SingleByteParam)

	call GetScriptByte
	ld [CurFruitTree], a
	ld b, BANK(FruitTreeScript)
	ld hl, FruitTreeScript
	jp ScriptJump

Script_swarm:
; script command 0xa0
; parameters:
;     flag (SingleByteParam)
;     map_group (MapGroupParam)
;     map_id (MapIdParam)

	call GetScriptByte
	ld c, a
	call GetScriptHalfword
	ld d, l ; intentional
	ld e, h
	jpba StoreSwarmMapIndices

Script_trainertext:
; script command 0x62
; parameters:
;     which_text (SingleByteParam)

	call GetScriptByte
	ld c, a
	ld b, 0
	ld hl, wSeenTextPointer
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTempTrainerBank]
	ld b, a
	jp MapTextbox

Script_scripttalkafter:
; script command 0x65

	ld hl, wScriptAfterPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTempTrainerBank]
	ld b, a
	jp ScriptJump

Script_trainerflagaction:
; script command 0x63
; parameters:
;     action (SingleByteParam)

	xor a
	ld [hScriptVar], a
	ld hl, wd041
	ld e, [hl]
	inc hl
	ld d, [hl]
	call GetScriptByte
	ld b, a
	predef EventFlagAction
	ld a, c
	and a
	ret z
	ld a, TRUE
	ld [hScriptVar], a
	ret

Script_winlosstext:
; script command 0x64
; parameters:
;     win_text_pointer (TextPointerLabelParam)
;     loss_text_pointer (TextPointerLabelParam)

	ld hl, wWinTextPointer
	call GetScriptByte
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	ret

Script_end_if_just_battled:
; script command 0x66

	ld a, [wRunningTrainerBattleScript]
	and a
	ret z
	jp Script_end

Script_check_just_battled:
; script command 0x67

	ld a, TRUE
	ld [hScriptVar], a
	ld a, [wRunningTrainerBattleScript]
	and a
	ret nz
	xor a
	ld [hScriptVar], a
	ret

Script_encountermusic:
; script command 0x80
	call PushSoundstate
	ld a, [OtherTrainerClass]
	ld e, a
	jpba PlayTrainerEncounterMusic

Script_playmusic:
; script command 0x7f
; parameters:
;     music_pointer (MultiByteParam)

	ld de, MUSIC_NONE
	call PlayMusic
	xor a
	ld [MusicFade], a
	call MaxVolume
	call GetScriptHalfword_de
	jp PlayMusic

Script_musicfadeout:
; script command 0x81
; parameters:
;     music (MultiByteParam)
;     fadetime (SingleByteParam)

	call GetScriptByte
	ld [MusicFadeID], a
	call GetScriptByte
	ld [MusicFadeID + 1], a
	call GetScriptByte
	and $7f
	ld [MusicFade], a
	ret

Script_playsound:
; script command 0x85
; parameters:
;     sound_pointer (MultiByteParam)

	call GetScriptHalfword_de
	jp PlaySFX

Script_playwaitsfx:
	call GetScriptHalfword_de
	jp PlayWaitSFX

GetScriptHalfword_de:
	push hl
	call GetScriptHalfword
	ld d, h
	ld e, l
	pop hl
	ret

Script_warpsound:
; script command 0x87

	ld a, [PlayerStandingTile]
	ld de, SFX_ENTER_DOOR
	cp $71 ; door
	jr z, .play
	ld de, SFX_WARP_TO
	cp $7c ; warp pad
	jr z, .play
	ld de, SFX_EXIT_BUILDING
.play
	jp PlaySFX

Script_cry:
; script command 0x84
; parameters:
;     cry_id (SingleByteParam)

	call GetScriptByteOrVar
	jp PlayCry

GetScriptPerson:
	and a
	ret z
	cp LAST_TALKED
	ret z
	dec a
	ret

Script_setlasttalked:
; script command 0x68
; parameters:
;     person (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	ld [hLastTalked], a
	ret

Script_applymovement:
; script command 0x69
; parameters:
;     person (SingleByteParam)
;     data (MovementPointerLabelParam)

	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr nz, .notLastTalked
	ld a, [hLastTalked]
.notLastTalked
	ld c, a

ApplyMovement:
	push bc
	ld a, c
	callba SetFlagsForMovement_1
	pop bc

	push bc
	call SetFlagsForMovement_2
	pop bc

	call GetScriptHalfword
	ld a, [ScriptBank]
	ld b, a
	call GetMovementData
	ret c

	ld a, SCRIPT_WAIT_MOVEMENT
	ld [ScriptMode], a
	jp StopScript

SetFlagsForMovement_2:
	jpba _SetFlagsForMovement_2

Script_applymovement2:
; apply movement to last talked
; script command 0x6a
; parameters:
;     data (MovementPointerLabelParam)

	ld a, [hLastTalked]
	ld c, a
	jp ApplyMovement

Script_faceplayer:
; script command 0x6b

	ld a, [hLastTalked]
	and a
	ret z
	ld d, $0
	ld a, [hLastTalked]
	ld e, a
	callba GetRelativeFacing
	ld a, d
	add a
	add a
	ld e, a
	ld a, [hLastTalked]
	ld d, a
	jp ApplyPersonFacing

Script_faceperson:
; script command 0x6c
; parameters:
;     person1 (SingleByteParam)
;     person2 (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr c, .ok
	ld a, [hLastTalked]
.ok
	ld e, a
	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr nz, .ok2
	ld a, [hLastTalked]
.ok2
	ld d, a
	push de
	callba GetRelativeFacing
	pop bc
	ret c
	ld a, d
	add a
	add a
	ld e, a
	ld d, c
	jp ApplyPersonFacing

Script_spriteface:
; script command 0x76
; parameters:
;     person (SingleByteParam)
;     facing (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr nz, .ok
	ld a, [hLastTalked]
.ok
	ld d, a
	call GetScriptByte
	add a
	add a
	ld e, a

ApplyPersonFacing:
	ld a, d
	push de
	call CheckObjectVisibility
	jr c, .not_visible
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	push bc
	call DoesSpriteHaveFacings
	pop bc
	jr c, .not_visible ; STILL_SPRITE
	ld hl, OBJECT_FLAGS1
	add hl, bc
	bit FIXED_FACING, [hl]
	jr nz, .not_visible
	pop de
	ld a, e
	call SetSpriteDirection
	ld hl, VramState
	bit 6, [hl]
	jr nz, .done
	call LoadMapPart
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
.loop
	res 7, [hl]
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
.done
	jp UpdateSprites

.not_visible
	pop de
	scf
	ret

Script_variablesprite:
; script command 0x6d
; parameters:
;     byte (SingleByteParam)
;     sprite (SingleByteParam)

	call GetScriptByte
	ld e, a
	ld d, $0
	ld hl, VariableSprites
	add hl, de
	call GetScriptByte
	ld [hl], a
	ret

Script_appear:
; script command 0x6f
; parameters:
;     person (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	call _CopyObjectStruct
	ld a, [hMapObjectIndexBuffer]
	ld b, 0 ; clear
	jp ApplyEventActionAppearDisappear

Script_disappear:
; script command 0x6e
; parameters:
;     person (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr nz, .ok
	ld a, [hLastTalked]
.ok
	call DeleteObjectStruct
	ld a, [hMapObjectIndexBuffer]
	ld b, 1 ; set
	call ApplyEventActionAppearDisappear
	jpba _UpdateSprites

ApplyEventActionAppearDisappear:
	push bc
	call GetMapObject
	ld hl, MAPOBJECT_EVENT_FLAG
	add hl, bc
	pop bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, -1
	cp e
	jr nz, .okay
	cp d
	jr nz, .okay
	xor a
	ret
.okay
	predef_jump EventFlagAction

Script_follow:
; script command 0x70
; parameters:
;     person2 (SingleByteParam)
;     person1 (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	ld b, a
	call GetScriptByte
	call GetScriptPerson
	ld c, a
	jpba StartFollow

Script_stopfollow:
; script command 0x71
	jpba StopFollow

Script_moveperson:
; script command 0x72
; parameters:
;     person (SingleByteParam)
;     x (SingleByteParam)
;     y (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	ld b, a
	call GetScriptByte
	add 4
	ld d, a
	call GetScriptByte
	add 4
	ld e, a
	jpba CopyDECoordsToMapObject

Script_writepersonxy:
; script command 0x73
; parameters:
;     person (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr nz, .ok
	ld a, [hLastTalked]
.ok
	ld b, a
	jpba WritePersonXY

Script_follownotexact:
; script command 0x77
; parameters:
;     person2 (SingleByteParam)
;     person1 (SingleByteParam)

	call GetScriptByte
	call GetScriptPerson
	ld b, a
	call GetScriptByte
	call GetScriptPerson
	ld c, a
	jpba FollowNotExact

Script_loademote:
; script command 0x74
; parameters:
;     bubble (SingleByteParam)

	call GetScriptByte
	cp -1
	jr nz, .not_var_emote
	ld a, [hScriptVar]
.not_var_emote
	ld c, a
	jpba LoadEmote

Script_showemote:
; script command 0x75
; parameters:
;     bubble (SingleByteParam)
;     person (SingleByteParam)
;     time (DecimalParam)

	call Script_writebyte
	call GetScriptByte
	call GetScriptPerson
	cp LAST_TALKED
	jr z, .ok
	ld [hLastTalked], a
.ok
	call GetScriptByte
	ld [ScriptDelay], a
	call GetScriptByte
	ld [wPlayEmoteSFX], a
	ld b, BANK(ShowEmoteScript)
	ld de, ShowEmoteScript
	jp ScriptCall

ShowEmoteScript:
	loademote EMOTE_MEM
	applymovement2 .Show
	pause 0
	applymovement2 .Hide
	end

.Show
	show_emote
	step_sleep_1
	step_end

.Hide
	hide_emote
	step_sleep_1
	step_end

Script_earthquake:
; script command 0x78
; parameters:
;     param (DecimalParam)

	ld hl, EarthquakeMovement
	ld de, wd002
	ld bc, EarthquakeMovementEnd - EarthquakeMovement
	rst CopyBytes
	call GetScriptByte
	ld [wd003], a
	and (1 << 6) - 1
	ld [wd005], a
	ld b, BANK(.script)
	ld de, .script
	jp ScriptCall

.script:
	applymovement PLAYER, wd002
	end

EarthquakeMovement:
	step_shake 16 ; the 16 gets overwritten with the script byte
	step_sleep 16 ; the 16 gets overwritten with the lower 6 bits of the script byte
	step_end
EarthquakeMovementEnd

Script_scrollingmenu:
; script command 0x5a
	call InitScrollingMenu
	call UpdateSprites
	ld a, [wScrollingMenuCursorBuffer]
	ld [wMenuCursorBuffer], a
	ld a, [wScrollingMenuScrollPosition]
	ld [wMenuScrollPosition], a
	ld hl, ScrollingMenu
	ld a, [ScriptBank]
	call FarCall_hl
	ld a, [wMenuScrollPosition]
	ld [wScrollingMenuScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wScrollingMenuCursorBuffer], a
	call GetScriptByte
	bit 0, a ; draw speech box?
	push af
	call nz, SpeechTextBox
	pop bc
	ld a, [wMenuJoypad]
	cp B_BUTTON
	ld a, 0
	jr z, .backedOut
	bit 1, b ; use cursor position or menu selection?
	ld a, [wMenuSelection]
	jr z, .backedOut
	ld a, [wScrollingMenuCursorPosition]
	inc a
.backedOut
	ld [hScriptVar], a
	ret

Script_randomwildmon:
; script command 0x5b
	xor a
	ld [wBattleScriptFlags], a
	jp PushSoundstate

Script_loadmemtrainer:
; script command 0x5c

	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	ld a, [wTempTrainerClass]
	ld [OtherTrainerClass], a
	ld a, [wTempTrainerID]
	ld [OtherTrainerID], a
	ret

Script_loadwildmon:
; script command 0x5d
; parameters:
;     pokemon (PokemonParam)
;     level (DecimalParam)

	ld a, (1 << 7)
	ld [wBattleScriptFlags], a
	call GetScriptByte
	ld [TempWildMonSpecies], a
	call GetScriptByte
	bit 7, a
	res 7, a
	ld [CurPartyLevel], a
	ret z
	ld hl, wWildMonCustomItem
	ld c, 5
.getScriptByteLoop
	call GetScriptByte
	ld [hli], a
	dec c
	jr nz, .getScriptByteLoop
	ret

Script_loadtrainer:
; script command 0x5e
; parameters:
;     trainer_group (TrainerGroupParam)
;     trainer_id (TrainerIdParam)

	ld a, (1 << 7) | 1
	ld [wBattleScriptFlags], a
	call GetScriptByte
	ld [OtherTrainerClass], a
	call GetScriptByte
	ld [OtherTrainerID], a
	ret

Script_startmirrorbattle:
	ld hl, wPartyCount
	ld de, OTPartyCount
	ld bc, wPartyMonNicknamesEnd - wPartyCount
	rst CopyBytes
	callba HealOTParty
	ld hl, InBattleTowerBattle
	ld a, [hl]
	push af
	set 1, [hl]
	call Script_startbattle
	pop af
	ld [InBattleTowerBattle], a
	ret

Script_startbattle:
; script command 0x5f

	call BufferScreen
	ld a, [wPartyCount]
	and a
	jr z, .no_pokemon
	predef StartBattle
	ld a, [wBattleResult]
	and $3f
	ld [hScriptVar], a
	ret

.no_pokemon
	inc a
	ld [wBattleResult], a
	ld [hScriptVar], a
	ld b, BANK(Script_OverworldWhiteout)
	ld hl, Script_OverworldWhiteout
	jp ScriptJump

Script_catchtutorial:
; script command 0x61
; parameters:
;     byte (SingleByteParam)

	call GetScriptByte
	ld [wBattleType], a
	call BufferScreen
	callba CatchTutorial
	jr Script_reloadmap

Script_reloadmapafterbattle:
; script command 0x60
	ld hl, wBattleScriptFlags
	ld a, [hl]
	ld [wWhiteOutFlags], a
	ld [hl], $0
	ld a, [wBattleResult]
	and $3f
	cp $1
	jr nz, Script_reloadmap
	ld b, BANK(Script_BattleWhiteout)
	ld hl, Script_BattleWhiteout
	jp ScriptJump

Script_reloadmap:
; script command 0x7b

	xor a
	ld [wBattleScriptFlags], a
	ld a, MAPSETUP_RELOADMAP
	jp WriteMapEntryMethodLoadMapStatusEnterMapAndStopScript

Script_scall:
; script command 0x0
; parameters:
;     pointer (ScriptPointerLabelParam)

	ld a, [ScriptBank]
	ld b, a
	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	jr ScriptCall

Script_farscall:
; script command 0x1
; parameters:
;     pointer (ScriptPointerLabelBeforeBank)

	call GetScriptByte
	ld b, a
	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	jr ScriptCall

Script_ptcall:
; script command 0x2
; parameters:
;     pointer (PointerLabelToScriptPointer)

	call GetScriptHalfword
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
ScriptCall:
; Bug: The script stack has a capacity of 5 scripts, yet there is
; nothing to stop you from pushing a sixth script.  The high part
; of the script address can then be overwritten by modifications
; to ScriptDelay, causing the script to return to the rst/interrupt
; space.

	push de
	ld hl, wScriptStackSize
	ld a, [hl]
	cp 5
	jr nc, .full
	ld e, a
	inc [hl]
	ld d, $0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	pop de
	ld a, [ScriptBank]
	ld [hli], a
	ld a, [ScriptPos]
	ld [hli], a
	ld a, [ScriptPos + 1]
	ld [hl], a
	ld a, b
	ld [ScriptBank], a
	ld a, e
	ld [ScriptPos], a
	ld a, d
	ld [ScriptPos + 1], a
	and a
	ret

.full
	ld [hCrashSavedA], a
	ld a, 11
	jp Crash

CallCallback::
	ld a, [ScriptBank]
	or $80
	ld [ScriptBank], a
	jp ScriptCall

Script_jump:
; script command 0x3
; parameters:
;     pointer (ScriptPointerLabelParam)

	call GetScriptHalfword
	jp LocalScriptJump

Script_farjump:
; script command 0x4
; parameters:
;     pointer (ScriptPointerLabelBeforeBank)

	call GetScriptByte
	ld b, a
	call GetScriptHalfword
	jp ScriptJump

Script_ptjump:
; script command 0x5
; parameters:
;     pointer (PointerLabelToScriptPointer)

	call GetScriptHalfword
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp ScriptJump

Script_iffalse:
; script command 0x8
; parameters:
;     pointer (ScriptPointerLabelParam)

	ld a, [hScriptVar]
	and a
	jp nz, SkipTwoScriptBytes
	jp Script_jump

Script_iftrue:
; script command 0x9
; parameters:
;     pointer (ScriptPointerLabelParam)

	ld a, [hScriptVar]
	and a
	jp nz, Script_jump
	jp SkipTwoScriptBytes

Script_if_equal:
; script command 0x6
; parameters:
;     byte (SingleByteParam)
;     pointer (ScriptPointerLabelParam)

	call GetScriptByte
	ld hl, hScriptVar
	cp [hl]
	jr z, Script_jump
	jr SkipTwoScriptBytes

Script_if_not_equal:
; script command 0x7
; parameters:
;     byte (SingleByteParam)
;     pointer (ScriptPointerLabelParam)

	call GetScriptByte
	ld hl, hScriptVar
	cp [hl]
	jr nz, Script_jump
	jr SkipTwoScriptBytes

Script_if_greater_than:
; script command 0xa
; parameters:
;     byte (SingleByteParam)
;     pointer (ScriptPointerLabelParam)

	ld a, [hScriptVar]
	ld b, a
	call GetScriptByte
	cp b
	jr c, Script_jump
	jr SkipTwoScriptBytes

Script_if_less_than:
; script command 0xb
; parameters:
;     byte (SingleByteParam)
;     pointer (ScriptPointerLabelParam)

	call GetScriptByte
	ld b, a
	ld a, [hScriptVar]
	cp b
	jr c, Script_jump
	jr SkipTwoScriptBytes

Script_jumpstd:
; script command 0xc
; parameters:
;     predefined_script (MultiByteParam)

	call StdScript
	jr ScriptJump

Script_callstd:
; script command 0xd
; parameters:
;     predefined_script (MultiByteParam)

	call StdScript
	ld d, h
	ld e, l
	jp ScriptCall

StdScript:
	call GetScriptByte
	ld e, a
	ld d, 0
	ld hl, StdScripts
	add hl, de
	add hl, de
	add hl, de
	ld a, BANK(StdScripts)
	call GetFarByteHalfword
	ld b, a
	ret

SkipTwoScriptBytes:
	ld hl, ScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	jr LocalScriptJump

ScriptJump:
	ld a, b
	ld [ScriptBank], a
LocalScriptJump:
	ld a, l
	ld [ScriptPos], a
	ld a, h
	ld [ScriptPos + 1], a
	ret

Script_priorityjump:
; script command 0x8d
; parameters:
;     pointer (ScriptPointerLabelParam)

	ld a, [ScriptBank]
	ld [wPriorityScriptBank], a
	call GetScriptByte
	ld [wPriorityScriptAddr], a
	call GetScriptByte
	ld [wPriorityScriptAddr + 1], a
	ld hl, ScriptFlags
	set 3, [hl]
	ret

Script_checktriggers:
; script command 0x13

	call CheckTriggers
	jr nz, .load_trigger
	ld a, $ff
.load_trigger
	ld [hScriptVar], a
	ret

Script_checkmaptriggers:
; script command 0x11
; parameters:
;     map_group (SingleByteParam)
;     map_id (SingleByteParam)

	call GetScriptByte
	ld b, a
	call GetScriptByte
	ld c, a
	call GetMapTrigger
	ld a, d
	or e
	jr z, .no_triggers
	ld a, [de]
	jr .load_trigger

.no_triggers
	ld a, $ff
.load_trigger
	ld [hScriptVar], a
	ret

Script_dotrigger:
; script command 0x14
; parameters:
;     trigger_id (SingleByteParam)

	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	jr DoTrigger

Script_domaptrigger:
; script command 0x12
; parameters:
;     map_group (MapGroupParam)
;     map_id (MapIdParam)
;     trigger_id (SingleByteParam)

	call GetScriptByte
	ld b, a
	call GetScriptByte
	ld c, a
DoTrigger:
	call GetMapTrigger
	ld a, d
	or e
	jr z, .no_trigger
	call GetScriptByte
	ld [de], a
.no_trigger
	ret

Script_copybytetovar:
; script command 0x19
; parameters:
;     address (RAMAddressParam)

	call GetScriptHalfword
	ld a, [hl]
	ld [hScriptVar], a
	ret

Script_copyvartobyte:
; script command 0x1a
; parameters:
;     address (RAMAddressParam)

	call GetScriptHalfword
	ld a, [hScriptVar]
	ld [hl], a
	ret

Script_loadvar:
; script command 0x1b
; parameters:
;     address (RAMAddressParam)
;     value (SingleByteParam)

	call GetScriptHalfword
	call GetScriptByte
	ld [hl], a
	ret

Script_writebyte:
; script command 0x15
; parameters:
;     value (SingleByteParam)

	call GetScriptByte
	ld [hScriptVar], a
	ret

Script_addvar:
; script command 0x16
; parameters:
;     value (SingleByteParam)

	call GetScriptByte
	ld hl, hScriptVar
	add [hl]
	ld [hl], a
	ret

Script_multiplyvar:
	call GetScriptByte
	ld c, a
	ld a, [hScriptVar]
	call SimpleMultiply
	ld [hScriptVar], a
	ret

Script_divideop:
	call GetScriptByte
	ld d, a
	jumptable .DivideOperations
	call SimpleDivide
	bit 2, d
	jr nz, .remainder
	ld a, b
.remainder
	ld [hScriptVar], a
	ret

.DivideOperations:	
	dw .varDivA
	dw .aDivVar
	dw .varDivHalfwordVar
	dw .halfwordVarDivVar

.varDivA
	call GetScriptByte
	ld c, a
	ld a, [hScriptVar]
	ret
	
.aDivVar
	ld a, [hScriptVar]
	ld c, a
	jp GetScriptByte
	
.varDivHalfwordVar
	ld hl, hScriptHalfwordVar
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, [hl]
	ld a, [hScriptVar]
	ret
	
.halfwordVarDivVar
	ld a, [hScriptVar]
	ld c, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	ret

Script_random:
; script command 0x17
; parameters:
;     input (SingleByteParam)

	call Script_writebyte
	and a
	jr z, .noRejectionSampling

	ld c, a
	call .Divide256byC
	and a
	jr z, .no_restriction ; 256 % b == 0
	ld b, a
	xor a
	sub b
	ld b, a
.loop
	push bc
	call Random
	pop bc
	ld a, [hRandomAdd]
	cp b
	jr nc, .loop
	jr .finish

.no_restriction
	push bc
	call Random
	pop bc
	ld a, [hRandomAdd]

.finish
	push af
	ld a, [hScriptVar]
	ld c, a
	pop af
	call SimpleDivide
	ld [hScriptVar], a
	ret

.noRejectionSampling
	call Random
	ld [hScriptVar], a
	ret

.Divide256byC
	xor a
	ld b, a
	sub c
.mod_loop
	inc b
	sub c
	jr nc, .mod_loop
	dec b
	add c
	ret

Script_checkcode:
; script command 0x1c
; parameters:
;     variable_id (SingleByteParam)

	call GetScriptByte
	call GetVarAction
	ld a, [de]
	ld [hScriptVar], a
	ret

Script_writevarcode:
; script command 0x1d
; parameters:
;     variable_id (SingleByteParam)

	call GetScriptByte
	call GetVarAction
	ld a, [hScriptVar]
	ld [de], a
	ret

Script_writecode:
; script command 0x1e
; parameters:
;     variable_id (SingleByteParam)
;     value (SingleByteParam)

	call GetScriptByte
	call GetVarAction
	call GetScriptByte
	ld [de], a
	ret

GetVarAction:
	ld c, a
	jpba _GetVarAction

Script_pokenamemem:
; script command 0x40
; parameters:
;     pokemon (PokemonParam); leave $0 to draw from script var
;     memory (SingleByteParam)

	call GetScriptByteOrVar
	ld [wd265], a
	call GetPokemonName
	ld de, wStringBuffer1
ConvertMemToText:
	call GetScriptByte
	cp 3
	jr c, CopyConvertedText
	xor a
CopyConvertedText:
	ld hl, wStringBuffer3
	ld bc, wStringBuffer4 - wStringBuffer3
	rst AddNTimes
	jp CopyName2

Script_itemtotext:
; script command 0x41
; parameters:
;     item (ItemLabelByte); use 0 to draw from hScriptVar
;     memory (SingleByteParam)

	call GetScriptByteOrVar
	ld [wd265], a
	call GetItemName
	ld de, wStringBuffer1
	jr ConvertMemToText

Script_mapnametotext:
; script command 0x42
; parameters:
;     memory (SingleByteParam)
	call GetCurWorldMapLocation

ConvertLandmarkToText:
	ld e, a
	callba GetLandmarkName
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_landmarktotext:
; script command 0xa5
; parameters:
;     id (SingleByteParam)
;     memory (SingleByteParam)

	call GetScriptByte
	jr ConvertLandmarkToText

Script_trainertotext:
; script command 0x43
; parameters:
;     trainer_id (TrainerGroupParam)
;     trainer_group (TrainerIdParam)
;     memory (SingleByteParam)

	call GetScriptByte
	ld c, a
	call GetScriptByte
	ld b, a
	callba GetTrainerName
	jr ConvertMemToText

Script_name:
; script command 0xa7
; parameters:
;     type (SingleByteParam)
;     id (SingleByteParam)
;     memory (SingleByteParam)

	call GetScriptByte
	ld [wNamedObjectTypeBuffer], a

ContinueToGetName:
	call GetScriptByte
	ld [wCurSpecies], a
	call GetName
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_trainerclassname:
; script command 0xa6
; parameters:
;     id (SingleByteParam)
;     memory (SingleByteParam)

	ld a, TRAINER_NAME
	ld [wNamedObjectTypeBuffer], a
	jr ContinueToGetName

Script_readmoney:
; script command 0x3d
; parameters:
;     account (SingleByteParam)
;     memory (SingleByteParam)

	call ResetStringBuffer1
	call GetMoneyAccount
	ld hl, wStringBuffer1
	lb bc, PRINTNUM_RIGHTALIGN | 3, 6
	call PrintNum
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_readcoins:
; script command 0x3e
; parameters:
;     memory (SingleByteParam)

	call ResetStringBuffer1
	ld hl, wStringBuffer1
	ld de, Coins
	lb bc, PRINTNUM_RIGHTALIGN | 2, 6
	call PrintNum
	ld de, wStringBuffer1
	jp ConvertMemToText

Script_RAM2MEM:
; script command 0x3f
; parameters:
;     memory (SingleByteParam)

	call ResetStringBuffer1
	ld de, hScriptVar
	ld hl, wStringBuffer1
	lb bc, PRINTNUM_RIGHTALIGN | 1, 3
	call PrintNum
	ld de, wStringBuffer1
	jp ConvertMemToText

ResetStringBuffer1:
	ld hl, wStringBuffer1
	ld bc, NAME_LENGTH
	ld a, "@"
	jp ByteFill

Script_stringtotext:
; script command 0x44
; parameters:
;     text_pointer (EncodedTextLabelParam)
;     memory (SingleByteParam)

	call GetScriptHalfword
	ld d, h
	ld e, l
	ld a, [ScriptBank]
	ld hl, CopyName1
	call FarCall_hl
	ld de, wStringBuffer2
	jp ConvertMemToText

Script_giveitem:
; script command 0x1f
; parameters:
;     item (ItemLabelByte)
;     quantity (SingleByteParam)

	call GetScriptByte
	cp ITEM_FROM_MEM
	jr nz, .ok
	ld a, [hScriptVar]
.ok
	ld [wCurItem], a
	call GetScriptByte
	ld [wItemQuantityChangeBuffer], a
	ld hl, NumItems
	call ReceiveItem
	jr nc, .full
	ld a, TRUE
	jr .load
.full
	xor a
.load
	ld [hScriptVar], a
	ret

Script_takefossil:
	call FossilCaseCheck
	jr nc, .no_case
	ld hl, wFossilCaseCount
	ld a, [hl]
	and a
	jr z, .empty
	dec [hl]
	inc hl
	ld a, [hl]
	push af
.loop
	inc hl
	ld a, [hld]
	ld [hli], a
	inc a
	jr nz, .loop
	ld [hl], a
	pop af
	ld [hScriptVar], a
	ret

.no_case
	ld a, 4
	ld [hScriptVar], a
	ret

.empty
	ld a, 5
	ld [hScriptVar], a
	ret

Script_givefossil:
	call FossilCaseCheck
	jr nc, .no_case
	ld hl, wFossilCaseCount
	ld a, [hl]
	cp FOSSIL_CASE_SIZE
	jr nc, .full
	inc [hl]
	inc hl
	ld c, a
	ld b, 0
	add hl, bc
	call Random
	and $3
	ld [hli], a
	ld [hl], $ff
	ld a, $1
	jr .load

.no_case
	ld a, $2
	jr .load

.full
	xor a
.load
	ld [hScriptVar], a
	ld b, BANK(GiveFossilScript)
	ld de, GiveFossilScript
	jp ScriptCall

GiveFossilScript:
	writetext ReceivedFossilText
	anonjumptable
	dw .Full
	dw .OK
	dw .NoCase

.OK
	waitsfx
	playwaitsfx SFX_ITEM
	waitbutton
	writetext PutFossilInCaseText
	end

.Full
	buttonsound
	writetext NoRoomForFossilText
	end

.NoCase
	buttonsound
	writetext NoFossilCaseText
	end

ReceivedFossilText:
	text_jump ReceivedFossilText_

PutFossilInCaseText:
	text_jump PutFossilInCaseText_

NoRoomForFossilText:
	text_jump NoRoomForFossilText_

NoFossilCaseText:
	text_jump NoFossilCaseText_

FossilCaseCheck:
	ld hl, NumItems
	ld a, FOSSIL_CASE
	ld [wCurItem], a
	jp CheckItem

Script_takeitem:
; script command 0x20
; parameters:
;     item (ItemLabelByte)
;     quantity (DecimalParam)

	xor a
	ld [hScriptVar], a

	call GetScriptByte
	cp ITEM_FROM_MEM
	jr z, .memitem
	ld [wCurItem], a

.memitem
	call GetScriptByte
	ld [wItemQuantityChangeBuffer], a
	ld a, -1
	ld [wCurItemQuantity], a
	ld hl, NumItems
	call TossItem
	ret nc
	ld a, TRUE
	ld [hScriptVar], a
	ret

Script_checkitem:
; script command 0x21
; parameters:
;     item (ItemLabelByte)

	xor a
	ld [hScriptVar], a
	call GetScriptByte
	ld [wCurItem], a
	ld hl, NumItems
	call CheckItem
	ret nc
	ld a, TRUE
	ld [hScriptVar], a
	ret

Script_givemoney:
; script command 0x22
; parameters:
;     account (SingleByteParam)
;     money (MoneyByteParam)

	call GetMoneyAccount
	call LoadMoneyAmountToMem
	jpba GiveMoney

Script_takemoney:
; script command 0x23
; parameters:
;     account (SingleByteParam)
;     money (MoneyByteParam)

	call GetMoneyAccount
	call LoadMoneyAmountToMem
	jpba TakeMoney

Script_checkmoney:
; script command 0x24
; parameters:
;     account (SingleByteParam)
;     money (MoneyByteParam)

	call GetMoneyAccount
	call LoadMoneyAmountToMem
	callba CompareMoney
CompareMoneyAction:
	jr z, .one
	sbc a
	and 2
.done
	ld [hScriptVar], a
	ret
.one
	ld a, 1
	jr .done

GetMoneyAccount:
	call GetScriptByte
	and a
	ld de, Money
	ret z
	ld de, wBankMoney
	ret

LoadMoneyAmountToMem:
	ld bc, hMoneyTemp
	push bc
	call GetScriptByte
	ld [bc], a
	inc bc
	call GetScriptByte
	ld [bc], a
	inc bc
	call GetScriptByte
	ld [bc], a
	pop bc
	ret

Script_givecoins:
; script command 0x25
; parameters:
;     coins (CoinByteParam)

	call LoadCoinAmountToMem
	jpba GiveCoins

Script_takecoins:
; script command 0x26
; parameters:
;     coins (CoinByteParam)

	call LoadCoinAmountToMem
	jpba TakeCoins

Script_checkcoins:
; script command 0x27
; parameters:
;     coins (CoinByteParam)

	call LoadCoinAmountToMem
	callba CheckCoins
	jr CompareMoneyAction

LoadCoinAmountToMem:
	call GetScriptHalfwordOrVar
	ld a, e
	ld [hMoneyTemp + 1], a
	ld a, d
	ld [hMoneyTemp], a
	ld bc, hMoneyTemp
	ret

Script_givebattlepoints:
	call LoadCoinAmountToMem
	jpba GiveBattlePoints

Script_takebattlepoints:
	call LoadCoinAmountToMem
	jpba TakeBattlePoints

Script_checkbattlepoints:
	call LoadCoinAmountToMem
	callba CheckBattlePoints
	jr CompareMoneyAction

Script_checktime:
; script command 0x2b
; parameters:
;     time (SingleByteParam)

	xor a
	ld [hScriptVar], a
	callba CheckTime
	call GetScriptByte
	and c
	ret z
	ld a, TRUE
	ld [hScriptVar], a
	ret

Script_checkpoke:
; script command 0x2c
; parameters:
;     pkmn (PokemonParam)

	xor a
	ld [hScriptVar], a
	call GetScriptByte
	ld hl, wPartySpecies
	call IsInSingularArray
	ret nc
	ld a, TRUE
	ld [hScriptVar], a
	ret

Script_writehalfword:
	call GetScriptHalfword_de
WriteDEToScriptHalfword:
	ld hl, hScriptHalfwordVar
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

Script_givepoke:
; script command 0x2d
; parameters:
;     pokemon (PokemonParam)
;     level (DecimalParam)
;     item (ItemLabelByte)
;     trainer (DecimalParam)
;     trainer_name_pointer (MultiByteParam)
;     pkmn_nickname (MultiByteParam)

	call GetScriptByteOrVar
	ld [wCurPartySpecies], a
	call GetScriptByte
	ld [CurPartyLevel], a
	call GetScriptByte
	ld [wCurItem], a
	call GetScriptByte
	and a
	ld b, a
	jr z, .ok
	ld hl, ScriptPos
	ld e, [hl]
	inc hl
	ld d, [hl]
	call GetScriptByte
	call GetScriptByte
	call GetScriptByte
	call GetScriptByte
.ok
	callba GivePoke
	ld a, b
	ld [hScriptVar], a
	ret

Script_giveegg:
; script command 0x2e
; parameters:
;     pkmn (PokemonParam)
;     level (DecimalParam)
; if no room in the party, return 0 in hScriptVar; else, return 2

	xor a ; PARTYMON
	ld [hScriptVar], a
	ld [wMonType], a
	call GetScriptByte
	ld [wCurPartySpecies], a
	call GetScriptByte
	ld [CurPartyLevel], a
	callba GiveEgg
	ret nc
	ld a, 2
	ld [hScriptVar], a
	ret

Script_setevent:
; script command 0x33
; parameters:
;     bit_number (MultiByteParam)

	call GetScriptHalfwordOrVar
	ld b, SET_FLAG
	predef_jump EventFlagAction

Script_clearevent:
; script command 0x32
; parameters:
;     bit_number (MultiByteParam)

	call GetScriptHalfwordOrVar
	ld b, RESET_FLAG
	predef_jump EventFlagAction

Script_checkevent:
; script command 0x31
; parameters:
;     bit_number (MultiByteParam)

	call GetScriptHalfwordOrVar
	ld b, CHECK_FLAG
	predef EventFlagAction
	ld a, c
	and a
	jr z, .false
	ld a, TRUE
.false
	ld [hScriptVar], a
	ret

GetScriptHalfwordOrVar_HL:
	push de
	call GetScriptHalfwordOrVar
	ld h, d
	ld l, e
	pop de
	ret

GetScriptHalfwordOrVar:
; use hScriptHalfwordVar if $ffff, otherwise use halfword arg
	call GetScriptHalfword_de
	ld a, d
	and e
	inc a
	ret nz
	ld a, [hScriptHalfwordVar]
	ld e, a
	ld a, [hScriptHalfwordVar + 1]
	ld d, a
	ret

Script_setflag:
; script command 0x36
; parameters:
;     bit_number (MultiByteParam)

	call GetScriptHalfword_de
	ld b, SET_FLAG
	jr _EngineFlagAction

Script_clearflag:
; script command 0x35
; parameters:
;     bit_number (MultiByteParam)

	call GetScriptHalfword_de
	ld b, RESET_FLAG
	jr _EngineFlagAction

Script_checkflag:
; script command 0x34
; parameters:
;     bit_number (MultiByteParam)

	call GetScriptHalfword_de
	ld b, 2 ; check
	call _EngineFlagAction
	ld a, c
	and a
	jr z, .false
	ld a, TRUE
.false
	ld [hScriptVar], a
	ret

_EngineFlagAction:
	jpba EngineFlagAction

Script_wildoff:
; script command 0x38

	ld hl, wStatusFlags
	set 5, [hl]
	ret

Script_wildon:
; script command 0x37

	ld hl, wStatusFlags
	res 5, [hl]
	ret

Script_warpfacing:
; script command 0xa3
; parameters:
;     facing (SingleByteParam)
;     map_group (MapGroupParam)
;     map_id (MapIdParam)
;     x (SingleByteParam)
;     y (SingleByteParam)

	call GetScriptByte
	and $3
	ld c, a
	ld a, [wPlayerSpriteSetupFlags]
	set 5, a
	or c
	ld [wPlayerSpriteSetupFlags], a
; fall through

Script_warp:
; script command 0x3c
; parameters:
;     map_group (MapGroupParam)
;     map_id (MapIdParam)
;     x (SingleByteParam)
;     y (SingleByteParam)

; This seems to be some sort of error handling case.
	call GetScriptByte
	and a
	jr z, .not_ok
	ld [MapGroup], a
	call GetScriptByte
	ld [MapNumber], a
	call GetScriptByte
	ld [XCoord], a
	call GetScriptByte
	ld [YCoord], a
	ld a, -1
	ld [wd001], a
	ld a, [MapGroup]
	cp GROUP_BATTLE_TOWER_HALLWAY
	ld a, MAPSETUP_BATTLE_TOWER
	jr z, .got_method
	ld a, MAPSETUP_WARP
	jr .got_method

.not_ok
	call GetScriptByte
	call GetScriptByte
	call GetScriptByte
	ld a, -1
	ld [wd001], a
	ld a, MAPSETUP_BADWARP
.got_method
	jp WriteMapEntryMethodLoadMapStatusEnterMapAndStopScript

Script_warpmod:
; script command 0x3a
; parameters:
;     warp_id (SingleByteParam)
;     map_group (MapGroupParam)
;     map_id (MapIdParam)

	call GetScriptByte
	cp $ff
	jr nz, .doNotUseScriptVar
	ld a, [hScriptVar]
.doNotUseScriptVar
	ld [BackupWarpNumber], a
	call GetScriptByte
	ld [BackupMapGroup], a
	call GetScriptByte
	ld [BackupMapNumber], a
	ret

Script_blackoutmod:
; script command 0x3b
; parameters:
;     map_group (MapGroupParam)
;     map_id (MapIdParam)

	call GetScriptByte
	ld [wLastSpawnMapGroup], a
	call GetScriptByte
	ld [wLastSpawnMapNumber], a
	ret

Script_dontrestartmapmusic:
; script command 0x83

	ld a, 1
	ld [wDontPlayMapMusicOnReload], a
	ret

Script_writecmdqueue:
; script command 0x7d
; parameters:
;     queue_pointer (MultiByteParam)

	call GetScriptByte
	ld e, a
	call GetScriptByte
	ld d, a
	ld a, [ScriptBank]
	ld b, a
	jpba WriteCmdQueue ; no need to callba

Script_delcmdqueue:
; script command 0x7e
; parameters:
;     byte (SingleByteParam)

	xor a
	ld [hScriptVar], a
	call GetScriptByte
	ld b, a
	callba DelCmdQueue ; no need to callba
	ret c
	ld a, 1
	ld [hScriptVar], a
	ret

Script_changemap:
; script command 0x79
; parameters:
;     map_data_pointer (MapDataPointerParam)

	call GetScriptByte
	ld [MapBlockDataBank], a
	call GetScriptByte
	ld [MapBlockDataPointer], a
	call GetScriptByte
	ld [MapBlockDataPointer + 1], a
	call ChangeMap
	jp BufferScreen

Script_changeblock:
; script command 0x7a
; parameters:
;     x (SingleByteParam)
;     y (SingleByteParam)
;     block (SingleByteParam)

	call GetScriptByte
	add 4
	ld d, a
	call GetScriptByte
	add 4
	ld e, a
	call GetBlockLocation
	call GetScriptByte
	ld [hl], a
	jp BufferScreen

Script_reloadmappart::
; script command 0x7c

	xor a
	ld [hBGMapMode], a
	call OverworldTextModeSwitch
	call GetMovementPermissions
	callba ReloadMapPart
	jp UpdateSprites

Script_warpcheck:
; script command 0x8e

	call WarpCheck
	ret nc
	jpba EnableEvents

Script_newloadmap:
; script command 0x8a
; parameters:
;     which_method (SingleByteParam)

	call GetScriptByte

; fallthrough
WriteMapEntryMethodLoadMapStatusEnterMapAndStopScript:
	ld [hMapEntryMethod], a
	ld a, $1
	ld [MapStatus], a
	jp StopScript

Script_reloadandreturn:
; script command 0x92

	call Script_newloadmap
	jp Script_end

Script_closetext:
; script command 0x49

	call BGMapAnchorTopLeft
	jp CloseText

Script_passtoengine:
; script command 0x89
; parameters:
;     data_pointer (PointerLabelBeforeBank)

	call GetScriptByte
	push af
	call GetScriptHalfword
	pop af
	jp StartAutoInput

Script_pause:
; script command 0x8b
; parameters:
;     length (DecimalParam)

	call GetScriptByte
	and a
	jr z, .loop
	ld [ScriptDelay], a
.loop
	ld c, 2
	call DelayFrames
	ld hl, ScriptDelay
	dec [hl]
	jr nz, .loop
	ret

Script_deactivatefacing:
; script command 0x8c
; parameters:
;     time (SingleByteParam)

	call GetScriptByte
	and a
	jr z, .no_time
	ld [ScriptDelay], a
.no_time
	ld a, SCRIPT_WAIT
	ld [ScriptMode], a
	jp StopScript

Script_ptpriorityjump:
; script command 0x8f
; parameters:
;     pointer (ScriptPointerLabelParam)

	call StopScript
	jp Script_jump

Script_end:
; script command 0x91

	call ExitScriptSubroutine
	ret nc
	xor a
	ld [ScriptRunning], a
	ld [ScriptMode], a ; SCRIPT_OFF
	ld hl, ScriptFlags
	res 0, [hl]
	jp StopScript

Script_return:
; script command 0x90

	call ExitScriptSubroutine
	ld hl, ScriptFlags
	res 0, [hl]
	jp StopScript

ExitScriptSubroutine:
; Return carry if there's no parent to return to.

	ld hl, wScriptStackSize
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ld e, [hl]
	ld d, $0
	ld hl, wScriptStack
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, a
	and $7f
	ld [ScriptBank], a
	ld a, [hli]
	ld e, a
	ld [ScriptPos], a
	ld a, [hl]
	ld d, a
	ld [ScriptPos + 1], a
	and a
	ret
.done
	scf
	ret

Script_end_all:
; script command 0x93

	xor a
	ld [wScriptStackSize], a
	ld [ScriptRunning], a
	ld a, SCRIPT_OFF
	ld [ScriptMode], a
	ld hl, ScriptFlags
	res 0, [hl]
	jp StopScript

Script_halloffame:
; script command 0xa1

	ld hl, GameTimerPause
	res 0, [hl]
	callba HallOfFame
	ld hl, GameTimerPause
	set 0, [hl]
	jr ReturnFromCredits

Script_credits:
; script command 0xa2

	callba RedCredits
ReturnFromCredits:
	call Script_end_all
	ld a, $3
	ld [MapStatus], a
	jp StopScript

Script_wait:
; script command 0xa8
; parameters:
;     unknown (SingleByteParam)

	push bc
	call GetScriptByte
.loop
	push af
	ld c, 6
	call DelayFrames
	pop af
	dec a
	jr nz, .loop
	pop bc
	ret

Script_loadscrollingmenudata:
; script command 0xa9
	call Script_loadmenudata
	xor a
	ld [wScrollingMenuScrollPosition], a
	inc a
	ld [wScrollingMenuCursorBuffer], a
	ret

Script_backupcustchar:
	ld hl, wPlayerCharacteristics
	ld de, wSavedPlayerCharacteristics2
	ld bc, wSavedPlayerCharacteristics2End - wSavedPlayerCharacteristics2
	rst CopyBytes
	ret

Script_restorecustchar:
	ld hl, wSavedPlayerCharacteristics2
	ld de, wPlayerCharacteristics
	ld bc, wSavedPlayerCharacteristics2End - wSavedPlayerCharacteristics2
	rst CopyBytes
	jpba RefreshSprites

Script_giveminingEXP:
	ld hl, MiningLevel
	ld a, 1
	call IncreaseCraftEXP
	ret nc

	ld b, BANK(.increaseMineLvlScript)
	ld de, .increaseMineLvlScript
	jp ScriptCall

.increaseMineLvlScript
	opentext
	farwritetext IncreaseMiningLevel
	jump FinishCraftLevel

Script_givesmeltingEXP:
	ld hl, SmeltingLevel
	ld a, 1
	call IncreaseCraftEXP
	ret nc

	ld b, BANK(.increasesmeltingLvlScript)
	ld de, .increasesmeltingLvlScript
	jp ScriptCall

.increasesmeltingLvlScript
	opentext
	farwritetext IncreaseSmeltingLevel
FinishCraftLevel:
	playwaitsfx SFX_DEX_FANFARE_50_79 ;Why isnt the sound playing? ; Because this was missing TriHard
	endtext

Script_giveballmakingEXP:
	ld hl, BallMakingLevel
	ld a, [hScriptVar]
	call IncreaseCraftEXP
	ret nc
	ld b, BANK(IncreaseBallMakingLevel)
	ld hl, IncreaseBallMakingLevel
	ld de, BallMakingLevel
	jr IncreaseCraftEXP_KeepCheckingEXP

Script_givejewelingEXP:
	ld hl, JewelingLevel
	ld a, [hScriptVar]
	call IncreaseCraftEXP
	ret nc
	ld b, BANK(IncreaseJewelingLevel)
	ld hl, IncreaseJewelingLevel
	ld de, JewelingLevel
IncreaseCraftEXP_KeepCheckingEXP:
	push hl
	push bc
	push de
	call MapTextbox
	ld de, SFX_DEX_FANFARE_50_79
	call PlayWaitSFX
	pop hl
	push hl
	call CheckIfCraftingLevelWouldIncrease
	pop de
	pop bc
	pop hl
	jr c, IncreaseCraftEXP_KeepCheckingEXP
	ret

Script_giveTM:
	call GetScriptByte
	ld b, a
	add a, a
	ld a, b
	jr nz, .loaded
	ld a, [hScriptVar]
	or b
.loaded
	ld [wd265], a
	and $7f
	ld c, a
	callba ReceiveTMHM

	push af
	ld hl, wStringBuffer3
	ld a, [wd265]
	ld b, a
	and $80
	ld c, a
	ld a, b
	and $7f
	cp NUM_TMS + 1
	ld b, "T"
	jr c, .notHM
	sub NUM_TMS
	or c
	ld [wd265], a
	and $7f
	ld b, "H"

.notHM
	ld [hl], b
	inc hl
	ld [hl], "M"
	inc hl

	; This is arguably a more efficient way to handle a 2-digit number
	ld c, 10
	call SimpleDivide
	ld c, a
	ld a, b
	add "0"
	ld [hli], a
	ld a, c
	add "0"
	ld [hli], a
	ld [hl], "@"

	call OpenText

	ld a, [wd265]
	bit 7, a
	ld b, BANK(_ReceivedTMText)
	ld hl, _ReceivedTMText
	jr nz, .gotTM
	ld hl, _FoundTMText
.gotTM
	call MapTextbox

	pop af
	jr nc, .full

	ld de, SFX_GET_TM
	call PlayWaitSFX

	ld b, BANK(_AddedTMText)
	ld hl, _AddedTMText
	call MapTextbox
	call WaitButton
	ld a, 1
	jr .finish

.full
	call ButtonSound
	ld b, BANK(_TMCaseFullText)
	ld hl, _TMCaseFullText
	call MapTextbox
	call WaitButton
	xor a
.finish
	ld [hScriptVar], a
	jp CloseText


_FoundTMText: ; Item
	text_jump FoundTMText

_ReceivedTMText: ; NPC Gives you a TM
	text_jump ReceivedTMText

_AddedTMText: ;
	text_jump AddedTMText

_TMCaseFullText:
	text_jump TMCaseFullText

Script_giveTMnomessage:
	call GetScriptByteOrVar
	ld c, a
	callba ReceiveTMHM
	sbc a
	and 1
	ld [hScriptVar], a
	ret

CheckIfCraftingLevelWouldIncrease:
	xor a

; fallthrough
IncreaseCraftEXP: ; Returns carry if you gained a level
	ld b, a
	ld a, [hli] ; Max crafting level is 100
	cp $64
	ret nc

	ld a, [hl]
	add b
	ld [hld], a
	ld b, a
	ld a, [hl]
	call GetCraftingEXPForLevel
	cp b
	jr z, .increaseLevel
	jr c, .increaseLevel
	and a
	ret

.increaseLevel
	sub b
	cpl
	inc a
	inc [hl]
	inc hl
	ld [hl], a
	scf
	ret

GetCraftingEXPForLevel:
	push hl
	inc a
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, -1
	ld de, 1
.sqrtLoop
	inc a
	dec e
	dec de
	add hl, de
	jr c, .sqrtLoop
	pop hl
	ret

Script_checkash:
	ld bc, hScriptHalfwordVar
	callba CheckAsh
	jp CompareMoneyAction

Script_setplayersprite:
	call GetScriptByte
	cp $ff
	jr nz, .compute
	ld a, [hScriptVar]
.compute
	and $7
	rla
	ld b, a
	ld a, [wPlayerGender]
	and $1
	or b
	ld [wPlayerGender], a
	ret ; callba RefreshSprites to apply

Script_setplayercolor:
	call GetScriptByte
	and a
	jr nz, .mem
	call GetScriptByte
	ld [wPlayerClothesPalette], a
	call GetScriptByte
	ld [wPlayerClothesPalette + 1], a
	ld a, [wPlayerGender]
	and $f
	ld b, a
	call GetScriptByte
	jr .set_race

.mem
	ld hl, PlayerColor
	ld a, [hli]
	ld [wPlayerClothesPalette], a
	ld a, [hli]
	ld [wPlayerClothesPalette + 1], a
	ld a, [hl]
.set_race
	and $f
	swap a
	or b
	ld [wPlayerGender], a
	ret ; callba RefreshSprites to apply

Script_loadsignpost:
	call RefreshScreen

	call GetScriptHalfwordOrVar_HL

	callba _Signpost
	call CloseText
	jp Script_end

Script_checkpokemontype: ;Returns 1 if this Pokemon is either X type or has a X typed move. 0 if it doesn't have either. 2 if you backed out.
	call GetScriptByte
	push af
	callba SelectMonFromParty
	jr c, .cancel
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	pop af
	ld hl, BaseType
	cp [hl]
	jr z, .OK
	inc hl
	cp [hl]
	jr z, .OK
	push af
	ld a, [wCurPartyMon]
	ld hl, PartyMon1Moves
	call GetPartyLocation
	pop bc
	ld c, 4

.loop
	push bc
	ld a, [hli]
	push hl
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	pop hl
	pop bc
	cp b
	jr z, .OK ;Move type matches!

	dec c
	jr nz, .loop
	xor a
	ld [hScriptVar], a
	ret

.OK
	ld a, 1
	ld [hScriptVar], a
	ret

.cancel
	pop af
	ld a, 2
	ld [hScriptVar], a
	ret

Script_addbytetovar:
	call GetScriptHalfwordOrVar
	ld h, d
	ld l, e
	ld a, [hScriptVar]
	add [hl]
	ld [hScriptVar], a
	ret
	
Script_giveorphanpoints:
	call LoadCoinAmountToMem
	jpba GiveOrphanPoints

Script_takeorphanpoints:
	call LoadCoinAmountToMem
	jpba TakeOrphanPoints

Script_checkorphanpoints:
	call LoadCoinAmountToMem
	callba CheckOrphanPoints
	jp CompareMoneyAction

Script_backupsecondpokemon:
	CheckEngine ENGINE_POKEMON_MODE
	ret nz ; sanity check
	ld hl, wPartyMon2
	ld de, wBackupMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	ld hl, wPartyCount
	ld a, [hl]
	ld [wBackupSecondPartySpecies], a
	ld a, 1
	ld [hl], a

	ld hl, wPartySpecies + 1
	ld de, wPokeonlyBackupPokemonSpecies
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, $ff
	dec hl
	ld [hl], a

	ld de, wPokeonlyBackupPokemonOT
	ld hl, wPartyMonOT + NAME_LENGTH
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld de, wPokeonlyBackupPokemonNickname
	ld hl, wPartyMonNicknames + PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes

	ret

Script_restoresecondpokemon:
	CheckEngine ENGINE_POKEMON_MODE
	ret z ; insanity check
	ld de, wPartyMon2
	ld hl, wBackupMon
	ld bc, PARTYMON_STRUCT_LENGTH
	rst CopyBytes
	ld a, [wBackupSecondPartySpecies]
	ld [wPartyCount], a

	ld de, wPartySpecies + 1
	ld hl, wPokeonlyBackupPokemonSpecies
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld hl, wPokeonlyBackupPokemonOT
	ld de, wPartyMonOT + NAME_LENGTH
	ld bc, NAME_LENGTH
	rst CopyBytes

	ld hl, wPokeonlyBackupPokemonNickname
	ld de, wPartyMonNicknames + PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	rst CopyBytes
	ret

Script_minpartylevel:
	ld a, [wPartyCount]
	and a
	jr z, .done
	ld b, a
	ld c, MAX_LEVEL
	ld hl, PartyMon1Level
	ld de, PARTYMON_STRUCT_LENGTH
.loop
	ld a, [hl]
	cp c
	jr nc, .not_lower
	ld c, a
.not_lower
	add hl, de
	dec b
	jr nz, .loop
	ld a, c
.done
	ld [hScriptVar], a
	ret
	
Script_givearcadetickets:
	call GetScriptThreeBytes
	jpba GiveArcadeTickets

Script_takearcadetickets:
	call GetScriptThreeBytes
	jpba TakeArcadeTickets

Script_checkarcadetickets:
	call GetScriptThreeBytes
	ld hl, wBattleArcadeTickets
	ld a, [hli]
	cp c
	jr nz, .done
	ld a, [hli]
	cp d
	jr nz, .done
	ld a, [hl]
	cp e
	jr nz, .done
	ld a, 1
	jr .calculated
.done
	sbc a
	and 2
.calculated
	ld [hScriptVar], a
	ret

Script_checkarcadehighscore:
	call GetScriptWord
	ld hl, wBattleArcadeMaxScore
	predef CompareBCDEtoHL
	jr nz, .not_equal
	ld a, 1
	jr .calculated
.not_equal
	ccf
	sbc a
	and 2
.calculated
	ld [hScriptVar], a
	ret

Script_checkarcademaxround:
	call GetScriptHalfword
	ld a, [wBattleArcadeMaxRound]
	cp h
	jr nz, .done
	ld a, [wBattleArcadeMaxRound + 1]
	cp l
	jr nz, .done
	ld a, 1
	jr .calculated
.done
	sbc a
	and 2
.calculated
	ld [hScriptVar], a
	ret

Script_scriptjumptable:
	call GetScriptHalfword
	jr ScriptJumptable

Script_anonjumptable:
	ld hl, ScriptPos
	ld a, [hli]
	ld h, [hl]
	ld l, a

ScriptJumptable:
	ld a, [hScriptVar]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [ScriptBank]
	call GetFarHalfword
	jp LocalScriptJump

Script_scriptstartasm:
	ld a, [ScriptBank]
	ld hl, ScriptPos
	call FarCall_Pointer
	ld a, h
	or l
	jp z, Script_end
	jp LocalScriptJump

Script_pushbyte:
	call Script_writebyte

; fallthrough
Script_pushvar:
	call ScriptVarStackOperation
.op
	inc [hl]
	ld c, [hl]
	ld b, 0
	add hl, bc
	ld a, [hScriptVar]
	ld [hl], a
	ret

Script_popvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	ld b, 0
	dec [hl]
	add hl, bc
	ld a, [hl]
	ld [hScriptVar], a
	ret

Script_swapbyte:
	call Script_writebyte

; fallthrough
Script_swapvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	ld b, 0
	add hl, bc
	ld c, [hl]
	ld a, [hScriptVar]
	ld [hl], a
	ld a, c
	ld [hScriptVar], a
	ret

Script_pullvar:
	call ScriptVarStackOperation
.op
	ld a, [hl]
	ld [hScriptVar], a
	ret

Script_pushhalfword:
	call Script_writehalfword

; fallthrough
Script_pushhalfwordvar:
	call ScriptVarStackOperation
.op
	ld a, [hl]
	inc a
	ld c, a
	ld b, 0
	inc a
	ld [hl], a
	add hl, bc
	ld a, [hScriptHalfwordVar]
	ld [hli], a
	ld a, [hScriptHalfwordVar + 1]
	ld [hl], a
	ret

Script_pullhalfwordvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	ld b, 0
	jr ReadHalfwordOffScriptVarStack

Script_pophalfwordvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	ld b, 0
	dec [hl]
	dec [hl]
ReadHalfwordOffScriptVarStack:
	add hl, bc
	ld a, [hld]
	ld e, [hl]
	ld d, a
	jp WriteDEToScriptHalfword

Script_swaphalfword:
	call Script_writehalfword

; fallthrough
Script_swaphalfwordvar:
	call ScriptVarStackOperation
.op
	ld c, [hl]
	ld b, 0
	add hl, bc
	ld a, [hld]
	ld c, [hl]
	ld b, a
	ld de, hScriptHalfwordVar
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	ld a, b
	ld [de], a
	dec de
	ld a, c
	ld [de], a
	dec de
	ret

ScriptVarStackOperation:
	pop hl
	ld a, [rSVBK]
	push af
	ld a, BANK(wScriptVarStackCount)
	ld [rSVBK], a
	call .execute_op
	pop af
	ld [rSVBK], a
	ret
.execute_op
	push hl
	ld hl, wScriptVarStackCount
	ret ; intentional push/pop mismatch

Script_loadarray:
; load array data
; pointer and array entry size
	call GetScriptHalfwordOrVar
	ld hl, wScriptArrayAddress
	ld a, [ScriptBank]
	ld [wScriptArrayBank], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	call GetScriptByte
	ld [hli], a
	ld a, [hScriptVar]
	ld [hl], a
	ret

Script_readarray:
; reads the following value in the loaded array at index [wScriptArrayCurrentEntry]
; if the array entry size is 1, omit the set entry
	call GetScriptArrayPointer
	call GetFarByte
	ld [hScriptVar], a
	ret

Script_readarrayhalfword:
; like Script_readarray, but return a halfword in hScriptHalfwordVar instead
	call GetScriptArrayPointer
	call GetFarHalfword
	ld a, l
	ld [hScriptHalfwordVar], a
	ld a, h
	ld [hScriptHalfwordVar + 1], a
	ret

Script_cmdwitharrayargs:
; execute a command with custom arguments
	callba CreateScriptCommandWithCustomArguments
	ld de, wScriptArrayCommandBuffer
	ld b, BANK(Script_cmdwitharrayargs)
	jp ScriptCall

GetScriptArrayPointer:
	ld hl, wScriptArrayAddress
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wScriptArrayEntrySize]
	ld c, a
	ld b, 0 ; store entry size in bc
	call GetScriptByte
	ld e, a
	ld d, b ; store entry index in de
	ld a, [wScriptArrayCurrentEntry]
	rst AddNTimes ; get entry pointer
	add hl, de ; plus index
	ld a, [wScriptArrayBank]
	ret

Script_getweekday:
	call UpdateTime
	call GetWeekday
	ld [hScriptVar], a
	ret

Script_milosswitch:
	callba MilosSwitchAction
	jp ScriptCall

Script_QRCode:
	call Script_writebyte
	jpba WriteQRCode

Script_switch:
; writebyte + selse combined into one
; hacky way of having fallthroughs to one point, abusing how selse and sendif work
; might break something
	call Script_writebyte

Script_selse:
	jpba ScriptSkipPastEndIf

Script_siffalse:
	ld b, 0
	jr ScriptConditionalEntryPoint

Script_siftrue:
	ld b, 1
	jr ScriptConditionalEntryPoint

Script_siflt:
	ld b, 2
	jr ScriptConditionalEntryPoint

Script_sifgt:
	ld b, 3
	jr ScriptConditionalEntryPoint

Script_sifeq:
	ld b, 4
	jr ScriptConditionalEntryPoint

Script_sifne:
	ld b, 5
ScriptConditionalEntryPoint:
	jpba ScriptConditional

Script_comparevartobyte:
	call GetScriptHalfwordOrVar
	ld a, [de]
	ld d, a
	ld a, [hScriptVar]
	cp d
	ld a, 2
	jr z, .done
	sbc a
	and 2
.done
	ld [hScriptVar], a
	ret

Script_vartohalfwordvar:
	ld a, [hScriptVar]
	ld [hScriptHalfwordVar], a
	xor a
	ld [hScriptHalfwordVar + 1], a
	ret
	
Script_findpokemontype:
	; finds a Pokémon of the indicated type, or one that has a move of that type. Returns in [hScriptVar], party index (1..6) if found or 0 if not
	call GetScriptByte
	ld [hScriptBuffer], a
	ld a, [wPartyCount]
	and a
	ld d, a
	jr z, .done
	ld hl, wPartyMon1
	ld bc, PARTYMON_STRUCT_LENGTH
	ld e, b ; b = 0 since the partymon struct is less than $100 bytes
.loop
	inc e
	push de
	push bc
	push hl
	call .check_type
	jr z, .found
	pop hl
	push hl
	call .check_moves
	jr c, .found
	pop hl
	pop bc
	pop de
	add hl, bc
	dec d
	jr nz, .loop
	xor a
.done
	ld [hScriptVar], a
	ret
.found
	add sp, 4 ;skip the pushed values
	pop de
	ld a, e
	jr .done
.check_type
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [hScriptBuffer]
	ld hl, BaseType
	cp [hl]
	ret z
	inc hl
	cp [hl]
	ret
.check_moves
	inc hl
	inc hl
	ld e, NUM_MOVES
	ld a, [hScriptBuffer]
	ld d, a
.move_loop
	ld a, [hli]
	push hl
	and a
	jr z, .skip_move
	dec a
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and $3f
	cp d
	jr z, .found_move
.skip_move
	pop hl
	dec e
	jr nz, .move_loop
	and a
	ret
.found_move
	pop hl
	scf
	ret

Script_startpokeonly:
	CheckEngine ENGINE_POKEMON_MODE
	jr z, .good
	call GetScriptThreeBytes
	xor a
	ld [hScriptVar], a
	ret

.good
	call Script_blackoutmod
	call GetScriptByte
	ld b, a
	ld de, ENGINE_USE_TREASURE_BAG
	call _EngineFlagAction
	call Script_backupsecondpokemon
	ld a, $1
	ld [hScriptVar], a
	ret

Script_endpokeonly:
	CheckEngine ENGINE_POKEMON_MODE
	jr nz, .good
	call GetScriptThreeBytes
	xor a
	ld [hScriptVar], a
	ret

.good
	call Script_blackoutmod
	call GetScriptByte
	ld b, a
	ld de, ENGINE_USE_TREASURE_BAG
	call EngineFlagAction
	call Script_restoresecondpokemon
	ld a, $1
	ld [hScriptVar], a
	ret

Script_showFX:
	jp GetScriptWord

Script_copystring:
	ld hl, hScriptHalfwordVar
	ld a, [hli]
	ld d, [hl]
	ld e, a
	call GetScriptStringBuffer
	jp CopyName2

Script_readhalfwordbyindex:
	call GetScriptHalfwordOrVar
	ld a, [hScriptVar]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld [hScriptVar], a
	ld a, [hl]
	ld [hScriptVar + 1], a
	ret
