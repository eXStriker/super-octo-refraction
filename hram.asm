HRAM_START         EQU $ff80
hPushOAM           EQU $ff80

hScriptVar         EQU $ff85
hScriptHalfwordVar EQU $ff86
; $ff88-ff89 available

hROMBankBackup     EQU $ff8a
hBuffer            EQU $ff8b
hLYOverrideStackCopyAmount  EQU $ff8c

hRTCDayHi          EQU $ff8d
hRTCDayLo          EQU $ff8e
hRTCHours          EQU $ff8f
hRTCMinutes        EQU $ff90
hRTCSeconds        EQU $ff91

hRTC               EQU $ff94
hHours             EQU $ff94
hMinutes           EQU $ff96
hSeconds           EQU $ff98
hRTCEnd            EQU $ff9a

hVBlankCounter     EQU $ff9b

hROMBank           EQU $ff9d
hVBlank            EQU $ff9e
hMapEntryMethod    EQU $ff9f
hMenuReturn        EQU $ffa0

hJoypadReleased    EQU $ffa2
hJoypadPressed     EQU $ffa3
hJoypadDown        EQU $ffa4
hJoypadSum         EQU $ffa5
hJoyReleased       EQU $ffa6
hJoyPressed        EQU $ffa7
hJoyDown           EQU $ffa8
hJoyLast           EQU $ffa9
hInMenu            EQU $ffaa

hDigitsFlags       EQU $ffab
hScriptBuffer      EQU $ffab

hPrinter                    EQU $ffac
hGraphicStartTile           EQU $ffad
hMoveMon                    EQU $ffae
hMapObjectIndexBuffer       EQU $ffaf
hObjectStructIndexBuffer    EQU $ffb0

hConnectionStripLength      EQU $ffaf
hConnectedMapWidth          EQU $ffb0

hMapBorderBlock             EQU $ffad
hMapWidthPlus6              EQU $ffae

hPredefTemp        EQU $ffb1

; can only use the bytes reserved for hPredefTemp in contained functions, unless you know what you're doing

hBuffer2           EQU $ffb1
hBuffer3           EQU $ffb2

hLZAddress         EQU $ffb1

hMonToStore        EQU $ffb1
hMonToCopy         EQU $ffb2

hPastLeadingZeroes EQU $ffb3

hDividend          EQU $ffb3 ; length in b register, before 'predef Divide' (max 4 bytes)
hDivisor           EQU $ffb7 ; 1 byte long
hQuotient          EQU $ffb4 ; result (3 bytes long)
hRemainder         EQU $ffb7 ; 1 byte long after Divide, 2 bytes long after Divide16

hLongQuotient      EQU $ffb3 ; 4-byte result

hMultiplicand      EQU $ffb4 ; 3 bytes long
hMultiplier        EQU $ffb7 ; 1 byte long
hProduct           EQU $ffb3 ; result (4 bytes long)

hMathBuffer        EQU $ffb9

hMetatileCountWidth    EQU $ffb3
hMetatileCountHeight   EQU $ffb4

hCrashRST          EQU $ffb3
hCurBitStream      EQU $ffb4
hCurSampVal        EQU $ffb5

hPalTrick          EQU $ffb3

hPrintNum1         EQU $ffb3
hPrintNum2         EQU $ffb4
hPrintNum3         EQU $ffb5
hPrintNum4         EQU $ffb6
hPrintNum5         EQU $ffb7
hPrintNum6         EQU $ffb8
hPrintNum7         EQU $ffb9
hPrintNum8         EQU $ffba
hPrintNum9         EQU $ffbb
hPrintNum10        EQU $ffbc

hOriginBank        EQU $ffb9
hDestinationBank   EQU $ffba

hUsedSpriteIndex   EQU $ffbd
hUsedSpriteTile    EQU $ffbe

hCurSpriteXCoord   EQU $ffbd
hCurSpriteYCoord   EQU $ffbe

hCurSpriteXPixel   EQU $ffbf
hCurSpriteYPixel   EQU $ffc0
hCurSpriteTile     EQU $ffc1
hCurSpriteOAMFlags EQU $ffc2

hLoopCounter       EQU $ffbf
hMoneyTemp         EQU $ffc3

hCompressedTextBank    EQU $ffc6

hLYOverridesStart              EQU $ffc7
hLYOverridesEnd              EQU $ffc8
hTemp              EQU $ffc9
hFFCA              EQU $ffca
hLinkPlayerNumber  EQU $ffcb
hFFCC              EQU $ffcc
hSerialSend        EQU $ffcd
hSerialReceive     EQU $ffce

hSCX               EQU $ffcf
hSCY               EQU $ffd0
hWX                EQU $ffd1
hWY                EQU $ffd2
hTilesPerCycle     EQU $ffd3
hBGMapMode         EQU $ffd4
hBGMapHalf         EQU $ffd5
hBGMapAddress      EQU $ffd6

hOAMUpdate         EQU $ffd8
hSPBuffer          EQU $ffd9

hBGMapUpdate       EQU $ffdb
hBGMapTileCount    EQU $ffdc

hMapAnims          EQU $ffde
hTileAnimFrame     EQU $ffdf

hLastTalked        EQU $ffe0

hRandom            EQU $ffe1
hRandomAdd         EQU $ffe1
hRandomSub         EQU $ffe2
hSecondsBackup     EQU $ffe3
hBattleTurn        EQU $ffe4 ; Which trainer's turn is it? 0: Player, 1: Opponent Trainer
hCGBPalUpdate      EQU $ffe5
hCGB               EQU $ffe6
hDMATransfer       EQU $ffe8
hFarCallSavedA     EQU $ffe9
hFFEA              EQU $ffea
hClockResetTrigger EQU $ffeb

hIETmp             EQU $fff0

hRequested2bpp         EQU $fff1
hRequested1bpp         EQU $fff2
hRequestedVTileDest    EQU $fff3
hRequestedVTileSource  EQU $fff5
; fff7

hDEDCryFlag            EQU $fff8
hRunPicAnim            EQU $fff9
hVBlankSavedA          EQU $fffc
hCrashSavedHL          EQU $fffd
hCrashSP               EQU $fffd
hCrashSavedErrorCode   EQU $fffd
hCrashSavedA           EQU $fffe
HRAM_END EQU $ffff
