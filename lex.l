%{
	#include "par.tab.h"
%}
delim	[ \t\n\r]
ws	[delim]+
letter	[A-za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+
type	[:][i][n][t][e][g][e][r]|[:][b][o][o][l]|[:][c][h][a][r]
idgroup ({id},)*{id}
annotation "/*"(.)*"*/"

%%
begin	{ return( BEGINO );}
end	{ return( END ); }
program { return( PROGRAM ); }
if	{ return( IF ); }
else	{ return( ELSE ); }
then	{ return( THEN ); }
repeat	{ return( REPEAT ); }
until	{ return( UNTIL ); }
while	{ return( WHILE ); }
do	{ return( DO ); }
and	{ return( AND ); }
or	{ return( OR ); }
not	{ return( NOT ); }
annotation { return( ANNOTATION ); }
var	{ return( VAR ); }
true { return( TRUEO );}
false { return (FALSEO);}
"(" { return (LBRACKET);}
")" { return (RBRACKET);}
"+"    { return( '+' ); }
"-"    { return( '-' ); }
"*"    { return( '*' ); }
"/"    { return( '/' ); }
":="    { filloperator(&yylval, yytext); return( ASSIGN ); }
"<"|"<="|">"|">="|"!="|"="    { filloperator(&yylval, yytext); return( RELOP ); }
";"    { return( ';' ); }
":"	{ return( ':' ); }
"."	{ return( FULLSTOP ); }
{ws}    { }
{id}    { filllexeme(&yylval, yytext);  return( ID ); }
{number}    { filllexeme(&yylval, yytext); return( NUMBER ); }
{type}	{ return( TYPE ); }
{idgroup} { return( IDGROUP ); }

%%

int yywrap() 
{ 
   return (1); 
} 

