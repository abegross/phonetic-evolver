use Terminal::ANSIColor;

our %aspects is export =
  "rounded"      => <y ʏ ø œ ɶ ʉ ɵ ə ɞ ɐ ä̹ u ʊ o ɔ ɒ>,
  "unrounded"    => <i ɪ e ɛ æ a ɨ ɘ ə ɜ ɐ ä ɯ ɤ ʌ ɑ>,
  "front"        => <i y i̞ y̞ e ø e̞ ø̞ ɛ œ æ æ̹ a ɶ>,
  "near-front"   => <ɪ ʏ>,
  "central"      => <ɨ ʉ ɨ̞ ʉ̞ ɘ ɵ ə ɜ ɞ ɐ ä ä̹>,
  "near-back"    => <ʊ̜ ʊ>,
  "back"         => <ɯ u ɯ̞ u̞ ɤ o ɤ̞ o̞ ʌ ɔ ɑ ɒ ɑ̝ ɒ̝>,
  "close"        => <i y i̙ y̙ ɨ ʉ ɯ̘ u̘ ɯ u>,
  "near-close"   => <i̞ y̞ ɪ ʏ ɨ̞ ʉ̞ ʊ̜ ʊ ɯ̞ u̞>,
  "close-mid"    => <e ø e̙ ø̙ ɘ ɵ ɤ̘ o̘ ɤ o>,
  "mid"          => <e̞ ø̞ ə ɤ̞ o̞>,
  "near-open"    => <æ æ̹ ɐ ɑ̝ ɒ̝>,
  "open-mid"     => <ɛ œ ɜ ɞ ʌ ɔ>,
  "open"         => <a ɶ ä ä̹ ɑ ɒ>,
  #"tense"        => <i u y o>,

  "voiced"       => <m ɱ n ɳ ɲ ŋ ɴ b d d ɟ g ɢ z ʒ ʐ ʑ β v ð ʝ ɣ ʁ ʕ ɦ ʋ ɹ ɻ j ɰ ⱱ ɾ ɽ ʙ r ʀ ʢ ɮ l ɫ ɭ ʎ ʟ ɺ ɥ w d̪z̪ dz dʒ d̠ʒ ɖʐ dʑ bβ b̪v d̪ð dɹ̝ d̠ɹ̠˔ ɟʝ gɣ ɢʁ ʡʢ dɮ ɟʎ̝ gʟ̝>,
  "voiceless"    => <p t ʈ c k q ʡ ʔ s ʃ ʂ ɕ ɸ f θ ç x χ ħ h ʜ ɬ ʍ t̪s̪ ts tʃ t̠ʃ ʈʂ tɕ pɸ p̪f t̪θ tɹ̝̊ t̠ɹ̠̊˔ cç kx qχ ʔh tɬ ʈɭ̊˔ cʎ̝̊ kʟ̝̊>,
  "bilabial"     => <m̥ m p b ɸ β β̞ ⱱ̟ ʙ̥ ʙ pɸ bβ p̪f b̪v>,
  "labiodental"  => <ɱ p̪ b̪ ⱱ f v ʋ>,
  "linguolabial" => <n̼ t̼ d̼ θ̼ ð̼ ɾ̼>,
  "dental"       => <t̪ d̪ θ ð ð̞ l̪ t̪s̪ d̪z̪ t̪θ d̪ð>,
  "alveolar"     => <n̥ n t d s z θ̠ ð̠ ɹ ɾ̥ ɾ r̥ r ɬ ɮ l ɫ ɺ̥ ɺ ts dz tɹ̝̊ dɹ̝ tɬ dɮ>,
  "postalveolar" => <ʃ ʒ ɹ̠̊˔ ɹ̠˔ ɹ̠ r̠ l̠ tʃ t̠ʃ dʒ d̠ʒ t̠ɹ̠̊˔ d̠ɹ̠˔>,
  "retroflex"    => <ɳ̊ ɳ ʈ ɖ ʂ ʐ ɻ˔ ɻ ɽ̊ ɽ ɭ̊˔ ɭ˔ ɭ ɭ̥̆ ɭ̆ ʈʂ ɖʐ ɽ̊r̥ ɽr 	ʈɭ̊˔>,
  "palatal"      => <ɲ̊ ɲ ɲ̊ ɲ ɕ ʑ ç ʝ j ʎ̝̊ ʎ̝ ʎ ʎ̆ ɥ tɕ dʑ cç ɟʝ cʎ̝̊ ɟʎ̝>,
  "velar"        => <ŋ̊ ŋ k g x ɣ ɰ ʟ̝̊ ʟ̝ ʟ ʟ̆ ɫ ʍ w kx gɣ kʟ̝̊ gʟ̝>,
  "uvular"       => <ɴ q ɢ χ ʁ ʁ̞ ʀ̥ ʀ ɢ̆ ʟ̠ qχ ɢʁ>,
  "pharyngeal"   => <ʡ ħ ʕ ʡ̆ ʜ ʢ ʡʢ>,
  "glottal"      => <ʔ h ɦ ʔ̞ ʔh>,
  "plosive"      => <p b p̪ b̪ t̼ d̼ t̪ d̪ t d ʈ ɖ c ɟ k g q ɢ ʡ ʔ t̪s̪ d̪z̪ ts dz tʃ t̠ʃ dʒ d̠ʒ ʈʂ ɖʐ tɕ dʑ pɸ bβ p̪f b̪v t̪θ d̪ð tɹ̝̊ dɹ̝ t̠ɹ̠̊˔ d̠ɹ̠˔ cç ɟʝ kx gɣ qχ ɢʁ ʡʢ ʔh>,
  "nasal"        => <m̥ m ɱ n̼ n̥ n ɳ̊ ɳ ɲ̊ ɲ ŋ̊ ŋ ɴ>,
  "trill"        => <ʙ̥ ʙ r̥ r r̠ ʀ̥ ʀ ʜ ʢ>,
  "tap"          => <ⱱ̟ ⱱ ɾ̼ ɾ̥ ɾ ɽ̊ ɽ ɢ̆ ʡ̆ ɺ̥ ɺ ɭ̥̆ ɭ̆ ʎ̆ ʟ̆>,
  "fricative"    => <s z ʃ ʒ ʂ ʐ ɕ ʑ ɸ β f v θ̼ ð̼ θ ð θ̠ ð̠ ɹ̠̊˔ ɹ̠˔ ɻ˔ ç ʝ x ɣ χ ʁ ħ ʕ h ɦ ɬ ɮ ɭ̊˔ ɭ˔ ʎ̝̊ ʎ̝ ʟ̝̊ ʟ̝ t̪s̪ d̪z̪ ts dz tʃ t̠ʃ dʒ d̠ʒ ʈʂ ɖʐ tɕ dʑ pɸ bβ p̪f b̪v t̪θ d̪ð tɹ̝̊ dɹ̝ t̠ɹ̠̊˔ d̠ɹ̠˔ cç ɟʝ kx gɣ qχ ɢʁ ʡʢ ʔh>,
  "affricate"    => <t̪s̪ d̪z̪ ts dz tʃ t̠ʃ dʒ d̠ʒ ʈʂ ɖʐ tɕ dʑ pɸ bβ p̪f b̪v t̪θ d̪ð tɹ̝̊ dɹ̝ t̠ɹ̠̊˔ d̠ɹ̠˔ cç ɟʝ kx gɣ qχ ɢʁ ʡʢ ʔh tɬ dɮ ʈɭ̊˔ cʎ̝̊ ɟʎ̝ kʟ̝̊ gʟ̝>,
  "sibilant"     => <s z ʃ ʒ ʂ ʐ ɕ ʑ>, # t̪s̪ d̪z̪ ts dz tʃ t̠ʃ dʒ d̠ʒ ʈʂ ɖʐ tɕ dʑ>,
  "lateral"      => <ɬ ɮ ɭ̊˔ ɭ˔ ʎ̝̊ ʎ̝ ʟ̝̊ ʟ̝ l̪ l l̠ ɭ ʎ ʟ ʟ̠ ɺ̥ ɺ ɭ̥̆ ɭ̆ ʎ̆ ʟ̆ ɫ tɬ dɮ ʈɭ̊˔ cʎ̝̊ ɟʎ̝ kʟ̝̊ gʟ̝>,
  "approximant"  => <β̞ ʋ ð̞ ɹ ɹ̠ ɻ j ɰ ʁ̞ ʔ̞ l̪ l l̠ ɭ ʎ ʟ ʟ̠ ɥ ʍ w ɫ>,
  "click"        => <ʘ ǀ ǃ ǂ ǁ>,
  "implosive"    => <ɓ ɗ ʄ ɠ ʛ>,
  "labial"       => <ɥ w>,
  ;

my %vowel-diacritics = 
	"nasal" 			=> "\c[COMBINING TILDE]",
	"voiceless" 		=> "\c[COMBINING RING BELOW]",
	"voiced" 			=> "\c[COMBINING CARON BELOW]",
	"breathy" 			=> "\c[COMBINING DIAERESIS BELOW]",
	"creaky" 			=> "\c[COMBINING TILDE BELOW]",
	"advanced" 			=> "\c[COMBINING PLUS SIGN BELOW]",
	"retracted" 		=> "\c[COMBINING MINUS SIGN BELOW]",
	"centralized" 		=> "\c[COMBINING DIAERESIS]",
	"mid-centralized"	=> "\c[COMBINING X ABOVE]",
	"raised" 			=> "\c[COMBINING UP TACK BELOW]",
	"lowered" 			=> "\c[COMBINING DOWN TACK BELOW]",
	"rounded" 			=> "\c[COMBINING RIGHT HALF RING BELOW]",
	"unrounded" 		=> "\c[COMBINING LEFT HALF RING BELOW]",
	"aspirated" 		=> "\c[MODIFIER LETTER SMALL H]",
	"front" 			=> "\c[COMBINING LEFT TACK BELOW]",
	"back" 				=> "\c[COMBINING RIGHT TACK BELOW]",
	"long" 				=> "\c[MODIFIER LETTER TRIANGULAR COLON]",
	"short" 			=> "\c[MODIFIER LETTER HALF TRIANGULAR COLON]",
	"extra-short" 		=> "\c[COMBINING BREVE]",
	;
my %consonant-diacritics = 
	"nasal" 			=> "\c[COMBINING TILDE]",
	"voiceless" 		=> "\c[COMBINING RING BELOW]",
	"voiced" 			=> "\c[COMBINING CARON BELOW]",
	"breathy" 			=> "\c[COMBINING DIAERESIS BELOW]",
	"creaky" 			=> "\c[COMBINING TILDE BELOW]",
	"dental" 			=> "\c[COMBINING BRIDGE BELOW]",
	"apical" 			=> "\c[COMBINING INVERTED BRIDGE BELOW]",
	"linguolabial" 		=> "\c[COMBINING SEAGULL BELOW]",
	"laminal" 			=> "\c[COMBINING SQUARE BELOW]",
	"advanced" 			=> "\c[COMBINING PLUS SIGN BELOW]",
	"retracted" 		=> "\c[COMBINING MINUS SIGN BELOW]",
	"centralized" 		=> "\c[COMBINING DIAERESIS]",
	"mid-centralized"	=> "\c[COMBINING X ABOVE]",
	"raised" 			=> "\c[COMBINING UP TACK BELOW]",
	"lowered" 			=> "\c[COMBINING DOWN TACK BELOW]",
	"rounded" 			=> "\c[COMBINING RIGHT HALF RING BELOW]",
	"unrounded" 		=> "\c[COMBINING LEFT HALF RING BELOW]",
	"aspirated" 		=> "\c[MODIFIER LETTER SMALL H]",
	"labial" 			=> "\c[MODIFIER LETTER SMALL W]",
	"palatal" 			=> "\c[MODIFIER LETTER SMALL J]",
	"velar" 			=> "\c[MODIFIER LETTER SMALL GAMMA]",
	"pharyngeal" 		=> "\c[MODIFIER LETTER SMALL REVERSED GLOTTAL STOP]",
	"front" 			=> "\c[COMBINING LEFT TACK BELOW]",
	"back" 				=> "\c[COMBINING RIGHT TACK BELOW]",
	"rhotic" 			=> "\c[MODIFIER LETTER RHOTIC HOOK]",
	"long" 				=> "\c[MODIFIER LETTER TRIANGULAR COLON]",
	"short" 			=> "\c[MODIFIER LETTER HALF TRIANGULAR COLON]",
	"extra-short" 		=> "\c[COMBINING BREVE]",
	;

my @vowel-chart = [
	%aspects{"close"},
	%aspects{"near-close"},
	%aspects{"close-mid"},
	%aspects{"mid"},
	%aspects{"open-mid"},
	%aspects{"near-open"},
	%aspects{"open"}
];

# finish large groupings
%aspects{"close"}     = (%aspects{"close"} ∪ %aspects{"near-close"}).keys.cache;
%aspects{"mid"}       = (%aspects{"mid"}   ∪ %aspects{"close-mid"} ∪ %aspects{"open-mid"}).keys.cache;
%aspects{"open"}      = (%aspects{"open"}  ∪ %aspects{"near-open"}).keys.cache;
%aspects{"front"}     = (%aspects{"front"} ∪ %aspects{"near-front"}).keys.cache;
%aspects{"back"}      = (%aspects{"back"}  ∪ %aspects{"near-back"}).keys.cache;

%aspects{"labial"}    = (%aspects{"labial"} ∪ %aspects{"bilabial"} ∪ %aspects{"labiodental"} ∪ %aspects{"linguolabial"}).keys.cache;
%aspects{"coronal"}   = (%aspects{"linguolabial"} ∪ %aspects{"dental"} ∪ %aspects{"alveolar"} ∪ %aspects{"postalveolar"} ∪ %aspects{"retroflex"} ∪ %aspects{"palatal"}).keys.cache;
%aspects{"dorsal"}    = (%aspects{"palatal"} ∪ %aspects{"velar"} ∪ %aspects{"uvular"}).keys.cache;
%aspects{"laryngeal"} = (%aspects{"pharyngeal"} ∪ %aspects{"glottal"}).keys.cache;
%aspects{"obstruent"} = (%aspects{"plosive"} ∪ %aspects{"fricative"} ∪ %aspects{"affricate"}).keys.cache;
%aspects{"continuant"} = (%aspects{"fricative"} ∪ %aspects{"approximant"}).keys.cache;
%aspects{"sonorant"} = (([∪] %aspects.values) (-) %aspects{"obstruent"}).keys.cache;

## add aliases
#%aspects{"high"}      := %aspects{"close"};
#%aspects{"low"}       := %aspects{"open"};
#%aspects{"high-mid"}  := %aspects{"close-mid"};
#%aspects{"low-mid"}   := %aspects{"open-mid"};
#%aspects{"near-high"} := %aspects{"near-close"};
#%aspects{"near-low"}  := %aspects{"near-open"};
#%aspects{"flap"}      := %aspects{"tap"};
#%aspects{"stop"}      := %aspects{"plosive"};
#%aspects{"occlusive"} := %aspects{"plosive"};
#%aspects{"epiglottal"}:= %aspects{"pharyngeal"};

my @exclusive = (
	#<rounded unrounded>,  # roundedness
	<front central back near-front near-back>,  # backness
	<close close-full close-mid near-close mid open open-mid near-open open-full high low high-mid low-mid near-high near-low>, # height
	
	<voiced voiceless rounded unrounded>, # voicedness
	<labial coronal dorsal laryngeal bilabial linguolabial dental alveolar postalveolar retroflex palatal velar uvular pharyngeal glottal>, # place
	<nasal plosive sonorant sibilant fricative approximant tap trill lateral>, # manner
	["affricate"],
);


my (%letters, @letters);
@letters = ([∪] %aspects.values).keys;
#dd @letters;
for @letters -> $letter {
	%letters{$letter} = [];
	for %aspects.kv -> $k, $v {
		%letters{$letter}.push: $k if $v ∋ $letter;
	}
}
#dd %letters;
my @vowels;
@vowels.push: |$_ for @vowel-chart;
my @consonants = (@letters (-) @vowels).keys;
sub vowels is export  { @vowels };
sub consonants is export { @consonants };

# find all aspects that are a letter is part of
sub get-aspects($letter) is export {
	return %letters{$letter};
}

# find all letters that fit a given aspect
multi sub get-letters($aspect) {
	my @letters;
	for %aspects.kv -> $name,@ltrs {
		#say @ltrs;
		@letters.push(|@ltrs) if $aspect eq $name;
	}

	for %vowel-diacritics.keys -> $diacritic {
		@letters.push: %vowel-diacritics{$diacritic}	if $aspect eq $diacritic;
	}
	for %consonant-diacritics.keys -> $diacritic {
		@letters.push: %consonant-diacritics{$diacritic}	if $aspect eq $diacritic;
	}

	return @letters;
}
#say get-letters("nasal");

# figure out which letters in a str includes a given aspect (including diacritics)
multi sub get-letters($str, $aspect, :$negative?) is export {
	return consonants if $aspect eq 'consonants';
	return vowels if $aspect eq 'vowels';
	my @ltrs;
	if $negative {
		@ltrs = |(@letters (-) get-letters($aspect)).keys;
	} else {
		@ltrs = get-letters($aspect);
	}
	my @matched = $str.split("",:skip-empty).map: {any(.NFKD.map: {.chr ∈ @ltrs})};
	my @returns;
	for $str.split("",:skip-empty) Z @matched -> [$letter, $match] {
		@returns.push: $letter if $match;
	}
	return @returns;
}

#say get-letters('nãtʰaŋ', 'voiced', :negative);

#say switch-aspect("n", "plosive");

# switch the aspect of a letter from one to another
#say switch-aspect("ɛ", "close"); # returns "i" cuz theyre both front unrounded
sub switch-aspect($letter, $to-aspect) is export {
	my @to-aspect = $to-aspect.Array;
	my $my-aspects = get-aspects($letter); #?? %letters{$letter} !! %consonants{$letter};
	return Nil if !$my-aspects;
	for @exclusive -> @ex {
		#say $my-aspects, @ex, " ", @to-aspect;
		# if $to-aspect is in @ex
		if @ex ∋ @to-aspect.any {
			if @to-aspect ∋ "close" and $my-aspects ∋ "near-open" {
				cut(@to-aspect, "close");
				@to-aspect.push: "near-close";
			} elsif @to-aspect ∋ "close" and $my-aspects ∋ "open-mid" {
				cut(@to-aspect, "close");
				@to-aspect.push: "close-mid";
			} elsif @to-aspect ∋ "open" and $my-aspects ∋ "near-close" {
				cut(@to-aspect, "open");
				@to-aspect.push: "near-open", "near";
			} elsif @to-aspect ∋ "open" and $my-aspects ∋ "close-mid" {
				cut(@to-aspect, "open");
				@to-aspect.push("open-mid", "mid");
			} elsif @to-aspect ∋ "affricate" {
				@to-aspect.push("fricative") if $my-aspects ∋ "plosive";
				@to-aspect.push("plosive") if $my-aspects ∋ "fricative";
			}
			# return the letter that addition of the set-intersection of the aspects is
			#say $my-aspects, @ex, @to-aspect;
			#dd @to-aspect, ($my-aspects (-) @ex).keys, (($my-aspects (-) @ex) ∪ @to-aspect).keys;
			#dd (($my-aspects (-) @ex) ∪ @to-aspect).keys;
			my $new-letter = get-letter-by-aspects((($my-aspects (-) @ex) ∪ @to-aspect).keys.Array);

			#dd $letter, $new-letter;
			if $letter ∈ @vowels {
				for %vowel-diacritics.keys -> $diacritic {
					$new-letter = $letter ~ %vowel-diacritics{$diacritic} if not $new-letter and @to-aspect ∋ $diacritic;
				}
			} elsif $letter ∈ @consonants {
				for %consonant-diacritics.keys -> $diacritic {
					$new-letter = $letter ~ %consonant-diacritics{$diacritic} if not $new-letter and @to-aspect ∋ $diacritic;
				}
			}
			#dd $new-letter;

			return $new-letter || $letter;
		}
	}
}


sub get-letter-by-aspects(@aspects where @aspects ~~ Array) is export {
	my @sets.push: %aspects{($_ ~~ Pair ?? $_.key !! $_)} for @aspects;
	#say "top", @aspects, [∩] @sets;
	@sets = |([∩] @sets.sort).keys.sort.Array;
	#dd @sets;

	# if the aspects given are an exact match to the aspects of a letter, then return the letter right away
	if @sets.elems > 1 {
		for @sets {
			return $_ if get-aspects($_) ≡ @aspects;
		}
	}
	if @sets ~~ Array {
		#dd @sets.elems;
		if @aspects ∌ "affricate" {
			my @temp;
			for @sets.kv -> $k, $_ {
				#dd $k, $_, get-aspects($_);
				#cut(@sets, $_) if get-aspects($_) ∋ "affricate";
				@temp.push: $_ if get-aspects($_) ∌ "affricate";
				#dd @sets;
			}
			@sets = @temp;
		}
		#dd @aspects;
		return @sets;
		#return @sets.sort».keys»[0];
	} else {
		return @sets[0];
	}
	die "{@aspects} is not a real letter";
}

sub move($letter, $dir where "close" | "open" | "front" | "back") is export {
	##return "∅" if $dir ne "up" | "down" | "right" | "left";

	my ($x, $y, $max-x, $max-y, $v-elems);
	$max-y = @vowel-chart.elems-1;
	for @vowel-chart.kv -> $k,$v {
		if $v ∋ $letter {
			$y = $k;
			$x = $v.first($letter, :k);
		}
	}

	$y += 1 if $dir eq "open";
	$y -= 1 if $dir eq "close";
	$y = clamp($y, 0, $max-y);
	$max-x = @vowel-chart[$y].elems-1;
	$x += 2 if $dir eq "back";
	$x -= 2 if $dir eq "front";
	$x = clamp($x, 0, $max-x);

	#dd @vowel-chart, $x, $y, $dir;

	return @vowel-chart[$y][$x];
}


sub cut(@array, $item) {
	return @array.splice(@array.first($item,:k), 1);
}
sub clamp($value, $min, $max) {
	my $new-value = $value;
	$new-value = $min if $value < $min;
	$new-value = $max if $value > $max;
	return $new-value;
}

#my @tests4 = [%letters{"ɬ"}.Array, <voiced velar plosive>.Array, <velar plosive>.Array, <labial velar approximant>.Array, <velar approximant>.Array, <retroflex nasal>.Array];
#my @results4 = ["ɬ", "g", <k g>, "w", <ɰ w ʍ ɫ ʟ>, <ɳ ɳ̊>];
#for @tests4.kv -> $i,$v {
	##say "";
	#my $value = get-letter-by-aspects($v);
	#say ($value eq @results4[$i].sort) ?? colored("OK","black on_green")~" $v → $value" !! colored("NOT OK","white on_red")~" $v ≠ $value";
#}
#say "###########################";

#my @tests3 = [<y close>, <o open>, <ɜ back>, <a back>, <ʊ front>, <a front>, <ɘ close>, <ɐ back>, <ə open>];
#my @results3 = <y o̞ ʌ ä ʉ̞ a ɨ̞ ɒ̝ ɜ>;
#for @tests3.kv -> $i,$v {
	##say "";
	#my $value = move($v[0], $v[1]);
	#say ($value eq @results3[$i]) ?? colored("OK","black on_green")~" {$v[0]} → {$v[1]} = $value" !! colored("NOT OK","white on_red")~" {$v[0]} → {$v[1]} ≠ $value";
#}
#say "###########################";

#my @tests2 = [<y near-back>, <u front>, <o open>, <a back>, <ɛ central>, <a near-close>, <u unrounded>, <u close-mid>, <ʊ unrounded>, <ä rounded>, <ɐ rounded>];
#my @results2 = <ʊ y ɔ ɑ ɜ ɪ ɯ o ʊ̜ ä̹ ɐ>;
#for @tests2.kv -> $i,$v {
	##say "";
	#my $value = switch-aspect($v[0], $v[1]);
	#say ($value eq @results2[$i]) ?? colored("OK","black on_green")~" {$v[0]} → {$v[1]} = $value" !! colored("NOT OK","white on_red")~" {$v[0]} → {$v[1]} ≠ $value";
#}
#say "###########################";

#my @tests1 = [%letters{"o"}.Array, <rounded front close>.Array, <unrounded central near-open open>.Array, <unrounded front close-mid>.Array];
#my @results1 = ["o", ["y", "ʏ"], "ɐ", "e"];
#for @tests1.kv -> $i,$v {
	##say "";
	#my $value = get-letter-by-aspects($v);
	#say ($value eq @results1[$i]) ?? colored("OK","black on_green")~" $v → $value" !! colored("NOT OK","white on_red")~" $v ≠ $value";
#}

#say "###########################";
#my @tests5 = [<k glottal>, <p voiced>, <b fricative>, <k fricative>, <ʃ voiced>, <s plosive>, <t affricate>, <g affricate>, <ts velar>, <tʃ voiced>, <n plosive>, <ŋ plosive>, <d voiceless>, <g voiceless>, <k voiced>, <n voiceless>, <a velar>, <t nasal>];
#my @results5 = <ʔ b β x ʒ t ts gɣ kx dʒ d g t k g n̥ a n>;
#for @tests5.kv -> $i,$v {
	##say "";
	#my $value = switch-aspect($v[0], $v[1]);
	#say ($value eq @results5[$i]) ?? colored("OK","black on_green")~" {$v[0]} → {$v[1]} = $value" !! colored("NOT OK","white on_red")~" {$v[0]} → {$v[1]} ≠ $value";
#}

