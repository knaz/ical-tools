use strict;
use warnings;

#
# Bins
#

my $perl = $ENV{PERL} || 'perl';
$perl = `which $perl`;
chomp $perl;

#
# Carton
#

(my $carton = $perl) =~ s{/[^/]+\z}{/carton};
warn "No $carton\n" unless (-x $carton);

`mkdir -p bin`;

my @scripts = qw(
	ical-parse
	carton-install
);

for my $script (@scripts) {
	print "Doing src/$script\n";
	my $string = do {
		open my $in, "<", "src/$script";
		local $/;
		<$in>;
	};

	$string =~ s/{perlbin}/$perl/g;
	$string =~ s/{perlcarton}/$carton/g;

	open my $out, ">", "bin/$script"
		or die "Cannot open bin/$script for writing: $!\n";
	print $out $string;
	close $out;

	system("chmod +x bin/$script") == 0 or die "Could not +x bin/$script\n";
}
