#!/usr/bin/env raku

enum Type <VOWEL CONSONANT>;

# vowels
my byte $rounded = 0b10000000;
my byte $front   = 0b01000000;
my byte $central = 0b00100000;
my byte $back	 = 0b00010000;
my byte $close   = 0b00001000;
my byte $near	 = 0b00000100;
my byte $open	 = 0b00000010;
my byte $mid	 = 0b00000001;

# VOWELS
# roundedness,backness,height,,,,
my %vowels =
	'i' => 0b01001000, # unrounded,front,close,,,,
	'y' => 0b11001000, # rounded,front,close,,,,
	'ɪ' => 0b01001100, # unrounded,front,near-close,,,,
	'ʏ' => 0b11001100, # rounded,front,near-close,,,,
	'e' => 0b01001001, # unrounded,front,close-mid,mid,,,
	'ø' => 0b11001001, # rounded,front,close-mid,mid,,,
	'ɛ' => 0b01000011, # unrounded,front,open-mid,mid,,,
	'œ' => 0b11000011, # rounded,front,open-mid,mid,,,
	'æ' => 0b01000110, # unrounded,front,near-open,,,,
	'a' => 0b01000010, # unrounded,front,open,,,,
	'ɶ' => 0b11000010, # rounded,front,open,,,,
	'ɨ' => 0b00101000, # unrounded,central,close,,,,
	'ʉ' => 0b10101000, # rounded,central,close,,,,
	'ɘ' => 0b00101001, # unrounded,central,close-mid,mid,,,
	'ɵ' => 0b10101001, # rounded,central,close-mid,mid,,,
	'ə' => 0b00100001, # unrounded,central,mid,mid,,,
	'ɜ' => 0b00100011, # unrounded,central,open-mid,mid,,,
	'ɞ' => 0b10100011, # rounded,central,open-mid,mid,,,
	'ɐ' => 0b00100110, # unrounded,central,near-open,,,,
	'ä' => 0b00100010, # unrounded,central,open,,,,
	'ɯ' => 0b00011000, # unrounded,back,close,,,,
	'u' => 0b10011000, # rounded,back,close,,,,
	'ʊ' => 0b10011100, # rounded,back,near-close,,,,
	'ɤ' => 0b00011001, # unrounded,back,close-mid,mid,,,
	'o' => 0b10011001, # rounded,back,close-mid,mid,,,
	'ʌ' => 0b00010011, # unrounded,back,open-mid,mid,,,
	'ɔ' => 0b10010011, # rounded,back,open-mid,mid,,,
	'ɑ' => 0b00010010, # unrounded,back,open,,,,
	'ɒ' => 0b10010010, # rounded,back,open,,,,
	;


# consonants
# trailing 0s cuz of the vowels
my byte $voiced       = 0b10000000000000000000000000000000;

my byte $bilabial     = 0b01000000000000000000000000000000;
my byte $labiodental  = 0b00100000000000000000000000000000;
my byte $dental       = 0b00010000000000000000000000000000;
my byte $alveolar	  = 0b00001000000000000000000000000000;
my byte $postalveolar = 0b00000100000000000000000000000000;
my byte $retroflex	  = 0b00000010000000000000000000000000;
my byte $palatal	  = 0b00000001000000000000000000000000;
my byte $velar	      = 0b00000000100000000000000000000000;
my byte $uvular	      = 0b00000000010000000000000000000000;
my byte $pharyngeal	  = 0b00000000001000000000000000000000;
my byte $glottal	  = 0b00000000000100000000000000000000;

my byte $nasal	      = 0b00000000000010000000000000000000;
my byte $stop	      = 0b00000000000001000000000000000000;
my byte $fricative	  = 0b00000000000000100000000000000000;
my byte $trill	      = 0b00000000000000010000000000000000;
my byte $approximant  = 0b00000000000000001000000000000000;
my byte $tap	      = 0b00000000000000000100000000000000;
my byte $lateral	  = 0b00000000000000000010000000000000;
my byte $sibilant	  = 0b00000000000000000001000000000000;
my byte $semivowel	  = 0b00000000000000000000100000000000;

my byte $pulmonic	  = 0b00000000000000000000010000000000;
my byte $implosive	  = 0b00000000000000000000001000000000;
my byte $click	      = 0b00000000000000000000000100000000;

# these are "any of the ones". so $dorsal is both $velar and $uvular
my byte $labial	      = 0b01100000000000000000000000000000;
my byte $coronal	  = 0b00011110000000000000000000000000;
my byte $dorsal	      = 0b00000000110000000000000000000000;
my byte $laryngeal	  = 0b00000000001100000000000000000000;
my byte $liquid	      = 0b00000000000010000010100000000000;
my byte $sonorant     = 0b01111111111101111101011100000000;

my @or = «$labial $coronal $dorsal $laryngeal $liquid $sonorant»;

# CONSONANTS
# symbol,voicedness,place,,manner,,,

my %consonants =
	"m" => 0b110000000000010000000010000000000, #voiced,bilabial,labial,nasal,,,pulmonic
	"p" => 0b010000000000001000000010000000000, #unvoiced,bilabial,labial,stop,,,pulmonic
	"b" => 0b110000000000001000000010000000000, #voiced,bilabial,labial,stop,,,pulmonic
	"ϕ" => 0b010000000000000100000010000000000, #unvoiced,bilabial,labial,fricative,,,pulmonic
	"β" => 0b110000000000000100000010000000000, #voiced,bilabial,labial,fricative,,,pulmonic
	"ʙ" => 0b110000000000000010000010000000000, #voiced,bilabial,labial,trill,,,pulmonic
	"ɱ" => 0b101000000000010000000010000000000, #voiced,labiodental,labial,nasal,,,pulmonic
	"f" => 0b001000000000000100000010000000000, #unvoiced,labiodental,labial,fricative,,,pulmonic
	"v" => 0b101000000000000100000010000000000, #voiced,labiodental,labial,fricative,,,pulmonic
	"ʋ" => 0b101000000000000001000010000000000, #voiced,labiodental,labial,approximant,,,pulmonic
	"ⱱ" => 0b101000000000000000100010000000000, #voiced,labiodental,labial,tap,,,pulmonic
	"θ" => 0b000100000000000100000010000000000, #unvoiced,dental,coronal,fricative,,,pulmonic
	"ð" => 0b100100000000000100000010000000000, #voiced,dental,coronal,fricative,,,pulmonic
	"n" => 0b100010000000010000000010000000000, #voiced,alveolar,coronal,nasal,,,pulmonic
	"t" => 0b000001000000001000000010000000000, #unvoiced,alveolar,coronal,stop,,,pulmonic
	"d" => 0b100001000000001000000010000000000, #voiced,alveolar,coronal,stop,,,pulmonic
	"s" => 0b000001000000000100001010000000000, #unvoiced,alveolar,coronal,fricative,sibilant,,pulmonic
	"z" => 0b100001000000000100001010000000000, #voiced,alveolar,coronal,fricative,sibilant,,pulmonic
	"ɹ" => 0b100001000000000001000010000000000, #voiced,alveolar,coronal,approximant,,,pulmonic
	"ɾ" => 0b100001000000000000100010000000000, #voiced,alveolar,coronal,tap,,,pulmonic
	"r" => 0b100001000000000010000010000000000, #voiced,alveolar,coronal,trill,,,pulmonic
	"ɬ" => 0b000001000000000100010010000000000, #unvoiced,alveolar,coronal,fricative,lateral,,pulmonic
	"ɮ" => 0b000001000000000100010010000000000, #unvoiced,alveolar,coronal,fricative,lateral,,pulmonic
	"l" => 0b100001000000000001010010000000000, #voiced,alveolar,coronal,approximant,lateral,,pulmonic
	"ɺ" => 0b100001000000000000110010000000000, #voiced,alveolar,coronal,tap,lateral,,pulmonic
	"ʃ" => 0b000000100000000100001010000000000, #unvoiced,postalveolar,coronal,fricative,sibilant,,pulmonic
	"ʒ" => 0b100000100000000100001010000000000, #voiced,postalveolar,coronal,fricative,sibilant,,pulmonic
	"ɳ" => 0b100000010000010000000010000000000, #voiced,retroflex,coronal,nasal,,,pulmonic
	"ʈ" => 0b000000010000001000000010000000000, #unvoiced,retroflex,coronal,stop,,,pulmonic
	"ɖ" => 0b100000010000001000000010000000000, #voiced,retroflex,coronal,stop,,,pulmonic
	"ʂ" => 0b000000010000000100001010000000000, #unvoiced,retroflex,coronal,fricative,sibilant,,pulmonic
	"ʐ" => 0b100000010000000100001010000000000, #voiced,retroflex,coronal,fricative,sibilant,,pulmonic
	"ɻ" => 0b100000010000000001000010000000000, #voiced,retroflex,coronal,approximant,,,pulmonic
	"ɽ" => 0b100000010000000000100010000000000, #voiced,retroflex,coronal,tap,,,pulmonic
	"ɭ" => 0b100000010000000001010010000000000, #voiced,retroflex,coronal,approximant,lateral,,pulmonic
	"ɲ" => 0b100000001000010000000010000000000, #voiced,palatal,,nasal,,,pulmonic
	"c" => 0b000000001000001000000010000000000, #unvoiced,palatal,,stop,,,pulmonic
	"ɟ" => 0b100000001000001000000010000000000, #voiced,palatal,,stop,,,pulmonic
	"ɕ" => 0b000000001000000100001010000000000, #unvoiced,palatal,,fricative,sibilant,,pulmonic
	"ʑ" => 0b100000001000000100001010000000000, #voiced,palatal,,fricative,sibilant,,pulmonic
	"ç" => 0b000000001000000100000010000000000, #unvoiced,palatal,,fricative,,,pulmonic
	"ʝ" => 0b100000001000000100000010000000000, #voiced,palatal,,fricative,,,pulmonic
	"j" => 0b100000001000000001000110000000000, #voiced,palatal,,approximant,,,pulmonic,semivowel
	"ʎ" => 0b100000001000000001010010000000000, #voiced,palatal,,approximant,lateral,,pulmonic
	"ŋ" => 0b100000000100010000000010000000000, #voiced,velar,dorsal,nasal,,,pulmonic
	"k" => 0b000000000100001000000010000000000, #unvoiced,velar,dorsal,stop,,,pulmonic
	"g" => 0b100000000100001000000010000000000, #voiced,velar,dorsal,stop,,,pulmonic
	"x" => 0b000000000100000100000010000000000, #unvoiced,velar,dorsal,fricative,,,pulmonic
	"ɣ" => 0b100000000100000100000010000000000, #voiced,velar,dorsal,fricative,,,pulmonic
	"ɰ" => 0b100000000100000001000110000000000, #voiced,velar,dorsal,approximant,,,pulmonic,semivowel
	"ʟ" => 0b100000000100000001010010000000000, #voiced,velar,dorsal,approximant,lateral,,pulmonic
	"ɴ" => 0b100000000010010000000010000000000, #voiced,uvular,dorsal,nasal,,,pulmonic
	"q" => 0b000000000010001000000010000000000, #unvoiced,uvular,dorsal,stop,,,pulmonic
	"ɢ" => 0b100000000010001000000010000000000, #voiced,uvular,dorsal,stop,,,pulmonic
	"χ" => 0b000000000010000100000010000000000, #unvoiced,uvular,dorsal,fricative,,,pulmonic
	"ʁ" => 0b100000000010000100000010000000000, #voiced,uvular,dorsal,fricative,,,pulmonic
	"ʀ" => 0b100000000010000010000010000000000, #voiced,uvular,dorsal,trill,,,pulmonic
	"ʡ" => 0b000000000001001000000010000000000, #unvoiced,pharyngeal,laryngeal,stop,,,pulmonic
	"ħ" => 0b000000000001000100000010000000000, #unvoiced,pharyngeal,laryngeal,fricative,,,pulmonic
	"ʕ" => 0b100000000001000100000010000000000, #voiced,pharyngeal,laryngeal,fricative,,,pulmonic
	"ʜ" => 0b000000000001000010000010000000000, #unvoiced,pharyngeal,laryngeal,trill,,,pulmonic
	"ʢ" => 0b100000000001000010000010000000000, #voiced,pharyngeal,laryngeal,trill,,,pulmonic
	"ʔ" => 0b000000000000001000000010000000000, #unvoiced,gottal,laryngeal,stop,,,pulmonic
	"h" => 0b000000000000000100000010000000000, #unvoiced,gottal,laryngeal,fricative,,,pulmonic
	"ɦ" => 0b100000000000000100000010000000000, #voiced,gottal,laryngeal,fricative,,,pulmonic
	"ɥ" => 0b100000001000000001000110000000000, #voiced,palatal,coronal,approximant,,labial,pulmonic,semivowel
	"w" => 0b100000000100000001000110000000000, #voiced,velar,dorsal,approximant,,labial,pulmonic,semivowel
	"ʍ" => 0b000000000100000001000010000000000, #unvoiced,velar,dorsal,approximant,,labial,pulmonic
	"ɫ" => 0b100100000100000001010010000000000, #voiced,alveolar,coronal,approximant,lateral,velar,pulmonic
	"ɓ" => 0b100000000000001000000001000000000, #voiced,bilabial,labial,stop,,,implosive
	"ɗ" => 0b100100000000001000000001000000000, #voiced,alveolar,coronal,stop,,,implosive
	"ᶑ" => 0b100000010000001000000001000000000, #voiced,retroflex,coronal,stop,,,implosive
	"ʄ" => 0b100000001000001000000001000000000, #voiced,palatal,,stop,,,implosive
	"ɠ" => 0b100000000100001000000001000000000, #voiced,velar,dorsal,stop,,,implosive
	"ʛ" => 0b100000000010001000000001000000000, #voiced,uvular,dorsal,stop,,,implosive
	"ʘ" => 0b010000000000000000000000100000000, #,bilabial,labial,,,,click
	"ǀ" => 0b001000000000000000000000100000000, #,dental,coronal,,,,click
	"ǃ" => 0b000100000000000000000000100000000, #,alveolar,coronal,,,,click
	"ǁ" => 0b000100000000000000010000100000000, #,alveolar,coronal,,lateral,,click
	"‼" => 0b000000010000000000000000100000000, #,retroflex,coronal,,,,click
	"ǂ" => 0b000000000100000000000000100000000, #,velar,dorsal,,,,click
	;



#my @rounded = «$y $ʏ $ø $œ $ɶ $ʉ $ɵ $ɞ $u $ʊ $o $ɔ $ɒ»;
#my @unrounded = «$i $ɪ $e $ɛ $æ $a $ɨ $ɘ $ə $ɜ $ɐ $ä $ɯ $ɤ $ʌ $ɑ»;
#my @letters = «$i $y $ɪ $ʏ $e $ø $ɛ $œ $æ $a $ɶ $ɨ $ʉ $ɘ $ɵ $ə $ɜ $ɞ $ɐ $ä $ɯ $u $ʊ $ɤ $o $ʌ $ɔ $ɑ $ɒ»;
#say @rounded, @letters;
#say %vowels.VAR.name;



# find all aspects that are a letter is part of
sub get-aspects($letter) {
	my @aspects;
	($letter +& $rounded) >= 1 ?? @aspects.push("rounded") !! @aspects.push("unrounded");
	@aspects.push("front")   if ($letter +& $front); 
	@aspects.push("central") if ($letter +& $central);
	@aspects.push("back")	 if ($letter +& $back);
	@aspects.push("close")   if ($letter +& $close);
	@aspects.push("near")	 if ($letter +& $near);
	@aspects.push("mid")	 if ($letter +& $mid);
	@aspects.push("open")	 if ($letter +& $open);

	($letter +& $voiced) >= 1 ?? @aspects.push("voiced") !! @aspects.push("unvoiced");
	@aspects.push("bilabial")		if ($letter +& $bilabial);
	@aspects.push("labiodental")	if ($letter +& $labiodental);
	@aspects.push("dental")			if ($letter +& $dental);
	@aspects.push("alveolar")		if ($letter +& $alveolar);
	@aspects.push("postalveolar")	if ($letter +& $postalveolar);
	@aspects.push("retroflex")		if ($letter +& $retroflex);
	@aspects.push("palatal")		if ($letter +& $palatal);
	@aspects.push("velar")			if ($letter +& $velar);
	@aspects.push("uvular")			if ($letter +& $uvular);
	@aspects.push("pharyngeal")		if ($letter +& $pharyngeal);
	@aspects.push("glottal")		if ($letter +& $glottal);
	@aspects.push("nasal")			if ($letter +& $nasal);
	@aspects.push("stop")			if ($letter +& $stop);
	@aspects.push("fricative")		if ($letter +& $fricative);
	@aspects.push("trill")	 		if ($letter +& $trill);
	@aspects.push("approximant")	if ($letter +& $approximant);
	@aspects.push("tap")			if ($letter +& $tap);
	@aspects.push("lateral")		if ($letter +& $lateral);
	@aspects.push("sibilant")		if ($letter +& $sibilant);
	@aspects.push("semivowel")		if ($letter +& $semivowel);
	@aspects.push("pulmonic")		if ($letter +& $pulmonic);
	@aspects.push("implosive")		if ($letter +& $implosive);
	@aspects.push("click")			if ($letter +& $click);
	# the "or" items
	@aspects.push("labial")			if ($letter +& $labial);
	@aspects.push("coronal")		if ($letter +& $coronal);
	@aspects.push("dorsal")			if ($letter +& $dorsal);
	@aspects.push("laryngeal")		if ($letter +& $laryngeal);
	@aspects.push("liquid")			if ($letter +& $liquid);
	@aspects.push("sonorant")		if ($letter +& $sonorant);
	return @aspects;
}

# find all letters that fit a given aspect
sub get-letters($aspect) {
	my @letters;
		for %vowels.kv -> $name,$letter {
			@letters.push($name) if (($letter +& $aspect) >= 1);
		}
		for %consonants.kv -> $name,$letter {
			@letters.push($name) if (($letter +& $aspect) >= 1);
			for @or -> $class {
				@letters.push($class) if (($letter +& $aspect) >= 1);
			}
		}
	return @letters;
}

# switch the aspect of a letter from one to another
sub switch-aspect(Int $from-aspect, Int $to-aspect, Int $letter) {
	my $ltr;
	# if the letter is in from_lang
	if (($letter +& $from-aspect) >= 1) {
		say $letter.base(2), "is a", $from-aspect.base(2), "to ", $to-aspect.base(2);
		# remove the from-aspect from the letter
		$ltr = $letter - $from-aspect;
		say $ltr.base(2);
		# now add to-aspect to the letter ('|=' in js)
		$ltr +|= $to-aspect;
		say $ltr.base(2);
	}
	return $ltr;
}

sub dec2bin($val) {
	my $num = abs($val);
	my $n = $num.base(2);
	return $n;
}

say get-aspects(%vowels{"ʌ"});
say get-aspects(%vowels{"ə"});
say get-letters($mid);
say get-letters($mid).map: {$_, get-aspects(%vowels{$_})};
say("ɜ",get-aspects(%vowels{"ɜ"})); # unrounded central open mid
say(get-aspects(switch-aspect($open, $close, %vowels{"ɜ"}))); # unrounded central close mid

say "";

say get-aspects(%consonants{"ʃ"});
say %consonants{"ʃ"};
say get-aspects(%consonants{"ɥ"});
say get-letters($tap);
say get-letters($tap).map: {$_, get-aspects(%consonants{$_})};
say("q",get-aspects(%consonants{"q"})); # unrounded central open mid
say(get-aspects(switch-aspect($uvular, $alveolar, %consonants{"q"}))); # unrounded central close mid
