%{
    #include "sample.tab.h"
    #include "string_util.h"
%}

%option noyywrap noinput nounput bison-locations

%%

[ \t]   ; // ignore all whitespace
"int"|"float"           { yylval->text = string_dup(yytext); return TYPE; }
[a-zA-Z][a-zA-Z0-9_]*   { yylval->text = string_dup(yytext); return IDENTIFIER; }
[0-9]+   { yylval->u.ival = atoi(yytext); yylval->text = string_dup(yytext); yylval->token = INT; return INT; }
[0-9]+[.][0-9]+	{ yylval->u.fval = atoi(yytext); yylval->text = string_dup(yytext); yylval->token = FLOAT; return FLOAT; }
"="             { return ATRIB; }
"+"             { return SOMA; }
"-"             { return SUB; }
"*"             { return MULT; }
"/"             { return DIV; }
"("             { return ABRE_PAREN; }
")"             { return FECHA_PAREN; }
[\n]            { return NEWLINE; }
";"             { return SCOLON; }
.               { /* Tratar caracteres inválidos */ }

%%
