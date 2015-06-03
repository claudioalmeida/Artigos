% com(+Combinaco inicial,[],-RESP)
% combinacao(+combinaco_qualquer,1,-total_de_combinacoes).

% determina se a presente combinacao corresponde a ultima combinacao
% esta rotina serve para evitar o calculo da quantidade de combinacoes
% que pode ser muito grande
% se RESP =1 nao é o ultimo codigo
% se RESP =0 ultimo codigo

parada([[A,A1]|B],RESP):-
(A>=A1, igual(B,[])-> RESP is 0, !;
A<A1 -> true, RESP is 1,!;
parada(B,RESP)).

% determina se a presente combinacao corresponde a ultima combinacao
% esta rotina serve para evitar o calculo da quantidade de combinacoes
% que pode ser muito grande
% se fail ultimo codigo
% se true nao é o ultimo codigo

parada([[A,A1]|B]):-
(A>=A1, B==[]-> true, !;
A<A1 -> fail, !;
parada(B)).


% calcula o numero de combinacoes  A de b em b
% combinacao_numero3(6,2,P) =15

combinacao_numero3(A, B, RESP) :-
        fatorial(A,D),
        fatorial(B,E),
        F is A-B,
        fatorial(F,G),
        RESP is D/ (E*G).

% calcula o fatorial do numero A
% fatorial(1,A,RESP).

fatorial(A,C):-
(A=<150->fatorial1(A,1,C);
A>150,A<171-> fatorial0(A,C);
C is 1).

fatorial0(A,C):-
C is exp(log(A)*A-A).


fatorial1(1, A, A).
fatorial1(A, B, C) :-
        D is A-1,
        E is B*D,
        fatorial1(D, E, C).

% calcula a quantidade de combinações que podem ser feitas com uma certa
% combinação, somente a quantidade total de cada campo é utilizada
% dependendo da quantidade esta conta pode ser inviável
% combinação_numero(Combinação, 1,RESP).


combinacao_numero([[_,Ax]|B],Ac,RESP):-
(B==[]-> RESP is Ac*Ax, !;
Ac1 is Ac*Ax, combinacao_numero(B,Ac1,RESP)).

% utilizado em combinacoes binarias
combinacao_numero2([[_,Ax]|B],Ac,RESP):-
(B==[]-> RESP is Ac*(Ax+1), !;
Ac1 is Ac*(Ax+1),
combinacao_numero2(B,Ac1,RESP)).

% calcula o próximo elemento da combinação
% com(Combinacao, [],RESP).
% com([[1,2],[1,3]],[],P).

com([[A,Ax]|B],Ac,RESP):-
(A<Ax -> A1 is A+1,
reverse(Ac,Acr),
append(Acr,[[A1,Ax]|B],RESP),!;
A=Ax -> 
com(B,[[1,Ax]|Ac],RESP)).

% versao do com binario 0 ou 1
com1([[A,Ax]|B],Ac,RESP):-
(A<Ax -> A1 is A+1,
reverse(Ac,Acr),
append(Acr,[[A1,Ax]|B],RESP),!;
A=Ax ->
com1(B,[[0,Ax]|Ac],RESP)).

% faz um elemento de combinacao
% responde um elemnto combinatorio com(+primeiro_elemento,Maximo_ou_base,RESPosta)
% exemplo  com([4,3,2,1],6,4,RESP).

com2([A|B],Fim,Casas, Resp):-
(A<Fim -> A1 is A+1, length([A|B],T),
       (T=Casas -> igual([A1|B],Resp), !;
                   T<Casas -> completa([A1|B],Casas, Resp));
A=Fim -> Fim2 is Fim-1, com2(B,Fim2,Casas, Resp)).

completa(B,Casas,Resp):-
length(B,T),
(T<Casas -> nth1(1,B,A), A1 is A+1, completa([A1|B],Casas,Resp);
T=Casas -> igual(B,Resp)).



% faz todas as combinações da rotina com/3 dentro de um intervalo A a Fim
% ex: repete(1,6,[[1,2],[1,3]]).
repete(A,A,_):-!.
repete(A,Fim,F):-
A1 is A+1,
com(F,[],RE),
write(RE),nl,
repete(A1,Fim,RE).

% pega o primeiro campo de cada combinaçõ e gera uma combinacao
pega_combinacao([A|B],Ac,RESP):-
(B==[]-> nth1(1,A,C), reverse([C|Ac],RESP);
nth1(1,A,C),pega_combinacao(B,[C|Ac],RESP)).

% pega os elementos da combinacao e transcreve para a os codigos relacionados
% no  fato trancreve(Com1, codigo).

pega_combinacao2([A|B],Ac,RESP):-
(B==[]-> nth1(1,A,C), transcreve(C,C1),reverse([C1|Ac],RESP);
nth1(1,A,C),transcreve(C,C1),pega_combinacao2(B,[C1|Ac],RESP)).

:-assert(transcreve(1,-1)).
:-assert(transcreve(2,0)).
:-assert(transcreve(3,1)).

