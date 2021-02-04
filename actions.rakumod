use IPA-Chart;
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
	has $.word;

	method TOP($/) {
		#say $/;
		$!word = $<conversion>[*-1].made ?? $<conversion>[*-1].made !! $!word;
		#say $<conversion>».made;
		#say $!word;
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
			#$/.make: replace($!word, $<lhs>.made, $<rhs>.made, word-beg=>$<word-beg>, word-end=>$<word-end>);
		} else {
			#$/.make: replace-all($!word, $<lhs>.made, $<rhs>.made);
			$/.make: replace($!word, $<lhs>.made, $<rhs>.made);
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
			$/.make: replace($!word, $<lhs>.made, $<rhs>.made, before=>%when{"before"}, after=>%when{"after"}, word-beg=>$<word-beg>, word-end=>$<word-end>);
		}
		#%letters{"letter"} = $<when><letter> if $<when><letter>;
		#%letters{"features"} = $<when><features> if $<when><features>;
		#%letters{"class"} = $<when><class> if $<when><class>;
		#dd @placeholder;
		#say %letters;
		#if %letters {
			## if the placeholder is before a letter 
			#if %letters{"letter"}[0].from ≥ 0 and @placeholder[0].from < %letters{"letter"}[0].from {
				#if $<word-beg> and $!word.starts-with($<lhs>.made) and $<lhs><jump> && $<rhs><jump> {
					#$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>);
				#} elsif $<lhs><jump> && $<rhs><jump> {
						#$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>, before=>%letters{"letter"}[0].made);
					#} else {
						##say "here";
						#$/.make: replace($!word, $<lhs>.made, $<rhs>.made, before=>%letters{"letter"}[0].made, word-beg=>$<word-beg>, word-end=>$<word-end>);
					#}
			## if the placeholder is after a letter 
			#} elsif @placeholder[0].from > %letters{"letter"}[0].from {
				#if $<lhs><jump> && $<rhs><jump> {
					#$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>, after=>%letters{"letter"}[0].made);
				#} else  {
					##$/.make: _s($!word, $<lhs>.made, $<rhs>.made, %letters{"letter"}[0].made);
					#$/.make: replace($!word, $<lhs>.made, $<rhs>.made, after=>%letters{"letter"}[0].made);
				#}
			#} else {
				#if $<lhs><jump> && $<rhs><jump> {
					#$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>, before=>%letters{"letter"}[0].made, after=>%letters{"letter"}[1].made);
				#} else  {
					##$/.make: _s_($!word, $<lhs>.made, $<rhs>.made, %letters{"letter"}[0].made, %letters{"letter"}[1].made);
					#$/.make: replace($!word, $<lhs>.made, $<rhs>.made, after=>%letters{"letter"}[0].made, before=>%letters{"letter"}[1].made);
				#}
			#}
		#} else {
			#if $<lhs><jump> && $<rhs><jump> {
				#if ($<word-beg> and $!word.starts-with($<lhs>.made[0])) or
					#($<word-end> and $!word.ends-with($<lhs>.made[0])) {
					##say "here";
					#$/.make: metathesis($!word, $<lhs><letter>, $<rhs><letter>);
				#}
			#} else  {
				#$/.make: replace($!word, $<lhs>.made, $<rhs>.made, word-beg=>$<word-beg>, word-end=>$<word-end>);
			#}
		#}
		#say "making $/";
		$!word = $/.made if $/.made;
		#say "made $!word";
	}

	method side($/) {
		die "only one placeholder allowed in the when block $/" if $<placeholder> and $<placeholder>.elems > 1;

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
		$/.make: "(<["~$<side>».made.join~"]>)";
	}
	method parenthesis($/) {
		$/.make: "([" ~ $<side>».made.join ~"]?)"
	}
	method brackets($/) {
		$/.make: make-all($/);
		#say $/.made;
	}

	method letter($/) {
		$/.make: $/.trim.subst(/\h/, "");
		#say $/.made;
	}
	method empty($/) {
		$/.make: ''.Str;
	}

	method reference($/) {
		if $/ eq '@' {
			$/.make: '~$/.orig';
		} else {
			$/.make: '~$/.split("",:skip-empty)[' ~ (+$/ - 1)~']';
		}
		#say $/.made;
	}

	method class($/) {
		#dd $/;
		#say "made:" , $<group>.made;
		if !rhs($/) {
			$<group>.make: get-letters($!word, $<group>.made)||$<group>.made if $<group>;
		#} else {
			#$<group>.make: switch-aspect("n", $<group>.made) if $<group>;
		}
		#say "made:" , $<group>.made;
		my ($before, $after, $join) = ("","","");
		if !rhs($/) {
			$before = "[";
			$before = "['"  if $<group>.made ne '.';
			$join   = "'|'";
			$after  = "]";
			$after  = "']"  if $<group>.made ne '.';
		}

		#dd [rhs($/), $before, $join, $after];
		#say $<group>.made.join($join);
		if !$<subscript> && !$<superscript> {
				$/.make: '('~$before~$<group>.made.join($join)~$after~')';
				#say "class", $/.made;
		} else {
			my $sup = $<superscript>.made;
			my $sub = $<subscript>.made;
			$/.make: '('~$before~$<group>.made.join($join)~$after~"**{$sub??$sub!!"0"}..{$sup??$sup!!"*"})" ;
			#$/.make: "["~$<group>.made.map({"|'$_'**{$sub??$sub!!"0"}..{$sup??$sup!!"*"}"})~"]";
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
	method group:sym<round>($/) 	{ $/.make("round"); }
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
	method group:sym<voice>($/) 	{ $/.make("voice"); }
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
		my $left = find-index($this.orig, /<[→>=]>|'->'|'is'|'becomes'/);
		my $when = find-index($this.orig, /'/'|'when'|'where'/);
		# make $rhs = True if we're currently on the right hand side of the equation
		my Bool $rhs = True if $self > $left && ($when?? $self < $when !! True);
		return $rhs;
	}

	sub find-index($str, $regex) {
		return $str.match($regex).from;
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
	sub replace(Str $str is rw, $from, $to-temp, Str :$before="", Str :$after="", :$word-beg, :$word-end) {
		#my $to = S:g/<[()]>// given $to-temp||"";
		my $to = $to-temp||"";
		my $string = $str;
		#dd [$string, $from, $to, $after, $before, $word-beg, $word-end];

		my $dest = '';
		my %ltrs;
		#say %aspects{S:g/<[()]>// given $to}:exists;
		if %aspects{S:g/<[()]>// given $to}:exists {
			#say (S:g/<[()[\]'|]>// given $from).split('',:skip-empty);
			#for (S:g/<[()[\]'|]>// given $from).split('',:skip-empty) {
				#$string = $string.subst(/<$_>/, switch-aspect($_, $to)||$_, :g) if $_;
			#}
			#dd $string;

			my $destination = (S:g/<[()[\]'|]>// given $from).split('',:skip-empty).map({%ltrs{$_} = switch-aspect($_, (S:g/<[()]>// given $to))});
			say $destination;

			for (S:g/<[()[\]'|]>// given $from).split('',:skip-empty) {
				#say $_;
				my $regex = ($after && $word-beg ?? "<?after ^ {S:g/<[()]>// given $after}>" !!
							('^' if $word-beg) ~
							("<?after {S:g/<[()]>// given $after}>" if $after)) ~

							($_ if $_) ~

							($before && $word-end ?? "<?before {S:g/<[()]>// given $before} \$>" !!
							("<?before {S:g/<[()]>// given $before}>" if $before) ~
							('$' if $word-end));
				#dd $regex;

				#say $string ~~ m:g/<$regex>/;
				my sub dest($/) { my $to = EVAL($destination); return $to }
				#dd $string;
				#say $_,  %ltrs{$_};
				$string = $string.subst(/<$regex>/, %ltrs{$_}, :g) if %ltrs{$_};
			}
		} else {
			$dest = $to;

			my $regex = ($after && $word-beg ?? "<?after ^ {S:g/'('|')'// given $after}>" !!
						('^' if $word-beg) ~
						("<?after {S:g/'('|')'// given $after}>" if $after)) ~

						($from if $from) ~

						($before && $word-end ?? "<?before {S:g/'('|')'// given $before} \$>" !!
						("<?before {S:g/'('|')'// given $before}>" if $before) ~
						('$' if $word-end));
			#dd $regex;

			#say $string ~~ m:g/<$regex>/;
			my sub dest($/) { my $to = EVAL($dest); return $to }
			#dd $string;
			$string = $string.subst(/<$regex>/, $dest.contains('$')??&dest!!(S:g/<[()]>// given $dest), :g);
		}
		#dd $dest;

		#dd $string;
		return $string;
	}

	# replace only if theres at least one of $surround surrounding $from. a → b // c = cab→cbb, acb→abb, cac→bab, dab→dab
	sub replace-neighboring(Str $str, $from, $to, Str :$surround, :$word-beg, :$word-end) {

		my $after = $surround if $str ~~ /<$surround><$from>/; 
		my $before = $surround if $str ~~ /<$from><$surround>/;
		#dd [$from, $to, $before, $after, $surround, $word-beg, $word-end];
		my $regex = ('^' if $word-beg) ~
					"[<?after $surround>?" ~ $from ~ "<?before $surround>|" ~
					"<?after $surround>" ~ $from ~ "]"~
					('$' if $word-end);
		#say $regex;

		my $string = $str.subst(/<$regex>/, $to||"", :g);
		return $string;
	}

	sub metathesis($str is rw, $from, $to, :$before="", :$after="", :$word-beg, :$word-end) {
		die "must have 2 letters for metathesis" if $from.elems < 2;
		die "must have 2 letters for metathesis" if $to.elems < 2;
		my $from0 = $from[0].made;
		my $from1 = $from[1].made;
		my $to0 = $to[0].made;
		my $to1 = $to[1].made;
		my $negative = "<-[$from0]>";

		my Str $beg = '^' if $word-beg;
		my Str $end = '$' if $word-end;
		my Str $left = $beg;
		$left ~= $after if $after;
		$left ~= $from0 if $from0;
		my Str $right = $from1;
		$right ~= $before if $before;
		$right ~= $end if $end;
		#dd [$from[0].made, $from[1].made, $to[0].made, $to[1].made, $before, $after, $beg, $end];
		if !$word-beg {
			$str ~~ s/<$left>(<$negative>*?.)<$right>/$after$to0$0$to1$before/;
		} else {
			$str ~~ s/<$left>(.+?)<$right>/$after$to0$0$to1$before/;
		}
		return $str;
	}
}
