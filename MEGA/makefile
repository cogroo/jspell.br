D= ../DIC
DICS= $D/port.geral.dic  $D/port.np.dic  $D/port.inf.dic  $D/port.siglas.dic

mega.dic.pl: megaport.dic.pl lemas.txt
	perl lemas-dic2dic lemas.txt  > mega.dic.pl

megaport.dic.pl: $(DICS)
	dic2mega $(DICS) > megaport.dic.pl 
