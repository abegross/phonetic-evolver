use IPA-Chart;
use Terminal::ANSIColor;
use MONKEY;

############################
###  regex embedded code ###
############################
# { CODE }    → runs perl6 code. no effect on regex matches
# <?{ CODE }> → code needs to return a true value for the match to succeed
# <!{ CODE }> → code needs to return a false value for the match to succeed
# $( CODE )   → result of code is interpreted as a literal string
# <{ CODE }>  → result of code is interpreted as a regex
# $STRING     → interprets $STRING as a literal sequence of characters
# <$STRING>   → interprets $STRING as regex source code


class Actions {
	# the word/string the program will be working on
	has $.word;
	# a list of <references> that will get populated as the action class goes
	has %!refs;
	# all items in the from block
	has $!i=0;
	has %!from;

	method TOP($/) {
		#say $/;
		$!word = $<conversion>[*-1].made ?? $<conversion>[*-1].made !! $!word;
		#say $<conversion>».made; #say $!word;
		$/.make: $!word;
	}

	multi method conversion($/ where $<sides>) {
		my $sides = $<sides>.made;
		if $<lhs><jump> && $<rhs><jump> {
			$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>, before=>$<sides><letter>, after=>$<sides><letter>);
		} else {
			#$sides = '[' ~ $sides ~ ']?';
			#dd $sides;
			$/.make: replace-neighboring($!word, $<lhs>.made, $<rhs>.made, surround=>$sides);
		}
		$!word = $/.made if $/.made;
	}
	multi method conversion($/ where !$<when>) {
		#say $<lhs>.made, $<rhs>.made;
		if $<lhs><jump> && $<rhs><jump> {
			$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>);
		#} elsif $<class> {
			##say $<lhs>.made, $<rhs>.made;
			#$/.make: self.replace($!word, $<lhs>.made, $<rhs>.made, word-beg=>$<word-beg>, word-end=>$<word-end>);
		} else {
			#$/.make: self.replace-all($!word, $<lhs>.made, $<rhs>.made);
			$/.make: self.replace($!word, $<lhs>.made, $<rhs>.made);
		}
		$!word = $/.made if $/.made;
	}
	multi method conversion($/ where $<when> && $<when><placeholder>) {
		#say $/;

		#say $<lhs>.made, $<rhs>.made;
		#say $/;
		#dd replace-all($!word, $<lhs>.made, $<rhs>.made);
		my @placeholder = $<when><placeholder>;
		my %when = $<when>.made;
		if $<lhs><jump> && $<rhs><jump> {
			$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>, before=>%when{"before"}, after=>%when{"after"}, word-beg=>$<word-beg>, word-end=>$<word-end>);
		} else {
			$/.make: self.replace($!word, $<lhs>.made, $<rhs>.made, before=>%when{"before"}.split('', :skip-empty), after=>%when{"after"}.split('', :skip-empty), word-beg=>$<word-beg>, word-end=>$<word-end>);
		}
		#say "making $/";
		$!word = $/.made if $/.made;
		#say "made $!word";
	}
	multi method conversion($/ where $<when> && !$<when><placeholder>) {
		error($/, 'must have a placeholder (\'_\') in when block')
	}

	method side($/) {
		says $/;
		# first quit program if there are any errors
		if rhs($/) {
			error($/, 'braces not allowed in right hand side') if $<features>[0]<braces>;
		}
		error($/, "only one placeholder allowed in the when side") if $<placeholder> and $<placeholder>.elems > 1;

		my %side;
		if $<jump> {
			for $/.caps.values {
				my $element = .value;
				#dd $element;
				%side{"none"} ~= $element.made.join if $element.made;
			}
			$/.make: %side{"none"};

		# the $<when> block:
		} elsif $<placeholder> {
			my $placeholder = $<placeholder>.from;
			#dd $/.caps;
			#dd .value.from for $/.caps;
			%side{"before"} = "";
			%side{"after"} = "";
			for $/.caps.values {
				my $element = .value;
				#say $element;
				#dd $element;
				#say $element<parenthesis>.made;
				#dd $element<parenthesis>.made;
				if $element.made {
					my $made = $element.made.join;
					%side{"before"} ~= $made if $element.from > $placeholder;
					%side{"after"} ~= $made if $element.from < $placeholder;
				}
			}
			$/.make: %side;
		} else {
			for $/.caps.values {
				my $element = .value;
				#dd $element;
				%side{"none"} ~= $element.made.join if $element.made;
			}
			$/.make: %side{"none"};
		}

		#say "side→", %side;
		#$/.make: %side;
		#say "done letter $<letter>";
	}
	method features($/) {
		$/.make: make-all($/);
	}
	method braces($/) {
		#$/.make: "(<["~$<side>».made.join.subst(/<[()]>/,'',:g)~"]>)";
		#$/.make: "<["~$<side>».made.join~"]>";
		$/.make: $<side>».made;
		%!from{++$!i} = 'braces' => $<side>».made;
	}
	method parenthesis($/) {
		$/.make: "[" ~ $<side>».made.join ~"]?"
	}
	method brackets($/) {
		$/.make: make-all($/);
		#say $/.made;
	}

	method letter($/) {
		#$/.make: '(' ~ $/.trim.subst(/\h/, "") ~ ')';
		$/.make: $/.trim.subst(/\h/, "");
		#say $/.made;
	}
	method empty($/) {
		$/.make: ''.Str;
	}

	method reference($/) {
		if $/ eq '@' {
			$/.make: '~$/';
		} else {
			$/.make: '~$/[' ~ (+$<number> - 1)~']';
			if $<class> {
				# its a string so that it can get EVAL'ed later (in replace())
				$/.make: 'get-letters('~$/.made~',"'~ $<class>.made.subst(/<[()]>/,:g) ~'")';
			} elsif $<features> {
				$/.make: 'get-letters('~$/.made~',"'~ $<features>.made.subst(/<[()]>/,:g) ~'")';
			}
		}
		#say $/.made;
	}

	method class($/) {
		#dd $/;
		says "made:" , $<class>»<group>».made;
		if !rhs($/) {
			#say '!rhs';
			# if the sign on a class is a negative
			my @letters;
			for $<class> {
				says $_;
				if .<sign> && .<sign> eq '-' {
					@letters.push: |(get-letters($!word, .<group>.made, :negative))||.<group>.made;
				} else {
					@letters.push: |(get-letters($!word, .<group>.made))||.<group>.made;
				}
			}

			@letters = @letters.unique;
			dds @letters;
			$<class>[0].make: @letters;
		} else {
			$<class>[0].make: $<class>»<group>».made;
		}
		says "made:" , $<class>[0].made;
		my ($before, $after, $join) = ("","","");
		if !rhs($/) {
			$before = "[";
			$before = "['"  if $<class>[0].made ne '.';
			$join   = "'|'";
			$after  = "]";
			$after  = "']"  if $<class>[0].made ne '.';
		}

		#dd [rhs($/), $before, $join, $after];
		#say $<class>[0].made.join($join);
		if !$<subscript> && !$<superscript> {
				#$/.make: '('~$before~$<class>[0].made.join($join)~$after~')';
				$/.make: $before~$<class>[0].made.join($join)~$after;
				#say "class", $/.made;
		} else {
			my $sup = $<superscript>.made;
			my $sub = $<subscript>.made;
			#$/.make: '('~$before~$<class>[0].made.join($join)~$after~"**{$sub??$sub!!"0"}..{$sup??$sup!!"*"})" ;
			$/.make: $before~$<class>[0].made.join($join)~$after~"**{$sub??$sub!!"0"}..{$sup??$sup!!"*"}" ;
			#$/.make: "["~$<class>[0].made.map({"|'$_'**{$sub??$sub!!"0"}..{$sup??$sup!!"*"}"})~"]";
		}

		if $<number> {
			my $number = $<class>[0] ~ $<number>;#.Str.trans('1234567890' => 'abcdefghij');
			if not %!refs{$number}:exists and !rhs($/) {
				%!refs{$number} = $/.made;
				$/.make: '$<'~ $number ~ '>=' ~ $/.made;
				#$/.make: '<{%refs{"'~ $number ~ '"}}>';
			} elsif rhs($/) {
				$/.make: '~$<'~ $number ~ '>';
				#$/.make: '%refs{"'~ $number ~ '"}'; #=' ~ $/.made;
			} else {
				$/.make: '$<'~ $number ~ '>';
			}
		}
	}

	method group:sym<X>($/) { $/.make: '.'; }
	method group:sym<consonants>($/) { $/.make: "consonants" } #consonants; }
	method group:sym<vowels>($/) { $/.make: "vowels"} #vowels; }
	method group:sym<fricative>($/) 		{$/.make("fricative");}
	method group:sym<affricate>($/) 		{$/.make("affricate");}
	method group:sym<laryngeal>($/) 		{$/.make("laryngeal");}
	method group:sym<semivowel>($/) 		{$/.make("semivowel");}
	method group:sym<sibilant>($/) 		{$/.make("sibilant");}
	method group:sym<approximant>($/) 	{$/.make("approximant");}
	method group:sym<labial>($/) 		{$/.make("labial");}
	method group:sym<dental>($/) 		{$/.make("dental");}
	method group:sym<palatal>($/) 		{$/.make("palatal");}
	method group:sym<plosive>($/) 		{$/.make("plosive");}
	method group:sym<alveolar>($/) 		{ $/.make("alveolar"); }
	method group:sym<stressed>($/) 		{ $/.make("stressed"); }
	method group:sym<syllabic>($/) 		{$/.make("syllabic");}
	method group:sym<short>($/) 			{ $/.make("short"); }
	method group:sym<spread-glottis>($/) {$/.make("spread-glottis");}
	method group:sym<aspirated>($/) 		{$/.make("aspirated");}
	method group:sym<tap>($/) 			{$/.make("tap");}
	# major group features
	method group:sym<sonorant>($/) 		{$/.make("sonorant");}
	method group:sym<velar>($/) 			{$/.make("velar");}
	method group:sym<liquid>($/) 		{$/.make("liquid");}
	method group:sym<vocalic>($/) 		{$/.make("vocalic");}
	method group:sym<consonantal>($/) 	{$/.make("consonantal");}
	#cavity features
	method group:sym<coronal>($/) 	{ $/.make("coronal"); }
	method group:sym<anterior>($/) 	{ $/.make("anterior"); }
		# tongue body features
		method group:sym<close>($/) 	{$/.make("close");}
		method group:sym<near-close>($/) 	{$/.make("near-close");}
		method group:sym<close-mid>($/) 	{$/.make("close-mid");}
		method group:sym<mid>($/) 	{$/.make("mid");}
		method group:sym<open-mid>($/) 	{$/.make("open-mid");}
		method group:sym<near-open>($/) 	{$/.make("near-open");}
		method group:sym<open>($/) 	{$/.make("open");}
		method group:sym<back>($/) 	{$/.make("back");}
		method group:sym<center>($/) 	{ $/.make("center"); }
		method group:sym<front>($/) 	{$/.make("front");}
	method group:sym<rounded>($/) 	{ $/.make("rounded"); }
	method group:sym<unrounded>($/) 	{ $/.make("unrounded"); }
	method group:sym<distributed>($/) 	{ $/.make("distributed"); }
	method group:sym<covered>($/) 	{ $/.make("covered"); }
	method group:sym<glottal>($/) 	{$/.make("glottal");}
		#secondary apertures
		method group:sym<nasal>($/) { $/.make("nasal"); }
		method group:sym<lateral>($/) 	{ $/.make("lateral"); }
	# manner of articulation features
	method group:sym<continuant>($/) 	{$/.make("continuant");}
		#release features
		method group:sym<primary release>($/) 	{ $/.make("primary release"); }
		method group:sym<secondary release>($/) 	{ $/.make("secondary release"); }
	# supplementary movements
	method group:sym<click>($/) 	{ $/.make("click"); }
	method group:sym<ejective>($/) 	{ $/.make("ejective"); }
	method group:sym<tense>($/) 	{ $/.make("tense"); }
	#source features
	method group:sym<voiced>($/) 	{ $/.make("voiced"); }
	method group:sym<voiceless>($/) 	{ $/.make("voiceless"); }
	method group:sym<strident>($/) 	{ $/.make("strident"); }
		#prosodic features
		method group:sym<stress>($/) 	{ $/.make("stress"); }
			# pitch
			method group:sym<high-pitch>($/) 	{ $/.make("high-pitch"); }
			method group:sym<low-pitch>($/) 	{ $/.make("low-pitch"); }
			method group:sym<elevated-pitch>($/) 	{ $/.make("elevated-pitch"); }
			method group:sym<rising-pitch>($/) 	{ $/.make("rising-pitch"); }
			method group:sym<falling-pitch>($/) 	{ $/.make("falling-pitch"); }
			method group:sym<concave-pitch>($/) 	{ $/.make("concave-pitch"); }
		method group:sym<length>($/) 	{ $/.make("length"); }


	method subscript($/) {
		$/.make: $/.trans('₀₁₂₃₄₅₆₇₈₉' => '0123456789').Int;
	}
	method superscript($/) {
		$/.make: $/.trans('⁰¹²³⁴⁵⁶⁷⁸⁹' => '0123456789').Int;
	}

	sub make-all($/) {
		my $made = "";
		for $/.caps.values {
			my $element = .value;
			#say $element;
			$made ~= $element.made.join("") if $element.made;
		}
		return $made;
	}

	# check if we're in the rhs (right hand side) of the phonological rule
	sub rhs($this) {
		# make variables to figure out where we are in the regex
		my $self = $this.from;
		my $str = $this.orig.substr(($this.orig.rindex(';', $self)||0)..*) || $this.orig;
		$self -= ($this.orig.rindex(';', $self)||0);
		my $left = find-index($str, /<[→>=]>|'->'|'=>'|'is'|'becomes'/);
		my $when = find-index($str, /'/'|'when'|'where'/);
		# make $rhs = True if we're currently on the right hand side of the equation
		my Bool $rhs = True if $self > $left && ($when?? $self < $when !! True);
		return $rhs;
	}

	sub find-index(Str $str, Regex $regex) {
		return $str.match($regex).from;
	}

	sub error(Match $/, Str $message) {
		says "$message:\n{colored($/.prematch, 'green')}{colored('⏏','yellow')}{colored($/.Str, 'red')}{$/.postmatch}";
		exit;
	}

	## if there needs to be a letter surrounding the placeholder
	#sub _s_($str is rw, $from, $to, $before, $after, :$word-beg=False, :$word-end=False) {
		#my %letters{"letter"} = $str.split("",:skip-empty);
		#for %letters{"letter"}.kv -> $k,$letter {
			#if $before.starts-with($letter) and 
				#$from.starts-with(%letters{"letter"}[$k+$before.chars]) and
				#$after.starts-with(%letters{"letter"}[$k+$before.chars+$from.chars]) {
					#return $str.substr(0,$k+$before.chars) ~ $to ~ $str.substr($k+$before.chars+$from.chars-1);
			#}
		#}
	#}

	# replace all occurrences conditionally
	method replace(Str $str, $from, $to-temp, :@before, :@after, :$word-beg, :$word-end) {
		my $to = S:g/<[()]>// given $to-temp||"";
		#my $string = $str;
		#dds [$str, $from, $to, $after, $before, $word-beg, $word-end];

		my $result = '';
		my @letters = |$str.split('',:skip-empty);
		#my @after = $after.split('', :skip-empty);
		my @from = $from.split('', :skip-empty);
		#my @before = $before.split('', :skip-empty);
		dds [@letters, %!from, @from, $to, @after, @before];
		my Int ($start, $end) = (0,0);
		my $i = 0;
		my $add = 0;
		# loop through all characters in the string
		while $i < @letters.elems {
			says $i;
			$add = 0;
			my $letter;
			# for each letter that we need to match…
			#my $i = $k;

			if ($word-beg ?? ($i-@after.elems==0) !! True) and
			   ($word-end ?? ($i==@letters.elems-@before.elems-1) !! True)
			{
				for %!from.kv -> $k, $v {
					says $k, $v;
					for $v.kv -> $kk, $vv {
						if $kk eq 'braces' {
							for $vv.values -> $ltr {
								says $ltr, ' ', @letters[$i];
								if $ltr eq @letters[$i] {
									says @letters[($i-@after.elems>0??$i-@after.elems!!0)..$i-1];
									says @letters[$i+1..($i+@before.elems < @letters.elems??$i+@before.elems!!$i+1)];
									if @letters[($i-@after.elems>0??$i-@after.elems!!0)..$i-1] ≡ @after and
									   @letters[$i+1..($i+@before.elems < @letters.elems??$i+@before.elems!!$i+1)] ≡ @before 
									{
										$letter = $to;
									}
								}
							}
						# if all else fails then its a regular old plain letter than just 
						# needs to get changed without doing anything fancy
						} else {
							#for @from.kv -> $j,$f {
								#says $i, $j ;
								#says $f;
								#if $f ne @letters[$i+$j] { last }
								#if $f eq @letters[$i+$j] {
									## check if '$before' and '$after' match correctly
									#if @letters[($i-@after.elems>0??$i-@after.elems!!0)..$i-1] ≡ @after and
									   #@letters[$i+1..($i+@before.elems < @letters.elems??$i+@before.elems!!$i+1)] ≡ @before {
										#says 'equal';
										#$letter = $to;
										#$add = @from.elems;
										#says $letter;
									#}
								##$letter = $to if $f eq $letter;
								#}
							#}
						}
					}
				}
			}

			says $letter ?? 'yes' !! 'no';
			$result ~= $letter||@letters[clamp($i, 0, @letters.elems-1)].join;
			$i += $add==0??1!!$add;
			says $result;
			#last if $i == @letters.elems;

			#for @before -> $b {
				#says $b;
				#last if $b ne $letter;
			#}
		}
		return $result;


		##my $to = S:g/<[()]>// given $to-temp||"";
		#my $to = $to-temp||"";
		#my $string = $str;
		#dds [$string, $from, $to, $after, $before, $word-beg, $word-end];

		#my $dest = '';
		## im only doing EVAL cuz i couldnt come up with something better.
		## i would really appreciate a pull request on this
		##my sub dest($/, $dest) { dd $dest; my $to = EVAL($dest); dd $to; return $to }
		#my sub dest($/) { my $to = EVAL($dest); return $to }
		#my %ltrs;
		##say %aspects{S:g/<[()]>// given $to}:exists;
		#if %aspects{S:g/<[()]>// given $to}:exists {
			##say (S:g/<[()[\]'|]>// given $from).split('',:skip-empty);
			##for (S:g/<[()[\]'|]>// given $from).split('',:skip-empty) {
				##$string = $string.subst(/<$_>/, switch-aspect($_, $to)||$_, :g) if $_;
			##}
			##dd $string;

			##dd (S:g/<[()[\]'|]>// given $from).split('',:skip-empty);
			#$dest = $from.split('|').map({S:g/<[()[\]']>// given $_}).map({%ltrs{$_} = switch-aspect($_, (S:g/<[()]>// given $to))||''});
			#S/.// given $dest;
			##dd $dest;

			#for $from.split('|').map({S:g/<[()[\]']>// given $_}) {
				##say $_;
				#my $regex = ($after && $word-beg ?? "<?after ^ {S:g/<[()]>// given $after}>" !!
							#('^' if $word-beg) ~
							#("<?after {S:g/<[()]>// given $after}>" if $after)) ~

							#($_ if $_) ~

							#($before && $word-end ?? "<?before {S:g/<[()]>// given $before} \$>" !!
							#("<?before {S:g/<[()]>// given $before}>" if $before) ~
							#('$' if $word-end));
				#dd $regex;

				##say $string ~~ m:g/<$regex>/;
				#dd $string;
				#say $_,': ',  %ltrs{$_};
				## TODO: do :ignoremark only if theres no marks in $from
				## 		else: leave it as is so that it properly matcheS only the coRrect marks
				#$string = $string.subst(/<$regex>/, %ltrs{$_}, :g) if %ltrs{$_};
				#dd $string;
			#}
		#} else {
			#$dest = $to;

			#my $regex = ($after && $word-beg ?? "<?after ^ {S:g/<[()]>// given $after}>" !!
						#('^' if $word-beg) ~
						#("{S:g/<[()]>// given $after}" if $after)) ~

						#'<(' ~ ($from if $from) ~ ')>' ~

						#($before && $word-end ?? "<?before {S:g/<[()]>// given $before} \$>" !!
						#("{S:g/<[()]>// given $before}" if $before) ~
						#('$' if $word-end));
			#dds $regex;

			##say $string ~~ m:g/<$regex>/;
			#my %refs = %!refs;
			##for %refs.kv -> $k,$v {
				##$v.substr-rw('$', '$/[0]') if $v.contains('$');
			##}
			#$dest = $dest.subst('$<', '$/<', :g) if $dest.contains('$<');
			#dds $dest;
			## TODO: for %!refs { make  }
			##EVAL('my token '~.key~' { '~.value~' }') for %!refs;
			###say $_ for %!refs;
			##my regex b { (['i'|'y'|'i̙'|'y̙'|'ɨ'|'ʉ'|'ɯ̘'|'u̘'|'ɯ'|'u'|'i̞'|'y̞'|'ɪ'|'ʏ'|'ɨ̞'|'ʉ̞'|'ʊ̜'|'ʊ'|'ɯ̞'|'u̞'|'e'|'ø'|'e̙'|'ø̙'|'ɘ'|'ɵ'|'ɤ̘'|'o̘'|'ɤ'|'o'|'e̞'|'ø̞'|'ə'|'ɤ̞'|'o̞'|'ɛ'|'œ'|'ɜ'|'ɞ'|'ʌ'|'ɔ'|'æ'|'æ̹'|'ɐ'|'ɑ̝'|'ɒ̝'|'a'|'ɶ'|'ä'|'ä̹'|'ɑ'|'ɒ']) };
			#$string = EVAL('$string.subst(rx:ignoremark/'~$regex~'/, {$dest.contains("\$")??&dest($/)!!(S:g/<[()]>// given $dest)}, :g)');
			#says $/;
			##say $/[0]<mine>[0], $/[0]<mine>[1];
			#dds $string;
		#}
		##dd $dest;

		#dds %!refs;
		##dd $string;
		#return $string;
	}

	# replace only if theres at least one of $surround surrounding $from. a → b // c = cab→cbb, acb→abb, cac→bab, dab→dab
	sub replace-neighboring(Str $str, $from, $to, Str :$surround, :$word-beg, :$word-end) {
		my $dest = S:g/<[()]>// given $to;
		my $after = $surround if $str ~~ /<$surround><$from>/; 
		my $before = $surround if $str ~~ /<$from><$surround>/;
		#dd [$from, $to, $before, $after, $surround, $word-beg, $word-end];
		my $regex = ('^' if $word-beg) ~
					"[<?after {S:g/<[()]>// given $surround}>?" ~ $from ~ "<?before {S:g/<[()]>// given $surround}>|" ~
					"<?after {S:g/<[()]>// given $surround}>" ~ $from ~ "]"~
					('$' if $word-end);
		says $regex;

		my $string = $str.subst(/<$regex>/, $dest||"", :g);
		return $string;
	}

	sub metathesis($str is rw, $from, $to, :$before="", :$after="", :$word-beg, :$word-end) {
		die "must have 2 letters for metathesis" if $from.elems < 2;
		die "must have 2 letters for metathesis" if $to.elems < 2;
		my $from0 = $from[0].made;
		my $from1 = $from[1].made;
		my $to0 = S:g/<[()]>// given $to[0].made;
		my $to1 = S:g/<[()]>// given $to[1].made;
		my $Before = $before ?? (S:g/<[()]>// given $before) !! '';
		my $After = $after ?? (S:g/<[()]>// given $after) !! '';
		my $negative = "<-[$from0]>";

		my Str $beg = '^' if $word-beg;
		my Str $end = '$' if $word-end;
		my Str $left = $beg;
		$left ~= $After if $After;
		$left ~= $from0 if $from0;
		my Str $right = $from1;
		$right ~= $Before if $Before;
		$right ~= $end if $end;
		#dd [$from[0].made, $from[1].made, $to[0].made, $to[1].made, $before, $after, $beg, $end];
		if !$word-beg {
			$str ~~ s/<$left>(<$negative>*?.)<$right>/$After$to0$0$to1$Before/;
		} else {
			$str ~~ s/<$left>(.+?)<$right>/$After$to0$0$to1$Before/;
		}
		return $str;
	}

	sub dds(**@c) {
		dd |@c;
	}
	sub says(**@c) {
		say |@c;
	}
}
