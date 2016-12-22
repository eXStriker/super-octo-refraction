GetPokeBallWobble: ; f971 (3:7971)
; Returns whether a Poke Ball will wobble in the catch animation.
; Whether a Pokemon is caught is determined beforehand.

	push de

	ld a, [rSVBK]
	push af

	ld a, 1 ; BANK(wCatchMon_NumShakes)
	ld [rSVBK], a

	ld a, [wCatchMon_NumShakes]
	inc a
	ld [wCatchMon_NumShakes], a

; Wobble up to 3 times.
	ld a, [wCatchMon_Critical]
	and a
	ld a, [wCatchMon_NumShakes]
	ld b, 1 + 1
	jr nz, .critical
	ld b, 3 + 1
.critical
	cp b
	jr nc, .caught
	ld a, [wWildMon] ; sure catch
	and a
	jr nz, .next
	; ld hl, wCatchMon_CatchRate
	; ; This is a frame-perfect trick that slightly improves your chances
	; ; of catching the Pokemon.
	; ld a, [hJoyPressed]
	; and D_DOWN | B_BUTTON
	; cp  D_DOWN | B_BUTTON
	; ld a, [hl]
	; jr nz, .check
	; cp $ff
	; jr z, .check
	; inc a
	; ld [hl], a
; .check
	ld a, [wCatchMon_CatchRate] ; to make down+b a thing, uncomment the above lines and comment this one
	dec a
	ld e, a
	ld d, 0
	ld hl, PokeballWobbleProbabilities
	add hl, de
	add hl, de
	ld a, [hli]
	ld c, a
	ld b, [hl]

; two random calls to avoid similarities with the dsum
	call Random
	ld d, a
	call Random
	sub c
	ld a, d
	sbc b
	ld c, 2 ; escaped
	jr nc, .done
.next
	ld c, 0 ; next wobble iteration
	jr .done

.caught
	ld a, [EnemyMonSpecies]
	ld [wWildMon], a
	ld c, 1 ; caught
.done
	pop af
	ld [rSVBK], a
	pop de
	ret

PokeballWobbleProbabilities: ; f9ba
; lookup table for the chance of wobbling
; equivalent to 65536/(255/catchRate)^0.1875
	dw 23187
	dw 26405
	dw 28491
	dw 30070
	dw 31355
	dw 32445
	dw 33397
	dw 34243
	dw 35008
	dw 35707
	dw 36350
	dw 36948
	dw 37507
	dw 38032
	dw 38527
	dw 38996
	dw 39442
	dw 39867
	dw 40273
	dw 40662
	dw 41036
	dw 41395
	dw 41742
	dw 42076
	dw 42400
	dw 42713
	dw 43016
	dw 43310
	dw 43596
	dw 43874
	dw 44145
	dw 44408
	dw 44665
	dw 44916
	dw 45161
	dw 45400
	dw 45634
	dw 45863
	dw 46086
	dw 46306
	dw 46521
	dw 46731
	dw 46938
	dw 47141
	dw 47340
	dw 47535
	dw 47727
	dw 47916
	dw 48102
	dw 48284
	dw 48464
	dw 48641
	dw 48815
	dw 48986
	dw 49155
	dw 49321
	dw 49485
	dw 49647
	dw 49806
	dw 49963
	dw 50119
	dw 50272
	dw 50423
	dw 50572
	dw 50719
	dw 50864
	dw 51008
	dw 51150
	dw 51290
	dw 51429
	dw 51566
	dw 51701
	dw 51835
	dw 51967
	dw 52098
	dw 52228
	dw 52356
	dw 52483
	dw 52608
	dw 52733
	dw 52856
	dw 52977
	dw 53098
	dw 53217
	dw 53335
	dw 53453
	dw 53568
	dw 53683
	dw 53797
	dw 53910
	dw 54022
	dw 54133
	dw 54243
	dw 54351
	dw 54459
	dw 54566
	dw 54673
	dw 54778
	dw 54882
	dw 54986
	dw 55088
	dw 55190
	dw 55291
	dw 55392
	dw 55491
	dw 55590
	dw 55688
	dw 55785
	dw 55881
	dw 55977
	dw 56072
	dw 56167
	dw 56260
	dw 56353
	dw 56446
	dw 56537
	dw 56628
	dw 56719
	dw 56809
	dw 56898
	dw 56987
	dw 57075
	dw 57162
	dw 57249
	dw 57335
	dw 57421
	dw 57506
	dw 57591
	dw 57675
	dw 57758
	dw 57841
	dw 57924
	dw 58006
	dw 58087
	dw 58168
	dw 58249
	dw 58329
	dw 58409
	dw 58488
	dw 58566
	dw 58645
	dw 58722
	dw 58800
	dw 58877
	dw 58953
	dw 59029
	dw 59105
	dw 59180
	dw 59255
	dw 59329
	dw 59403
	dw 59477
	dw 59550
	dw 59622
	dw 59695
	dw 59767
	dw 59839
	dw 59910
	dw 59981
	dw 60051
	dw 60122
	dw 60191
	dw 60261
	dw 60330
	dw 60399
	dw 60467
	dw 60535
	dw 60603
	dw 60671
	dw 60738
	dw 60805
	dw 60871
	dw 60937
	dw 61003
	dw 61069
	dw 61134
	dw 61199
	dw 61264
	dw 61328
	dw 61392
	dw 61456
	dw 61520
	dw 61583
	dw 61646
	dw 61708
	dw 61771
	dw 61833
	dw 61895
	dw 61956
	dw 62018
	dw 62079
	dw 62140
	dw 62200
	dw 62261
	dw 62321
	dw 62380
	dw 62440
	dw 62499
	dw 62558
	dw 62617
	dw 62676
	dw 62734
	dw 62792
	dw 62850
	dw 62908
	dw 62965
	dw 63022
	dw 63079
	dw 63136
	dw 63193
	dw 63249
	dw 63305
	dw 63361
	dw 63417
	dw 63472
	dw 63527
	dw 63582
	dw 63637
	dw 63692
	dw 63746
	dw 63800
	dw 63854
	dw 63908
	dw 63962
	dw 64015
	dw 64069
	dw 64122
	dw 64175
	dw 64227
	dw 64280
	dw 64332
	dw 64384
	dw 64436
	dw 64488
	dw 64539
	dw 64591
	dw 64642
	dw 64693
	dw 64744
	dw 64795
	dw 64845
	dw 64896
	dw 64946
	dw 64996
	dw 65046
	dw 65095
	dw 65145
	dw 65194
	dw 65244
	dw 65293
	dw 65342
	dw 65390
	dw 65439
	dw 65487
	dw 65535
