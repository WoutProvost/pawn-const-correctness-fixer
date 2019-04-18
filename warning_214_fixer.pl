#!/usr/bin/perl
use strict;
use warnings;
use File::Spec;

# Check for at least 2 arguments
if(@ARGV < 2) {
	die "Usage: $0 SOURCE DESTINATION\n";
}

# Check if the source file and the destination file are equal
if($ARGV[0] eq $ARGV[1]) {
	die "The source file can not be the same as the destination file, to prevent losing the original.\n"
}

# Declare temporary files
my $amx_temp = "warning_214_fixer.amx";
my $warnings_temp = "warning_214_fixer.txt";

# Execute the compiler in a child process, redirecting stdout to trash and stderr to a temporary file
my $devnull = File::Spec->devnull();
system "pawncc $ARGV[0] -o$amx_temp > $devnull 2> $warnings_temp";

# Extract the line number and the string name from all lines containing 'warning 214' from the temporary stderr file
open INPUT, $warnings_temp or die "Can't open temporary file '$warnings_temp': $!.\n";
my %warnings;
my $amount = 0;
while(<INPUT>) {
	if(/\((\d+)\) : warning 214: possibly a "const" array argument was intended: "(.+)"$/m) {
		# Lines with more than one warning, will point to a list of strings
		push(@{$warnings{$1}}, $2);
		$amount++;
	}
}
close INPUT;

# Add 'const' in front of every string that needs it
open INPUT, $ARGV[0] or die "Can't open source file '$ARGV[0]': $!.\n";
open OUTPUT, ">$ARGV[1]" or die "Can't open destination file '$ARGV[1]': $!.\n";
foreach my $ln (sort {$a <=> $b} keys %warnings) {
	# The line numbers are sorted in ascending order, so we only need to go over the source file once
	while(<INPUT>) {
		if($ln == $.) {
			# Fix each string on the line
			foreach my $str (@{$warnings{$ln}}) {
				s/($str *\[.*?\])/const $1/;
			}
			# Output the line only once, after all the strings on that line are fixed
			print OUTPUT;
			last;
		} else {
			# Output other lines from the script
			print OUTPUT;
		}
	}
}
while(<INPUT>) {
	# Output leftover lines from the script
	print OUTPUT;
}
close INPUT;
close OUTPUT;

# Remove temporary files
unlink $amx_temp;
unlink $warnings_temp;

# Write message
print "Fixed warning 214 a total of $amount times.\n";