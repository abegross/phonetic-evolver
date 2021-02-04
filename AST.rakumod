class ASTNode {

}

class AST::TOP is ASTNode {
	has ASTNode @.conversions;
}

class AST::Conversion is ASTNode {
	has $.lhs;
	has $.rhs;
	has $.sides;
	has $.preceded;
	has $.followed;
	has Bool    $.word-beg;
	has Bool    $.word-end;
}

class AST::Side is ASTNode {
	has @.letters;
	has @.classes;
	has @.features;
	has @.references;
	has Bool $.jump;
	has Bool $.no;
}

class AST::Class is ASTNode {
	has @.class;
}
class AST::Braces is ASTNode {
	has @.side;
}
class AST::Features is ASTNode {
	has $.brackets;
	has $.braces;
	has $.parenthesis;
	has $.chevrons;
}

