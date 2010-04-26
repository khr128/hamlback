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
%token <strval>  SPACE_INDENT
%token <intval>  NUM
%start tag

%type <strval> tag_element
%type <strval> indent
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
  | tag_element indent  
    {
      acc = append(acc, $2);
      free($2);
    }
  | tag_element VAR     { yyerror($1); $$ = 0; free($1); }
  | tag_element INVALID { yyerror("invalid tag_element");  $$ = 0; }
  ;

indent:
  SPACE_INDENT PCT VAR
  {
    fprintf(stderr, "indent_size: %lu\n", strlen($1)); 
    $$=concatenate(3, $1, "<", $3);
  }

name:
  PCT VAR 
  { 
    haml_stack.tag_name = strdup($2);
    haml_push(haml_stack);
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

  struct HAML_STACK el = haml_pop();
  while(!haml_cmp(el, haml_null))
  {
    /** close the erb tag **/
    printf ("</%s>\n", el.tag_name);
    haml_clean(&el);
    el = haml_pop();
  }
}

