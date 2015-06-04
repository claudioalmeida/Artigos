:- set_prolog_flag(xpce_threaded,true).

/* inicializa_variáveis
   Inicializa as variáveis globais que serão usadas pelo programa.
   Determinístico.
*/
inicializa_variaveis  :-

remover_lista_duplamente_encadeada(pai),
remover_lista_duplamente_encadeada(mae),
retractall(melhor_individuo(_,_)).

% Define a semente do gerador de números aleatórios (para garantir que o programa sempre tenha o mesmo ponto de partida).
set_random(seed(11)),

% Define o tamanho padrão população se o mesmo não for informado na chamada do programa.
nb_setval(tamanho_da_populacao,100),

% Define o número de gerações padrão se o mesmo não for informado na chamada do programa.
nb_setval(numero_de_geracoes,100),

% Menor distância encontrada
nb_setval(menor_distancia_encontrada,6110),
nb_getval(menor_distancia_encontrada,Menor_Distancia_Encontrada),
nb_setval(melhor_fitness,999999999999999999999999),
nb_setval(melhor_fitness_anterior,999999999999999999999999),

% Define a taxa de migração - porcentagem de novos indivíduos que surgem (do nada) a cada geração.
nb_setval(taxa_de_migracao,0.1),

% Define a probabilidade de ocorrer muotação com o indivíduo.
nb_setval(probabilidade_mutacao,0.15),
%nb_setval(probabilidade_mutacao,1),

% Define a probabilidade de ocorrer a operação de rootação com o indivíduo.
nb_setval(probabilidade_rotacao,0.30),

% Define a probabilidade de ocorrer crossover com o indivíduo.
nb_setval(probabilidade_crossover,0.75),
%nb_setval(probabilidade_crossover,1),

% Define o número de gerações que, caso a melhor fitness não seja alterada, modifica o indíviduo a atualiza as probabilidades de mutação, crossover e rotação.
nb_setval(numero_de_geracoes_para_revisao_do_contexto,50),

% Taxa de migração - porcentagem de novos indivíduos que surgem (do nada) a cada geração.
nb_setval(menor_evolucao_aceitavel,0.025),
nb_getval(menor_evolucao_aceitavel,Menor_Evolucao_Aceitavel),

Menor_Diferenca_Fitness_Aceitavel is round(Menor_Distancia_Encontrada * Menor_Evolucao_Aceitavel),
nb_setval(menor_diferenca_fitness_aceitavel,Menor_Diferenca_Fitness_Aceitavel),
nb_setval(menor_diferenca_fitness_aceitavel,1),

% Limite para definição de um indivíduo como solução (se o fitness dele for inferior ao valor será considerada solução.
nb_setval(ldlf,122200),

% Número de cidades.
nb_setval(nc,130),
%nb_setval(nc,10),


% Limite da diferenca de fitness entre dois individuos do mesmo grupo no torneio.
nb_setval(ldf,0),

% Limite da distância euclidiana para eliminar um indivíduo no torneio (se a distância euclidiana entre dois indivíduos for menor do que esse limite, o indivíduo de maior fitness é eliminado).
nb_setval(limite_da_distancia_euclidiana_no_torneio,1),

% População inicial
nb_setval(p,[]),

% Soluções iniciais
nb_setval(s,[]),

% Número de gerações desde a última mudança de fitness
nb_setval(numero_de_geracoes_desde_a_ultima_mudanca_de_fitness,0),

% Gera as cidades que devem ser percorridas.
gera_cidades.

/* gera_cidade
   Inicializa o vetor com as cidades que devem ser percorridas.
   Determinístico
*/
gera_cidades :-
	nb_getval(nc,Numero_Cidades),
	Numero_Cidades_Atualizado is Numero_Cidades - 1,
	ger_cidades(Numero_Cidades_Atualizado,[]).

/* ger_cidades(+Numero_Cidades,-Vetor_Cidades)
   Implementa gera_cidades/0, onde:
		+Numero_Cidades -> Número de cidades que ainda faltam ser inseridas no vetor.
		-ListaComElemento -> Vetor com as cidades.
   Determinístico.
*/

ger_cidades(0, Vetor_Cidades) :-
	!,
	nb_setval(vc,[0|Vetor_Cidades]).
	
ger_cidades(Numero_Cidades, Vetor_Cidades) :-
	Numero_Cidades_Atualizado is Numero_Cidades - 1,
	ger_cidades(Numero_Cidades_Atualizado, [Numero_Cidades|Vetor_Cidades]).

/* gera_individuo(-(F-Trajeto)) 
   Gera um Individuo aleatório. O individuo é uma permuotação das cidades a serem percorridas, onde:
		F -> Valor do fitness do indivíduo
		Trajeto -> Permuotação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/

gera_individuo(F-Trajeto):-
	nb_getval(vc,Vetor_Cidades),
	nb_getval(nc,Numero_Cidades),
	ger_individuo(Vetor_Cidades,Numero_Cidades,Cauda_Diferenca_De_Lista/Cauda_Diferenca_De_Lista,F-Trajeto).

/* ger_individuo(+Vetor_Cidades,+Numero_Cidades,-Vetor_Cidades)
   Implementa gera_individuo/1, onde:
		+Vetor_Cidades -> Vetor com todas as cidades que devem ser percorridas.
		+Numero_Cidades -> Número de cidades.
		+Cauda_Diferenca_De_Lista/Cauda_Diferenca_De_Lista -> Diferença de lista que receberá o trajeto.
		+F-Trajeto -> Indivíduo (permuotação das cidades a serem percorridas) gerado onde:
			F -> Valor do fitness do indivíduo
			Trajeto -> Permuotação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/	

ger_individuo(Vetor_Cidades,Numero_Cidades,Cauda_Diferenca_De_Lista/Cauda_Diferenca_De_Lista,F-Trajeto) :-
	!,
	random(0,Numero_Cidades,Cidade),
	delete(Vetor_Cidades,Cidade,Vetor_Cidades_Atualizado),
	Numero_Cidades_Atualizado is Numero_Cidades - 1,
	ger_individuo(Cidade,Cidade,Vetor_Cidades_Atualizado,Numero_Cidades_Atualizado,0-[Cidade|X]/X,F-Trajeto).

/* ger_individuo(+Ultima_Cidade,+Cidade_Atual,+Vetor_Cidades,+Numero_Cidades,-Vetor_Cidades)
   Implementa gera_individuo/1, onde:
		+Ultima_Cidade -> Última cidade do trajeto. Deve ser preservada para que, ao finalizar o trajeto, calcule-se a distância entre a primeira cidade e a última cidade e adicione à distância total do trajeto.
		+Cidade_Atual -> A cidade na qual o trajeto se encontra. Última cidade gerada para o trajeto até o momento.
		+Vetor_Cidades -> Vetor com todas as cidades que devem ser percorridas.
		+Numero_Cidades -> Número de cidades.
		+Cauda_Diferenca_De_Lista/Cauda_Diferenca_De_Lista -> Diferença de lista que receberá o trajeto.
		+F-Trajeto -> Indivíduo (permuotação das cidades a serem percorridas) gerado onde:
			F -> Valor do fitness do indivíduo
			Trajeto -> Permuotação das cidades do problema representando o trajeto a ser percorrido.
   Determinístico.
*/	

ger_individuo(Ultima_Cidade, Cidade_Atual,_,0,F_Inicial-[Cidade_Atual|Trajeto]/Cauda_Diferenca_De_Lista,F-[Cidade_Atual|Trajeto]/Cauda_Diferenca_De_Lista) :-
	!,
	funcao_cantor(Ultima_Cidade,Cidade_Atual,Funcao_Cantor),
	distancia(Funcao_Cantor,Distancia),	
	F is F_Inicial + Distancia.
	
ger_individuo(Ultima_Cidade,Cidade_Atual,Vetor_Cidades,Numero_Cidades,F_Inicial-Trajeto_Inicial/Cauda_Diferenca_De_Lista,F-Trajeto) :-
	random(0,Numero_Cidades,Indice_Cidade),
	nth0(Indice_Cidade, Vetor_Cidades, Cidade),
	delete(Vetor_Cidades,Cidade,Vetor_Cidades_Atualizado),
	Numero_Cidades_Atualizado is Numero_Cidades - 1,
	funcao_cantor(Cidade_Atual,Cidade,Funcao_Cantor),
	distancia(Funcao_Cantor,Distancia),
	F_Inicial_Atualizado is F_Inicial + Distancia,
	ger_individuo(Ultima_Cidade,Cidade,Vetor_Cidades_Atualizado,Numero_Cidades_Atualizado,F_Inicial_Atualizado-[Cidade|Trajeto_Inicial]/Cauda_Diferenca_De_Lista,F-Trajeto).
	
/* gera_populacao(+NumeroIndividuos,-Populacao) 
   Gera uma população de indivíduos aleatórios onde:
		+NumeroIndividuos -> Tamanho da população que será gerada
		-Populacao -> População gerada.
   Determinístico.
*/
gera_populacao(NumeroIndividuos,Populacao) :-
	ger_populacao(NumeroIndividuos,[],Populacao).

/* ger_populacao(+NumeroIndividuos,+PopulacaoInicial,-PopulacaoFinal)
   Implementa gera_populacao/2, onde:
		+ NumeroIndividuos -> Tamanho da população que ainda falta gerar.
		+ PopulacaoInicial -> Acumulador a ser preenchido até chegar em PopulacaoFinal 
   Determinístico.
*/
ger_populacao(0,PopulacaoFinal,PopulacaoFinal):-!.
ger_populacao(NumeroIndividuos,Populacao,PopulacaoFinal):-
	gera_individuo(Individuo),
	NumeroIndividuosAtualizado is NumeroIndividuos-1,
	ger_populacao(NumeroIndividuosAtualizado,[Individuo|Populacao],PopulacaoFinal).