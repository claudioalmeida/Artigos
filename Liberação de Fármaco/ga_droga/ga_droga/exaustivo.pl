% Author:
% Date: 12/12/2006

% gera pontos para fazer o grafico da superficie de erro

% faz a chamada e estrutura os elementos de combinacao para fazer a busca exaustiva
exaustivo:-
[config],
open('superficie.txt',write,_,[alias(superficie)]), % arquivo que contem toda a superficie
open('melhores.txt',write,_,[alias(melhores)]),     % arquivo que contem apenas os paramentrros menores que 1% de erro

precisao_exaustivo(Precisoes,_,_,_),
gera_combinacoes(Precisoes,[],Combinacoes),
reverse(Precisoes,Precisoes_rev), gera_quantidade_de_calculos(Precisoes_rev,[],Quantidade), nb_setval(inter,Quantidade),
cabecalho,
exaustivo(Combinacoes).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gera o primeiro elemento de combinacao binario
% ex [[0,1],[0,1]] dois bits

gera_combinacoes([],Ac,RESP):- reverse(Ac,RESP),!.
gera_combinacoes([P|Precisao],Ac,RESP):-
gera_primeira_combinacao(P,[],COM1),
gera_combinacoes(Precisao,[COM1|Ac], RESP).

gera_primeira_combinacao(T,Ac,Com1):-
(length(Ac,T)-> Com1=Ac;
gera_primeira_combinacao(T,[[0,1]|Ac],Com1)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gera a lista de paramentros =Vardiados +Constantes e calcula o erro na extencao da
% curva e gera o proximo elemento de combinacao

exaustivo(Combinacoes):-
precisao_exaustivo(Precisao,Pos_var,Intervalos,Pos_const),
pega_variados(Combinacoes,Pos_var,Intervalos,[],Variados),
parametros_referencia(Referencia),
pega_constantes(Referencia,Pos_const,[],Constantes),
append(Constantes,Variados,Parametros_des), sort(Parametros_des,Parametros_ord),
maplist(nth1(2),Parametros_ord,Parametros),
maplist(nth1(2),Variados,Variados_escreve),
intervalo_t(Inicio,Fim,Step),
espaco_t(Inicio,Fim,Step,Vetor_t),
calcula_erro_funcao(Parametros,Vetor_t,[],Erro),
append(Variados_escreve,[Erro],Escreve),
faixa_erro(Melhor,Super),
(Erro=<Melhor -> escreve_superficie(melhores,Escreve); true),
(Erro=<Super ->  escreve_superficie(superficie,Escreve); true),
%  escreve_superficie(superficie,Escreve),
!, (combinacao(Combinacoes,Precisao,[],Combinacoes2)-> exaustivo(Combinacoes2);
                                            close(melhores), close(superficie), true).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% seleciona os parametrso que são variados durante o processo de varedura
pega_variados([],[],[],Ac,Variados):-reverse(Ac,Variados),!.
pega_variados([C|Combinacoes],[P|Posicoes],[[Inicio,Fim]|Intervalos],Ac,Variados):-
pega_combinacao(C,[],String),
bin2real(Inicio,Fim,String,Real),
pega_variados(Combinacoes,Posicoes,Intervalos,[[P,Real]|Ac],Variados).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% seleciona os parametrso que são constantes durante o processo de varedura
pega_constantes(_,[],Constantes,Constantes):- !.
pega_constantes(Referencia,[P|Posicao],Ac,Constantes):-
nth1(P,Referencia,Com),
pega_constantes(Referencia,Posicao,[[P,Com]|Ac],Constantes).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% faz a chamada da rotina de cimbinacao e gera o proximo elemento de combinacao
combinacao([C|C1],[P|Precisao],Ac,Combinacoes2):-
(parada(C),C1=[]-> fail;
 parada(C)->      gera_primeira_combinacao(P,[],Com1),

                   nb_getval(inter,[I1,Cal]),
                   current_output(STREAM), format('~ninteracao',[]), maplist(nth1(1),Cal,Calculo),
                                           maplist(format(STREAM,' ~w'),[I1|Calculo]),
                                           (com(Cal,[],Cal2)-> true; Cal2=Cal), nb_setval(inter,[I1,Cal2]),

                  !, combinacao(C1,Precisao,[Com1|Ac],Combinacoes2);
                  reverse(C,C_r),com1(C_r,[],Com1_r),reverse(Com1_r,Com1),
                  reverse([Com1|Ac],Ac1),
                  append(Ac1,C1,Combinacoes2),!).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
escreve_superficie(Stream,[]):- format(Stream,'~n',[]),!.

escreve_superficie(Stream,[A|A1]):-
format(Stream,'~w ',[A]),
escreve_superficie(Stream, A1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUPORTE MONITORAMENTO %%%%%%%%%%%%%%%%%%%%%%
% calcula a quantidade de calculos que ja foi feita
gera_quantidade_de_calculos([P],Ac,Quantidade):- Q is round(2^P), reverse(Ac, Q1),append([Q],[Q1],Quantidade).
gera_quantidade_de_calculos([P|Precisao],Ac,Resp):-
Q is round(2^P),
gera_quantidade_de_calculos(Precisao,[[0,Q]|Ac],Resp).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cabecalho:-
precisao_exaustivo(Precisoes,Pos_var,Intervalos,Pos_const),
parametros_referencia(Referencia),
nb_getval(inter,[Q|[Quantidade]]),
maplist(nth1(2),Quantidade,Calculos),

format(superficie, '# Valores constantes~n',[]),
escreve_constantes(superficie,Pos_const,Referencia),
format(superficie, '# variados~n',[]),
escreve_variados(superficie, Pos_var, Intervalos),
format(superficie, '# Precisao~n',[]),
maplist(format(superficie,'# ~w bits~n'),Precisoes),
format(superficie,'# Quantidade de calculos~n# ',[]),
maplist(format(superficie,'~w '),[Q|Calculos]),nl(superficie),nl(superficie),

format(melhores, '# Valores constantes~n',[]),
escreve_constantes(melhores,Pos_const,Referencia),
format(melhores, '# variados~n',[]),
escreve_variados(melhores, Pos_var, Intervalos),
format(melhores, '# Precisao~n',[]),
maplist(format(melhores,'# ~w bits~n'),Precisoes),
format(melhores,'# quantidade de calculos~n# ',[]),
maplist(format(melhores,'~w '),[Q|Calculos]), nl(melhores),nl(melhores).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

escreve_constantes(_,[],_).
escreve_constantes(Stream, [P|P1],Referencia):-
nth1(P,Referencia,R),
format(Stream,'# ~w ~w~n',[P,R]),escreve_constantes(Stream,P1,Referencia).

escreve_variados(_,[],[]).
escreve_variados(Stream, [P|P1],[[I,F]|Variados]):-
format(Stream,'# ~w ~w ~w~n',[P,I,F]),escreve_variados(Stream,P1,Variados).
