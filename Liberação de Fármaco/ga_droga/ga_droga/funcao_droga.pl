% Author:
% Date: 03/12/06




funcao_droga(T,[D,C,A,H],FT):-
FT is sqrt((8*D*C*(A-C/2)*T)/((A^2)*(H^2))).

referencia(T,[D,C,A,H],FT):-
FT is sqrt((8*D*C*(A-C/2)*T)/((A^2)*(H^2))).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcula a diferença e eleva ao dradrado

diferenca_ao_2(M1,M2,D2):-
D2 is (M1-M2)^2 .

erro_relativo_medio(A,B,D):-
D is abs(A-B)*(A+B)/(2*(A*B)).

% calcula o desvio de um conjunto de numeros
desvio(X,Media,N,Desvio):-
maplist(diferenca_ao_2(Media),X,Lista),
sumlist(Lista,Soma),
Desvio is sqrt(Soma/N).


% define uma sigmoide  com valor maximo igual a 1
% X valor independente
% crossover = C, A=inclinaçao da curva padrão, P =peso, sendo P=0 (sem peso) P=2 (peso maximo) P>2 pesos menores
% Y is gausseana(1,2,3).
sig(X,A,C,Y):-
Y is 1/(1+exp(-A*(X-C))).


soma_vetor([],[],Ac,RESP):- reverse(Ac,RESP).
soma_vetor([A|A1],[B|B1],Ac,RESP):-
C is A+B,
soma_vetor(A1,B1,[C|Ac],RESP).


lista_vazia(Elemento,T,Ac,RESP):-
(length(Ac,T), RESP=Ac;
lista_vazia(Elemento,T,[Elemento|Ac],RESP)).
