% Arquivo contendo as funções de inicialização dos parâmetros utilizados pelo programa.

% Configura o SWI-Prolog para permitir a execução de mais de uma thread no meio do programa.
:- set_prolog_flag(xpce_threaded,true).

/* inicializa_parametros
   Inicializa os parãmetros que serão usadoss pelo programa.
   Determinístico.
*/
inicializa_parametros  :-

% Limpa as listas encadeadas utilizadas pelo crossover improved_gx
remover_lista_duplamente_encadeada(pai),
remover_lista_duplamente_encadeada(mae),

% Limpa os melhores indivíduos de todas as gerações
retractall(melhor_individuo(_,_)),

% Define a semente do gerador de números aleatórios (para garantir que o programa sempre tenha o mesmo ponto de partida).
set_random(seed(11)),

% Define o tamanho padrão população se o mesmo não for informado na chamada do programa.
nb_setval(tamanho_da_populacao,100),

% Define o número de gerações padrão se o mesmo não for informado na chamada do programa.
nb_setval(numero_de_geracoes,100),

% Define a menor distância já encontrada encontrada nesse problema do Caixeiro Viajante
nb_setval(menor_distancia_encontrada,6110),
nb_getval(menor_distancia_encontrada,Menor_Distancia_Encontrada),

% Define a melhor fitness já encontrada encontrada nesse problema do Caixeiro Viajante
nb_setval(melhor_fitness_encontrada,999999999999999999999999),
nb_setval(melhor_fitness_encontrada_anterior,999999999999999999999999),

% Define a taxa de migração - porcentagem de novos indivíduos que surgem (do nada) a cada geração.
nb_setval(taxa_de_migracao,0.1),

% Define a probabilidade de ocorrer mutação com o indivíduo.
nb_setval(probabilidade_de_mutacao,0.15),

% Define a probabilidade de ocorrer a operação de rotação com o indivíduo.
nb_setval(probabilidade_de_rotacao,0.3),

% Define a probabilidade de ocorrer crossover com o indivíduo.
nb_setval(probabilidade_de_crossover,0.75),

% Define o número de gerações que, caso a melhor fitness não seja alterada, modifica o indíviduo e atualiza as probabilidades de mutação, crossover e rotação.
nb_setval(numero_de_geracoes_para_revisao_dos_parametros,5),

% Define a menor evolução aceitável de uma geração para outra para não contar como estagnado.
nb_setval(menor_evolucao_aceitavel_por_geracao,0.00163666),
nb_getval(menor_evolucao_aceitavel_por_geracao,Menor_Evolucao_Aceitavel_por_Geracao),

% Define o quanto de fitness deve ser melhorado de uma geração para outra para se alcançar a menor evolução aceitável.
Menor_Diferenca_de_Fitness_Aceitavel_por_Geracao is round(Menor_Distancia_Encontrada * Menor_Evolucao_Aceitavel_por_Geracao),
nb_setval(menor_diferenca_de_fitness_aceitavel_por_geracao,Menor_Diferenca_de_Fitness_Aceitavel_por_Geracao),
nb_setval(menor_diferenca_de_fitness_aceitavel_por_geracao,5),

% Limite para definição de um indivíduo como solução (se o fitness dele for inferior ao valor será considerada solução.
nb_setval(limite_de_fitness_para_ser_considerado_solucao,122200),

% Número de cidades da instância atual do caixeiro viajante.
nb_setval(numero_de_cidades,130),
%nb_setval(numero_de_cidades,64),

% Limite da diferenca de fitness entre dois individuos para que os mesmos entrem em um torneio.
nb_setval(limite_da_diferenca_de_fitness_para_entrar_em_torneio,0),

% Limite da distância euclidiana para eliminar um indivíduo no torneio (se a distância euclidiana entre dois indivíduos for menor do que esse limite, o indivíduo de maior fitness é eliminado).
nb_setval(limite_da_distancia_euclidiana_para_eliminacao_no_torneio,1),

% Inicializa a população.
nb_setval(populacao_inicial,[]),

% Inicializa as soluções.
nb_setval(solucoes,[]),

% Número de gerações desde a última mudança de fitness
nb_setval(numero_de_geracoes_desde_a_ultima_mudanca_de_fitness,0),

% Gera uma lista com as cidades que devem ser percorridas.
gera_cidades.

/* gera_cidades
   Inicializa a lista com as cidades que devem ser percorridas.
   Determinístico
*/
gera_cidades :-
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	Numero_de_Cidades_Restantes is Numero_de_Cidades - 1,
	gera_cidades(Numero_de_Cidades_Restantes,[]).

/* gera_cidades(+Numero_de_Cidades_Restantes,-Lista_de_Cidades)
   Implementa gera_cidades/0, onde:
		+Numero_de_Cidades_Restantes -> Número de cidades que ainda faltam ser inseridas na lista.
		-Lista_de_Cidades -> Lista com as cidades.
   Determinístico.
*/

gera_cidades(0, Lista_de_Cidades) :-
	!,
	nb_setval(lista_de_cidades,[0|Lista_de_Cidades]).
	
gera_cidades(Numero_de_Cidades_Restantes, Lista_de_Cidades) :-
	Numero_de_Cidades_Restantes_Atualizado is Numero_de_Cidades_Restantes - 1,
	gera_cidades(Numero_de_Cidades_Restantes_Atualizado, [Numero_de_Cidades_Restantes|Lista_de_Cidades]).

/* gera_individuo(-Individuo) 
   Gera um individuo aleatório. O individuo é uma permutação das cidades a serem percorridas, onde:
		-Individuo -> Indivíduo gerado aleatoriamente. Um individuo é representado por F-Trajeto/Cauda_do_Trajeto, onde:
			F -> Valor da fitness do indivíduo
			Trajeto -> Permutação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/

gera_individuo(Individuo):-
	!,
	random(0,100000,Semente_do_Gerador_de_Numeros_Aleatorios),
	set_random(seed(Semente_do_Gerador_de_Numeros_Aleatorios)),
	nb_getval(lista_de_cidades,Lista_de_Cidades),
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	random(0,Numero_de_Cidades,Cidade),
	delete(Lista_de_Cidades,Cidade,Lista_de_Cidades_Atualizado),
	Numero_de_Cidades_Atualizado is Numero_de_Cidades - 1,
	gera_individuo(Cidade,Cidade,Lista_de_Cidades_Atualizado,Numero_de_Cidades_Atualizado,0-[Cidade|Cauda_da_Diferenca_de_Lista]/Cauda_da_Diferenca_de_Lista,Individuo).
	
/* permuta_individuo(+Individuo_Atual,-Individuo_Permutado) 
   Permuta um indivíduo, onde:
		+Individuo_Atual -> Indivíduo atual.
		-Individuo -> Indivíduo permutado. Um individuo é representado por F-Trajeto/Cauda_do_Trajeto, onde:
			F -> Valor da fitness do indivíduo
			Trajeto -> Permutação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/
permuta_individuo(Individuo_Atual,Individuo_Permutado):-
	!,
	random(0,100000,Semente_do_Gerador_de_Numeros_Aleatorios),
	set_random(seed(Semente_do_Gerador_de_Numeros_Aleatorios)),
	length(Individuo_Atual,Tamanho_do_Individuo),
	random(0,Tamanho_do_Individuo,Indice_da_Cidade),
	nth0(Indice_da_Cidade, Individuo_Atual, Cidade),
	delete(Individuo_Atual,Cidade,Individuo_Atual_Atualizado),
	Tamanho_do_Individuo_Atualizado is Tamanho_do_Individuo - 1,
	gera_individuo(Cidade,Cidade,Individuo_Atual_Atualizado,Tamanho_do_Individuo_Atualizado,0-[Cidade|Cauda_da_Diferenca_de_Lista]/Cauda_da_Diferenca_de_Lista,Individuo_Permutado).
	
/* gera_individuo_guloso(-Individuo) 
   Gera um individuo com algoritmo guloso. O individuo é uma permutação das cidades a serem percorridas, onde:
		-Individuo -> Indivíduo gerado aleatoriamente. Um individuo é representado por F-Trajeto/Cauda_do_Trajeto, onde:
			F -> Valor da fitness do indivíduo
			Trajeto -> Permutação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/

gera_individuo_guloso(Individuo):-
	!,
	random(0,100000,Semente_do_Gerador_de_Numeros_Aleatorios),
	set_random(seed(Semente_do_Gerador_de_Numeros_Aleatorios)),
	nb_getval(lista_de_cidades,Lista_de_Cidades),
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	random(0,Numero_de_Cidades,Cidade),
	delete(Lista_de_Cidades,Cidade,Lista_de_Cidades_Atualizado),
	Numero_de_Cidades_Atualizado is Numero_de_Cidades - 1,
	gera_individuo(Cidade,Cidade,Lista_de_Cidades_Atualizado,Numero_de_Cidades_Atualizado,0-[Cidade|Cauda_da_Diferenca_de_Lista]/Cauda_da_Diferenca_de_Lista,Individuo_Parcial),
	rotacao_total(Individuo_Parcial,Individuo,_).
	
/* gera_individuo(+Ultima_Cidade,+Cidade_Atual,+Lista_de_Cidades,+Numero_de_Cidades,+Lista_de_Cidades,+Acumulador_Individuo,-Individuo)
   Implementa gera_individuo/1, onde:
		+Ultima_Cidade -> Última cidade do trajeto. Deve ser preservada para que, ao finalizar o trajeto, calcule-se a distância entre a primeira cidade e a última cidade e adicione à distância total do trajeto.
		+Cidade_Atual -> A cidade na qual o trajeto se encontra. Última cidade gerada para o trajeto até o momento.
		+Lista_de_Cidades -> Vetor com todas as cidades que devem ser percorridas.
		+Numero_de_Cidades -> Número de cidades.
		+Cauda_da_Diferenca_de_Lista/Cauda_da_Diferenca_de_Lista -> Diferença de lista que receberá o trajeto.
		+Acumulador_Individuo -> Diferença de lista que será usada para construir o trajeto.
		-Individuo -> Indivíduo gerado. O individuo é representado por F-Trajeto, onde:
			F -> Valor da fitness do indivíduo
			Trajeto -> Permutação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/	

gera_individuo(Ultima_Cidade, Cidade_Atual,_,0,F_Parcial-[Cidade_Atual|Trajeto]/Cauda_da_Diferenca_de_Lista,F-[Cidade_Atual|Trajeto]/Cauda_da_Diferenca_de_Lista) :-
	!,
	funcao_de_paridade_de_cantor(Ultima_Cidade,Cidade_Atual,Funcao_de_Paridade_de_Cantor),
	distancia(Funcao_de_Paridade_de_Cantor,Distancia),	
	F is F_Parcial + Distancia.
	
gera_individuo(Ultima_Cidade,Cidade_Atual,Lista_de_Cidades,Numero_de_Cidades,F_Parcial-Trajeto_Parcial/Cauda_da_Diferenca_de_Lista,F-Trajeto) :-
	random(0,Numero_de_Cidades,Indice_Cidade),
	nth0(Indice_Cidade, Lista_de_Cidades, Proxima_Cidade),
	delete(Lista_de_Cidades,Proxima_Cidade,Lista_de_Cidades_Atualizada),
	Numero_de_Cidades_Atualizado is Numero_de_Cidades - 1,
	funcao_de_paridade_de_cantor(Cidade_Atual,Proxima_Cidade,Funcao_de_Paridade_de_Cantor),
	distancia(Funcao_de_Paridade_de_Cantor,Distancia),
	F_Parcial_Atualizada is F_Parcial + Distancia,
	gera_individuo(Ultima_Cidade,Proxima_Cidade,Lista_de_Cidades_Atualizada,Numero_de_Cidades_Atualizado,F_Parcial_Atualizada-[Proxima_Cidade|Trajeto_Parcial]/Cauda_da_Diferenca_de_Lista,F-Trajeto).

/* gera_populacao(+Numero_de_Individuos,-Populacao) 
   Gera uma população de indivíduos aleatórios onde:
		+Numero_de_Individuos -> Tamanho da população que será gerada
		-Populacao -> População gerada.
   Determinístico.
*/
gera_populacao(Numero_de_Individuos,Populacao) :-
	gera_populacao(Numero_de_Individuos,[],Populacao).

/* gera_populacao(+Numero_de_Individuos,+Populacao_Parcial,-Populacao)
   Implementa gera_populacao/2, onde:
		+Numero_de_Individuos -> Tamanho da população que ainda falta gerar.
		+Populacao_Parcial -> Acumulador a ser preenchido até chegar em Populacao.
		-Populacao -> População gerada.
   Determinístico.
*/
gera_populacao(0,Populacao,Populacao):-!.

gera_populacao(Numero_de_Individuos,Populacao_Parcial,Populacao):-
	gera_individuo(Individuo),
	Numero_de_Individuos_Atualizado is Numero_de_Individuos-1,
	gera_populacao(Numero_de_Individuos_Atualizado,[Individuo|Populacao_Parcial],Populacao).
	
/* gera_populacao_gulosa(+Numero_de_Individuos,-Populacao) 
   Gera uma população de indivíduos utilizando algoritmo guloso onde:
		+Numero_de_Individuos -> Tamanho da população que será gerada
		-Populacao -> População gerada.
   Determinístico.
*/
gera_populacao_gulosa(Numero_de_Individuos,Populacao) :-
	gera_populacao_gulosa(Numero_de_Individuos,[],Populacao).

/* gera_populacao_gulosa(+Numero_de_Individuos,+Populacao_Parcial,-Populacao)
   Implementa gera_populacao_gulosa/2, onde:
		+Numero_de_Individuos -> Tamanho da população que ainda falta gerar.
		+Populacao_Parcial -> Acumulador a ser preenchido até chegar em Populacao.
		-Populacao -> População gerada.
   Determinístico.
*/
gera_populacao_gulosa(0,Populacao,Populacao):-!.

gera_populacao_gulosa(Numero_de_Individuos,Populacao_Parcial,Populacao):-
	gera_individuo_guloso(Individuo),
	Numero_de_Individuos_Atualizado is Numero_de_Individuos-1,
	gera_populacao_gulosa(Numero_de_Individuos_Atualizado,[Individuo|Populacao_Parcial],Populacao).