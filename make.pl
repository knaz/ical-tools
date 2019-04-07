use strict;
use warnings;

#
# Bins
#

my $perl = $ENV{PERL} || 'perl';
$perl = `which $perl`;
chomp $perl;

`mkdir -p bin`;

my @scripts = qw(
	ical-parse
);

for my $script (@scripts) {
	my $string = do {
		open my $in, "<", "src/ical-parse";
		local $/;
		<$in>;
	};

	$string =~ s/{perlbin}/$perl/g;

	open my $out, ">", "bin/ical-parse";
	print $out $string;
}

#
# Carton
#

(my $carton = $perl) =~ s/\bperl\z/carton/;
if (!-x $carton) {
	warn "No $carton\n";
	exit;
}
