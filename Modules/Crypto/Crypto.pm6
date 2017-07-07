#!/usr/bin/env perl6

#`<
TODO @ key_rng: Char @char
>

; use v6
; unit module Crypto

; sub key_gen(Str $file) is export {
	; my @line = $file.IO.lines;
	# csv header
	; my @field = {
		; for @_ {
			; $_ = "$0\n" if $_ ~~ /(.*)\:min/
			; $_ = ':' if $_ ~~ /^\:/
			; $_ = $0 if $_ ~~ /(.+)\:.*/
		}
		; @_
	}(split(',', shift @line).map({$_.trim}))
	; print @field.map({$_ ~ "\n"}).join
	# csv_liner
	; for @line {
		; $_ = split(',', $_)
	}
	; print @line.map({$_ ~ "--\n"}).join
#`<
	...
	__,(__,__),__
	'__',('__','__'),'__'
	...
	extract @char
	my @value
>
}

# all passwords support alphanumeric, but not all systems support special chars
# is time secure for rng? no, just leave it! perl is for the lazy...
; sub key_rng(
	UInt $min
	, UInt $max=$min
	, @char=(('0'..'9'), ('a'..'z'), ('A'..'Z')).flat
) is export {
	; return
		0 < $min <= $max
		?? @char.pick(rand * ($max - $min + 1) + $min).join
		!! 'ERR: RTFS!!!' # see~; lazy...
}
