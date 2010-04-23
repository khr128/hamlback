%{
#include <haml_helpers.h>
char *acc = 0;
%}

%union {
  int intval;
  char *strval;
}

%token PCT POUND EOL INVALID
%token CLOSE_BRACE OPEN_BRACE ARROW SYMBOL STRING
%token <strval>  VAR
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
    char *text;
    text = (char *)calloc(strlen($2)+2, 1); 
    strcpy(text, "<");
    strcat(text, $2);

    free($2);
    $$=text;
  }
 
id:
  POUND VAR
  { 
    char *text;
    text = (char *)calloc(strlen($2)+7, 1); 
    strcpy(text, " id='"); 
    strcat(text, $2); 
    strcat(text, "'"); 

    free($2);
    $$=text;
  }

hash: 
    OPEN_BRACE SYMBOL ARROW STRING CLOSE_BRACE
    {
      char *text;
      const char *msg = " c=\"d\"";
      text = (char *)calloc(strlen(msg)+1, 1); 
      strcpy(text, msg);

      $$=text;
    }
%%
yyerror( char *str )
{
  fprintf(stderr, "error:-( %s\n", str); 
}

main()
{
  yyparse();
}

