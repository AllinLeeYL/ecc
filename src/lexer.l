%option nounput
%{
#include "common.h"
#include "parser.h"  // yacc header
extern struct Yields progYields;
int lineno=1;
int curYield = 0;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+

CHAR \'(\\t|\\n|\\r|[^\\])\'
STRING \"([^\"^\\]|\\n|\\t|\\r)+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */

{STRING} {
    TreeNode *node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = string(yytext);
    yylval = node;
    return STRING;
}

"++" return LOP_PLUSPLUS;
"--" return LOP_SUBSUB;

"!" return LOP_NOT;

"==" return LOP_EQ;
"!=" return LOP_NEQ;
"+=" return LOP_PLUSEQ;
"-=" return LOP_SUBEQ;
"*=" return LOP_MULTEQ;
"/=" return LOP_DIVEQ;
"%=" return LOP_MODEQ;

"*" return LOP_MULT;
"/" return LOP_DIV;
"%" return LOP_MOD;
"+" return LOP_PLUS;
"-" return LOP_SUB;
">=" return LOP_GEQ;
"<=" return LOP_LEQ;
">" return LOP_G;
"<" return LOP_L;

"&&" return LOP_AND;
"||" return LOP_OR;
"=" return LOP_ASSIGN;
"&" return LOP_LAB;

";" return  SEMICOLON;
"," return COMMA;

"if" return IF;
"else" return ELSE;
"while" return WHILE;
"for" return FOR;
"return" return RETURN;
"printf" return PRINTF;
"scanf" return SCANF;

"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"void" return T_VOID;
"const" return T_CONST;


"(" {return LP;}
")" {return RP;}
"[" {return LBCT;}
"]" {return RBCT;}
"{" {curYield = progYields.newYield(curYield);
     return LB;}
"}" {curYield = progYields.yields[curYield].father;
     return RB;}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1] != '\\' ? yytext[1] : 
                   yytext[2] == 't' ? '\t' : 
                   yytext[2] == 'n' ? '\n' :
                   yytext[2] == 'r' ? '\r' :
                   ' ';
    yylval = node;
    return CHAR;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    node->yield_offset = curYield;
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%