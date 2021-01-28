use Grammar::Tracer;

grammar Parser {
	rule TOP {
		<side>
	}

	regex side {
		[ \h+
			|| <placeholder>
			|| <letter>
			|| <word-end>
		]+
	}

	regex letter {
		<['\w] - [\n_;]>+
	}
	token word-end { '#' }
	token placeholder { '_'+ }
}


say Parser.parse("_ma#");

