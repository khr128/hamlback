%{
#include <haml_helpers.h>
char *acc = 0;
%}

%union {
  int intval;
  char *strval;
}

%token PCT POUND EQUAL SPACE EOL INVALID
%token CLOSE_BRACE OPEN_BRACE ARROW  
%token <strval>  VAR
%token <strval>  SYMBOL
%token <strval>  STRING
%token <strval>  CONTENT
%token <strval>  SPACE_INDENT
%start tag

%type <strval> tag_element
%type <strval> indent
%type <strval> name
%type <strval> div
%type <strval> name_element
%type <strval> tag
%%

tag: {/* nothing */}
  | tag tag_element EOL 
    {
      if(acc)
      {
        /*fprintf(stderr, "<!--==========%s===========-->\n", acc);*/
        printf ("%s>\n", acc);  
        free(acc);
        acc = 0;
      }
    }
  | div
    {
        printf ("%s\n", $1);  
    }
    ;

tag_element: {/* nothing */}
 | tag_element name 
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
      $$=make_tag_name($1, $3);
      if(!$$)
        yyerror("invalid indentation");

      /*fprintf(stderr, "indent_size: %d\n", haml_current_indent);*/
    }
    ;

name:
   PCT name_element 
    {
      acc = append(acc, $2);
      free($2);
    }

  | PCT VAR EOL
    { 
      $$=make_tag_name(strdup(""), $2);
    }
    ;

name_element:
  VAR POUND VAR OPEN_BRACE SYMBOL ARROW STRING CLOSE_BRACE
    {
      char *symbol = strtrim($5, ':');
      char *val = strtrim($7, '"');

    /*fprintf(stderr, "name: %s id: %s sym: %s val: %s\n", $1, $3, symbol, val); */
      haml_current_indent = 0;

      push_tag_name(strdup($1), strdup(""));
      $$=concatenate(10, "<", $1, " id='", $3, "'", " ", symbol, "=\"", val, "\"");

      haml_free(6, $1, $3, symbol, val, $5, $7);
    }
  | VAR POUND VAR
    {
    /*fprintf(stderr, "name: %s, id: %s\n", $1, $3); */
      haml_current_indent = 0;

      push_tag_name(strdup($1), strdup(""));
      $$=concatenate(5, "<", $1, " id='", $3, "'");

      haml_free(2, $1, $3);
    }
    ;

div: 
  POUND VAR EOL
  {
    /*fprintf(stderr, "name: div, id: %s\n", $2);*/
      haml_current_indent = 0;

      push_tag_name(strdup("div"), strdup(""));
      $$=concatenate(3, "<div id='", $2, "'>");
      haml_free(1, $2);
  }
  | POUND VAR CONTENT EOL
  {
    /*fprintf(stderr, "name: div, id: %s\n", $3);*/
      haml_current_indent = 0;

      push_tag_name(strdup("div"), strdup(""));
      $$=concatenate(4, "<div id='", $2, "'>", $3);
      haml_free(2, $2, $3);
  }

  | POUND VAR EQUAL CONTENT EOL
  {
    /*fprintf(stderr, "name: div, id: %s\n", $2);*/
      haml_current_indent = 0;

      push_tag_name(strdup("div"), strdup(""));
      char *ruby_code = strtrim($4, ' ');
      $$=concatenate(5, "<div id='", $2, "'> <%= ", ruby_code, " %>");
      haml_free(2, $2, $4, ruby_code);
  }
  ;

%%
main()
{
  yyparse();

  /*close tags which are still open*/
  struct HAML_STACK el = haml_pop();
  while(!haml_cmp(el, haml_null))
  {
    printf ("%s</%s>\n", el.indent, el.tag_name);  
    haml_clean(&el);
    el = haml_pop();
  }
}

