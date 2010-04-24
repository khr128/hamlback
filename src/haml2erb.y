%{
#include <haml_helpers.h>
char *acc = 0;
%}

%union {
  int intval;
  char *strval;
}

%token PCT POUND EOL SCAN_END INVALID
%token CLOSE_BRACE OPEN_BRACE ARROW  
%token <strval>  VAR
%token <strval>  SYMBOL
%token <strval>  STRING
%token <intval>  NUM
%start tag

%type <strval> tag_element
%type <strval> hash
%type <strval> name
%type <strval> id
%type <strval> tag
%%

tag: {/* nothing */}
  | tag tag_element EOL 
    {
      if(acc)
      {
        fprintf(stderr, "<!--==========%s===========-->\n", acc);
        printf ("%s>\n", acc);  
        free(acc);
        acc = 0;
      }
    }
  ;

tag_element: {/* nothing */}
  | tag_element name 
    {
      acc = append(acc, $2);
      free($2);
    }
  | tag_element id 
    {
      acc = append(acc, $2);
      free($2);
    }
  | tag_element hash 
    {
      acc = append(acc, $2);
      free($2);
    }
  | tag_element VAR     { yyerror($1); $$ = 0; free($1); }
  | tag_element INVALID { yyerror("invalid tag_element");  $$ = 0; }
  ;

name:
  PCT VAR 
  { 
    push_name(strdup($2));
    $$=concatenate(2, "<", $2);
    free($2);
  }
 
id:
  POUND VAR
  { 
    $$=concatenate(3, " id='", $2, "'");
    free($2);
  }

hash: 
    OPEN_BRACE SYMBOL ARROW STRING CLOSE_BRACE
    {
      char *symbol = strtrim($2, ':');
      char *val = strtrim($4, '"');

      $$=concatenate(5, " ", symbol, "=\"", val, "\"");

      free(symbol);
      free(val);
      free($2);
      free($4);
    }
%%
yyerror( char *str )
{
  fprintf(stderr, "error:-( %s\n", str); 
}

main()
{
  yyparse();

  char *tag_name = pop_name();
  while(tag_name)
  {
    fprintf(stderr, "<!--==========End: %s===========-->\n", tag_name);
    printf ("</%s>\n", tag_name);
    tag_name = pop_name();
  }
}

