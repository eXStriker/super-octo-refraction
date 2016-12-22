LoadPushOAM:: ; 4031
	ld hl, PushOAMCode
	lb bc, (PushOAMCodeEnd - PushOAMCode), hPushOAM & $ff
.loop
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop
	ret

PushOAMCode: ; 403f
	ld [$ff00+c], a
.loop
	dec b
	jr nz, .loop
	ret
PushOAMCodeEnd: