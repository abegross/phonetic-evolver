use Test;

test-file($_) for dir('t').sort;

done-testing;

sub test-file($file) {
	my $path = $file.path;

	my $proc = run('raku ./ipa-chart.p6', $path, :out, :err);

	is(expected($path), $proc.out.slurp, $path);
}

sub expected($path) {
	my $expected;
	for $path.IO.lines -> $line {
		$line ~~ /'##'\s*(\N*)/;
		next unless $0;
		$expected ~= "$0\n";
	}
	
	return $expected;
}
