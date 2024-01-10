%{
	#include "pre.h"
	#define YYSTYPE node
	#include "par.tab.h"
	
	int yyerror();
	int yyerror(char* msg);
	int backpatchflag = 0;
	extern int yylex();    
	codelist* list;
	
%}

%token PROGRAM
%token END
%token BEGINO
%token IDGROUP
%token IF ELSE THEN
%token REPEAT UNTIL
%token WHILE DO
%token LBRACKET
%token RBRACKET
%token NOT
%token RELOP
%token NUMBER ID
%token AND
%token TYPE
%token VAR
%token FULLSTOP
%token ANNOTATION
%token TRUEO
%token FALSEO
%right LBRACKET
%left RBRACKET
%left AND OR
%left '+' '-'
%left '*' '/'
%right NOT
%right '='
%right ASSIGN

%%

S: 
 PROGRAM ID ';' { GenStart(list, $2.lexeme); } VAR IDGROUP TYPE ';' COMPOUND FULLSTOP

 |PROGRAM ID VAR IDGROUP TYPE ';' COMPOUND FULLSTOP
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of a semicolon after the program id!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 
 PROGRAM ID ';' VAR IDGROUP TYPE COMPOUND FULLSTOP
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of a semicolon after the variable declaration!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 |PROGRAM ';' VAR IDGROUP TYPE ';' COMPOUND FULLSTOP
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of the program id!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 |PROGRAM ID';' IDGROUP TYPE ';' COMPOUND FULLSTOP
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of \"var\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 |PROGRAM ID IDGROUP
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of a semicolon after the program id!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 |PROGRAM ID TYPE 
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of a semicolon after the program id!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 |PROGRAM ID COMPOUND
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of a semicolon after the program id!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }

 |PROGRAM ID FULLSTOP
 {
 	//eeeeeeeeeeeee
	char temp[80] = "Lack of a semicolon after the program id!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
 }


|PROGRAM ID ';' { GenStart(list, $2.lexeme); } COMPOUND FULLSTOP;


COMPOUND:
BEGINO LANGUAGETABLE END M
{
	backpatch(list, $2.nextlist, $4.instr);
}

/*|LANGUAGETABLE END M
{
//eeeeeeeeeeeee
	char temp[80] = "Lack of the reserved word \"begin\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
} */

|BEGINO END M
{
//eeeeeeeeeeeee
	char temp[80] = "Lack of the languagetable between \"begin\" and \" end\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
} 

/*|BEGINO LANGUAGETABLE
{
//eeeeeeeeeeeee
	char temp[80] = "Lack of the reserved word \"end\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
} */
;


//eeeeeeeeeeeeeeeeeee

LANGUAGETABLE:
STATEMENT LANGUAGETABLE 
{
	
} 

| STATEMENT 
{
	
};

STATEMENT:
IF EXPRESSION THEN M STATEMENT
{ 	
	backpatch(list, $2.truelist, $4.instr); 
	$$.nextlist = merge($2.falselist, $5.nextlist); 
}

|IF THEN M STATEMENT
{
//eeeeeeeeeeeee
	char temp[40] = "Lack of an expression!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION M STATEMENT
{
//eeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"then\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION THEN M 
{
//eeeeeeeeeeeee
	char temp[80] = "Lack of a statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|EXPRESSION THEN M STATEMENT
{
//eeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"if\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION THEN M STATEMENT ELSE N M STATEMENT
{ 	
	backpatch(list, $2.truelist, $4.instr);    
	backpatch(list, $2.falselist, $8.instr);
  	$5.nextlist = merge($5.nextlist, $7.nextlist);    
  	$$.nextlist = merge($5.nextlist, $9.nextlist); 
} 



|IF THEN M STATEMENT ELSE N M STATEMENT
{
//eeeeeeeeeeeeee
	char temp[80] = "Lack of an expression!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION M STATEMENT ELSE N M STATEMENT
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"then\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION THEN M ELSE N M STATEMENT
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"else\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION THEN M STATEMENT N M STATEMENT
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Lack of a statement between \"then\" and \"else\"!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|IF EXPRESSION THEN M STATEMENT ELSE N M
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Lack of a statement after \"else\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF EXPRESSION ELSE 
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"then\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|IF 
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete if-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|THEN
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete if-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|ELSE
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete if-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|REPEAT M STATEMENT UNTIL M EXPRESSION
{
	backpatch(list, $3.nextlist, $5.instr);
	backpatch(list, $6.falselist, $2.instr);
	$$.nextlist = $6.truelist;
	//gen_goto(list, $2.instr);
}

|M STATEMENT UNTIL M EXPRESSION
{
//eeeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"repeat\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|REPEAT M UNTIL M EXPRESSION
{
//eeeeeeeeeeeeee
	char temp[80] = "Lack of a statement between \"repeat\" and \"until\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|REPEAT M STATEMENT EXPRESSION
{
//eeeeeeeeeeeeee
	char temp[80] = "Lack of the reversed word \"until\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|REPEAT M STATEMENT UNTIL M 
{
//eeeeeeeeeeeeee
	char temp[80] = "Lack of a statement after \"until\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|REPEAT M
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete repeat-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|UNTIL M
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete repeat-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|WHILE M EXPRESSION DO M STATEMENT
{ 	
	backpatch(list, $6.nextlist, $2.instr);    
	backpatch(list, $3.truelist, $5.instr);
 	$$.nextlist = $3.falselist;	
 	gen_goto(list, $2.instr); 
}

|WHILE M DO M STATEMENT
{ 	
//eeeeeeeeee
	char temp[80] = "Lack of an expression after \"while\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|WHILE M EXPRESSION M STATEMENT
{ 	
//eeeeeeeeee
	char temp[80] = "Lack of the reserved word \"do\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|WHILE M EXPRESSION DO M
{ 	
//eeeeeeeeee
	char temp[80] = "Lack of a statement after \"do\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|EXPRESSION DO M STATEMENT
{ 	
//eeeeeeeeee
	char temp[80] = "Lack of the reserved word \"while\"!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|EXPRESSION M STATEMENT
{ 	
//eeeeeeeeee
	char temp[80] = "Incomplete statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|WHILE M
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete while-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|DO M
{ 	
//eeeeeeeeeeeeee
	char temp[80] = "Incomplete while-statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|STATEMENT M EXPRESSION
{ 	
//eeeeeeeeee
	char temp[80] = "Incomplete statement!";
	strcpy(errors[errorsNum], temp);
	errorsline[errorsNum] = list->linecnt;
	errorsNum++;
}

|OP ASSIGN EXPRESSION
{
	copyaddr(&$1, $1.lexeme); 
	gen_assignment(list, $1, $3);
}
//eeeeeeeeeeeeeeee

|L
{
	$$.nextlist = $1.nextlist;
}

|COMPOUND
{
	
}
;

L:L ';' M STATEMENT
{
	backpatch(list, $1.nextlist, $3.instr);
	$$.nextlist = $4.nextlist;
}

|L M STATEMENT
{
	backpatch(list, $1.nextlist, $2.instr);
	$$.nextlist = $3.nextlist;
}

|STATEMENT
{
	$$.nextlist = $1.nextlist;
}
;

EXPRESSION: 
EXPRESSION AND M EXPRESSION    
{ 	
	backpatch(list, $1.truelist, $3.instr);
  	$$.truelist = $4.truelist; 
  	$$.falselist = merge($1.falselist, $4.falselist); 
}

| AND M EXPRESSION    
{ 	
//eeeeeeeee
	char temp[80] = "Lack of an expression before \"and\"!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|EXPRESSION AND M   
{ 	
//eeeeeeeee
	char temp[80] = "Lack of an expression after \"and\"!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|EXPRESSION OR M EXPRESSION
{
	backpatch(list, $1.falselist, $3.instr);
	$$.truelist = merge($1.truelist, $4.truelist);
	$$.falselist = $4.falselist;
}

| OR M EXPRESSION    
{ 	
//eeeeeeeee
	char temp[80] = "Lack of an expression before \"or\"!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|EXPRESSION OR M   
{ 	
//eeeeeeeee
	char temp[80] = "Lack of an expression after \"or\"!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|NOT EXPRESSION
{
	$$.truelist = $2.falselist;
	$$.falselist = $2.truelist;
	$$.nextlist = $2.falselist;
}

|NOT
{
//eeeeeeeee
	char temp[80] = "Lack of an expression after \"not\"!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|EXPRESSION M EXPRESSION  
{ 	
//eeeeeeeee
	char temp[80] = "Lack of a logical operator(like \"and\" and \"or\") !";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|OP RELOP OP
{	
	$$.truelist = new_instrlist(nextinstr(list));
        $$.falselist = new_instrlist(nextinstr(list)+1);
        gen_if(list, $1, $2.oper, $3);
        gen_goto_blank(list); 
}

|OP OP
{
//eeeeeeeee
	char temp[80] = "Lack of a comparison operator!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|OP RELOP
{
//eeeeeeeee
	char temp[80] = "Lack of an OP after the comparison operator!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|RELOP OP
{
//eeeeeeeee
	char temp[80] = "Lack of an OP before the comparison operator!";
	strcpy(errors[errorsNum], temp);
	errorsNum++;
}

|OP
{
	copyaddr_fromnode(&$$, $1);
}
;
		
OP: LBRACKET OP RBRACKET 
    {
    	new_temp(&$$, get_temp_index0(list));
    } 
    |OP '+' OP { new_temp(&$$, get_temp_index(list)); gen_3addr(list, $$, $1, "+", $3); }
    |OP '-' OP { new_temp(&$$, get_temp_index(list)); gen_3addr(list, $$, $1, "-", $3); }
    |OP '*' OP { new_temp(&$$, get_temp_index(list)); gen_3addr(list, $$, $1, "*", $3); }
    |OP '/' OP { new_temp(&$$, get_temp_index(list)); gen_3addr(list, $$, $1, "/", $3); }
    |NUMBER {copyaddr(&$$, $1.lexeme);}
    |ID {copyaddr(&$$, $1.lexeme);}
    
    ;
		

M : { $$.instr = nextinstr(list); };

N : {
	$$.nextlist = new_instrlist(nextinstr(list));
 	gen_goto_blank(list);
    }
    ;
%%

int yyerror(char* msg)
{
    printf("\nERROR with message: %s\n", msg);
    return 0;
}
S

int main(int argc, char *argv[])
{
    ++argv; --argc;
    list = newcodelist();
    FILE *f;
    if (argc>0) f = fopen(argv[0],"r");
    
  
    
	
    //重定向标准输入到 test.in
    //freopen("test.in", "rt+", stdin);
    // 重定向标准输出到 test.out
    //freopen("test.out", "wt+", stdout);

else
    {
        char file[100];
        printf("\n输入你的文件:\n");
        scanf("%s",file);
        f=fopen(file,"r");
        yyrestart(f);
     
    }

   
    yyparse();
    print(list);
    
    // 关闭重定向的文件流
    //fclose(stdin);
    //fclose(stdout);

    return 0;
}                
                
                



