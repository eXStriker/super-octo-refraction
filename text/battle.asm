BattleText::

BattleText_PlayerPickedUpPayDayMoney:
	ctxt "<PLAYER> picked up"
	line "¥@"
	deciram wPayDayMoney, 3, 6
	text "!"
	prompt

WildPokemonAppearedText:
	ctxt "Wild <EMON>"
	line "appeared!"
	prompt

HookedPokemonAttackedText:
	ctxt "The hooked"
	line "<EMON>"
	cont "attacked!"
	prompt

PokemonFellFromTreeText:
	ctxt "<EMON> fell"
	line "out of the tree!"
	prompt

WantsToBattleText::
	ctxt "<ENEMY>"
	line "wants to battle!"
	prompt

BattleText_WildFled:
	ctxt "Wild <EMON>"
	line "fled!"
	prompt

BattleText_EnemyFled:
	ctxt "Enemy <EMON>"
	line "fled!"
	prompt

HurtByPoisonText:
	ctxt "<USER>"
	line "is hurt by poison!"
	prompt

PoisonHealText:
	ctxt "<USER>"
	line "recovered with"
	cont "Poison Heal!"
	prompt

HurtByBurnText:
	ctxt "<USER>'s"
	line "hurt by its burn!"
	prompt

LeechSeedSapsText:
	ctxt "Leech Seed saps"
	line "<USER>!"
	prompt

LiquidOozeHurtsText:
	ctxt "Leech Seed saps"
	line "<USER>'s"
	cont "Liquid Ooze!"
	prompt

HasANightmareText:
	ctxt "<USER>"
	line "has a Nightmare!"
	prompt

HurtByCurseText:
	ctxt "<USER>'s"
	line "hurt by the Curse!"
	prompt

SandstormHitsText:
	ctxt "The Sandstorm hits"
	line "<USER>!"
	prompt

HailHitsText:
	ctxt "The Hail bombards"
	line "<USER>!"
	prompt

PerishCountText:
	ctxt "<USER>'s"
	line "Perish count is @"
	deciram wd265, 1, 1
	ctxt "!"
	prompt

FinalChanceText:
	ctxt "<USER>"
	line "has @"
	deciram wd265, 1, 1
	ctxt " turns left!"
	prompt

BattleText_TargetRecoveredWithItem:
	ctxt "<TARGET>"
	line "recovered with"
	cont "<STRBF1>."
	prompt

BattleText_UserRecoveredPPUsing:
	ctxt "<USER>"
	line "recovered PP using"
	cont "<STRBF1>."
	prompt

BattleText_TargetWasHitByFutureSight:
	ctxt "<TARGET>"
	line "was hit by Future"
	cont "Sight!"
	prompt

BattleText_SafeguardFaded:
	ctxt "<USER>'s"
	line "Safeguard faded!"
	prompt

BattleText_PkmnLightScreenFell:
	ctxt "<STRBF1> #mon's"
	line "Light Screen fell!"
	prompt

BattleText_PkmnReflectFaded:
	ctxt "<STRBF1> #mon's"
	line "Reflect faded!"
	prompt

BattleText_RainContinuesToFall:
	ctxt "Rain continues to"
	line "fall."
	prompt

BattleText_TheSunlightIsStrong:
	ctxt "The sunlight is"
	line "strong."
	prompt

BattleText_TheSandstormRages:
	ctxt "The sandstorm"
	line "rages."
	prompt

BattleText_HailContinuesToFall:
	ctxt "Hail continues to"
	line "fall."
	prompt

BattleText_TheRainStopped:
	ctxt "The rain stopped."
	prompt

BattleText_TheSunlightFaded:
	ctxt "The sunlight"
	line "faded."
	prompt

BattleText_TheSandstormSubsided:
	ctxt "The sandstorm"
	line "subsided."
	prompt

BattleText_TheHailStopped:
	ctxt "The hail stopped."
	prompt


BattleText_WildPkmnFainted:
	ctxt "Wild <EMON>"
	line "fainted!"
	prompt


BattleText_EnemyPkmnFainted:
	ctxt "Enemy <EMON>"
	line "fainted!"
	prompt

GotMoneyForWinningText:
	ctxt "<PLAYER> got ¥@"
	deciram wBattleReward, 3, 6
	ctxt ""
	line "for winning!"
	prompt

BattleText_EnemyWasDefeated:
	ctxt "<ENEMY>"
	line "was defeated!"
	prompt

TiedAgainstText:
	ctxt "Tied against"
	line "<ENEMY>!"
	prompt

SentSomeToMomText:
	ctxt "<PLAYER> got ¥@"
	deciram wBattleReward, 3, 6
	ctxt ""
	line "for winning!"
	cont "Sent some to the"
	cont "bank!"
	prompt

SentHalfToMomText:
	ctxt "Sent half to the"
	line "bank!"
	prompt

SentAllToMomText:
	ctxt "Sent all to the"
	line "bank!"
	prompt

BattleText_0x80a4f:
	ctxt "<RIVAL>: Huh? I"
	line "should've chosen"
	cont "your #mon!"
	prompt

BattleText_PkmnFainted:
	ctxt "<BMON>"
	line "fainted!"
	prompt

BattleText_UseNextMon:
	ctxt "Use next #mon?"
	done

BattleText_0x80a93:
	ctxt "<RIVAL>: Yes!"
	line "I guess I chose a"
	cont "good #mon!"
	prompt

LostAgainstText:
	ctxt "Lost against"
	line "<ENEMY>!"
	prompt

BattleText_EnemyIsAboutToUseWillPlayerChangePkmn:
	ctxt "<ENEMY>"
	line "is about to use"
	cont "<EMON>."

	para "Will <PLAYER>"
	line "change #mon?"
	done

BattleText_EnemySentOut:
	ctxt "<ENEMY>"
	line "sent out"
	cont "<EMON>!"
	done

BattleText_TheresNoWillToBattle:
	ctxt "There's no will"
	line "to battle!"
	prompt

BattleText_AnEGGCantBattle:
	ctxt "An egg can't"
	line "battle!"
	prompt

BattleText_TheresNoEscapeFromTrainerBattle:
	ctxt "No! There's no"
	line "running from a"
	cont "trainer battle!"
	prompt

BattleText_GotAwaySafely:
	ctxt "Got away safely!"
	prompt

BattleText_UserFledUsingItsStringBuffer1:
	ctxt "<USER>"
	line "fled using its"
	cont "<STRBF1>!"
	prompt

BattleText_CantEscape:
	ctxt "Can't escape!"
	prompt

BattleText_UserHurtBySpikes:
	ctxt "<USER>'s"
	line "hurt by Spikes!"
	prompt

RecoveredUsingText:
	ctxt "<TARGET>"
	line "recovered using a"
	cont "<STRBF1>!"
	prompt

RecoveredUsingText2:
	ctxt "<TARGET>"
	line "recovered using an"
	cont "<STRBF1>!"
	prompt

BattleText_BattleCantFightEagulou::
	ctxt "You can't fight"
	line "in Eagulou Park!"
	prompt

BattleText_UsersStringBuffer1Activated:
	ctxt "<USER>'s"
	line "<STRBF1>"
	cont "activated!"
	prompt

BattleText_ItemsCantBeUsedHere:
	ctxt "Items can't be"
	line "used here."
	prompt

BattleText_PkmnIsAlreadyOut:
	ctxt "<BMON>"
	line "is already out."
	prompt

BattleText_PkmnCantBeRecalled:
	ctxt "<BMON>"
	line "can't be recalled!"
	prompt

BattleText_TheresNoPPLeftForThisMove:
	ctxt "There's no PP left"
	line "for this move!"
	prompt

BattleText_TheMoveIsDisabled:
	ctxt "The move is"
	line "disabled!"
	prompt

BattleText_PkmnHasNoMovesLeft:
	ctxt "<BMON>"
	line "has no moves left!"
	done

BattleText_TargetsEncoreEnded:
	ctxt "<TARGET>'s"
	line "Encore ended!"
	prompt

BattleText_StringBuffer1GrewToLevel:
	ctxt "<STRBF1> grew to"
	line "level @"
	deciram CurPartyLevel, 1, 3
	ctxt "!"
	done

FastAsleepText:
	ctxt "<USER>"
	line "is fast asleep!"
	prompt

WokeUpText:
	ctxt "<USER>"
	line "woke up!"
	prompt

AllWokeUpText:
	ctxt "All sleeping"
	line "#mon woke up!"
	prompt

FrozenSolidText:
	ctxt "<USER>"
	line "is frozen solid!"
	prompt

FlinchedText:
	ctxt "<USER>"
	line "flinched!"
	prompt

MustRechargeText:
	ctxt "<USER>"
	line "must recharge!"
	prompt

DisabledNoMoreText:
	ctxt "<USER>'s"
	line "disabled no more!"
	prompt

IsConfusedText:
	ctxt "<USER>"
	line "is confused!"
	prompt

HurtItselfText:
	ctxt "It hurt itself in"
	line "its confusion!"
	prompt

ConfusedNoMoreText:
	ctxt "<USER>'s"
	line "confused no more!"
	prompt

AllConfusedNoMoreText:
	ctxt "All #mon are no"
	line "longer confused!"
	prompt

BecameConfusedText:
	ctxt "<TARGET>"
	line "became confused!"
	prompt

BattleText_ItemHealedConfusion:
	ctxt "A <STRBF1> rid"
	line "<TARGET>"
	cont "of its confusion."
	prompt

AlreadyConfusedText:
	ctxt "<TARGET>'s"
	line "already confused!"
	prompt

BattleText_UsersHurtByStringBuffer1:
	ctxt "<USER>'s"
	line "hurt by"
	cont "<STRBF1>!"
	prompt

BattleText_UserWasReleasedFromStringBuffer1:
	ctxt "<USER>"
	line "was released from"
	cont "<STRBF1>!"
	prompt

UsedBindText:
	ctxt "<USER>"
	line "used Bind on"
	cont "<TARGET>!"
	prompt

WasTrappedText:
	ctxt "<TARGET>"
	line "was trapped!"
	prompt

WrappedByText:
	ctxt "<TARGET>"
	line "was wrapped by"
	cont "<USER>!"
	prompt

HungOnText:
	ctxt "<TARGET>"
	line "hung on with"
	cont "<STRBF1>!"
	prompt

EnduredText:
	ctxt "<TARGET>"
	line "endured the hit!"
	prompt

InLoveWithText:
	ctxt "<USER>"
	line "is in love with"
	cont "<TARGET>!"
	prompt

InfatuationText:
	ctxt "<USER>'s"
	line "infatuation kept"
	cont "it from attacking!"
	prompt

CameToSensesText:
	ctxt "<USER> came to"
	line "its senses!"
	prompt

AllCameToSensesText:
	ctxt "All #mon came"
	line "to their senses!"
	prompt

DisabledMoveText:
	ctxt "<USER>'s"
	line "<STRBF1> is"
	cont "disabled!"
	prompt

LoafingAroundText:
	ctxt "<USER>"
	line "is loafing around."
	prompt

BeganToNapText:
	ctxt "<BMON> began"
	line "to nap!"
	prompt

WontObeyText:
	ctxt "<BMON> won't"
	line "obey!"
	prompt

TurnedAwayText:
	ctxt "<BMON> turned"
	line "away!"
	prompt

IgnoredOrdersText:
	ctxt "<BMON> ignored"
	line "orders!"
	prompt

IgnoredSleepingText:
	ctxt "<BMON> ignored"
	line "orders<...> sleeping!"
	prompt

NoPPLeftText:
	ctxt "But no PP is left"
	line "for the move!"
	prompt

HasNoPPLeftText:
	ctxt "<USER>"
	line "has no PP left for"
	cont "<STRBF2>!"
	prompt

WentToSleepText:
	ctxt "<USER>"
	line "went to sleep!"
	done

RestedText:
	ctxt "<USER>"
	line "fell asleep and"
	cont "became healthy!"
	done

RegainedHealthText:
	ctxt "<USER>"
	line "regained health!"
	prompt

AttackMissedText:
	ctxt "<USER>'s"
	line "attack missed!"
	prompt

CrashedText:
	ctxt "<USER>"
	line "kept going and"
	cont "crashed!"
	prompt

UnaffectedText:
	ctxt "<TARGET>'s"
	line "unaffected!"
	prompt

DoesntAffectText:
	ctxt "It doesn't affect"
	line "<TARGET>!"
	prompt

CriticalHitText:
	ctxt "A critical hit!"
	prompt

SuperEffectiveText:
	ctxt "It's super-"
	line "effective!"
	prompt

NotVeryEffectiveText:
	ctxt "It's not very"
	line "effective<...>"
	prompt

TookDownWithItText:
	ctxt "<TARGET>"
	line "took down with it,"
	cont "<USER>!"
	prompt

RageBuildingText:
	ctxt "<USER>'s"
	line "rage is building!"
	prompt

GotAnEncoreText:
	ctxt "<TARGET>"
	line "got an encore!"
	prompt

SharedPainText:
	ctxt "The battlers"
	line "shared pain!"
	prompt

TookAimText:
	ctxt "<USER>"
	line "took aim!"
	prompt

DestinyBondEffectText:
	ctxt "<USER>'s"
	line "trying to take its"
	cont "opponent with it!"
	prompt

SpiteEffectText:
	ctxt "<TARGET>'s"
	line "<STRBF1> was"
	cont "reduced by @"
	deciram wd265, 1, 1
	text "!"
	prompt

BellChimedText:
	ctxt "A bell chimed!"
	prompt

FellAsleepText:
	ctxt "<TARGET>"
	line "fell asleep!"
	prompt

AbilitySleepText:
	ctxt "<USER>'s"
	line "<STRBF1>"
	cont "caused"
	cont "<TARGET>"
	cont "to fall asleep!"
	prompt

AlreadyAsleepText:
	ctxt "<TARGET>'s"
	line "already asleep!"
	prompt

WasPoisonedText:
	ctxt "<TARGET>"
	line "was poisoned!"
	prompt

AbilityPoisonText:
	ctxt "<TARGET>'s"
	line "poisoned by"
	cont "<STRBF1>!"
	prompt

BadlyPoisonedText:
	ctxt "<TARGET>'s"
	line "badly poisoned!"
	prompt

AlreadyPoisonedText:
	ctxt "<TARGET>'s"
	line "already poisoned!"
	prompt

SuckedHealthText:
	ctxt "Sucked health from"
	line "<TARGET>!"
	prompt

DreamEatenText:
	ctxt "<TARGET>'s"
	line "dream was eaten!"
	prompt

WasBurnedText:
	ctxt "<TARGET>"
	line "was burned!"
	prompt

FlameBodyBurnedText:
	ctxt "<USER>'s"
	line "Flame Body burned"
	cont "<TARGET>!"
	prompt

DefrostedOpponentText:
	ctxt "<TARGET>"
	line "was defrosted!"
	prompt

MagmaArmorThawText:
	ctxt "<USER>"
	line "thawed due to"
	cont "Magma Armor!"
	prompt

AlreadyBurnedText:
	ctxt "<TARGET>'s"
	line "already burned!"
	prompt

WasFrozenText:
	ctxt "<TARGET>"
	line "was frozen solid!"
	prompt

WontRiseAnymoreText:
	ctxt "<USER>'s"
	line "<STRBF2> won't"
	cont "rise anymore!"
	prompt

WontDropAnymoreText:
	ctxt "<TARGET>'s"
	line "<STRBF2> won't"
	cont "drop anymore!"
	prompt

FledFromBattleText::
	ctxt "<USER>"
	line "fled from battle!"
	prompt

FledInFearText:
	ctxt "<TARGET>"
	line "fled in fear!"
	prompt

BlownAwayText:
	ctxt "<TARGET>"
	line "was blown away!"
	prompt

PlayerHitTimesText:
	ctxt "Hit @"
	deciram PlayerDamageTaken, 1, 1
	ctxt " times!"
	prompt

EnemyHitTimesText:
	ctxt "Hit @"
	deciram EnemyDamageTaken, 1, 1
	ctxt " times!"
	prompt

MistText:
	ctxt "<USER>'s"
	line "shrouded in mist!"
	prompt

ProtectedByMistText:
	ctxt "<TARGET>'s"
	line "protected by mist."
	prompt

GettingPumpedText:
	ctxt "<USER>'s"
	line "getting pumped!"
	prompt

RecoilText:
	ctxt "<USER>'s"
	line "hit with recoil!"
	prompt

MadeSubstituteText:
	ctxt "<USER>"
	line "made a substitute!"
	prompt

HasSubstituteText:
	ctxt "<USER>"
	line "has a substitute!"
	prompt

TooWeakSubText:
	ctxt "Too weak to make"
	line "a substitute!"
	prompt

SubTookDamageText:
	ctxt "The substitute"
	line "took damage for"
	cont "<TARGET>!"
	prompt

SubFadedText:
	ctxt "<TARGET>'s"
	line "substitute faded!"
	prompt

LearnedMoveText:
	ctxt "<USER>"
	line "learned"
	cont "<STRBF1>!"
	prompt

WasSeededText:
	ctxt "<TARGET>"
	line "was seeded!"
	prompt

EndNightmaresLeechSeedText:
	ctxt "Nightmares and"
	line "seeds have been"
	cont "eliminated!"
	prompt

EvadedText:
	ctxt "<TARGET>"
	line "evaded the attack!"
	prompt

WasDisabledText:
	ctxt "<TARGET>'s"
	line "<STRBF1> was"
	cont "disabled!"
	prompt

EndWallsText:
	ctxt "All barriers"
	line "have vanished!"
	prompt

TransformedTypeText:
	ctxt "<USER>"
	line "transformed into"
	cont "the <STRBF1>-type!"
	prompt

EliminatedStatsText:
	ctxt "All stat changes"
	line "were eliminated!"
	prompt

TransformedText:
	ctxt "<USER>"
	line "transformed into"
	cont "<STRBF1>!"
	prompt

LightScreenEffectText:
	ctxt "<USER>'s"
	line "Spcl.Def rose!"
	prompt

ReflectEffectText:
	ctxt "<USER>'s"
	line "Defense rose!"
	prompt

NothingHappenedText:
	ctxt "But nothing"
	line "happened."
	prompt

ButItFailedText:
	ctxt "But it failed!"
	prompt

ItFailedText:
	ctxt "It failed!"
	prompt

DidntAffect1Text:
	ctxt "It didn't affect"
	line "<TARGET>!"
	prompt

HPIsFullText:
	ctxt "<USER>'s"
	line "HP is full!"
	prompt

DraggedOutText:
	ctxt "<USER>"
	line "was dragged out!"
	prompt

ParalyzedText:
	ctxt "<TARGET>'s"
	line "paralyzed! Maybe"
	cont "it can't attack!"
	prompt

PrzAbilityText:
	ctxt "<USER>'s"
	line "<STRBF1>"
	cont "paralyzed"
	cont "<TARGET>!"
	para "Maybe it can't"
	line "attack!"
	prompt

FullyParalyzedText:
	ctxt "<USER>'s"
	line "fully paralyzed!"
	prompt

AlreadyParalyzedText:
	ctxt "<TARGET>'s"
	line "already paralyzed!"
	prompt

IsGuardingText:
	ctxt "<USER>'s"
	line "guarding itself!"
	prompt

ProtectedByText:
	ctxt "<TARGET>'s"
	line "protected by"
	cont "<STRBF1>!"
	prompt

MirrorMoveFailedText:
	ctxt "The Mirror Move"
	next "failed!"
	prompt

StoleText:
	ctxt "<USER>"
	line "stole <STRBF1>"
	cont "from its foe!"
	prompt

CantEscapeNowText:
	ctxt "<TARGET>"
	line "can't escape now!"
	prompt

StartedNightmareText:
	ctxt "<TARGET>"
	line "started to have a"
	cont "nightmare!"
	prompt

WasDefrostedText:
	ctxt "<USER>"
	line "was defrosted!"
	prompt

PutACurseText:
	ctxt "<USER>"
	line "cut its own HP and"

	para "put a curse on"
	line "<TARGET>!"
	prompt

ProtectedItselfText:
	ctxt "<USER>"
	line "protected itself!"
	prompt

ProtectingItselfText:
	ctxt "<TARGET>'s"
	line "protecting itself!"
	done

SpikesText:
	ctxt "Spikes scattered"
	line "all around"
	cont "<TARGET>!"
	prompt

IdentifiedText:
	ctxt "<USER>"
	line "identified"
	cont "<TARGET>!"
	prompt

StartPerishText:
	ctxt "Both #mon will"
	line "faint in 3 turns!"
	prompt

SandstormBrewedText:
	ctxt "A sandstorm"
	line "brewed!"
	prompt

StartedToHailText:
	ctxt "It started to"
	line "hail!"
	prompt

BracedItselfText:
	ctxt "<USER>"
	line "braced itself!"
	prompt

FellInLoveText:
	ctxt "<TARGET>"
	line "fell in love!"
	prompt

CuteCharmText:
	ctxt "<USER>'s"
	line "<STRBF1>"
	para "infatuated"
	line "<TARGET>!"
	prompt

CoveredByVeilText:
	ctxt "<USER>'s"
	line "covered by a veil!"
	prompt

SafeguardProtectText:
	ctxt "<TARGET>"
	line "is protected by"
	cont "Safeguard!"
	prompt

MagnitudeText:
	ctxt "Magnitude @"
	deciram wd265, 1, 1
	text "!"
	prompt

ReleasedByText:
	ctxt "<USER>"
	line "was released by"
	cont "<TARGET>!"
	prompt

ShedLeechSeedText:
	ctxt "<USER>"
	line "shed Leech Seed!"
	prompt

BlewSpikesText:
	ctxt "<USER>"
	line "blew away Spikes!"
	prompt

DownpourText:
	ctxt "A downpour"
	line "started!"
	prompt

SunGotBrightText:
	ctxt "The sunlight got"
	line "bright!"
	prompt

BellyDrumText:
	ctxt "<USER>"
	line "cut its HP and"
	cont "maximized Attack!"
	prompt

CopiedStatsText:
	ctxt "<USER>"
	line "copied the stat"

	para "changes of"
	line "<TARGET>!"
	prompt

ForesawAttackText:
	ctxt "<USER>"
	line "foresaw an attack!"
	prompt

BeatUpAttackText:
	ctxt "<STRBF1>'s"
	line "attack!"
	done

IgnoredOrders2Text:
	ctxt "<USER>"
	line "ignored orders!"
	prompt

BattleText_LinkErrorBattleCanceled:
	ctxt "Link error…"

	para "The battle has"
	line "been canceled…"
	prompt

StartFinalChanceText:
	ctxt "<USER>"
	line "took its"
	cont "Final Chance!"
	prompt

FinalChanceHealedText:
	ctxt "<USER>"
	line "was fully healed!"
	prompt

LavaPoolText:
	ctxt "Lava pooled around"
	line "<TARGET>!"
	prompt

BattleText_UserBurnedByLavaPool:
	ctxt "<USER>'s"
	line "burned by"
	cont "Lava Pool!"
	prompt

UserBecameTypeText:
	ctxt "<USER>"
	line "is now"
	cont "<STRBF1>-type!"
	prompt

TargetBecameTypeText:
	ctxt "<TARGET>"
	line "is now"
	cont "<STRBF1>-type!"
	prompt

UserBecameTypePartialText:
	ctxt "<USER>"
	line "is part"
	cont "<STRBF1>-type!"
	prompt

TargetBecameTypePartialText:
	ctxt "<TARGET>"
	line "is part"
	cont "<STRBF1>-type!"
	prompt

PrismSprayText:
	ctxt "It became the"
	line "<STRBF1>-type!"
	prompt

HealedWithShellBellText:
	ctxt "<USER>"
	line "restored health"
	cont "with Shell Bell!"
	prompt

NaturePowerText:
	ctxt "Nature Power"
	line "turned into"
	cont "<STRBF1>!"
	prompt

LiquidOozeText:
	ctxt "It was hurt by"
	line "<TARGET>'s"
	cont "Liquid Ooze!"
	prompt

AbilityPreventsStatDownsText:
	ctxt "<TARGET>'s"
	line "<STRBF1>"
	cont "prevents <STRBF2>"
	cont "drops!"
	prompt

DroughtText:
	ctxt "<USER>'s"
	line "Drought intensi-"
	cont "fied the sun's"
	cont "rays!"
	prompt

DrizzleText:
	ctxt "<USER>'s"
	line "Drizzle started"
	cont "a downpour!"
	prompt

SandStreamText:
	ctxt "<USER>'s"
	line "Sand Stream"
	cont "whipped up a"
	cont "sandstorm!"
	prompt

SnowWarningText:
	ctxt "<USER>'s"
	line "Snow Warning"
	cont "caused a hail-"
	cont "storm!"
	prompt

PressureText:
	ctxt "<USER>"
	line "is exerting its"
	cont "Pressure!"
	prompt

AbilityStatDropText:
	ctxt "<USER>'s"
	line "<STRBF1>"
	para "cuts the opponent's"
	line "<STRBF2>!"
	prompt

TraceText:
	ctxt "<USER>"
	line "traced"
	para "<TARGET>'s"
	line "<STRBF1>!"
	prompt

DownloadText:
	ctxt "<USER>'s"
	line "<STRBF1>!"
	prompt

ShedSkinText:
	ctxt "<USER>"
	line "recovered with"
	cont "Shed Skin!"
	prompt

AbilityCantSleepText:
	ctxt "<TARGET>'s"
	line "<STRBF1>"
	para "prevents sleep!"
	prompt

InnerFocusText:
	ctxt "<USER>"
	line "won't flinch"
	para "because of its"
	line "Inner Focus!"
	prompt

IceBodyText:
	ctxt "<USER>'s"
	line "healed by"
	cont "Ice Body!"
	prompt

FlashFireText:
	ctxt "<TARGET>'s"
	line "Flash Fire"
	para "fuels its Fire-"
	line "type moves!"
	prompt

BreaksTheMoldText:
	ctxt "<USER>"
	line "breaks the mold!"
	prompt

FriskText:
	ctxt "<USER>"
	line "frisked its foe"

	para "and found one"
	line "<STRBF1>!"
	prompt

AbilityHurtText:
	ctxt "<USER>'s"
	line "hurt by"
	cont "<STRBF1>!"
	prompt

AbilityRestoreHPText:
	ctxt "<USER>'s"
	line "<STRBF1>"
	cont "restored HP!"
	prompt

AirLockText:
	ctxt "The effects of"
	line "weather vanished!"
	prompt

BattleText_ForfeitChallenge:
	ctxt "Forfeit the battle"
	line "and end your chal-"
	cont "lenge?"
	done

BattleText_NoSwitchFinalChance:
	ctxt "You can't switch"
	line "out while under"
	cont "Final Chance!"
	prompt
