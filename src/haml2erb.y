%{
#include <haml_helpers.h>
char *acc = 0;
%}

%union {
  int intval;
  char *strval;
}

%token PCT POUND EQUAL EOL INVALID
%token CLOSE_BRACE OPEN_BRACE ARROW  
%token <strval>  VAR
%token <strval>  SYMBOL
%token <strval>  STRING
%token <strval>  CONTENT
%token <strval>  RUBY_CODE
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
  | tag RUBY_CODE EOL
    {
      /*fprintf(stderr, "<!--==========%s===========-->\n", $2);*/
      char *indent = strtok($2, "=");
      char *code = strtrim(strtok(0, "="), ' ');
      printf ("%s<%%= %s %%>\n", indent, code);  
      haml_free(2, code, $2);
    }
  | tag div
    {
      printf ("%s\n", $2);  
      free($2);
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
      $$=make_tag_name($3, $1);
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
      $$=make_tag_name($2, strdup(""));
    }
    ;

name_element:
  VAR POUND VAR OPEN_BRACE SYMBOL ARROW STRING CLOSE_BRACE
    {
      char *symbol = strtrim($5, ':');
      char *val = strtrim($7, '"');

    /*fprintf(stderr, "name: %s id: %s sym: %s val: %s\n", $1, $3, symbol, val); */
      haml_set_current_indent(0);

      push_tag_name($1, "");
      $$=concatenate(10, "<", $1, " id='", $3, "'", " ", symbol, "=\"", val, "\"");

      haml_free(6, $1, $3, symbol, val, $5, $7);
    }
  | VAR POUND VAR
    {
    /*fprintf(stderr, "name: %s, id: %s\n", $1, $3); */
      haml_set_current_indent(0);

      push_tag_name($1, "");
      $$=concatenate(5, "<", $1, " id='", $3, "'");

      haml_free(2, $1, $3);
    }
    ;

div: 
  POUND VAR EOL
  {
    /*fprintf(stderr, "name: div, id: %s\n", $2);*/
      haml_set_current_indent(0);

      push_tag_name("div", "");
      $$=concatenate(3, "<div id='", $2, "'>");
      haml_free(1, $2);
  }
  | POUND VAR CONTENT EOL
  {
    /*fprintf(stderr, "name: div, id: %s\n", $3);*/
      haml_set_current_indent(0);

      push_tag_name("div", "");
      $$=concatenate(4, "<div id='", $2, "'>", $3);
      haml_free(2, $2, $3);
  }

  | POUND VAR EQUAL CONTENT EOL
  {
    /*fprintf(stderr, "name: div, id: %s\n", $2);*/
      haml_set_current_indent(0);

      push_tag_name("div", "");
      char *ruby_code = strtrim($4, ' ');
      $$=concatenate(5, "<div id='", $2, "'> <%= ", ruby_code, " %>");
      haml_free(3, $2, $4, ruby_code);
  }
  ;

%%
void close_tag(struct HAML_STACK *el)
{
    printf ("%s</%s>\n", el->indent, el->tag_name);  
}

main()
{
  yyparse();

  /*close tags which are still open*/
  haml_execute_stack(close_tag);
}

