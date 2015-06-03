% Author:
% Date: 17/12/06
z:-[escreve], escreve_classe, escreve_highlander.
% rotinas de escrita de resultados


escreve_classe:-
(escreve_classe(n)-> true;
 escreve_classe(s)-> escreve_all_classe(1)).
 
 
 escreve_all_classe(Ac):-
  Ac1 is Ac+1,
  (esfera(Ac,Classe,Centroide,Erro,Highlander),Ac=1->
          format('~`_t~w~80|~n',['_']),
          format('~t~30|CLASSES ENCONTRADAS~n',[]),
          format('Nº~t~5|D~t~20|Cs~t~35|A~t~50|H~t~65|Freq~t~70|H.Lander~t~80|Erro~n',[]),
          length(Classe,T_classe),
          format('~0f',[Ac]),
          format('~t~5|~10f~t~20|~10f~t~35|~10f~t~50|~10f',Centroide),
          format('~t~65|~0f',[T_classe]),
          (Highlander=[]-> true; format('~t~70|~0f',[Highlander])),
          format('~t~80|~2e~n',[Erro]),
          
          escreve_all_classe(Ac1);
  esfera(Ac,Classe,Centroide,Erro,Highlander)->
          length(Classe,T_classe),
          format('~0f',[Ac]),
          format('~t~5|~7f~t~20|~7f~t~35|~7f~t~50|~7f',Centroide),
          format('~t~65|~0f',[T_classe]),
          (Highlander=[]-> true; format('~t~70|~0f',[Highlander])),
          format('~t~80|~2e~n',[Erro]),
          escreve_all_classe(Ac1);
  true).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

escreve_highlander:-
(escreve_highlander(n)-> true;
 escreve_highlander(s)-> nb_getval(highlander,Hi),escreve_highlander_lista(1,Hi)).
 
escreve_highlander_lista(_,[]).
escreve_highlander_lista(Ac,[H|Highlander]):-
  Ac1 is Ac+1,
  i(_,H,Centroide,_,_,Erro),
 (Ac=1,[H|Highlander]\==[]->
          format('~`_t~w~80|~n',['_']),
          format('~t~25|INDIVIDUOS HIGHLANDER~n',[]),
          format('Nº~t~5|D~t~20|Cs~t~35|A~t~50|H~t~70|Nome~t~80|Erro~n',[]),
          format('~0f',[Ac]),
          format('~t~5|~10f~t~20|~10f~t~35|~10f~t~50|~10f',Centroide),
          format('~t~70|~0f~t~80|~2e~n',[H,Erro]),
          escreve_highlander_lista(Ac1,Highlander);

          format('~0f',[Ac,H]),
          format('~t~5|~10f~t~20|~10f~t~35|~10f~t~50|~10f',Centroide),
          format('~t~70|~0f~t~80|~2e~n',[H,Erro]),
          escreve_highlander_lista(Ac1,Highlander);
  true).

