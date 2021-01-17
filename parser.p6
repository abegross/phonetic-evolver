use Grammar::Tracer;
grammar Parser {
	rule TOP {
		[ <conversion>* <comment>? ]* %% [ '\n' | ';' ] 
	}
	rule conversion {
		<lhs=side> <becomes> <rhs=side> [['/'|'when'|'where'] <when=side>]?
	}
	regex side { #:sigspace # allow whitespace and backtracking so that <letter> doesnt swallow <becomes>
		<word-beg=word-end>? 
		[ <features> || <class> || <placeholder> || <empty> || <no> || <letter> ]+ 
		<word-end>? 
	}
	rule features {
		'[' ~ ']' [<sign>? <class> \s*]+
	}
	
	token sign {
		<[-+]>
	}
	token becomes {
		'→' | '>' | '->' | 'becomes' | 'is'
	}
	rule letter {
		<[' \w ː] - [V C _]>+
	}

	token word-end { '#' }
	token no { '!' | 'not' }
	token placeholder { '_'+ }
	token empty { '∅' | 'silent' }
	proto token class {*}
		token class:sym<consonants> { 'C' | 'consonant' }
		token class:sym<vowels> 	{ 'V' | 'vowel' }
		token class:sym<nasal> 		{ 'nasal' }
		token class:sym<stop> 		{ 'stop' }
		token class:sym<voice> 		{ 'voice' }
		token class:sym<alveolar> 	{ 'alveolar' }
		token class:sym<stressed> 	{ 'stressed' }
		token class:sym<short> 		{ 'short' }

	rule comment {
		'%' \N* 
	}
}

#say Parser.parse("u → o; lj becomes j when _#; V# > ∅");
my @tests = ["V# > ∅", 
	"'o >we", 
	"# we → gwe  % we becomes gwe at the beginning of words", 
	"pt becomes p / !_V",
	"l -> l̥͡l / [+consonant -voice] __",
	"% /t/ and /d/ are flapped when they occur after a stressed vowel and before a stressless vowel",
	"[+stop +consonant +alveolar] → ɾ / [+vowel +stressed] ___ [+vowel -stressed]",
	"t → ∅ / !Vː_#",
];
for @tests {
	say Parser.parse($_);
}
for @tests {
	my $parse = Parser.parse($_);
	if $parse {
		say "OK $_";
	} else {
		say "NOT OK $_";
	}
}
