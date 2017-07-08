#!/usr/bin/env perl6

#`<
TODO @ key_rng: Char @char
WTF I found another viminal
>

; use v6
; use MONKEY-SEE-NO-EVAL
; unit module Keypto

; sub key_gen(Str $csv) is export {
	; my @line = $csv.IO.lines;
	# csv header
	; my @field = {
		; for @_ {
			; $_ = "$0\n" if $_ ~~ /(.+)\:min/
			; $_ = ':' if $_ ~~ /^\:/
			; $_ = $0 if $_ ~~ /(.+)\:.*/
		}
		; @_
	}(split(',', shift @line).map({.trim}))
	; $_ = @field.grep('charray',:k)[0]
	; my $outdex = @field - $_ - 1
	; my $index = $_
	; @field.push: @field.splice($_, 1)
	# csv_liner
	; $csv ~~ /(.+)\.csv/
	; my $key = "$0.key"
	; my $gen
	; for @line {
		; my @value_tmp = split(',', $_).map({.trim})
		; my @value =
			$index == 0
			?? [
				|@value_tmp.splice(@value_tmp - $outdex, @value_tmp - 1)
				, @value_tmp
			] !! [
				|@value_tmp.splice(0, $index)
				, |@value_tmp.splice(@value_tmp - $outdex, @value_tmp - 1)
				, @value_tmp
			]
		# WTF
		; @value[* - 1] = EVAL(@value[* - 1].join(',')).map({.flat}).flat
		# primary key is ':'
		# key_rng() has \n
		# @charray is at the end
		#.map({.trim})
		; my @gotcha
		; @gotcha.push((@field.grep: /^\:$/, :k)[0])
		; $gen ~= @value[@gotcha[* - 1]] ~ "\n"
		; @gotcha.push((@field.grep: /.+\n/, :k)[0])
		; $gen ~= "\t" ~ @field[@gotcha[* - 1]].chop ~ ': '
		; if 'max' ∈ @field {
			; @gotcha.push((@field.grep: /max/, :k)[0])
			; $gen ~=
				'charray' ∈ @field
				?? key_rng(+@value[@gotcha[* - 2]], +@value[@gotcha[* - 1]], @value[* - 1])
				!! key_rng(+@value[@gotcha[* - 2]], +@value[@gotcha[* - 1]])
		} else {
			; $gen ~=
				'charray' ∈ @field
				?? key_rng(+@value[@gotcha[* - 1]], +@value[@gotcha[* - 1]], @value[* - 1])
				!! key_rng(+@value[@gotcha[* - 1]])
		}
		; @gotcha.reverse.map({; @field.splice($_, 1); @value.splice($_, 1)})
		; @value.pop
		; @field.pop
		; $gen ~= "\n"
		; say ''
		; say @gotcha
		; say @field.map({$_~"\n"}).flat
		; say @value.map({$_~"\n"}).flat
	}
	; spurt $key, $gen
}

# https://irclog.perlgeek.de/perl6/2017-07-08
; subset Char of Str where .chars == 1
# all passwords support alphanumeric, but not all systems support special chars
# is time secure for rng? no, just leave it! perl is for the lazy...
; sub key_rng(
	UInt $min
	, UInt $max=$min
	, @char=(|('0'..'9'), |('a'..'z'), |('A'..'Z'))
	#, @char=(('0'..'9'), ('a'..'z'), ('A'..'Z')).flat
) is export {
	; return
		0 < $min <= $max
		?? @char.roll(rand * ($max - $min + 1) + $min).join
		!! 'ERR: RTFS!!!' # see~; lazy...
}
