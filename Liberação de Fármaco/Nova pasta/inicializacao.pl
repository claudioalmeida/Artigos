:- use_module('operacoes_auxiliares.pl').

/* gera_individuo(+Tamanho,+ValoresDisponiveis,-Individuo) 
   é verdade se a lista Individuo for gerada do tamanho Tamanho utilizando os elementos de ValoresDisponiveis. 
   Determinístico.
*/
gera_individuo(Tamanho,ValoresDisponiveis,Individuo):- length(ValoresDisponiveis,TamanhoValoresDisponiveis),
													   NTamanhoValoresDisponiveis is TamanhoValoresDisponiveis + 1,
													   ge_individuo(Tamanho,ValoresDisponiveis,NTamanhoValoresDisponiveis,[],Individuo).

/* ge_individuo(+Tamanho,+ValoresDisponiveis,+TamanhoValoresDiponiveis,+IndividuoInicial,-IndividuoFinal)
   implementa gera_individuo|4, usando IndividuoInicial para gerar a lista. 
   IndividuoInicial deve ser inicializado com []. Determinístico.
*/
ge_individuo(0,_,_,Individuo,[FitnessIndividuo|[Individuo-ValorDecimalIndividuo]]):-	
	fitness(Individuo,FitnessIndividuo),
	calcula_valor_decimal(Individuo,ValorDecimalIndividuo),
	!.
																
ge_individuo(Contador,ValoresDisponiveis,TamanhoValoresDiponiveis,IndividuoInicial,IndividuoFinal):-
	NContador is Contador-1,
	random(1,TamanhoValoresDiponiveis,Posicao),
	encontra_enesimo(Posicao,ValoresDisponiveis,Elemento),
	ge_individuo(NContador,ValoresDisponiveis,TamanhoValoresDiponiveis,[Elemento|IndividuoInicial],IndividuoFinal).
	
/* gera_populacao(+NumeroIndividuos,+Tamanho,+ValoresDisponiveis,-Populacao) 
   é verdade se a lista Populacao for gerada com o número de indivíduos NumeroIndividuos construídos de maneira aleatória a partir
   da lista de ValoresDisponiveisTamanho utilizando os elementos de ValoresDisponiveis. 
   Determinístico.
*/
gera_populacao(NumeroIndividuos,Tamanho,ValoresDisponiveis,Populacao):- ge_populacao(NumeroIndividuos,Tamanho,ValoresDisponiveis,[],Populacao).

/* ge_populacao(+Tamanho,+ValoresDisponiveis,+NumeroIndividuos,+PopulacaoInicial,-Populacao)
   implementa gera_populacao|4, usando PopulacaoInicial para gerar a lista. PopulacaoInicial deve ser inicializado com []. Determinístico.
*/
ge_populacao(0,_,_,Populacao,Populacao) :- !.
																
ge_populacao(Contador,Tamanho,ValoresDisponiveis,PopulacaoInicial,PopulacaoFinal):- NContador is Contador-1,
																					gera_individuo(Tamanho,ValoresDisponiveis,Individuo),
																					ge_populacao(NContador,Tamanho,ValoresDisponiveis,[Individuo|PopulacaoInicial],PopulacaoFinal).