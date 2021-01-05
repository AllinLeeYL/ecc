%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    struct Yields progYields;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}

%token LP RP LBCT RBCT LB RB

%token IF ELSE WHILE FOR RETURN PRINTF SCANF

%token T_CHAR T_INT T_STRING T_BOOL T_VOID T_CONST

%token SEMICOLON COMMA

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left LOP_ASSIGN
%left LOP_OR
%left LOP_AND
%left LOP_EQ LOP_NEQ LOP_PLUSEQ LOP_SUBEQ LOP_MULTEQ LOP_DIVEQ LOP_MODEQ
%left LOP_G LOP_L LOP_GEQ LOP_LEQ
%left LOP_PLUS LOP_SUB
%left LOP_MULT LOP_DIV LOP_MOD
%left LOP_NOT LOP_LAB
%left LOP_PLUSPLUS LOP_SUBSUB
%nonassoc UMINUS

%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);}
;

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| RETURN expr SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_RETURN; $$->addChild($2); $$->type = $2->type;}
| RETURN SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_RETURN; $$->type = TYPE_VOID;}
| declaration {$$ = $1;}
| expr SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_EXPR; $$->addChild($1);}
| PRINTF LP exprs RP SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_PRINTF; $$->addChild($3);}
| SCANF LP exprs RP SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SCANF; $$->addChild($3);}
| IF_STMT {$$ = $1;}
| WHILE LP expr RP LB statements RB {$$ = new TreeNode($3->lineno, NODE_STMT);
                                     $$->stype = STMT_WHILE;
                                     TreeNode* stblock0 = new TreeNode(lineno, NODE_STMT);
                                     stblock0->addChild($3);
                                     TreeNode* stblock1 = new TreeNode(lineno, NODE_STMT);
                                     stblock1->addChild($6);
                                     $$->addChild(stblock0); $$->addChild(stblock1);
                                     $3->typeCheck(TYPE_BOOL);}
| FOR LP statement expr SEMICOLON expr RP LB statements RB {$$ = new TreeNode($3->lineno, NODE_STMT);
                                                            $$->stype = STMT_FOR;
                                                            TreeNode* stblock0 = new TreeNode(lineno, NODE_STMT);
                                                            stblock0->addChild($3);
                                                            TreeNode* stblock1 = new TreeNode(lineno, NODE_STMT);
                                                            stblock1->addChild($4);
                                                            TreeNode* stblock2 = new TreeNode(lineno, NODE_STMT);
                                                            stblock2->addChild($6);
                                                            TreeNode* stblock3 = new TreeNode(lineno, NODE_STMT);
                                                            stblock3->addChild($9);
                                                            $$->addChild(stblock0);
                                                            $$->addChild(stblock1);
                                                            $$->addChild(stblock2);
                                                            $$->addChild(stblock3);
                                                            $4->typeCheck(TYPE_BOOL);}
;

IF_STMT
: IF LP expr RP LB statements RB ELSE IF_STMT {$$ = new TreeNode(lineno, NODE_STMT);
                                               $$->stype = STMT_IF;
                                               TreeNode* stblock0 = new TreeNode(lineno, NODE_STMT);
                                               stblock0->addChild($3);
                                               TreeNode* stblock1 = new TreeNode(lineno, NODE_STMT);
                                               stblock1->addChild($6);
                                               TreeNode* stblock2 = new TreeNode(lineno, NODE_STMT);
                                               stblock2->addChild($9);
                                               $$->addChild(stblock0); $$->addChild(stblock1); $$->addChild(stblock2);
                                               $3->typeCheck(TYPE_BOOL);
                                               }
| IF LP expr RP LB statements RB ELSE LB statements RB {$$ = new TreeNode(lineno, NODE_STMT);
                                                        $$->stype = STMT_IF;
                                                        TreeNode* stblock0 = new TreeNode(lineno, NODE_STMT);
                                                        stblock0->addChild($3);
                                                        TreeNode* stblock1 = new TreeNode(lineno, NODE_STMT);
                                                        stblock1->addChild($6);
                                                        TreeNode* stblock2 = new TreeNode(lineno, NODE_STMT);
                                                        stblock2->addChild($10);
                                                        $$->addChild(stblock0); $$->addChild(stblock1); $$->addChild(stblock2);
                                                        $3->typeCheck(TYPE_BOOL);}
| IF LP expr RP LB statements RB {$$ = new TreeNode(lineno, NODE_STMT); 
                                  $$->stype = STMT_IF;
                                  TreeNode* stblock0 = new TreeNode(lineno, NODE_STMT);
                                  stblock0->addChild($3);
                                  TreeNode* stblock1 = new TreeNode(lineno, NODE_STMT);
                                  stblock1->addChild($6);
                                  $$->addChild(stblock0); $$->addChild(stblock1);
                                  $3->typeCheck(TYPE_BOOL);}
;

declaration
: T decl_exprs SEMICOLON {$$ = new TreeNode($1->lineno, NODE_STMT);
                          $$->stype = STMT_DECL;
                          $$->addChild($1); $$->addChild($2);
                          $$->allocTypeForDECL($1->type);} 
| T IDENTIFIER LP RP LB statements RB {int diff = 1;
                                       struct Symbol * lastSymbol = progYields.ifExists($2->yield_offset, $2->var_name, &diff);
                                       if (diff == 0) {printf("Type error\n");exit(0);}
                                       struct Symbol * curSymbol = progYields.addSym($2->yield_offset, $2->var_name);
                                       $2->symbol_p = curSymbol; $2->symbol_p->isFunc = 1;
                                       $$ = new TreeNode($1->lineno, NODE_STMT);
                                       $$->stype = STMT_FUNC_DECL;
                                       $$->addChild($1); $$->addChild($2); $$->addChild($6);
                                       $$->rtTypeCheck($1->type);}
;

decl_exprs
: decl_expr {$$ = $1;}
| decl_exprs COMMA decl_expr {$$ = $1; $$->addSibling($3);}
;

decl_expr
: IDENTIFIER {$$ = $1;
              int diff = 1;
              struct Symbol * lastSymbol = progYields.ifExists($$->yield_offset, $$->var_name, &diff);
              if (diff == 0) {printf("Type error\n"); exit(0);}
              $$->symbol_p = progYields.addSym($$->yield_offset, $$->var_name);}
| IDENTIFIER LOP_ASSIGN expr {int diff = 1;
                              struct Symbol * lastSymbol = progYields.ifExists($1->yield_offset, $1->var_name, &diff);
                              if (diff == 0) {printf("Type error\n"); exit(0);}
                              $1->symbol_p = progYields.addSym($1->yield_offset, $1->var_name);
                              $$ = new TreeNode(lineno, NODE_EXPR); 
                              $$->optype = OP_ASSIGN;
                              $$->addChild($1); 
                              $$->addChild($3);}
;

exprs
: expr {$$ = $1;}
| exprs COMMA expr {$$ = $1; $$->addSibling($3);}
;

expr
: VALUE {$$ = $1;}
| LP expr RP {$$ = $2;}
| LOP_PLUSPLUS expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_FRONTPP; $2->typeCheck(TYPE_INT); $$->type = TYPE_INT; $$->addChild($2);}
| expr LOP_PLUSPLUS {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_TAILPP; $1->typeCheck(TYPE_INT); $$->type = TYPE_INT; $$->addChild($1);}
| LOP_SUBSUB expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_FRONTSS; $2->typeCheck(TYPE_INT); $$->type = TYPE_INT; $$->addChild($2);}
| expr LOP_SUBSUB {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_TAILSS; $1->typeCheck(TYPE_INT); $$->type = TYPE_INT; $$->addChild($1);}
| LOP_NOT expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_NOT; $$->addChild($2); $2->typeCheck(TYPE_BOOL); $$->type = TYPE_BOOL;/*逻辑非*/}
| LOP_LAB expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_GETADDR; $$->addChild($2);/*取地址*/}
| LOP_PLUS expr %prec UMINUS {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_UNARYP; $2->typeCheck(TYPE_INT); $$->type = TYPE_INT; $$->addChild($2);/*一元取正*/}
| LOP_SUB expr %prec UMINUS {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_UNARYS; $2->typeCheck(TYPE_INT); $$->type = TYPE_INT; $$->addChild($2);/*一元取负*/}
| expr LOP_MULT expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                      $$->optype = OP_MULT; 
                      $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_INT;
                      $$->addChild($1); $$->addChild($3);}
| expr LOP_DIV expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_DIV;
                     $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_INT;
                     $$->addChild($1); $$->addChild($3);}
| expr LOP_MOD expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_MOD;
                     $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_INT;
                     $$->addChild($1); $$->addChild($3);}
| expr LOP_PLUS expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_PLUS;
                     $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_INT;
                     $$->addChild($1); $$->addChild($3);}
| expr LOP_SUB expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_SUB;
                     $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_INT;
                     $$->addChild($1); $$->addChild($3);}
| expr LOP_G expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                   $$->optype = OP_G;
                   $$->addChild($1); $$->addChild($3); $$->type = TYPE_BOOL;}
| expr LOP_L expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                   $$->optype = OP_L;
                   $$->addChild($1); $$->addChild($3); $$->type = TYPE_BOOL;}
| expr LOP_GEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_GEQ;
                     $$->addChild($1); $$->addChild($3); $$->type = TYPE_BOOL;}
| expr LOP_LEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_LEQ;
                     $$->addChild($1); $$->addChild($3); $$->type = TYPE_BOOL;}
| expr LOP_EQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                    $$->optype = OP_EQ;
                    $$->addChild($1); $$->addChild($3); $$->type = TYPE_BOOL;}
| expr LOP_NEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_NEQ;
                     $$->addChild($1); $$->addChild($3); $$->type = TYPE_BOOL;}
| expr LOP_PLUSEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                        $$->optype = OP_PLUSEQ;
                        $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_VOID;
                        $$->addChild($1); $$->addChild($3);}
| expr LOP_SUBEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                       $$->optype = OP_SUBEQ;
                       $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_VOID;
                       $$->addChild($1); $$->addChild($3);}
| expr LOP_MULTEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                        $$->optype = OP_MULTEQ;
                        $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_VOID;
                        $$->addChild($1); $$->addChild($3);}
| expr LOP_DIVEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                       $$->optype = OP_DIVEQ;
                       $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_VOID;
                       $$->addChild($1); $$->addChild($3);}
| expr LOP_MODEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                       $$->optype = OP_MODEQ;
                       $1->typeCheck(TYPE_INT); $3->typeCheck(TYPE_INT); $$->type = TYPE_VOID;
                       $$->addChild($1); $$->addChild($3);}
| expr LOP_AND expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_AND;
                     $1->typeCheck(TYPE_BOOL); $3->typeCheck(TYPE_BOOL); $$->type = TYPE_BOOL;
                     $$->addChild($1); $$->addChild($3);}
| expr LOP_OR expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                    $$->optype = OP_OR;
                    $1->typeCheck(TYPE_BOOL); $3->typeCheck(TYPE_BOOL); $$->type = TYPE_BOOL;
                    $$->addChild($1); $$->addChild($3);}
| IDENTIFIER LOP_ASSIGN expr {struct Symbol * symbol = progYields.ifExists($1->yield_offset, $1->var_name, NULL);
                              if (symbol != NULL) {$1->symbol_p = symbol; $1->type = symbol->type;}
                              else {cout<<$1->var_name<<" is not declared\n";exit(0);}
                              $$ = new TreeNode(lineno, NODE_EXPR); 
                              $$->optype = OP_ASSIGN;
                              $$->addChild($1); $$->addChild($3);}
;

VALUE
: IDENTIFIER {
    $$ = $1;
    struct Symbol * symbol = progYields.ifExists($$->yield_offset, $$->var_name, NULL);
    if (symbol != NULL){
        $$->symbol_p = symbol;
        $$->type = symbol->type;
    }
    else {
        /*变量未声明*/
        cout<<$1->var_name<<" is not declared\n";
        exit(0);
    }
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_VOID {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_VOID;}
| T_CONST T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT; $$->isConst = true;} 
| T_CONST T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT; $$->isConst = true;} 
| T_CONST T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT; $$->isConst = true;} 
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}

int variNotDecl(std::string varname){
    
}