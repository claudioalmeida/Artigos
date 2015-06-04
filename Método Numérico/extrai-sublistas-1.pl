/* 13/3/15 Conversão para diferença de listas,apenas os acumuladores.
   14/3/15 Conversão para diferença de listas também as listas Prefixo, Nucleo e Sufixo. Gera diferentes combinações de filhos.
   José de Siqueira
*/

/* extrair_sublistas(+PosiçãoInicial,+PosiçãooFinal,+Lista,-Prefixo,-Nucleo,-Sufixo) 
   Dada uma Lista, extrai três sublistas, onde:
+PosicaoInicial -> Posição de início da lista Núcleo.
+PosiçãoFinal -> Posição de término da lista Núcleo.
+Lista -> Lista a ser dividida em 3 DL: Prefixo, Núcleo e Sufixo.
-Prefixo -> Primeira diferença de lista que vai da posição 1 até (PosiçãoInicial - 1).
-Nucleo -> Segunda diferença de lista que vai da posição PosicaoInicial até PosicaoFinal.
-Sufixo -> Terceira diferença de lista que vai da posição PosicaoFinal + 1 até o final de Lista. 
   Determinístico.
*/
extrair_sublistas(PosicaoInicial,PosicaoFinal,Lista,Prefixo-P,Nucleo-N,Sufixo-S):-
	( (PosicaoInicial >=1, PosicaoFinal >=1, PosicaoInicial =< PosicaoFinal) -> 
	   ext_sublistas(PosicaoInicial,PosicaoFinal,Lista,AccP-AccP,AccN-AccN,Prefixo-P,Nucleo-N,Sufixo-S)
	;
	fail).

/* ext_sublistas(+PosiçãoInicial,+PosicaoFinal,+Lista,+AcumuladorPrefixo,+AcumuladorNucleo,-Prefixo,-Nucleo,-Sufixo) 
   Implementa extrair_sublistas/6, onde:
+PosicaoInicial -> Posição de início da lista Núcleo.
+PosiçãoFinal -> Posição de término da lista Núcleo.
+Lista -> Lista a ser dividida em 3: Prefixo, Núcleo e Sufixo.
+AcumuladorPrefixo -> Acumulador DL que será preenchido até formar Prefixo.
+AcumuladorNucleo -> Acumulador DL que será preenchido até formar Nucleo.
-Prefixo -> Primeira diferença de lista que vai da posição 1 até (PosiçãoInicial - 1).
-Nucleo -> Segunda diferença de lista que vai da posição PosicaoInicial até PosicaoFinal.
-Sufixo -> Terceira diferença de lista que vai da posição PosicaoFinal + 1 até o final de Lista. 
   usando os acumuladores AcumuladorPrefixo, AcumuladorNucleo e a própria lista Lista para chegar nas listas Prefixo, Nucleo e Sufixo.  
   Determinístico.

*/

ext_sublistas(1,1,[Elemento|Sufixo]-S,Prefixo-P,Nucleo-[Elemento|N],Prefixo-P,Nucleo-N,Sufixo-S) :- 
	!.

%reverse(Prefixo,PrefixoReverso),
%reverse([Elemento|Nucleo],NucleoReverso).

ext_sublistas(1,PosicaoFinal,[Elemento|Lista]-L,AcumuladorPrefixo,AcumuladorNucleo-[Elemento|AN],Prefixo-P,Nucleo-N,Sufixo-S) :-
	!,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublistas(1,PosicaoFinalAtualizada,Lista-L,AcumuladorPrefixo,AcumuladorNucleo-AN,Prefixo-P,Nucleo-N,Sufixo-S).

ext_sublistas(2,PosicaoFinal,[Elemento|Lista]-L,AcumuladorPrefixo-[Elemento|AP],AcumuladorNucleo,Prefixo-P,Nucleo-N,Sufixo-S) :-
	!,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublistas(1,PosicaoFinalAtualizada,Lista-L,AcumuladorPrefixo-AP,AcumuladorNucleo,Prefixo-P,Nucleo-N,Sufixo-S).

ext_sublistas(PosicaoInicial,PosicaoFinal,[Elemento|Lista]-L,AcumuladorPrefixo-[Elemento|AP],AcumuladorNucleo,Prefixo-P,Nucleo-N,Sufixo-S) :-
	PosicaoInicialAtualizada is PosicaoInicial-1,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublistas(PosicaoInicialAtualizada,PosicaoFinalAtualizada,Lista-L,AcumuladorPrefixo-AP,AcumuladorNucleo,Prefixo-P,Nucleo-N,Sufixo-S).

teste1(Inicio,Fim,Prefixo-P,Nucleo-N,Sufixo-S,Filho1-F1,Filho2-F2,Filho3-F3,Filho4-F4):- 
	extrair_sublistas(Inicio,Fim,[a,b,c,d,e,f,g,h,i,j,k|X]-X,Prefixo-P,Nucleo-N,Sufixo-S),
	copy_term(Sufixo-S,Sufixo2-S2),
	copy_term(Prefixo-P,Prefixo2-P2),
	copy_term(Nucleo-N,Nucleo2-N2),
	copy_term(Sufixo-S,Sufixo3-S3),
	copy_term(Prefixo-P,Prefixo3-P3),
	copy_term(Nucleo-N,Nucleo3-N3),
	copy_term(Sufixo-S,Sufixo4-S4),
	copy_term(Prefixo-P,Prefixo4-P4),
	copy_term(Nucleo-N,Nucleo4-N4),
	% Filho 1 = Sufixo + Nucleo + Prefixo
	Filho1 = Sufixo, 
	S = Nucleo,
	N = Prefixo,
	F1 = P,
	% Filho 2 = Sufixo + Prefixo + Nucleo
	Filho2 = Sufixo2, 
	S2 = Prefixo2,
	P2 = Nucleo2,
	F2 = N2,
	% Filho 3 = Prefixo + Sufixo + Nucleo
	Filho3 = Prefixo3, 
	P3 = Sufixo3,
	S3 = Nucleo3,
	F3 = N3,
	% Filho 4 = Nucleo + Sufixo + Prefixo 
	Filho4 = Nucleo4, 
	N4 = Sufixo4,
	S4 = Prefixo4,
	F4 = P4.
%	S = [].
%	teste(3,5,P,N,S,F1,F2,F3,F4).