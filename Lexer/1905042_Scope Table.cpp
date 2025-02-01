#include<bits/stdc++.h>
#include "1905042_SymbolInfo.cpp"
using namespace std;

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
                delete temp1;
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
    bool Insert(string name, string type, ofstream &logout)
    {




        SymbolInfo* ob= new SymbolInfo(name,type);
        int i= (SDBMHash(name,sz))%sz;
        int j=1;
        if(bucket[i]==NULL)
        {
            bucket[i]=ob;
            //logout<<"\tInserted in ScopeTable# "<<id<<" at position "<<i+1<<", "<<j<<endl;

        }

        else
        {
            SymbolInfo* temp1= bucket[i];

            while(1)
            {

                if(temp1->getName()==name)
                {
                    logout<<"\t"<<name<<" already exisits in the current ScopeTable"<<endl;
                    return false;
                }
                else if(temp1->getNext()==NULL)
                {
                    temp1->setNext(ob);
                    //logout<<"\tInserted in ScopeTable# "<<id<<" at position "<<i+1<<", "<<j+1<<endl;
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

