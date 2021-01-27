use lib ".";
use parser;
use actions;
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

DOC CHECK {
	my @tests1 = [
		# alabama 
		#["a > e", "elebeme"],
		#["a → e", "elebeme"],
		#["a → zd", "zdlzdbzdmzd"],
		#["a -> b; l -> m", "bmbbbmb"],
		#["a > e / _b", "alebama"],
		#["a > e / b _", "alabema"],
		#["a > e / a l _ b", "alebama"],
		#["a > e / #_", "elabama"],
		#["a > e / #_;l→m;", "emabama"],
		#["l > e / #a _", "aeabama"],
		#["l > e / #_a", "alabama"],
		#["a > g / c _#", "alabama"],
		#["a > g / _#", "alabamg"],
		#["ba > ab ", "alaabma"],
		#['{b,m} > p', "alapapa"],
		#['a > e / _{b,m}', "alebema"],
		#['V > e', "elebeme"],
		#['C > z', "azazaza"],
		#['V > e / C_', "alebeme"],
		#['V > e / C_m', "alabema"],
		#['C > ∅', "aaaa"],
		["l…b → b…l ", "abalama"],
		["l…b → b…l / a ___ ", "abalama"],
		["l…b → z…q ", "azaqama"],
		["l…b → b...l / _a ", "abalama"],
		["l…b → b...l / _ma ", "alabama"],
		["l…a → z…q ", "azabqma"],
		["a…b → z…q", "alzbaqa"],
		["a…b → z…q / #_ ", "zlaqama"],
		["a…b → z…q / #_ ; qa -> bz/_z", "zlaqama"],
		["a…b → z…q / #_ ; qa -> bz/_ma#", "zlabzma"],
		["ba -> gz / #ala_", "alagzma"],
		#["a…m → z…q / #_ ; ba -> gz / #zla _", "zlagzqa"],
		#["al…am → am…ab / #_", "amababa"],
	];

	my @tests2 = [
		#topgord
		['o > e / _C₀', "tepgerd"],
		['o > e / _C₀#', "tepgerd"],
		['o > e / _C₁³', "topgerd"],
		['o > e / _C₂', "topgerd"],
		['o > e / _C₂#', "topgerd"],
		['o > e / _C₃', "topgord"],
		['o > e / _C₀g', "tepgerd"],
		['o > e / _C₀d', "topgerd"],
		#'o > e / _(C)#', "tepgerd",
		##to gods
		#'o > e / C₀#', # te geds
		## burro
		#'∅ > it / _V#', # burrito
		## ask
		#'CC > 2 1', # aks
		##bye 
		#'X₁ > @@', # byebye
		##baley
		#'#CVC > @@', # balbaley
		## mitigate
		#'t > d / V1 _ V1', #midigate
		##plato
		#'∅ > C1 V1 / #_C1 C2 V1', # paplato
	];

	run-test("alabama", @tests1);
	#run-test("topgord", @tests2);

	sub run-test($word, @tests) {
		say "#####################################";
		say $word;
		for @tests -> $test {
			my $parse = Parser.parse($test[0], actions=>actions.new(word=>$word));
			if $parse.made eq $test[1] {
				say colored("OK","black on_green"), " $parse = $test[1]";
			} else {
				say colored("NOT OK","white on_red"), " $parse = {$parse.made}, ≠ $test[1]";
			}
		}
	}
}
