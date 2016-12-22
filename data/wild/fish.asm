FishGroups:
fish_group: macro
	db \1
	dw \2_Old, \2_Good, \2_Super
	endm

	fish_group 50 percent + 1, .Shore
	fish_group 50 percent + 1, .Ocean
	fish_group 50 percent + 1, .Lake
	fish_group 50 percent + 1, .Pond
	fish_group 50 percent + 1, .Cave

.Shore_Old
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     FEEBAS,     10
.Shore_Good
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     FEEBAS,     20
	db  90 percent + 1, FEEBAS,     20
	db 100 percent,     GOLDEEN,    20
.Shore_Super
	db  40 percent,     FEEBAS,     40
	db  90 percent + 1, FEEBAS,     40
	db 100 percent,     MILOTIC,    40

.Ocean_Old
	db  70 percent + 1, MAGIKARP,   10
	db  85 percent + 1, GOLDEEN,    10
	db 100 percent,     TENTACOOL,  10
.Ocean_Good
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     TENTACOOL,  20
	db  90 percent + 1, TENTACRUEL, 20
	db 100 percent,     GYARADOS,   20
.Ocean_Super
	db  40 percent,     TENTACOOL,  40
	db  70 percent,     GYARADOS,   40
	db  90 percent + 1, TENTACRUEL, 40
	db 100 percent,     WAILMER,    40

.Lake_Old
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     GOLDEEN,    10
.Lake_Good
	db  35 percent,     MAGIKARP,   20
	db  90 percent + 1, GOLDEEN,    20
	db 100 percent,     TENTACOOL,  20
.Lake_Super
	db  40 percent,     GOLDEEN,    40
	db  70 percent,     TENTACOOL,  40
	db  90 percent + 1, MAGIKARP,   40
	db 100 percent,     SEAKING,    40

.Pond_Old
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     SURSKIT,    10
.Pond_Good
	db  35 percent,     MAGIKARP,   20
	db  90 percent + 1, SURSKIT,    20
	db 100 percent,     FEEBAS,     20
.Pond_Super
	db  30 percent,     FEEBAS,     40
	db  50 percent + 1, MAGIKARP,   40
	db 100 percent,     SURSKIT,    40

.Cave_Old
	db  85 percent + 1, MAGIKARP,   10
	db 100 percent,     GOLDEEN,    10
.Cave_Good
	db  35 percent,     MAGIKARP,   20
	db  70 percent,     GOLDEEN,    20
	db  90 percent + 1, RELICANTH,  20
	db 100 percent,     TENTACOOL,  20
.Cave_Super
	db  40 percent,     GOLDEEN,    40
	db  70 percent,     TENTACOOL,  40
	db 100 percent,     RELICANTH,  40
