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
        : arithm_oper';' { printNonTerminal("ARITHM EXPRESSION"); }
        | assign_oper';' {  printNonTerminal("ASSIGN EXPRESSION");}
        | TOK_LABLE { printNonTerminal("LABLE"); }
        | TOK_ID { printNonTerminal("IDENTIFIER"); }
        | TOK_IF '(' cmp_oper ')' { printNonTerminal("COMAPRE EXPRESSION"); }
        | error

num_consts:
      | TOK_INT
      | TOK_FLOAT

indexing
      : TOK_ID'['TOK_ID']'
      | TOK_ID'['TOK_INT']'

oper_param
      : TOK_ID
      | indexing
      | num_consts

arithm_oper
      : oper_param TOK_ARITHM oper_param
      | arithm_oper TOK_ARITHM oper_param

assign_oper
      : TOK_ID TOK_ASSIGN oper_param
      | TOK_ID TOK_ASSIGN TOK_STR
      | TOK_ID TOK_ASSIGN arithm_oper
      | TOK_ID TOK_ARITHM TOK_ASSIGN arithm_oper
      | assign_oper TOK_ASSIGN oper_param
      | assign_oper TOK_ASSIGN TOK_STR
      | assign_oper TOK_ASSIGN arithm_oper
      | assign_oper TOK_ARITHM TOK_ASSIGN arithm_oper

cmp_oper
      : oper_param TOK_CMP oper_param
      | cmp_oper TOK_CMP oper_param
      
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