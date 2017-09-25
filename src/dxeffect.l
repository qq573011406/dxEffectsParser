%option noyywrap
%option outfile="Gen_dxeffect.c"
%{
	#define YY_NO_UNISTD_H
    #include<stdio.h>
    //#include "dxeffect_tab.h"
    int yylval = 0;
%}

IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]* 


%%

[ \t\n]			{}
"technique"		{fprintf(yyout,"find tec\n");}
"pass"			{fprintf(yyout,"find pass\n");}
{IDENTIFIER}	{fprintf(yyout,"find identifier:%s\n",yytext);}
.				{}
%%
int main(int argc,char**argv)
{
    if(argc >= 2){
        FILE* file = fopen(argv[1],"r");
		yyin = file;
		if(argc >= 3){
			FILE* outFile = fopen(argv[2],"w+");
			if(outFile){
				yyout = outFile;
			}
		}
    }
    yylex();
    return 0;
}
