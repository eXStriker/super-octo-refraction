BattleCommand_StartRain:
; startrain
	ld b, WEATHER_RAIN
	ld hl, DownpourText
	jr StartWeather

BattleCommand_StartSun:
; startsun
	ld b, WEATHER_SUN
	ld hl, SunGotBrightText
	jr StartWeather

BattleCommand_StartSandstorm:
; startsandstorm
	ld b, WEATHER_SANDSTORM
	ld hl, SandstormBrewedText
	jr StartWeather

BattleCommand_StartHail:
; starthail
	ld b, WEATHER_HAIL
	ld hl, StartedToHailText
StartWeather:
	ld a, [EffectFailed]
	and a
	ret nz
	ld a, [Weather]
	cp b
	jr nz, ApplyWeather

.failed
	ld hl, wCurDamage
	ld a, [hli]
	or [hl]
	ret nz
	call AnimateFailedMove
	jp PrintButItFailed

DrizzleFunction:
	ld a, RAIN_DANCE
	ld b, WEATHER_RAIN
	ld hl, DrizzleText
	jr AbilityWeather

DroughtFunction:
	ld a, SUNNY_DAY
	ld b, WEATHER_SUN
	ld hl, DroughtText
	jr AbilityWeather

SandStreamFunction:
	ld a, SANDSTORM
	ld b, WEATHER_SANDSTORM
	ld hl, SandStreamText
	jr AbilityWeather

SnowWarningFunction:
	ld a, HAIL
	ld b, WEATHER_HAIL
	ld hl, SnowWarningText
AbilityWeather:
	push hl
	push bc
	push af
	ld a, [Weather]
	cp b
	jr z, WeatherAbilityFail
	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	pop af
	ld [hl], a
	call UpdateMoveData
	pop bc
	pop hl
ApplyWeather:
	ld a, b
	ld [Weather], a
	push hl
	push bc
	call GetUserItem
	ld a, b
	pop bc
	dec b
	ld c, b
	ld b, 0
	ld hl, .WeatherItems
	add hl, bc
	ld b, a
	ld a, [hl]
	cp b
	ld a, 5
	jr nz, .load
	ld a, 8
.load
	ld [WeatherCount], a
	ld a, 1
	ld [wBattleAnimParam], a
	call AnimateCurrentMove
	pop hl
	jp StdBattleTextBox

.WeatherItems:
	db HELD_DAMP_ROCK
	db HELD_HEAT_ROCK
	db HELD_SMOOTH_ROCK
	db HELD_ICY_ROCK

WeatherAbilityFail:
	pop af
	pop bc
	pop hl
	ret
