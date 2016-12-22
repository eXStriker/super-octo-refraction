Music_HallOfFame:
	channelcount 4
	channel 1, Music_HallOfFame_Ch1
	channel 2, Music_HallOfFame_Ch2
	channel 3, Music_HallOfFame_Ch3
	channel 4, Music_HallOfFame_Ch4

Music_HallOfFame_Ch1:
	tempo $70
	dutycycle $2
	notetype $c, $c7
	vibrato $c, $22
	octave 1
	note G_, 2
	note __, 12
	notetype $6, $c7
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	notetype $c, $c7
	note G_, 2
	note __, 6
	note G_, 2
	note __, 2
	note G_, 2
	note __, 2
	note G_, 2
	note __, 8
	note G_, 2
	note __, 2
	note G_, 2
	note F_, 2
	note __, 10
	intensity $97
	octave 3
	note D_, 1
	note E_, 1
	note F_, 1
	note F#, 1
	octave 4
	note C_, 16
	note E_, 16
	note F#, 16
	note F_, 8
	octave 3
	note F_, 1
	note G_, 1
	note A_, 1
	note B_, 1
	octave 4
	note C_, 1
	note D_, 1
	note E_, 1
	note F#, 1
	note G_, 16
	octave 5
	note D_, 8
	octave 4
	note A_, 8
	note B_, 16
	note F_, 8
	note A_, 8
	vibrato $10, $12
Music_HallOfFame_L1:
	note G_, 16
	note A_, 8
	octave 5
	note C_, 8
	octave 4
	note B_, 8
	note G_, 8
	note A_, 4
	note C_, 4
	note F_, 4
	note A_, 4
	dutycycle $0
	intensity $c5
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note G_, 10
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note G_, 4
	note A_, 4
	note D_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note G_, 10
	octave 3
	note A_, 2
	note A#, 2
	octave 4
	note C_, 2
	note F_, 4
	note G_, 6
	note D_, 2
	octave 3
	note G_, 2
	note B_, 2
	octave 4
	note D_, 2
	note D_, 2
	octave 3
	note G_, 2
	note B_, 2
	octave 4
	note D_, 2
	note C_, 2
	octave 3
	note F_, 2
	note A_, 2
	octave 4
	note C_, 2
	note C_, 2
	octave 3
	note F_, 2
	note A_, 2
	octave 4
	note C_, 2
	octave 3
	note B_, 2
	note D_, 2
	note G_, 2
	note B_, 2
	note B_, 2
	note D_, 2
	note G_, 2
	note B_, 2
	note A_, 2
	note A#, 2
	octave 4
	note C_, 2
	note D_, 2
	note F_, 1
	note G_, 1
	note A_, 1
	note A#, 1
	octave 5
	note C_, 1
	note D_, 1
	note E_, 1
	note F#, 1
	note G_, 8
	dutycycle $2
	intensity $c7
	octave 3
	note B_, 8
	note A_, 8
	octave 4
	note F_, 8
	octave 3
	note G_, 8
	octave 4
	note C_, 4
	note D_, 4
	note A#, 1
	note D#, 1
	octave 3
	note A#, 1
	note D#, 1
	note A#, 1
	octave 4
	note D#, 1
	note A#, 1
	octave 5
	note D#, 1
	note C_, 1
	octave 4
	note F_, 1
	note C_, 1
	octave 3
	note F_, 1
	octave 4
	note C_, 1
	note F_, 1
	octave 5
	note C_, 1
	note F_, 1
	octave 4
	note D_, 8
	octave 3
	note B_, 8
	note A_, 8
	octave 4
	note F_, 8
	octave 3
	note G_, 8
	octave 4
	note C_, 4
	note D_, 4
	note D#, 8
	note F_, 4
	intensity $97
	octave 3
	note C_, 1
	note F_, 1
	note A_, 1
	octave 4
	note C_, 1
	callchannel Music_HallOfFame_P1
	note A#, 1
	note G_, 1
	octave 4
	note D#, 1
	octave 3
	note A#, 1
	octave 4
	note G_, 1
	note D#, 1
	note A#, 1
	note G_, 1
	octave 5
	note D#, 1
	octave 4
	note A_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	note A_, 1
	note C_, 1
	note F_, 1
	octave 3
	note A_, 1
	callchannel Music_HallOfFame_P1
	octave 5
	note D#, 1
	octave 4
	note A#, 1
	note G_, 1
	note D#, 1
	octave 3
	note A#, 1
	note G_, 1
	note D#, 1
	octave 2
	note A#, 1
	arp $c, $0
	note F_, 1
	octave 3
	note C_, 1
	note F_, 1
	octave 4
	note C_, 1
	note F_, 1
	octave 5
	note C_, 1
	note F_, 1
	octave 6
	note C_, 1
	arp $0, $0
	octave 4
	note G_, 16
	note __, 16
	note G_, 16
	note F_, 16
	loopchannel 0, Music_HallOfFame_L1

Music_HallOfFame_Ch2:
	dutycycle $3
	notetype $c, $c4
	vibrato $8, $25
	octave 3
Music_HallOfFame_L2:
	callchannel Music_HallOfFame_P2
	loopchannel 6, Music_HallOfFame_L2
Music_HallOfFame_L3:
	callchannel Music_HallOfFame_P3
	note G_, 8
	note A_, 8
	callchannel Music_HallOfFame_P4
	callchannel Music_HallOfFame_P3
	note A#, 1
	note D#, 1
	octave 2
	note A#, 1
	note D#, 1
	note A#, 1
	octave 3
	note D#, 1
	note A#, 1
	octave 4
	note D#, 1
	note C_, 1
	octave 3
	note F_, 1
	note C_, 1
	octave 2
	note F_, 1
	octave 3
	note C_, 1
	note F_, 1
	octave 4
	note C_, 1
	note F_, 1
	octave 3
	callchannel Music_HallOfFame_P4
Music_HallOfFame_L4:
	callchannel Music_HallOfFame_P2
	loopchannel 4, Music_HallOfFame_L4
	loopchannel 0, Music_HallOfFame_L3

Music_HallOfFame_Ch3:
	notetype $c, $1c
	portadown $40
	octave 3
	note G_, 2
	note __, 14
	note G_, 2
	note __, 14
	note G_, 2
	note __, 14
	note G_, 2
	note __, 6
	intensity $15
	octave 2
	portadown $b
	note G_, 8
	callchannel Music_HallOfFame_P5
	note C_, 4
	callchannel Music_HallOfFame_P5
	note C_, 4
	callchannel Music_HallOfFame_P5
	note E_, 4
	callchannel Music_HallOfFame_P5
	note E_, 4
	callchannel Music_HallOfFame_P5
	note F#, 4
	callchannel Music_HallOfFame_P5
	note F#, 4
	callchannel Music_HallOfFame_P6
	note F_, 2
	callchannel Music_HallOfFame_P6
	note F_, 2
Music_HallOfFame_L5:
	callchannel Music_HallOfFame_P6
	loopchannel 4, Music_HallOfFame_L5
Music_HallOfFame_L6:
	callchannel Music_HallOfFame_P7
	callchannel Music_HallOfFame_P7
	callchannel Music_HallOfFame_P7
Music_HallOfFame_L7:
	callchannel Music_HallOfFame_P6
	note G_, 2
	loopchannel 12, Music_HallOfFame_L7
	callchannel Music_HallOfFame_P6
	note F_, 2
	callchannel Music_HallOfFame_P6
	note F_, 2
	callchannel Music_HallOfFame_P8
	note G_, 2
	note __, 16
	note __, 10
	portadown $0
	intensity $15
	octave 2
	note F_, 4
	note E_, 16
	note D#, 8
	note F_, 8
	note G_, 16
	note F_, 16
	note E_, 16
	callchannel Music_HallOfFame_P6
	note D#, 6
	callchannel Music_HallOfFame_P6
	note F_, 2
	intensity $1c
	portadown $40
	octave 3
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	callchannel Music_HallOfFame_P9
	callchannel Music_HallOfFame_P6
	note F_, 2
	callchannel Music_HallOfFame_P6
	note F_, 2
	callchannel Music_HallOfFame_P9
	callchannel Music_HallOfFame_P8
	loopchannel 0, Music_HallOfFame_L6

Music_HallOfFame_Ch4:
	notetype $c
	togglenoise $4
	note B_, 16
	note B_, 16
	note B_, 16
	note B_, 8
	note A#, 4
	note D_, 4
Music_HallOfFame_L8:
	note A#, 2
	note F#, 2
	note G#, 2
	note A_, 2
	note A#, 2
	note F#, 2
	note G#, 2
	note A_, 1
	note A_, 1
	loopchannel 3, Music_HallOfFame_L8
	note A#, 2
	note A_, 1
	note A_, 1
	note A#, 2
	note A_, 1
	note A_, 1
	note A#, 2
	note A#, 2
	note A#, 1
	note A#, 1
	note A#, 1
	note A#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
Music_HallOfFame_L9:
	callchannel Music_HallOfFame_P10
	callchannel Music_HallOfFame_P11
Music_HallOfFame_L10:
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	callchannel Music_HallOfFame_P10
	callchannel Music_HallOfFame_P11
	loopchannel 2, Music_HallOfFame_L10
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	callchannel Music_HallOfFame_P10
	callchannel Music_HallOfFame_P12
	note B_, 16
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	note __, 8
	note E_, 4
	note E_, 4
	note B_, 8
	note B_, 4
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note B_, 4
	callchannel Music_HallOfFame_P10
	callchannel Music_HallOfFame_P11
	note B_, 4
	callchannel Music_HallOfFame_P10
	callchannel Music_HallOfFame_P12
	note B_, 4
	loopchannel 0, Music_HallOfFame_L9

Music_HallOfFame_P1:
	note D_, 1
	octave 3
	note B_, 1
	octave 4
	note G_, 1
	note D_, 1
	note B_, 1
	note G_, 1
	octave 5
	note D_, 1
	octave 4
	note B_, 1
	octave 5
	note G_, 1
	octave 4
	note B_, 1
	octave 5
	note D_, 1
	octave 4
	note G_, 1
	note B_, 1
	note D_, 1
	note G_, 1
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	octave 3
	note A_, 1
	octave 4
	note F_, 1
	note C_, 1
	note A_, 1
	note F_, 1
	octave 5
	note C_, 1
	octave 4
	note A_, 1
	octave 5
	note F_, 1
	octave 4
	note A_, 1
	octave 5
	note C_, 1
	octave 4
	note F_, 1
	note A_, 1
	note C_, 1
	note F_, 1
	octave 3
	note A_, 1
	note B_, 1
	note G_, 1
	octave 4
	note E_, 1
	octave 3
	note B_, 1
	octave 4
	note G_, 1
	note E_, 1
	note B_, 1
	note G_, 1
	octave 5
	note E_, 1
	octave 4
	note G_, 1
	note B_, 1
	note E_, 1
	note G_, 1
	octave 3
	note B_, 1
	octave 4
	note E_, 1
	octave 3
	note G_, 1
	endchannel

Music_HallOfFame_P2:
	note G_, 2
	note D_, 2
	note G_, 2
	note A_, 10
	note G_, 2
	note D_, 2
	note G_, 2
	octave 4
	note C_, 4
	octave 3
	note B_, 4
	note A_, 2
	note G_, 2
	note D_, 2
	note G_, 2
	note A_, 10
	note F_, 2
	note C_, 2
	note F_, 2
	note A#, 4
	note A_, 4
	note F_, 2
	endchannel

Music_HallOfFame_P3:
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note G_, 6
	octave 3
	note B_, 2
	octave 4
	note C_, 2
	note D_, 4
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 4
	octave 3
	note G_, 2
	note A_, 2
	octave 4
	note E_, 4
	note C_, 2
	octave 3
	note B_, 2
	note G_, 4
	note A_, 4
	endchannel

Music_HallOfFame_P4:
	note B_, 2
	octave 4
	note C_, 2
	note D_, 2
	note G_, 4
	note G_, 2
	note A_, 2
	note G_, 2
	note D_, 4
	note C_, 2
	octave 3
	note B_, 2
	octave 4
	note C_, 4
	octave 3
	note G_, 2
	note A_, 2
	octave 4
	note C_, 4
	note D_, 2
	note E_, 2
	note G_, 4
	note A_, 4
	note A#, 2
	octave 5
	note D_, 1
	note C_, 1
	octave 4
	note G_, 2
	octave 5
	note C_, 1
	octave 4
	note G_, 1
	note F_, 2
	note A_, 1
	note G_, 1
	note D_, 2
	note G_, 1
	octave 5
	note D_, 1
	octave 3
	endchannel

Music_HallOfFame_P5:
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	note __, 2
	portadown $0
	intensity $15
	octave 2
	endchannel

Music_HallOfFame_P6:
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	endchannel

Music_HallOfFame_P7:
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	note G_, 2
	loopchannel 12, Music_HallOfFame_P7
.loop2
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	note F_, 2
	loopchannel 4, .loop2
	endchannel

Music_HallOfFame_P8:
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	note G_, 2
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	endchannel

Music_HallOfFame_P9:
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	note G_, 2
	loopchannel 4, Music_HallOfFame_P9
.loop2
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	note F_, 2
	loopchannel 4, .loop2
.loop3
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	note E_, 2
	loopchannel 4, .loop3
.loop4
	intensity $1c
	portadown $40
	octave 3
	note G_, 2
	portadown $0
	intensity $15
	octave 2
	note D#, 2
	loopchannel 2, .loop4
	endchannel

Music_HallOfFame_P10:
	note E_, 2
	note F#, 1
	note F#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note E_, 2
	note F#, 1
	note F#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note E_, 2
	note F#, 1
	note F#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note E_, 2
	note A#, 1
	note F#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note E_, 2
	note F#, 1
	note F#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note E_, 2
	note F#, 1
	note F#, 1
	note A#, 1
	note F#, 1
	note F#, 1
	note F#, 1
	note E_, 2
	note F#, 1
	note F#, 1
	note A#, 1
	endchannel

Music_HallOfFame_P11:
	note F#, 1
	note A#, 1
	note F#, 1
	note E_, 1
	note A#, 1
	note A#, 1
	note A#, 1
	endchannel

Music_HallOfFame_P12:
	note A#, 1
	note A#, 1
	note A#, 1
	note E_, 1
	note E_, 1
	note E_, 1
	note E_, 1
	endchannel
