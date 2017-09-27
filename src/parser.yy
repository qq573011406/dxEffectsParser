/* $Id$ -*- mode: c++ -*- */
/** \file parser.yy Contains the example Bison parser source */

%{ /*** C/C++ Declarations ***/

#include <cstdio>
#include <string>
#include <vector>

#include "expression.h"

class TechniqueNode;


%}

/*** yacc/bison Declarations ***/

/* Require bison 2.3 or later */
%require "2.3"

/* add debug output code to generated parser. disable this for release
 * versions. */
%debug

/* start symbol is named "start" */
%start start

/* write out a header file containing the token defines */
%defines

/* use newer C++ skeleton file */
%skeleton "lalr1.cc"

/* namespace to enclose parser in */
%name-prefix="example"

/* set the parser's class identifier */
%define "parser_class_name" "Parser"

/* keep track of the current position within the input */
%locations
%initial-action
{
    // initialize the initial location object
    @$.begin.filename = @$.end.filename = &driver.streamname;
};

/* The driver is passed by reference to the parser and to the scanner. This
 * provides a simple but effective pure interface, not relying on global
 * variables. */
%parse-param { class Driver& driver }

/* verbose error messages */
%error-verbose

 /*** BEGIN EXAMPLE - Change the example grammar's tokens below ***/

%union {
	typedef std::string					_str;
	typedef class TechniqueNode		_techNode;
	typedef class PassNode				_passNode;
	typedef std::vector<_passNode*>		_passNodes;
	typedef class StateAssignmentNode	_stateAssignmentNode;
	typedef std::vector<_stateAssignmentNode*> _stateAssignmentNodes;
	typedef class StateAssignmentValue  _stateAssignmentNodeValue;

    _str				  *stringVal;
    _techNode			  *techValue;
	_passNode			  *passValue;
	_passNodes			  *passValues;
	_stateAssignmentNode  *stateAssignmentValue;
	_stateAssignmentNodes  *stateAssignmentValues;
	_stateAssignmentNodeValue *stateValue;

	int					  integerVal;
	float				  floatVal;
	bool 				  boolVal;

}
%token PASS
%token TECHNIQUE
%token <stringVal>  STATE_NAME
%token <stringVal>  STRING
%token <stringVal> 	IDENTIFIER
%token <integerVal>   INTEGER;
%token <floatVal> FLOAT;
%token <boolVal>  BOOLEAN
%token				END	     0	"end of file"





/// Beigin Effect States (Direct3D 9)
//effect state [ [index] ] = expression;


/* Light States */

/* Material States */
/* Pixel Pipe Render States */
/* Vertex Pipe Render States */
/* Sampler States */
/* Shader States */
%token COMPILE
/* Shader Constant States */
/* Texture States */
/* Texture Stage States */
/* Transform States */
/* Sampler Stage States */
/// End Of Effect States (Direct3D 9)


%type <techValue>  stmt_tec
%type <passValue>  stmt_pass
%type <passValues> stmt_pass_list
%type <integerVal>   stmt_state_name_index
%type <stateValue> stmt_state_value
%type <stateAssignmentValue> stmt_state
%type <stateAssignmentValues> stmt_state_list


%destructor { delete $$; } IDENTIFIER
%destructor { delete $$; } stmt_tec
%destructor { delete $$; } stmt_pass

 /*** END EXAMPLE - Change the example grammar's tokens above ***/

%{

#include "driver.h"
#include "scanner.h"

/* this "connects" the bison parser in the driver to the flex scanner class
 * object. it defines the yylex() function call to pull the next token from the
 * current lexer object of the driver context. */
#undef yylex
#define yylex driver.lexer->lex

%}

%% /*** Grammar Rules ***/

 /*** BEGIN EXAMPLE - Change the example grammar rules below ***/

stmt_state_value: INTEGER {$$ = new StateIntegerValue($1);}
				| FLOAT   {$$ = new StateFloatValue($1);}
				| BOOLEAN {$$ = new StateBooleanValue($1);}
				| STRING  {$$ = new StateStringValue(*$1);delete $1;}
				| IDENTIFIER  {$$ = new StateStringValue(*$1);delete $1;}
				| STATE_NAME  {$$ = new StateStringValue(*$1);delete $1;}
				| COMPILE IDENTIFIER IDENTIFIER '(' ')' {$$ = new StateCompileValue(*$2,*$3);delete $2;delete $3;}
				| COMPILE IDENTIFIER STRING '(' ')' {$$ = new StateCompileValue(*$2,*$3);delete $2;delete $3;}
				| COMPILE STRING STRING '(' ')' {$$ = new StateCompileValue(*$2,*$3);delete $2;delete $3;}
				| COMPILE STRING IDENTIFIER '(' ')' {$$ = new StateCompileValue(*$2,*$3);delete $2;delete $3;}


stmt_state_name_index: '[' INTEGER ']' {$$ = $2;}

stmt_state: STATE_NAME '=' stmt_state_value ';' {$$ = new StateAssignmentNode(*$1,$3);delete $1;}
				| STATE_NAME stmt_state_name_index '=' stmt_state_value ';' {$$ = new StateAssignmentNode(*$1,$4,$2);delete $1;}

stmt_state_list:   /* empty */ {$$ = new std::vector<StateAssignmentNode*>();}
                | stmt_state stmt_state_list  {
												$$ = new std::vector<StateAssignmentNode*>();
												$$->push_back($1);
												$$->insert($$->end(),$2->begin(),$2->end());
												delete $2;
											  }

stmt_pass:	PASS IDENTIFIER  '{' stmt_state_list '}' {$$ = new PassNode(*$2,*$4);delete $2;}

stmt_pass_list: stmt_pass {$$ = new std::vector<PassNode*>();$$->push_back($1);}
               | stmt_pass stmt_pass_list {
											$$ = new std::vector<PassNode*>();
											$$->push_back($1);
											$$->insert($$->end(),$2->begin(),$2->end());
											delete $2;
										   }

stmt_tec:	TECHNIQUE IDENTIFIER '{' stmt_pass_list '}' {
                                                                $$ = new TechniqueNode(*$2,*$4);
																driver.calc.AddTechnique(*$$);
																delete $2;
                                                                delete $4;
                                                            }

stmt_tec_list: stmt_tec {}
              |   stmt_tec stmt_tec_list {}

start	:	stmt_tec_list

 /*** END EXAMPLE - Change the example grammar rules above ***/

%% /*** Additional Code ***/

void example::Parser::error(const Parser::location_type& l,
			    const std::string& m)
{
    driver.error(l, m);
}
