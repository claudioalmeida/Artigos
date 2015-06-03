% Author:
% Date: 05/12/06

/* Faz a chamada para os operadores geneticos.
A execucao dos operadoes em apenas uma classe nao é viavel, pois a primeira classe
seria privilegiada portanto os operadores devem ser invocados para toda a populacao
e o clan ira soibreviver se as suas informacaoes forem realmente relevantes*/

operadores_geneticos(Vivos_imi,Mortos_imi):-
%format('Operador velhice ',[]),
%                 morte_velhice(Morte_velhice,0), %  elimina os individuos da populacao de acordop com a velhice e aptidao ex doenca)
%                 length(Morte_velhice,TV),format('~w ~w~n',[Morte_velhice,TV]),
format('~t~20|mortos~t~30|vivos~n',[]),

format('Operador Habitat ',[]),
%                   findall(I,i(_,I,_,_,_,_),Populacao_habitat),
                  nb_getval(invasores,Invasores_redum),list_to_set(Invasores_redum,Invasores),nb_setval(habitat,Invasores),
                  length(Invasores,TH), format('~t~22|~0f~n',[TH]),
                  morte_habitat2(Invasores),

format('Operador predador ',[]),
                  findall(I,i(_,I,_,_,_,_),Populacao_predador), % indididuoes restantes do operados velhice
                  morte_predador(Populacao_predador,0),% 17% % elimina os individuos de menor aptidao(erro>Media+desvio) de acordo comuma fuzzy e um numero aleatório
                 % morte_por_erro(Populacao_predador), % 16 elimina os individuos de menor aptidao( erro>Media+desvio)


format('Operador imigrante ',[]),
                  vivos_mortos(Vivos_imi,Mortos_imi),
                  imigrantes(Mortos_imi),% define a criacao de individuos  aleatórios

format('Operador cross & mut',[]),
                 vivos_mortos(Vivos_cross, Mortos_cross),
                 length(Mortos_cross,TCross), format('~t~32|~0f~n',[TCross]),
                 cruzamentos_mutacao(Mortos_cross,Vivos_cross),!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPERADOES MORTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elimina uma geracao inteira devido a sua velhice

morte_velhice:-
numero_real16(Morre),
findall(Geracao,i(Geracao,_,_,_,_,_),Geracoes_repete), list_to_set(Geracoes_repete,Geracoes),
length(Geracoes,N_geracoes),
Mata is random(N_geracoes)+1,
nth1(Mata,Geracoes,Ge),nb_getval(geracao,G), Dif is G-Ge,
sig(Dif,0.1,100, Fit_morte),
(Fit_morte>Morre -> retractall(i(Ge,_,_,_,_,_));true).% elimina a geracao

% elimina os individuos que tem maior erro atraves de uma fuzzy
%individuos bons tambem podem ser eliminados

morte_predador([],P):- format('~t~22|~0f~n',[P]),nb_setval(predador,P),!.
morte_predador([I|Todos],P):-
media_desvio(Media,Desvio),
numero_real16(Morre),
Media_desvio is Media+Desvio,% trace,

i(_,I,_,_,_,Erro),  Inclina is 10/(Media+Desvio),
sig(Erro,Inclina,Media_desvio, Fit_morte),
(Fit_morte>Morre ->  nb_getval(highlander,HI),
                     (member(I,HI)-> select(I,HI,HI_new), nb_setval(highlander,HI_new);true),
                     retractall(i(_,I,_,_,_,_)),P1 is P+1,
                     morte_predador(Todos,P1);
                     morte_predador(Todos,P)).

% elimina todos os individuos que tem erro maior que Media+desvio
morte_por_erro([],M):- format('~t~22|~0f~n',[M]),!.
morte_por_erro([I|Todos],M):-
i(_,I,_,_,_,Erro),
media_desvio(Media,Desvio),
Media_desvio is Media+Desvio,
(Erro>Media_desvio ->  nb_getval(highlander,HI), % remove o highlander da lista caso ele seja morto
                       (member(I,HI)-> select(I,HI,HI_new), nb_setval(highlander,HI_new);true),
                      retractall(i(_,I,_,_,_,_)),M1 is M+1,
                      morte_por_erro(Todos,M1);
                      morte_por_erro(Todos,M)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* elimina os individuos que estao muito proximos preservando o individui de menor erro
 uma esfera de protecao é criada ao redor de cada individuo podendo formar clusteres altamente ordenados
 na forma de esferas concentricas*/

morte_habitat2([]):-!.
morte_habitat2([I|Invasores]):-
nb_getval(highlander,HI), % remove o highlander da lista caso ele seja morto
(member(I,HI)-> select(I,HI,HI_new), nb_setval(highlander,HI_new);true),
retract(i(_,I,_,_,_,_)),
morte_habitat2(Invasores).



morte_habitat1([],M):-format('~t~22|~0f~n',[M]),!.
morte_habitat1(Individuos,M):-
nth1(1,Individuos,I),
Individuos =[_|Restante],
i(_,I,_,_,_,Erro),
mais_proximo_maior_erro(I,Restante,0.001,Erro,I,Quem_morre,0,Outro), % tem que definir como calcular o D_min
(Outro=1-> retract(i(_,Quem_morre,_,_,_,_)),
           select(Quem_morre,Individuos,Individuos2), M1 is M+1,
           morte_habitat1(Individuos2,M1);
Outro=0 -> morte_habitat1(Restante,M)).


mais_proximo_maior_erro(_,[],_,_,Quem_morre,Quem_morre,O,O).
mais_proximo_maior_erro(I,[T|Todos],D_min,Ac_erro,Ac_I,Quem_morre,O,Outro):-
i(_,T,_,_,_,Erro_t),
(i2j(I,T,_,D)-> true; i2j(T,I,_,D)-> true),
(D<D_min,Erro_t>Ac_erro -> mais_proximo_maior_erro(I,Todos,D_min,Erro_t,T,Quem_morre,1,Outro);
 D<D_min,Erro_t<Ac_erro -> mais_proximo_maior_erro(I,Todos,D_min,Ac_erro,Ac_I,Quem_morre,1,Outro);
                           mais_proximo_maior_erro(I,Todos,D_min,Ac_erro,Ac_I,Quem_morre,O,Outro)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPERADOES DE CRIACAO %%%%%%%%%%%%%%%%%%%%%
% cria alguns individuos randomicos

imigrantes(Individuos):-
media_desvio(Media,_Desvio),% MD is Media+Desvio,
sig(Media,0.5,3, R),
               length(Individuos,T),
               Total is round(T*R),
               pega_parte_da_lista(Individuos,Total,[],Lista),
                    length(Lista,TCross), format('~t~32|~0f ~n',[TCross]),
               cria_individuos_lista(Lista).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotina que decide qual operador mutacao ou cross sera utilizado e se sera utilizado

cruzamentos_mutacao([],_):-!.

cruzamentos_mutacao([I|Individuos], Populacao):-

length(Populacao,Pop),
H_rand is random(Pop)+1, nth1(H_rand,Populacao,H),i(_,H,_,Strings_h,_,Erro_h),    % define um casal de individuos
M_rand is random(Pop)+1, nth1(M_rand,Populacao,M),i(_,M,_,Strings_m,_,Erro_m),

media_desvio(Media,Desvio),
MD is Media+Desvio, Inclina is 2/Desvio,

sig(Erro_h,Inclina,MD, Fit_h),
sig(Erro_m,Inclina,MD, Fit_m),
Casal_muta is sqrt(Fit_h*Fit_m*0.03),
Casal_cross is sqrt(Fit_h*Fit_m),

numero_real16(CxM),
 (CxM =<Casal_muta ->
           Quem is random(2),
          (Quem =0 -> mutacao(H,I);
           Quem =1 -> mutacao(M,I)),
             cruzamentos_mutacao(Individuos,Populacao);
CxM =<Casal_cross ->
            cross(Strings_h,Strings_m,I),
            cruzamentos_mutacao(Individuos,Populacao);
cruzamentos_mutacao([I|Individuos],Populacao)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% operador mutacao
% mutacao(Quem e mutado, Novo ser)
mutacao(N,Codigo):-
i(_,N,Reais,Strings,Unitarios,_),
intervalos(Intervalos),

length(Strings,T),
Gene is random(T)+1, % sorteia qual string sera modificada
nth1(Gene,Strings,String),

                                 length(String,S),
                                 Gene_s is random(S)+1,  % sorteia qual posisao na string sera modificada
                                 nth1(Gene_s,String,Elemento),
                                 % sustitui o elemento da string
                                 (Elemento=1-> substitui_elemento_lista(String,Gene_s,0,[],String_new);
                                  Elemento=0 -> substitui_elemento_lista(String,Gene_s,1,[],String_new)),
nth1(Gene,Intervalos,[Pi,Pf]),
bin2real(Pi,Pf,String_new,Real_new),
bin2real(0.0,1.0,String_new,Unitario_new),
substitui_elemento_lista(Reais,Gene,Real_new,[],Reais_new),
substitui_elemento_lista(Strings,Gene,String_new,[],Strings_new),
substitui_elemento_lista(Unitarios,Gene,Unitario_new,[],Unitarios_new),

intervalo_t(Inicio,Fim,Step),
espaco_t(Inicio,Fim,Step,Vetor_t),
calcula_erro_funcao(Reais_new,Vetor_t,[],Erro_new),
nb_getval(geracao,G),
assert(i(G,Codigo,Reais_new,Strings_new,Unitarios_new,Erro_new)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% faz a chamada dos dois tipos de crossover

cross(Strings_1,Strings_2,I):-
Tipo is random(2),   % define o tido de crosovre entre strings ou interno na string
length(Strings_1,T),
Cross_lista is random(T)+1,

(Tipo=1 ->   Cross_lista_1 is Cross_lista-1,   % define ate qual posicao nada sera feito e depois dela tambem nada é feito
                                               % exCros_lista=3  0,1,2,(3), 4 5 mexe apenas na posicao 4
             cross_lista(Strings_1,Strings_2,Cross_lista_1,[],[],Strings_1_new,Strings_2_new); % troca duas strings

 Tipo=0 ->     nth1(Cross_lista_i,Strings_1,String_1),
               nth1(Cross_lista_i,Strings_1,String_1),
               length(String_1, T_gene), T_gene1 is T_gene-1,
               Cross_gene is random(T_gene1)+1,
               cross_lista_interno(Strings_1,Strings_2,Cross_lista,Cross_gene,Strings_1_new,Strings_2_new)),

intervalos(Intervalos),
intervalo_t(Inicio,Fim,Step), espaco_t(Inicio,Fim,Step,Vetor_t),

converte_lista_para_real(Strings_1_new,Intervalos,[],Real_1_new),
calcula_erro_funcao(Real_1_new,Vetor_t,[],Erro_1_new),

converte_lista_para_real(Strings_2_new,Intervalos,[],Real_2_new),
calcula_erro_funcao(Real_2_new,Vetor_t,[],Erro_2_new),
nb_getval(geracao,G),
unitario(Unitarios),
(Erro_1_new<Erro_2_new ->  converte_lista_para_real(Strings_1_new,Unitarios,[],Unitario_1_new),
                           assert(i(G,I,Real_1_new,Strings_1_new, Unitario_1_new,Erro_1_new));

 Erro_1_new>=Erro_2_new -> converte_lista_para_real(Strings_2_new,Unitarios,[],Unitario_2_new),
                           assert(i(G,I,Real_2_new,Strings_2_new,Unitario_2_new, Erro_2_new)) ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tipos de crossover
% troca duas strings por inteiro entre dois individuoes

cross_lista([A|A1],[B|B1],T, Ac_A, Ac_B,Ind_A,Ind_B):-
(length(Ac_A,T)-> reverse(Ac_A,Ac_A1), append(Ac_A1,[B|A1],Ind_A),
                 reverse(Ac_B,Ac_B1), append(Ac_B1,[A|B1],Ind_B);
                 
cross_lista(A1,B1,T,[A|Ac_A],[B|Ac_B],Ind_A,Ind_B)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Troca dois pedacos de uma string de dois individuos
cross_lista_interno(Strings_1, Strings_2,Cross_lista,Cross_gene,Strings_1_new,Strings_2_new):-
nth1(Cross_lista,Strings_1, String1),
nth1(Cross_lista,Strings_2, String2),

troca_pedacos(String1, String2,Cross_gene, [],[],L1,L2),

substitui_elemento_lista(Strings_1,Cross_lista,L1,[],Strings_1_new),
substitui_elemento_lista(Strings_1,Cross_lista,L2,[],Strings_2_new).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   ROTINAS DE SUPORTE %%%%%%%%%%%%%%%%%%%%%%%%%%
% indentifica quuais os indices estam faltando para completar a populacao devido aos processo de eliminacao
vivos_mortos(Vivos,Mortos):-
pop_size(Size),
indices_faltosos(1,Size,[],Vivos,[],Mortos).

indices_faltosos(Ac,Fim,Ac_v,Vivos,Ac_m,Mortos):-
(Ac>Fim -> reverse(Ac_v,Vivos), reverse(Ac_m,Mortos);
Ac1 is Ac +1,
(i(_,Ac,_,_,_,_)-> indices_faltosos(Ac1,Fim,[Ac|Ac_v],Vivos,Ac_m,Mortos);
                 indices_faltosos(Ac1,Fim,Ac_v,Vivos,[Ac|Ac_m],Mortos))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% converte cada uma das listas de binarios para um nimero real de acordo com os intervalos definidos
converte_lista_para_real([],[],Ac,Lista_real):-reverse(Ac,Lista_real).
converte_lista_para_real([S|Strings],[[I,F]|Intervalos],Ac,Lista_real):-
bin2real(I,F,S,Real),
converte_lista_para_real(Strings,Intervalos,[Real|Ac],Lista_real).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pega N individuos da lista e coloca na LISTA aCU
pega_parte_da_lista(Indi,N,Ac,Lista):-
(length(Ac,N)-> Lista=Ac;
                nth1(1,Indi,I),
                select(I,Indi,Indi_2),
                pega_parte_da_lista(Indi_2,N,[I|Ac],Lista)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotina suporte para o operador mutacao
substitui_elemento_lista([L|L1],Posicao,Elemento,Ac,RESP):-
length(Ac,T), T1 is T+1,
(T1 =Posicao -> reverse([Elemento|Ac],Ac1),append(Ac1,L1,RESP);
               substitui_elemento_lista(L1,Posicao,Elemento,[L|Ac],RESP)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotina suporte para os operadores crossover
troca_pedacos([A|A1],[B|B1],T,Ac_A,Ac_B,Lista1,Lista2):-
(length(Ac_A,T)-> reverse(Ac_A,Ac_A1), append(Ac_A1,[B|B1],Lista1),
                  reverse(Ac_B,Ac_B1), append(Ac_B1,[A|A1],Lista2);
troca_pedacos(A1,B1,T,[A|Ac_A],[B|Ac_B],Lista1,Lista2)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cria um vetor que tem coordenadas unitarioas
unitarios:-
intervalos(I), length(I,T),
unitarios([0,1],T,[],U),abolish(unitario/1), assert(unitario(U)).

unitarios(Intervalo,T,Ac,Vetor_u):-
(length(Ac,T)-> Vetor_u=Ac;
unitarios(Intervalo,T,[Intervalo|Ac],Vetor_u)).
