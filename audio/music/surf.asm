Music_Surf:
	channelcount 3
	channel 1, Music_Surf_Ch1
	channel 2, Music_Surf_Ch2
	channel 3, Music_Surf_Ch3

Music_Surf_Ch1:
	tempo $75
	dutycycle $1
	notetype $c, $c4
	vibrato $10, $12
	stereopanning $f
Music_Surf_L1:
	octave 3
	note F_, 2
	note A#, 2
	octave 4
	note D#, 2
	note F_, 2
	note A#, 2
	note __, 2
	octave 3
	note F_, 2
	note A_, 2
	octave 4
	note D#, 2
	note F_, 2
	note A_, 2
	note __, 2
	loopchannel 3, Music_Surf_L1
	octave 3
	note F_, 2
	note A#, 2
	octave 4
	note D#, 2
	note F_, 2
	note A#, 2
	note __, 2
	octave 3
	note F_, 2
	note __, 2
	note D#, 2
	note F_, 2
	note G_, 2
	note A_, 2
	callchannel Music_Surf_P1
	note A_, 6
	note __, 2
	note F_, 4
	note A_, 8
	note D#, 2
	note F_, 2
	note G_, 6
	note __, 2
	note G_, 2
	note A_, 2
	note A#, 8
	note A#, 2
	note G_, 2
	note A_, 10
	note __, 2
	note C_, 2
	note D_, 2
	note D#, 2
	note F_, 2
	note G_, 2
	note A_, 2
	callchannel Music_Surf_P1
	note A_, 4
	note A#, 4
	octave 4
	note D_, 4
	note D#, 2
	note __, 2
	note D#, 4
	note F_, 4
	note F#, 4
	note F_, 4
	note D#, 4
	note C#, 8
	octave 3
	note G#, 4
	octave 4
	note F_, 4
	note D#, 4
	note C#, 4
	note C_, 8
	octave 3
	note G_, 4
	octave 4
	note E_, 4
	note D_, 4
	note C_, 4
	octave 3
	note B_, 8
	note B_, 2
	note __, 2
	note A_, 6
	note __, 2
	note A_, 2
	note __, 2
	note A#, 6
	note __, 2
	note A#, 2
	note __, 2
	octave 4
	note C_, 6
	note __, 2
	note C_, 2
	note __, 2
	octave 2
	note F_, 1
	note A_, 1
	octave 3
	note C_, 1
	note D#, 1
	note F_, 1
	note A_, 1
	octave 4
	note C_, 1
	note D#, 1
	note F_, 1
	note A_, 1
	octave 5
	note C_, 1
	note D#, 1
	note F_, 2
	note __, 2
	octave 4
	note C_, 4
	note D#, 4
	callchannel Music_Surf_P2
	octave 4
	note C_, 8
	note C_, 2
	note D#, 2
	callchannel Music_Surf_P2
	note A_, 4
	note G_, 4
	note A_, 4
	loopchannel 0, Music_Surf_L1

Music_Surf_Ch2:
	dutycycle $2
	notetype $c, $c3
	stereopanning $f0
Music_Surf_L2:
	octave 1
	note A#, 4
	octave 2
	note F_, 2
	note __, 2
	note F_, 2
	note __, 2
	octave 1
	note A_, 4
	octave 2
	note F_, 2
	note __, 2
	note F_, 2
	note __, 2
	loopchannel 3, Music_Surf_L2
	octave 1
	note A#, 4
	octave 2
	note F_, 2
	note __, 2
	note F_, 2
	note __, 2
	octave 1
	note A_, 4
	note __, 4
	note A_, 4
	callchannel Music_Surf_P3
	forceoctave F_ + $f
	callchannel Music_Surf_P4
	forceoctave A# + $f
	callchannel Music_Surf_P5
	forceoctave C_ - 1
	note C_, 4
	note F_, 2
	note __, 2
	note F_, 2
	note __, 2
	note C_, 4
	note F_, 2
	note __, 2
	note A_, 2
	note __, 2
	callchannel Music_Surf_P3
	forceoctave C_ - 1
	octave 1
	note A#, 4
	octave 2
	note D_, 4
	note F_, 4
	note G_, 2
	note __, 2
	note G_, 4
	note F_, 2
	note __, 2
	forceoctave F_ - 1
	callchannel Music_Surf_P5
	forceoctave D# - 1
	callchannel Music_Surf_P5
	forceoctave D_ - 1
	callchannel Music_Surf_P5
	forceoctave C_ - 1
	callchannel Music_Surf_P6
	forceoctave D_ - 1
	callchannel Music_Surf_P6
	forceoctave D# - 1
	callchannel Music_Surf_P6
	forceoctave F_ - 1
	callchannel Music_Surf_P6
	octave 2
	note C_, 2
	note __, 2
	note C_, 8
	rept 2
	callchannel Music_Surf_P5
	callchannel Music_Surf_P7
	forceoctave D_ - 1
	callchannel Music_Surf_P5
	forceoctave C_ - 1
	callchannel Music_Surf_P5
	forceoctave A# + $f
	callchannel Music_Surf_P5
	forceoctave C_ - 1
	callchannel Music_Surf_P5
	forceoctave D# - 1
	callchannel Music_Surf_P5
	forceoctave F_ - 1
	callchannel Music_Surf_P7
	endr
	forceoctave C_ - 1
	loopchannel 0, Music_Surf_L2

Music_Surf_Ch3:
	notetype $c, $13
	vibrato $9, $24
	octave 4
Music_Surf_L4:
	note A#, 4
	note A_, 4
	note G_, 4
	note A_, 4
	note F_, 6
	note __, 2
	note D#, 4
	note D_, 4
	note D#, 4
	note F_, 10
	note __, 2
	note A#, 4
	octave 5
	note C_, 2
	note __, 2
	octave 4
	note A#, 2
	note __, 2
	note A#, 4
	note F_, 6
	note __, 2
	note D#, 4
	note D_, 4
	note G_, 4
	note F_, 4
	note A#, 2
	octave 5
	note C_, 2
	note D_, 2
	note D#, 2
	intensity $11
	note F_, 14
	notetype $6, $11
	note __, 3
	note F#, 1
	notetype $c, $11
	note G_, 2
	note __, 2
	note F_, 2
	note __, 2
	note F_, 8
	note D#, 2
	note D_, 2
	note D#, 6
	note __, 2
	note C_, 2
	note D_, 2
	note D#, 14
	notetype $6, $11
	note __, 3
	note E_, 1
	notetype $c, $11
	note F_, 2
	note __, 2
	note D#, 2
	note __, 2
	note D#, 8
	note D_, 2
	note C_, 2
	note D_, 6
	note __, 2
	callchannel Music_Surf_P8
	note C_, 6
	note __, 2
	octave 4
	note G_, 4
	octave 5
	note C_, 6
	note __, 2
	octave 4
	note G_, 2
	note A_, 2
	note A#, 6
	note __, 2
	note A#, 2
	octave 5
	note C_, 2
	note D_, 6
	note __, 2
	note D#, 2
	octave 4
	notetype $6, $11
	note A#, 3
	note B_, 1
	notetype $c, $11
	octave 5
	note C_, 10
	note __, 2
	note C_, 4
	note D_, 4
	note D#, 4
	intensity $11
	note F_, 14
	notetype $6, $11
	note __, 3
	note F#, 1
	notetype $c, $11
	note G_, 2
	note __, 2
	note F_, 2
	note __, 2
	note A#, 8
	note D#, 2
	note D_, 2
	note D#, 4
	note C_, 4
	note D_, 4
	note D#, 6
	note __, 2
	note D#, 2
	notetype $6, $11
	note __, 3
	note E_, 1
	notetype $c, $11
	note F_, 4
	note C_, 4
	note D#, 4
	note D_, 6
	note __, 2
	note D_, 2
	note D#, 2
	note D_, 6
	note __, 2
	callchannel Music_Surf_P8
	note C_, 4
	note D_, 4
	note F_, 4
	note G_, 2
	note __, 2
	intensity $11
	note G_, 4
	note A_, 4
	note A#, 4
	note A_, 4
	note G_, 4
	note F_, 10
	note __, 2
	note G#, 4
	note G_, 4
	note F_, 4
	note D#, 10
	note __, 2
	note G_, 4
	note F#, 4
	note E_, 4
	note D_, 10
	note __, 2
	note C_, 6
	note __, 2
	note C_, 2
	notetype $6, $11
	note __, 3
	note C#, 1
	note D_, 12
	note __, 4
	note D_, 4
	note __, 3
	note D_, 1
	notetype $c, $11
	note D#, 4
	note C_, 4
	note D#, 4
	note F_, 12
	note __, 4
	note F_, 4
	note A_, 4
	note A#, 12
	note __, 4
	note A_, 4
	note G_, 4
	note F_, 12
	note D_, 4
	note __, 4
	note D_, 4
	note G_, 12
	note __, 4
	note F_, 4
	note D#, 4
	note D_, 6
	note C_, 2
	octave 4
	note A#, 2
	octave 5
	note D#, 2
	note D_, 4
	note __, 4
	intensity $13
	note D_, 2
	note C_, 2
	octave 4
	callchannel Music_Surf_P9
	note F_, 2
	octave 5
	note C_, 6
	note __, 2
	note F_, 2
	note G_, 2
	note G#, 4
	note G_, 4
	note F_, 4
	note D#, 4
	note __, 4
	note D#, 4
	note F_, 4
	note C_, 4
	note F_, 4
	note A_, 4
	note F_, 4
	note A_, 4
	intensity $11
	note A#, 12
	note __, 4
	note A_, 2
	note G_, 2
	note F_, 2
	note D#, 2
	note F_, 4
	note D_, 4
	note F_, 4
	note D_, 4
	note __, 4
	note D_, 4
	note G_, 12
	note __, 4
	note G_, 2
	note F_, 2
	note D#, 2
	note D_, 2
	note C_, 4
	octave 4
	note A#, 2
	octave 5
	note C_, 2
	note D_, 2
	octave 4
	note A#, 2
	octave 5
	note G_, 4
	note __, 4
	intensity $13
	octave 4
	note G_, 2
	note A_, 2
	callchannel Music_Surf_P9
	note A#, 2
	octave 5
	note C_, 4
	note F_, 4
	note G_, 4
	note G#, 4
	note G_, 4
	note F_, 4
	note D#, 4
	note __, 4
	note D#, 4
	note F_, 12
	note C_, 4
	octave 4
	note F_, 4
	note A_, 4
	loopchannel 0, Music_Surf_L4

Music_Surf_P1:
	note A#, 2
	octave 4
	note D_, 2
	note F_, 4
	note F_, 2
	note __, 2
	octave 3
	loopchannel 2, Music_Surf_P1
.loop2
	note A#, 2
	octave 4
	note D_, 2
	note D#, 4
	note D#, 2
	note __, 2
	octave 3
	loopchannel 4, .loop2
	note A#, 2
	octave 4
	note C_, 2
	note D_, 4
	note D_, 2
	note __, 2
	octave 3
	note A#, 2
	octave 4
	note C_, 2
	note D_, 4
	octave 3
	note A#, 2
	note A_, 2
	note G_, 10
	note __, 2
	note G_, 4
	note A_, 4
	note A#, 4
	endchannel

Music_Surf_P2:
	note F_, 12
	octave 3
	note A#, 4
	octave 4
	note F_, 4
	note C_, 4
	note F_, 8
	note F_, 4
	octave 3
	note A_, 4
	note __, 4
	note A_, 4
	note A#, 12
	note G_, 4
	octave 4
	note D_, 4
	octave 3
	note A#, 4
	octave 4
	note D_, 8
	note C_, 4
	octave 3
	note A#, 8
	note A#, 2
	note A_, 2
	note G_, 4
	note __, 4
	note G_, 2
	note A_, 2
	note A#, 2
	note __, 2
	note A#, 2
	note A_, 2
	note G_, 2
	note __, 2
	note A_, 8
	note C_, 4
	note A_, 8
	octave 4
	note C_, 2
	note D_, 2
	note D#, 4
	note D_, 4
	note C_, 4
	octave 3
	note A#, 4
	note __, 4
	note A#, 4
	note A_, 8
	note A_, 2
	note __, 2
	endchannel

Music_Surf_P3:
	octave 2
	note F_, 2
	note __, 2
	note F_, 2
	note A#, 2
	note F_, 2
	note A#, 2
	note F_, 2
	note __, 2
	note F_, 4
	note A#, 4
	note D#, 2
	note __, 2
	note D#, 2
	note A#, 2
	note D#, 2
	note A#, 2
	note D#, 2
	note __, 2
	note D#, 4
	note A#, 4
	note D#, 2
	note __, 2
	note D#, 2
	note A#, 2
	note D#, 2
	note A#, 2
	note D#, 2
	note __, 2
	note D#, 4
	note A#, 4
	note D_, 2
	note __, 2
	note D_, 2
	note A#, 2
	note D_, 2
	note A#, 2
	note D_, 2
	note __, 2
	note D_, 4
	note C_, 4
	forceoctave G_ + $f

Music_Surf_P4:
	octave 2
	note C_, 4
	note G_, 2
	note __, 2
	note G_, 2
	note __, 2
	loopchannel 2, Music_Surf_P4
	endchannel

Music_Surf_P5:
	octave 2
	note C_, 4
	note F_, 2
	note __, 2
	note F_, 2
	note __, 2
	loopchannel 2, Music_Surf_P5
	endchannel

Music_Surf_P6:
	octave 2
	note C_, 2
	note __, 2
	note C_, 2
	octave 1
	note G_, 2
	octave 2
	note C_, 2
	octave 1
	note G_, 2
	endchannel

Music_Surf_P7:
	octave 2
	note C_, 4
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	loopchannel 2, Music_Surf_P7
	endchannel

Music_Surf_P8:
	intensity $13
	note D_, 2
	note C_, 2
	octave 4
	note A#, 10
	note __, 2
	note A#, 4
	octave 5
	note C_, 4
	note D_, 4
	endchannel

Music_Surf_P9:
	note A#, 4
	note __, 4
	note A#, 2
	octave 5
	note C_, 2
	note D_, 2
	note __, 2
	note D_, 2
	note C_, 2
	octave 4
	note A#, 2
	note __, 2
	octave 5
	note C_, 4
	note __, 4
	note C_, 2
	octave 4
	endchannel
