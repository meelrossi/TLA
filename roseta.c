#include "roseta.h"

Function * 
getNewFunction() {
	Function * fun = (Function*)Malloc(sizeof(Function));
	return fun;
}

Variable * 
getNewVariable() {
	Variable * var = (Variable*)Malloc(sizeof(Variable));
	return var;
}

Class * 
getNewClass() {
	Class * class = (Class*)Malloc(sizeof(Class));
	return class;
}

Function * 
getNewObject() {
	Object * obj = (Object*)Malloc(sizeof(Object));
	return obj;
}