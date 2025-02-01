%option noyywrap
%x str
%x singleLineComment
%x multiLineComent

%{
#include<iostream>
#include<string>
#include<fstream>
#include"1905042_SymbolTable.h"

#include "y.tab.h"
using namespace std;

extern int line_count;
int localLine=0;
extern int error_count;
void yyerror(char*);  // yyerror() function for generating error message
extern YYSTYPE yylval;  
extern SymbolTable symbolTable; 
extern ofstream logout;
extern ofstream errout;

char  strToken[200005];
char strLog[200005];
char token[50];
char * s1;
char * s2;

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


"if" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "IF",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <IF> Lexeme "<<yytext<<" found\n";
	return IF;
}
"else" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "ELSE",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <ELSE> Lexeme "<<yytext<<" found\n";
	return ELSE;
}
"for" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "FOR",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <FOR> Lexeme "<<yytext<<" found\n";
	return FOR;
}
"while" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "WHILE",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <WHILE> Lexeme "<<yytext<<" found\n";
	return WHILE;
}
"do" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "DO",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <DO> Lexeme "<<yytext<<" found\n";
	return DO;
}
"int" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "INT",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <INT> Lexeme "<<yytext<<" found\n";
	return INT;
}
"char" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "CHAR",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <CHAR> Lexeme "<<yytext<<" found\n";
	return CHAR;
}
"float"	{
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "FLOAT",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <FLOAT> Lexeme "<<yytext<<" found\n";
	return FLOAT;
}
"double" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "DOUBLE",true);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <DOUBLE> Lexeme "<<yytext<<" found\n";
	return DOUBLE;
}
"void" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "VOID",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <VOID> Lexeme "<<yytext<<" found\n";
    return VOID;
}
"return" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "RETURN",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;	
	logout<<"Line# "<<line_count<<": Token <RETURN> Lexeme "<<yytext<<" found\n";
	return RETURN;
}
"switch" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "SWITCH",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <SWITCH> Lexeme "<<yytext<<" found\n";
	return SWITCH;
}
"case" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "CASE",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <CASE> Lexeme "<<yytext<<" found\n";
	return CASE;
}
"default" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "DEFAULT",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;	
	logout<<"Line# "<<line_count<<": Token <DEFAULT> Lexeme "<<yytext<<" found\n";
	return DEFAULT;
}
"continue" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "CONTINUE",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <CONTINUE> Lexeme "<<yytext<<" found\n";
	return CONTINUE;
}
"println" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "PRINTLN",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <PRINTLN> Lexeme "<<yytext<<" found\n";
    return PRINTLN;
}

("++"|"--") {
	
    SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "INCOP",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <INCOP> Lexeme "<<yytext<<" found\n";
	return INCOP;
			
		}

("+"|"-")	{

  SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "ADDOP",true);
  symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <ADDOP> Lexeme "<<yytext<<" found\n";
	return ADDOP;			
		}
        

("*"|"/"|"%") {

      SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "MULOP",true);
	  symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <MULOP> Lexeme "<<yytext<<" found\n";
	return MULOP;		
		}
("<="|">="|"=="|"!="|"<"|">") {
  SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "RELOP",true);
  symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found\n";
	return RELOP;
		}
"=" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "ASSIGNOP",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <ASSIGNOP> Lexeme "<<yytext<<" found\n";
	return ASSIGNOP;
			
		}
("&&"|"||") {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "LOGICOP",true);
  	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <LOGICOP> Lexeme "<<yytext<<" found\n";
	return LOGICOP;
}
("&"|"|"|"^"|"<<"|">>")	{
  SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "BITOP",true);
  symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <BITOP> Lexeme "<<yytext<<" found\n";
	return BITOP;	
		}
! {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "NOT",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <NOT> Lexeme "<<yytext<<" found\n";
	return NOT;

    
}
"(" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "LPAREN",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <LPAREN> Lexeme "<<yytext<<" found\n";
			return LPAREN;	
}
")" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "RPAREN",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <RPAREN> Lexeme "<<yytext<<" found\n";
			return RPAREN;
			
}
"{" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "LCURL",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <LCURL> Lexeme "<<yytext<<" found\n";
			return LCURL;

}
"}" {
			SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "RCURL",true);
			symbolInfo->setStl(line_count);
			symbolInfo->setEnl(line_count);
    		yylval = (YYSTYPE) symbolInfo;
			logout<<"Line# "<<line_count<<": Token <RCURL> Lexeme "<<yytext<<" found\n";
			return RCURL;
}

"[" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "LSQUARE",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <LSQUARE> Lexeme "<<yytext<<" found\n";			
	return LSQUARE;		

}
"]" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "RSQUARE",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <RSQUARE> Lexeme "<<yytext<<" found\n";
			return RSQUARE;
}
"," {
		SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "COMMA",true);
		symbolInfo->setStl(line_count);
		symbolInfo->setEnl(line_count);
        yylval = (YYSTYPE) symbolInfo;
		logout<<"Line# "<<line_count<<": Token <COMMA> Lexeme "<<yytext<<" found\n";
			return COMMA;
}
";" {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "SEMICOLON",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <SEMICOLON> Lexeme "<<yytext<<" found\n";
			return SEMICOLON;
			

}

{DIGIT}+ 	{

	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "CONST_INT",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <CONSTINT> Lexeme "<<yytext<<" found\n";
    return CONST_INT;
			
			}
{DIGIT}+(\.{DIGIT}+)?(E[+-]?{DIGIT}+)? {
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "CONST_FLOAT",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found\n";
return CONST_FLOAT;
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
	 SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "CONST_CHAR",true);
	 symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <CONST_CHAR> Lexeme "<<yytext<<" found\n";
				return CONST_CHAR;
	 		
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
	line_count+=localLine;
	BEGIN(INITIAL);	
}
<singleLineComment><<EOF>> {
error_count++;
*s1++=0;
line_count+=localLine;


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
	
	line_count+=localLine;
	BEGIN(INITIAL);

}
<multiLineComent><<EOF>> {
	error_count++;
	line_count+=localLine;
	*s1++=0;
	

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
		
	SymbolInfo* symbolInfo = new  SymbolInfo(yytext, "ID",true);
	symbolInfo->setStl(line_count);
	symbolInfo->setEnl(line_count);
    yylval = (YYSTYPE) symbolInfo;
	logout<<"Line# "<<line_count<<": Token <ID> Lexeme "<<yytext<<" found\n";
			return ID;
}

{WHITESPACE} {}
\'\' {
			error_count++;
			
}
({DIGIT}*\.{DIGIT}*)+[E]?(\.{DIGIT}*)+ {
	error_count++;
			
}

{DIGIT}+[E][+-]?{DIGIT}*[E\.][0-9\.E]* {
	error_count++;
	
}			
{DIGIT}+{ALPHABET}+{ALPHANUMERIC}* {
	error_count++;
	
}
\'{CHAR_LITERAL}{CHAR_LITERAL}+\' {
	error_count++;
}	

{UNFINISHED_CHAR} {
	error_count++;
	
}
. {
	error_count++;

}
%%