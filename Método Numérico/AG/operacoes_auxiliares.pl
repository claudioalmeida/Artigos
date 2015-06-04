/* substitui_enesimo(+Posição,+Lista,+Elemento,-ListaComElemento)
   Substitui um elemento em determinada posição na lista por outro elemento, onde:
		+Posição -> Posição do elemento que será substituído (inicia de 1)
		+Lista -> Lista cujo elemento se deseeja substituir.
		+Elemento -> Elemento que substituirá o elemento atual da lista.
		-ListaComElemento -> Lista após a substituição do elemento.
   Determinístico.
*/
substitui_enesimo(Posicao,Lista,Elemento,ListaComElemento):-
    subst_enesimo(1,Posicao,Lista,Elemento,ListaComElemento).

/* subst_enesimo(+Contador,+Posição,+Lista,+Elemento,-ListaComElemento)
   Implementa substitui_enesimo/4, onde:
		+Contador -> Contador utilizado para contar a posição dos elementos na lista. Deve ser iniciado com 1.
		+Posição -> Posição do elemento que será substituído (inicia de 1)
		+Lista -> Lista cujo elemento se deseeja substituir.
		+Elemento -> Elemento que substituirá o elemento atual da lista.
		-ListaComElemento -> Lista após a substituição do elemento.
   Determinístico.
*/
subst_enesimo(Posicao,Posicao,[_|Lista],Elemento,[Elemento|Lista]):-!.
subst_enesimo(Contador,Posicao,[A|Lista],Elemento,[A|ListaComElemento]):-
    NContador is Contador+1,
    subst_enesimo(NContador,Posicao,Lista,Elemento,ListaComElemento).

/* extrair_sublistas(+PosiçãoInicial,+PosiçãooFinal,+Lista,-Prefixo,-Nucleo,-Sufixo) 
   Dada uma Lista, extrai três sublistas, onde:
		+PosicaoInicial -> Posição de início da lista Núcleo.
		+PosiçãoFinal -> Posição de término da lista Núcleo.
		+Lista -> Diferença de lista a ser dividida em 3 diferenças de listas: Prefixo, Núcleo e Sufixo.
		-Prefixo -> Primeira diferença de lista que vai da posição 1 até (PosiçãoInicial - 1).
		-Nucleo -> Segunda diferença de lista que vai da posição PosicaoInicial até PosicaoFinal.
		-Sufixo -> Terceira diferença de lista que vai da posição PosicaoFinal + 1 até o final de Lista. 
	Determinístico.
*/
extrair_sublistas(PosicaoInicial,PosicaoFinal,Lista,Prefixo/P,Nucleo/N,Sufixo/S):-
	( (PosicaoInicial >=1, PosicaoFinal >=1, PosicaoInicial =< PosicaoFinal) -> 
	   ext_sublistas(PosicaoInicial,PosicaoFinal,Lista,AccP/AccP,AccN/AccN,Prefixo/P,Nucleo/N,Sufixo/S)
	;
	fail).

/* ext_sublistas(+PosiçãoInicial,+PosicaoFinal,+Lista,+AcumuladorPrefixo,+AcumuladorNucleo,-Prefixo,-Nucleo,-Sufixo) 
   Implementa extrair_sublistas/6, onde:
		+PosicaoInicial -> Posição de início da diferença de lista Núcleo.
		+PosiçãoFinal -> Posição de término da diferença de lista Núcleo.
		+Lista -> Diferença de lista a ser dividida em 3 diferenças de listas: Prefixo, Núcleo e Sufixo.
		+AcumuladorPrefixo -> Acumulador diferença de lista que será preenchido até formar Prefixo.
		+AcumuladorNucleo -> Acumulador diferença de lista que será preenchido até formar Nucleo.
		-Prefixo -> Primeira diferença de lista que vai da posição 1 até (PosiçãoInicial - 1).
		-Nucleo -> Segunda diferença de lista que vai da posição PosicaoInicial até PosicaoFinal.
		-Sufixo -> Terceira diferença de lista que vai da posição PosicaoFinal + 1 até o final de Lista. 
   Usando os acumuladores AcumuladorPrefixo, AcumuladorNucleo e a própria lista Lista para chegar nas listas Prefixo, Nucleo e Sufixo.  
   Determinístico.

*/

ext_sublistas(1,1,[Elemento|Sufixo]/X,Prefixo/P,Nucleo/[Elemento|N],Prefixo/P,Nucleo/N,Novo_Sufixo/S) :- 
	!,
	copy_term(Sufixo/X,Novo_Sufixo/S).

ext_sublistas(1,PosicaoFinal,[Elemento|Lista]/L,AcumuladorPrefixo,AcumuladorNucleo/[Elemento|AN],Prefixo/P,Nucleo/N,Sufixo/S) :-
	!,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublistas(1,PosicaoFinalAtualizada,Lista/L,AcumuladorPrefixo,AcumuladorNucleo/AN,Prefixo/P,Nucleo/N,Sufixo/S).

ext_sublistas(2,PosicaoFinal,[Elemento|Lista]/L,AcumuladorPrefixo/[Elemento|AP],AcumuladorNucleo,Prefixo/P,Nucleo/N,Sufixo/S) :-
	!,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublistas(1,PosicaoFinalAtualizada,Lista/L,AcumuladorPrefixo/AP,AcumuladorNucleo,Prefixo/P,Nucleo/N,Sufixo/S).

ext_sublistas(PosicaoInicial,PosicaoFinal,[Elemento|Lista]/L,AcumuladorPrefixo/[Elemento|AP],AcumuladorNucleo,Prefixo/P,Nucleo/N,Sufixo/S) :-
	PosicaoInicialAtualizada is PosicaoInicial-1,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublistas(PosicaoInicialAtualizada,PosicaoFinalAtualizada,Lista/L,AcumuladorPrefixo/AP,AcumuladorNucleo,Prefixo/P,Nucleo/N,Sufixo/S).

/* cortar_cauda(+Lista,+Posicao,-ListaCortada) 
   Dada uma lista, corta todos os elementos da cauda daquela lista, onde:
		+Lista -> Lista cuja calda será cortada.
		+Posicao -> Posição de término da lista e onde, a partir do próximo elemento, será considerado cauda.
		-ListaCortada -> Lista sem a cauda.
   Determinístico.
*/
cortar_cauda(Lista,Posicao,ListaCortada):-
	cor_cauda(Lista,Posicao,Cauda_Diferenca_De_Lista/Cauda_Diferenca_De_Lista,ListaCortada).

/* cor_cauda(+Lista,+Posicao,+ListaAtualCortada,-ListaCortada) 
   Implementa cortar_cauda/3, onde:
		+Lista -> Lista cuja calda será cortada.
		+Posicao -> Posição de término da lista e onde, a partir do próximo elemento, será considerado cauda.
		+ListaAtualCortada -> Acumulador que será preenchido até formar ListaCortada.
		-ListaCortada -> Lista sem a cauda.
   Determinístico.
*/

cor_cauda(_,0,Lista_Cortada_Diferenca_De_Lista,Lista_Cortada) :-
	!,
	converte_diferenca_de_lista_lista(Lista_Cortada_Diferenca_De_Lista,Lista_Cortada).

cor_cauda([],_,Lista_Cortada_Diferenca_De_Lista,Lista_Cortada) :-
	!,
	converte_diferenca_de_lista_lista(Lista_Cortada_Diferenca_De_Lista,Lista_Cortada).

cor_cauda([Elemento|Lista],Posicao,ListaAtualCortada/[Elemento|Cauda_Diferenca_De_Lista],ListaCortada) :-
	NovaPosicao is Posicao-1,
	cor_cauda(Lista,NovaPosicao,ListaAtualCortada/Cauda_Diferenca_De_Lista,ListaCortada).

/* numero_elementos_iguais(+Lista1,+Lista2,-Numero_Elementos_Iguais) 
   Dadas duas listas, calcula o número de elementos iguais na mesma posição entre elas, onde:
		+Lista1 -> Primeira lista.
		+Lista2 -> Segunda lista.
		-Numero_Elementos_Iguais -> Número de elementos iguais na mesma posição em Lista1 e Lista2.
   Determinístico.
*/
										
numero_elementos_iguais(_-Inviduo1/X,_-Individuo2/Y,Numero_Elementos_Iguais):-
	num_elementos_iguais(Inviduo1/X,Individuo2/Y,0,Numero_Elementos_Iguais).	

/* num_elementos_iguais(+Lista1,+Lista2,+ListaAtualCortada,-ListaCortada) 
   Implementa numero_elementos_iguais/3, onde:
		+Lista1 -> Primeira lista.
		+Lista2 -> Segunda lista.
		+Contador -> Contador que irá ser incrementado com o número de cidades iguais
		-Numero_Elementos_Iguais -> Número de elementos iguais na mesma posição em Lista1 e Lista2.
   Determinístico.
*/	

num_elementos_iguais(X/X,Y/Y,Numero_Elementos_Iguais,Numero_Elementos_Iguais) :- 
	var(X),
	!.

num_elementos_iguais([Elemento_Individuo|Individuo1]/X,[Elemento_Individuo|Individuo2]/Y,Contador,Numero_Elementos_Iguais) :- 
	!,
	Contador_Atualizado is Contador + 1,
	num_elementos_iguais(Individuo1/X,Individuo2/Y,Contador_Atualizado,Numero_Elementos_Iguais).
	
num_elementos_iguais([_|Individuo1]/X,[_|Individuo2]/Y,Contador,Numero_Elementos_Iguais) :- 
	num_elementos_iguais(Individuo1/X,Individuo2/Y,Contador,Numero_Elementos_Iguais).

/* trechos_iguais(+Lista1,+Lista2,-Trechos_Iguais) 
   Dada uma Lista, extrai três sublistas, onde:
		+PosicaoInicial -> Posição de início da lista Núcleo.
		+PosiçãoFinal -> Posição de término da lista Núcleo.
		+Lista -> Diferença de lista a ser dividida em 3 diferenças de listas: Prefixo, Núcleo e Sufixo.
		-Prefixo -> Primeira diferença de lista que vai da posição 1 até (PosiçãoInicial - 1).
		-Nucleo -> Segunda diferença de lista que vai da posição PosicaoInicial até PosicaoFinal.
		-Sufixo -> Terceira diferença de lista que vai da posição PosicaoFinal + 1 até o final de Lista. 
	Determinístico.
*/
trechos_iguais(Lista1,Lista2,Trechos_Iguais) :-
	trechos_iguais(Lista1,Lista2,1,0-[0,0,Acumulador_Trecho/Acumulador_Trecho],Acumulador_Trechos_Iguais/Acumulador_Trechos_Iguais,Trechos_Iguais).

/* ext_sublistas(+PosiçãoInicial,+PosicaoFinal,+Lista,+AcumuladorPrefixo,+AcumuladorNucleo,-Prefixo,-Nucleo,-Sufixo) 
   Implementa extrair_sublistas/6, onde:
		+PosicaoInicial -> Posição de início da diferença de lista Núcleo.
		+PosiçãoFinal -> Posição de término da diferença de lista Núcleo.
		+Lista -> Diferença de lista a ser dividida em 3 diferenças de listas: Prefixo, Núcleo e Sufixo.
		+AcumuladorPrefixo -> Acumulador diferença de lista que será preenchido até formar Prefixo.
		+AcumuladorNucleo -> Acumulador diferença de lista que será preenchido até formar Nucleo.
		-Prefixo -> Primeira diferença de lista que vai da posição 1 até (PosiçãoInicial - 1).
		-Nucleo -> Segunda diferença de lista que vai da posição PosicaoInicial até PosicaoFinal.
		-Sufixo -> Terceira diferença de lista que vai da posição PosicaoFinal + 1 até o final de Lista. 
   Usando os acumuladores AcumuladorPrefixo, AcumuladorNucleo e a própria lista Lista para chegar nas listas Prefixo, Nucleo e Sufixo.  
   Determinístico.

*/

trechos_iguais([Elemento|Lista1],[Elemento|Lista2],Contador,_-[0,Posicao_Final,Trecho/[Elemento|Nova_Cauda_Trecho]],Acumulador_Trechos_Iguais,Trechos_Iguais) :-
	integer(Elemento),
	!,
	Contador_Atualizado is Contador + 1,
	trechos_iguais(Lista1,Lista2,Contador_Atualizado,_-[Contador,Posicao_Final,Trecho/Nova_Cauda_Trecho],Acumulador_Trechos_Iguais,Trechos_Iguais).
	
trechos_iguais([Elemento|Lista1],[Elemento|Lista2],Contador,_-[Posicao_Inicial,_,Trecho/[Elemento|Nova_Cauda_Trecho]],Acumulador_Trechos_Iguais,Trechos_Iguais) :-
	integer(Elemento),
	!,
	Contador_Atualizado is Contador + 1,
	trechos_iguais(Lista1,Lista2,Contador_Atualizado,_-[Posicao_Inicial,_,Trecho/Nova_Cauda_Trecho],Acumulador_Trechos_Iguais,Trechos_Iguais).
	
trechos_iguais([Elemento1|Lista1],[Elemento2|Lista2],Contador,_-[0,0,Trecho/Cauda_Trecho],Acumulador_Trechos_Iguais,Trechos_Iguais) :-
	integer(Elemento1),
	Elemento1 =\= Elemento2,
	!,
	Contador_Atualizado is Contador + 1,
	trechos_iguais(Lista1,Lista2,Contador_Atualizado,0-[0,0,Trecho/Cauda_Trecho],Acumulador_Trechos_Iguais,Trechos_Iguais).
	
trechos_iguais([Elemento1|Lista1],[Elemento2|Lista2],Contador,_-[Posicao_Inicial,0,Trecho/Cauda_Trecho],Acumulador_Trechos_Iguais/[Fitness-[Posicao_Inicial,Posicao_Final,Trecho]|Nova_Cauda_Trechos_Iguais],Trechos_Iguais) :-
	integer(Elemento1),
	Elemento1 =\= Elemento2,
	Posicao_Inicial =\= 0,
	!,
	Posicao_Final is Contador - 1,
	Contador_Atualizado is Contador + 1,
	fitness(Trecho,Fitness),
	Cauda_Trecho = [],
	trechos_iguais(Lista1,Lista2,Contador_Atualizado,0-[0,0,Acumulador_Trecho/Acumulador_Trecho],Acumulador_Trechos_Iguais/Nova_Cauda_Trechos_Iguais,Trechos_Iguais).

trechos_iguais(_,_,_,_-[0,0,_/[]],Trechos_Iguais/[],Trechos_Iguais) :- !.

trechos_iguais(_,_,Contador,_-[Posicao_Inicial,0,Trecho/Cauda_Trecho],Trechos_Iguais/[Fitness-[Posicao_Inicial,Posicao_Final,Trecho]],Trechos_Iguais) :-
	Posicao_Inicial =\= 0,
	!,
	Posicao_Final is Contador - 1,
	fitness(Trecho,Fitness),
	Cauda_Trecho = [].

/* concatena_diferenca_de_lista(+Diferenca_De_Lista1,+Diferenca_De_Lista2,-Diferencas_De_Listas_Concatenadas) 
   Dadas duas diferenças de listas, concatena ambas:
		+Diferenca_De_Lista1 -> Primeira diferença de lista.
		+Diferenca_De_Lista2 -> Segunda diferença de lista.
		-Diferencas_De_Listas_Concatenadas -> Concatenação das diferenças de listas Diferenca_De_Lista1 e Diferenca_De_Lista2.
   Determinístico.
*/

concatena_diferenca_de_lista(A/B,B/C,A/C).

/* converte_lista_diferenca_de_lista(+Lista,-Diferenca_De_Lista) 
   Converte uma lista em uma diferença de lista.
		+Lista -> Lista a ser convertida em diferença de lista.
		-Diferencas_De_Lista -> Diferença de lista resultante de lista.
   Determinístico.
*/

converte_lista_diferenca_de_lista(Lista,Diferenca_De_Lista/Cauda_Diferenca_De_Lista) :- append(Lista, Cauda_Diferenca_De_Lista, Diferenca_De_Lista).
	
/* converte_diferenca_de_lista_lista(+Diferenca_De_Lista,-Lista) 
   Converte uma lista em uma diferença de lista.
		+Diferencas_De_Lista -> Diferença de lista a ser convertida em lista.
		-Lista -> Lista resultante da diferença de lista.
   Determinístico.
*/

converte_diferenca_de_lista_lista(Lista/[],Lista).

/* funcao_cantor(+Primeiro_Elemento,+Segundo_Elemento,-Funcao_Cantor) 
   Calcula a função de Cantor dados dois argumentos.
		+Primeiro_Elemento -> Primeiro elemento da função.
		+Segundo_Elemento -> Segundo elemento da função.
		-Funcao_Cantor -> Resultado da Função de Cantor para os dois elementos.
   Determinístico.
*/

funcao_cantor(Primeiro_Elemento,Segundo_Elemento,Funcao_Cantor) :-
	Funcao_Cantor is (((Primeiro_Elemento + Segundo_Elemento)*(Primeiro_Elemento+Segundo_Elemento+1))/2)+Segundo_Elemento.

/* pega_ultimo_elemento_lista_incompleta(+Lista_Incompleta,-Variavel) 
   Pega o último elemento (variável) de uma lista incompleta.
		+Lista_Incompleta -> Lista incompleta cujo último elemento se deseja.
		-Variavel -> Último elemento (variável) da lista incompleta.
   Determinístico.
*/

pega_ultimo_elemento_lista_incompleta(Elemento,Elemento) :- 
	var(Elemento),
	!.
	
pega_ultimo_elemento_lista_incompleta([_|Lista_Incompleta],Variavel) :- 
	pega_ultimo_elemento_lista_incompleta(Lista_Incompleta,Variavel).

/* pega_melhor_media_mediana_pior(+Populacao,-Melhor_Individuo,-Media,-Individuo_Mediana,-Pior_Individuo) 
   Retorna a média e mediana da população, onde:
		+Populacao -> População ordenada.
		-Melhor_Individuo -> Melhor indivíduo da população.
		-Media -> Média de Fitness da População.
		-Individuo_Mediana -> Indivíduo da Mediana da População.
		-Pior_Individuo -> Pior indivíduo da população.
   Determinístico.
*/

pega_melhor_media_mediana_pior([F-Melhor_Individuo|Restante_Populacao],F-Melhor_Individuo,Media,Individuo_Mediana,Pior_Individuo) :-
	length([F-Melhor_Individuo|Restante_Populacao],Tamanho_Populacao),
	(0 is Tamanho_Populacao mod 2 ->
		Indice_Mediana is (Tamanho_Populacao/2)
	 ;
		Indice_Mediana is (Tamanho_Populacao + 1)/2),

	peg_media_mediana_pior([F-Melhor_Individuo|Restante_Populacao],Tamanho_Populacao,Indice_Mediana,0,Media,Individuo_Mediana,Pior_Individuo).

/* peg_media_mediana_pior(+Populacao,+Tamanho_Populacao,+Metade_Tamanho_Populacao,+Soma_Fitness,-Media,-Individuo_Mediana,-Pior_Individuo) 
   Implementa pega_media_mediana/4, onde:
		+Populacao -> População ordenada.
		+Tamanho_Populacao -> Tamanho da população.
		+Indice_Mediana -> Índice onde se encontra o indivíduo da Mediana.
		+Soma_Fitness -> Soma das fitness para, ao final, calcular a média.
		-Media -> Média de Fitness da População.
		-Individuo_Mediana -> Indivíduo da Mediana da População.
		-Pior_Individuo -> Pior indivíduo da população.
   Determinístico.
*/	
peg_media_mediana_pior([F-Pior_Individuo],Tamanho_Populacao,_,Soma_Fitness,Media,_,F-Pior_Individuo) :-
	!,
	Soma_Fitness_Atualizada is Soma_Fitness + F,
	Media is Soma_Fitness_Atualizada/Tamanho_Populacao.

peg_media_mediana_pior([F-Individuo|Restante_Populacao],Tamanho_Populacao,1,Soma_Fitness,Media,Individuo_Mediana,Pior_Individuo) :-
	!,
	Soma_Fitness_Atualizada is Soma_Fitness + F,
	Individuo_Mediana = F-Individuo,
	peg_media_mediana_pior(Restante_Populacao,Tamanho_Populacao,_,Soma_Fitness_Atualizada,Media,_,Pior_Individuo).

peg_media_mediana_pior([F-_|Restante_Populacao],Tamanho_Populacao,Indice_Mediana,Soma_Fitness,Media,Individuo_Mediana,Pior_Individuo) :-
	Soma_Fitness_Atualizada is Soma_Fitness + F,
	Indice_Mediana_Atualizado is Indice_Mediana - 1, 
	peg_media_mediana_pior(Restante_Populacao,Tamanho_Populacao,Indice_Mediana_Atualizado,Soma_Fitness_Atualizada,Media,Individuo_Mediana,Pior_Individuo).

/*=======================================================================*/

/* criar_lista_duplamente_encadeada(+Individuo) 
 
*/

% Lista de apenas um elemento								
criar_lista_duplamente_encadeada(Sexo,[Primeiro_Elemento|Cauda_Lista]):-
	var(Cauda_Lista),
	!,
	asserta(lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Primeiro_Elemento,Primeiro_Elemento)).

% Lista de dois elementos
criar_lista_duplamente_encadeada(Sexo,[Primeiro_Elemento,Segundo_Elemento|Cauda_Lista]):-
	var(Cauda_Lista),
	!,
	asserta(lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Segundo_Elemento,Segundo_Elemento)),
	assertz(lista_duplamente_encadeada(Sexo,Segundo_Elemento,Primeiro_Elemento,Primeiro_Elemento)).	

% Lista com mais de dois elementos	
criar_lista_duplamente_encadeada(Sexo,[Primeiro_Elemento,Segundo_Elemento|Restante_Trajeto]):-
	criar_lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Segundo_Elemento,Primeiro_Elemento,[Segundo_Elemento|Restante_Trajeto]).	

criar_lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Segundo_Elemento,Elemento_Anterior,[Ultimo_Elemento|Cauda_Lista]) :- 
	var(Cauda_Lista),
	!,
	asserta(lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Ultimo_Elemento,Segundo_Elemento)),
	assertz(lista_duplamente_encadeada(Sexo,Ultimo_Elemento,Elemento_Anterior,Primeiro_Elemento)).

criar_lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Segundo_Elemento,Elemento_Anterior,[Elemento_Atual,Proximo_Elemento|Restante_Trajeto]) :- 
	assertz(lista_duplamente_encadeada(Sexo,Elemento_Atual,Elemento_Anterior,Proximo_Elemento)),
	criar_lista_duplamente_encadeada(Sexo,Primeiro_Elemento,Segundo_Elemento,Elemento_Atual,[Proximo_Elemento|Restante_Trajeto]).

remover_elemento_lista_duplamente_encadeada(Sexo,Elemento) :-
	lista_duplamente_encadeada(Sexo,Elemento,Anterior_Elemento,Proximo_Elemento),
	(Elemento = Anterior_Elemento ->
		retract(lista_duplamente_encadeada(Sexo,Elemento,Elemento,Elemento))
	 ;
		(Anterior_Elemento = Proximo_Elemento ->
				retract(lista_duplamente_encadeada(Sexo,Elemento,Anterior_Elemento,Anterior_Elemento)),
				retract(lista_duplamente_encadeada(Sexo,Anterior_Elemento,Elemento,Elemento)),
				asserta(lista_duplamente_encadeada(Sexo,Anterior_Elemento,Anterior_Elemento,Anterior_Elemento))
				
		 ;
			retract(lista_duplamente_encadeada(Sexo,Elemento,Anterior_Elemento,Proximo_Elemento)),
			retract(lista_duplamente_encadeada(Sexo,Anterior_Elemento,Anterior_Anterior_Elemento,Elemento)),
			retract(lista_duplamente_encadeada(Sexo,Proximo_Elemento,Elemento,Proximo_Proximo_Elemento)),
			assertz(lista_duplamente_encadeada(Sexo,Anterior_Elemento,Anterior_Anterior_Elemento,Proximo_Elemento)),
			assertz(lista_duplamente_encadeada(Sexo,Proximo_Elemento,Anterior_Elemento,Proximo_Proximo_Elemento))
		)
	).

anterior_proximo_elementos_lista_duplamente_encadeada(Sexo,Elemento,Anterior_Elemento,Proximo_Elemento) :-
	lista_duplamente_encadeada(Sexo,Elemento,Anterior_Elemento,Proximo_Elemento),
	remover_elemento_lista_duplamente_encadeada(Sexo,Elemento).
	
remover_lista_duplamente_encadeada(Sexo) :-
	retractall(lista_duplamente_encadeada(Sexo,_,_,_)).


	






