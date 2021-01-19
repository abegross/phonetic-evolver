use Terminal::ANSIColor;
my %aspects =
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
  "open"    => <a ɶ ä ä̹ ɑ ɒ>,

  "voiced"       => <m ɱ n ɳ ɲ ŋ ɴ b d d ɟ ɡ ɢ z ʒ ʐ ʑ β v ð ʝ ɣ ʁ ʕ ɦ ʋ ɹ ɻ j ɰ ⱱ ɾ ɽ ʙ r ʀ ʢ ɮ l ɫ ɭ ʎ ʟ ɺ ɥ w>,
  "voiceless"    => <p t ʈ c k q ʡ ʔ s ʃ ʂ ɕ ɸ f θ ç x χ ħ h ʜ ɬ ʍ>,
  "bilabial"     => <m̥ m p b ɸ β β̞ ⱱ̟ ʙ̥ ʙ>,
  "labiodental"  => <ɱ p̪ b̪ ⱱ f v ʋ>,
  "linguolabial" => <n̼ t̼ d̼ θ̼ ð̼ ɾ̼>,
  "dental"       => <t̪ d̪ θ ð ð̞ l̪>,
  "alveolar"     => <n̥ n t d s z θ̠ ð̠ ɹ ɾ̥ ɾ r̥ r ɬ ɮ l ɫ ɺ̥ ɺ>,
  "postalveolar" => <ʃ ʒ ɹ̠̊˔ ɹ̠˔ ɹ̠ r̠ l̠>,
  "retroflex"    => <ɳ̊ ɳ ʈ ɖ ʂ ʐ ɻ˔ ɻ ɽ̊ ɽ ɭ̊˔ ɭ˔ ɭ ɭ̥̆ ɭ̆>,
  "palatal"      => <ɲ̊ ɲ ɲ̊ ɲ ɕ ʑ ç ʝ j ʎ̝̊ ʎ̝ ʎ ʎ̆ ɥ>,
  "velar"        => <ŋ̊ ŋ k ɡ x ɣ ɰ ʟ̝̊ ʟ̝ ʟ ʟ̆ ɫ ʍ w>,
  "uvular"       => <ɴ q ɢ χ ʁ ʁ̞ ʀ̥ ʀ ɢ̆ ʟ̠>,
  "pharyngeal"   => <ʡ ħ ʕ ʡ̆ ʜ ʢ>,
  "glottal"      => <ʔ h ɦ ʔ̞>,
  "plosive"      => <p b p̪ b̪ t̼ d̼ t̪ d̪ t d ʈ ɖ c ɟ k ɡ q ɢ ʡ ʔ>,
  "nasal"        => <m̥ m ɱ n̼ n̥ n ɳ̊ ɳ ɲ̊ ɲ ŋ̊ ŋ ɴ>,
  "trill"        => <ʙ̥ ʙ r̥ r r̠ ʀ̥ ʀ ʜ ʢ>,
  "tap"          => <ⱱ̟ ⱱ ɾ̼ ɾ̥ ɾ ɽ̊ ɽ ɢ̆ ʡ̆ ɺ̥ ɺ ɭ̥̆ ɭ̆ ʎ̆ ʟ̆>,
  "fricative"    => <s z ʃ ʒ ʂ ʐ ɕ ʑ ɸ β f v θ̼ ð̼ θ ð θ̠ ð̠ ɹ̠̊˔ ɹ̠˔ ɻ˔ ç ʝ x ɣ χ ʁ ħ ʕ h ɦ ɬ ɮ ɭ̊˔ ɭ˔ ʎ̝̊ ʎ̝ ʟ̝̊ ʟ̝>,
  "sibilant"     => <s z ʃ ʒ ʂ ʐ ɕ ʑ>,
  "lateral"      => <ɬ ɮ ɭ̊˔ ɭ˔ ʎ̝̊ ʎ̝ ʟ̝̊ ʟ̝ l̪ l l̠ ɭ ʎ ʟ ʟ̠ ɺ̥ ɺ ɭ̥̆ ɭ̆ ʎ̆ ʟ̆ ɫ>,
  "approximant"  => <β̞ ʋ ð̞ ɹ ɹ̠ ɻ j ɰ ʁ̞ ʔ̞ l̪ l l̠ ɭ ʎ ʟ ʟ̠ ɥ ʍ w ɫ>,
  "click"        => <ʘ ǀ ǃ ǂ ǁ>,
  "implosive"    => <ɓ ɗ ʄ ɠ ʛ>,
  "labial"       => <ɥ w>,
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

%aspects{"labial"}    = (%aspects{"labial"} ∪ %aspects{"bilabial"} ∪ %aspects{"labiodental"}).keys.cache;
%aspects{"coronal"}   = (%aspects{"dental"} ∪ %aspects{"alveolar"} ∪ %aspects{"postalveolar"} ∪ %aspects{"retroflex"} ∪ %aspects{"palatal"}).keys.cache;
%aspects{"dorsal"}    = (%aspects{"palatal"} ∪ %aspects{"velar"} ∪ %aspects{"uvular"}).keys.cache;
%aspects{"laryngeal"} = (%aspects{"pharyngeal"} ∪ %aspects{"glottal"}).keys.cache;
%aspects{"obstruent"} = (%aspects{"plosive"} ∪ %aspects{"fricative"}).keys.cache;# ∪ %aspects{"affricate"}).keys.cache;
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
	<rounded unrounded>,  # roundedness
	<front central back near-front near-back>,  # backness
	<close close-full close-mid near-close mid open open-mid near-open open-full high low high-mid low-mid near-high near-low>, # height
	
	<voiced voiceless>, # voicedness
	<labial coronal dorsal laryngeal bilabial linguolabial dental alveolar postalveolar retroflex palatal velar uvular pharyngeal glottal>, # place
	<nasal plosive sibilant affricate fricative approximant tap trill lateral>, # manner
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
dd %letters;

# find all aspects that are a letter is part of
sub get-aspects($letter) {
	return %letters{$letter};
}

# find all letters that fit a given aspect
sub get-letters($aspect) {
	my @letters;
	for %aspects.kv -> $name,@ltrs {
		#say @ltrs;
		@letters.push(|@ltrs) if $aspect eq $name;
	}
	return @letters;
}

# switch the aspect of a letter from one to another
#say switch-aspect("ɛ", "close"); # returns "i" cuz theyre both front unrounded
sub switch-aspect($letter, $to-aspect) {
	my @to-aspect = $to-aspect.Array;
	my $my-aspects = get-aspects($letter); #?? %letters{$letter} !! %consonants{$letter};
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
			} 
			# return the letter that addition of the set-intersection of the aspects is
			#say $my-aspects, @ex, @to-aspect;
			#dd @to-aspect, ($my-aspects (-) @ex)[0].keys, (($my-aspects (-) @ex) ∪ @to-aspect).keys;
			my $new-letter = get-letter-by-aspects((($my-aspects (-) @ex) ∪ @to-aspect).Array);
			$new-letter = $letter ~ "\x0339" if not $new-letter and @to-aspect ∋ "rounded";
			$new-letter = $letter ~ "\x031C" if not $new-letter and @to-aspect ∋ "unrounded";
			return $new-letter;
		}
	}
}


sub get-letter-by-aspects(@aspects where @aspects ~~ Array) {
	my @sets.push: %aspects{($_ ~~ Pair ?? $_.key !! $_)} for @aspects;
	#dd @aspects, @sets, [∩] @sets.sort;
	@sets = [∩] @sets.sort;

	#say @sets, @sets[0].sort».keys;
	if @sets[0].elems > 1 {
		my $correct = "";
		my $least = 999999;
		my $k = "";
		for @sets[0].sort».keys -> $key {
			$k = $key[0];
			return $k if get-aspects($k) ≡ @aspects;
			if get-aspects($k).elems < $least {
				$correct = $k;
				$least = get-aspects($k).elems;
			}
			#dd $k,get-aspects($k).elems,$least,$correct;
		}
		return $correct;
	} else {
		return @sets[0][0];
	}
	if @sets[0] ~~ Set {
		return @sets[0].sort».keys»[0];
	} else {
		return @sets[0][0];
	}
	die "{@aspects} is not a real letter";
}

sub move($letter, $dir where "close" | "open" | "front" | "back") {
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

my @tests1 = [%letters{"o"}.Array, <rounded front close>.Array, <unrounded central near-open open>.Array, <unrounded front close-mid>.Array];
my @results1 = ["o", "y", "ɐ", "e"];
for @tests1.kv -> $i,$v {
	#say "";
	my $value = get-letter-by-aspects($v);
	say ($value eq @results1[$i]) ?? colored("OK","black on_green")~" $v → $value" !! colored("NOT OK","white on_red")~" $v ≠ $value";
}
say "###########################";

my @tests2 = [<y near-back>, <u front>, <o open>, <a back>, <ɛ central>, <a near-close>, <u unrounded>, <u close-mid>, <ʊ unrounded>, <ä rounded>, <ɐ rounded>];
my @results2 = <ʊ y ɔ ɑ ɜ ɪ ɯ o ʊ̜ ä̹ ɐ>;
for @tests2.kv -> $i,$v {
	#say "";
	my $value = switch-aspect($v[0], $v[1]);
	say ($value eq @results2[$i]) ?? colored("OK","black on_green")~" {$v[0]} → {$v[1]} = $value" !! colored("NOT OK","white on_red")~" {$v[0]} → {$v[1]} ≠ $value";
}
say "###########################";

my @tests3 = [<y close>, <o open>, <ɜ back>, <a back>, <ʊ front>, <a front>, <ɘ close>, <ɐ back>, <ə open>];
my @results3 = <y o̞ ʌ ä ʉ̞ a ɨ̞ ɒ̝ ɜ>;
for @tests3.kv -> $i,$v {
	#say "";
	my $value = move($v[0], $v[1]);
	say ($value eq @results3[$i]) ?? colored("OK","black on_green")~" {$v[0]} → {$v[1]} = $value" !! colored("NOT OK","white on_red")~" {$v[0]} → {$v[1]} ≠ $value";
}
say "###########################";

my @tests4 = [%letters{"ɬ"}.Array, <voiced velar plosive>.Array, <velar plosive>.Array, <labial velar approximant>.Array, <velar approximant>.Array, <retroflex nasal>.Array];
my @results4 = ["ɬ", "ɡ", <k ɡ>, "w", <ɰ w ʍ ɫ ʟ>, <ɳ ɳ̊>];
for @tests4.kv -> $i,$v {
	#say "";
	my $value = get-letter-by-aspects($v);
	say ($value eq @results4[$i].sort) ?? colored("OK","black on_green")~" $v → $value" !! colored("NOT OK","white on_red")~" $v ≠ $value";
}
say "###########################";

my @tests5 = [<k glottal>, <p voiced>, <b fricative>, <k fricative>, <s plosive>];
my @results5 = <ʔ b β x t>;
for @tests5.kv -> $i,$v {
	#say "";
	my $value = switch-aspect($v[0], $v[1]);
	say ($value eq @results5[$i]) ?? colored("OK","black on_green")~" {$v[0]} → {$v[1]} = $value" !! colored("NOT OK","white on_red")~" {$v[0]} → {$v[1]} ≠ $value";
}

