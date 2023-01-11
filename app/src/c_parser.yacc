%locations

%{
#include "c_lexer.h"

/* Это сигнатуры необходимых bison'у функций */
void yyerror (char const * s); // функция обработки ошибок
/* Здесь сигнатуры наших функций */
// вывод терминалов
static void printTerminal(const char *tokName);
// вывод нетерминалов
static void printNonTerminal(const char *tokName);
// вывод сообщений об ошибках
static void printErrorMessage(const char * msg);

%}

%token TOK_ID TOK_INT TOK_FLOAT TOK_INDEX TOK_DELIM TOK_STR TOK_CMP TOK_IF TOK_GOTO TOK_LABLE TOK_BLOCK_BEGIN TOK_BLOCK_END TOK_GAP_O TOK_GAP_C
%left  TOK_ASSIGN
%start program

%token TOK_ARITHM

%%

program: statement
       | program statement

statement
        : expression
        | error

string: TOK_STR { printNonTerminal("CONST STRING"); }

number
      : TOK_INT { printNonTerminal("CONST INT"); }
      | TOK_FLOAT { printNonTerminal("CONST FLOAT"); }

indexing
      : number
      | TOK_ID'['TOK_ID']' { printNonTerminal("INDEXING"); }
      | TOK_ID'['TOK_INT']' { printNonTerminal("INDEXING"); }

param
      : TOK_ID { printNonTerminal("IDENTIFIER"); }
      | indexing

arithm
      : param
      | arithm TOK_ARITHM param { printNonTerminal("ARITHM"); }
      | param TOK_ARITHM param { printNonTerminal("ARITHM"); }

cmp
      : arithm
      | cmp TOK_CMP param { printNonTerminal("COMPARE"); }
      | param TOK_CMP param { printNonTerminal("COMPARE"); }

assign
      : cmp
      /* | TOK_ID TOK_ASSIGN param { printNonTerminal("ASSIGN"); } */
      | assign TOK_ASSIGN string { printNonTerminal("ASSIGN"); }
      | assign TOK_ASSIGN cmp { printNonTerminal("ASSIGN"); }
      /* | TOK_ID TOK_ARITHM TOK_ASSIGN param { printNonTerminal("ARITHM ASSIGN"); } */
      | assign TOK_ARITHM TOK_ASSIGN cmp { printNonTerminal("ASSIGN"); }
      /* | assign TOK_ASSIGN param
      | assign TOK_ASSIGN TOK_STR
      | assign TOK_ASSIGN arithm
      | assign TOK_ARITHM TOK_ASSIGN arithm */


expression
      : assign
      | TOK_LABLE { printNonTerminal("LABLE"); }
      | TOK_GOTO TOK_ID { printNonTerminal("GOTO"); }
      | conditional
      /* | param */
      | ';' { printNonTerminal("EXPRESSION"); }

gap_expression
      : '('expression')' { printNonTerminal("GAP EXPRESSION"); }

block_expression
      : '{' expression '}' { printNonTerminal("BLOCK EXPRESSION"); }
      | '{' block_expression '}' { printNonTerminal("BLOCK EXPRESSION"); }

conditional
      : TOK_IF '(' expression ')' statement { printNonTerminal("IF OPERATOR"); }
      /* | TOK_IF '(' expression ')' expression { printNonTerminal("IF OPERATOR"); } */
%%



void yyerror(char const * msg)
{
  fprintf(stderr, "%d:%d: '%s' - '%s'\n", yylloc.first_line, yylloc.first_column, yytext, msg);
}
// вывод терминалов
static void printTerminal(const char *tokName){
  fprintf(stdout, "<'%s', %d:%d, %d:%d>\n", tokName, yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column);
}
// вывод нетерминалов
static void printNonTerminal(const char *tokName){
  fprintf(stderr, "<'%s'>\n", tokName);
}