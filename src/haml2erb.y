%{
#define YYDEBUG 1
#include <haml_helpers.h>
char *acc = 0;
int just_indent = 0;
%}

%union {
  int intval;
  char *strval;
}

%token DOCTYPE
%token PCT POUND EQUAL EOL LINE_CONTINUATION INVALID HAML_COMMENT BLANK_LINE
%token CLOSE_BRACE OPEN_BRACE ARROW COMMA PERIOD
%token <strval>  VAR
%token <strval>  SYMBOL
%token <strval>  QUOTED_SYMBOL
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
%type <strval> id
%type <strval> content
%type <strval> div
%type <strval> div_element
%type <strval> name_element
%type <strval> tag
%type <strval> key_value
%type <strval> hash
%%

tag: 
  {/* nothing */
      fprintf(stderr, "<!--====start=====|tag|=====start=====-->\n");
  }
  | tag tag_element EOL 
    {
      fprintf(stderr, "<!--====elem=====|tag|=====elem=====-->\n");
      if(acc)
      {
        fprintf(stderr, "<!--====acc======|%s|===========-->\n", acc);
        printf ("<%s>\n", acc);  
        free(acc);
        acc = 0;
      }
    }
  | tag content EOL
    {
      fprintf(stderr, "<!--====t=====|%s|=====t=====-->\n", $2);
      printf ("%s\n", $2);  
      free($2);
    }
  | tag ESCAPED_CONTENT EOL
    {
      fprintf(stderr, "<!--====\\t=====|%s|=====\\t=====-->\n", $2);
      free(print_indented_tag($2, "\\", "%s\n", " "));
    }
  | tag BLANK_LINE
    {
      fprintf(stderr, "<!--====\\n=====| |=====\\n=====-->\n");
    }
  | tag DOCTYPE EOL
    {
      fprintf(stderr, "<!--====!!!=====| |=====!!!=====-->\n");
      printf ("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n");  
    }
  | tag HAML_COMMENT
    {
      fprintf(stderr, "<!--====c=====|haml comment|=====c=====-->\n");
      /* do nothing */
    }
  | tag HTML_COMMENT EOL
    {
      fprintf(stderr, "<!--====/=====|%s|=====/=====-->\n", $2);
      free(print_indented_tag($2, "/", "<!-- %s -->\n", " "));
    }

  | tag RUBY_CODE EOL
    {
      fprintf(stderr, "<!--====*=====|%s|=====*=====-->\n", $2);
      free(print_indented_tag($2, "=", "<%%= %s %%>\n", " "));
    }
  | tag RUBY_CODE_NO_INSERT
    {
      fprintf(stderr, "<!--====-=====|%s|=====-=====-->\n", $2);
      char* indent = print_indented_tag($2, "-", "<%% %s %%>\n", " \n");
      push_tag_name(0, indent, ruby_code);
      free(indent);
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
  | tag content LINE_CONTINUATION
    {
      fprintf(stderr, "<!--====||====|%s|=====||====-->\n", $2);
      printf ("%s\n", $2);  
      free($2);
    }
    ;

tag_element: {/* nothing */}
 | tag_element name 
    {
      acc = make_tag_element($2, &just_indent, acc);
      free($2);
    }
  | tag_element div 
    {
      acc = make_tag_element($2, &just_indent, acc);
      free($2);
    }

  | tag_element indent
    {
      if($2)
      {
        fprintf(stderr, "<!--====indent=====|%s>|=====indent=====-->\n", $2);
        printf ("%s>\n", $2);  
        free($2);
      }
      acc = 0;
    }
  | tag_element VAR     { yyerror($1); $$ = 0; free($1); }
  | tag_element INVALID { yyerror("invalid tag_element");  $$ = 0; }
  ;

indent:
  SPACE_INDENT name
  {
    if(!haml_set_space_indent(strlen($1)))
    {
      yyerror("invalid indentation");
    }
    else
    {
      close_previously_parsed_tags($2);
      if(just_indent)
      {
        fprintf(stderr, "<!--====i_name_ji====|%s<%s>|=====i_name_ji=====-->\n", $1, $2);
        printf("%s<%s", $1, $2);
        $$=0;
        haml_free(2, $1, $2);
      }
      else
      {
        fprintf(stderr, "<!--====i_name====|%s<%s|=====i_name=====-->\n", $1, $2);
        $$=make_tag_name($2, $1);
        if(!$$)
          yyerror("invalid indentation");
      }

      just_indent = 0;
    }
  }
  | SPACE_INDENT div
    {    
      if(!haml_set_space_indent(strlen($1)))
      {
        yyerror("invalid indentation");
      }
      else
      {
        close_previously_parsed_tags($2);
        fprintf(stderr, "<!--====i_div====|%s<%s|=====i_div=====-->\n", $1, $2);
        $$=make_tag_name($2, $1);
        if(!$$)
          yyerror("invalid indentation");
      }
    }
  ;

key_value:
    SYMBOL ARROW STRING
    {
      fprintf(stderr, "<!--====hash=====|%s %s|=====hash=====-->\n", $1, $3);
      char *symbol = strtrim($1, ':');
      char *val = strtrim($3, '"');
      $$=concatenate(4, symbol, "=\"", val, "\"");
      haml_free(4, $1, $3, symbol, val);
    }
    | QUOTED_SYMBOL ARROW STRING
    {
      fprintf(stderr, "<!--====qhash=====|%s %s|=====qhash=====-->\n", $1, $3);
      char *symbol = strtrim2($1, ":\"");
      char *val = strtrim($3, '"');
      $$=concatenate(4, symbol, "=\"", val, "\"");
      haml_free(4, $1, $3, symbol, val);
    }
    ;

hash:
    key_value 
{
      fprintf(stderr, "<!--====kv=====|%s|=====kv=====-->\n", $1);
}
    | hash COMMA key_value
    {
      fprintf(stderr, "<!--====hash,kv=====|%s %s|=====hash,kv=====-->\n", $1, $3);
      $$=concatenate(3, $1, " ", $3);
      haml_free(2, $1, $3);
    }
    ;

name:
   PCT name_element 
    {
      fprintf(stderr, "<!--====PCT name_element=====|%s|=====PCT name_element=====-->\n", $2);
      $$=$2;
      acc = 0;
    }
    ;

name_element:
  VAR
    { 
      fprintf(stderr, "<!--====var=====|%s|=====var=====-->\n", $1);
      $$=$1;
      just_indent=0;
    }
  | VAR content
    {
      fprintf(stderr, "<!--====tag=====|<%s>%s|=====tag=====-->\n", $1, $2);
      char *content = strtrim($2, ' ');
      $$ = concatenate(6, $1, ">", content, "</", $1, ">\n");
      haml_free(3, $1, $2, content);
      just_indent = 1;
    }
  | VAR EQUAL content
    {
      fprintf(stderr, "<!--====tag_code=====|<%s>%s|=====tag_code=====-->\n", $1, $3);
      char *content = strtrim($3, ' ');
      $$ = concatenate(6, $1, "> <%= ", content, " %> </", $1, ">\n");
      haml_free(3, $1, $3, content);
      just_indent = 1;
    }
  | VAR POUND VAR OPEN_BRACE hash CLOSE_BRACE
    {
      fprintf(stderr, "<!--====ne#{}=====|%s id=%s %s|=====ne#{}=====-->\n", $1, $3, $5);

      $$=concatenate(5, $1, " id='", $3, "' ", $5);
      haml_free(3, $1, $3, $5);
      just_indent=0;
    }

  | VAR OPEN_BRACE hash CLOSE_BRACE
    {
      fprintf(stderr, "<!--====ne{}=====|%s %s|=====ne{}=====-->\n", $1, $3);
      $$=concatenate(3, $1, " ", $3);
      haml_free(2, $1, $3);
      just_indent=0;
    }
  | VAR OPEN_BRACE hash CLOSE_BRACE EQUAL content
    {
      fprintf(stderr, "<!--====itag_code=====|<%s>%s|=====itag_code=====-->\n", $1, $3);
      char *content = strtrim($6, ' ');
      $$=concatenate(6, $1, " ", $3, "> <%= ", content, " %");
      haml_free(4, $1, $3, $6, content);
      just_indent=0;
    }
  | VAR OPEN_BRACE hash CLOSE_BRACE content
    {
      fprintf(stderr, "<!--====itaghash=====|<%s %s>%s|=====itaghash=====-->\n", $1, $3, $5);
      char *content = strtrim($5, ' ');
      $$=concatenate(8, $1, " ", $3, ">", content, "</", $1, ">\n");
      haml_free(4, $1, $3, $5, content);
      just_indent=1;
    }

  | VAR POUND id
    {
    fprintf(stderr, "name: %s, id: %s\n", $1, $3); 

      $$=concatenate(3, $1, " ", $3);
      haml_free(2, $1, $3);
      just_indent=0;
    }

  | VAR PERIOD VAR
    {
    fprintf(stderr, "name: %s, id: %s\n", $1, $3); 

      $$=concatenate(4, $1, " class='", $3, "'");
      haml_free(2, $1, $3);
      just_indent=0;
    }
    ;

id:
  VAR
  {
    fprintf(stderr, "<!--====id=====|id='%s'|=====id=====-->\n", $1);
    $$=concatenate(3, "id='", $1, "'");
    free($1);
  }

content:
  CONTENT
  {
    $$=$1;
  }

div: 
  POUND div_element
  {
    $$ = $2;
    acc = 0;
  }
  ;

div_element:
  id
  {
    $$=concatenate(2, "div ", $1);
    haml_free(1, $1);
    just_indent=0;
  }
  | id content
  {
    char *content = strtrim($2, ' ');
    $$=concatenate(5, "div ", $1, ">", content, "</div>\n");
    haml_free(3, $1, $2, content);
    just_indent=1;
  }
  | id EQUAL content
  {
    char *ruby_code = strtrim($3, ' ');
    $$=concatenate(5, "div ", $1, "> <%= ", ruby_code, " %");
    haml_free(3, $1, $3, ruby_code);
    just_indent=0;
  }

%%
void close_tag(struct HAML_STACK *el)
{
    switch (el->type)
    {
      case html:
        fprintf(stderr, "html:%s</%s>\n", el->indent, el->tag_name);
        printf ("%s</%s>\n", el->indent, el->tag_name);
        break;
      case ruby_code:
        fprintf(stderr, "ruby:%s<%% end %%>\n", el->indent);
        printf ("%s<%% end %%>\n", el->indent);
        break;
    }
}

main()
{
  yyparse();

  /*complete continuation line, if any */
  char* continue_line = haml_get_continue_line();
  if(continue_line)
    printf("%s\n", continue_line);

  check_previous_tag();
  /*close tags which are still open*/
  haml_execute_stack(close_tag);
}

