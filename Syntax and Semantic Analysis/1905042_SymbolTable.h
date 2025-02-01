#include<bits/stdc++.h>
using namespace std;


class Parameter
{
    string name;
    string type; 

public:
    Parameter(string name, string type)
    {
        
        this->name = name;
        this->type = type;
    }

    string getName()
    {
        return name;
    }
    string getType()
    {
        return type;
    }
};
class SymbolInfo
{
    string name, type;
//for ParseTree
    int stl,enl;
    bool leaf;
    // for additional Info
    string dataType;        // for array, variable function(returnType), typeSpecifier(specifier);
    string additionalType="N/A";  // N/A if type is not ID else Array, Func_Dec, Func_Def,VARIABLE;
    int arrSize;    // Only for array
public:
    vector<SymbolInfo*> childList;
     vector<Parameter> parameterList;


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
        leaf=false;
        
    }
      SymbolInfo(string nm , string tp,bool lf)
    {
        name=nm;
        type=tp;
        next=NULL;
        leaf=lf;
        
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
    void setStl(int x)
    {
        stl=x;
    }
    int getStl()
    {
        return stl;
    }
    void setEnl(int x)
    {
        enl=x;
    }
    int getEnl()
    {
        return enl;
    }
    void setLeaf(bool val)
    {
        leaf=val;
    }
    bool isLeaf()
    {
        return leaf;
    }
    void setDataType(string dataType)
    {
        this->dataType=dataType;
    }
    string getDataType()
    {
        return dataType;
    }
    void setArrSize(int n)
    {
        arrSize=n;
    }
    int getArrSize()
    {
        return arrSize;
    }
    void setAdditionalType(string additional)
    {
        additionalType=additional;
    }
    string getAdditionalType()
    {
        return additionalType;
    }
    void addChild(SymbolInfo* child)
    {
        childList.push_back(child);
    }
    void addParameter(string name, string type)
    {
        Parameter p(name,type);
    }
};


class ScopeTable
{
    SymbolInfo ** bucket;
    ScopeTable* parentScope=NULL;
    int id,sz;

    unsigned long long SDBMHash(string str, unsigned long long n)
    {
        unsigned long long hash = 0;
        unsigned long long i = 0;
        unsigned long long len = str.length();

        for (i = 0; i < len; i++)
        {
            hash = (str[i]) + (hash << 6) + (hash << 16) - hash;

        }
        hash%=n;
        return hash;
    }

public:
    ScopeTable(int n, int id)
    {
        sz=n;
        bucket= new SymbolInfo* [sz];
        this->id=id;
        for(int i=0; i<n; i++) bucket[i]=NULL;
    }
    ~ScopeTable()
    {
         for(int i=0; i<sz; i++)
        {

            SymbolInfo* temp=bucket[i];
            while(temp!=NULL)
            {
               SymbolInfo* temp1=temp;
                temp=temp->getNext();
               // delete temp1;
            }

        }
        delete [] bucket;
    }

    void setParent(ScopeTable* p)
    {
        parentScope = p;
    }
    void setID(int i)
    {
        id=i;
    }
    int getId()
    {
        return id;
    }
    ScopeTable* getParent()
    {
        return parentScope;
    }
    bool Insert(SymbolInfo* ob)
    {
        int i= (SDBMHash(ob->getName(),sz))%sz;
        int j=1;
        if(bucket[i]==NULL)
        {
            bucket[i]=ob;
        }

        else
        {
            SymbolInfo* temp1= bucket[i];

            while(1)
            {

                if(temp1->getName()==ob->getName())
                {

                    return false;
                }
                else if(temp1->getNext()==NULL)
                {
                    temp1->setNext(ob);

                    break;
                }

                temp1=temp1->getNext();
                j++;

            }


        }
        return true;

    }

    SymbolInfo* lookUp(string name)
    {

        int i= SDBMHash(name,sz)%sz;


        if(bucket[i]==NULL)
        {

            return NULL;
        }


        SymbolInfo* temp=bucket[i];
        int j=1;
        while(temp!=NULL)
        {
            if(name==temp->getName())
            {
            
                return temp;
            }
            j++;
            temp=temp->getNext();
        }

        return NULL;
    }
    bool Delete(string name)
    {
        int i=SDBMHash(name,sz)%sz;
        int j=1;
        bool found = false;
        SymbolInfo*  temp=bucket[i];
        if(bucket[i]==NULL) found=false;
        else if(bucket[i]->getName()==name)
        {
            bucket[i]=bucket[i]->getNext();
            cout<<"\tDeleted '"<<name<<"' from ScopeTable# "<<id<<" at position "<<i+1<<", "<<j<<endl;
            delete temp;
            found=true;
            return true;
        }
        else
        {

            while(temp->getNext()!=NULL)
            {
                if((temp->getNext())->getName()==name)
                {
                    temp->setNext((temp->getNext())->getNext());
                    cout<<"\tDeleted '"<<name<<"' from ScopeTable# "<<id<<" at position "<<i+1<<", "<<j+1<<endl;
                    found = true;
                    if(temp->getNext()==NULL) break;
                }
                temp=temp->getNext();
                j++;
            }


        }
        if(!found)
        {
            cout<<"\tNot found in the current ScopeTable"<<endl;
            return false;
        }
    }
    void Print(ofstream &logout)
    {

        logout<<"\tScopeTable# "<<id<<endl;
        for(int i=0; i<sz; i++)
        {
            if(bucket[i]!=NULL)
            {
              logout<<"\t"<<(i+1)<<"--> ";
            SymbolInfo* temp=bucket[i];
            while(temp!=NULL)
            {
                logout<<"<"<<temp->getName()<<','<<temp->getType()<<"> ";
                temp=temp->getNext();
            }
            logout<<endl;
            }

        }
    }
    int getSize()
    {
        return sz;
    }

};


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
            //cout<<"\tScopeTable# "<<curr->getId()<<" cannot be removed"<<endl;
        }
        else
        {
            curr=curr->getParent();
       // cout<<"\tScopeTable# "<<temp->getId()<<" removed"<<endl;
        delete temp;
        }

    }

    bool Insert(SymbolInfo* symbol)
    {
        bool success=curr->Insert(symbol);
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


    SymbolInfo* lookUpCurrScope(string name)
    {
        return curr->lookUp(name);
    }
    SymbolInfo* lookUpAllScope(string name)
    {
        ScopeTable* temp=curr;
        while(temp!=NULL)
        {
            SymbolInfo* t1=temp->lookUp(name);
            if(t1!=NULL)
            return t1;
            temp=temp->getParent();
        }
        return NULL;
    }


};
