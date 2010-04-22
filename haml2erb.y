%{
  #include <stdio.h>
%}

%union {
  int intval;
  char *strval;
}

%token PCT EOL
%token <strval>  VAR
%start tags

%%

tags: /* nothing */
  | tags tag EOL { printf ("=>"); }
  ;

tag:
  PCT VAR
  {
    printf ("Tag %s\n", $2);
  }
  ;
%%
yyerror( char *str )
{
  fprintf(stderr, "error:-( %s\n", str); 
}

int main()
{
  yyparse();
  return 0;
}
