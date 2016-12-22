DemoSine::
x = 0.0
	rept 256
y = (mul(sin(x),128.0))>>16
if y < 128
	db y
else
	db 127
endc
x = x + 256.0
	endr
