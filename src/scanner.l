/* $Id$ -*- mode: c++ -*- */
/** \file scanner.ll Define the example Flex lexical scanner */

%{ /*** C/C++ Declarations ***/

#include <string>

#include "scanner.h"

/* import the parser's token type into a local typedef */
typedef example::Parser::token token;
typedef example::Parser::token_type token_type;

/* By default yylex returns int, we use token_type. Unfortunately yyterminate
 * by default returns 0, which is not of token_type. */
#define yyterminate() return token::END

/* This disables inclusion of unistd.h, which is not available under Visual C++
 * on Win32. The C++ scanner uses STL streams instead. */
#define YY_NO_UNISTD_H

%}

/*** Flex Declarations and Options ***/

/* enable c++ scanner class generation */
%option c++

/* change the name of the scanner class. results in "ExampleFlexLexer" */
%option prefix="Example"

/* the manual says "somewhat more optimized" */
%option batch

/* enable scanner to generate debug output. disable this for release
 * versions. */
%option debug

/* no support for include files is planned */
%option yywrap nounput 

/* enables the use of start condition stacks */
%option stack


/* The following paragraph suffices to track locations accurately. Each time
 * yylex is invoked, the begin position is moved onto the end position. */
%{
#define YY_USER_ACTION  yylloc->columns(yyleng);
%}



/* Effect States (Direct3D 9) Token*/

es_light_states LightAmbient|LightAttenuation0|LightAttenuation1|LightAttenuation2|LightDiffuse|LightDirection|LightEnable|LightFalloff|LightPhi|LightPosition|LightRange|LightSpecular|LightTheta|LightType
es_material_states MaterialAmbient|MaterialDiffuse|MaterialEmissive|MaterialPower|MaterialSpecular

es_all_states {es_light_states}|{es_material_states}


%% /*** Regular Expressions Part ***/

 /* code to place at the beginning of yylex() */
%{
    // reset location
    yylloc->step();
%}

 /*** BEGIN EXAMPLE - Change the example lexer rules below ***/

"/*"([^*]|"*"[^/])*"*/"  { /* skip comments */ }
"//"[^\r\n]*             { /* skip comments */ }

"pass"          {return token::PASS;}
"technique"     {return token::TECHNIQUE;}
"compile"       {return token::COMPILE;}
"float2"        {return token::FLOAT2;}
"float3"        {return token::FLOAT3;}
"float4"        {return token::FLOAT4;}
{es_all_states} {
        yylval->stringVal = new std::string(yytext, yyleng);
        return token::STATE_NAME;
}

[tT][rR][uU][eE]  {yylval->boolVal = true;return token::BOOLEAN;}
[fF][aA][lL][sS][eE] {yylval->boolVal = false;return token::BOOLEAN;}


[0-9]+ {
    yylval->integerVal = atoi(yytext);
    return token::INTEGER;
}

[0-9]+"."[0-9]*[fF]? {
    yylval->floatVal = atof(yytext);
    return token::FLOAT;
}


[_A-Za-z][A-Za-z0-9_]* {
    yylval->stringVal = new std::string(yytext, yyleng);
    return token::IDENTIFIER;
}


[A-Za-z][A-Za-z0-9_,.-]* {
    yylval->stringVal = new std::string(yytext, yyleng);
    return token::STRING;
}



 /* gobble up white-spaces */
[ \t\r]+ {
    //yylloc->step();
}

 /* gobble up end-of-lines */
\n {

}

 /* pass all other characters up to bison */
.   {
        return static_cast<token_type>(*yytext);
    }

 /*** END EXAMPLE - Change the example lexer rules above ***/

%% /*** Additional Code ***/

namespace example {

Scanner::Scanner(std::istream* in,
		 std::ostream* out)
    : ExampleFlexLexer(in, out)
{
}

Scanner::~Scanner()
{
}

void Scanner::set_debug(bool b)
{
    yy_flex_debug = b;
}

}

/* This implementation of ExampleFlexLexer::yylex() is required to fill the
 * vtable of the class ExampleFlexLexer. We define the scanner's main yylex
 * function via YY_DECL to reside in the Scanner class instead. */

#ifdef yylex
#undef yylex
#endif

int ExampleFlexLexer::yylex()
{
    std::cerr << "in ExampleFlexLexer::yylex() !" << std::endl;
    return 0;
}

/* When the scanner receives an end-of-file indication from YY_INPUT, it then
 * checks the yywrap() function. If yywrap() returns false (zero), then it is
 * assumed that the function has gone ahead and set up `yyin' to point to
 * another input file, and scanning continues. If it returns true (non-zero),
 * then the scanner terminates, returning 0 to its caller. */

int ExampleFlexLexer::yywrap()
{
    return 1;
}
