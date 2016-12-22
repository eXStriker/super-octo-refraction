Music_Evolution: ; f06e1
	channelcount 4
	channel 1, Music_Evolution_Ch1
	channel 2, Music_Evolution_Ch2
	channel 3, Music_Evolution_Ch3
	channel 4, Music_Evolution_Ch4
; f06ed

Music_Trade:
	channelcount 4
	channel 1, Music_Trade_Ch1
	channel 2, Music_Trade_Ch2
	channel 3, Music_Trade_Ch3
	channel 4, Music_Trade_Ch4

Music_Trade_Ch1:
	tempo 132
	volume $77
	vibrato $6, $34
	tone $0001
	octave 3
	jumpchannel Music_Evolution_Trade_Ch1

Music_Evolution_Ch1: ; f06ed
	tempo 132
	volume $77
	vibrato $6, $34
	tone $0001
	dutycycle $2
	notetype $c, $92
	octave 3
	slidepitchto 1, 4, A_
	note C_, 1
	slidepitchto 1, 4, A_
	note G_, 1
	slidepitchto 1, 4, A_
	note C_, 1
	slidepitchto 1, 4, A_
	note G_, 1
	note __, 4
Music_Evolution_Trade_Ch1:
	dutycycle $3
	stereopanning $f
.loop: ; f0713
	callchannel .BranchGMajor
	notetype $c, $a4
	note F#, 4
	callchannel .BranchGMajor
	notetype $c, $a4
	note F#, 4
	loopchannel 2, .loop
.loop2
	callchannel .BranchAMajor
	notetype $c, $a4
	note G#, 4
	callchannel .BranchAMajor
	notetype $c, $a4
	note G#, 4
	loopchannel 0, .loop2
; f0737

.BranchGMajor: ; f0737
	notetype $c, $a2
	octave 3
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C_, 4
	endchannel
; f0743

.BranchAMajor: ; f0743
	notetype $c, $a2
	octave 3
	note D_, 4
	note A_, 4
	note D_, 4
	note A_, 4
	note D_, 4
	note A_, 4
	note D_, 4
	endchannel
; f074f

Music_Trade_Ch2:
	vibrato $8, $25
	jumpchannel Music_Evolution_Trade_Ch2

Music_Evolution_Ch2: ; f074f
	dutycycle $2
	vibrato $8, $25
	notetype $c, $a2
	octave 4
	note G_, 1
	note D_, 1
	note G_, 1
	note D_, 1
	note __, 4
Music_Evolution_Trade_Ch2:
	dutycycle $3
	stereopanning $f0
.loop: ; f0761
	callchannel .BranchGMajor
	notetype $c, $b5
	note A_, 4
	callchannel .BranchGMajor
	notetype $c, $b5
	note B_, 4
	loopchannel 2, .loop
.loop2
	callchannel .BranchAMajor
	notetype $c, $b5
	note B_, 4
	callchannel .BranchAMajor
	notetype $c, $b5
	octave 4
	note C#, 4
	octave 3
	loopchannel 0, .loop2
; f0787

.BranchGMajor: ; f0787
	notetype $c, $b2
	octave 3
	note G_, 4
	note D_, 4
	note G_, 4
	note D_, 4
	note G_, 4
	note D_, 4
	note G_, 4
	endchannel
; f0793

.BranchAMajor: ; f0793
	notetype $c, $b2
	octave 3
	note A_, 4
	note E_, 4
	note A_, 4
	note E_, 4
	note A_, 4
	note E_, 4
	note A_, 4
	endchannel
; f079f

Music_Trade_Ch3:
	notetype $c, $16
	jumpchannel Music_Evolution_Trade_Ch3

Music_Evolution_Ch3: ; f079f
	notetype $c, $16
	note __, 8
Music_Evolution_Trade_Ch3:
.loop: ; f07a3
	callchannel .BranchGMajor
	octave 3
	note A_, 4
	callchannel .BranchGMajor
	octave 3
	note B_, 4
	loopchannel 2, .loop
.loop2
	callchannel .BranchAMajor
	octave 3
	note B_, 4
	callchannel .BranchAMajor
	octave 4
	note C#, 4
	loopchannel 0, .loop2
; f07bf

.BranchGMajor: ; f07bf
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note D_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note D_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note D_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	endchannel
; f07d5

.BranchAMajor: ; f07d5
	octave 2
	note B_, 2
	note __, 2
	octave 3
	note E_, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	octave 3
	note E_, 2
	note __, 2
	octave 2
	note B_, 2
	note __, 2
	octave 3
	note E_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	endchannel
; f07eb

Music_Trade_Ch4:
	togglenoise $5
	notetype $c
	jumpchannel Music_Evolution_branch_f07f0

Music_Evolution_Ch4: ; f07eb
	togglenoise $5
	notetype $c
	note __, 8
Music_Evolution_branch_f07f0: ; f07f0
	stereopanning $f0
	note A#, 6
	note A#, 4
	stereopanning $f
	note E_, 2
	note E_, 2
	note E_, 2
	loopchannel 0, Music_Evolution_branch_f07f0
; f07fd
