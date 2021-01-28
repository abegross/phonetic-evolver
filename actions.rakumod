use IPA-Chart;

############################
###  regex embedded code ###
############################
# { CODE }    → runs perl6 code. no effect on regex matches
# <?{ CODE }> → code needs to return a true value for the match to succeed
# <!{ CODE }> → code needs to return a false value for the match to succeed
# <{ CODE }>  → result of code is interpreted as a regex
# $STRING     → interprets $STRING as a literal sequence of characters
# <$STRING>   → interprets $STRING as regex source code


class actions {
	has $.word;

	has $!from;
	has $!to;

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
				%side{"none"} ~= $element.made.join("") if $element.made;
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
				#dd $element;
				%side{"before"} ~= $element.made.join("") if $element.from > $placeholder;
				%side{"after"} ~= $element.made.join("") if $element.from < $placeholder;
			}
			$/.make: %side;
		} else {
			for $/.caps.values {
				my $element = .value;
				#dd $element;
				%side{"none"} ~= $element.made.join("") if $element.made;
			}
			$/.make: %side{"none"};
		}

		#say "side→", %side;
		#$/.make: %side;
		#say "done letter $<letter>";
	}
	method features($/) {
		$/.make: $<braces>.made;
	}
	method braces($/) {
		$/.make: "<["~$<side>».made.join("")~"]>";
	}

	method letter($/) {
		$/.make: ~$/.trim.subst(/\h/, "");
		#say $/.made;
	}
	method empty($/) {
		$/.make: "";
	}

	method class($/) {
		if !$<subscript> && !$<superscript> {
			$/.make: "['"~$<group>.made.join("'|'")~"']";
		} else {
			my $sup = $<superscript>.made;
			my $sub = $<subscript>.made;
			#dd $sub, $sub;
			#say "['"~$<group>.made.join("'|'")~"]**{$sub??$sub!!"0"}..{$sup??$sup!!"*"}";
			$/.make: "['"~$<group>.made.join("'|'")~"']**{$sub??$sub!!"0"}..{$sup??$sup!!"*"}";
			#$/.make: "["~$<group>.made.map({"|'$_'**{$sub??$sub!!"0"}..{$sup??$sup!!"*"}"})~"]";
		}
	}
	method group:sym<X>($/) { $/.make: '.'; }
	method group:sym<consonants>($/) { $/.make: consonants; }
	method group:sym<vowels>($/) { $/.make: vowels; }

	method subscript($/) {
		$/.make: $/.trans('₀₁₂₃₄₅₆₇₈₉' => '0123456789').Int;
	}
	method superscript($/) {
		$/.make: $/.trans('⁰¹²³⁴⁵⁶⁷⁸⁹' => '0123456789').Int;
	}

#	sub replace-all($str is rw, $from, $to) {
#		#say "all";
#		$str = $str.subst(/<$from>/, $to, :g);
#		return $str;
#	}

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
	sub replace(Str $str, $from, $to, Str :$before="", Str :$after="", :$word-beg, :$word-end) {
		#dd [$from, $to, $after, $before, $word-beg, $word-end];

		my $regex = ($after && $word-beg ?? "<?after \^ $after>" !!
					('^' if $word-beg) ~
					("<?after $after>" if $after)) ~

					$from ~

					($before && $word-end ?? "<?before $before \$>" !!
					("<?before $before>" if $before) ~
					('$' if $word-end));
		#say $regex;

		my $string = $str.subst(/<$regex>/, $to||"", :g);
		#dd $string;
		return $string;
	}

	# replace only if theres at least one of $surround surrounding $from. a → b // c = cab→cbb, acb→abb, cac→bab, dab→dab
	sub replace-neighboring(Str $str, $from, $to, Str :$surround, :$word-beg, :$word-end) {

		my $after = $surround if $str ~~ /<$surround><$from>/; 
		my $before = $surround if $str ~~ /<$from><$surround>/;
		#dd [$from, $to, $before, $after, $surround, $word-beg, $word-end];
		#dd $str ~~ /<$from><$surround>/;
		my $regex = ('^' if $word-beg) ~
					"[<?after $surround>?" ~ $from ~ "<?before $surround>|" ~
					"<?after $surround>" ~ $from ~ "]"~
					('$' if $word-end);
		#say $regex;

		my $string = $str.subst(/<$regex>/, $to||"", :g);
		#dd $string;
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
