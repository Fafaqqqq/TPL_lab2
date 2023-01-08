#!/bin/bash

NAME_LEXER=lexer
NAME_PARSER=parser

[ ! -z "$1" ] && NAME_LEXER=$1 
[ ! -z "$2" ] && NAME_PARSER=$2

flex --outfile=app/src/$NAME_LEXER.c --header-file=app/src/$NAME_LEXER.h app/src/$NAME_LEXER.lex
bison app/src/$NAME_PARSER.yacc --defines=app/src/$NAME_PARSER.h -o app/src/$NAME_PARSER.c