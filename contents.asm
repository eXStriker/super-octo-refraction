; Doubles as bank constants.

; main.o

CODE_1                      EQU $01
CODE_2                      EQU $02
CODE_3                      EQU $03
CODE_4                      EQU $04
CODE_5                      EQU $05
CODE_6                      EQU $07
CODE_7                      EQU $08
CODE_8                      EQU $09
CODE_9                      EQU $0A
CODE_10                     EQU $0B
CODE_11                     EQU $0D
CODE_12                     EQU $0E
CODE_13                     EQU $10
CODE_14                     EQU $11
CODE_15                     EQU $12
CODE_16                     EQU $13
CODE_17                     EQU $14
CODE_18                     EQU $18
CODE_19                     EQU $1E
CODE_20                     EQU $23
CODE_21                     EQU $25
CODE_22                     EQU $26
CODE_23                     EQU $27
CODE_24                     EQU $28
CODE_25                     EQU $2C
CODE_26                     EQU $2D
CODE_27                     EQU $31
CODE_28                     EQU $32
CODE_29                     EQU $33
CODE_30                     EQU $34
CODE_31                     EQU $35
CODE_32                     EQU $36
CODE_33                     EQU $38
CODE_34                     EQU $39
CODE_35                     EQU $3F
CODE_36                     EQU $40
CODE_37                     EQU $42
CODE_38                     EQU $43
CODE_39                     EQU $44
CODE_40                     EQU $45
CODE_41                     EQU $50
CODE_42                     EQU $51
CODE_43                     EQU $5B
CODE_44                     EQU $5C
CODE_45                     EQU $70

DATA_SINE_LOOKUP            EQU $05
DATA_BATTLE_TOWER           EQU $37

BATTLE_TOWER_DEBUG          EQU $14

EFFECT_COMMANDS             EQU $0D
ENEMY_TRAINERS              EQU $0E
BATTLE_CORE                 EQU $0F

ROOFS                       EQU $07

TILESETS_1                  EQU $08
TILESETS_2                  EQU $0C
TILESETS_3                  EQU $22
TILESETS_4                  EQU $27
TILESETS_5                  EQU $28
TILESETS_6                  EQU $2D
TILESETS_7                  EQU $43
TILESETS_8                  EQU $44
TILESETS_9                  EQU $71

TILESETS_SMALL_1            EQU $05
TILESETS_SMALL_2            EQU $13
TILESETS_SMALL_3            EQU $35
TILESETS_SMALL_4            EQU $38
TILESETS_SMALL_5            EQU $3D
TILESETS_SMALL_6            EQU $42
TILESETS_SMALL_7            EQU $4D

; data/pokedex/entries.o

POKEDEX_ENTRIES_1           EQU $3E
POKEDEX_ENTRIES_2           EQU $3F


; engine/events.o
; engine/scripting.o
; engine/events_2.o
EVENTS                      EQU $25

; gfx/pics.o

PIC_POINTERS                EQU $46
TRAINER_PIC_POINTERS        EQU $67

PICS_1                      EQU $21
PICS_2                      EQU $37
PICS_3                      EQU $40
PICS_4                      EQU $45
PICS_5                      EQU $46
PICS_6                      EQU $47
PICS_7                      EQU $48
PICS_8                      EQU $49
PICS_9                      EQU $4A
PICS_10                     EQU $4B
PICS_11                     EQU $4C
PICS_12                     EQU $4D
PICS_13                     EQU $4E
PICS_14                     EQU $4F
PICS_15                     EQU $50
PICS_16                     EQU $51
PICS_17                     EQU $52
PICS_18                     EQU $53
PICS_19                     EQU $54
PICS_20                     EQU $55
PICS_21                     EQU $56

PICS_SMALL_1                EQU $02
PICS_SMALL_2                EQU $13
PICS_SMALL_3                EQU $1A
PICS_SMALL_4                EQU $28
PICS_SMALL_5                EQU $31
PICS_SMALL_6                EQU $36
PICS_SMALL_7                EQU $3F

PLAYER_PICS                 EQU $57

PIC_ANIMS                   EQU $34

PIC_ANIM_FRAMES_1           EQU $34
PIC_ANIM_FRAMES_2           EQU $35
PIC_ANIM_FRAMES_3           EQU $36

; spritestuff

SPRITES_1                   EQU $03
SPRITES_2                   EQU $05
SPRITES_3                   EQU $30
SPRITES_4                   EQU $31
SPRITES_5                   EQU $42

SPRITES_SMALL_1             EQU $32
SPRITES_SMALL_2             EQU $44
SPRITES_SMALL_3             EQU $54
SPRITES_SMALL_4             EQU $59

POKEMON_SPRITE_POINTERS     EQU $43

POKEMON_OW_SPRITES_1        EQU $03
POKEMON_OW_SPRITES_2        EQU $06
POKEMON_OW_SPRITES_3        EQU $1A
POKEMON_OW_SPRITES_4        EQU $20
POKEMON_OW_SPRITES_5        EQU $2F

POKEMON_OW_SPRITES_SMALL_1  EQU $30
POKEMON_OW_SPRITES_SMALL_2  EQU $43
POKEMON_OW_SPRITES_SMALL_3  EQU $44
POKEMON_OW_SPRITES_SMALL_4  EQU $54

PLAYER_SPRITES_1            EQU $07
PLAYER_SPRITES_2            EQU $20

POKEICONS_POINTERS          EQU $1C

POKEICONS_1                 EQU $1E
POKEICONS_2                 EQU $2B
POKEICONS_3                 EQU $2E
POKEICONS_4                 EQU $44

; maps.o

MAP_HEADERS                 EQU $25
MAP_SECOND_HEADERS          EQU $26

MAPS_1                      EQU $05
MAPS_2                      EQU $1F
MAPS_3                      EQU $20
MAPS_4                      EQU $2A
MAPS_5                      EQU $2B
MAPS_6                      EQU $2C
MAPS_7                      EQU $36
MAPS_8                      EQU $43
MAPS_9                      EQU $6C

MAPS_SMALL_1                EQU $4E

MAP_SCRIPTS_1               EQU $0E
MAP_SCRIPTS_2               EQU $12
MAP_SCRIPTS_3               EQU $15
MAP_SCRIPTS_4               EQU $16
MAP_SCRIPTS_5               EQU $17
MAP_SCRIPTS_6               EQU $18
MAP_SCRIPTS_7               EQU $19
MAP_SCRIPTS_8               EQU $1A
MAP_SCRIPTS_9               EQU $1B
MAP_SCRIPTS_10              EQU $1C
MAP_SCRIPTS_11              EQU $1D
MAP_SCRIPTS_12              EQU $1E
MAP_SCRIPTS_13              EQU $1F
MAP_SCRIPTS_14              EQU $28
MAP_SCRIPTS_15              EQU $6F

MAP_SCRIPTS_SMALL_1         EQU $09
MAP_SCRIPTS_SMALL_2         EQU $0A
MAP_SCRIPTS_SMALL_3         EQU $0C
MAP_SCRIPTS_SMALL_4         EQU $23
MAP_SCRIPTS_SMALL_5         EQU $27
MAP_SCRIPTS_SMALL_6         EQU $30
MAP_SCRIPTS_SMALL_7         EQU $37
MAP_SCRIPTS_SMALL_8         EQU $4A
MAP_SCRIPTS_SMALL_9         EQU $56
MAP_SCRIPTS_SMALL_10        EQU $71

MAP_SCRIPTS_BATTLE_TOWER    EQU $15

; audio.o

AUDIO                       EQU $3A

SONGS_1                     EQU $14
SONGS_2                     EQU $22
SONGS_3                     EQU $24
SONGS_4                     EQU $3A
SONGS_5                     EQU $3B
SONGS_6                     EQU $3C
SONGS_7                     EQU $3D

SONGS_SMALL_1               EQU $11
SONGS_SMALL_2               EQU $1A
SONGS_SMALL_3               EQU $26
SONGS_SMALL_4               EQU $29
SONGS_SMALL_5               EQU $30
SONGS_SMALL_6               EQU $32
SONGS_SMALL_7               EQU $45
SONGS_SMALL_8               EQU $71

SOUND_EFFECTS_1             EQU $3C
SOUND_EFFECTS_2             EQU $5C

CRIES                       EQU $24

DED                         EQU $3F

DED_1                       EQU $29
DED_2                       EQU $40
DED_3                       EQU $58
DED_4                       EQU $59
DED_5                       EQU $5A
DED_6                       EQU $5B
DED_7                       EQU $5C
DED_8                       EQU $5D
DED_9                       EQU $5E
DED_10                      EQU $5F
DED_11                      EQU $60
DED_12                      EQU $61
DED_13                      EQU $62
DED_14                      EQU $63
DED_15                      EQU $64
DED_16                      EQU $65
DED_17                      EQU $66
DED_18                      EQU $67
DED_19                      EQU $68
DED_20                      EQU $69
DED_21                      EQU $6A
DED_22                      EQU $6B
DED_23                      EQU $6C
DED_24                      EQU $6D
DED_25                      EQU $6E
DED_26                      EQU $6F
DED_27                      EQU $70

DED_SMALL_1                 EQU $04
DED_SMALL_2                 EQU $0B
DED_SMALL_3                 EQU $13
DED_SMALL_4                 EQU $16
DED_SMALL_5                 EQU $20
DED_SMALL_6                 EQU $28
DED_SMALL_7                 EQU $2C
DED_SMALL_8                 EQU $38
DED_SMALL_9                 EQU $3E
DED_SMALL_10                EQU $41

; misc gfx

EMOTE_BUBBLES               EQU $0B
FONT_GFX                    EQU $41
MISC_GFX                    EQU $41
END_GFX                     EQU $52
SIGNPOST_GFX                EQU $71

; text.o

TEXT_1                      EQU $08
TEXT_2                      EQU $25
TEXT_3                      EQU $3A
TEXT_4                      EQU $3E
TEXT_5                      EQU $4B
TEXT_6                      EQU $4F
TEXT_7                      EQU $50
TEXT_8                      EQU $53
TEXT_9                      EQU $5D
TEXT_10                     EQU $68

TEXT_STANDARD               EQU $25
TEXT_JUDGE                  EQU $15
