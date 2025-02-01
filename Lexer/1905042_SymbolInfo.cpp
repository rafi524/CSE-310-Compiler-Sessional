#include<bits/stdc++.h>
using namespace std;
class SymbolInfo
{
    string name, type;


public:
     SymbolInfo * next;
    SymbolInfo()
    {
        next=NULL;
    }
    SymbolInfo(string nm , string tp)
    {
        name=nm;
        type=tp;
        next=NULL;
    }
    string getName()
    {
        return name;
    }
    string getType()
    {
        return type;
    }
    SymbolInfo* getNext()
    {
        return next;
    }
    void setName(string nm)
    {
        name=nm;
    }
    void setType(string tp)
    {
        type=tp;
    }
    void setNext(SymbolInfo* ob)
    {
        next=ob;
    }
};
