#!/usr/bin/perl

while(<>){
    chomp;
    push @i,$_ if /^>/;
    push @o,$_ if /^</;
}

print "Diferenças de palavras desde a última versão (FALTA ID DA VERSÃO ANTERIOR)"; 
print "\n\n**Removidas**"; 
map {print} @o; 
print "\n\n**Adicionadas**"; 
map {print} @i;

# rawdiffwordlist.$L-`$(DATE)`.txt > verbdiffwordlist.$L-`$(DATE)`.txt
