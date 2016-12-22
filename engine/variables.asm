_GetVarAction::
	ld a, c
	cp NUM_VARS
	jr c, .valid
	xor a
.valid
	ld c, a
	ld b, 0
	ld hl, .VarActionTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld b, [hl]
	ld a, b
	and RETVAR_EXECUTE
	jp nz, _de_
	ld a, b
	and RETVAR_ADDR_DE
	ret nz
	ld a, [de]
	jp .loadstringbuffer2

.VarActionTable
; $00: copy [de] to wStringBuffer2
; $40: return address in de
; $80: call function
	dwb wStringBuffer2,                 RETVAR_STRBUF2
	dwb wPartyCount,                    RETVAR_STRBUF2
	dwb .BattleResult,                  RETVAR_EXECUTE
	dwb wBattleType,                    RETVAR_ADDR_DE
	dwb TimeOfDay,                      RETVAR_STRBUF2
	dwb .CountCaughtMons,               RETVAR_EXECUTE
	dwb .CountSeenMons,                 RETVAR_EXECUTE
	dwb .CountBadges,                   RETVAR_EXECUTE
	dwb PlayerState,                    RETVAR_ADDR_DE
	dwb .PlayerFacing,                  RETVAR_EXECUTE
	dwb hHours,                         RETVAR_STRBUF2
	dwb .DayOfWeek,                     RETVAR_EXECUTE
	dwb MapGroup,                       RETVAR_STRBUF2
	dwb MapNumber,                      RETVAR_STRBUF2
	dwb wStringBuffer2,                 RETVAR_STRBUF2
	dwb wPermission,                    RETVAR_STRBUF2
	dwb .BoxFreeSpace,                  RETVAR_EXECUTE
	dwb wStringBuffer2,                 RETVAR_STRBUF2
	dwb XCoord,                         RETVAR_STRBUF2
	dwb YCoord,                         RETVAR_STRBUF2

.CountCaughtMons
; Caught mons.
	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	jr .bits

.CountSeenMons
; Seen mons.
	ld hl, PokedexSeen
	ld b, EndPokedexSeen - PokedexSeen
	jr .bits

.CountBadges
; Number of owned badges.
	ld hl, Badges
	ld b, 3
.bits
	call CountSetBits
	ld a, [wd265]
	jr .loadstringbuffer2

.PlayerFacing
; The direction the player is facing.
	ld a, [PlayerDirection]
	and $c
	rrca
	rrca
	jr .loadstringbuffer2

.DayOfWeek
; The day of the week.
	call GetWeekday
	jr .loadstringbuffer2

.BoxFreeSpace
; Remaining slots in the current box.
	ld a, BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
	ld a, MONS_PER_BOX
	sub [hl]
	ld b, a
	call CloseSRAM
	ld a, b
	jr .loadstringbuffer2

.BattleResult
	ld a, [wBattleResult]
	and $3f
.loadstringbuffer2
	ld de, wStringBuffer2
	ld [de], a
	ret
