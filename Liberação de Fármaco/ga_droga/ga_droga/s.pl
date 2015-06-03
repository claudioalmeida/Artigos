% Author:
% Date: 03/12/06

s:-
% [config],  % contem os fatos de configuraçao do sistema
[randomicos], % rotinas suporte para listas e numeros randomicos
[pop_ini], % define a populacao inicial do ga
[cal_erro], % todoas as rotinas relacionadas aos calculos de erro
[operadores], % todos os operadores geneticos
[funcao_droga], % contem a funcao modelo no formato f(T,[Parametros],FT)
[classe],
[converge],
[escreve],
[escreve_files],
[com], % rotinas de analise combinatória
[exaustivo].

:-s.
a:- [s], ga.

ga:-
set_random(seed(11)),
nome_arquivos(1),
[config],
% ZERANDO VARIAVEIS
statistics(cputime,T0),
nb_setval(tempo,[T0,0]),

format('~n~nZerando variaveis~n',[]),
abolish(esfera/5), assert(esfera(0,0,0,0,0)),
nb_setval(highlander,[]),
nb_setval(invasores,[]),
nb_setval(n_classe,0),
nb_setval(classificados,0),
nb_setval(predador,1), 
nb_setval(habitat,1),


abolish(i2j/4),assert(i2j(0,0,0,0)),
nb_setval(geracao,1),
unitarios,
intervalos(Intencidade), length(Intencidade,TI),
lista_vazia(0,TI,[],Lista_vazia),
abolish(lista_vazia/1), assert(lista_vazia(Lista_vazia)),
format('Criando a populacao inicial~n',[]),

% ABRINDO ARQUIVOS
nb_getval(file_nu,Nu),
concat_atom([geracao,Nu],'_',Nome),
file_name_extension(Nome,txt,File),

open(File,write,_,[alias(geracao)]),

populacao_inicial,
media_desvio_populacao,
format('Calculando erro dos individuos na 1º geracao~n',[]),
cal_erro_individuos(1,2), %calcula o erro entre dois indivíduos
again.


again:-

(convergencia_individuos -> classe,escreve_files, true;
      nb_getval(geracao,G), G1 is G+1, nb_setval(geracao,G1),
      nb_setval(cross,G),
      format('~n~n~nGeracao ~w~n',[G]),
      media_desvio_populacao,
      operadores_geneticos(Vivos,Mortos),length(Vivos,S),length(Mortos,M),
      media_desvio(Media,Desvio),

      format('Total(mortos|vivos) ~t~22|~0f~t~32|~0f~n',[M,S]),
      format('~`_t~w~40|~n',['_']),
      format('Erro medio da populacao~t~35|~3e~nDesvio medio do erro~t~35|~3e~n',[Media,Desvio]),

      format('Cal. erro ind. modificados~n',[]),
      cal_erro_individuos_lista(Mortos,1), %calcula o erro entre dois indivíduos
      format('~`_t~w~40|~n',['_']),
      integridade(1),
      erro_highlander,
      classe,
      nb_getval(n_candidatos,N_cand),
      nb_getval(n_classes,N_classes),
      nb_getval(classificados,N_c),
      nb_getval(highlander,HI), length(HI,N_high),
      format('Nº classes ~t~30|~0f~n',[N_classes]),
      
      format('Nº candidatos ~t~30|~0f~n',[N_cand]),
      format('Nº classificados ~t~30|~0f~n',[N_c]),
      format('Nº Highlander ~t~30|~0f~n',[N_high]),
      
      escreve_classe,  % rotinas de escrita opcionais
      escreve_highlander,

      statistics(cputime,T1), nb_getval(tempo,[T0,DT]),
      TG is T1-T0, TT is T1-T0+DT, nb_setval(tempo,[T1,TT]),
      format('~`_t~w~40|~n',['_']),
      format('Tempo geracao ~w=~w s~n',[G,TG]),
      format('Tempo total     ~w s~n',[TT]),
      (G=1-> format(geracao,'Geracao Media Desvio Classes Highlander tempo_g Tempo_total~n',[]);true),
      format(geracao,'~w ~w ~w ~w ~w ~w ~w~n',[G,Media,Desvio,N_classes,N_high,TG,TT]),

      !,again).


integridade(Ac):-
pop_size(Pop_size),Ac1 is Ac+1,
(Ac=<Pop_size, i(_,Ac,_,_,_,_)-> integridade(Ac1),true;
Ac>Pop_size-> true; write(erro_de_integridade),nl,trace).
