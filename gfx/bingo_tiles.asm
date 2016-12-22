; Contains a copy of bingo_tiles.pal in case gfx.py destroys the content of the .pal file

.palette0
	; text palette, also the palette used to encode the tiles
	; colors 0, 1, 2, 3 map to white, blue, red, black
	; colors 1 and 2 are reserved for dynamic coloring
	RGB 31, 31, 31
	RGB 00, 00, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

.palette1
	; bingo board, border
	RGB 31, 31, 31
	RGB 09, 00, 31
	RGB 31, 29, 00
	RGB 31, 26, 00

.palette2
	; bingo board, inside
	RGB 17, 17, 17
	RGB 09, 09, 09
	RGB 31, 29, 00
	RGB 31, 26, 00

.palette3
	; marked cell
	RGB 00, 31, 02
	RGB 11, 26, 17
	RGB 31, 29, 00
	RGB 00, 13, 07

.palette4
	; unmarked cell
	RGB 31, 29, 00
	RGB 31, 14, 10
	RGB 31, 00, 00
	RGB 13, 00, 00
