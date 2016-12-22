Music_SomethingDungeon:
	channelcount 4
	channel 1, Music_SomethingDungeon_Ch1
	channel 2, Music_SomethingDungeon_Ch2
	channel 3, Music_SomethingDungeon_Ch3
	channel 4, Music_SomethingDungeon_Ch4

Music_SomethingDungeon_Ch1:
	tempo $62
	dutycycle $3
	notetype $c, $c2
	vibrato $1, $14
	stereopanning $f
	note __, 1
Music_SomethingDungeon_L1:
	tone $0002
	setcondition 0
	callchannel Music_SomethingDungeon_P1
	callchannel Music_SomethingDungeon_P1
	callchannel Music_SomethingDungeon_P1
	setcondition 1
	callchannel Music_SomethingDungeon_P1
	tone $0000
	setcondition 0
	callchannel Music_SomethingDungeon_P2
	callchannel Music_SomethingDungeon_P2
	callchannel Music_SomethingDungeon_P4
	setcondition 1
	callchannel Music_SomethingDungeon_P4
	loopchannel 0, Music_SomethingDungeon_L1

Music_SomethingDungeon_Ch2:
	dutycycle $1
	notetype $c, $c2
	stereopanning $f0
	setcondition 0
Music_SomethingDungeon_L5:
	rept 6
	callchannel Music_SomethingDungeon_P1
	endr
	callchannel Music_SomethingDungeon_P8
	callchannel Music_SomethingDungeon_P8
	loopchannel 0, Music_SomethingDungeon_L5

Music_SomethingDungeon_Ch3:
	notetype $c, $11
	octave 1
	note A#, 4
	note __, 2
	octave 2
	note A#, 4
	note __, 6
	octave 1
	note A#, 2
	octave 2
	note A#, 2
	note __, 2
	note A#, 2
	octave 1
	note A#, 4
	note __, 2
	octave 2
	note A#, 4
	note __, 6
	octave 1
	note A#, 2
	octave 2
	note A#, 2
	octave 1
	note A#, 2
	octave 2
	note A#, 2
	octave 1
	note G_, 4
	note __, 2
	octave 2
	note G_, 4
	note __, 6
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	note __, 2
	note G_, 2
	octave 1
	note G_, 4
	note __, 2
	octave 2
	note G_, 4
	note __, 6
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	octave 1
	note G_, 2
	octave 2
	note G_, 2
	loopchannel 2, Music_SomethingDungeon_Ch3
	notetype $6, $11
	rept 4
	callchannel Music_SomethingDungeon_P9
	endr
	callchannel Music_SomethingDungeon_P11
	callchannel Music_SomethingDungeon_P11
	loopchannel 0, Music_SomethingDungeon_Ch3

Music_SomethingDungeon_Ch4:
	notetype $c
	togglenoise $3
	note __, 16
Music_SomethingDungeon_L6:
	note __, 16
	loopchannel 10, Music_SomethingDungeon_L6
	note __, 10
	note D#, 2
	note D_, 2
	note D_, 2
Music_SomethingDungeon_L7:
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 2
	note D#, 2
	note D_, 4
	note D_, 1
	note D_, 1
	loopchannel 12, Music_SomethingDungeon_L7
	note D_, 16
	loopchannel 0, Music_SomethingDungeon_L6

Music_SomethingDungeon_P1:
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note F_, 2
	note A#, 2
	note F_, 2
	note C#, 2
	loopchannel 4, Music_SomethingDungeon_P1
Music_SomethingDungeon_P7:
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note G_, 2
	note G#, 2
	note G_, 2
	note C#, 2
	jumpif 1, .part2
	loopchannel 4, Music_SomethingDungeon_P7
	endchannel
.part2
	loopchannel 3, Music_SomethingDungeon_P7
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note G_, 2
	note G#, 2
	note G_, 2
	note C#, 1
	endchannel

Music_SomethingDungeon_P2:
	note C#, 2
	note F_, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note F_, 2
	loopchannel 4, Music_SomethingDungeon_P2
Music_SomethingDungeon_P3:
	note C#, 2
	note G_, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note G_, 2
	jumpif 1, .part2
	loopchannel 4, Music_SomethingDungeon_P3
	endchannel
.part2
	loopchannel 3, Music_SomethingDungeon_P3
	note C#, 2
	note G_, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note G_, 3
	endchannel

Music_SomethingDungeon_P4:
	note C#, 2
	note F#, 2
	note A#, 2
	octave 4
	note C#, 2
	octave 3
	note A#, 2
	note F#, 2
	loopchannel 2, Music_SomethingDungeon_P4
.loop2
	note C_, 2
	note D#, 2
	note G#, 2
	octave 4
	note C_, 2
	octave 3
	note G#, 2
	note D#, 2
	loopchannel 2, .loop2
	jumpchannel Music_SomethingDungeon_P3

Music_SomethingDungeon_P8:
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note F#, 2
	note A#, 2
	note F#, 2
	note C#, 2
	loopchannel 2, Music_SomethingDungeon_P8
.loop2
	octave 2
	note A#, 2
	octave 3
	note C_, 2
	note D#, 2
	note A#, 2
	note D#, 2
	note C_, 2
	loopchannel 2, .loop2
	jumpchannel Music_SomethingDungeon_P7

Music_SomethingDungeon_P9:
	octave 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	octave 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	loopchannel 4, Music_SomethingDungeon_P9
Music_SomethingDungeon_P10:
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note G_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note G_, 3
	note __, 1
	loopchannel 4, Music_SomethingDungeon_P10
	endchannel

Music_SomethingDungeon_P11:
	octave 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	octave 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	loopchannel 2, Music_SomethingDungeon_P11
.loop2
	octave 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	octave 1
	note A#, 3
	note __, 1
	octave 2
	note A#, 3
	note __, 1
	loopchannel 2, .loop2
	jumpchannel Music_SomethingDungeon_P10
