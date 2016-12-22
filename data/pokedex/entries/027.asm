	ctxt "Flash" ; species name
	done
	dw 108, 209 ; height, weight

	db .page2 - .page1
.page1
	ctxt "The extension and"
	next "contraction of its"
	next "muscles generates"
	done
.page2
	ctxt "electricity. It"
	next "glows when in"
	next "trouble."
	done
