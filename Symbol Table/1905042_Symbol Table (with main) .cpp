#include<bits/stdc++.h>
#include "1905042_Scope Table.cpp"

using namespace std;
class SymbolTable{
ScopeTable *curr=NULL;
ScopeTable *parent=NULL;
int scope_id=1;

 void exitAll()
    {
        ScopeTable* temp=curr;
        while(temp!=NULL)
        {
            curr=curr->getParent();
            cout<<"\tScopeTable# "<<temp->getId()<<" removed"<<endl;
            delete temp;
            temp=curr;

        }
    }
public:
    SymbolTable(int n)
    {

        curr=new ScopeTable(n,scope_id);
        cout<<"\tScopeTable# "<<scope_id<<" created"<<endl;
        scope_id++;
    }
    ~ SymbolTable()
    {
        exitAll();
    }
    void enterScope(int sz)
    {
        ScopeTable * child= new ScopeTable(sz,scope_id);
        child->setParent(curr);
        curr=child;
        cout<<"\tScopeTable# "<<scope_id<<" created"<<endl;
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
        cout<<"\tScopeTable# "<<temp->getId()<<" removed"<<endl;
        delete temp;
        }

    }

    bool Insert(string name, string type)
    {
        bool success=curr->Insert(name,type);
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
    void printCurrentScope()
    {
        curr->Print();
    }
    void  printAllScope()
    {
        ScopeTable* temp = curr;
        while(temp!=NULL)
        {
            temp->Print();
            temp=temp->getParent();
        }
    }

};
int split (string str, char seperator);
string strings[10];
int main()
{
int n;


   freopen ("sample_input.txt","r",stdin);
   freopen ("sample_output.txt","w",stdout);
   string s;
   getline(cin,s);
   n=stoi(s);
   SymbolTable table1 (n);

   getline(cin,s);

   int sz=split(s,' ');


   int cmd=1;
   while(1)
   {

       char ch= strings[0][0];
       cout<<"Cmd "<<cmd<<": "<<s<<endl;
       cmd++;
        switch(ch)
        {
        case 'I':
            {

                if(sz!=3)
                    cout<<"\tNumber of parameters mismatch for the command I"<<endl;
                    else
                table1.Insert(strings[1],strings[2]);
                break;
            }
        case 'L':
            {
                if(sz!=2)
                    cout<<"\tNumber of parameters mismatch for the command L"<<endl;
                else
                    table1.lookUp(strings[1]);
                break;
            }
        case 'P':
            {
                if(sz!=2)
                    cout<<"\tNumber of parameters mismatch for the command P"<<endl;
                else if(strings[1]=="C")
                    table1.printCurrentScope();
                else if(strings[1]=="A")
                    table1.printAllScope();
                    break;
            }
        case 'D':
            {
                if(sz!=2)
                    cout<<"\tNumber of parameters mismatch for the command D"<<endl;
                else
                {
                    table1.Remove(strings[1]);
                }
                break;
            }
        case 'S':
            {
                if(sz!=1)
                    cout<<"\tNumber of parameters mismatch for the command S"<<endl;
                else
                {
                   table1.enterScope(n);

                }
                break;
            }
        case 'E':
            {
                if(sz!=1)
                    cout<<"\tNumber of parameters mismatch for the command E"<<endl;
                else
                {
                    table1.exitScope();
                }
                break;
            }
        case 'Q':
            {
                if(sz!=1)
                    cout<<"\tNumber of parameters mismatch for the command Q"<<endl;
                else
                {

                    break;
                }
            }


        }
         if(ch=='Q') break;
    getline(cin,s);
    sz=split(s,' ');

   }

}

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
