%{
#include<iostream>
#include<string>
#include<sstream>
#include<fstream>
#include<cstdlib>
#include<vector>

#include "1905042_SymbolTable.h"

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;

SymbolTable symbolTable(11);

int line_count = 1;
int error_count = 0;

FILE* fp;
ofstream logout;
ofstream errout;
ofstream parsetree;

vector<Parameter> parameterList;
vector<SymbolInfo*> varList;
vector<Parameter> argumentList;
void yyerror(char* s)
{
	
}
void errorOut(int errStl,string s)
{
	error_count++;
	errout<<"Line# "<<errStl<<": "<<s<<endl;
}
void generateParseTree(SymbolInfo*root,int spaceCnt)
{
	////cout<<"Called"<<endl;
	////cout<<root->getName()<<" prt "<<root->childList.size();
	for(int i=0;i<spaceCnt;i++)
	{
		parsetree<<" ";
	}
	if(root->isLeaf())
	{
		parsetree<<root->getType()+" : "+root->getName()<<"\t<Line: "<<root->getStl()<<">"<<endl;
	}
	else
	{
		parsetree<<root->getName()<<" \t<Line: "<<root->getStl()<<"-"<<root->getEnl()<<">"<<endl;
		for(SymbolInfo* child: root->childList)
		{
			generateParseTree(child,spaceCnt+1);
		}
	}
}
void addInfos(SymbolInfo* to,int stl, int enl, vector<SymbolInfo*> children)
{
	to->setStl(stl);
	to->setEnl(enl);
	to->setLeaf(false);
	string name=to->getType()+" :";
	for(SymbolInfo* child:children)
	{
		to->addChild(child);
		name+=" "+(string)child->getType();
	}
	to->setName(name);
} 
%}

%define api.value.type {SymbolInfo*}

%token CONST_INT CONST_FLOAT ID CONST_CHAR
%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN
%token ASSIGNOP NOT INCOP DECOP LOGICOP RELOP ADDOP MULOP BITOP
%token LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
start : program {
			$$ = new SymbolInfo("","start");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
            logout<<" start: program"<< endl;
			generateParseTree($$,0);
	}
	;

program : program unit {
			$$ = new SymbolInfo("","program");
			addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
}
	| unit {
		 $$ = new SymbolInfo("","program");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
	}
	;
	
unit : var_declaration {
			$$ = new SymbolInfo("","unit");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
}
     | func_declaration {
		$$=new SymbolInfo("", "unit");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		
	 }
     | func_definition {
		$$=new SymbolInfo("", "unit");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		
	 }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
			$$ = new SymbolInfo("","func_declaration");
			addInfos($$,$1->getStl(),$6->getEnl(),{$1,$2,$3,$4,$5,$6});
			SymbolInfo* temp = symbolTable.lookUpAllScope($2->getName());

			if(temp == NULL)
			{
			$2->setDataType($1->getDataType());
			$2->setAdditionalType("Func_Dec");
			$2->parameterList=parameterList;
			symbolTable.Insert($2);
			}	
			else
			{
				
				if(temp->getAdditionalType() == "FUNC_DEC")
				{
						errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");
				}
				else
				{	
					errorOut($2->getStl(),"\'"+$2->getName()+"\' redeclared as different kind of symbol");
				}
			}
			
			parameterList.clear();

}
		| type_specifier ID LPAREN RPAREN SEMICOLON {
			$$ = new SymbolInfo("","func_declaration");
			addInfos($$,$1->getStl(),$5->getEnl(),{$1,$2,$3,$4,$5});
			SymbolInfo* temp = symbolTable.lookUpAllScope($2->getName());
			if(temp == NULL)
			{
			$2->setDataType($1->getDataType());
			$2->setAdditionalType("Func_Dec");
			symbolTable.Insert($2);
			}
			else
			{
				if(temp->getAdditionalType() == "FUNC_DEC")
				{
					errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");
				
				}
				else
				{
					errorOut($2->getStl(),"\'"+$2->getName()+"\' redeclared as different kind of symbol");
				}
			}

			parameterList.clear();
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement {
		$$ = new SymbolInfo("","func_definition");
			addInfos($$,$1->getStl(),$6->getEnl(),{$1,$2,$3,$4,$5,$6});
			$2->setDataType($1->getDataType());
			SymbolInfo* temp = symbolTable.lookUpAllScope($2->getName());
			if(temp == NULL)
			{
				
			
			$2->setAdditionalType("Func_Def");
			$2->parameterList=parameterList;
			symbolTable.Insert($2);
			}
			else
			{				
				if(temp->getAdditionalType() == "Func_Dec")
				{					
					if(temp->parameterList.size() != parameterList.size()||$1->getDataType()!= temp->getDataType())
					{
						errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");
					}
					else
					{
						bool valid = true;
						
						
						for(int i=0;i<temp->parameterList.size();i++)
						{
							if(temp->parameterList[0].getType() != parameterList[i].getType())
							{
								valid = false;
							}
						}
						
						if(!valid)
						{
							errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");
						}
						else
						{
							temp->parameterList=parameterList;
							temp->setAdditionalType("Func_Def");
						}
					}
				}
				else if(temp->getAdditionalType() == "Func_Def")
				{
					errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");
				}
				else
				{
					errorOut($2->getStl(),"\'"+$2->getName()+"\' redeclared as different kind of symbol");
				}
			}
			parameterList.clear();
}
		| type_specifier ID LPAREN RPAREN compound_statement {
			$$ = new SymbolInfo("","func_definition");
			addInfos($$,$1->getStl(),$5->getEnl(),{$1,$2,$3,$4,$5});
			SymbolInfo* temp = symbolTable.lookUpAllScope($2->getName());
			$2->setDataType($1->getDataType());
			if(temp == NULL) {
				$2->setAdditionalType("Func_Def");
				symbolTable.Insert($2);
			}
				
			else
			{
				
				if(temp->getAdditionalType() == "Func_Dec")
				{
					
					if($1->getDataType() != temp->getDataType())
					{
						errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");
					}
					else
					{
						temp->setAdditionalType("Func_Dec");
					}
				}
				else if(temp->getAdditionalType() == "Func_Def")
				{
					errorOut($2->getStl(),"Conflicting types for \'"+$2->getName()+"\'");	
				}
				else
				{
					errorOut($2->getStl(),"\'"+$2->getName()+"\' redeclared as different kind of symbol");
				}
			}
			parameterList.clear();
			//cout<<$2->getName()<<" line 75"<<endl;
		}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID {

			$$ = new SymbolInfo("","parameter_list");
			addInfos($$,$1->getStl(),$4->getEnl(),{$1,$2,$3,$4});

			Parameter param($4->getName(),$3->getDataType());
			bool exists=false;
			for(int i=0;i<parameterList.size();i++)
			{
				if(parameterList[i].getName() == param.getName())
				{
						exists=true;
				errorOut($4->getStl(),"Redefinition of parameter \'"+parameterList[i].getName()+"\'");
				}
			}
			if(!exists)
			parameterList.push_back(param);
}
		| parameter_list COMMA type_specifier {
			$$ = new SymbolInfo("","parameter_list");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
			Parameter param("",$3->getDataType());
			parameterList.push_back(param);
		}
 		| type_specifier ID {

			$$ = new SymbolInfo("","parameter_list");
			addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
			Parameter param ($2->getName(),$1->getDataType());
			bool exists=false;
			for(int i=0;i<parameterList.size();i++)
			{
				if(parameterList[i].getName() == param.getName())
				{
						exists=true;
						errorOut($2->getStl(),"Redefinition of parameter \'"+parameterList[i].getName()+"\'");
				}
			}
			if(!exists)
			parameterList.push_back(param);
			
		}
		| type_specifier {
			$$ = new SymbolInfo("","parameter_list");
			$$->addChild($1);
			Parameter param("",$1->getDataType());
			parameterList.push_back(param);
		}
 		;

 		
compound_statement : LCURL enter_scope statements RCURL {
			$$ = new SymbolInfo("","compound_statement");
			addInfos($$,$1->getStl(),$4->getEnl(),{$1,$3,$4});
			
				symbolTable.printAllScope(logout);
				symbolTable.exitScope();
}
 		    | LCURL enter_scope RCURL {
			$$ = new SymbolInfo("","compound_statement");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$3});

			}
 		    ;
enter_scope : {
	symbolTable.enterScope();
			for(int i=0;i<parameterList.size();i++)
			{
				SymbolInfo* temp = new SymbolInfo(parameterList[i].getName(),"ID");
				temp->setAdditionalType("VARIABLE");
				temp->setDataType(parameterList[i].getType());
				symbolTable.Insert(temp);
			}
}	    
var_declaration : type_specifier declaration_list SEMICOLON {

	$$ = new SymbolInfo("", "var_declaration");
	addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
	string dType=$1->getDataType();
		if(dType=="VOID")
		{
			for(SymbolInfo* var:varList)
			{
				errorOut(var->getStl(),"Variable or field \'"+var->getName()+"\' declared void");
			}
			
		}
		else
		{
			for(int i=0; i<varList.size(); i++) {
                    varList[i]->setDataType(dType);
					SymbolInfo *temp = symbolTable.lookUpCurrScope(varList[i]->getName());	
					if(temp!=NULL)
					{
					if(temp->getAdditionalType() == "VARIABLE" || temp->getAdditionalType() == "ARRAY")
					{
						errorOut(varList[i]->getStl(),"Conflicting types for\'"+varList[i]->getName()+"\'");
					}
					else
					{
						errorOut(varList[i]->getStl(),"\'"+varList[i]->getName()+"\' redeclared as different kind of symbol");
						
					}
					}
					else
					{
						symbolTable.Insert(varList[i]);
					}
                }
		}
		varList.clear();
}
 		 ;
 		 
type_specifier	: INT {
	$$ = new SymbolInfo("", "type_specifier");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType("INT");
}
 		| FLOAT {
			$$ = new SymbolInfo("","type_specifier");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType("FLOAT");
		}
 		| VOID {
			$$ = new SymbolInfo("","type_specifier");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType("VOID");		
		}
 		;
 		
declaration_list : declaration_list COMMA ID {
				$$ = new SymbolInfo("","declaration_list");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
			$3->setAdditionalType("VARIABLE");
			varList.push_back($3);
			
}
 		  | declaration_list COMMA ID LSQUARE CONST_INT RSQUARE {
				$$ = new SymbolInfo("","declaration_list");
			addInfos($$,$1->getStl(),$6->getEnl(),{$1,$2,$3,$4,$5,$6});
			$3->setAdditionalType("ARRAY");
			$3->setArrSize(stoi($5->getName()));
			varList.push_back($3);
			
		  }
 		  | ID {
			$$ = new SymbolInfo("","declaration_list");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$1->setAdditionalType("VARIABLE");
			varList.push_back($1);
			$$->setAdditionalType("VARIABLE");
		  }
 		  | ID LSQUARE CONST_INT RSQUARE {
			$$ = new SymbolInfo("","declaration_list");
			addInfos($$,$1->getStl(),$4->getEnl(),{$1,$2,$3,$4});
			$1->setAdditionalType("ARRAY");
			$1->setArrSize(stoi($3->getName()));
			varList.push_back($1);
		  }
 		  ;
 		  
statements : statement {
	$$ = new SymbolInfo("","statements");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			
}
	   | statements statement {
		$$ = new SymbolInfo("","statements");
			addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
	   }
	   ;
	   
statement : var_declaration {
	$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
}
	  | expression_statement {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
	  }
	  | compound_statement {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			logout<<"statement : compound_statement"<<endl;
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$7->getEnl(),{$1,$2,$3,$4,$5,$6,$7});
			logout<<"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement"<<endl;
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$5->getEnl(),{$1,$2,$3,$4,$5});
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$7->getEnl(),{$1,$2,$3,$4,$5,$6,$7});
	  }
	  | WHILE LPAREN expression RPAREN statement {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$5->getEnl(),{$1,$2,$3,$4,$5});
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$5->getEnl(),{$1,$2,$3,$4,$5});
	  }
	  | RETURN expression SEMICOLON {
		$$ = new SymbolInfo("","statement");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
	  }
	  ;
	  
expression_statement 	: SEMICOLON {
	$$ = new SymbolInfo("","expression_statement");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
}		
			| expression SEMICOLON {
				$$ = new SymbolInfo("","expression_statement");
			addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
			$$->setDataType($1->getDataType());
			}
			;
	  
variable : ID {
	$$ = new SymbolInfo("","variable");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
	
	SymbolInfo* temp = symbolTable.lookUpAllScope($1->getName());

		if(temp == NULL)
		{
			errorOut($1->getStl(),"Undeclared variable \'"+$1->getName()+"\'");
		}
		else
		{
			$$->setDataType(temp->getDataType());
			$$->setAdditionalType($1->getName());	//AdditionalType is variable name here. ex: a=2; here a 
			
		}
}	
	 | ID LSQUARE expression RSQUARE {
		$$ = new SymbolInfo("","variable");
			addInfos($$,$1->getStl(),$4->getEnl(),{$1,$2,$3,$4});
			if($3->getDataType() == "FLOAT")
		{
			errorOut($1->getStl(),"Array subscript is not an integer");
		}
		SymbolInfo* temp = symbolTable.lookUpAllScope($1->getName());

		if(temp == NULL)
		{
			errorOut($1->getStl(),"Undeclared variable \'"+$1->getName()+"\'");
		}
		else if(temp->getAdditionalType() != "ARRAY")
		{
			errorOut($1->getStl(),"\'"+$1->getName()+"\' is not an array");
			
		}
		else
		{
			$$->setDataType(temp->getDataType());
		}
		
	 }
	 ;
	 
expression : logic_expression {
		$$ = new SymbolInfo("","expression");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType($1->getDataType());
}
	   | variable ASSIGNOP logic_expression {
		//cout<<"548: variable ASSIGNOP logic_expression "<<endl;
		$$ = new SymbolInfo("","expression");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
			$$->setDataType($1->getDataType());
			if($3->getDataType()=="VOID")
			{
				errorOut($$->getStl(),"Void cannot be used in expression ");
			}
			if($1->getDataType()=="INT")
			{
				if($3->getDataType()=="FLOAT")
				errorOut($1->getStl(),"Warning: possible loss of data in assignment of FLOAT to INT");
			}
			else if($1->getDataType()=="VOID")
			{
				errorOut($1->getStl(),"Void cannot be used in expression ");
			}
	   }
	   ;
			
logic_expression : rel_expression {
			$$ = new SymbolInfo("","logic_expression");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType($1->getDataType());

}
		 | rel_expression LOGICOP rel_expression {
			$$ = new SymbolInfo("","logic_expression");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
			if($1->getDataType()=="VOID")
			{
				errorOut($$->getStl(),"Void cannot be used in expression ");
			}
			if($3->getDataType()=="VOID")
			{
				errorOut($$->getStl(),"Void cannot be used in expression ");
			}
			//$$->setDataType();///work here///
		 }	
		 ;
			
rel_expression	: simple_expression {
			$$ = new SymbolInfo("","rel_expression");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType($1->getDataType());
}
		| simple_expression RELOP simple_expression	{
			$$ = new SymbolInfo("","rel_expression");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
			if($1->getDataType()=="VOID")
			{
				errorOut($$->getStl(),"Void cannot be used in expression ");
			}
			if($3->getDataType()=="VOID")
			{
				errorOut($$->getStl(),"Void cannot be used in expression ");
			}
			//$$->setDataType();//Work
		}
		;
				
simple_expression : term {
		$$ = new SymbolInfo("","simple_expression");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		$$->setDataType($1->getDataType());
}
		  | simple_expression ADDOP term {
			$$ = new SymbolInfo("","simple_expression");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
			if($1->getDataType()=="VOID")
			{
				errorOut($1->getStl(),"Void cannot be used in expression ");
				$$->setDataType("FLOAT");
			}
			if($3->getDataType()=="VOID")
			{
				errorOut($1->getStl(),"Void cannot be used in expression ");
				$$->setDataType("FLOAT");
			}
			if(($1->getDataType() == "FLOAT" || $3->getDataType() == "FLOAT")) {
                $$->setDataType("FLOAT");
            }
			else
			{
				$$->setDataType($1->getDataType());
			}
		  }
		  ;
					
term :	unary_expression {
			$$ = new SymbolInfo("","term");
			addInfos($$,$1->getStl(),$1->getEnl(),{$1});
			$$->setDataType($1->getDataType());

}
     |  term MULOP unary_expression {
			$$ = new SymbolInfo("","term");
			addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});

			if($1->getDataType()=="VOID")
			{
				errorOut($1->getStl(),"Void cannot be used in expression ");
				$$->setDataType("FLOAT");
			}
			if($3->getDataType()=="VOID")
			{
				errorOut($1->getStl(),"Void cannot be used in expression ");
				$$->setDataType("FLOAT");
			}
			if(($2->getName() == "%") && ($1->getDataType() != "INT" || $3->getDataType() != "INT")) {
                errorOut($$->getStl(),"Operands of modulus must be integers ");
                $$->setDataType("INT");
            }
			else if(($2->getName() != "%") && ($1->getDataType() == "FLOAT" || $3->getDataType() == "FLOAT")) {
                $$->setDataType("FLOAT");
            }
			else
			{
				$$->setDataType($1->getDataType());
			}
			if(($2->getName()=="/"||$2->getName()=="%")&&($3->getAdditionalType()=="0"||$3->getAdditionalType()=="0.0"))
			{
				errorOut($$->getStl(),"Warning: division by zero i=0f=1Const=0");
			}

	 }
     ;

unary_expression : ADDOP unary_expression {
		$$ = new SymbolInfo("","unary_expression");
		addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
		if($2->getDataType()=="VOID")
		{
			errorOut($$->getStl(),"Void cannot be used in expression ");
			$$->setDataType("FLOAT");
		}
		else
		{
			$$->setDataType($2->getDataType());
		}
}
		 | NOT unary_expression {
				$$ = new SymbolInfo("","unary_expression");
				addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
		        if($2->getDataType() == "VOID") {
                errorOut($$->getStl(),"Void cannot be used in expression ");
            }
            $$->setDataType("INT");
		 }
		 | factor {
			$$ = new SymbolInfo("","unary_expression");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		 $$->setDataType($1->getDataType());
		 $$->setAdditionalType($1->getAdditionalType());

		 }
		 ;
	
factor	: variable {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		$$->setDataType($1->getDataType());
}
	| ID LPAREN argument_list RPAREN {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$4->getEnl(),{$1,$2,$3,$4});
				SymbolInfo *temp = symbolTable.lookUpAllScope($1->getName());
		if(temp == NULL)
		{
			errorOut($1->getStl(),"Undeclared function \'"+$1->getName()+"\'");
			$$->setDataType("UNDEFINED");
		}
		else
		{
			$$->setDataType(temp->getDataType());
			
			if(temp->parameterList.size() > argumentList.size())
			{
				errorOut($1->getStl(),"Too few arguments to function \'"+temp->getName()+"\'");
			}
			else if(temp->parameterList.size() < argumentList.size())
			{
				//cout<<$1->getStl()<<" :"<<$1->getName()<<" :"<<temp->parameterList.size() <<" 708 "<<argumentList.size()<<endl;
				errorOut($1->getStl(),"Too many arguments to function \'"+temp->getName()+"\'");
			}
			else
			{	//cout<<"parameter vs argument type "<<temp->parameterList.size()<<endl;
				for(int i=0;i<temp->parameterList.size();i++)
				{
					//cout<<parameterList[i].getType()<<"   "<< argumentList[i].getType()<<endl;
					if(temp->parameterList[i].getType() != argumentList[i].getType())
					{
						
						errorOut($1->getStl(),"Type mismatch for argument "+to_string(i+1)+" of \'"+temp->getName()+"\'");
					}
				}
			}
			
		}
		argumentList.clear();

	}
	| LPAREN expression RPAREN {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});
		$$->setDataType($2->getDataType());
	}
	| CONST_INT {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		$$->setDataType("INT");
		$$->setAdditionalType($1->getName());
	} 
	| CONST_FLOAT {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		$$->setDataType("FLOAT");
		$$->setAdditionalType($1->getName());
		//cout<<$1->getStl()<<" - 740: const_float->factor :"<<$$->getDataType()<<endl;
	}
	| variable INCOP {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$2->getEnl(),{$1,$2});
		$$->setDataType($1->getDataType());
		if($1->getDataType()=="VOID")
		{
			 errorOut($$->getStl(),"Void cannot be used in expression ");
		}
		else if($1->getDataType()!="INT")
		{
			if($2->getName()=="++")
			 errorOut($$->getStl(),"Operands of Increment must be integer");
			 else if($2->getName()=="--")
			 {
				errorOut($$->getStl(),"Operands of Decrement must be integer");
			 }
		}

		
	} 
	| variable DECOP {
		$$ = new SymbolInfo("","factor");
		addInfos($$,$1->getStl(),$2->getEnl(),{$2});
		$$->setDataType($1->getDataType());
		
	}
	;
	
argument_list : arguments {
		$$ = new SymbolInfo("","argument_list");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		$$->setDataType($1->getDataType());
}
			  | {
				$$ = new SymbolInfo("","argument_list");
				addInfos($$,line_count,line_count,{});
			  }
			  ;
	
arguments : arguments COMMA logic_expression {
		$$ = new SymbolInfo("","arguments");
		addInfos($$,$1->getStl(),$3->getEnl(),{$1,$2,$3});

		argumentList.push_back(Parameter("",$3->getDataType()));
}
	      | logic_expression {
			$$ = new SymbolInfo("","arguments");
		addInfos($$,$1->getStl(),$1->getEnl(),{$1});
		argumentList.push_back(Parameter("",$1->getDataType()));
		  }
	      ;
 

%%
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	logout.open("log.txt");
	errout.open("error.txt");
	parsetree.open("parsetree.txt");

	//symbolTable.enterScope(1, 7, logout);

	yyin=fp;
	yyparse();
	

	fclose(fp);
	logout.close();
	errout.close();
	parsetree.close();
	
	return 0;
}
