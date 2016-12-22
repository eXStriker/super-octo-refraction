RedCredits::
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld a, 10
	ld [MusicFade], a
	callba FadeOutPalettes
	xor a
	ld [VramState], a
	ld [hMapAnims], a
	callba RedCredits_PrepVideoData
	ld c, 8
	call DelayFrames
	call DisableSpriteUpdates
	ld a, SPAWN_RED
	ld [wSpawnAfterChampion], a
	ld a, [wStatusFlags]
	ld b, a
	jpba Credits
