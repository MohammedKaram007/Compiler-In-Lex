digit [0-9]
digits {digit}{digit}*
optFrac [.]{digits}
optExp [E][+-]{digits}{optFrac}?
num {digits}{optFrac}?{optExp}?
Letter [A-Za-z]
underscore [_]
letornum {Letter}|{digits}
underscoreLetOrNum {letornum}*{underscore}{letornum}+
Letters {underscore}?{Letter}+{underscoreLetOrNum}*
%{
#include "parser.tab.h"
%}
%%
"exit" {return EXIT;}
"print" {printf("SCANNER print command\n");return print;}
"if"	{printf ("SCANNER <"); printf(yytext); printf(",KW>\n");return(IF);}
"else"	{printf ("SCANNER <"); printf(yytext); printf(",KW>\n");return(ELSE);}
"then"	{printf ("SCANNER <"); printf(yytext); printf(",KW>\n");return(THEN);}
"=="	{printf ("SCANNER <"); printf(yytext); printf(",COMP>\n");return(EQUAL);}
{Letters}{digits}* {
					printf ("SCANNER <"); 
					printf(yytext); 
					printf(",%d",computeSymbolIndex(yytext));
					printf(">\n");
					int i=0;
					for (i;i<sizeof(yytext);i++)
					yylval.id[i]=yytext[i]; 
					return identifier;
					}
{num} {
		printf ("SCANNER <"); 
		printf(yytext); 
		printf(",Number>\n");
		yylval.num = atoi(yytext); 
		return number;
		}
")" {printf("SCANNER <SC,"); printf(yytext); printf(">\n");return PR;}
"(" {printf("SCANNER <SC,"); printf(yytext); printf(">\n");return PL;}
[ \t\n] ;
[=<>{}] {printf ("SCANNER <"); printf(yytext); printf(",SC>\n");return yytext[0];}
"+" 	{printf ("SCANNER <"); printf(yytext); printf(",OP>\n");return(PLUS);}
"-"		{printf ("SCANNER <"); printf(yytext); printf(",OP>\n");return(MINUS);}
"*"		{printf ("SCANNER <"); printf(yytext); printf(",OP>\n");return(MUL);}
"/"		{printf ("SCANNER <"); printf(yytext); printf(",OP>\n");return(DIV);}
";" {printf ("SCANNER <"); printf(yytext); printf(",SEMI>\n");return SEMI;}
. {ECHO; yyerror ("unexpected character");}
%%
int yywrap()
{
return 1;
}
