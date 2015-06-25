%{
#include "y.tab.h"
%}
%option nounput yylineno

%%

"for"							{return FOR_TOKEN;}
"while"							{return WHILE_TOKEN;}
"if"							{return IF_TOKEN;}
"do"							{return DO_TOKEN;}
"else"							{return ELSE_TOKEN;}
"object" 						{return OBJECT_TOKEN;}
"true"							{return TRUE_TOKEN;}
"null"							{return NULL_TOKEN;}
"false"							{return FALSE_TOKEN;}
"print"							{return PRINT;}
"void"							{return VOID;}
"case"							{return CASE;}
"default"						{return DEFAULT;}
"int"							{return TYPE;}
"char"							{return TYPE;}
"char *"						{return TYPE;}
"int *"							{return TYPE;}
"main"							{return MAIN;}
"switch"						{return SWITCH_TOKEN;}
"-"								{return OP_MINUS;}
"+"								{return OP_PLUS;}
"*"								{return OP_MULT;}
"/"								{return OP_DIV;}
"%"								{return OP_MOD;}
"<="							{return OP_LE;}
">="							{return OP_GE;}
"=="							{return OP_EQ;}
">"								{return OP_GT;}
"<"								{return OP_LT;}
"="								{return OP_ASSIGN;}
":"								{return COLON;}
"!="							{return OP_NE;}
"||"							{return OP_OR;}
"&&"							{return OP_AND;}
"!"								{return NOT;}
int|Integer|String    			{return TYPE;}
[a-zA-Z][_a-zA-Z0-9]*			{return NAME;}
[\+-]?[1-9][0-9]*				{return NUMBER;}
[\"].*[\"]						{return STRING;}
"{"								{return OPEN_C_BRACKET;}
"}"								{return CLOSE_C_BRACKET;}
"["								{return OPEN_S_BRACKET;}
"]"								{return CLOSE_S_BRACKET;}
"("								{return OPEN_PARENTHESIS;}
")"								{return CLOSE_PARENTHESIS;}
";"								{return SEMICOLON;}
"."								{return DOT;}
","								{return COMMA;}
[ \t\n]							;
.								{printf("unexpected character\n");}

%%

int yywrap(void)
{
	return 1;
}