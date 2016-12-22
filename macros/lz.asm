; The lz format can contain the following commands:
; 	lzdata <bytes>: up to 1,024 literal bytes
; 	lzrepeat <count>, <value>[, <value>]: one or two values repeated for up to 1,024 bytes
; 	lzzero <count>: special case of the above where the value is $00
; 	lzcopy <kind>, <count>, <address>: copy of some data already in the file. The kind can be normal (straight copy),
; 	                                   flipped (the bits are flipped when copying: %01000001 becomes %10000010), or
; 	                                   reversed (the source pointer moves backwards, copying bytes in reverse order). The
; 	                                   count can be up to 1,024, and the address is either absolute or negative relative (-1 to -128).
; 	lzend: ends the LZ input stream, must appear exactly once

lzcmd: MACRO
	if ((\2) < 1) || ((\2) > 1024)
		fail "An LZ command can only represent between 1 and 1,024 bytes"
	endc
	if (\2) > 32
		db $e0 | ((\1) << 2) | (((\2) - 1) >> 8)
		db ((\2) - 1) & $ff
	else
		db ((\1) << 5) | ((\2) - 1)
	endc
ENDM

lzdata: MACRO
lzdata_count = _NARG
	lzcmd 0, lzdata_count
	rept lzdata_count
		db \1
		shift
	endr
ENDM

lzrepeat: MACRO
	if (_NARG < 2) || (_NARG > 3)
		fail "lzrepeat can only repeat one or two bytes"
	endc
lzrepeat_count = _NARG + -1
	lzcmd lzrepeat_count, \1
	rept lzrepeat_count
		db \2
		shift
	endr
ENDM

lzzero: MACRO
	if _NARG != 1
		fail "lzzero only takes a count parameter"
	endc
	lzcmd 3, \1
ENDM

lzcopy: MACRO
	if _NARG != 3
		fail "lzcopy requires a kind, a count and an address"
	endc
	if "\1" == "normal"
		lzcmd 4, \2
	else
	if "\1" == "flipped"
		lzcmd 5, \2
	else
	if "\1" == "reversed"
		lzcmd 6, \2
	else
		fail "Unknown kind in lzcopy"
	endc
	endc
	endc
	if (\3) < 0
		if (\3) < -128
			fail "lzcopy address must be between -128 and $7fff"
		endc
		db $7f - (\3)
	else
		if (\3) > $7fff
			fail "lzcopy address must be between -128 and $7fff"
		endc
		bigdw \3
	endc
ENDM

lzend: MACRO
	if _NARG > 0
		fail "lzend does not take parameters"
	endc
	db $ff
ENDM
