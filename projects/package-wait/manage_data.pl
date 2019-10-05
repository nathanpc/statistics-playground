#!/usr/bin/perl

use warnings;
use strict;
use autodie;

package Statistics::PackageWait::Manager;

use DBI;
use DateTime;
use Data::Dumper;
use Getopt::Long;
use Term::ANSIColor;
use DateTime::Format::ISO8601;

# Parses a raw data input file.
sub parse_raw_csv {
	my ($fname) = @_;
	my @entries;

	# Open input file.
	open(my $file, '<:encoding(UTF-8)', $fname);

	# Go through each line.
	while (my $line = <$file>) {
		# Strip newline.
		chomp $line;

		# Ignore empty lines and lines without any digits.
		if (($line =~ m/^\s*$/) || !($line =~ m/\d/)) {
			next;
		}

		# Parse columns.
		my @cols = split(/,/, $line);
		my %row = (
			origin      => $cols[0],
			destination => $cols[1],
			carrier     => $cols[2],
			shipped     => $cols[3],
			delivered   => $cols[4]
		);

		# Calculate the wait period.
		my $shipped = DateTime::Format::ISO8601->parse_datetime($row{shipped});
		my $delivered = DateTime::Format::ISO8601->parse_datetime($row{delivered});
		my $delta = $shipped->delta_days($delivered);
		$row{wait_period} = $delta->in_units("days");

		# TODO: Check if any key is undef and show errors.

		push @entries, \%row;
	}

	return @entries;
}

# Pushes a array of entries to the database.
sub populate_db {
	my ($dbh, $entries) = @_;

	for my $entry (@{$entries}) {
		# Insert data into database.
		my $sth = $dbh->prepare("INSERT INTO Packages(origin, destination,
								carrier, shipped,delivered, wait_period)
								VALUES (?, ?, ?, ?, ?, ?)");
		$sth->execute(
			$entry->{origin},
			$entry->{destination},
			$entry->{carrier},
			$entry->{shipped},
			$entry->{delivered},
			$entry->{wait_period}
		);
	}
}

# Program usage message.
sub usage {
	print "Usage: $0 [-i] [--csv filename]\n";
	print "\n";
	print "Options:\n";
	print "    -i --import\tImports some kinda of data (See 'Importing')\n";
	print "\n";
	print "Importing:\n";
	print "    --csv <filename>\tImports from a CSV file.\n";
}

# Main entry point.
sub main {
	my $import_data = 0;
	my $import_fn = "";

	# Get command line arguments.
	GetOptions(
		'import|i' => \$import_data,
		'csv=s' => \$import_fn
	);

	# Connect to the database.
	my $dbname = "data/database.db";
	my $dbh = DBI->connect("dbi:SQLite:dbname=$dbname", "", "",
						   { AutoCommit => 1, RaiseError => 1, PrintError => 0 })
		or die $DBI::errstr;

	# Check if the import data flag is set.
	if ($import_data) {
		print "Importing data...\n";

		# Check if we have some kind of data to import.
		if (!($import_fn eq "")) {
			# Raw data.
			print "Parsing raw CSV data... ";

			# Parse CSV.
			my @entries = parse_raw_csv($import_fn);
			print colored("OK", "green") . "\n";

			# Populate database.
			print "Appending data to database... ";
			populate_db($dbh, \@entries);
			print colored("OK", "green") . "\n";

			return;
		} else {
			# Nothing to import, show usage.
			usage();
		}
	} else {
		# No arguments given.
		usage();
	}
}

main();
1;

__END__

=head1 NAME

Statistics::PackageWait::Manager - A data manager for the package-wait project.

=head1 METHODS

=over 4

=item I<@entries> = C<parse_raw_csv>(I<$fname>)

Parses a CSV file given as I<$fname> and parses it, returning a array of each
valid entry.

B<IMPORTANT:> The CSV file must be in the following format:
Origin,Destination,Carrier,Shipping Date,Delivery Date,

=item C<populate_db>(I<$dbh>, I<\@entries>)

Pushes a entry list I<@entries> to the database and populates it using the
database handler I<$dbh>.

=item C<usage>()

Prints a simple usage message for the user.

=item C<main>()

The prorgam main entry point.

=back

=head1 AUTHOR

Nathan Campos <nathanpc@dreamintech.net>

=head1 COPYRIGHT

Copyright (c) 2019 Nathan Campos.

=cut
