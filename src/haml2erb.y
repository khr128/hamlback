%{
  #include <stdio.h>
%}

%union {
  int intval;
  char *strval;
}

%token PCT EOL INVALID
%token <strval>  VAR
%token <intval>  NUM
%start tag

%type <strval> tag_element
%type <strval> tag
%%

tag: {/* nothing */}
  | tag tag_element EOL 
    {
      fprintf(stderr, "<!--=====================-->\n");
      if($2)
      {
        printf ("<%s>\n</%s>\n", $2, $2);  
      }
    }
  ;

tag_element: {/* nothing */}
  | PCT VAR { $$ = $2; }
  | tag_element VAR     { yyerror($1); $$ = 0; free($1); }
  | tag_element INVALID { yyerror("invalid tag_element");  $$ = 0; }
  ;

%%
yyerror( char *str )
{
  fprintf(stderr, "error:-( %s\n", str); 
}

main()
{
  yyparse();
}
