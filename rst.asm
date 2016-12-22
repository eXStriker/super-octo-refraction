; rst vectors

SECTION "rst0", ROM0[0]
	di
	ld [hCrashSavedA], a
	ld a, $0 ; because xor a destroys f
	jp Crash

SECTION "rst8", ROM0[FarCall]
	jp StackFarCall
DrawBattleHPBar::
; Draw an HP bar d tiles long at hl
; Fill it up to e pixels
; moved due to DED function filling up home bank
	jpba _DrawBattleHPBar

SECTION "rst10", ROM0[Bankswitch]
	ld [hROMBank], a
	ld [MBC3RomBank], a
GenericDummyFunction:: ;keeping this here since it's easy to find
	ret

SECTION "rst18", ROM0[AddNTimes]
	jp _AddNTimes

GetFarByteAndIncrement::
	call GetFarByte
	inc hl
	ret

SECTION "rst20", ROM0[Predef]
	jp _Predef

ReplaceKrisSprite::
	jpba _ReplaceKrisSprite

SECTION "rst28", ROM0[JumpTable]
	jp Jumptable

LoadStandardFont::
	jpba _LoadStandardFont

SECTION "rst30", ROM0[CopyBytes]
	jp _CopyBytes

LoadFontsBattleExtra::
	jpba _LoadFontsBattleExtra

SECTION "rst38", ROM0[$38]
; debugging purposes
	di
	ld [hCrashSavedA], a
	ld a, $1
	jp Crash
