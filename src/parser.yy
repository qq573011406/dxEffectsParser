/* $Id$ -*- mode: c++ -*- */
/** \file parser.yy Contains the example Bison parser source */

%{ /*** C/C++ Declarations ***/

#include <stdio.h>
#include <string>
#include <vector>

#include "expression.h"

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
    std::string*		stringVal;
    class TechniqueNode*		technique;
	class PassNode*				pass;
	class StateAssignmentNode*  stateAssignment;
}

%token <stringVal> 	IDENTIFIER
%token <technique> 	TECHNIQUE
%token <pass> 		PASS
%token <stringVal>  STATENAME
%token <stringVal>  STATEVALUE 
%token				END	     0	"end of file"
%token BRACEETS_LEFT BRACEETS_RIGHT EQUAL SEMICOLON

//%type <technique>	technique_stat
//%type <pass>	pass_stat
//%type <stateAssignment>	stateassignment_stat

%destructor { delete $$; } IDENTIFIER
%destructor { delete $$; } TECHNIQUE
%destructor { delete $$; } PASS

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
stmt_state	:	IDENTIFIER EQUAL IDENTIFIER SEMICOLON {std::cout<<"state:"<<*$1<<" EqualTo "<<*$3<<std::endl;}
            |   STATENAME EQUAL IDENTIFIER SEMICOLON {std::cout<<"state:"<<*$1<<" EqualTo "<<*$3<<std::endl;}
stmt_state_list :   /* empty */
                | stmt_state stmt_state_list  {}

stmt_pass	:	PASS IDENTIFIER  BRACEETS_LEFT stmt_state_list BRACEETS_RIGHT {std::cout<<"pass:"<<*$2<<std::endl;}

stmt_pass_list : stmt_pass {}
               | stmt_pass stmt_pass_list {}

stmt_tec	:	TECHNIQUE IDENTIFIER BRACEETS_LEFT stmt_pass_list BRACEETS_RIGHT {std::cout<<"technique:"<<*$2<<std::endl;}

stmt_tec_list   :   stmt_tec {}
                |   stmt_tec stmt_tec_list {}

start	:	stmt_tec_list

 /*** END EXAMPLE - Change the example grammar rules above ***/

%% /*** Additional Code ***/

void example::Parser::error(const Parser::location_type& l,
			    const std::string& m)
{
    driver.error(l, m);
}
