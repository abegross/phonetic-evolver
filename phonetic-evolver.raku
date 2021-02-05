use lib ".";
use parser;
use actions;
#use evaluator;
use Terminal::ANSIColor;

#say Parser.parse("u → o; lj becomes j when _#; V# > ∅");
#my @tests = [
	#"V# > ∅", 
	#"'o >we", 
	#"# we → gwe  // we becomes gwe at the beginning of words", 
	#"pt becomes p / !_V",
	#"l -> l̥͡l / [+consonant -voice] __",
	#"// /t/ and /d/ are flapped when they occur after a stressed vowel and before a stressless vowel",
	#"[stop consonant alveolar] → ɾ / [+vowel +stressed] ___ [+vowel -stressed]",
	#'t → ∅ / !Vː_#',
	#'t → ∅ / ! Vː _ #',
	#'f * > 2:F -',
	#'[vowel] # becomes silent',
	#q{'SSS → 'S [-V] S},
	#q{[-continuant  -voice] -> [+spread glottis] / ! s ___ [-syllabic -stress]},
	#'[stop] → [nasal] / _ [nasal]',
	#'[stop]  [nasal] → α:[nasal] 2',
	#'[ʃ, ʒ, t͡ʃ, d͡ʒ] becomes [s, z, t͡s, d͡z] when _ [s, z] ',
	#'a{be}d > acd',
	#'x{y(z)} > acd',
	#'x({yz}) > acd',
	#'V → [+tense] / — {# V C{i e}V} ',
	#'V → [-back] / ___ C₀ V[+high -back]',
	#'V → [-back] / ___ C₀³ V[+high -back]',
	#'V → [-back] / ___ C⁵₄ V[+high -back]',
	#'[-anterior -continuant <-voice>] → [+coronal +strident <+anterior +continuant>] / _ [+V +S]'
#];

#DOC CHECK {
	my @tests1 = [
		# alabama 
		["a > e", "elebeme"],
		["a → e", "elebeme"],
		["a → zd", "zdlzdbzdmzd"],
		["a -> b; l -> m", "bmbbbmb"],
		["a > e / _ b", "alebama"],
		["a > e / b _", "alabema"],
		["a > e / a l _ b", "alebama"],
		["a > e / #_", "elabama"],
		["a > e / #_;l→m;", "emabama"],
		["l > e / #a _", "aeabama"],
		["l > e / #_ a", "alabama"],
		["a > g / c _#", "alabama"],
		["a > g / _#", "alabamg"],
		["ba > ab ", "alaabma"],
		['{b,m} > p', "alapapa"],
		['a > e / _{b,m}', "alebema"],
		['V > e', "elebeme"],
		['C > z', "azazaza"],
		['V > e / C _', "alebeme"],
		['V > e / C _ m', "alabema"],
		["ba -> gz / la _", "alagzma"],
		["ba -> gz / #ala _", "alagzma"],
		["ba -> gz / #al _", "alabama"],
		["l…b → b…l ", "abalama"],
		["l…b → b…l / a ___ ", "abalama"],
		["l…b → z…q ", "azaqama"],
		["l…b → b...l / _a ", "abalama"],
		["l…b → b...l / _b ", "alabama"],
		["al…am → am…ab / #_", "amababa"],
		["l…b → b...l / _ma ", "alabama"],
		["l…a → z…q ", "azabqma"],
		["a…m → z…q", "alzbaqa"],
		["a…m → z…q / #_", "zlabaqa"],
		["a…b → z…q / #_ ", "zlaqama"],
		["a…b → z…q / #_ ; qa -> bz/_z", "zlaqama"],
		["a…b → z…q / #_ ; qa -> bz/_ma#", "zlabzma"],
		["a…m → z…q / #_ ; ba -> gz / #zla _", "zlagzqa"],
		['C > ∅', "aaaa"],
		['a→z/{l,m} _;C>∅/a _', "azbaz"],
	];

	my @tests2 = [
		#topgord
		['o > e / _ C₀', "tepgerd"],
		['o > e / _ C₀#', "topgerd"],
		['o > e / _ C₁³', "tepgerd"],
		['o > e / _ C³₁', "tepgerd"],
		['o > e / _ C₂', "tepgerd"],
		['o > e / _ C₂#', "topgerd"],
		['o > e / _ C₃', "topgord"],
		['o > e / _ C₀g', "tepgord"],
		['o > e / _ C₀d', "topgerd"],
		['o > e // g', "topgerd"], # when neighboring 'g'
		['p>g;o > e // g', "teggerd"],
		['r > g // d #', "topgogd"],
		['r > g // z #', "topgord"],
		['o > e / X₂_', "topgerd"], # when preceded by 2 of anything
		['o > e / _ (p)', "tepgerd"],
		['o > e / _(C)', "tepgerd"],
		['o > e / _(C)#', "topgord"],
		['o > e / _(CC)#', "topgerd"],
		['o > e / _(C)(C)#', "topgerd"],
		['∅ > at / #C_', "tatopgord"],
	];

	my @tests3 = [
		["N > z", "zztʰaz"],
		["[+nasal] > z", "zztʰaz"],
		["[+stop] > z", "nãzʰaŋ"],
		["n > [+stop]", "dãtʰaŋ"],
		["ŋ → g; n > [+stop]", "dãtʰag"],
		#["[+aspirated] > z", "nãzaŋ"],
		["[+nasal] > [+stop]", "dãtʰag"],
		["[voiced] > [voiceless]", "n̥ãtʰaŋ̥"],
		["[+nasal] > [+stop]; [voiced] > [voiceless]", "tãtʰak"],
		["[+nasal] > [+stop] / _#", "nãtʰag"],
		#["[-voiced] > [velar]", "nãkʰaŋ"],
	];

	my @tests4 = [
		['CC > 2 1', "togpodr"],
		['CC > @@', "topgpgordrd"],
		['X₁ > @@', "topgordtopgord"],
		['X > @@', "ttooppggoorrdd"],
		['CVC > @@', "toptopgorgord"],
	];
	my @tests5 = [
		# æftɚ
		['f X > 2:F -', 'æθ̠tɚ'],
	];
	my @tests6 = [
		# mitigate
		#['t > d / V1 _ V1', 'midigate'],
		##plato
		#'∅ > C1 V1 / #_C1 C2 V1', # paplato
	];
	my @errors = [
		['C > 1 / _ _ # ', 'topgord'],
		['C > {b,m} / _ # ', 'topgord'],
	];

	run-test("alabama", @tests1);
	run-test("topgord", @tests2);
	run-test("nãtʰaŋ", @tests3);
	run-test("topgord", @tests4);
	#run-test("æftɚ", @tests5);
	#run-test("mitigate", @tests5);
	#run-test('topgord', @errors);

	sub run-test($word, @tests) {
		say "#####################################";
		say $word;
		for @tests -> $test {
			my $parse = Parser.parse($test[0], actions=>Actions.new(word=>$word));
			#my $eval = Evaluator.new(word=>$word);
			#$eval.eval($parse.made);
			#say $parse;
			if $parse.made eq $test[1] {
				say colored("OK","black on_green"), " $parse = $test[1]";
			} else {
				say colored("NOT OK","white on_red"), " $parse = {$parse.made}, ≠ $test[1]";
			}
		}
	}
#}

#say Parser.parse("l…b → b...l / _ma ");
