/* substitui_enesimo(+Posição,+Lista,+Elemento,-Lista_Com_Elemento)
   Substitui um elemento em determinada posição na lista por outro elemento, onde:
		+Posição -> Posição do elemento que será substituído (inicia de 1)
		+Lista -> Lista cujo elemento se deseeja substituir.
		+Elemento -> Elemento que substituirá o elemento atual da lista.
		-Lista_Com_Elemento -> Lista após a substituição do elemento.
   Determinístico.
*/
substitui_enesimo(1,[_|Lista],Elemento,[Elemento|Lista]):-!.
substitui_enesimo(Posicao,[Proximo_Elemento|Lista],Elemento,[Proximo_Elemento|Lista_Com_Elemento]):-
    Posicao_Atualizada is Posicao - 1,
    substitui_enesimo(Posicao_Atualizada,Lista,Elemento,Lista_Com_Elemento).

/* extrair_sublistas(+Posicao_Inicial,+Posicao_Final,+Lista,-Prefixo,-Nucleo,-Sufixo) 
   Dada uma Lista, extrai três sublistas, onde:
		+Posicao_Inicial -> Posição de início da lista Núcleo.
		+Posicao_Final -> Posição de término da lista Núcleo.
		+Lista -> Diferença de lista a ser dividida em 3 diferenças de listas: Prefixo, Núcleo e Sufixo.
		-Prefixo -> Primeira diferença de lista que vai da posição 1 até (Posicao_Inicial - 1).
		-Nucleo -> Segunda diferença de lista que vai da posição Posicao_Inicial até Posicao_Final.
		-Sufixo -> Terceira diferença de lista que vai da posição Posicao_Final + 1 até o final de Lista. 
	Determinístico.
*/
extrair_sublistas(Posicao_Inicial,Posicao_Final,Lista,Prefixo,Nucleo,Sufixo):-
	extrair_sublistas(Posicao_Inicial,Posicao_Final,Lista,Cauda_do_Acumulador_do_Prefixo/Cauda_do_Acumulador_do_Prefixo,Cauda_do_Acumulador_do_Nucleo/Cauda_do_Acumulador_do_Nucleo,Prefixo,Nucleo,Sufixo).

/* extrair_sublistas(+Posicao_Inicial,+Posicao_Final,+Lista,+Acumulador_do_Prefixo,+Acumulador_do_Nucleo,-Prefixo,-Nucleo,-Sufixo) 
   Implementa extrair_sublistas/6, onde:
		+Posicao_Inicial -> Posição de início da diferença de lista Núcleo.
		+Posicao_Final -> Posição de término da diferença de lista Núcleo.
		+Lista -> Diferença de lista a ser dividida em 3 diferenças de listas: Prefixo, Núcleo e Sufixo.
		+Acumulador_do_Prefixo -> Acumulador diferença de lista que será preenchido até formar Prefixo.
		+Acumulador_do_Nucleo -> Acumulador diferença de lista que será preenchido até formar Nucleo.
		-Prefixo -> Primeira diferença de lista que vai da posição 1 até (Posicao_Inicial - 1).
		-Nucleo -> Segunda diferença de lista que vai da posição Posicao_Inicial até Posicao_Final.
		-Sufixo -> Terceira diferença de lista que vai da posição Posicao_Final + 1 até o final de Lista. 
   Usando os acumuladores Acumulador_do_Prefixo, Acumulador_do_Nucleo e a própria lista Lista para chegar nas listas Prefixo, Nucleo e Sufixo.  
   Determinístico.

*/

extrair_sublistas(1,1,[Elemento|Resto_da_Lista]/Cauda_da_Lista,Prefixo,Nucleo/[Elemento|Cauda_do_Nucleo],Prefixo,Nucleo/Cauda_do_Nucleo,Sufixo) :- 
	!,
	copy_term(Resto_da_Lista/Cauda_da_Lista,Sufixo).

extrair_sublistas(1,Posicao_Final,[Elemento|Lista]/Cauda_da_Lista,Acumulador_do_Prefixo,Acumulador_do_Nucleo/[Elemento|Cauda_do_Acumulador_do_Nucleo],Prefixo,Nucleo,Sufixo) :-
	!,
	Posicao_Final_Atualizada is Posicao_Final-1,
	extrair_sublistas(1,Posicao_Final_Atualizada,Lista/Cauda_da_Lista,Acumulador_do_Prefixo,Acumulador_do_Nucleo/Cauda_do_Acumulador_do_Nucleo,Prefixo,Nucleo,Sufixo).

extrair_sublistas(Posicao_Inicial,Posicao_Final,[Elemento|Lista]/Cauda_da_Lista,Acumulador_do_Prefixo/[Elemento|Cauda_do_Acumulador_do_Prefixo],Acumulador_do_Nucleo,Prefixo,Nucleo,Sufixo) :-
	Posicao_Inicial_Atualizada is Posicao_Inicial-1,
	Posicao_Final_Atualizada is Posicao_Final-1,
	extrair_sublistas(Posicao_Inicial_Atualizada,Posicao_Final_Atualizada,Lista/Cauda_da_Lista,Acumulador_do_Prefixo/Cauda_do_Acumulador_do_Prefixo,Acumulador_do_Nucleo,Prefixo,Nucleo,Sufixo).

/* cortar_cauda(+Lista,+Posicao,-Lista_Cortada) 
   Dada uma lista, corta todos os elementos da cauda daquela lista, onde:
		+Lista -> Lista cuja calda será cortada.
		+Posicao -> Posição de término da lista e onde, a partir do próximo elemento, será considerado cauda.
		-Lista_Cortada -> Lista sem a cauda.
   Determinístico.
*/
cortar_cauda(Lista,Posicao,Lista_Cortada):-
	cortar_cauda(Lista,Posicao,Cauda_da_Diferenca_de_Lista/Cauda_da_Diferenca_de_Lista,Lista_Cortada).

/* cortar_cauda(+Lista,+Posicao,+Lista_Cortada_Parcial,-Lista_Cortada) 
   Implementa cortar_cauda/3, onde:
		+Lista -> Lista cuja calda será cortada.
		+Posicao -> Posição de término da lista e onde, a partir do próximo elemento, será considerado cauda.
		+Lista_Cortada_Parcial -> Acumulador que será preenchido até formar Lista_Cortada.
		-Lista_Cortada -> Lista sem a cauda.
   Determinístico.
*/

cortar_cauda(_,0,Diferenca_de_Lista_Cortada,Lista_Cortada) :-
	!,
	converte_diferenca_de_lista_em_lista(Diferenca_de_Lista_Cortada,Lista_Cortada).

cortar_cauda([],_,Diferenca_de_Lista_Cortada,Lista_Cortada) :-
	!,
	converte_diferenca_de_lista_em_lista(Diferenca_de_Lista_Cortada,Lista_Cortada).

cortar_cauda([Elemento|Lista],Posicao,Lista_Cortada_Parcial/[Elemento|Cauda_da_Diferenca_de_Lista],Lista_Cortada) :-
	Posicao_Atualizada is Posicao-1,
	cortar_cauda(Lista,Posicao_Atualizada,Lista_Cortada_Parcial/Cauda_da_Diferenca_de_Lista,Lista_Cortada).

/* numero_de_elementos_iguais(+Lista1,+Lista2,-Numero_de_Elementos_Iguais) 
   Dadas duas listas, calcula o número de elementos iguais na mesma posição entre elas, onde:
		+Lista1 -> Primeira lista.
		+Lista2 -> Segunda lista.
		-Numero_de_Elementos_Iguais -> Número de elementos iguais na mesma posição em Lista1 e Lista2.
   Determinístico.
*/
										
numero_de_elementos_iguais(_-Inviduo1,_-Individuo2,Numero_de_Elementos_Iguais):-
	numero_de_elementos_iguais(Inviduo1,Individuo2,0,Numero_de_Elementos_Iguais).	

/* numero_de_elementos_iguais(+Lista1,+Lista2,+Numero_de_Elementos_Iguais_Parcial,-Numero_de_Elementos_Iguais) 
   Implementa numero_de_elementos_iguais/3, onde:
		+Lista1 -> Primeira lista.
		+Lista2 -> Segunda lista.
		+Numero_de_Elementos_Iguais_Parcial -> Contador que irá ser incrementado com o número de cidades iguais
		-Numero_de_Elementos_Iguais -> Número de elementos iguais na mesma posição em Lista1 e Lista2.
   Determinístico.
*/	

numero_de_elementos_iguais(Cauda_da_Primeira_Diferenca_de_Lista/Cauda_da_Primeira_Diferenca_de_Lista,_,Numero_de_Elementos_Iguais,Numero_de_Elementos_Iguais) :- 
	var(Cauda_da_Primeira_Diferenca_de_Lista),
	!.

numero_de_elementos_iguais([Elemento|Lista1]/Cauda_da_Primeira_Diferenca_de_Lista,[Elemento|Lista2]/Cauda_da_Segunda_Diferenca_de_Lista,Numero_de_Elementos_Iguais_Parcial,Numero_de_Elementos_Iguais) :- 
	!,
	Numero_de_Elementos_Iguais_Parcial_Atualizado is Numero_de_Elementos_Iguais_Parcial + 1,
	numero_de_elementos_iguais(Lista1/Cauda_da_Primeira_Diferenca_de_Lista,Lista2/Cauda_da_Segunda_Diferenca_de_Lista,Numero_de_Elementos_Iguais_Parcial_Atualizado,Numero_de_Elementos_Iguais).
	
numero_de_elementos_iguais([_|Lista1]/Cauda_da_Primeira_Diferenca_de_Lista,[_|Lista2]/Cauda_da_Segunda_Diferenca_de_Lista,Contador,Numero_de_Elementos_Iguais) :- 
	numero_de_elementos_iguais(Lista1/Cauda_da_Primeira_Diferenca_de_Lista,Lista2/Cauda_da_Segunda_Diferenca_de_Lista,Contador,Numero_de_Elementos_Iguais).

/* trechos_iguais(+Lista1,+Lista2,-Trechos_Iguais) 
   Dadas duas listas, retorna os trechos pertencentes a ambas na mesma, onde:
		+Lista1 -> Primeira lista.
		+Lista2 -> Segunda lista.
		-Trechos_Iguais -> Trechos iguais em ambas as listas.
	Determinístico.
*/
trechos_iguais(Lista1,Lista2,Trechos_Iguais) :-
	copy_term(Lista1,Lista1_Copiada),
	copy_term(Lista2,Lista2_Copiada),
	trechos_iguais(Lista1_Copiada,Lista2_Copiada,1,0-[0,0,Cauda_do_Acumulador_de_Trecho/Cauda_do_Acumulador_de_Trecho],Cauda_do_Acumulador_de_Trechos_Iguais/Cauda_do_Acumulador_de_Trechos_Iguais,Trechos_Iguais).

/* trechos_iguais(+Lista1,+Lista2,+Posicao_Avaliada,+Acumulador_de_Trecho,+Acumulador_de_Trechos_Iguais,-Trechos_Iguais) 
   Implementa trechos_iguais/3, onde:
		+Lista1 -> Primeira lista.
		+Lista2 -> Segunda lista.
		+Posicao_Avaliada -> Posição que está sendo analisada em ambas as listas.
		+Acumulador_de_Trecho -> Acumulador de trecho igual de ambas as listas
		+Acumulador_de_Trechos_Iguais -> Acumulador de trechos iguais de ambas as listas
		-Trechos_Iguais -> Trechos iguais em ambas as listas.
	Determinístico.
*/
trechos_iguais([Elemento|Lista1],[Elemento|Lista2],Posicao_Avaliada,_-[0,0,Trecho/[Elemento|Cauda_do_Trecho_Igual]],Acumulador_de_Trechos_Iguais,Trechos_Iguais) :-
	integer(Elemento),
	!,
	Posicao_Avaliada_Atualizada is Posicao_Avaliada + 1,
	trechos_iguais(Lista1,Lista2,Posicao_Avaliada_Atualizada,_-[Posicao_Avaliada,0,Trecho/Cauda_do_Trecho_Igual],Acumulador_de_Trechos_Iguais,Trechos_Iguais).
	
trechos_iguais([Elemento|Lista1],[Elemento|Lista2],Posicao_Avaliada,_-[Posicao_Inicial,_,Trecho/[Elemento|Cauda_do_Trecho_Igual]],Acumulador_de_Trechos_Iguais,Trechos_Iguais) :-
	integer(Elemento),
	!,
	Posicao_Avaliada_Atualizada is Posicao_Avaliada + 1,
	trechos_iguais(Lista1,Lista2,Posicao_Avaliada_Atualizada,_-[Posicao_Inicial,_,Trecho/Cauda_do_Trecho_Igual],Acumulador_de_Trechos_Iguais,Trechos_Iguais).
	
trechos_iguais([Elemento1|Lista1],[Elemento2|Lista2],Posicao_Avaliada,_-[0,0,Trecho/Cauda_do_Trecho_Igual],Acumulador_de_Trechos_Iguais,Trechos_Iguais) :-
	integer(Elemento1),
	Elemento1 =\= Elemento2,
	!,
	Posicao_Avaliada_Atualizada is Posicao_Avaliada + 1,
	trechos_iguais(Lista1,Lista2,Posicao_Avaliada_Atualizada,0-[0,0,Trecho/Cauda_do_Trecho_Igual],Acumulador_de_Trechos_Iguais,Trechos_Iguais).
	
trechos_iguais([Elemento1|Lista1],[Elemento2|Lista2],Posicao_Avaliada,_-[Posicao_Inicial,0,Trecho/Cauda_do_Trecho_Igual],Acumulador_de_Trechos_Iguais/[Fitness-[Posicao_Inicial,Posicao_Final,Trecho/Cauda_do_Trecho_Igual]|Cauda_do_Acumulador_de_Trechos_Iguais],Trechos_Iguais) :-
	integer(Elemento1),
	Elemento1 =\= Elemento2,
	Posicao_Inicial =\= 0,
	!,
	Posicao_Final is Posicao_Avaliada - 1,
	Posicao_Avaliada_Atualizada is Posicao_Avaliada + 1,
	fitness(Trecho,Fitness),
	trechos_iguais(Lista1,Lista2,Posicao_Avaliada_Atualizada,0-[0,0,Cauda_do_Acumulador_de_Trecho/Cauda_do_Acumulador_de_Trecho],Acumulador_de_Trechos_Iguais/Cauda_do_Acumulador_de_Trechos_Iguais,Trechos_Iguais).

trechos_iguais(Cauda_da_Primeira_Diferenca_de_Lista/Cauda_da_Primeira_Diferenca_de_Lista,_,_,_-[0,0,_/[]],Trechos_Iguais/[],Trechos_Iguais_Ordenados) :- 
	var(Cauda_da_Primeira_Diferenca_de_Lista),
	!,
	sort(1, @>=, Trechos_Iguais, Trechos_Iguais_Ordenados).

trechos_iguais(Cauda_da_Primeira_Diferenca_de_Lista/Cauda_da_Primeira_Diferenca_de_Lista,_,Posicao_Avaliada,_-[Posicao_Inicial,0,Trecho/Cauda_do_Trecho_Igual],Trechos_Iguais/[Fitness-[Posicao_Inicial,Posicao_Final,Trecho/Cauda_do_Trecho_Igual]],Trechos_Iguais_Ordenados) :-
	Posicao_Inicial =\= 0,
	var(Cauda_da_Primeira_Diferenca_de_Lista),
	!,
	Posicao_Final is Posicao_Avaliada - 1,
	fitness(Trecho,Fitness),
	sort(1, @>=, Trechos_Iguais, Trechos_Iguais_Ordenados).

/* concatena_diferenca_de_lista(+Diferenca_de_Lista1,+Diferenca_de_Lista2,-Diferencas_De_Listas_Concatenadas) 
   Dadas duas diferenças de listas, concatena ambas, onde:
		+Diferenca_de_Lista1 -> Primeira diferença de lista.
		+Diferenca_de_Lista2 -> Segunda diferença de lista.
		-Diferencas_De_Listas_Concatenadas -> Concatenação das diferenças de listas Diferenca_de_Lista1 e Diferenca_de_Lista2.
   Determinístico.
*/

concatena_diferenca_de_lista(Diferenca_de_Lista1/Cauda_da_Diferenca_de_Lista1,Cauda_da_Diferenca_de_Lista1/Cauda_da_Diferenca_de_Lista2,Diferenca_de_Lista1/Cauda_da_Diferenca_de_Lista2).

/* converte_lista_em_diferenca_de_lista(+Lista,-Diferenca_de_Lista) 
   Converte uma lista em uma diferença de lista.
		+Lista -> Lista a ser convertida em diferença de lista.
		-Diferenca_de_Lista -> Diferença de lista resultante de lista.
   Determinístico.
*/

converte_lista_em_diferenca_de_lista(Lista,Diferenca_de_Lista/Cauda_da_Diferenca_de_Lista) :- append(Lista, Cauda_da_Diferenca_de_Lista, Diferenca_de_Lista).
	
/* converte_diferenca_de_lista_em_lista(+Diferenca_de_Lista,-Lista) 
   Converte uma lista em uma diferença de lista.
		+Diferenca_de_Lista -> Diferença de lista a ser convertida em lista.
		-Lista -> Lista resultante da diferença de lista.
   Determinístico.
*/

converte_diferenca_de_lista_em_lista(Lista/[],Lista).

/* funcao_de_paridade_de_cantor(+Primeiro_Elemento,+Segundo_Elemento,-Funcao_de_Paridade_de_Cantor) 
   Calcula a função de paridade de Cantor dados dois argumentos.
		+Primeiro_Elemento -> Primeiro elemento da função.
		+Segundo_Elemento -> Segundo elemento da função.
		-Funcao_de_Paridade_de_Cantor -> Resultado da Função de Cantor para os dois elementos.
   Determinístico.
*/

funcao_de_paridade_de_cantor(Primeiro_Elemento,Segundo_Elemento,Funcao_de_Paridade_de_Cantor) :-
	Funcao_de_Paridade_de_Cantor is (((Primeiro_Elemento + Segundo_Elemento)*(Primeiro_Elemento+Segundo_Elemento+1))/2)+Segundo_Elemento.

/* pega_ultimo_elemento_da_lista_incompleta(+Lista_Incompleta,-Ultimo_Elemento_da_Lista_Incompleta) 
   Pega o último elemento (variável) de uma lista incompleta.
		+Lista_Incompleta -> Lista incompleta cujo último elemento se deseja.
		-Ultimo_Elemento_da_Lista_Incompleta -> Último elemento (variável) da lista incompleta.
   Determinístico.
*/

pega_ultimo_elemento_da_lista_incompleta(Elemento,Elemento) :- 
	var(Elemento),
	!.
	
pega_ultimo_elemento_da_lista_incompleta([_|Lista_Incompleta],Ultimo_Elemento_da_Lista_Incompleta) :- 
	pega_ultimo_elemento_da_lista_incompleta(Lista_Incompleta,Ultimo_Elemento_da_Lista_Incompleta).

/* pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo(+Populacao,-Melhor_Individuo,-Media,-Individuo_da_Mediana,-Pior_Individuo) 
   Retorna a média e mediana da população, onde:
		+Populacao -> População ordenada.
		-Melhor_Individuo -> Melhor indivíduo da população.
		-Media -> Média de Fitness da População.
		-Individuo_da_Mediana -> Indivíduo da Mediana da População.
		-Pior_Individuo -> Pior indivíduo da população.
   Determinístico.
*/

pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo([Fitness_do_Melhor_Individuo-Melhor_Individuo|Populacao_Restante],Fitness_do_Melhor_Individuo-Melhor_Individuo,Media,Individuo_da_Mediana,Pior_Individuo) :-
	length([Fitness_do_Melhor_Individuo-Melhor_Individuo|Populacao_Restante],Tamanho_da_Populacao),
	(0 is Tamanho_da_Populacao mod 2 ->
		Indice_da_Mediana is (Tamanho_da_Populacao/2)
	 ;
		Indice_da_Mediana is (Tamanho_da_Populacao + 1)/2
	),

	pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo([Fitness_do_Melhor_Individuo-Melhor_Individuo|Populacao_Restante],Tamanho_da_Populacao,Indice_da_Mediana,0,Media,Individuo_da_Mediana,Pior_Individuo).

/* pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo(+Populacao,+Tamanho_da_Populacao,+Metade_Tamanho_da_Populacao,+Soma_de_Fitness,-Media,-Individuo_da_Mediana,-Pior_Individuo) 
   Implementa pega_media_mediana/4, onde:
		+Populacao -> População ordenada.
		+Tamanho_da_Populacao -> Tamanho da população.
		+Indice_da_Mediana -> Índice onde se encontra o indivíduo da Mediana.
		+Soma_de_Fitness -> Soma das fitness para, ao final, calcular a média.
		-Media -> Média de Fitness da População.
		-Individuo_da_Mediana -> Indivíduo da Mediana da População.
		-Pior_Individuo -> Pior indivíduo da população.
   Determinístico.
*/	
pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo([Fitness_do_Pior_Individuo-Pior_Individuo],Tamanho_da_Populacao,_,Soma_de_Fitness,Media,_,Fitness_do_Pior_Individuo-Pior_Individuo) :-
	!,
	Soma_de_Fitness_Atualizada is Soma_de_Fitness + Fitness_do_Pior_Individuo,
	Media is Soma_de_Fitness_Atualizada/Tamanho_da_Populacao.

pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo([Fitness-Individuo|Populacao_Restante],Tamanho_da_Populacao,1,Soma_de_Fitness,Media,Individuo_da_Mediana,Pior_Individuo) :-
	!,
	Soma_de_Fitness_Atualizada is Soma_de_Fitness + Fitness,
	Individuo_da_Mediana = Fitness-Individuo,
	pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo(Populacao_Restante,Tamanho_da_Populacao,_,Soma_de_Fitness_Atualizada,Media,_,Pior_Individuo).

pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo([Fitness-_|Populacao_Restante],Tamanho_da_Populacao,Indice_da_Mediana,Soma_de_Fitness,Media,Individuo_da_Mediana,Pior_Individuo) :-
	Soma_de_Fitness_Atualizada is Soma_de_Fitness + Fitness,
	Indice_da_Mediana_Atualizado is Indice_da_Mediana - 1, 
	pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo(Populacao_Restante,Tamanho_da_Populacao,Indice_da_Mediana_Atualizado,Soma_de_Fitness_Atualizada,Media,Individuo_da_Mediana,Pior_Individuo).

/* criar_lista_duplamente_encadeada(+Pai_ou_Mae,+Lista_Incompleta) 
   Cria uma lista duplamente encadeada com assert, onde:
		+Pai_ou_Mae -> Qual o papel da lista duplamente encadeada no crossover.
		+Lista_Incompleta -> Lista incompleta que gerará a lista duplamente encadeada.
   Determinístico.
*/	
% Lista de apenas um elemento								
criar_lista_duplamente_encadeada(Pai_ou_Mae,[Primeiro_Elemento|Cauda_da_Lista]):-
	var(Cauda_da_Lista),
	!,
	asserta(lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Primeiro_Elemento,Primeiro_Elemento)).

% Lista de dois elementos
criar_lista_duplamente_encadeada(Pai_ou_Mae,[Primeiro_Elemento,Segundo_Elemento|Cauda_da_Lista]):-
	var(Cauda_da_Lista),
	!,
	asserta(lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Segundo_Elemento,Segundo_Elemento)),
	assertz(lista_duplamente_encadeada(Pai_ou_Mae,Segundo_Elemento,Primeiro_Elemento,Primeiro_Elemento)).

% Lista com mais de dois elementos	
criar_lista_duplamente_encadeada(Pai_ou_Mae,[Primeiro_Elemento,Segundo_Elemento|Restante_do_Trajeto]):-
	criar_lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Segundo_Elemento,Primeiro_Elemento,[Segundo_Elemento|Restante_do_Trajeto]).		

/* criar_lista_duplamente_encadeada(+Pai_ou_Mae,+Primeiro_Elemento,+Segundo_Elemento,+Elemento_Anterior,+Lista_Incompleta) 
   Cria uma lista duplamente encadeada com assert, onde:
		+Pai_ou_Mae -> Qual o papel da lista duplamente encadeada no crossover.
		+Primeiro_Elemento -> Primeira cidade do caminho (necessária ao final para fazer a dupla de ponteiros da última cidade).
		+Segundo_Elemento -> Segunda cidade do caminho (necessária ao final para fazer a dupla de ponteiros da primeira cidade).
		+Elemento_Anterior -> Último elemento do caminho até o momento.
		+Lista_Incompleta -> Lista incompleta que gerará a lista duplamente encadeada.
   Determinístico.
*/		

criar_lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Segundo_Elemento,Elemento_Anterior,[Ultimo_Elemento_da_Lista_Incompleta|Cauda_da_Lista]) :- 
	var(Cauda_da_Lista),
	!,
	asserta(lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Ultimo_Elemento_da_Lista_Incompleta,Segundo_Elemento)),
	assertz(lista_duplamente_encadeada(Pai_ou_Mae,Ultimo_Elemento_da_Lista_Incompleta,Elemento_Anterior,Primeiro_Elemento)).
	
criar_lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Segundo_Elemento,Elemento_Anterior,[Elemento_Atual,Elemento_Posterior|Restante_do_Trajeto]) :- 
	assertz(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Atual,Elemento_Anterior,Elemento_Posterior)),
	criar_lista_duplamente_encadeada(Pai_ou_Mae,Primeiro_Elemento,Segundo_Elemento,Elemento_Atual,[Elemento_Posterior|Restante_do_Trajeto]).

/* remover_elemento_da_lista_duplamente_encadeada(+Pai_ou_Mae,+Elemento) 
   Remove um elemento de uma lista duplamente encadeada, onde:
		+Pai_ou_Mae -> Qual o papel da lista duplamente encadeada no crossover.
		+Elemento -> Elemento que será excluído da lista duplamente encadeada.
   Determinístico.
*/	
/*remover_elemento_da_lista_duplamente_encadeada(Pai_ou_Mae,Elemento) :-
	lista_duplamente_encadeada(Pai_ou_Mae,Elemento,Elemento_Anterior,Elemento_Posterior),
	(Elemento = Elemento_Anterior ->
		retract(lista_duplamente_encadeada(Pai_ou_Mae,Elemento,Elemento,Elemento))
	 ;
		(Elemento_Anterior = Elemento_Posterior ->
				retract(lista_duplamente_encadeada(Pai_ou_Mae,Elemento,Elemento_Anterior,Elemento_Anterior)),
				retract(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Anterior,Elemento,Elemento)),
				asserta(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Anterior,Elemento_Anterior,Elemento_Anterior))
				
		 ;
			retract(lista_duplamente_encadeada(Pai_ou_Mae,Elemento,Elemento_Anterior,Elemento_Posterior)),
			retract(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Anterior,Elemento_Anterior_ao_Anterior,Elemento)),
			retract(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Posterior,Elemento,Elemento_Posterior_ao_Posterior)),
			assertz(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Anterior,Elemento_Anterior_ao_Anterior,Elemento_Posterior)),
			assertz(lista_duplamente_encadeada(Pai_ou_Mae,Elemento_Posterior,Elemento_Anterior,Elemento_Posterior_ao_Posterior))
		)
	).*/
	
/* remover_elemento_da_lista_duplamente_encadeada(+Lista_Duplamente_Encadeada,+Elemento) 
   Remove um elemento de uma lista duplamente encadeada, onde:
		+Lista_Duplamente_Encadeada -> Lista duplamente encadeada cujo elemento se deseja remover.
		+Elemento -> Elemento que será excluído da lista duplamente encadeada.
   Determinístico.
*/	
remover_elemento_da_lista_duplamente_encadeada(Lista_Duplamente_Encadeada,Elemento) :-
	hashtable:ht_delete(Lista_Duplamente_Encadeada,Elemento,[Elemento_Anterior,Elemento_Posterior]),

	(Elemento = Elemento_Anterior ->
		true
	 ;
		hashtable:ht_delete(Lista_Duplamente_Encadeada,Elemento_Anterior,[Elemento_Anterior_ao_Anterior,_]),
		(Elemento_Anterior = Elemento_Posterior ->
			ht_put(Lista_Duplamente_Encadeada,Elemento_Anterior,[Elemento_Anterior,Elemento_Anterior])
		 ;
			hashtable:ht_delete(Lista_Duplamente_Encadeada,Elemento_Posterior,[_,Elemento_Posterior_ao_Posterior]),
			ht_put(Lista_Duplamente_Encadeada,Elemento_Anterior,[Elemento_Anterior_ao_Anterior,Elemento_Posterior]),
			ht_put(Lista_Duplamente_Encadeada,Elemento_Posterior,[Elemento_Anterior,Elemento_Posterior_ao_Posterior])
		)
	).

/* pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(+Pai_ou_Mae,+Elemento,-Elemento_Anterior,-Elemento_Posterior) 
   Remove um elemento de uma lista duplamente encadeada, onde:
		+Pai_ou_Mae -> Qual o papel da lista duplamente encadeada no crossover.
		+Elemento -> Elemento cujos elementos anterior e posterior serão pegos.
		-Elemento_Anterior -> Elemento anterior a Elemento na lista duplamente encadeada.
		-Elemento_Posterior -> Elemento posterior a Elemento na lista duplamente encadeada. 
   Determinístico.
*/	
/*pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(Pai_ou_Mae,Elemento,Elemento_Anterior,Elemento_Posterior) :-
	lista_duplamente_encadeada(Pai_ou_Mae,Elemento,Elemento_Anterior,Elemento_Posterior),
	remover_elemento_da_lista_duplamente_encadeada(Pai_ou_Mae,Elemento).*/

/* pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(+Lista_Duplamente_Encadeada,+Elemento,-Elemento_Anterior,-Elemento_Posterior) 
   Remove um elemento de uma lista duplamente encadeada, onde:
		+Lista_Duplamente_Encadeada -> Lista duplamente encadeada cujos elementos se deseja pegar.
		+Elemento -> Elemento cujos elementos anterior e posterior serão pegos.
		-Elemento_Anterior -> Elemento anterior a Elemento na lista duplamente encadeada.
		-Elemento_Posterior -> Elemento posterior a Elemento na lista duplamente encadeada. 
   Determinístico.
*/	
pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(Lista_Duplamente_Encadeada,Elemento,Elemento_Anterior,Elemento_Posterior) :-
	hashtable:ht_get(Lista_Duplamente_Encadeada,Elemento,[Elemento_Anterior,Elemento_Posterior]),
	remover_elemento_da_lista_duplamente_encadeada(Lista_Duplamente_Encadeada,Elemento).

/* remover_lista_duplamente_encadeada(+Pai_ou_Mae,+Elemento) 
   Remove completamente a lista duplamente encadeada, onde:
		+Pai_ou_Mae -> Qual o papel da lista duplamente encadeada no crossover.
   Determinístico.
*/	
remover_lista_duplamente_encadeada(Pai_ou_Mae) :-
	retractall(lista_duplamente_encadeada(Pai_ou_Mae,_,_,_)).
	

/* criar_lista_duplamente_encadeada_com_key_value(+Lista_Incompleta, -Lista_Duplamente_Encadeada_com_Key_Value) 
   Cria uma lista duplamente encadeada utilizando key value, onde:
		+Lista_Incompleta -> Lista incompleta que gerará a lista duplamente encadeada.
		-Lista_Duplamente_Encadeada_com_Key_Value -> Lista Duplamente Encadeada usando Key Value
   Determinístico.
*/	
% Lista de apenas um elemento								
criar_lista_duplamente_encadeada_com_key_value([Primeiro_Elemento|Cauda_da_Lista],Primeiro_Elemento-[Primeiro_Elemento,Primeiro_Elemento]):-
	var(Cauda_da_Lista),
	!.

% Lista de dois elementos
criar_lista_duplamente_encadeada_com_key_value([Primeiro_Elemento,Segundo_Elemento|Cauda_da_Lista],[Primeiro_Elemento-[Segundo_Elemento,Segundo_Elemento],Segundo_Elemento-[Primeiro_Elemento,Primeiro_Elemento]]):-
	var(Cauda_da_Lista),
	!.

% Lista com mais de dois elementos	
criar_lista_duplamente_encadeada_com_key_value([Primeiro_Elemento,Segundo_Elemento|Restante_do_Trajeto],Lista_Duplamente_Encadeada_com_Key_Value):-
	criar_lista_duplamente_encadeada_com_key_value(Primeiro_Elemento,Segundo_Elemento,Primeiro_Elemento,[Segundo_Elemento|Restante_do_Trajeto],[],Lista_Duplamente_Encadeada_com_Key_Value).		

/* criar_lista_duplamente_encadeada_com_key_value(+Primeiro_Elemento,+Segundo_Elemento,+Elemento_Anterior,+Lista_Incompleta,+Lista_Duplamente_Encadeada_com_Key_Value_Parcial,-Lista_Duplamente_Encadeada_com_Key_Value) 
   Cria uma lista duplamente encadeada com assert, onde:
		+Primeiro_Elemento -> Primeira cidade do caminho (necessária ao final para fazer a dupla de ponteiros da última cidade).
		+Segundo_Elemento -> Segunda cidade do caminho (necessária ao final para fazer a dupla de ponteiros da primeira cidade).
		+Elemento_Anterior -> Último elemento do caminho até o momento.
		+Lista_Incompleta -> Lista incompleta que gerará a lista duplamente encadeada.
		+Lista_Duplamente_Encadeada_com_Key_Value_Parcial -> Acumulador a ser preenchido até formar Lista_Duplamente_Encadeada_com_Key_Value.
		-Lista_Duplamente_Encadeada_com_Key_Value -> Lista Duplamente Encadeada usando Key Value
   Determinístico.
*/			

criar_lista_duplamente_encadeada_com_key_value(Primeiro_Elemento,Segundo_Elemento,Elemento_Anterior,[Ultimo_Elemento_da_Lista_Incompleta|Cauda_da_Lista],Lista_Duplamente_Encadeada_com_Key_Value_Parcial,[Primeiro_Elemento-[Ultimo_Elemento_da_Lista_Incompleta,Segundo_Elemento],Ultimo_Elemento_da_Lista_Incompleta-[Elemento_Anterior,Primeiro_Elemento]|Lista_Duplamente_Encadeada_com_Key_Value_Parcial]) :- 
	var(Cauda_da_Lista),
	!.
	
criar_lista_duplamente_encadeada_com_key_value(Primeiro_Elemento,Segundo_Elemento,Elemento_Anterior,[Elemento_Atual,Elemento_Posterior|Restante_do_Trajeto],Lista_Duplamente_Encadeada_com_Key_Value_Parcial,Lista_Duplamente_Encadeada_com_Key_Value) :- 
	criar_lista_duplamente_encadeada_com_key_value(Primeiro_Elemento,Segundo_Elemento,Elemento_Atual,[Elemento_Posterior|Restante_do_Trajeto],[Elemento_Atual-[Elemento_Anterior,Elemento_Posterior]|Lista_Duplamente_Encadeada_com_Key_Value_Parcial],Lista_Duplamente_Encadeada_com_Key_Value).






