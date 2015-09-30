#!/usr/bin/env perl -w

# phase_shift_osc.pl
# Phase Shift oscillator frequency calculator.

use strict;
use warnings;
use Math::Trig;

sub calc_freq {
	my ($r, $c) = @_;
	my $freq = 1 / (2 * pi * $r * $c * sqrt(6));

	return $freq;
}

print calc_freq($ARGV[0], $ARGV[1]) . "\n";
