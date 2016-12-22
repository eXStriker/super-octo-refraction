	ctxt "Fish" ; species name
	done
	dw 200, 163 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It is a shabby and"
	next "ugly #mon."
	next "However, it is"
	done
.page2
	ctxt "very hardy and can"
	next "survive on little"
	next "water."
	done
