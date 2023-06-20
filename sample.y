%locations
%define api.pure full
%define parse.error detailed
%code top {
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
}

%code requires {
    struct my_token {
        char *text;
        union {
            int ival;
            float fval;
        } u;
        int token;
    };

    typedef struct my_token my_token;

    #define ERROR 0;
}

%code {
    #include "sample.tab.h"
    #include "string_util.h"

    void yyerror(YYLTYPE* yyllocp, const char* msg);
    int yylex(YYSTYPE* yylvalp, YYLTYPE* yyllocp);

    int soma(my_token A, my_token B);
    int fdiv(my_token A, my_token B);
    // int sub(my_token A, my_token B);
    // int mult(my_token A, my_token B);
    char* printType(int A);

    int isVariableDeclared(char* variableName);
    void addVariable(char* variableName, int dataType);
    void updateVariable(char* variableName, int value);
    int getIdType(char* variableName);


    // Maximum number of variables
    #define MAX_VARIABLES 100

    // Structure to represent a variable entry in the symbol table
    typedef struct {
        char name[256];
        int dataType;  // Assuming int datatype for simplicity
        int value;     // Value of the variable
    } VariableEntry;

    // Array-based symbol table
    VariableEntry symbolTable[MAX_VARIABLES];
    int numVariables = 0;
}

%define api.value.type {struct my_token}
%token IDENTIFIER
%token INT FLOAT

%token ATRIB
%token SOMA SUB MULT DIV
%token ABRE_PAREN FECHA_PAREN

%token NEWLINE
%token TYPE
%token SCOLON

%left SOMA SUB
%left MULT DIV

%start boot

%%

boot: 
    | boot line

line: NEWLINE
    | statement NEWLINE { }
    | declaration NEWLINE { }
    ;

declaration: TYPE IDENTIFIER SCOLON {
        int dataType = FLOAT;
        if (strcmp($1.text, "int") == 0) {
            dataType = INT;
        }

        addVariable((char*) $2.text, dataType);

        printf("Variable %s -> %s\n", $2.text, printType(dataType));
    }
    ;

statement: IDENTIFIER ATRIB expression SCOLON 
          {
                updateVariable($1.text, $3.token);

                printf("Expression: %s.\n", printType($3.token));
          }
          ;

expression: INT { $$ = $1; }
          | FLOAT { $$ = $1; }
          | IDENTIFIER { 
                my_token v;
                v.token = getIdType($1.text);
                $$ = v;
            }
          | expression SOMA expression { 
                my_token v;
                v.token = soma($1, $3);
                $$ = v;
            }
//           | expression SUB expression { $$ = sub($1,$3); }
//           | expression MULT expression { $$ = mult($1,$3); }
          | expression DIV expression {
                my_token v;
                v.token = fdiv($1, $3);
                $$ = v;
            }
          | ABRE_PAREN expression FECHA_PAREN { $$ = $2; }
          ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(YYLTYPE *yyllocp, const char *str) {
    fprintf(stderr, "error: %s in line %d, column %d\n", str, yyllocp->first_line, yyllocp->first_column);
}

int soma(my_token A, my_token B) {
  int aux;

  if (A.token == FLOAT && B.token == FLOAT) {
    aux = FLOAT;
  }
  else if (A.token == FLOAT && B.token == INT) {
    aux = FLOAT;
  }
  else if (A.token == INT && B.token == FLOAT) {
    aux = FLOAT;
  }
  else if (A.token == INT && B.token == INT) {
    aux = INT;
  }
  else {
    aux = ERROR;
  }

  return aux;
}

int fdiv(my_token A, my_token B) {
  int aux;

  if (A.token == FLOAT && B.token == FLOAT) {
    aux = FLOAT;
  }
  else if (A.token == FLOAT && B.token == INT) {
    aux = FLOAT;
  }
  else if (A.token == INT && B.token == FLOAT) {
    aux = FLOAT;
  }
  else if (A.token == INT && B.token == INT) {
    aux = INT;
  }
  else {
    aux = ERROR;
  }

  return aux;
}

// int sub(int A, int B) {
//   int aux;

//   if (A == FLOAT && B == FLOAT) {
//     aux = FLOAT;
//   }
//   else if (A == FLOAT && B == INT) {
//     aux = FLOAT;
//   }
//   else if (A == INT && B == FLOAT) {
//     aux = FLOAT;
//   }
//   else if (A == INT && B == INT) {
//     aux = INT;
//   }
//   else {
//     aux = ERROR;
//   }

//   return aux;
// }

// int mult(int A, int B) {
//   int aux;

//   if (A == FLOAT && B == FLOAT) {
//     aux = FLOAT;
//   }
//   else if (A == FLOAT && B == INT) {
//     aux = FLOAT;
//   }
//   else if (A == INT && B == FLOAT) {
//     aux = FLOAT;
//   }
//   else if (A == INT && B == INT) {
//     aux = INT;
//   }
//   else {
//     aux = ERROR;
//   }

//   return aux;
// }

// Function to check if a variable is already declared in the symbol table
int isVariableDeclared(char* variableName) {
    int i;
    for (i = 0; i < numVariables; i++) {
        if (strcmp(symbolTable[i].name, variableName) == 0) {
            return 1;  // Variable is already declared
        }
    }
    return 0;  // Variable is not declared
}

// Function to add a variable entry to the symbol table
void addVariable(char* variableName, int dataType) {
    if (numVariables < MAX_VARIABLES) {
        VariableEntry entry;
        strcpy(entry.name, variableName);
        entry.dataType = dataType;
        symbolTable[numVariables] = entry;
        numVariables++;
    } else {
        printf("Error: Maximum number of variables exceeded.\n");
        exit(1);
    }
}

// Function to update the value of a variable in the symbol table
void updateVariable(char* variableName, int value) {
    int i;
    for (i = 0; i < numVariables; i++) {
        if (strcmp(symbolTable[i].name, variableName) == 0) {
            if (symbolTable[i].dataType == value) {
                printf("Variable %s and expression are the same type.\n", variableName);
            } else {
                printf("Error: Variable '%s' expects type %s and encountered type %s.\n", variableName, printType(symbolTable[i].dataType), printType(value));
                exit(1);
            }
            return;
        }
    }
    printf("Error: Variable '%s' is not declared.\n", variableName);
    exit(1);
}

char* printType(int A) {
    switch (A)
    {
    case INT:
        return "integer";
    break;

    case FLOAT:
        return "float";
    break;

    default:
        return "unrecognized";
    }
}

int getIdType(char* variableName) {
    int i;
    for (i = 0; i < numVariables; i++) {
        if (strcmp(symbolTable[i].name, variableName) == 0) {

            return symbolTable[i].dataType;
        }
    }
    printf("Error: Variable '%s' is not declared.\n", variableName);
    exit(1);
}