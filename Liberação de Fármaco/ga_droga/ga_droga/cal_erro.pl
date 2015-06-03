% Author:
% Date: 03/12/06

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcula o erro do conjunto de parametros  em relacao aos valores da funcao f(T)
calcula_erro_funcao(_,[],Ac,Erro):- length(Ac,T), sumlist(Ac,Soma_erro), Erro is Soma_erro/T, !.
calcula_erro_funcao([D,C,A,H],[T|Lista_t],Ac,Erro_total):-
parametros_referencia([Dr,Cr,Ar,Hr]),
funcao_droga(T,[D,C,A,H],FT),
referencia(T,[Dr,Cr,Ar,Hr],FT_ref),
Ac1 is abs(FT-FT_ref)/FT_ref,
calcula_erro_funcao([D,C,A,H],Lista_t,[Ac1|Ac],Erro_total).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUPORTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cria um vetor com os valores de T

espaco_t(Inicio,Fim,Step,Vetor_t):-
N is round((Fim-Inicio)/Step),
numlist(0,N,Vetor),
maplist(valor(Inicio,Step),Vetor,Vetor_t), !.

valor(Ini,Step,Inteiro,Val):-
Val is Ini+ Step*Inteiro .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calcula a media e o desvio do erro da populacao
media_desvio_populacao:-
findall(Erro,i(_,_,_,_,_,Erro),Erros),
sumlist(Erros,Soma_erros),
length(Erros,N),
Media is Soma_erros/N,
desvio(Erros,Media,N,Desvio1),
(Desvio1<1e-10 -> Desvio is 1e-10; Desvio is Desvio1),
abolish(media_desvio/2), assert(media_desvio(Media,Desvio)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  calcula o erro do conjunto em relacao a outro conjunto
% e adiciona na memoria o fato erro/3 erro(I1,I2,Soma_erro).

cal_erro_individuos(I1,I2):-
nb_getval(qq,QQ), QQ1 is QQ/5000, (integer(QQ1)-> write(QQ),nl;true),
Q is QQ+1,nb_setval(qq,Q),

 (i(_,I1,Reais1,_,Unitarios1,_), i(_,I2,Reais2,_,Unitarios2,_)->
                                      maplist(erro_relativo_medio,Reais1,Reais2,Erros),sumlist(Erros,Soma_erros),
                                      maplist(diferenca_ao_2,Unitarios1,Unitarios2,Distancias),sumlist(Distancias,Soma_distancias),
                                      Distancia is sqrt(Soma_distancias),
                                      assert(i2j(I1,I2,Soma_erros,Distancia)),
                                      I2a is I2+1,
                                      cal_erro_individuos(I1,I2a);
 i(_,I1,Reais1,_,_,_)-> I1a is I1+1, I2a is I1+2, cal_erro_individuos(I1a,I2a); !,true).


% calcula somente o erro dos individuos na lista
cal_erro_individuos_lista([],_):-!.
cal_erro_individuos_lista([I1|R],I2):-
I2a is I2+1,
 (I1=I2 -> I2a is I2+1,cal_erro_individuos_lista([I1|R],I2a);
 i(_,I1,Reais1,_,Unitarios1,_), i(_,I2,Reais2,_,Unitarios2,_)->
                                      maplist(erro_relativo_medio,Reais1,Reais2,Erros),sumlist(Erros,Soma_erros),
                                      maplist(diferenca_ao_2,Unitarios1,Unitarios2,Distancias),sumlist(Distancias,Soma_distancias),
                                      Distancia is sqrt(Soma_distancias),
                                      (retract(i2j(I1,I2,_,_))->true;
                                       retract(i2j(I2,I1,_,_))-> true),
                                      assert(i2j(I1,I2,Soma_erros,Distancia)),
                                      I2a is I2+1,
                                      cal_erro_individuos_lista([I1|R],I2a);
i(_,I1,Reais1,_,_,_)-> cal_erro_individuos_lista(R,1); true).

% calculao erro limite para os individuos highlander
erro_highlander:-
media_desvio(Media,_),
ordem_highlander(Ordem),
Erro_h is Media/(10^Ordem),
abolish(erro_highlander/1), assert(erro_highlander(Erro_h)).
