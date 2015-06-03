% Author:
% Date: 17/12/06
% Dedine o indice dos nomes de arquivos

nome_arquivos(N):-
concat_atom([geracao,N],'_',Geracao),file_name_extension(Geracao,txt,Geracao_file),
concat_atom([candidatos,N],'_',Candidatos),file_name_extension(Candidatos,txt,Candidatos_file),
concat_atom([classe,N],'_',Classe),file_name_extension(Classe,txt,Classe_file),
concat_atom([highlander,N],'_',High),file_name_extension(High,txt,High_file),
(exists_file(Geracao_file), exists_file(Candidatos_file), exists_file(Classe_file), exists_file(High_file)->
                    N1 is N+1,
                    nome_arquivos(N1);
nb_setval(file_nu,N)). 





% escreve os resultados em arquivos para posterior verificacao


escreve_files:-
close(geracao),
nb_getval(file_nu,Nu),

concat_atom([classe,Nu],'_',Classe),
file_name_extension(Classe,txt,Classe_file),
(exists_file(Classe_file)-> delete_file(Classe_file);true),
append(Classe_file),
escreve_all_classe(1),
told,


concat_atom([highlander,Nu],'_',High_nu),
file_name_extension(High_nu,txt,High_file),
(exists_file(High_file)-> delete_file(High_file);true),
append(High_file),
nb_getval(highlander,Hi),escreve_highlander_lista(1,Hi),
told,



concat_atom([candidatos,Nu],'_',Candidatos_nu),
file_name_extension(Candidatos_nu,txt,Candidatos_file),
open(Candidatos_file,write,_,[alias(c)]),
nb_getval(candidatos,Candidatos),
escreve(Candidatos),
close(c),

% script do linux
(current_prolog_flag(unix,true)-> 
shell('rm -f all'), 
concat_atom([geracao,Nu],'_',GE1), concat_atom([GE1,txt],'.',Ger),
concat_atom([cat, Ger, Classe_file, High_file, '>', all], ' ', Junta),
shell(Junta),
pop_size(POP),
media_desvio_converge(M,_),
concat_atom(['mail gpvoga@gmail.com -s \'', numero,POP, Nu, M, '\'', '<', all],' ', Mail),
concat_atom(['mail gpvoga@hotmail.com -s \'', numero,POP, Nu,M, '\'', '<', all],' ', Mail2),
 shell(Mail), shell(Mail2); true).


escreve([]).
escreve([C|C1]):-
i(_,C,[X1,X2,X3,X4],_,_,Erro),
format(c,'~w ~w ~w ~w ~w~n',[X1,X2,X3,X4,Erro]),
escreve(C1).

