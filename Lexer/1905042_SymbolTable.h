#include<bits/stdc++.h>
#include "1905042_Scope Table.cpp"

using namespace std;
class SymbolTable{
ScopeTable *curr=NULL;
ScopeTable *parent=NULL;
int scope_id=1;
int scopeTableSize;

 void exitAll()
    {
        ScopeTable* temp=curr;
        while(temp!=NULL)
        {
            curr=curr->getParent();
           // cout<<"\tScopeTable# "<<temp->getId()<<" removed"<<endl;
            delete temp;
            temp=curr;

        }
    }
public:
    SymbolTable(int n)
    {

        scopeTableSize=n;
        curr=new ScopeTable(n,scope_id);
        //cout<<"\tScopeTable# "<<scope_id<<" created"<<endl;
        scope_id++;
    }
    ~ SymbolTable()
    {
        exitAll();
    }
    void enterScope()
    {
        ScopeTable * child= new ScopeTable(scopeTableSize,scope_id);
        child->setParent(curr);
        curr=child;
       // cout<<"\tScopeTable# "<<scope_id<<" created"<<endl;
        scope_id++;
    }
    void exitScope()
    {
        ScopeTable *temp=curr;
        if(curr->getParent()==NULL)
        {
            cout<<"\tScopeTable# "<<curr->getId()<<" cannot be removed"<<endl;
        }
        else
        {
            curr=curr->getParent();
       // cout<<"\tScopeTable# "<<temp->getId()<<" removed"<<endl;
        delete temp;
        }

    }

    bool Insert(string name, string type,ofstream &logout)
    {
        bool success=curr->Insert(name,type,logout);
        return success;
    }
    bool Remove(string name)
    {
        return curr->Delete(name);
    }
    SymbolInfo * lookUp(string name)
    {
        ScopeTable* temp = curr;
        SymbolInfo* res;

        while(temp != NULL)
        {
            res=temp->lookUp(name);
            if(res!=NULL) return res;
            temp=temp->getParent();
        }
    cout<<"\t'"<<name<<"' not found in any of the ScopeTables"<<endl;
        return NULL;
    }
    void printCurrentScope(ofstream &logout)
    {
        curr->Print(logout);
    }
    void  printAllScope(ofstream &logout)
    {
        ScopeTable* temp = curr;
        while(temp!=NULL)
        {
            temp->Print(logout);
            temp=temp->getParent();
        }
    }

};
int split (string str, char seperator);
string strings[10];


int split (string str, char seperator)
{
    int currIndex = 0, i = 0;
    int startIndex = 0, endIndex = 0;
    while (i <= str.size())
    {
        if (str[i] == seperator || i == str.size())
        {
            endIndex = i;
            string subStr = "";
            subStr.append(str, startIndex, endIndex - startIndex);
            strings[currIndex] = subStr;
            currIndex += 1;
            startIndex = endIndex + 1;
        }
        i++;
        }
        return currIndex;
}

