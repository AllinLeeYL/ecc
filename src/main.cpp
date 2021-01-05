#include "common.h"
#include <fstream>

extern TreeNode *root;
extern struct Yields progYields;
extern FILE *yyin;
extern int yyparse();

using namespace std;
int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        FILE *fin = fopen(argv[1], "r");
        if (fin != nullptr)
        {
            yyin = fin;
        }
        else
        {
            cerr << "failed to open file: " << argv[1] << endl;
        }
    }
    yyparse();
    if(root != NULL) {
        root->genNodeId(0);
        progYields.genSymID(0);
        //root->printAST();
        //progYields.printYield();
        //progYields.printSymTable();
        Translater* t = new Translater(stdout);
        t->translate(root, &progYields);
    }
    return 0;
}