#ifndef _BOBLI_TRANSLATER_H
#define _BOBLI_TRANSLATER_H

#include <stdlib.h>
#include <stdio.h>
#include "tree.h"

class Translater{
public:
    int labelID;
    int stack_p;
    FILE* fp;
    Type* type;
    Translater(FILE*);
    ~Translater();
    void genDATA(TreeNode*);
    void genBSS(struct Yields*);
    void genTEXT(TreeNode*, struct Yields*);
    void genFunc(TreeNode*, struct Yields*);

    void genExprs(TreeNode*, struct Yields*);
    void genExpr(TreeNode*, struct Yields*);
    void genExpr_ASSIGN(TreeNode*, struct Yields*); // 赋值表达式率先计算右孩子
    void genExpr_LR(TreeNode*, struct Yields*); // 表达式左右孩子都需要率先计算
    void genExpr_UNARY(TreeNode*, struct Yields*); // 右孩子需要计算
    void genSTMT(TreeNode*, struct Yields*);
    void genTEXT_TRVSIB(TreeNode*, struct Yields*); // 遍历节点的所有兄弟，用于语句
public:
    void translate(TreeNode*, struct Yields*);
};

#endif