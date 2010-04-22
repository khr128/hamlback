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

%type <strval> tag
%type <strval> tags
%%

tags: /* nothing */{}
  | tags tag EOL { printf ("<%s>\n</%s>\n", $2, $2);  free($2); }
  ;

tag:
  PCT VAR { $$ = $2 }
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
