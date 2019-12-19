%{
void yyerror (char *s);
#include <stdio.h>
#include <stdlib.h>
int symbols[1000];
int showSymbolVal (char symbol[]);
void updateSymbolVal (char symbol[], int val);
%}

%union {long num; char id[1000];}
%start line
%token print IF ELSE PLUS MINUS MUL DIV SEMI PR PL THEN EQUAL EXIT
%token <num> number
%token <id> identifier
%type <num> line Exp Condition Statment ifElse
%left EQUAL
%left PLUS MINUS MUL DIV 
%left IF ELSE

%%
line	: assignment SEMI {;}
		| ifElse
		| EXIT {printf("Bye bye");exit(0);}
		| print Exp SEMI {printf("PARSER ===> printing %d\n",$2);}
		| line assignment SEMI {;}
		| line print Exp SEMI {printf("PARSER ===> printing %d\n",$3);}
		| line EXIT {printf("Bye bye");exit(0);}
		;

ifElse:	IF PL Condition PR THEN Statment ELSE Statment SEMI{
						if($3){
							printf("PARSER ===> In the if true part\n");
							printf("PARSER ===> The statment was executed with the value of %d\n",$6);
							}
						else{
							printf("PARSER ===> In the else part\n");
							printf("PARSER ===> The statment was executed with the value of %d\n",$8);
							}
							printf("\n");
						}
		| IF PL Condition PR THEN Statment SEMI{
						if($3){
							printf("PARSER ===> Correct condition statment value is %d",$6);
							}
						else
							printf("PARSER ===> incorrect condition");
						printf("\n");
						}
		;
		
Condition:	number
			| Exp '<' Exp {$$ =  $1 < $3? 1: 0; }
			| Exp EQUAL Exp {$$ = $1 == $3? 1: 0 ; }
			| Exp '>' Exp {$$ = $1 > $3? 1: 0 ;}
			;
			
Statment:	Exp
			| line
			;
			
Exp:		number
			| Exp PLUS Exp {$$ = $1 + $3;}
			| Exp MINUS Exp {$$ = $1 - $3;}
			| Exp MUL Exp {$$ = $1 * $3;}
			| Exp DIV Exp {$$ = $1 / $3;}
			| identifier {$$ = showSymbolVal($1);}
			;

assignment	: identifier '=' Exp {updateSymbolVal ($1,$3);}
		;
%%

int computeSymbolIndex (char token[])
{
	int idx = -1;
	int i = 0;
	for (i;i<sizeof(token);i++)
	{
	if (token[i] >='a')
		idx += token[i] - 'a' +1;
	}
	return idx;
}

int showSymbolVal (char symbol[])
{
	int index = computeSymbolIndex (symbol);
	return symbols[index];
}

void updateSymbolVal (char symbol[], int val)
{
	int index = computeSymbolIndex (symbol);
	symbols [index] = val;
}

int main (void){
	int i;
	for (i=0; i<1000; i++){
		symbols[i] = 0;
	}
	freopen("ScannerParserOutput.txt","w",stdout);
	yyparse();
	return 0;
}

void yyerror(char *s){
	printf("%s",s);
}