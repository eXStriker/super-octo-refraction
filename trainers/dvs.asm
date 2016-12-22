GetTrainerDVs: ; 270c4
; Return the DVs of OtherTrainerClass in bc

	push hl
	ld a, [OtherTrainerClass]
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerClassDVs
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ret
; 270d6

TrainerClassDVs: ; 270d6
	;  Atk  Spd
	;  Def  Spc
	db $9A, $77 ; Josiah
	db $88, $88 ; Brooklyn
	db $98, $88 ; Rinji
	db $98, $88 ; Edison
	db $98, $88 ; Ayaka
	db $98, $88 ; Cadence
	db $98, $88 ; Andre
	db $7C, $DD ; Bruce
	db $DD, $DD ; Rival1
	db $DC, $DD ; Mura
	db $7E, $DF ; Yuki
	db $98, $88 ; Koji
	db $DC, $DD ; Daichi
	db $98, $A6 ; DelinquentF
	db $DC, $DD ; Sora
	db $DC, $DD ; Lance
	db $BA, $BA ; Patroller
	db $98, $88 ; Scientist
	db $98, $88 ; Youngster
	db $98, $88 ; Schoolboy
	db $98, $88 ; Bird Keeper
	db $58, $88 ; Lass
	db $78, $68 ; Cheerleader
	db $D8, $C8 ; CooltrainerM
	db $7C, $C8 ; CooltrainerF
	db $69, $D8 ; Beauty
	db $98, $88 ; Pokemaniac
	db $D8, $A8 ; GruntF
	db $98, $88 ; Gentleman
	db $98, $88 ; Skier
	db $67, $99 ; Teacher
	db $7B, $8B ; Sheryl
	db $98, $88 ; Bug Catcher
	db $98, $88 ; Fisher
	db $98, $88 ; SwimmerM
	db $78, $88 ; SwimmerF
	db $98, $88 ; Sailor
	db $98, $88 ; Super Nerd
	db $DD, $DD ; Rival2
	db $98, $88 ; Guitarist
	db $AD, $77 ; Hiker
	db $98, $88 ; Biker
	db $B8, $69 ; Joe
	db $98, $88 ; Burglar
	db $98, $88 ; Firebreather
	db $98, $88 ; Juggler
	db $98, $88 ; Blackbelt
	db $98, $88 ; Psychic
	db $6A, $A8 ; Picnicker
	db $98, $88 ; Camper
	db $98, $88 ; Sage
	db $78, $88 ; Medium
	db $98, $88 ; Boarder
	db $98, $88 ; PokefanM
	db $B6, $89 ; DelinquentM
	db $69, $98 ; Twins
	db $6D, $78 ; PokefanF
	db $FD, $DE ; Red
	db $FD, $DE ; Blue
	db $98, $88 ; Officer
	db $7E, $A8 ; Miner
	db $9B, $A8 ; Karpman
	db $46, $46 ; Arcade PC
	db $BA, $89 ; Lily
	db $9A, $BA ; Lois
	db $9B, $8A ; Sparky
	db $FD, $DE ; Gold
	db $B6, $DB ; Giovanni
	db $B9, $A8 ; Ernest
	db $FD, $DE ; Kris
	db $78, $8A ; Kimono Girl
	db $98, $8A ; Bugsy
	db $98, $98 ; Whitney
	db $99, $6B ; Sabrina
	db $FF, $FF ; Candela
	db $FF, $FF ; Blanche
	db $FF, $FF ; Spark
	db $FD, $DE ; Brown
	db $96, $A9 ; GuitaristF
; 2715c
