% Author:
% Date: 03/12/06

populacao_inicial:-
pop_size(Size),
abolish(i/6),
cria_individuos(1,Size).

% Faz a chamada para criar vários indivíduos
% cria os individuos com codigos em ordem sequencial
cria_individuos(Inicio,Fim):-
(Inicio=< Fim->
Print is Inicio/1003,(integer(Print)-> format('~w indivíduos~n',[Inicio]);true),
precisao(Precisao),
intervalos(Intervalos),
cria_um_individuo(Inicio,Precisao,Intervalos,[],[],[]),
Inicio2 is round(Inicio+1),
cria_individuos(Inicio2,Fim);
Inicio>Fim -> true).


% cria os individios com os codigos que estao na lista
cria_individuos_lista([]):-!.
cria_individuos_lista([C|Codigos]):-
precisao(Precisao),
intervalos(Intervalos),
cria_um_individuo(C,Precisao,Intervalos,[],[],[]),
cria_individuos_lista(Codigos).

% cris in individuo randomico e coloca-o no funtor ser/4
% i(Geracao, Codigo,Parametros_reais, Parametros_binarios)

cria_um_individuo(Codigo,[],[],Reais_r,Strings_r,Unitarios_r):-
reverse(Reais_r,Reais),
reverse(Strings_r,Strings),
reverse(Unitarios_r,Unitarios),
nb_getval(geracao,G),
intervalo_t(Inicio,Fim,Step),
espaco_t(Inicio,Fim,Step,Vetor_t),

calcula_erro_funcao(Reais,Vetor_t,[],Erro),
assert(i(G,Codigo,Reais,Strings,Unitarios,Erro)).

cria_um_individuo(Codigo,[P|Precisao],[[Inicio,Fim]|Intervalos],Ac_real,Ac_string,Ac_unitario):-
string_randomica(P,[],String),
bin2real(Inicio,Fim,String,Real),
bin2real(0.0, 1.0, String,Unitario),
cria_um_individuo(Codigo,Precisao,Intervalos,[Real|Ac_real],[String|Ac_string],[Unitario|Ac_unitario]).

