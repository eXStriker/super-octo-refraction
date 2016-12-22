Music_PrismFemaleTrainer:
	dbw $C0, PrismFemaleTrainer_Ch1
	dbw $01, PrismFemaleTrainer_Ch2
	dbw $02, PrismFemaleTrainer_Ch3
	dbw $03, PrismFemaleTrainer_Ch4

PrismFemaleTrainer_Ch1::
	tempo 134
	volume $77
	vibrato $10, $23
	dutycycle $1
	notetype $c, $c7
	tone $0003
	note __, 8
PrismFemaleTrainer_Ch1_sub_0:
	octave 2
	note G_, 1
	note __, 1
	note G_, 1
	note __, 3
	note F_, 1
	note __, 1
	note G_, 1
	note __, 5
	note G_, 1
	note __, 1
	note C_, 1
	note __, 1
	note C_, 1
	note __, 3
	note C_, 1
	note __, 1
	note C_, 1
	note __, 5
	note C_, 1
	note __, 1
	loopchannel 0, PrismFemaleTrainer_Ch1_sub_0

PrismFemaleTrainer_Ch2::
	vibrato $12, $25
	dutycycle $1
	notetype $c, $b1
	tone $0002
	note __, 8
PrismFemaleTrainer_Ch2_sub__0
	octave 3
	note B_, 2
	note F_, 2
	note A_, 2
	note G_, 2
	note B_, 2
	note F_, 2
	note A_, 2
	note B_, 2
	octave 4
	note C_, 2
	octave 3
	note F_, 2
	note A_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note F_, 2
	note A_, 2
	note G_, 2
	loopchannel 0, PrismFemaleTrainer_Ch2_sub__0

PrismFemaleTrainer_Ch3::
	stereopanning $ff
	vibrato $8, $00
	notetype $c, $16
	octave 5
	note C_, 1
	note D_, 1
	note E_, 1
	note F_, 1
	note G_, 1
	note F_, 1
	note D_, 1
	note C_, 1
PrismFemaleTrainer_Ch3_sub_0:
	octave 5
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	vibrato $0, $33
	note E_, 4
	vibrato $8, $00
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	vibrato $0, $33
	note D_, 4
	vibrato $8, $00
	note D#, 1
	note E_, 1
	note F_, 1
	note F#, 1
	note G_, 2
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note G_, 1
	vibrato $0, $33
	note C_, 4
	vibrato $8, $00
	note G_, 2
	note E_, 2
	vibrato $0, $33
	note G_, 4
	vibrato $8, $00
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	vibrato $0, $33
	note A_, 4
	vibrato $8, $00
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 2
	note __, 1
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note E_, 1
	vibrato $0, $33
	note D_, 3
	vibrato $8, $00
	note __, 1
	loopchannel 0, PrismFemaleTrainer_Ch3_sub_0

PrismFemaleTrainer_Ch4:
	togglenoise $3
	notetype $c
	note __, 8
PrismFemaleTrainer_Ch4_sub_0:
	note D_, 2
	note D_, 2
	note C#, 1
	note C#, 1
	note C#, 1
	note C#, 1
	note __, 4
	note D_, 4
	loopchannel 0, PrismFemaleTrainer_Ch4_sub_0
