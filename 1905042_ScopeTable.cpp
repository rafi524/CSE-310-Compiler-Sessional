#include<bits/stdc++.h>
#include "1905042_SymbolInfo.cpp"
using namespace std;

class ScopeTable
{
    SymbolInfo ** bucket;
    ScopeTable* parentScope=NULL;
    int id,sz;

    unsigned int SDBMHash(string str)
    {
        unsigned int hash = 0;
        unsigned int i = 0;
        unsigned int len = str.length();

        for (i = 0; i < len; i++)
        {
            hash = (str[i]) + (hash << 6) + (hash << 16) - hash;
            hash=hash%7;
        }

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
    bool Insert(string name, string type)
    {




        SymbolInfo* ob= new SymbolInfo(name,type);
        int i= (SDBMHash(name))%sz;
        int j=1;
        if(bucket[i]==NULL)
        {
            bucket[i]=ob;
            cout<<"\tInserted in ScopeTable# "<<id<<" at position "<<i+1<<", "<<j<<endl;

        }

        else
        {
            SymbolInfo* temp1= bucket[i];

            while(1)
            {

                if(temp1->getName()==name)
                {
                    cout<<"\t'"<<name<<"' already exists in the current ScopeTable"<<endl;
                    return false;
                }
                else if(temp1->getNext()==NULL)
                {
                    temp1->setNext(ob);
                    cout<<"\tInserted in ScopeTable# "<<id<<" at position "<<i+1<<", "<<j+1<<endl;
                    break;
                }

                temp1=temp1->getNext();
                j++;

            }

            return true;
        }

    }

    SymbolInfo* lookUp(string name)
    {

        int i= SDBMHash(name)%sz;


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
                cout<<"\t'"<<name<<"' found in ScopeTable# "<<id<<" at position "<<i+1<<", "<<j<<endl;
                return temp;
            }
            j++;
            temp=temp->getNext();
        }

        return NULL;
    }
    bool Delete(string name)
    {
        int i=SDBMHash(name)%sz;
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
                    cout<<"\tDeleted '"<<name<<"' from ScopeTable# "<<id<<" at position "<<i<<", "<<j<<endl;
                    found = true;
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
    void Print()
    {

        cout<<"\tScopeTable# "<<id<<endl;
        for(int i=0; i<sz; i++)
        {
            cout<<"\t"<<(i+1)<<"--> ";
            SymbolInfo* temp=bucket[i];
            while(temp!=NULL)
            {
                cout<<"<"<<temp->getName()<<','<<temp->getType()<<"> ";
                temp=temp->getNext();
            }
            cout<<endl;
        }
    }
    int getSize()
    {
        return sz;
    }

};

