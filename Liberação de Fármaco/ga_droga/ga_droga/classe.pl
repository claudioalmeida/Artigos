% Author:
% Date: 12/14/2006

classe:-
pop_size(Pop_size),
nb_setval(invasores,[]),
abolish(esfera/5), assert(esfera(0,0,0,0,0)),
candidatos_classe(1,Pop_size,[],Candidatos),
classificacao(Candidatos),
nb_setval(candidatos,Candidatos),
length(Candidatos,N_cand), nb_setval(n_candidatos,N_cand),

findall(Classe,esfera(Classe,_,_,_,_),Classes),
length(Classes,N_classes1), N_classes is N_classes1-1,nb_setval(n_classes,N_classes),

findall(Individuos,esfera(_,Individuos,_,_,_),Classificados_1),
flatten(Classificados_1,Classificados_2),
list_to_set(Classificados_2,Classificados), length(Classificados,N_c_1),N_c is N_c_1-1,
nb_setval(classificados,N_c).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define quais os individuos serao submetidos ao processo de classificacao
candidatos_classe(I,Pop_size,Ac,Candidatos):-
I1 is I+1,
(I=<Pop_size->
              media_desvio(Media,Desvio),
              MD is Media+Desvio/2,
              i(_,I,_,_,_,Erro),
              (Erro=<MD -> candidatos_classe(I1,Pop_size,[I|Ac],Candidatos);
                           candidatos_classe(I1,Pop_size,Ac,Candidatos));
Candidatos=Ac).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Faz a chamada para da rotina de  classificacao, cada indifivuo pode guiar a construcao de uma
% classe com base com todos os outros individuos
classificacao([]):- !.
classificacao([I|Candidatos]):-
classe([I],Candidatos,[]),
classificacao(Candidatos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Rotina que constroi uma classe guida por um individuo, se a classe ja existe
o processo de finalizada, caso contrário são calculadas as opropriedades da  classe
e o fato esfera/4 é definido o individuo highlander so definido se o erro da
classe for muito pequeno*/

classe(Classe_des,[],Invasores_new):- % finalizacao da classe
length(Classe_des,T_classe),
(T_classe>1 -> sort(Classe_des,Classe_ord),

nb_getval(invasores,Invasores_old),
append(Invasores_new,Invasores_old, Invasores), nb_setval(invasores,Invasores),
               classe_ja_existe(1,Classe_ord); true). % teste de existencia

classe(Classe,[I|Candidatos],Invasores_old):- % construcao da classe com base na distancia minima euclidiana
(member(I,Classe)-> classe(Classe,Candidatos);
                    encontra_distancia_classe([I|Classe],[],Distancias),


                    nb_getval(highlander,Highlanderes),
                    % se existir algum individuo highlandrer na classe o raio da classe sera reduzido
                    (existe(Classe,Highlanderes)-> distancia_minima_high(D_min),distancia_maxima_high(D_max);
                                                   distancia_minima(D_min),distancia_maxima(D_max)),

                    encontra_invasor(Distancias,D_min,[],Invasores), % se o individuo tiver um D maior que o permitido o D dele aparece aqui
                    encontra_excluido(Distancias,D_max,[],Excluidos), % se o D do individuo e menor que o permitido o D dele aparece aqui
                    (Excluidos=[],Invasores=[] -> classe([I|Classe],Candidatos,Invasores_old);
                                Invasores\==[] -> append(Invasores,Invasores_old,Invasores_new),
                                                  classe(Classe,Candidatos,Invasores_new);
                       Excluidos\==[]          -> classe(Classe,Candidatos,Invasores_old))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testa  a existencia de uma classe construida pelo classe
classe_ja_existe(Ac,Classe_ord):-
(esfera(Ac,Classe_ac,_,_,_)-> (Classe_ord=Classe_ac-> true; Ac1 is Ac+1, classe_ja_existe(Ac1,Classe_ord));

           nb_setval(n_classe,Ac),
           propriedades_da_classe(Classe_ord,Centroide,Erro_centroide,Highlander),
           (Highlander =[]-> assert(esfera(Ac,Classe_ord,Centroide,Erro_centroide,[]));
                             nb_getval(highlander,H),
                             (member(Highlander,H)->true;
                             nb_setval(highlander,[Highlander|H])), % adiciona um highlander
                             i(_,Highlander,P_high,_,_,Erro_high),
                             assert(esfera(Ac,Classe_ord,P_high,Erro_high,Highlander)) )).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcula o vetor centroide de uma clsse e o highlander caso o erro da classe seja
% inferior a 1e-2
propriedades_da_classe(Classe,Centroide,Erro_centro,Highlander):-
lista_vazia(Lista_vazia),
length(Classe,N),
calcula_centroide(Classe,N,Lista_vazia,Centroide),
intervalo_t(Inicio,Fim,Step),
espaco_t(Inicio,Fim,Step,Vetor_t),
calcula_erro_funcao(Centroide,Vetor_t,[],Erro_centro),
intervalos(Intervalos),
converte_centroide_unitario(Intervalos,Centroide,[],Unitario_centro),
distancia_minima(D_min),
erro_highlander(Erro_h),
(Erro_centro=<Erro_h -> highlander(Classe,Unitario_centro,D_min,_,Highlander);
                        Highlander=[]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcula as coodenada do vetor centroide
calcula_centroide([],N,Soma_posicoes,Centroide):-
maplist(divide_por(N),Soma_posicoes,Centroide).

calcula_centroide([C|Classe],N,Ac_centro,Centroide):-
i(_,C,Parametros,_,_,_),
soma_vetor(Ac_centro,Parametros,[],Ac_centro1),
calcula_centroide(Classe,N,Ac_centro1,Centroide).

% suporte para calcular o vetor centroide
divide_por(N,X,Y):- Y is X/N.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define a existencia de uma vetor extermamente proximo ao centroide com erro muito
% pequeno, este individuo sera imortal a partir deste instante e sera adicionado
% no fato highlander/1, cada highlander simboliza uma solucao permanente
% highlander(Classe,Unitario_centro,D_min,Ac_h,Highlander)

highlander([],_,_,Ac_h,Highlander):- (var(Ac_h)-> Highlander=[]; Highlander=Ac_h).

highlander([C|Classe],Unitario,D_high,Ac_h,Highlander):-
i(_,C,_,_,Uni,Erro),
maplist(diferenca_ao_2,Uni,Unitario,Distancias),sumlist(Distancias,Soma_distancias),
Distancia is sqrt(Soma_distancias),
ordem_highlander(Ordem_h),
media_desvio(Media,_), Erro_h is Media/(10^Ordem_h),
(Distancia<D_high,Erro<Erro_h  ->  highlander(Classe,Unitario,Distancia,C,Highlander);
 Distancia>=D_high -> highlander(Classe,Unitario,D_high,Ac_h,Highlander);
       Erro>Erro_h -> highlander(Classe,Unitario,D_high,Ac_h,Highlander)).


converte_centroide_unitario([],[],Ac,Unitario):- reverse(Ac,Unitario).
converte_centroide_unitario([[I,F]|Intervalos],[C1|Coordenadas],Ac,Unitario):-
 Intervalo is F-I,
 P is C1-I,
 U is P/Intervalo,
converte_centroide_unitario(Intervalos,Coordenadas,[U|Ac],Unitario).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% encontra  todos os erros entre os individuos de uma classe ou conjuntos
encontra_distancia_classe([_],Distancias,Distancias).

encontra_distancia_classe([I|Classe],Ac_d,Distancias):-
encontra_distancia_individuo(I,Classe,[],Distancias_parcial),
append(Distancias_parcial,Ac_d,Ac_d1),
encontra_distancia_classe(Classe,Ac_d1,Distancias).


encontra_distancia_individuo(_,[],Distancias,Distancias).
encontra_distancia_individuo(I,[C|C1],Ac_d,Distancias):-
(i2j(I,C,_,Distancia)->true;
 i2j(C,I,_,Distancia)-> true; format('i2j ~w ~w nao existe ~n',[C,I]), trace),
encontra_distancia_individuo(I,C1,[[Distancia,I,C]|Ac_d],Distancias).


%%%%%%%%%%%%%%%%%%%%% SUPORTE - CONSTRUCAO DE CLASSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enconstra os individuos que sao invasores o individuo mais forte (menor erro) sobrevive
encontra_invasor([],_,Ac,Invasores):- list_to_set(Ac,Invasores).
encontra_invasor([[D1,I1,I2]|Distancias],D_min,Ac,Invasores):-
(D1<D_min -> % inicia o conflito
i(_,I1,_,_,_,Erro1),
i(_,I2,_,_,_,Erro2),
                    (Erro1=<Erro2 -> encontra_invasor(Distancias,D_min,[I2|Ac],Invasores);
                      Erro1>Erro2 -> encontra_invasor(Distancias,D_min,[I1|Ac],Invasores));
encontra_invasor(Distancias,D_min,Ac,Invasores)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enconstra os individuos que sao invasores o individuo mais forte (menor erro) sobrevive
encontra_excluido([],_,Ac,Excluidos):- list_to_set(Ac,Excluidos).
encontra_excluido([[D1,I1,I2]|Distancias],D_min,Ac,Excluidos):-
(D1>D_min -> % inicia o conflito
i(_,I1,_,_,_,Erro1),
i(_,I2,_,_,_,Erro2),
                    (Erro1=<Erro2 -> encontra_excluido(Distancias,D_min,[I2|Ac],Excluidos);
                      Erro1>Erro2 -> encontra_excluido(Distancias,D_min,[I1|Ac],Excluidos));
encontra_excluido(Distancias,D_min,Ac,Excluidos)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define qual é o raio de uma classe
encontra_raio_classe([],Diametro,Raio_classe):-Raio_classe is Diametro/2.
encontra_raio_classe([[D|_]|Distancias],D1,Raio_classe):-
(D>D1 -> Distancias-> encontra_raio_classe(Distancias,D,Raio_classe);
D=<D1 -> encontra_raio_classe(Distancias,D,Raio_classe)).

%
existe([],_):- fail.
existe([A|A1],Conjunto):-
(member(A,Conjunto)-> true;
                      existe(A1,Conjunto)).


% retorna sucesso se X >=C
maior_que(C,X):-(X>C -> true; fail).

% retorna sucesso se X =<C
menor_que(C,X):-(X<C -> true; fail).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
