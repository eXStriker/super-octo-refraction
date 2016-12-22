TrainerNotes_:
	call TN_PrintToD
	call TN_PrintLocation
	call TN_PrintLV
	call TN_PrintCharacteristics
	jp TN_PrintAbility

TN_PrintToD
	ld de, .caughtat
	hlcoord 1, 8
	call PlaceString
	ld a, [TempMonCaughtTime]
	and $c0
	ld de, .unknown
	jr z, .print
	rlca
	rlca
	cp 2
	ld de, .morn
	jr c, .print
	ld de, .day
	jr z, .print
	ld de, .nite
.print
	hlcoord 5, 8
	jp PlaceText

.caughtat
	db "Met@"

.morn
	ctxt "in the morning"
	done

.day
	ctxt "during the day"
	done

.nite
	ctxt "at night"
	done

.unknown
	ctxt "at unkwn time"
	done

TN_PrintLocation:
	ld de, .unknown
	ld a, [TempMonCaughtLocation]
	and $7f
	jr z, .print
	cp $7e
	jr z, .print
	ld de, .event
	cp $7f
	jr z, .print
	ld e, a
	callba GetLandmarkName
	ld de, .regular
.print
	hlcoord 1, 10
	jp PlaceText

.unknown
	ctxt "Unknown Location"
	done

.event
	ctxt "Event #mon"
	done

.regular
	text "<STRBF1>"
	done

TN_PrintLV:
	ld a, [TempMonCaughtLevel]
	and $3f
	hlcoord 1, 12
	jr z, .unknown
	cp 1
	jr z, .hatched
	cp 63
	jr z, .max
	ld [wTrainerNotes_EncounterLevel], a
	ld de, .metat
	call PlaceText
	ld de, wTrainerNotes_EncounterLevel
	lb bc,   1,  3
	hlcoord  8, 12
	jp PrintNum
.hatched
	ld de, .egg
	jp PlaceText
.unknown
	ld de, .str_unknown
	jp PlaceText
.max
	ld de, .str_max
	jp PlaceText

.metat
	text "Met at ", $6e
	done

.egg
	ctxt "Hatched from Egg"
	done

.str_unknown
	ctxt "Given in a trade"
	done

.str_max
	text "Met at ", $6e, "63+"
	done

TN_PrintCharacteristics:
	ld hl, TempMonDVs
	ld d, 0 ; hp
	ld a, [hl]
	and $f
	ld c, a ; def
	ld a, [hli]
	swap a
	and $f ; atk
	cp c
	ld e, 2
	ld b, c
	jr c, .atk
	ld e, 1
	ld b, a
.atk
	srl a
	rl d
	srl c
	rl d
	ld a, [hl]
	and $f
	ld c, a ; spe
	ld a, [hl]
	swap a
	and $f ; spx
	cp c
	ld l, 5
	ld h, c
	jr c, .spx
	ld l, 3
	ld h, a
.spx
	srl a
	rl d
	srl c
	rl d
	ld a, b
	cp h
	jr nc, .skip
	ld e, l
	ld b, h
.skip
	ld a, b
	cp d
	jr nc, .skiphp
	ld e, 0
	ld b, d
.skiphp
	ld a, 3
	cp e
	jr nz, .skipspx
	; since DVs don't have SpA/SpD split so we have to determine it by OT ID
	ld a, [TempMonID + 1]
	bit 0, a
	jr z, .skipspx
	inc e
.skipspx
	ld a, b
	ld c, 5
	call SimpleDivide
	ld b, a
	ld a, e
	call SimpleMultiply
	add b
	ld l, a
	ld h, 0
	ld bc, Characteristics
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	hlcoord 1, 14
	jp PlaceText

TN_PrintAbility:
	ld hl, TempMon
	call CalcPartyMonAbility
	ld [wd265], a
	call GetAbilityName
	hlcoord 1, 16
	jp PlaceString

Characteristics:
	dw Chara_HP0, Chara_HP1, Chara_HP2, Chara_HP3, Chara_HP4
	dw Chara_ATK0, Chara_ATK1, Chara_ATK2, Chara_ATK3, Chara_ATK4
	dw Chara_DEF0, Chara_DEF1, Chara_DEF2, Chara_DEF3, Chara_DEF4
	dw Chara_SPA0, Chara_SPA1, Chara_SPA2, Chara_SPA3, Chara_SPA4
	dw Chara_SPD0, Chara_SPD1, Chara_SPD2, Chara_SPD3, Chara_SPD4
	dw Chara_SPE0, Chara_SPE1, Chara_SPE2, Chara_SPE3, Chara_SPE4

Chara_HP0:
	ctxt "Loves to eat"
	done
Chara_HP1:
	ctxt "Takes plenty of"
	nl   "siestas"
	done
Chara_HP2:
	ctxt "Nods off a lot"
	done
Chara_HP3:
	ctxt "Scatters things"
	nl   "often"
	done
Chara_HP4:
	ctxt "Likes to relax"
	done

Chara_ATK0:
	ctxt "Proud of its"
	nl   "power"
	done
Chara_ATK1:
	ctxt "Likes to thrash"
	nl   "about"
	done
Chara_ATK2:
	ctxt "A little quick"
	nl   "tempered"
	done
Chara_ATK3:
	ctxt "Likes to fight"
	done
Chara_ATK4:
	ctxt "Quick tempered"
	done

Chara_DEF0: 
	ctxt "Sturdy body"
	done
Chara_DEF1:
	ctxt "Capable of taking"
	nl   "hits"
	done
Chara_DEF2:
	ctxt "Highly persistent"
	done
Chara_DEF3:
	ctxt "Good endurance"
	done
Chara_DEF4:
	ctxt "Good perseverance"
	done

Chara_SPA0:
	ctxt "Highly curious"
	done
Chara_SPA1:
	ctxt "Mischievous"
	done
Chara_SPA2:
	ctxt "Thoroughly"
	nl   "cunning"
	done
Chara_SPA3:
	ctxt "Often lost in"
	nl   "thought"
	done
Chara_SPA4:
	ctxt "Very finicky"
	done

Chara_SPD0:
	ctxt "Strong willed"
	done
Chara_SPD1:
	ctxt "Somewhat vain"
	done
Chara_SPD2:
	ctxt "Strongly defiant"
	done
Chara_SPD3:
	ctxt "Hates to lose"
	done
Chara_SPD4:
	ctxt "Somewhat stubborn"
	done

Chara_SPE0:
	ctxt "Likes to run"
	done
Chara_SPE1:
	ctxt "Alert to sounds"
	done
Chara_SPE2:
	ctxt "Impetuous and"
	nl   "silly"
	done
Chara_SPE3:
	ctxt "Somewhat of a"
	nl   "clown"
	done
Chara_SPE4: 
	ctxt "Quick to flee"
	done
