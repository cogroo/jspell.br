%{
/*-----------------------------------------------------------------------------\
| GE_VERB.L                                                                    |
\-----------------------------------------------------------------------------*/

int linha = 1;

void trata_ws(char *yytext)
{
   int i;

   i = 0;
   while (yytext[i] != '\0') {
      if (yytext[i] == '\n') linha++;
      i++;
   }
}

%}

DELIM    [ \t\n]
WS       {DELIM}*
PALAVRA  [a-zA-Z0-9_'`~^ביםףתאטלעשדץגךפחüס\-]+
LETRA    \:[a-z]

%start NORMAL COMENT

%%
        BEGIN NORMAL;
<NORMAL>{PALAVRA} {strcpy(yylval.str, yytext); /*fprintf(stderr, "%s", yylval.str);*/ return(PALAVRA);}
<NORMAL>{LETRA}   {yylval.ch = yytext[1]; return(LETRA);}
<NORMAL>"#v"      {return(V);}
<NORMAL>"#vX"     {return(VX);}
<NORMAL>"//"      {BEGIN COMENT;}
<NORMAL>{WS}      {trata_ws(yytext);}
<NORMAL>.         {return(yytext[0]);}
<COMENT>\n        {linha++; BEGIN NORMAL;}
<COMENT>.         {}

%%

yywrap(){return(1);}   /* deve existir quando se usa lex, yacc */
