#ifndef ROSETA_H
#define ROSETA_H

#include <stdio.h>
#include <string.h>
#include <malloc.h>

typedef struct Function
{
	char* type;
	char* name;
	Parameters* parameters;
	Bloque* bloque;
	Function* next;
};

typedef struct Variable {
	char* name;
	char* type;
	Variable* next;
};

typedef struct Class {
	char* name;
	Variable* variables;
	Function* functions;
	Card* next;
};

typedef struct Object {
	Class* classes;
	Function* main;
};

Class * getNewClass();
Object * getNewObject();
Variable * getNewVariable();
Function * getNewFunction();

#endif