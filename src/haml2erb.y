%{
  #include <stdio.h>
  #include <stdlib.h>
%}

%union {
  int intval;
  char *strval;
}

%token PCT POUND EOL INVALID
%token <strval>  VAR
%token <intval>  NUM
%start tag

%type <strval> tag_element
%type <strval> tag
%%

tag: {/* nothing */}
  | tag tag_element EOL 
    {
      if($2)
      {
        fprintf(stderr, "<!--==========%s===========-->\n", $2);
        printf ("%s>\n", $2);  
        free($2);
      }
    }
  ;

tag_element: {/* nothing */}
  | PCT VAR 
    { 
      char *text;
      text = (char *)calloc(strlen($2)+2, 1); 
      strcpy(text, "<");
      strcat(text, $2);

      free($$);
      free($2);
      $$=text;
    }
  | tag_element POUND VAR 
    { 
      char *text;
      text = (char *)calloc(strlen($3)+strlen($$)+7, 1); 
      strcpy(text, $$); 
      strcat(text, " id='"); 
      strcat(text, $3); 
      strcat(text, "'"); 

      free($$);
      $$=text;
    }
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
