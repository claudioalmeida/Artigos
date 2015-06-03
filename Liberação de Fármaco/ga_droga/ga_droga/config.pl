% Author:
% Date: 03/12/06
:- nb_setval(geracao,1).

:- abolish(pop_size/1), assert(pop_size(500)). % tamanho da populacao

:-abolish(precisao/1), assert(precisao([32 ,32,32,16])). % define a precisao inicial de cada parametro otimizado
/* regra para a devinicao de cada precisao
Se (Maximo-Minimo)/2^Bits<que a menor ordem de grabdeza dos valores ->true; fail
ex 4.82-0.042=4.778
   4.778/2^8 =4.778/256= 0.018664 esta na mesma ordem de grandeza
   4.778/2^16=4.778/65536=7.27*10^(-5) esta pode ser utilizada*/

:-abolish(parametros_referencia/1), assert(parametros_referencia([1.35,16.2,70,0.167])).


%                                          [Di,Df],[Ci,Cf],[Ai,Af],[Hi,Hf]
:-abolish(intervalos/1), assert(intervalos([[0.042,4.82],[2.7,40.0],[33.3,133.1],[0.164, 0.170]])).
:-abolish(intervalo_t/3), assert(intervalo_t(1,100,99)). % define o intervalo de tempo e o passo dos intervalo

:-nb_setval(qq,1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% definicoes de classe
:-abolish(erro_entre_individuos/1),assert(erro_entre_individuos(0.01)).

:-abolish(distancia_minima/1), assert(distancia_minima(0.01)).
:-abolish(distancia_maxima/1), assert(distancia_maxima(0.07)).

:-abolish(distancia_minima_high/1), assert(distancia_minima_high(0.02)).
:-abolish(distancia_maxima_high/1), assert(distancia_maxima_high(0.05)).


:-abolish(ordem_highlander/1), assert(ordem_highlander(2)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% valores de rro para indicar a convergencia
:- abolish(media_desvio_converge/2), assert(media_desvio_converge(0.000001,0.000001)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configuracao do processo exaustivo
:-abolish(precisao_exaustivo/4), assert(precisao_exaustivo([3,3,3,3],[1,2,3,4],[[0.042,4.82],[2.7,40],[33,133],[0.164,0.17]],[])).
% faixa_erro(Melhor, Superficie).
:-abolish(faixa_erro/2), assert(faixa_erro(0.01,0.1)).

% precisao_exaustivo([3,3],[1,2],[[0.042,4.82],[2.7,40]],[3,4]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configuracao do processo de exibicao dos resultados

escreve_classe(n).
escreve_highlander(n).

