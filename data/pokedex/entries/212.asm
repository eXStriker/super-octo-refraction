	ctxt "Scissors" ; species name
	done
	dw 511, 2600 ; height, weight

	db .page2 - .page1
.page1
	ctxt "This #mon's"
	next "pincers, which"
	next "contain steel, can"
	done
.page2
	ctxt "crush any hard"
	next "object it gets a"
	next "hold of into bits."
	done
