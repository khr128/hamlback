%{
#include <haml_helpers.h>
char *acc = 0;
%}

%union {
  int intval;
  char *strval;
}

%token PCT POUND EQUAL EOL LINE_CONTINUATION INVALID HAML_COMMENT
%token CLOSE_BRACE OPEN_BRACE ARROW  
%token <strval>  VAR
%token <strval>  SYMBOL
%token <strval>  STRING
%token <strval>  CONTENT
%token <strval>  ESCAPED_CONTENT
%token <strval>  RUBY_CODE
%token <strval>  RUBY_CODE_NO_INSERT
%token <strval>  SPACE_INDENT
%token <strval>  HTML_COMMENT
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
        /*fprintf(stderr, "<!--====acc======|%s|===========-->\n", acc);*/
        printf ("%s>\n", acc);  
        free(acc);
        acc = 0;
      }
    }
  | tag CONTENT EOL
    {
      fprintf(stderr, "<!--====t=====|%s|=====t=====-->\n", $2);
      printf ("%s\n", $2);  
      free($2);
    }
  | tag ESCAPED_CONTENT EOL
    {
      fprintf(stderr, "<!--====\\t=====|%s|=====\\t=====-->\n", $2);
      print_indented_tag($2, "\\", "%s\n", " ");
    }

  | tag HAML_COMMENT EOL
    {
      fprintf(stderr, "<!--====c=====|haml comment|=====c=====-->\n");
      /* do nothing */
    }
  | tag HTML_COMMENT EOL
    {
      fprintf(stderr, "<!--====/=====|%s|=====/=====-->\n", $2);
      print_indented_tag($2, "/", "<!-- %s -->\n", " ");
    }

  | tag RUBY_CODE EOL
    {
      fprintf(stderr, "<!--====*=====|%s|=====*=====-->\n", $2);
      print_indented_tag($2, "=", "<%%= %s %%>\n", " ");
    }
  | tag RUBY_CODE_NO_INSERT
    {
      fprintf(stderr, "<!--====-=====|%s|=====-=====-->\n", $2);
      print_indented_tag($2, "-", "<%% %s %%>\n", " \n");
    }
  | tag RUBY_CODE LINE_CONTINUATION
    {
      fprintf(stderr, "<!--====|=====|%s|=====|=====-->\n", $2);
      char *indent = strtok($2, "=");
      char *code = strtrim(strtok(0, "="), ' ');
      printf ("%s<%%= %s\n", indent, code);  

      haml_set_continue_line(concatenate(2, indent, "%>"));
      haml_free(2, code, $2);
    }
  | tag CONTENT LINE_CONTINUATION
    {
      fprintf(stderr, "<!--====||====|%s|=====||====-->\n", $2);
      printf ("%s\n", $2);  
      free($2);
    }
  | tag div
    {
      /*fprintf(stderr, "<!--====d=====|%s|=====d=====-->\n", $2);*/
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
  | SPACE_INDENT PCT VAR CONTENT
    {
      fprintf(stderr, "<!--====itag=====|%s<%s>%s|=====itag=====-->\n", $1, $3, $4);
      char *content = strtrim($4, ' ');
      printf("%s<%s>%s</%s>\n", $1, $3, content, $3);
      haml_free(4, $1, $3, $4, content);
      $$ = 0;
    }
  | SPACE_INDENT PCT VAR  OPEN_BRACE SYMBOL ARROW STRING CLOSE_BRACE CONTENT
    {
      fprintf(stderr, "<!--====itaghash=====|%s<%s>%s|=====itaghash=====-->\n", $1, $3, $9);
      char *symbol = strtrim($5, ':');
      char *val = strtrim($7, '"');
      char *content = strtrim($9, ' ');
      printf("%s<%s %s='%s'>%s</%s>\n", $1, $3, symbol, val, content, $3);
      haml_free(8, $1, $3, $5, $7, $9, symbol, val, content);
      $$ = 0;
    }

    ;

name:
   PCT name_element 
    {
      acc = append(acc, $2);
      free($2);
    }

  | PCT VAR
    { 
      fprintf(stderr, "<!--====var=====|%s|=====var=====-->\n", $2);
      $$=make_tag_name($2, strdup(""));
    }
  | PCT VAR CONTENT
    {
      fprintf(stderr, "<!--====tag=====|<%s>%s|=====tag=====-->\n", $2, $3);
      char *content = strtrim($3, ' ');
      printf("<%s>%s</%s>\n", $2, content, $2);
      haml_free(3, $2, $3, content);
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
    fprintf(stderr, "%s</%s>\n", el->indent, el->tag_name);
    printf ("%s</%s>\n", el->indent, el->tag_name);  
}

main()
{
  yyparse();

  /*complete continuation line, if any */
  char* continue_line = haml_get_continue_line();
  if(continue_line)
    printf("%s\n", continue_line);

  /*close tags which are still open*/
  haml_execute_stack(close_tag);
}

