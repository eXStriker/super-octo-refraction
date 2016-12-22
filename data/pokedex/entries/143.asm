	ctxt "Sleeping" ; species name
	done
	dw 611, 10140 ; height, weight

	db .page2 - .page1
.page1
	ctxt "This #mon's"
	next "stomach is so"
	next "strong, even"
	done
.page2
	ctxt "eating moldy or"
	next "rotten food will"
	next "not affect it."
	done
