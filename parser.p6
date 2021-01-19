#use Grammar::Tracer;
use Terminal::ANSIColor;

grammar Parser {
	rule TOP {
		[ <conversion>* <comment>? ]* %% [ '\n' | ';' ] 
	}
	rule conversion {
		<lhs=side> <becomes> <rhs=side> <when>?
	}
	rule when {
		['/'|'when'|'where'] <side>
	}
	regex side { #:sigspace # allow whitespace and backtracking so that <letter> doesnt swallow <becomes>
		<word-beg=word-break>? 
		[ \h 
			|| <features> 
			|| <class> 
			|| <reference>
			|| <placeholder> 
			|| <geminate> 
			|| <empty> 
			|| <no> 
			|| <letter>
		]+ 
		<word-end=word-break>? 
	}
	rule features {
		| <brackets>
		| <braces>
		| <parenthesis>
	}
	# the brackets represent all the features the changed sounds have in common
	rule brackets {
		'[' ~ ']' [
			# comma or whitespace delimited classes
			| [<sign>? [ <features> || <class> || <letter> ] \s*?]+ 
			| [<sign>? [ <features> || <class> || <letter> ] \s*?]+ %% ','
		]
	}
	# { } (Curly Braces): Indicate a logical-disjunction relationship of two expressions. For example,
	# The two expressions, ABD and AED and be written with curly braces as:
    # `A { B E } D`. A is followed by either B or E and then D.
	rule braces {
		| '{' ~ '}' [ <word-break> || <features> || <class> || <letter> \s*? ]+
		| '{' ~ '}' [ <word-break> || <features> || <class> || <letter> \s*? ]+ %% ','
	}
	# ( ) (Parenthesis): Indicate a logical-disjunction relationship of two expressions and an abbreviated version of the curly braces notation, while maintaining the same disjunctive relationship function. For example,
	# The two expressions, ABD and AD and be written with parentheses as:
    # `A ( B ) D`, B is optionally permitted to come between A and D.
	rule parenthesis {
		| '(' ~ ')' [ <features> || <class> || <letter> \s*? ]+ 
		| '(' ~ ')' [ <features> || <class> || <letter> \s*? ]+ %% ','
	}

	token sign {
		<[-+]>
	}
	token becomes {
		'→' | '>' | '->' | 'becomes' | 'is' | '='
	}
	rule letter {
		<[' \w] - [_]>+
	}
	token geminate { 'ː' }
	token word-break { '#' | ']word' | '[word' }
	token no { '!' | 'not' }
	token placeholder { '_'+ | '*'|'–'|'—' | '-'+ }
	token empty { '∅' | 'silent' }

	proto token class {*}
		token class:sym<consonants> 	{ 'C' | 'consonant' }
		token class:sym<vowels> 		{ 'V' | 'vowel' }
		token class:sym<syllable> 		{ 'S' | 'syllable' }
		token class:sym<fricative> 		{ 'F' | 'fricative' }
		token class:sym<stop> 			{ <sym> }
		token class:sym<alveolar> 		{ <sym> }
		token class:sym<stressed> 		{ <sym> }
		token class:sym<syllabic> 		{ <sym> }
		token class:sym<short> 			{ <sym> }
		token class:sym<spread glottis> { <sym> }
		token class:sym<aspirate> 		{ <sym> }
		token class:sym<tap> 			{ 'flap' | 'tap' }

		# major class features
		token class:sym<sonorant> 		{ <sym> }
		token class:sym<vocalic> 		{ <sym> }
		token class:sym<consonantal> 	{ <sym> }
		#cavity features
		token class:sym<coronal> 	{ <sym> }
		token class:sym<anterior> 	{ <sym> }
			# tongue body features
			token class:sym<high> 	{ <sym> }
			token class:sym<low> 	{ <sym> }
			token class:sym<back> 	{ <sym> }
		token class:sym<round> 	{ <sym> }
		token class:sym<distributed> 	{ <sym> }
		token class:sym<covered> 	{ <sym> }
		token class:sym<glottal constrictions> 	{ <sym> }
			#secondary apertures
			token class:sym<nasal> 	{ <sym> }
			token class:sym<lateral> 	{ <sym> }
		# manner of articulation features
		token class:sym<continuant> 	{ <sym> }
			#release features
			token class:sym<primary release> 	{ <sym> }
			token class:sym<secondary release> 	{ <sym> }
		# supplementary movements
		token class:sym<click> 	{ <sym> }
		token class:sym<ejective> 	{ <sym> }
		token class:sym<tense> 	{ <sym> }
		#source features
		token class:sym<voice> 	{ <sym> }
		token class:sym<strident> 	{ <sym> }
			#prosodic features
			token class:sym<stress> 	{ <sym> }
				# pitch
				token class:sym<high-pitch> 	{ <sym> }
				token class:sym<low-pitch> 	{ <sym> }
				token class:sym<elevated-pitch> 	{ <sym> }
				token class:sym<rising-pitch> 	{ <sym> }
				token class:sym<falling-pitch> 	{ <sym> }
				token class:sym<concave-pitch> 	{ <sym> }
			token class:sym<length> 	{ <sym> }
	
	token reference {
		\d+ [ ':' [ <class> | <features> ] ]?
	}

	rule comment {
		'//' \N* 
	}
}

#say Parser.parse("u → o; lj becomes j when _#; V# > ∅");
my @tests = [
	"V# > ∅", 
	"'o >we", 
	"# we → gwe  // we becomes gwe at the beginning of words", 
	"pt becomes p / !_V",
	"l -> l̥͡l / [+consonant -voice] __",
	"// /t/ and /d/ are flapped when they occur after a stressed vowel and before a stressless vowel",
	"[stop consonant alveolar] → ɾ / [+vowel +stressed] ___ [+vowel -stressed]",
	't → ∅ / !Vː_#',
	't → ∅ / ! Vː _ #',
	'f * > 2:F -',
	'[vowel] # becomes silent',
	q{'SSS → 'S [-V] S},
	q{[-continuant  -voice] -> [+spread glottis] / ! s ___ [-syllabic -stress]},
	'[stop] → [nasal] / _ [nasal]',
	'[stop]  [nasal] → 1:[nasal] 2',
	'[ʃ, ʒ, t͡ʃ, d͡ʒ] becomes [s, z, t͡s, d͡z] when _ [s, z] ',
	'a{be}d > acd',
	'x{y(z)} > acd',
	'x({yz}) > acd',
	'V → [+tense] / — {# V C{i e}V} ',
];
for @tests {
	say Parser.parse($_);
}
for @tests {
	my $parse = Parser.parse($_);
	if $parse {
		say colored("OK","black on_green"), " $_";
	} else {
		say colored("NOT OK","white on_red"), " $_";
	}
}
