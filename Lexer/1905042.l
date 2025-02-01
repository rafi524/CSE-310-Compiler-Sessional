%option noyywrap
%x str
%x singleLineComment
%x multiLineComent

%{

#include<cstdio>
#include<cstdlib>
#include<bits//stdc++.h>
#include"1905042_SymbolTable.h"


using namespace std;

void toUpper(char* s)
{
    int i=0;
    while(s[i]!='\0')
    {
        if(s[i]>=97&&s[i]<=122)
            s[i]-=32;

            i++;
    }

}
int line_count=1;
int localLine=0;
int error_count=0;
char  strToken[200005];
char strLog[200005];
char token[50];
char * s1;
char * s2;


ofstream logout;
ofstream tokenout;

SymbolTable symbolTable(10);

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
ALPHABET {LETTER}|_
ALPHANUMERIC {ALPHABET}|{DIGIT}
ID {ALPHABET}({ALPHANUMERIC})*
CHAR_LITERAL ((\\n)|(\\t)|(\\a)|(\\f)|(\\r)|(\\b)|(\\v)|(\\0)|(\\)|(\\\\)|(\\\')|(\\\")|{ALPHANUMERIC})
UNFINISHED_CHAR \'{CHAR_LITERAL}+

%%

{NEWLINE} {line_count++;}

("if"|"else"|"for"|"while"|"do"|"break"|"int"|"char"|"float"|"double"|"void"|"return"|"switch"|"case"|"default"|"continue")	{
            char Token[20];
            strcpy(Token,yytext);
           toUpper(Token);
            
			tokenout<<"<"<<Token<<", "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <"<<Token<<"> Lexeme "<<yytext<<" found\n";
		}
("++"|"--") {
			tokenout<<"<INCOP, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <INCOP> Lexeme "<<yytext<<" found\n";
			
			
		}

("+"|"-")	{
			tokenout<<"<ADDOP, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <ADDOP> Lexeme "<<yytext<<" found\n";	
		}
        

("*"|"/"|"%") {
			tokenout<<"<MULOP, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <MULOP> Lexeme "<<yytext<<" found\n";
		}
("<="|">="|"=="|"!="|"<"|">") {
	tokenout<<"<RELOP, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found\n";
		}
"=" {
			tokenout<<"<ASSIGNOP, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <ASSIGNOP> Lexeme "<<yytext<<" found\n";
		}
("&"|"|"|"^"|"<<"|">>")	{
			tokenout<<"<BITOP, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <BITOP> Lexeme "<<yytext<<" found\n";

		}
! {
	tokenout<<"<NOT, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <NOT> Lexeme "<<yytext<<" found\n";

    
}
"(" {
			tokenout<<"<LPAREN, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <LPAREN> Lexeme "<<yytext<<" found\n";
}
")" {
			tokenout<<"<RPAREN, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <RPAREN> Lexeme "<<yytext<<" found\n";
}
"{" {
			symbolTable.enterScope();
			tokenout<<"<LCURL, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <LCURL> Lexeme "<<yytext<<" found\n";

}
"}" {
			tokenout<<"<RCURL, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <RCURL> Lexeme "<<yytext<<" found\n";
			symbolTable.exitScope();
}

"[" {
			tokenout<<"<LSQUARE, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <LSQUARE> Lexeme "<<yytext<<" found\n";

}
"]" {
			tokenout<<"<RSQUARE, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <RSQUARE> Lexeme "<<yytext<<" found\n";


}
"," {
			tokenout<<"<COMMA, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <COMMA> Lexeme "<<yytext<<" found\n";
}
";" {
			tokenout<<"<SEMICOLON, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <SEMICOLON> Lexeme "<<yytext<<" found\n";

}

{DIGIT}+ 	{
			tokenout<<"<CONST_INT, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <CONST_INT> Lexeme "<<yytext<<" found\n";
			}
{DIGIT}+(\.{DIGIT}+)?(E[+-]?{DIGIT}+)? {
			tokenout<<"<CONST_FLOAT, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found\n";

}

\'{CHAR_LITERAL}\' {
	
	char ch=yytext[2];
	char c=yytext[1];
	if(yytext[1]=='\'')
	{
		c='e';
	
	}
	
	if(yytext[1]=='\\'){
		switch(ch) {
		case'n':{
			c='\n';
			break;
			}
		case't':{
			c='\t';
			break;
			}
			case'a':{
			c='\a';
			break;
			}
			case 'f':{
			c='\f';
			break;
			}
			case 'r':{
			c='\r';
			break;
			}
			case 'b':{
			c='\b';
			break;
			}
			case '0':{
			c='\0';
			break;
			}
			case 'v':{
			c='\v';
			break;
			}
			case '\'':{
			c='\'';
			break;
			}
			case '\"':{
			c='\"';
			break;
			}
			case '\\':{
			c='\\';
			break;
			}
			
	}
	}
	 
	 			tokenout<<"<CONST_CHAR, "<<c<<">\n";
			logout<<"Line# "<<line_count<<": Token <CONST_CHAR> Lexeme "<<c<<" found\n";
}

\" {
	BEGIN(str);
	s1=strToken;
	s2=strLog;
	*s2++='\"';
	localLine=0;
	strcpy(token,"SINGLE LINE STRING");
}
<str>\" {
	
	*s2++='\"';
	*s1++=0;
	*s2++=0;
			tokenout<<"<"<<token<<", "<<strToken<<">\n";
			logout<<"Line# "<<line_count<<": Token <"<<token<<"> Lexeme "<<strLog<<" found\n";
	
	line_count+=localLine;
	BEGIN(INITIAL);
}
<str>\\\r\n {
	*s2++='\\';
	*s2++='\r';
	*s2++='\n';
	localLine++;
	strcpy(token,"MULTI LINE STRING");
}
<str>\\\n {
	*s2++='\\';
	*s2++='\n';
	localLine++;
	strcpy(token,"MULTI LINE STRING");
}
<str>[\r]?\n {
	error_count++;
	*s1++=0;
	*s2++=0;
	
	line_count+=localLine;
	logout<<"Error at line# "<<line_count<<": UNFINISHED_STRING "<<strLog<<"\n",line_count,strLog;
	localLine++;
	line_count++;
    BEGIN (INITIAL);
}
<str>\\n {

	*s1++='\n';
	*s2++='\\';
	*s2++='n';
}
<str>\\t {
	*s1++='\t';
	*s2++='\\';
	*s2++='t';
}
<str>\\a {
	*s1++='\a';
	*s2++='\\';
	*s2++='a';
}
<str>\\f {
	*s1++='\f';
	*s2++='\\';
	*s2++='f';
}
<str>\\r {
	*s1++='\r';
	*s2++='\\';
	*s2++='r';
}
<str>\\b {
	*s1++='\b';
	*s2++='\\';
	*s2++='b';
}
<str>\\0 {
	*s1++='\0';
	*s2++='\\';
	*s2++='0';
}
<str>\\\\ {
	*s1++='\\';
	*s2++='\\';
	*s2++='\\';
}
<str>\\\' {
	*s1++='\'';
	*s2++='\\';
	*s2++='\'';
}
<str>\\\" {
	*s1++='\"';
	*s2++='\\';
	*s2++='\"';
}
<str>. {
	*s1++=yytext[0];
	*s2++=yytext[0];
}
<str><<EOF>> {
	error_count++;
	*s1++=0;
	*s2++=0;
	line_count+=localLine;
	logout<<"Error at line# "<<line_count<<": UNFINISHED_STRING "<<strLog<<"\n";
	
    BEGIN (INITIAL);
}
\/\/ {
	s1=strLog;
	*s1++='/';
	*s1++='/';
	localLine=0;
	BEGIN(singleLineComment);
}
<singleLineComment>\\\r\n {

	*s1++='\\';
	*s1++='\r';
	*s1++='\n';
	localLine++;
}
<singleLineComment>\\\n {
	*s1++='\\';
	*s1++='\n';
	localLine++;
}
<singleLineComment>[\r]?\n {
	
	*s1++=0;
	localLine++;
	logout<<"Line# "<<line_count<<": Token <SINGLE LINE COMMENT> Lexeme "<<strLog<<" found\n";
	line_count+=localLine;
	BEGIN(INITIAL);	
}
<singleLineComment><<EOF>> {
error_count++;
*s1++=0;
line_count+=localLine;
logout<<"Error at line# "<<line_count<<": UNFINISHED COMMENT "<<strLog<<"\n";

BEGIN(INITIAL);
}

<singleLineComment>. {
	*s1++=yytext[0];
	
}
\/\* {
	s1=strLog;
	*s1++='/';
	*s1++='*';
	localLine=0;
	BEGIN(multiLineComent);
}
<multiLineComent>\*\/ {
	*s1++='*';
	*s1++='/';
	*s1++=0;
	logout<<"Line# "<<line_count<<": Token <MULTI LINE COMMENT> Lexeme "<<strLog<<" found\n";
	line_count+=localLine;
	BEGIN(INITIAL);

}
<multiLineComent><<EOF>> {
	error_count++;
	line_count+=localLine;
	*s1++=0;
	logout<<"Error at line# "<<line_count<<": UNFINISHED_COMMENT "<<strLog<<"\n";

BEGIN(INITIAL);
}
<multiLineComent>[\r]?\n {
	*s1++='\n';
	localLine++;
}

<multiLineComent>. {
	*s1++=yytext[0];
}
{ID} {
			tokenout<<"<ID, "<<yytext<<">\n";
			logout<<"Line# "<<line_count<<": Token <ID> Lexeme "<<yytext<<" found\n";
			bool success=symbolTable.Insert(yytext,"ID",logout);
			if(success)
			symbolTable.printAllScope(logout);
				
}

{WHITESPACE} {}
\'\' {
			error_count++;
			logout<<"Error at line# "<<line_count<<": EMPTY_CHAR_CONST  "<<yytext<<endl;
}
({DIGIT}*\.{DIGIT}*)+[E]?(\.{DIGIT}*)+ {
	error_count++;
			logout<<"Error at line# "<<line_count<<": TOO_MANY_DECIMAL_POINTS "<<yytext<<endl;
}

{DIGIT}+[E][+-]?{DIGIT}*[E\.][0-9\.E]* {
	error_count++;
	logout<<"Error at line# "<<line_count<<": ILLFORMED_NUMBER "<<yytext<<endl;
}			
{DIGIT}+{ALPHABET}+{ALPHANUMERIC}* {
	error_count++;
	logout<<"Error at line# "<<line_count<<": INVALID_ID_SUFFIX_NUM_PREFIX "<<yytext<<endl;
}
\'{CHAR_LITERAL}{CHAR_LITERAL}+\' {
	error_count++;
	logout<<"Error at line# "<<line_count<<": MULTICHAR_CONST_CHAR "<<yytext<<endl;
}

{UNFINISHED_CHAR} {
	error_count++;
	logout<<"Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<yytext<<endl;
}
. {
	error_count++;
	logout<<"Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<yytext<<endl;
}
%%
int main(int argc, char** argv) {
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
tokenout.open("token.txt");
	logout.open("log.txt");
	yyin= fin;
	yylex();
	symbolTable.printAllScope(logout);
	logout<<"Total lines: "<<line_count<<endl;	
	logout<<"Total errors: "<<error_count<<endl;
	fclose(yyin);
	logout.close();
	tokenout.close();
	return 0;
}
