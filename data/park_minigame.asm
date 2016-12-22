ParkMinigameGames:
	; price (x100), minutes, balls, game kind (-1: choose by time of day)
	db 20, 10, 15, -1 ; regular 10 min
	db 35, 20, 30, -1 ; regular 20 min
	db 50, 30, 50, -1 ; regular 30 min
	db 25, 15, 20, 3  ; special, available on weekends

ParkMinigameTables:
	; mon chance (%), mon table, item table
	dbww 75, ParkMinigameMons0, ParkMinigameItems0
	dbww 70, ParkMinigameMons1, ParkMinigameItems1
	dbww 80, ParkMinigameMons2, ParkMinigameItems2
	dbww 75, ParkMinigameMons3, ParkMinigameItems3

ParkMinigameMons0:
	db 25, BUTTERFREE
	db 20, YANMA
	db 20, GOLBAT
	db 15, FEAROW
	db 15, PIDGEOT
	db 4, SCYTHER
	db 1, SCIZOR

ParkMinigameMons1:
	db 25, PARAS
	db 20, YANMA
	db 20, PARASECT
	db 15, ARIADOS
	db 9, VOLBEAT
	db 9, ILLUMISE
	db 2, YANMEGA

ParkMinigameMons2:
	db 25, GOLBAT
	db 20, VULPIX
	db 20, GROWLITHE
	db 15, GRAVELER
	db 15, MAGMAR
	db 4, GOLEM
	db 1, GIBLE

ParkMinigameMons3:
	db 25, PARAS
	db 20, CACNEA
	db 20, WEEPINBELL
	db 15, BRELOOM
	db 15, TANGELA
	db 4, VICTREEBEL
	db 1, EEVEE

; item tables are: first byte, percentage; second byte: high nibble: kind (1 for Poke, 2 for Great, 3 for Ultra, 4 for Master), low nibble: quantity
; an item with a kind of 0 represents an empty spot
ParkMinigameItems0:
	dbnn 15, 1, 1
	dbnn 10, 1, 2
	dbnn  5, 1, 3
	dbnn 10, 2, 1
	dbnn  5, 2, 2
	dbnn  3, 2, 3
	dbnn  6, 3, 1
	dbnn  4, 3, 2
	dbnn  2, 3, 3
	dbnn 40, 0, 0

ParkMinigameItems1:
	dbnn 15, 1, 1
	dbnn 10, 1, 2
	dbnn  5, 1, 3
	dbnn 10, 2, 1
	dbnn  5, 2, 2
	dbnn  5, 2, 3
	dbnn  6, 3, 1
	dbnn  4, 3, 2
	dbnn 40, 0, 0

ParkMinigameItems2:
ParkMinigameItems3:
	dbnn 15, 1, 1
	dbnn 10, 1, 2
	dbnn  5, 1, 3
	dbnn 10, 2, 1
	dbnn  5, 2, 2
	dbnn  3, 2, 3
	dbnn 10, 3, 1
	dbnn  5, 3, 2
	dbnn  2, 3, 3
	dbnn 35, 0, 0
