#!/usr/bin/env perl6

#`<
TODO @ key_rng: Char @char
>

; use v6
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
	}(split(',', shift @line).map({$_.trim}))
	; $_ = @field.index('charray')
	; my @index = $_ - 1, $_
	; @field.push: @field.splice($_ - 1, 1)
	# csv_liner
	; $csv ~~ /(.+)\.csv/
	; my $key = "$0.key"
	; spurt $key, ''
	; for @line {
		; my @value_tmp = split(',', $_).map({$_.trim})
		; my @value =
			@index[0]
			?? [
				|@value_tmp.splice(0,@index[0])
				, |@value_tmp.splice(@index[1] + 1, @value_tmp - 1)
				, @value_tmp
			] !! [
				|@value_tmp.splice(@index[1] + 1, +@value_tmp - 1)
				, @value_tmp
			]
		; @value[* - 1][* - 1] = @value[* - 1][* - 1].chop
		; @value[* - 1][0] = @value[* - 1][0].substr(1)
		; say @value.map({$_ ~ "\n"}).flat
		# key_rng() has \n
		# @charray is at the end
		; spurt $key, "test\n", :append
	}
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
		?? @char.pick(rand * ($max - $min + 1) + $min).join
		!! 'ERR: RTFS!!!' # see~; lazy...
}
