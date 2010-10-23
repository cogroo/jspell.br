#Aspell Makefile for using official aspell Language Toolkit
#Aspell5

#make (aspell)
#make (install)

T=../ASPELL_TOOLKIT/aspell-lang
L=pt_PT
K=pt
O=$T/$K

DATE=date +%Y%m%d

all: aspell

dist: aspell
	cd $O; make dist
	mv $O/aspell5*`${DATE}`* .
