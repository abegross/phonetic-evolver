#use Grammar::Tracer;

grammar Parser {
	rule TOP {
		[ <conversion>* <comment>? ]* %% [ '\n' | ';' ]
	}
	rule conversion {
		<lhs=side> <becomes> <rhs=side> 
		[ <where> <word-beg=word-break>?
			#[<preceded=side>? <placeholder> <followed=side> || <preceded=side> <placeholder> || <placeholder>]
			<when=side>
		<word-end=word-break>? 
		| <surround> <word-beg=word-break>? <sides=side> <word-end=word-break>? ]?
	}

	regex side {
		[ \h+
			|| <placeholder>
			|| <features>
			|| <class>
			|| <jump>
			|| <reference>
			|| <geminate>
			|| <empty>
			|| <no>
			|| <letter>
		]+


	}

	rule features {
		| <brackets>
		| <braces>
		| <parenthesis>
		| <chevrons>
	}
	# the brackets represent all the features the changed sounds have in common
	rule brackets {
		'[' ~ ']' [
			# comma or whitespace delimited classes
			| [ <features> || <class> || <letter> \s*?]+
			| [ <features> || <class> || <letter> \s*?]+ %% ','
		]
	}
	# { } (Curly Braces): Indicate a logical-disjunction relationship of two expressions. For example,
	# The two expressions, ABD and AED and be written with curly braces as:
    # `A { B E } D`. A is followed by either B or E and then D.
	rule braces {
		| '{' ~ '}' [ <word-break> || <side> \s*? ]+
		| '{' ~ '}' [ <word-break> || <side> \s*? ]+ %% ','
	}
	# ( ) (Parenthesis): Indicate a logical-disjunction relationship of two expressions and an abbreviated version of the curly braces notation, while maintaining the same disjunctive relationship function. For example,
	# The two expressions, ABD and AD and be written with parentheses as:
    # `A ( B ) D`, B is optionally permitted to come between A and D.
	rule parenthesis {
		| '(' ~ ')' [ <word-break> || <side> \s*? ]+
		| '(' ~ ')' [ <word-break> || <side> \s*? ]+ %% ','
	}
	# ANGLED  BRACKET  NOTATION:    < >
	# Used  with  rules  that involve dependencies between  two  feature  specifications  by  way  of adding a condition to the rule of the form
	#“if a , then b ”
	rule chevrons {
		| '<' ~ '>' [ <features> || <class> || <letter> \s*? ]+
		| '<' ~ '>' [ <features> || <class> || <letter> \s*? ]+ %% ','
	}

	token sign {
		<[-+]>
	}
	token surround { '//' }
	token where {
		'/' | 'when' | 'where'
	}
	token becomes {
		'->' | '→' | '>' | 'becomes' | 'is' | '='
	}
	regex letter {
		<['\h\w] - [\n_;]>+ [ <syllable> <[' \w] - [\n_;]>+ ]*
	}
	token geminate { 'ː' }
	token word-break { '#' }
	token no { '!' | 'not' }
	token jump { '…' | '...' }
	token placeholder { '_'+ | '*'|'–'|'—' }
	token empty { '∅' | 'silent' }
	token number { \d+ }
	token syllable { '.' | '$' }
	
	token reference {
		| [\d+ | <[αβγδεζηθικλμνξοπρςτυφχψω]> ] [ ':' [ <class> | <features> ] ]?
		| '@'
	}

	token class {
		<sign>? <group> <number>? [ <superscript>? <subscript> | <subscript> <superscript>? ]?
	}
	token subscript   { <[₀₁₂₃₄₅₆₇₈₉]>+ }
	token superscript { <[⁰¹²³⁴⁵⁶⁷⁸⁹]>+ }
	proto token group {*}
		token group:sym<X> 	{ <sym> } # stands for literally anything
		token group:sym<consonants> 	{ 'C' | 'consonant' }
		token group:sym<vowels> 		{ 'V' | 'vowel' }
		token group:sym<syllable> 		{ 'S' | 'syllable' }
		token group:sym<fricative> 		{ 'F' | 'fricative' | "fric" }
		token group:sym<affricate> 		{ "A" | "affricate" }
		token group:sym<laryngeal> 		{ "L" | "laryngeal" }
		token group:sym<semivowel> 		{ "W" | "semivowel" }
		token group:sym<sibilant> 		{ "sibilant" | "sib" }
		token group:sym<approximant> 	{ "approximant" | "approx" }
		token group:sym<labial> 		{ "P" | "labial" | "lab" }
		token group:sym<dental> 		{ "dental" | "dent" }
		token group:sym<palatal> 		{ "palatal" | "pal" }
		token group:sym<plosive> 		{ "S" | "stop" | "plosive" | "O" | "obstruent" | "obstr" }
		token group:sym<alveolar> 		{ <sym> }
		token group:sym<stressed> 		{ <sym> }
		token group:sym<syllabic> 		{ "syllabic" | "syll" }
		token group:sym<short> 			{ <sym> }
		token group:sym<spread-glottis> { "spread-glottis" | "spread glottis" }
		token group:sym<aspirated> 		{ "aspirated" | "asp" }
		token group:sym<tap> 			{ 'flap' | 'tap' }

		# major group features
		token group:sym<sonorant> 		{ 'R' | 'sonorant' | "son" | "resonant" }
		token group:sym<velar> 			{ 'velar' | "vel"}
		token group:sym<liquid> 		{ 'L' | 'liquid' | "liqu" }
		token group:sym<vocalic> 		{ "vocalic" | "voc" }
		token group:sym<consonantal> 	{ "consonantal" | "cons" }
		#cavity features
		token group:sym<coronal> 	{ <sym> }
		token group:sym<anterior> 	{ <sym> }
			# tongue body features
			token group:sym<close> 	{ "close" | "high" | "hi" }
			token group:sym<near-close> 	{ "near-close" | "near-high" }
			token group:sym<close-mid> 	{ "close-mid" | "high-mid" }
			token group:sym<mid> 	{ <sym> }
			token group:sym<open-mid> 	{ "open-mid" | "low-mid" }
			token group:sym<near-open> 	{ "near-open" | "near-low" }
			token group:sym<open> 	{ "open" | "low" | "lo" }
			token group:sym<back> 	{ 'B' | "back" }
			token group:sym<center> 	{ <sym> }
			token group:sym<front> 	{ "E" | "front" }
		token group:sym<round> 	{ <sym> }
		token group:sym<distributed> 	{ <sym> }
		token group:sym<covered> 	{ <sym> }
		token group:sym<glottal> 	{ "glottal" | "glott" }
			#secondary apertures
			token group:sym<nasal> 	{ 'N' | 'nasal' | 'nas' }
			token group:sym<lateral> 	{ <sym> }
		# manner of articulation features
		token group:sym<continuant> 	{ "Z" | "continuant" | "cont" }
			#release features
			token group:sym<primary release> 	{ <sym> }
			token group:sym<secondary release> 	{ <sym> }
		# supplementary movements
		token group:sym<click> 	{ <sym> }
		token group:sym<ejective> 	{ <sym> }
		token group:sym<tense> 	{ <sym> }
		#source features
		token group:sym<voice> 	{ <sym> }
		token group:sym<strident> 	{ <sym> }
			#prosodic features
			token group:sym<stress> 	{ <sym> }
				# pitch
				token group:sym<high-pitch> 	{ <sym> }
				token group:sym<low-pitch> 	{ <sym> }
				token group:sym<elevated-pitch> 	{ <sym> }
				token group:sym<rising-pitch> 	{ <sym> }
				token group:sym<falling-pitch> 	{ <sym> }
				token group:sym<concave-pitch> 	{ <sym> }
			token group:sym<length> 	{ <sym> }

	rule comment {
		'%%' \N*
	}
}

#say Parser.parse('a → e / _ b');
#say Parser.parse('a → e / b _');
#say Parser.parse('a → e / # _');
#say Parser.parse('{b,m} → p');
