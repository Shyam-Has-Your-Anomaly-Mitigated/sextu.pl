#!/usr/bin/env perl6
; use v6.c
; unit module Ethics
; print [
	'#!/usr/bin/env perl6'
	, '#`[ℝeal Perl Programmers] use Ethics;'
	, '=begin comment'
	, [
		#`<
			let the error messages GUIDE you... 🖖
			I haven't even done a single tutorial yet
			and I'm already hacking away! :D -- JAPH
		>
		'DON\'T PANIC'
		#`{
			#`(ℝeal PerlX Programmers) use PerlX;
			ERR: 'Perl is a builtin type, not an external module'
		}
		, 'use Perl'
		# Larry Wall @ 1997
		, 'prefer things to be visually distinct'
		# https://en.wikipedia.org/wiki/Learning_Perl
		, 'don\'t use indices'
		# ; my $TMTOWTDI = 'There's More Than One Way To Do It'
		, 'know Tim Toady'
		# ; my $TOTSS = 'The One-True-Syntax Syndrome'
		, 'don\'t have TOTSS'
		# recursion
		, 'use Ethics'
	].map({"\tℝeal Perl Programmers " ~ $_ ~ ", or die;\n"}).join
	~ '=end comment'
].map({
	# ; my $terminal = 'overlapping chars'
	; s:g/ℝ/R/
	; $_ ~ "\n"
}).join
