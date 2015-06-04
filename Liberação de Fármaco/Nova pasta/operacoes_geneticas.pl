% :- use_module('operacoes_auxiliares.pl').
:- use_module(library(clpq)).

/* funcao_liberacao_farmaco(+CoeficienteDifusao,+CoeficienteSolubilidade,+CargaFarmaco,+AlturaPilula,+Tempo,-Resultado)
   é verdade se Resultado for o resultado da função de liberação de fármaco de Higuchi dado os parâmetros CoeficienteDifusao (D), 
   CoeficienteSolubilidade(Cs),CargaFarmaco(A),AlturaPilula(h) e Tempo(t).
   Determinístico.
*/
funcao_liberacao_farmaco(CoeficienteDifusao,CoeficienteSolubilidade,CargaFarmaco,AlturaPilula,Tempo,Resultado) :- 
	Resultado is sqrt((8*CoeficienteDifusao*CoeficienteSolubilidade*(CargaFarmaco-CoeficienteSolubilidade/2)*Tempo)/((CargaFarmaco^2)*(AlturaPilula^2))).
	
/* fitness(+CoeficienteDifusao,+CoeficienteSolubilidade,+CargaFarmaco,+AlturaPilula,+Tempo,-Fitness)
   é verdade se Fitness for o resultado do logaritmo do erro absoluto entre função de liberação de fármaco 
   de Higuchi dado os parâmetros CoeficienteDifusao (D), CoeficienteSolubilidade(Cs),CargaFarmaco(A),AlturaPilula(h) 
   e Tempo(t) e o valor de referência para a mesma.
   Determinístico.
*/
fitness(CoeficienteDifusao,CoeficienteSolubilidade,CargaFarmaco,AlturaPilula,Tempo,Fitness) :-
	funcao_liberacao_farmaco(CoeficienteDifusao,CoeficienteSolubilidade,CargaFarmaco,AlturaPilula,Tempo,Resultado),
	% Se resultado - referencia for maior que 0
	!,
	Fitness is log(abs(Resultado - referenciafuncaoliberacaofarmaco)).

/* crossover(+Posição,+PrimeiroIndividuo,+SegundoIndividuo,-PrimeiroIndividuoModificado,-SegundoIndividuoModificado)
   é verdade se o elemento na posição Posição de PrimeiroIndivíduo trocado com o elemento na mesma posição de
   SegundoIndividuo resultar em, respectivamente, PrimeiroIndividuoModificado e SegundoIndividuoModificado. 
   Determinístico.
*/
crossover(Posicao,PrimeiroIndividuo,SegundoIndividuo,PrimeiroIndividuoModificado,SegundoIndividuoModificado):-
	troca_enesimo(Posicao,PrimeiroIndividuo,SegundoIndividuo,PrimeiroIndividuoModificado,SegundoIndividuoModificado).

/* mutacao(+Posição,+Elemento,+Individuo,-IndividuoModificado) 
   é verdade se o elemento Elemento substituir o elemento na posição Posição de Indivíduo resultando na
   nova lista IndividuoModificado. 
   Determinístico.
*/
mutacao(Posicao,Elemento,Individuo,IndividuoModificado):-
	substitui_enesimo(Posicao,Individuo,Elemento,IndividuoModificado).
	