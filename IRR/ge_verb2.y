%{
/*----------------------------------------------------------------------------\
| GE_VERB.Y                                                                   |
\----------------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define COMPRIM
#define DEF_FLAGS "L"

/* #define MYDEBUG */

#define FALSE 0
#define TRUE 1

#define MAX_CONJ 64

char aeir[3][MAX_CONJ][20] =   {{"ando",
 "o", "as", "a", "amos", "ais", "am",
 "e", "es", "e", "emos", "eis", "em",
 "a", "e", "emos", "ai", "em",
 "ado", "ada", "ados", "adas",
 "ava", "avas", "ava", "ávamos", "áveis", "avam",
 "ei", "aste", "ou", "ámos", "astes", "aram",
 "ara", "aras", "ara", "áramos", "áreis", "aram",
 "arei", "arás", "ará", "aremos", "areis", "arão",
 "asse", "asses", "asse", "ássemos", "ásseis", "assem",
 "ar", "ares", "ar", "armos", "ardes", "arem",
 "aria", "arias", "aria", "aríamos", "aríeis", "ariam"},
 {"endo",
 "o", "es", "e", "emos", "eis", "em",
 "a", "as", "a", "amos", "ais", "am",
 "e", "a", "amos", "ei", "am",
 "ido", "ida", "idos", "idas",
 "ia", "ias", "ia", "íamos", "íeis", "iam",
 "i", "este", "eu", "emos", "estes", "eram",
 "era", "eras", "era", "êramos", "êreis", "eram",
 "erei", "erás", "erá", "eremos", "ereis", "erão",
 "esse", "esses", "esse", "êssemos", "êsseis", "essem",
 "er", "eres", "er", "ermos", "erdes", "erem",
 "eria", "erias", "eria", "eríamos", "eríeis", "eriam"},
{"indo",
 "o", "es", "e", "imos", "is", "em",
 "a", "as", "a", "amos", "ais", "am",
 "e", "a", "amos", "i", "am",
 "ido", "ida", "idos", "idas",
 "ia", "ias", "ia", "íamos", "íeis", "iam",
 "i", "iste", "iu", "imos", "istes", "iram",
 "ira", "iras", "ira", "íramos", "íreis", "iram",
 "irei", "irás", "irá", "iremos", "ireis", "irão",
 "isse", "isses", "isse", "íssemos", "ísseis", "issem",
 "ir", "ires", "ir", "irmos", "irdes", "irem",
 "iria", "irias", "iria", "iríamos", "iríeis", "iriam"}
};

char tempos[MAX_CONJ][14] = {"T=g",
   "P=1,N=s,T=p",  "P=2,N=s,T=p",  "P=3,N=s,T=p",
   "P=1,N=p,T=p",  "P=2,N=p,T=p",  "P=3,N=p,T=p",
   "P=1,N=s,T=pc", "P=2,N=s,T=pc", "P=3,N=s,T=pc",
   "P=1,N=p,T=pc", "P=2,N=p,T=pc", "P=3,N=p,T=pc",
                   "P=2,N=s,T=i",  "P=3,N=s,T=i",
   "P=1,N=p,T=i",  "P=2,N=p,T=i",  "P=3,N=p,T=i",
   "G=m,N=s,T=ppa", "G=f,N=s,T=ppa", "G=m,N=p,T=ppa", "G=f,N=p,T=ppa",
   "P=1,N=s,T=pi", "P=2,N=s,T=pi", "P=3,N=s,T=pi",
   "P=1,N=p,T=pi", "P=2,N=p,T=pi", "P=3,N=p,T=pi",
   "P=1,N=s,T=pp", "P=2,N=s,T=pp", "P=3,N=s,T=pp",
   "P=1,N=p,T=pp", "P=2,N=p,T=pp", "P=3,N=p,T=pp",
   "P=1,N=s,T=pmp","P=2,N=s,T=pmp","P=3,N=s,T=pmp",
   "P=1,N=p,T=pmp","P=2,N=p,T=pmp","P=3,N=p,T=pmp",
   "P=1,N=s,T=f",  "P=2,N=s,T=f",  "P=3,N=s,T=f",
   "P=1,N=p,T=f",  "P=2,N=p,T=f",  "P=3,N=p,T=f",
   "P=1,N=s,T=pic","P=2,N=s,T=pic","P=3,N=s,T=pic",
   "P=1,N=p,T=pic","P=2,N=p,T=pic","P=3,N=p,T=pic",
   "P=1,N=s,T=fc", "P=2,N=s,T=fc", "P=3,N=s,T=fc",
   "P=1,N=p,T=fc", "P=2,N=p,T=fc", "P=3,N=p,T=fc",
   "P=1,N=s,T=c",  "P=2,N=s,T=c",  "P=3,N=s,T=c",
   "P=1,N=p,T=c",  "P=2,N=p,T=c",  "P=3,N=p,T=c"
 };

char dic_name[80];

typedef struct tconj {
   char conj[20];
   char pess;
   char num;
   char tempo[4];
} tconj;

tconj act_conj[MAX_CONJ+4];    /* mante'm as conjugac,o~es do verbo(s) a sere(m)
                                correntemente analisados */
                               /* +4 por causa do infinitivo pessoal */

#define MAX_VERB_CAB 30

typedef struct verb_inf {
    char name[20];
    char flags[20];
} verb_inf;

verb_inf verbo[MAX_VERB_CAB];   /* array com os verbos do cabec,alho corrente */

char trat[MAX_CONJ];  /* indica se esta conjugac,a~o vai ter tratamento "especial"*/

int i_c,     /* n. de conjugac,o~es corrente */
    i_v;     /* n. de verbos do cabec,alho corrente */
char letra;  /* letra anterior ao X */
char tcab;   /* indicador do tipo de cabec,alho corrente */
char escr_v_inf;

int put_info;

static char so_irr_p_pc_i;

FILE *fp_inf;

int vc = 99; /* verb_count (come,a em 100 p/ na~o comfundir com tempos) */

/*----------------------------------------------------------------------------*/
char stg[255];

/*----------------------------------------------------------------------------*/

int in_tempos(char *aux)
{
   int i;

   i = 0;
   while (strcmp(tempos[i], aux) && i < MAX_CONJ)
      i++;
   if (i == MAX_CONJ)
      return(-1);   /* insucesso */
   else
      return(i);
}

char flag_aux[20];

/*----------------------------------------------------------------------------*/

char *da_flags(char *strg)
{
   int i;

   i = 0;
   while (*strg != '\0') {
      if (*strg == 'L' || *strg == 'P' || *strg == 'S' || *strg == 'R')
         flag_aux[i++] = *strg;
      strg++;
   }
   flag_aux[i] = '\0';
   return(flag_aux);
}

/*----------------------------------------------------------------------------*/

char *merge(char pess, char num, char *temp, char compr)
{
   if (pess == '0')
      sprintf(stg, "T=g");
   else if (pess == 'm' || pess == 'f')
      sprintf(stg, "G=%c,N=%c,T=%s", pess, num, temp);
   else
      sprintf(stg, "P=%c,N=%c,T=%s", pess, num, temp);

   if (compr) {
      int i;
      if ((i = in_tempos(stg)) != -1)
         sprintf(stg, "#%d", i);
   }
   return(stg);
}

/*----------------------------------------------------------------------------*/

void escreve(char *forma, char *verb_name, char *flags, char pess, char num, char *temp)
{
   if (put_info) {  /* default */

#ifdef COMPRIM
      merge(pess, num, temp, 1);
      if (strlen(verb_name) > 3)
         printf("%s/$#%d$#v$%s/%s\n", forma, vc, stg, flags);
      else
         printf("%s/$%s$#v$%s/%s\n", forma, verb_name, stg, flags);
#else
      merge(pess, num, temp, 0);
      printf("%s/$%s$CAT=v$%s/%s\n", forma, verb_name, stg, flags);
#endif
   }
   else
      puts(forma);
}

/*----------------------------------------------------------------------------*/

void add_verb_inf(char *verb_name)
{
   vc++;
#ifdef COMPRIM
      printf("#%d/%s\n", vc, verb_name);
#endif
   if (escr_v_inf)
      fprintf(fp_inf, "%s\n", verb_name);
}


void det_pess_verb_tratadas()
{
   int i, i1;
   char *aux;

   for (i = 0; i < MAX_CONJ; i++)
      trat[i] = FALSE;
   so_irr_p_pc_i = 1;
   for (i = 0; i < i_c; i++) {   /* para cada conjugac,a~o */

      aux = merge(act_conj[i].pess, act_conj[i].num, act_conj[i].tempo, 0);  /* nunca se quer comprimido para fazer match */
      if ((i1 = in_tempos(aux)) != -1) {
         trat[i1] = TRUE;
         if (strcmp(act_conj[i].tempo, "p") && strcmp(act_conj[i].tempo, "pc")
             && strcmp(act_conj[i].tempo, "i"))
             so_irr_p_pc_i = 0;
      }
   }
}

/*----------------------------------------------------------------------------*/

void gera_tempos_reg(char *verb_name, char* flags)
{
   int r, t, paux;
   char aux[60];

   paux = strlen(verb_name) - 2;
   switch (verb_name[paux]) {
      case 'a': r = 0; break;
      case 'e': r = 1; break;
      case 'i': r = 2; break;
      default : return;   /*  ex v. po^r */
   }
   strcpy(aux, verb_name);
   aux[paux] = '\0';
   for (t = 0; t < MAX_CONJ; t++)
      if (!trat[t] &&   /* na~o tem tratamento especial */
          (so_irr_p_pc_i == 0 || (t >= 1 && t <= 17)))
         if (put_info)
#ifdef COMPRIM
           if (strlen(verb_name) > 3)
              printf("%s%s/$#%d$#v$#%d/%s\n", aux, aeir[r][t], vc, t, flags);
           else
              printf("%s%s/$%s$#v$#%d/%s\n", aux, aeir[r][t], verb_name, t, flags);
#else
            printf("%s%s/$%s$CAT=v$%s/%s\n", aux, aeir[r][t], verb_name, tempos[t], flags);
#endif
         else
            printf("%s%s\n", aux, aeir[r][t]);

}

/*----------------------------------------------------------------------------*/

int det_pos_letra(char letra, char *verb_name)
{
   int i;

   i = strlen(verb_name) - 3;
   while (verb_name[i] != letra && i > 0)
      i--;
   return(i);
}

/*----------------------------------------------------------------------------*/

void trata_X()
{
/* parte do princi'pio que as conjugaço~es sa~o constitui'das por uma letra,
  seguida de um X seguida das desine^ncias */

   int pos,   /*posic,a~o da letra que vai ser substitui'da */
       v, c;
   char aux[40], aux2[10];

   for (v = 0; v < i_v; v++) {
      pos = det_pos_letra(letra, verbo[v].name);
#ifdef MYDEBUG
      fprintf(stderr, "trataX: %s\n", verbo[v].name);
#endif
      add_verb_inf(verbo[v].name);
      gera_tempos_reg(verbo[v].name, verbo[v].flags);
      for (c = 0; c < i_c; c++) {
         strcpy(aux, verbo[v].name);
         aux[strlen(aux)-2] = '\0';   /* retirar terminaça~o (ar, er,ir) */
         aux[pos] = act_conj[c].conj[0];   /* alterar letra */
         if (act_conj[c].conj[1] != '\'')   /* na~o e' caso de acento */
            strcat(aux, act_conj[c].conj+2);
         else {                              /* acento */
            strcpy(aux2, aux+pos+1);
            aux[pos+1] = '\''; aux[pos+2] = '\0';
            strcat(aux, aux2);
            strcat(aux, act_conj[c].conj+3);
         }
         escreve(aux, verbo[v].name, verbo[v].flags,
                act_conj[c].pess, act_conj[c].num, act_conj[c].tempo);
      }
   }
}

/*----------------------------------------------------------------------------*/

char *corta_resto(char *lin)
{
   while (*lin != '/' && *lin != '\0')
      lin++;
   *lin = '\0';
   return(lin+1);
}

void trata_aster()
{
   char aux[90], *p;
   char lin[90];
   FILE *fp;
   int c;

#ifdef MYDEBUG
   fprintf(stderr, "*%s\n", verbo[0].name);
#endif
   sprintf(aux, "grep \"%s/\" %s", verbo[0].name, dic_name);
/*   sprintf(aux, "grep \"%s/CAT=v\" %s>auxil", verbo[0].name, dic_name);
   system(aux); */
   if (fp = popen(aux, "r")) {
      while (fgets(lin, 90, fp) /*!feof(fp)*/) {  
                         /* para cada verbo no diciona'rio */
         if (strncmp(lin, "File ", 5)) {/* pq o GREP do MS-DOS é Estúpido e põe: File ...: na 1¦ linha */
            p = corta_resto(lin);  /* lin passa a apontar so' para o verbo */
            p = corta_resto(p); /* avanc,ar campo de features */
            corta_resto(p);     /* remover comenta'rios */
            add_verb_inf(lin);
            gera_tempos_reg(lin, da_flags(p));
            for (c = 0; c < i_c; c++) {
               strcpy(aux, lin);
               aux[strlen(aux)-strlen(verbo[0].name)] = '\0';   /* retirar chars do fim terminaça~o (ex. ibir) */
               strcat(aux, act_conj[c].conj);
               escreve(aux, lin, da_flags(p),
                      act_conj[c].pess, act_conj[c].num, act_conj[c].tempo);
            }
         }
      }
      pclose(fp);
   }
}

/*----------------------------------------------------------------------------*/

int det_n()
{
/* n ira' indicar o n. de chars comuns (no fim) dos 2 primeiros verbos */
   int n, n0, n1;

   if (i_v == 1)
      n = strlen(verbo[0].name);   /* se só ha' um verbo, ele esta' definido por extenso */
   else {
      n0 = strlen(verbo[0].name) -1;
      n1 = strlen(verbo[1].name) -1;
      n = 0;
      while (n0 >= 0 && n1 >= 0 && verbo[0].name[n0] == verbo[1].name[n1]) {
         n++;
         n0--;
         n1--;
      }
   }
   return(n);
}

void trata_n()
{
   int v, c, n;
   char aux[60];

   n = det_n();
   for (v = 0; v < i_v; v++) {
#ifdef MYDEBUG
   fprintf(stderr, "%s\n", verbo[v].name);
#endif
      add_verb_inf(verbo[v].name);
      gera_tempos_reg(verbo[v].name, verbo[v].flags);
      for (c = 0; c < i_c; c++) {
         strcpy(aux, verbo[v].name);
         aux[strlen(aux)-n] = '\0';   /* retirar terminaça~o () */
         strcat(aux, act_conj[c].conj);
         escreve(aux, verbo[v].name, verbo[v].flags,
                act_conj[c].pess, act_conj[c].num, act_conj[c].tempo);
      }
   }

}

/*----------------------------------------------------------------------------*/

void trata_corpo()
{
   det_pess_verb_tratadas();
   switch (tcab) {
      case '*': trata_aster(); break;
      case 'n': trata_n(); break;
      case 'X': trata_X(); break;
   }
}

%}

%start prog

%union {
   char str[255];
   char ch;
}

%token <str> PALAVRA
%token <ch> LETRA

%token V VX

%type <str> flags

%%

prog   : blocos
       ;

blocos : bloco
       | blocos bloco
       ;

bloco  : cab {i_c = 0;} corpo {trata_corpo();};

cab    : cab_aster
       | cab_n
       | cabX
       ;

cab_aster: V '*' PALAVRA {tcab = '*'; strcpy(verbo[0].name, $3);};

cab_n  : V {i_v = 0;} l_palavras {tcab = 'n';};

cabX   : VX LETRA {i_v = 0;} l_palavras {tcab = 'X'; letra = $2;};

corpo  : linha_c
       | corpo linha_c
       ;

linha_c: PALAVRA PALAVRA PALAVRA {strcpy(act_conj[i_c].conj, $1);
                                  act_conj[i_c].pess = $2[0];
                                  act_conj[i_c].num  = $2[1];
                                  strcpy(act_conj[i_c].tempo,$3);
#ifdef MYDEBUG
   fprintf(stderr, "%s/N=%c,P=%c,T=%s\n", act_conj[i_c].conj, act_conj[i_c].num, act_conj[i_c].pess, act_conj[i_c].tempo);
#endif
                                  i_c++;};

l_palavras: PALAVRA flags               {strcpy(verbo[i_v].name, $1);
                                         strcpy(verbo[i_v].flags, da_flags($2));
                                         i_v++;}
          | l_palavras ',' PALAVRA  flags {strcpy(verbo[i_v].name, $3);
                                           strcpy(verbo[i_v].flags, da_flags($4));
                                           i_v++;}
          ;

flags     :                               {strcpy($$, DEF_FLAGS);}
          | '/' PALAVRA                   {strcpy($$, $2);}
          ;
%%

#include"lex.yy.c"

yyerror()
{
   fprintf(stderr, "%c---erro--linha %d --%c\n", 7, linha, 7);
}

/* le^ do stdin o fich. dos tempos irregulares */
/* escreve no stdout, o fich. gerado */
/* como para^metro, deve ter o diciona'rio so' com verbos */
/* pode ter um segundo par^ametro, indicando que se quer escrever num
 ficheiro o inf. de todos os verbos irregulares encontrados */

/* ATEN,C~AO:
     o grep faz ".../v..." isto e', a "/" e o "CAT=v" tem de estar pegados. */

void legenda()
{
#ifdef COMPRIM
   int i;

   for (i = 0; i < MAX_CONJ; i++)
      printf("#%d/%s\n", i, tempos[i]);

#endif
}

int main(int argc, char *argv[])
{
   char out_inf[80];

   if (argc < 2)
      puts("Deve-se indicar o nome do diciona'rio (so' com verbos) como para^metro");
   else {
      if (argc == 2) put_info = 1;  /* default */
                else put_info = 0;

      strcpy(dic_name, argv[1]);
      if (argc > 2) {
         strcpy(out_inf, argv[2]);
         fp_inf = fopen(out_inf, "w");
         escr_v_inf = 1;
      }
      else escr_v_inf = 0;
      legenda();
      yyparse();
      if (argc > 2) fclose(fp_inf);
   }
   return 0;
}
