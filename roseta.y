%{

#include <stdio.h>
#include <string.h>
#include "roseta.h"
	
%}

%token FOR_TOKEN WHILE_TOKEN IF_TOKEN ELSE_TOKEN SWITCH_TOKEN DO_TOKEN
%token OP_PLUS OP_MINUS OP_MULT OP_DIV OP_MOD
%token OP_ASSIGN OP_GT OP_LT OP_GE OP_LE OP_EQ
%token OP_AND OP_OR NOT OP_NE
%token NUMBER STRING NAME OBJECT_TOKEN TRUE_TOKEN FALSE_TOKEN NULL_TOKEN
%token OPEN_C_BRACKET CLOSE_C_BRACKET OPEN_S_BRACKET CLOSE_S_BRACKET
%token OPEN_PARENTHESIS CLOSE_PARENTHESIS
%token COLON SEMICOLON COMMA DOT
%token PRINT MAIN
%token TYPE VOID
%token CASE DEFAULT
%union {
	Function * function;
	Variable * variable;
	Class * class;
	char* name;
	Object* object;
}
%start Program

%%

Program 
	: Objects
		{ generateCCode($1); }
	;

Objects
	: Class Objects
		{	
			if($$ == NULL){
				$$ = $1;
			}
			else {
				Class* classes = $$;
				while(classes->next){
					classes= classes->next;
				}
				classes->next = $1;
			}
		}
	| Main
		{
			Object* obj = getNewObject();
			obj->classes = $$;
			obj->main = $1;
			$$ = obj;
		}
	;

Class 
	: OBJECT_TOKEN NAME OPEN_C_BRACKET Variables Functions CLOSE_C_BRACKET
		{ 
			Class* class = getNewClass();
			class->name = $1;
			class->variables = $2;
			class->next = null;
			$$ = class;
		}
	;

Variables
	: Variable SEMICOLON Variables
		{	
			if($$ == NULL){
				$$ = $1;
			}
			else {
				Variable* variables = $$;
				while(variables->next){
					variables = variables->next;
				}
				variable->next = $1;
			}
		}
	| 	
	;

Variable 
	: TYPE NAME
		Variable* var = getNewVariable();
		var->type = $1;
		var->name = $2;
		$$ = var;
	;

Functions
	: Function Functions
		 {	
			if($$ == NULL){
				$$ = $1;
			}
			else {
				Function* functions = $$;
				while(functions->next){
					functions = functions->next;
				}
				functions->next = $1;
			}
		}
	| 	
	;

Function
	: TYPE NAME Parameters Bloque
		Function* fun = getNewFunction();
		fun->type = $1;
		fun->name = $2;
		fun->Parameters = $3;
		fun->Bloque = $4;
		$$ = fun;
	| VOID NAME Parameters Bloque
		Function* fun = getNewFunction();
		fun->type = $1;
		fun->name = $2;
		fun->Parameters = $3;
		fun->Bloque = $4;
		$$ = fun;
	;

Parameters
	: OPEN_PARENTHESIS Variable_1 CLOSE_PARENTHESIS
		{ $$ = "( " + $2 + " )"; }
	;

Variable_1
	: Variable Variable_2
		{ $$ = "" + $1 + $2; }
	| 	
	;

Variable_2
	: COMMA Variable Variable_2
		{ $$ = ", " + $2 + $3; }
	|	
	;

Bloque
	: OPEN_C_BRACKET Statement CLOSE_C_BRACKET
		{ $$ = "{\n" + $2 + "\n}"; }
	;

Statement
	: Variable SEMICOLON Statement
		{ $$ = $1 + ";\n" + $3; }
	| Expression SEMICOLON Statement
		{ $$ = $1 + ";\n" + $3; }
	| Variable OP_ASSIGN Expression SEMICOLON Statement
		{ $$ = $1 + "=" + $3 + ";\n" + $5; }
	| NAME OP_ASSIGN Expression SEMICOLON Statement
		{ $$ = $1 + "=" + $3 + ";\n" + $5; }
	| WHILE_TOKEN OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS Bloque Statement
		{ $$ = "while ( " + $3 + " )\n" + $5 + "\n" + $6; }
	| FOR_TOKEN OPEN_PARENTHESIS Expression SEMICOLON Expression SEMICOLON Expression SEMICOLON CLOSE_PARENTHESIS Bloque Statement
		{ $$ = "for ( " + $3 + " ; " + $5 + " ; " + $7 + " )\n" + $9 + "\n" + $10; }
	| IF_TOKEN OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS Bloque Statement
		{ $$ = "if ( " + $3 + " )\n" + $5 + "\n" + $6; }
	| IF_TOKEN OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS Bloque ELSE_TOKEN Bloque Statement
		{ $$ = "if ( " + $3 + " )\n" + $5 + "\n" + "else\n" + $7 + "\n" + $8; }
	| SWITCH_TOKEN OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS OPEN_C_BRACKET Cases CLOSE_C_BRACKET Statement
		{ $$ = "switch ( " + $3 + " )\n{\n" + $6 + "\n}" + $8; }
	| DO_TOKEN Bloque WHILE_TOKEN OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS SEMICOLON Statement
		{ $$ = "do\n" + $2 + "\n" + "while ( " + $5 + " );\n" + $8; }
	|	
	;

Expression
	: Expression Operator Expression
		{ $$ = $1 + " " + $2 + " " + $3; }
	| Expression
		{ $$ = "" + $1 }
	| OPEN_PARENTHESIS Expression CLOSE_PARENTHESIS
		{ $$ = "( " + $2 + " )"; }
	| Term 
		{ $$ = "" + $1; }
	| NAME DOT NAME OPEN_PARENTHESIS Value_1 CLOSE_PARENTHESIS
		{ $$ = $1 + "_" + $3 + "( " + $5 + " )"; }
	| NAME OPEN_PARENTHESIS Value_1 CLOSE_PARENTHESIS
	 	{ $$ = $1 + " ( " + $3 + " )";}
	| PRINT OPEN_PARENTHESIS STRING Value_2 CLOSE_PARENTHESIS
		{ $$ = "printf" "( " $3 $4 ")"; }
	;

Value_1
	: Expression Value_2
		{ $$ = "" + $1 + $2;}
	|	
	;

Value_2
	: COMMA Expression Value_2
		{ $$ = ", " + $1 + $2;}
	|
	;

Term
	: NAME
		{ $$ = $1; }
	| NUMBER
		{ $$ = $1; }
	| TRUE_TOKEN
		{ $$ = $1; }
	| FALSE_TOKEN
		{ $$ = $1; }
	| STRING
		{ $$ = $1; }
	| NULL_TOKEN
		{ $$ = $1; }
	;

Operator 
	: OP_PLUS
		{ $$ = $1; }
	| OP_MINUS
		{ $$ = $1; }
	| OP_MULT
		{ $$ = $1; }
	| OP_DIV
		{ $$ = $1; }
	| OP_MOD
		{ $$ = $1; }
	| OP_AND
		{ $$ = $1; }
	| OP_OR
		{ $$ = $1; }
	| OP_EQ
		{ $$ = $1; }
	| OP_GT
		{ $$ = $1; }
	| OP_LT
		{ $$ = $1; }
	| OP_LE
		{ $$ = $1; }
	| OP_GE
		{ $$ = $1; }
	;

Cases 
	: CASE Expression COLON Bloque Cases
		{ $$ = "case " $2 " :\n" $4 "\n" $5; }
	| DEFAULT COLON Bloque
		{ $$ = "default : " "\n" $3 "\n"; }
Main 
	: TYPE MAIN OPEN_PARENTHESIS VOID CLOSE_PARENTHESIS Bloque
		{ $$ = $1 " main " "() " $6; }
	;


%%

int
yywrap() {
	return 1;
}

int 
main() {
	yyparse();
}












