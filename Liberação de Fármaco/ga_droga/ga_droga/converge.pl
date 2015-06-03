% Author:
% Date: 06/12/06

convergencia_individuos:-
media_desvio(Media,Desvio),
media_desvio_converge(M,D),
nb_getval(predador,Pred),
nb_getval(habitat,Habitat),

(Pred=0, Habitat=[] -> true;
 Media=<M,Desvio=<D->true;
                             fail).

