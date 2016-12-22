INCLUDE "includes.asm"

SECTION "Audio", ROMX, BANK[AUDIO]

INCLUDE "audio/engine.asm"

; What music plays when a trainer notices you
INCLUDE "audio/trainer_encounters.asm"

Music:
INCLUDE "audio/music_pointers.asm"

INCLUDE "audio/music/nothing.asm"

Cries:
INCLUDE "audio/cry_pointers.asm"

SFX:
INCLUDE "audio/sfx_pointers.asm"

SECTION "Songs 1", ROMX, BANK[SONGS_1]
; linked, do not separate
INCLUDE "audio/music/prism/_libhoennbattle.asm"
INCLUDE "audio/music/prism/hoennwildbattle.asm"
INCLUDE "audio/music/prism/hoenntrainerbattle.asm"
INCLUDE "audio/music/prism/hoenngymbattle.asm"
; end of linked section

SECTION "Songs 2", ROMX, BANK[SONGS_2]
INCLUDE "audio/music/prism/naljogymbattle.asm"
INCLUDE "audio/music/prism/naljowildbattle.asm"
INCLUDE "audio/music/prism/palletbattle.asm"
INCLUDE "audio/music/prism/kantolegend.asm"
INCLUDE "audio/music/prism/route103.asm"
INCLUDE "audio/music/prism/club2.asm"
INCLUDE "audio/music/prism/prism_ice_cave.asm"
INCLUDE "audio/music/prism/prism_trainer_encounter.asm"
INCLUDE "audio/music/prism/prism_tough_trainer_2.asm"
INCLUDE "audio/music/prism/prism_female_trainer.asm"
INCLUDE "audio/music/prism/prism_female_trainer_2.asm"
INCLUDE "audio/music/prism/hoohbattle.asm"
INCLUDE "audio/music/prism/lugiabattle.asm"
INCLUDE "audio/music/prism/silphco.asm"
INCLUDE "audio/music/route36.asm"
INCLUDE "audio/music/credits.asm"
INCLUDE "audio/music/postcredits.asm"

SECTION "Songs 3", ROMX, BANK[SONGS_3]
INCLUDE "audio/music/prism/route203.asm"
INCLUDE "audio/music/prism/route209.asm"
INCLUDE "audio/music/prism/route210.asm"
INCLUDE "audio/music/prism/route216.asm"
INCLUDE "audio/music/prism/EternaForest.asm"
INCLUDE "audio/music/prism/shop.asm"
INCLUDE "audio/music/tintower.asm"

SECTION "Songs 4", ROMX, BANK[SONGS_4]
INCLUDE "audio/music/rivalbattle.asm"
INCLUDE "audio/music/rocketbattle.asm"
INCLUDE "audio/music/elmslab.asm"
INCLUDE "audio/music/darkcave.asm"
INCLUDE "audio/music/johtogymbattle.asm"
INCLUDE "audio/music/championbattle.asm"
INCLUDE "audio/music/ssaqua.asm"
INCLUDE "audio/music/newbarktown.asm"
INCLUDE "audio/music/goldenrodcity.asm"
INCLUDE "audio/music/vermilioncity.asm"
INCLUDE "audio/music/titlescreen.asm"
INCLUDE "audio/music/ruinsofalphinterior.asm"
INCLUDE "audio/music/lookpokemaniac.asm"

SECTION "Songs 5", ROMX, BANK[SONGS_5]
INCLUDE "audio/music/trainervictory.asm"
INCLUDE "audio/music/route1.asm"
INCLUDE "audio/music/route3.asm"
INCLUDE "audio/music/route12.asm"
INCLUDE "audio/music/kantogymbattle.asm"
INCLUDE "audio/music/kantotrainerbattle.asm"
INCLUDE "audio/music/kantowildbattle.asm"
INCLUDE "audio/music/pokemoncenter.asm"
INCLUDE "audio/music/looklass.asm"
INCLUDE "audio/music/lookofficer.asm"
INCLUDE "audio/music/route2.asm"
INCLUDE "audio/music/mtmoon.asm"
INCLUDE "audio/music/gamecorner.asm"
INCLUDE "audio/music/looksage.asm"
INCLUDE "audio/music/pokemonchannel.asm"
INCLUDE "audio/music/lighthouse.asm"
INCLUDE "audio/music/lakeofrage.asm"
INCLUDE "audio/music/indigoplateau.asm"
INCLUDE "audio/music/route37.asm"
INCLUDE "audio/music/rockethideout.asm"
INCLUDE "audio/music/dragonsden.asm"
INCLUDE "audio/music/ruinsofalphradio.asm"
INCLUDE "audio/music/lookbeauty.asm"
INCLUDE "audio/music/route26.asm"
INCLUDE "audio/music/ecruteakcity.asm"
INCLUDE "audio/music/lakeofragerocketradio.asm"
INCLUDE "audio/music/magnettrain.asm"
INCLUDE "audio/music/lavendertown.asm"
INCLUDE "audio/music/dancinghall.asm"
INCLUDE "audio/music/contestresults.asm"
INCLUDE "audio/music/route30.asm"
INCLUDE "audio/music/healpokemon.asm"

SECTION "Songs 6", ROMX, BANK[SONGS_6]
INCLUDE "audio/music/viridiancity.asm"
INCLUDE "audio/music/celadoncity.asm"
INCLUDE "audio/music/wildpokemonvictory.asm"
INCLUDE "audio/music/successfulcapture.asm"
INCLUDE "audio/music/gymleadervictory.asm"
INCLUDE "audio/music/mtmoonsquare.asm"
INCLUDE "audio/music/gym.asm"
INCLUDE "audio/music/pallettown.asm"
INCLUDE "audio/music/profoakspokemontalk.asm"
INCLUDE "audio/music/profoak.asm"
INCLUDE "audio/music/lookrival.asm"
INCLUDE "audio/music/aftertherivalfight.asm"
INCLUDE "audio/music/surf.asm"
INCLUDE "audio/music/nationalpark.asm"
INCLUDE "audio/music/azaleatown.asm"
INCLUDE "audio/music/cherrygrovecity.asm"
INCLUDE "audio/music/unioncave.asm"
INCLUDE "audio/music/lookyoungster.asm"
INCLUDE "audio/music/lookhiker.asm"

SECTION "Songs 7", ROMX, BANK[SONGS_7]
INCLUDE "audio/music/bicycle.asm"
INCLUDE "audio/music/johtowildbattle.asm"
INCLUDE "audio/music/prism/johtoGSC.asm"
INCLUDE "audio/music/sprouttower.asm"
INCLUDE "audio/music/burnedtower.asm"
INCLUDE "audio/music/mom.asm"
INCLUDE "audio/music/victoryroad.asm"
INCLUDE "audio/music/lookrocket.asm"
INCLUDE "audio/music/rockettheme.asm"
INCLUDE "audio/music/mainmenu.asm"
INCLUDE "audio/music/lookkimonogirl.asm"
INCLUDE "audio/music/violetcity.asm"
INCLUDE "audio/music/bugcatchingcontest.asm"
INCLUDE "audio/music/lookmysticalman.asm"
INCLUDE "audio/music/crystalopening.asm"
INCLUDE "audio/music/battletowertheme.asm"
INCLUDE "audio/music/suicunebattle.asm"
INCLUDE "audio/music/battletowerlobby.asm"
INCLUDE "audio/music/mobilecenter.asm"
INCLUDE "audio/music/prism/ceruleanGSC.asm"
INCLUDE "audio/music/prism/cinnabarremix.asm"

SECTION "Songs small 1", ROMX, BANK[SONGS_SMALL_1]
INCLUDE "audio/music/prism/kalospowerplant.asm"
INCLUDE "audio/music/prism/lilycovecity.asm"

SECTION "Songs small 2", ROMX, BANK[SONGS_SMALL_2]
INCLUDE "audio/music/halloffame.asm"

SECTION "Songs small 3", ROMX, BANK[SONGS_SMALL_3]
INCLUDE "audio/music/evolution.asm"
INCLUDE "audio/music/printer.asm"
INCLUDE "audio/music/prism/dreamsequence.asm"

SECTION "Songs small 4", ROMX, BANK[SONGS_SMALL_4]
INCLUDE "audio/music/prism/somethingdungeon.asm"

SECTION "Songs small 5", ROMX, BANK[SONGS_SMALL_5]
INCLUDE "audio/music/prism/naljotrainerbattle.asm"
INCLUDE "audio/music/mobileadapter.asm"

SECTION "Songs small 6", ROMX, BANK[SONGS_SMALL_6]
INCLUDE "audio/music/prism/pokemontower.asm"
INCLUDE "audio/music/prism/hauntedforest.asm"
INCLUDE "audio/music/prism/hauntedmansion.asm"

SECTION "Songs small 7", ROMX, BANK[SONGS_SMALL_7]
INCLUDE "audio/music/prism/hoennlegend.asm"

SECTION "Songs small 8", ROMX, BANK[SONGS_SMALL_8]
INCLUDE "audio/music/prism/nuggetbridge.asm"
INCLUDE "audio/music/prism/oreburgh.asm"

SECTION "Sound Effects 1", ROMX, BANK[SOUND_EFFECTS_1]
INCLUDE "audio/sfx.asm"
INCLUDE "audio/sfx_crystal.asm"

SECTION "Sound Effects 2", ROMX, BANK[SOUND_EFFECTS_2]
INCLUDE "audio/prismsfx.asm"

SECTION "Cries", ROMX, BANK[CRIES]

CryHeaders:: INCLUDE "audio/cry_headers.asm"

INCLUDE "audio/cries.asm"

SECTION "DED", ROMX, BANK[DED]
INCLUDE "audio/ded.asm"

INCLUDE "audio/ded/files.asm"
