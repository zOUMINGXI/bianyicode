 %{

//  expr1.y
//  YACC f i l e
//  Date: xxxx/xx/xx
//  xxxxx <xxxxx@nbjl.nankai.edu.cn>
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin ;
void yyerror(const char* s);
int isnum(char s);
%}

%token ADD MINUS PLUS DIVIDE NUMBER

%left ADD MINUS
%left PLUS DIVIDE
%right UMINUS

 %%


lines : lines expr ';' { printf("%f\n", $2); }
    | lines ';'
    |
    ;

expr : expr ADD expr { $$ = $1 + $3; }
    | expr MINUS expr { $$ = $1 - $3; }
    | expr PLUS  expr { $$ = $1 * $3; }
    | expr DIVIDE  expr { $$ = $1 / $3; }
    | '(' expr ')' { $$ = $2; }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | NUMBER{ $$=$1; }
    ;


%%

int yylex()
{
  int t;
  while(1)
  {
    t=getchar();
    if(t==' '||t=='\t'||t=='\n')
    {
      //do nothing
    }
    else if(t=='+')
    {
      return ADD;
    }
    else if(t=='-')
    {
      return MINUS;
    }
    else if(t=='*')
    {
      return PLUS;
    }
    else if(t=='/')
    {
      return DIVIDE;
    }
    else if(isnum(t)) 
    {
      yylval=0;
      while (isnum(t)) 
      {
        yylval = yylval * 10 + t - '0' ;
        t = getchar ();
      }
      ungetc(t,stdin);
      return NUMBER;
    }
    else
    {
      return t;
    }
  }
}
// programs section
int isnum(char t)
{
  if (t>='0'&&t<='9')
  {
    return 1;
  }else
  {
    return 0;
  }
}

int main(void)
{
  yyin=stdin;
  do {
    yyparse();
  } while (!feof(yyin));
  return 0;
}

void yyerror(const char* s)
{
  fprintf (stderr,"Parse error : %s\n", s );
  exit (1);
}