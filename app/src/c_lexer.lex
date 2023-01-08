%option noyywrap nounput noinput

%{
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include "c_parser.h"

typedef struct
{
  int line; // Строка
  int column; // Столбец
} Position_t;

extern FILE* result;
static Position_t Position = {1, 1}; //Текущая позиция в файле
static bool GotError = false;// и

// Функция сдвига на num строк
static void incrLine(int num) {Position.line += num;}
// Функция возвращает номер текущей строки в читаемом файле
static int line(void) {return Position.line;}
// Функция сдвига на num столбцов
static void incrColumn(int num) {Position.column += num;}
// Функция возвращает номер текущего столбца в читаемом файле
static int column(void) {return Position.column;}
// Функция сброса номера текущего столбца в читаемом файле в начало
// строки
static void dropColumn(void) {Position.column = 1;}

#define YY_USER_ACTION { \
  yylloc.first_line = line(); \
  yylloc.last_line = line(); \
  yylloc.first_column = column(); \
  yylloc.last_column = column() + yyleng - 1; \
  incrColumn(yyleng); }

static void printLexeme(const char * tokName)
{
  fprintf(result, "%s, \"%s\", %d, %d\n",
    tokName,
    yytext,
    line(),
    column() - yyleng);
}

%}

%x COMMENT_LINE COMMENT_BLOCK

digit [0-9]
letter [a-zA-Z]
delim [;,]
gap_open \(
gap_close \)
space [ \t]+
block_begin \{
block_end   \}

octa [0-7]
hex [0-9a-f]
binary [01]

id ("_"|{letter})("_"|{letter}|{digit})*
lable ("_"|{letter}|{digit})+":"

int [-+]?("0"?("x"{hex}+|"b"{binary}+|{octa}+)|{digit}+)[uUlL]?[uUlL]?
float [-+]?({digit}*\.{digit}+|{digit}+\.)([eE][-+]?{digit}+)?[fF]?
string (\".*\")|(\'.*\')

arithm_oper ([+/&|]|"*"|"%"|"-"|"<<"|">>")
index ("_"|{letter})("_"|{letter}|{digit})+"["({id}|{int})"]"
assign {arithm_oper}?=
cmp ("<"|">"|"<="|">="|"!="|"=="|"&&"|"||")

%%
"/*"                { BEGIN(COMMENT_BLOCK); }
<COMMENT_BLOCK>.    { }
<COMMENT_BLOCK>"*/" { BEGIN(INITIAL); }

"//"                { BEGIN(COMMENT_LINE); }
<COMMENT_LINE>\n    { BEGIN(INITIAL); }
<COMMENT_LINE>.     { }

{id} { return TOK_ID; }
{lable} { return TOK_LABLE; }

"if" { return TOK_IF; }
"goto" { return TOK_GOTO; }


{cmp} { return TOK_CMP; }
{arithm_oper} { return TOK_CMP;}
{assign} { return TOK_ASSIGN; }
{index} { return TOK_INDEX; }

{int} { return TOK_INT; }
{float} { return TOK_FLOAT; }
{string}  { return TOK_STR; }

{block_begin} { return TOK_BLOCK_BEGIN; }
{block_end} { return TOK_BLOCK_END; }
{space} {}

{delim} { return TOK_DELIM; }
{gap_open} { return TOK_GAP_O; }
{gap_close} { return TOK_GAP_C; }

\r?\n/(.|\n) { dropColumn(); incrLine(1);}
[^a-zA-Z_0-9+\-*/><!;,=(){}\[\]&|\'" \n\t] { return YYerror; }
. { printLexeme("UNKNOWN"); }
\r?\n  { return YYEOF; }

%%