%{
    #include "find.tab.h"
    int yylval = 0;
%}

%%

"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"|" {return ABS;}
[0-9]+ {yylval = atoi(yytext);return NUMBER;}
\n {return EOL;}
[ \t] {/* ignore */}
. {printf("Mystery charater %c\n",*yytext);}

%%
int yywrap(){return 1;}  