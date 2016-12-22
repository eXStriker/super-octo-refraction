RunMapSetupScript::
	ld a, [hMapEntryMethod]
	and $f
	dec a
	ld c, a
	ld b, 0
	ld hl, MapSetupScripts
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp ReadMapSetupScript

MapSetupScripts:
	dw MapSetupScript_Warp        ; F1
	dw MapSetupScript_Continue    ; F2
	dw MapSetupScript_ReloadMap   ; F3
	dw MapSetupScript_Teleport    ; F4
	dw MapSetupScript_Door        ; F5
	dw MapSetupScript_Fall        ; F6
	dw MapSetupScript_Connection  ; F7
	dw MapSetupScript_LinkReturn  ; F8
	dw MapSetupScript_Train       ; F9
	dw MapSetupScript_Submenu     ; FA
	dw MapSetupScript_BadWarp     ; FB
	dw MapSetupScript_Fly         ; FC
	dw MapSetupScript_BattleTower ; FD

MapSetupScript_Teleport:
	mapsetup DelayClearingOldSprites
MapSetupScript_Fly:
	mapsetup FadeOutPalettes
	mapsetup JumpRoamMons
MapSetupScript_Warp:
	mapsetup DisableLCD
	mapsetup MapSetup_Sound_Off
	mapsetup LoadSpawnPoint
	mapsetup LoadMapAttributes
	mapsetup RunCallback_05_03
	mapsetup SpawnPlayer
	mapsetup RefreshPlayerCoords
	mapsetup GetCoordOfUpperLeftCorner
	mapsetup LoadBlockData
	mapsetup BufferScreen
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup LoadObjectsRunCallback_02
	mapsetup LoadMapPalettes
	mapsetup ForceUpdateCGBPalsIfMapSetupWarp
	mapsetup EnableLCD
	mapsetup SpawnInFacingDown
	mapsetup RefreshMapSprites
	mapsetup PlayMapMusic
	mapsetup FadeInMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData
	mapsetup_end

MapSetupScript_BattleTower:
	mapsetup FadeOutPalettes
	mapsetup DisableLCD
	mapsetup LoadSpawnPoint
	mapsetup LoadMapAttributes
	mapsetup RunCallback_05_03
	mapsetup SpawnPlayer
	mapsetup RefreshPlayerCoords
	mapsetup GetCoordOfUpperLeftCorner
	mapsetup LoadBlockData
	mapsetup BufferScreen
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup FadeOldMapMusic
	mapsetup LoadObjectsRunCallback_02
	mapsetup EnableLCD
	mapsetup LoadMapPalettes
	mapsetup SpawnInFacingDown
	mapsetup RefreshMapSprites
	mapsetup FadeToMapMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData
	mapsetup_end

MapSetupScript_BadWarp:
	mapsetup LoadSpawnPoint
	mapsetup LoadMapAttributes
	mapsetup RunCallback_05_03
	mapsetup SpawnPlayer
	mapsetup RefreshPlayerCoords
	mapsetup GetCoordOfUpperLeftCorner
	mapsetup LoadBlockData
	mapsetup BufferScreen
	mapsetup DisableLCD
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup FadeOldMapMusic
	mapsetup EnableLCD
	mapsetup LoadObjectsRunCallback_02
	mapsetup LoadMapPalettes
	mapsetup SpawnInFacingDown
	mapsetup RefreshMapSprites
	mapsetup FadeToMapMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData
	mapsetup_end

MapSetupScript_Connection:
	mapsetup SuspendMapAnims
	mapsetup EnterMapConnection
	mapsetup LoadMapAttributes
	mapsetup RunCallback_05_03
	mapsetup RefreshPlayerCoords
	mapsetup LoadBlockData
	mapsetup LoadTilesetHeader
	mapsetup SaveScreen
	mapsetup LoadObjectsRunCallback_02
	mapsetup FadeToMapMusic
	mapsetup LoadMapPalettes
	mapsetup QueueLandmarkSignAnim
	mapsetup _UpdateTimePals
	mapsetup LoadWildMonData
	mapsetup UpdateRoamMons
	mapsetup ActivateMapAnims
	mapsetup_end

MapSetupScript_Fall:
	mapsetup DelayClearingOldSprites
MapSetupScript_Door:
	mapsetup FadeOutPalettes
MapSetupScript_Train:
	mapsetup LoadWarpData
	mapsetup LoadMapAttributes
	mapsetup RestoreFacingAfterWarp
	mapsetup RunCallback_05_03
	mapsetup RefreshPlayerCoords
	mapsetup LoadBlockData
	mapsetup BufferScreen
	mapsetup DisableLCD
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup FadeOldMapMusic
	mapsetup EnableLCD
	mapsetup LoadObjectsRunCallback_02
	mapsetup LoadMapPalettes
	mapsetup RefreshMapSprites
	mapsetup FadeToMapMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData
	mapsetup UpdateRoamMons
	mapsetup_end

MapSetupScript_ReloadMap: ; 153e7
	mapsetup FadeInPalsMapAndMusic
	mapsetup ClearBGPalettes
	mapsetup DisableLCD
	mapsetup MapSetup_Sound_Off
	mapsetup LoadBlockData
	mapsetup LoadNeighboringBlockData
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup EnableLCD
	mapsetup LoadMapPalettes
	mapsetup RefreshMapSprites
	mapsetup ForceMapMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData_KeepFlutes
	mapsetup CancelMapSign
	mapsetup_end

MapSetupScript_LinkReturn:
	mapsetup FadeInPalsMapAndMusic
	mapsetup DisableLCD
	mapsetup MapSetup_Sound_Off
	mapsetup RunCallback_05_03
	mapsetup LoadBlockData
	mapsetup BufferScreen
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup EnableLCD
	mapsetup LoadMapPalettes
	mapsetup RefreshMapSprites
	mapsetup EnterMapMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData
	mapsetup DontScrollText
	mapsetup_end

MapSetupScript_Continue:
	mapsetup DisableLCD
	mapsetup MapSetup_Sound_Off
	mapsetup LoadMapAttributes_SkipPeople
	mapsetup GetCoordOfUpperLeftCorner
	mapsetup RunCallback_03
	mapsetup LoadBlockData
	mapsetup LoadNeighboringBlockData
	mapsetup BufferScreen
	mapsetup LoadGraphics
	mapsetup LoadMetatilesTilecoll
	mapsetup LoadMapTimeOfDay
	mapsetup EnableLCD
	mapsetup LoadMapPalettes
	mapsetup RefreshMapSprites
	mapsetup EnterMapMusic
	mapsetup FadeInPalettes
	mapsetup ActivateMapAnims
	mapsetup LoadWildMonData
	mapsetup_end

MapSetupScript_Submenu:
	mapsetup LoadBlockData
	mapsetup LoadNeighboringBlockData
	mapsetup_end

ReadMapSetupScript:
	jr .handleLoop
.loop
	push hl
	ld c, a
	ld b, 0
	ld hl, MapSetupCommands
	add hl, bc
	add hl, bc
	add hl, bc
	call FarPointerCall
	pop hl
.handleLoop
	ld a, [hli]
	cp -1
	jr nz, .loop
	ret

MapSetupCommands:
	mapsetupcommand EnableLCD ; 00
	mapsetupcommand DisableLCD ; 01
	mapsetupcommand MapSetup_Sound_Off ; 02
	mapsetupcommand PlayMapMusic ; 03
	mapsetupcommand RestartMapMusic ; 04
	mapsetupcommand FadeToMapMusic ; 05
	mapsetupcommand FadeInPalsMapAndMusic ; 06
	mapsetupcommand EnterMapMusic ; 07
	mapsetupcommand ForceMapMusic ; 08
	mapsetupcommand FadeInMusic ; 09
	mapsetupcommand LoadBlockData ; 0a
	mapsetupcommand LoadNeighboringBlockData ; 0b
	mapsetupcommand SaveScreen ; 0c
	mapsetupcommand BufferScreen ; 0d
	mapsetupcommand LoadGraphics ; 0e
	mapsetupcommand LoadTilesetHeader ; 0f
	mapsetupcommand LoadMapTimeOfDay ; 10
	mapsetupcommand LoadMapPalettes ; 11
	mapsetupcommand LoadWildMonData ; 12
	mapsetupcommand RefreshMapSprites ; 13
	mapsetupcommand RunCallback_05_03 ; 14
	mapsetupcommand RunCallback_03 ; 15
	mapsetupcommand LoadObjectsRunCallback_02 ; 16
	mapsetupcommand LoadSpawnPoint ; 17
	mapsetupcommand EnterMapConnection ; 18
	mapsetupcommand LoadWarpData ; 19
	mapsetupcommand LoadMapAttributes ; 1a
	mapsetupcommand LoadMapAttributes_SkipPeople ; 1b
	mapsetupcommand ClearBGPalettes ; 1c
	mapsetupcommand FadeOutPalettes ; 1d
	mapsetupcommand FadeInPalettes ; 1e
	mapsetupcommand GetCoordOfUpperLeftCorner ; 1f
	mapsetupcommand RestoreFacingAfterWarp ; 20
	mapsetupcommand SpawnInFacingDown ; 21
	mapsetupcommand SpawnPlayer ; 22
	mapsetupcommand RefreshPlayerCoords ; 23
	mapsetupcommand DelayClearingOldSprites ; 24
	mapsetupcommand DelayLoadingNewSprites ; 25
	mapsetupcommand UpdateRoamMons ; 26
	mapsetupcommand JumpRoamMons ; 27
	mapsetupcommand FadeOldMapMusic ; 28
	mapsetupcommand ActivateMapAnims ; 29
	mapsetupcommand SuspendMapAnims ; 2a
	mapsetupcommand _UpdateTimePals ; 2b
	mapsetupcommand DontScrollText ; 2c
	mapsetupcommand QueueLandmarkSignAnim ; 2d
	mapsetupcommand LoadWildMonData_KeepFlutes ; 2e
	mapsetupcommand CancelMapSign ; 2f
	mapsetupcommand ForceUpdateCGBPalsIfMapSetupWarp ; lol
	mapsetupcommand LoadMetatilesTilecoll ; 30

DontScrollText:
	xor a
	ld [wLinkSuppressTextScroll], a
	ret

ActivateMapAnims:
	ld a, $1
	ld [hMapAnims], a
	ret

SuspendMapAnims:
	xor a
	ld [hMapAnims], a
	ret

LoadObjectsRunCallback_02:
	ld a, MAPCALLBACK_OBJECTS
	call RunMapCallback
	callba LoadObjectMasks
	jpba InitializeVisibleSprites

DelayClearingOldSprites:
	ld hl, wPlayerSpriteSetupFlags
	set 7, [hl]
	ret

DelayLoadingNewSprites:
	ld hl, wPlayerSpriteSetupFlags
	set 6, [hl]
	ret

CheckReplaceKrisSprite:
	nop
	call .CheckBiking
	jr c, .ok
	call .CheckSurfing
	jr c, .ok
	call .CheckResetPlayerState
	ret nc

.ok
	jp ReplaceKrisSprite

.CheckBiking
	and a
	ld hl, wBikeFlags
	bit 1, [hl]
	ret z
	ld a, PLAYER_BIKE
	ld [PlayerState], a
	scf
	ret

.CheckResetPlayerState
	ld a, [PlayerState]
	and a ; PLAYER_NORMAL
	jr z, .nope
	rrca ; PLAYER_BIKE
	jr c, .biking
	rrca ; PLAYER_SLIP
	jr nc, .reset
.nope
	and a
	ret

.biking
	call GetMapPermission
	cp INDOOR
	jr z, .reset
	cp PERM_5
	jr z, .reset
	cp DUNGEON
	jr z, .reset
	call GetCurMapTileset
	cp TILESET_SIDESCROLL
	jr nz, .nope
.reset
	xor a ; PLAYER_NORMAL
	ld [PlayerState], a
	scf
	ret

.CheckSurfing
	call CheckOnWater
	jr nz, .ret_nc
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, ._surfing
	cp PLAYER_SURF_PIKA
	jr z, ._surfing
	ld a, PLAYER_SURF
	ld [PlayerState], a
._surfing
	scf
	ret

.ret_nc
	and a
	ret

FadeOldMapMusic:
	ld a, 6
	jp SkipMusic

FadeInPalsMapAndMusic:
	xor a
	ld [MusicFadeIDLo], a
	ld [MusicFadeIDHi], a
	ld a, $4
	ld [MusicFade], a
	ld c, 1 << 7 | 2
	jp FadeToLightestColor

ForceMapMusic:
	ld a, [PlayerState]
	cp PLAYER_BIKE
	jr nz, .notbiking
	call VolumeOff
	ld a, $88
	ld [MusicFade], a
.notbiking
	jp TryRestartMapMusic
