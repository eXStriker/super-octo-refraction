Music_PrismIceCave:
	dbw $C0, PrismIceCave_Ch1
	dbw $01, PrismIceCave_Ch2
	dbw $02, PrismIceCave_Ch3
	dbw $03, PrismIceCave_Ch4

PrismIceCave_Ch1::
	tempo 140
	volume $77
	dutycycle $2
	tone $0001
	vibrato $12, $23
	stereopanning $f0
	notetype $c, $b7
	octave 3
	note G_, 2
	note __, 6
	note F_, 2
	note __, 6
	note E_, 2
	note __, 6
	note F_, 2
	note __, 4
	note G_, 2
PrismIceCave_Ch1_sub_0:
	notetype $c, $b7
	octave 4
	note C_, 8
	octave 3
	note G_, 8
	callchannel PrismIceCave_Ch1_sub_2
	octave 3
	note A_, 8
	octave 4
	note C_, 8
	octave 3
	callchannel PrismIceCave_Ch1_sub_3
	octave 4
	note C_, 16
	octave 3
	note B_, 8
	note G_, 8
	callchannel PrismIceCave_Ch1_sub_4
	note G_, 8
	octave 4
	note D_, 8
	note C_, 8
	octave 3
	note A_, 8
	callchannel PrismIceCave_Ch1_sub_2
	note C_, 8
	octave 3
	note A_, 8
	callchannel PrismIceCave_Ch1_sub_3
	octave 4
	note C_, 16
	octave 3
	note B_, 8
	note G_, 8
	callchannel PrismIceCave_Ch1_sub_4
	note G_, 8
	note B_, 8
	octave 4
	intensity $40
	note C_, 4
	intensity $a0
	note E_, 4
	intensity $ff
	note D_, 8
	notetype $c, $b7
	octave 4
	note C_, 8
	octave 3
	note G_, 8
	callchannel PrismIceCave_Ch1_sub_2
	octave 3
	note A_, 8
	octave 4
	note C_, 8
	octave 3
	callchannel PrismIceCave_Ch1_sub_3
	octave 4
	note C_, 16
	octave 3
	note B_, 8
	note G_, 8
	callchannel PrismIceCave_Ch1_sub_4
	note G_, 8
	octave 4
	note D_, 8
	note C_, 8
	octave 3
	note A_, 8
	callchannel PrismIceCave_Ch1_sub_2
	note C_, 8
	octave 3
	note A_, 8
	callchannel PrismIceCave_Ch1_sub_3
	octave 4
	note C_, 16
	octave 3
	note B_, 8
	note G_, 8
	callchannel PrismIceCave_Ch1_sub_4
	note G_, 8
	note B_, 8
	loopchannel 0, PrismIceCave_Ch1_sub_0

PrismIceCave_Ch1_sub_2:
	dutycycle $1
	intensity $20
	octave 3
	note B_, 2
	intensity $30
	octave 4
	note C_, 2
	intensity $40
	octave 3
	note B_, 2
	intensity $50
	octave 4
	note C_, 2
	intensity $60
	octave 3
	note B_, 2
	intensity $70
	octave 4
	note C_, 2
	intensity $80
	octave 3
	note B_, 2
	intensity $90
	octave 4
	note C_, 2
	notetype $c, $b7
	dutycycle $2
	endchannel

PrismIceCave_Ch1_sub_3:
	dutycycle $1
	intensity $20
	note G_, 2
	intensity $30
	note A_, 2
	intensity $40
	note G_, 2
	intensity $50
	note A_, 2
	intensity $60
	note G_, 2
	intensity $70
	note A_, 2
	intensity $80
	note G_, 2
	intensity $90
	note A_, 2
	notetype $c, $b7
	dutycycle $2
	endchannel

PrismIceCave_Ch1_sub_4:
	dutycycle $1
	intensity $20
	note A_, 2
	intensity $30
	note B_, 2
	intensity $40
	note A_, 2
	intensity $50
	note B_, 2
	intensity $60
	note A_, 2
	intensity $70
	note B_, 2
	intensity $80
	note A_, 2
	intensity $90
	note B_, 2
	notetype $c, $b7
	dutycycle $2
	endchannel

PrismIceCave_Ch2::
	dutycycle $1
	vibrato $12, $23
	stereopanning $f
	notetype $c, $c7
	octave 4
	note G_, 8
	note A_, 8
	note E_, 4
	note C_, 4
	note D_, 8
PrismIceCave_Ch2_sub_0:
	callchannel PrismIceCave_Ch2_sub_1
	callchannel PrismIceCave_Ch2_sub_1
	intensity $40
	note E_, 4
	intensity $a0
	note G_, 4
	intensity $ff
	notetype $c, $c7
	note B_, 8
	note E_, 16
	note D_, 16
	note C_, 8
	note D_, 2
	note F_, 2
	note A_, 4
	note G_, 16
	note E_, 2
	note D_, 2
	note C_, 8
	note F_, 4
	note G_, 10
	note E_, 2
	note D_, 4
	note E_, 16
	note D_, 6
	note E_, 6
	note G_, 4
	note E_, 16
	note G_, 6
	note A_, 6
	note B_, 4
	note A_, 8
	note G_, 2
	note F_, 2
	note D_, 4
	octave 5
	note C_, 16
	octave 4
	note A_, 8
	note G_, 2
	note F_, 2
	note D_, 4
	note G_, 10
	note F_, 4
	note A_, 2
	note E_, 16
	note D_, 16
	loopchannel 0, PrismIceCave_Ch2_sub_0

PrismIceCave_Ch2_sub_1:
	notetype $c, $c7
	note E_, 16
	note G_, 16
	note A_, 8
	note G_, 2
	note F_, 2
	note D_, 4
	note B_, 16
	note A_, 8
	note G_, 2
	note F_, 2
	note D_, 4
	note G_, 10
	note F_, 4
	note A_, 2
	note E_, 16
	note D_, 16
	endchannel

PrismIceCave_Ch3::
	vibrato $0, $33
	notetype $c, $12
	octave 3
	note C_, 2
	note __, 4
	note E_, 2
	note C_, 2
	note __, 4
	note D_, 2
	note C_, 2
	note __, 4
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 2
	note C_, 2
	note __, 2
PrismIceCave_Ch3_sub_0:
	callchannel PrismIceCave_Ch3_sub_1
	; measure 19
	note C_, 2
	note __, 4
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 2
	note C_, 2
	note __, 2
	callchannel PrismIceCave_Ch3_sub_1
	loopchannel 0, PrismIceCave_Ch3_sub_0

PrismIceCave_Ch3_sub_1:
	note __, 4
	note C_, 4
	note E_, 2
	note D_, 2
	note C_, 4
	note F_, 4
	note C_, 4
	note D_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 6
	note C_, 4
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note __, 2
	note D_, 2
	note __, 2
	note C_, 2
	note __, 6
	note C_, 4
	note E_, 2
	note D_, 2
	note C_, 4
	note F_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 4
	note D_, 4
	note C_, 2
	note __, 6
	note C_, 2
	note __, 2
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	octave 3
	note C_, 2
	note __, 6
	note C_, 4
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 4
	note F_, 2
	note D_, 2
	note C_, 4
	note D_, 4
	note C_, 2
	note __, 6
	note C_, 2
	note __, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note __, 2
	note E_, 2
	note __, 2
	note C_, 2
	note __, 2
	note D_, 2
	note __, 2
	note C_, 2
	note __, 6
	note C_, 4
	note E_, 2
	note D_, 2
	note C_, 4
	note F_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 4
	note D_, 4
	note C_, 2
	note __, 6
	note C_, 2
	note __, 2
	note E_, 2
	octave 2
	note B_, 2
	octave 3
	note C_, 2
	note __, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	octave 3
	note C_, 2
	note __, 2
	endchannel

PrismIceCave_Ch4:
	togglenoise $3
	notetype $c
	note __, 16
	note __, 16
PrismIceCave_Ch4_sub_0:
	callchannel PrismIceCave_Ch4_sub_1
	callchannel PrismIceCave_Ch4_sub_1
	note __, 16
	callchannel PrismIceCave_Ch4_sub_1
	callchannel PrismIceCave_Ch4_sub_1
	loopchannel 0, PrismIceCave_Ch4_sub_0

PrismIceCave_Ch4_sub_1:
	note __, 16
	note __, 16
	note __, 8
	note B_, 8
	note E_, 4
	note E_, 4
	note __, 8
	note E_, 4
	note E_, 4
	note B_, 8
	note E_, 4
	note E_, 4
	note B_, 8
	note E_, 2
	note F#, 2
	note E_, 4
	note B_, 8
	note E_, 2
	note F#, 2
	note E_, 4
	note B_, 8
	endchannel
