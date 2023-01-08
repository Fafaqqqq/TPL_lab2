%locations

%{
#include "c_lexer.h"
/* Это сигнатуры необходимых bison'у функций */
void yyerror (char const * s); // функция обработки ошибок
/* Здесь сигнатуры наших функций */
// вывод терминалов
static void printTerminal(const char *tokName)
{
  printf("%s\n", tokName);
}
// вывод нетерминалов
static void printNonTerminal(const char *tokName)
{
  printf("%s\n", tokName);
}
// вывод сообщений об ошибках
static void printErrorMessage(const char * msg)
{
  fprintf(stderr, "%s\n", msg);
}

void yyerror(char const * msg)
{
  fprintf (stderr,
  "\'%s\' ", msg);
}

%}

%token TOK_ID TOK_INT TOK_FLOAT TOK_INDEX TOK_DELIM TOK_STR TOK_ARITHM TOK_CMP TOK_IF TOK_GOTO TOK_LABLE TOK_BLOCK_BEGIN TOK_BLOCK_END TOK_GAP_O TOK_GAP_C
%right TOK_ASSIGN
%left '<' '>' '='
%start program

%%
program: statement { printNonTerminal("statement"); }
       | program statement { printNonTerminal("program statement"); }

expr: {printNonTerminal("for expr; expr; expr) do oper;"); }
statement: nfor'('expr';'expr';'expr')' ndo oper';'
           {printNonTerminal("for expr; expr; expr) do oper;"); }
          | error';'

oper: statement { printNonTerminal("statement"); }
    | expr { printNonTerminal("expr"); }

expr_cmp: prim_expr cmp prim_expr
        { printNonTerminal("prim_expr cmp prim_expr"); }

prim_expr: TOK_ID { printTerminal("TOK_ID");}
         | TOK_INT { printTerminal("TOK_NUM"); }

cmp: '<' { printTerminal("\'<\'"); }
   | '>' { printTerminal("\'>\'"); }
   | '=' { printTerminal("\'=\'"); }

nfor: { printTerminal("TOK_FOR");}

ndo: { printTerminal("TOK_DO");}

nassign: TOK_ASSIGN { printTerminal("TOK_ASSIGN");}

ident: TOK_ID { printTerminal("TOK_ID"); }

%%