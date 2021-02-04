use AST;
use IPA-Chart;
use Data::Dump;


class Evaluator {
	has $.word;

	method eval(ASTNode $top) {
		my $word = $!word;
		#say Dump $top;
		$word = self.replace($word, $_) for $top.conversions;
		#say Dump $word;
		$!word = $word;
	}


	# replace all occurrences conditionally
	method replace($str, $conv) {
		say 'in here';
		say $str;

		#say $conv;
		say 'done';
		my ($after, $before, $orig, $dest) = ('', '', '', '');
		my $lhs = '['~$conv.lhs.classes[0].class.map({"|'$_'"})~']';
		my $rhs = $conv.rhs;
		my $word-beg = $conv.word-beg;
		my $word-end = $conv.word-end;
		$after = $conv.preceded;
		$before = $conv.followed;
		#$after = $conv.preceded».[0] if $conv.preceded;
		#$before = $conv.followed».[0] if $conv.followed;

		#die 'lhs and rhs must be balanced' if $rhs.elems > $lhs.elems;
		#say $rhs;
		if $rhs.references {
			for $rhs.references {
				say $_;
				$dest ~= '$'
			}
		}

		dd [$lhs, $rhs, $after, $before, $word-beg, $word-end];

		#my Str $dest;
		#say %aspects{$rhs}:exists;
		#if %aspects{$rhs}:exists {
			#$dest = $lhs.map({switch-aspect($_, $rhs)}).join.Str;
		#} else {
			#$dest = $rhs;
		#}
		#dd $dest;
		my $string = '';



		my $regex = ($after && $word-beg ?? "<?after ^ {$after.join}>" !!
					('^' if $word-beg) ~
					("<?after {$after.join}>" if $after)) ~

					($lhs.join) ~

					($before && $word-end ?? "<?before $before \$>" !!
					("<?before {$before.join}>" if $before) ~
					('$' if $word-end));
		dd $regex;
		$string = S:g/<$regex>/$rhs/ given $str;
		#say $string;

		##dd $string;
		return $string;
	}

	method result { return $!word; }

	sub get-side($side) {
		return unless $side;

		my $ltrs = '';
		$ltrs = '[' ~ $side.classes[0].class.map({"|'$_'"}) ~ ']' if $side.classes;
		if $side.features and $side.features[0].braces {
			$ltrs = $side.features[0].braces».side».letters;
			$ltrs = $ltrs[0];
			$ltrs = '[' ~ $ltrs.map({"|'$_'"}) ~ ']';
		}
		$ltrs = $side.letters[0] if $side.letters;

		return $ltrs;
	}
}
