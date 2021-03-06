#!/usr/bin/env perl6
; use v6.c
; use MONKEY-SEE-NO-EVAL
; unit module Keypto

# CSV files are lines/records of values/fields
; sub key_gen(Str $csv_file) is export {
	; $csv_file ~~ /^(.+)\.csv$/
	; my Str $key_file = "$0_" ~ DateTime.now.posix ~ ".key"
	; my Str @line = $csv_file.IO.lines
	; my Str $message
	# WTF negating regex in the matchspace
	; if @line[0] !~~ /\,/ {
		; $message = shift @line
		# WTF just ignore the whitespace!?!
		#; $message ~~ s:g/\\(.)/\ $0/
		; $message ~~ s:g/\\n/\n/
		; $message ~~ s:g/\\t/\t/
	}
	; my Str @header = split(/\,/, shift @line).map({; .trim})
	; my UInt ($keydex, $yekdex)
	; my Bool $key = (@header ~~ /^(.*\:)?key$/).Bool
	# WTF /^(.*\:)?key$/ ∈ @header
	; if $key {
		# FREE
		; $keydex = @header.grep(/^(.*\:)?key$/, :k)[0]
		; $yekdex = @header -$keydex -1
	}
	; @header = @header.map({; s/^(.*)\:.*$/$0/; $_})
	; my Str @format = split(/\,/, shift @line).map({
		; my $tmp = $_.trim
		# WTF just ignore the whitespace!?!
		#; $tmp ~~ s:g/\\(.)/\ $0/
		; $tmp ~~ s:g/\\n/\n/
		; $tmp ~~ s:g/\\t/\t/
		; $tmp
	})
	; my Str $gen = "Generated by Keypto at " ~ DateTime.now ~ ($message.chars?? $message!! '')
	# map is just a for-each loop, right?
	; @line.map({
		# TODO need to handle the key via *dex
		; my Str @value_tmp = split(/\,/, $_).map({; .trim})
		; my @value =
			$key
			??
				$keydex == 0
				?? [
					@value_tmp.splice($keydex, @value_tmp -$yekdex).join(',')
					, |@value_tmp
				] !! [
					|@value_tmp.splice(0, $keydex)
					, @value_tmp.splice(0, @value_tmp -$yekdex).join(',')
					, |@value_tmp
				]
			!!
				@value_tmp
		; my UInt ($min, $max) = 0, 0
		; my Bool ($charray, $vallay)
		; my @charray
		; if $key {
			; my UInt $charraydex = @value[$keydex].index('(') // @value[$keydex].chars
			; my UInt $rangedex = @value[$keydex].index('-') // $charraydex
			; $min = @value[$keydex].substr(0, $rangedex).Int
			; $max =
				$rangedex != $charraydex
				?? @value[$keydex].substr($rangedex +1, $charraydex -$rangedex -1).Int
				!! $min
			; @charray = EVAL(@value[$keydex].substr($charraydex)).List.flat
			; @value[$keydex] = @charray == [Any]?? Nil!! @charray
			; $vallay = Nil ∉ @charray
		}
		; my ($headex, $valdex)
		; my @fmt = @format
		; for 0..@header -($charray?? 2!! 1) {
			; if 1 < +@fmt || @fmt[0] ~~ /\%S/ {
				; $headex = @fmt[0].index('%S')
				; $valdex = @fmt[0].index('%s')
				; @fmt[0] ~~ s/\%S/%s/
			}
			; if $_ == $keydex && 0 < $min <= $max {
				; if $headex && $valdex  {
					; if $headex < $valdex {
						; $gen ~= sprintf(@fmt[0], @header[$_], (
							@charray != [Any]
							?? key_rng($min, $max, @charray)
							!! key_rng($min, $max)
						))
					} else {
						; $gen ~= sprintf(@fmt[0], (
							@charray != [Any]
							?? key_rng($min, $max, @charray)
							!! key_rng($min, $max)
						), @header[$_])
					}
				} else {
					; $gen ~= sprintf(@fmt[0], $headex?? @header[$_]!! (
						@charray != [Any]
						?? key_rng($min, $max, @charray)
						!! key_rng($min, $max)
					))
				}
			} elsif @value[$_] {
				# TODO write "m", so min it's represented by a single Char; even without a file extension!
				# TODO blame me, compare blame backwards, automate the process
				; $gen ~= sprintf(@fmt[0], ($headex && $valdex?? |(
					$headex < $valdex
					?? (@header[$_], @value[$_])
					!! (@value[$_], @header[$_])
				)!! ($headex?? @header[$_]!! @value[$_])))
			}
			; if 1 < +@fmt {; shift @fmt}
		}
		; $gen ~= $message.chars?? $message!! ''
	})
	; spurt $key_file, $gen
}

#`[
	all passwords support alphanumeric, but not all systems support special chars
	is time secure for rng? no; temporal observations lead to lhermal observations lead to patterns
]
; sub key_rng(
	UInt $min
	, UInt $max = $min
	, @charray = (|('0'..'9'), |('a'..'z'), |('A'..'Z'))
) is export {
	; return
		0 < $min <= $max
		?? @charray
			.map({
				; .chars == 1 or die "\e[31mERR:\e[0m @charray must be a List of Char...\n\t@charray = @charray[]"
				; $_
			})
			.roll(rand ×($max -$min +1) +$min)
			.join
		!! die "\e[31mERR:\e[0m [\$min, \$max] = [$min, $max] | 0 < $min <= $max"
}

#`<
	; my $viminals = <ACHTUNG ATTN ATTENTION FIXME NB TODO TBD WTF XXX NOTE>
	; my ($index, $outdex)
	; my @rray = <a b c d e f g>
	# 'c' dex
	; $index = 2
	; $outdex = 4
>
