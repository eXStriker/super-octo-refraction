DaycareStep:: ; 7282

	ld a, [wDaycareMan]
	bit 0, a
	jr z, .daycare_lady

	ld a, [wBreedMon1Level] ; level
	cp 100
	jr nc, .daycare_lady
	ld hl, wBreedMon1Exp + 2 ; exp
	inc [hl]
	jr nz, .daycare_lady
	dec hl
	inc [hl]
	jr nz, .daycare_lady
	dec hl
	inc [hl]
	ld a, [hl]
	cp 5242880 / $10000
	jr c, .daycare_lady
	ld a, 5242880 / $10000
	ld [hl], a

.daycare_lady
	ld a, [wDaycareLady]
	bit 0, a
	jr z, .check_egg

	ld a, [wBreedMon2Level] ; level
	cp 100
	jr nc, .check_egg
	ld hl, wBreedMon2Exp + 2 ; exp
	inc [hl]
	jr nz, .check_egg
	dec hl
	inc [hl]
	jr nz, .check_egg
	dec hl
	inc [hl]
	ld a, [hl]
	cp 5242880 / $10000
	jr c, .check_egg
	ld a, 5242880 / $10000
	ld [hl], a

.check_egg
	ld hl, wDaycareMan
	bit 5, [hl] ; egg
	ret z
	ld hl, wStepsToEgg
	dec [hl]
	ret nz

	call Random
	and $7f
	ld [hl], a
	callba CheckBreedmonCompatibility
	ld a, [wd265]
	cp 230
	ld b, -1 + 32 percent
	jr nc, .okay
	ld a, [wd265]
	cp 170
	ld b, 16 percent
	jr nc, .okay
	ld a, [wd265]
	cp 110
	ld b, 12 percent
	jr nc, .okay
	ld b, 4 percent

.okay
	call Random
	cp b
	ret nc
	ld hl, wDaycareMan
	res 5, [hl]
	set 6, [hl]
	ret
