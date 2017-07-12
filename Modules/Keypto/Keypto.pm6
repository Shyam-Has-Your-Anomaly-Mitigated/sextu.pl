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
			; $_ = "$0\n" if $_ ~~ /^(.+)\:min$/
			; $_ = ':' if $_ ~~ /^\:.*$/
			; $_ = $0 if $_ ~~ /^(.+)\:.*$/
		}
		; @_
	}(split(',', shift @line).map({; .trim}))
	; my $charray = 'charray' ∈ @field
	; my ($index, $outdex)
	; if $charray {
		; $index = @field.grep('charray', :k)[0]
		; $outdex = @field -$index -1
		; @field.push: @field.splice($index, 1)
	}
	# csv_liner
	; $csv ~~ /^(.+)\.csv$/
	; my $key = "$0_" ~ DateTime.now.posix ~ ".key"
	; my $magic = "\n\n¿¿¿TIME TO RESET???\n"
	; my $gen = "LAST RESET @ " ~ DateTime.now ~ $magic
	; for @line {
		; my @value_tmp = split(',', $_).map({; .trim})
		; my @value =
			$charray
			??
				$index == 0
				?? [
					|@value_tmp.splice(@value_tmp -$outdex, @value_tmp -1)
					, @value_tmp
				] !! [
					|@value_tmp.splice(0, $index)
					, |@value_tmp.splice(@value_tmp -$outdex, @value_tmp -1)
					, @value_tmp
				]
			!!
				@value_tmp
		; my $vallay
		; if $charray {
			; @value[* -1] = EVAL(@value[* -1].join(',')).List.flat
			; if $charray {
				# WTF WTF
				; @value[@field.grep('charray', :k)[0]] = @value[@field.grep('charray', :k)[0]].List
				; $vallay = Nil ∉ @value[@field.grep('charray', :k)[0]]
			}
		}
		# primary key is ':'
		# key_rng() has \n
		# @charray is at the end
		; my @gotcha
		; @gotcha.push((@field.grep: /^\:$/, :k)[0])
		; $gen ~= "\n" ~ @value[@gotcha[* -1]]
		; @gotcha.push((@field.grep: /^.+\n$/, :k)[0])
		; $gen ~= "\n\t" ~ @field[@gotcha[* -1]].chop ~ ': '
		; if 'max' ∈ @field {
			; @gotcha.push((@field.grep: /^max$/, :k)[0])
			; $gen ~=
				$vallay
				?? key_rng(+@value[@gotcha[* -2]], +@value[@gotcha[* -1]], @value[* -1])
				!! key_rng(+@value[@gotcha[* -2]], +@value[@gotcha[* -1]])
		} else {
			; $gen ~=
				$vallay
				?? key_rng(+@value[@gotcha[* -1]], +@value[@gotcha[* -1]], @value[* -1])
				!! key_rng(+@value[@gotcha[* -1]])
		}
		; for 0..@field -($charray?? 2!! 1) {
			; $gen ~= "\n\t@field[$_]: @value[$_]" if $_ ∉ @gotcha && @value[$_].chars
		}
		; $gen ~= $magic
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
		?? @char.roll(rand ×($max -$min +1) +$min).join
		!! 'ERR: RTFS!!!' # see~; lazy...
}
