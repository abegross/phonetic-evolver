my %aspects =
  "rounded"    => <y ʏ ø œ ɶ ʉ ɵ ə ɞ ɐ ä̹ ʊ o ɔ ɒ>,
  "unrounded"  => <i ɪ e ɛ æ a ɨ ɘ ə ɜ ɐ ä ɯ ɤ ʌ ɑ>,
  "front"      => <i y i̞ y̞ e ø e̞ ø̞ ɛ œ æ æ̹ a ɶ>,
  "near-front" => <ɪ ʏ>,
  "central"    => <ɨ ʉ ɨ̞ ʉ̞ ɘ ɵ ə ɜ ɞ ɐ ä ä̹>,
  "near-back"  => <ʊ̜ ʊ>,
  "back"       => <ɯ u ɯ̞ u̞ ɤ o ɤ̞ o̞ ʌ ɔ ɑ ɒ ɑ̝ ɒ̝>,
  "close"      => <i y i̙ y̙ ɨ ʉ ɯ̘ u̘ ɯ u>,
  "near-close" => <i̞ y̞ ɪ ʏ ɨ̞ ʉ̞ ʊ̜ ʊ ɯ̞ u̞>,
  "close-mid"  => <e ø e̙ ø̙ ɘ ɵ ɤ̘ o̘ ɤ o>,
  "mid"        => <e̞ ø̞ ə ɤ̞ o̞>,
  "near-open"  => <æ æ̹ ɐ ɑ̝ ɒ̝>,
  "open-mid"   => <ɛ œ ɜ ɞ ʌ ɔ>,
  "open"       => <a ɶ ä ä̹ ɑ ɒ>,
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
%aspects{"open"}  = (%aspects{"open"}  ∪ %aspects{"open-mid"}  ∪ %aspects{"near-open"}).keys.cache;
%aspects{"close"} = (%aspects{"close"} ∪ %aspects{"close-mid"} ∪ %aspects{"near-close"}).keys.cache;
%aspects{"mid"}   = (%aspects{"mid"}   ∪ %aspects{"close-mid"} ∪ %aspects{"open-mid"}).keys.cache;
%aspects{"front"} = (%aspects{"front"} ∪ %aspects{"near-front"}).keys.cache;
%aspects{"back"}  = (%aspects{"back"}  ∪ %aspects{"near-back"}).keys.cache;
# add aliases
%aspects{"high"}      := %aspects{"close"};
%aspects{"low"}       := %aspects{"open"};
%aspects{"high-mid"}  := %aspects{"close-mid"};
%aspects{"low-mid"}   := %aspects{"open-mid"};
%aspects{"near-high"} := %aspects{"near-close"};
%aspects{"near-low"}  := %aspects{"near-open"};


my (%vowels, @letters);
@letters = ([∪] %aspects.values).keys;
#dd @letters;
for @letters -> $letter {
	%vowels{$letter} = $[];
	for %aspects.kv -> $k, $v {
		%vowels{$letter}.push: $k if $v ∋ $letter;
	}
}
#dd %vowels;

my @exclusive = (<rounded unrounded>,  # roundedness
				<front central back near-front near-back>,  # backness
				<close close-mid near-close mid open open-mid near-open high low high-mid low-mid near-high near-low>); #height

# find all aspects that are a letter is part of
sub get-aspects($letter) {
	return %vowels{$letter};
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
# switch-aspect("ɛ", "close") # returns "i" cuz theyre both front unrounded
sub switch-aspect($letter, $to-aspect) {
	my @to-aspect = $to-aspect.Array;
	my $my-aspects = get-aspects($letter); #?? %vowels{$letter} !! %consonants{$letter};
	for @exclusive -> @ex {
		#say $my-aspects, @ex, " ", @to-aspect;
		# if $to-aspect is in @ex
		if @ex ∋ any(@to-aspect) {
			if @to-aspect ∋ "close" and $my-aspects ∋ "near-open" {
				@to-aspect = cut(@to-aspect, "close");
				@to-aspect.push: "near-close";
			} elsif @to-aspect ∋ "close" and $my-aspects ∋ "open-mid" {
				@to-aspect = cut(@to-aspect, "close");
				@to-aspect.push: "close-mid";
			} elsif @to-aspect ∋ "open" and $my-aspects ∋ "near-close" {
				@to-aspect = cut(@to-aspect, "open");
				@to-aspect.push: "near-open", "near";
			} elsif @to-aspect ∋ "open" and $my-aspects ∋ "close-mid" {
				@to-aspect = cut(@to-aspect, "open");
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
	##say @aspects;
	#my %letters;
	##say '';
	##dd @aspects;
#	@aspects.push: "open"  if @aspects ∋ "near-open" and @aspects ∌ "open";
#	@aspects.push: "close" if @aspects ∋ "near-close" and @aspects ∌ "close";
#	@aspects.push: "mid"   if (@aspects ∋ "close-mid" or @aspects ∋ "open-mid") and @aspects ∌ "mid";
#	@aspects.push: "low"  if @aspects ∋ "near-low" and @aspects ∌ "low";
#	@aspects.push: "high" if @aspects ∋ "near-high" and @aspects ∌ "high";
#	@aspects.push: "mid"   if (@aspects ∋ "high-mid" or @aspects ∋ "low-mid") and @aspects ∌ "mid";
	##dd @aspects;
	#for %vowels.kv -> $letter, $aspects {
		##say $letter;
		##if ($aspects (&) @aspects).elems == $aspects.elems {
		#return $letter if @aspects ≡ $aspects;
		## ⊃ means superset
		## ⊇ is (1,2,3) (>=) (2,3) #true
		#if (@aspects ⊆ $aspects) {
			##dd $letter, $aspects, @aspects, @aspects ∪ $aspects;
			#%letters{$letter} = $aspects;
			##return $letter;
		#}
	#}
	##return %letters.sort(:v)[*-1];
	##dd %letters;
	#return %letters.keys[0];# ?? %letters !! Nil;
	
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
	die "{@aspects} is not a real letter";
}

sub move($letter, $dir where "close"|"high" | "open"|"low" | "front" | "back") {
	##return "∅" if $dir ne "up" | "down" | "right" | "left";

	my ($x, $y, $max-x, $max-y, $v-elems);
	$max-y = @vowel-chart.elems-1;
	for @vowel-chart.kv -> $k,$v {
		if $v ∋ $letter {
			$y = $k;
			$x = $v.first($letter, :k);
		}
	}

	$y += 1 if $dir eq "open"|"low";
	$y -= 1 if $dir eq "close"|"high";
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

my @tests1 = [%vowels{"o"}.Array, <rounded front close>.Array, <unrounded central near-open open>.Array, <unrounded front high-mid>.Array];
my @results1 = <o y ɐ e>;
for @tests1.kv -> $i,$v {
	#say "";
	my $value = get-letter-by-aspects($v);
	say ($value eq @results1[$i]) ?? "OK: $v → $value" !! "NOT OK: $v ≠ $value";
}
say "###########################";

my @tests2 = [<y near-back>, <o open>, <a back>, <ɛ central>, <a near-close>, <u unrounded>, <u high-mid>, <ʊ unrounded>, <ä rounded>, <ɐ rounded>];
my @results2 = <ʊ ɔ ɑ ɜ ɪ ɯ o ʊ̜ ä̹ ɐ>;
for @tests2.kv -> $i,$v {
	#say "";
	my $value = switch-aspect($v[0], $v[1]);
	say ($value eq @results2[$i]) ?? "OK: {$v[0]} → {$v[1]} = $value" !! "NOT OK: {$v[0]} → {$v[1]} ≠ $value";
}
say "###########################";

my @tests3 = [<y close>, <o open>, <ɜ back>, <a back>, <ʊ front>, <a front>, <ɘ high>, <ɐ back>, <ə open>];
my @results3 = <y o̞ ʌ ä ʉ̞ a ɨ̞ ɒ̝ ɜ>;
for @tests3.kv -> $i,$v {
	#say "";
	my $value = move($v[0], $v[1]);
	say ($value eq @results3[$i]) ?? "OK: {$v[0]} → {$v[1]} = $value" !! "NOT OK: {$v[0]} → {$v[1]} ≠ $value";
}

#say get-letters("mid");
##say get-letters("mid").map: {$_, %vowels{$_}};
#say("ɜ",%vowels{"ɜ"}); # unrounded central open-mid mid
#say %vowels{switch-aspect("ɜ","close")} == <unrounded central close-mid mid> ?? "OK: ɜ → close = (unrounded central close-mid mid)" !! "NOT OK: ɜ → close ≠ {%vowels{switch-aspect('ɜ','close')}}";

#say "";

#say get-aspects(%consonants{"ʃ"});
#say %consonants{"ʃ"};
#say get-aspects(%consonants{"ɥ"});
#say get-letters($tap);
#say get-letters($tap).map: {$_, get-aspects(%consonants{$_})};
#say("q",get-aspects(%consonants{"q"})); # unrounded central open mid
#say(get-aspects(switch-aspect($uvular, $alveolar, %consonants{"q"}))); # unrounded central close mid
