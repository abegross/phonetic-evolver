grammar Test {
	token TOP {
		[\h || <no> || <class> || <geminate> || <placeholder> || <letter>]+
		<word-end>?
	}
	token no { '!' }
	token geminate { 'ː' }
	token placeholder { '_'+ }
	token letter {
		<[' \w] - [_]>+
	}

	proto token class { * }
		token class:sym<syllable>  { 'S' | 'syllable' }
		token class:sym<vowel>     { 'V' | 'vowel' }
		token class:sym<consonant> { 'C' | 'consonant' }
	
	token word-end { '#' }
}
say Test.parse: '!Vː_#';
say Test.parse: '! Vː _ #';
