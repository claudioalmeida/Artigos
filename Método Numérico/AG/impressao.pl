/* escreve_cabecalho(+Stream)
   Escreve o cabeçalho do arquivo com os valores das variáveis definidas, onde:
		+Stream -> Fluxo do arquivo de saída.
 */
escreve_cabecalho(Stream) :-
	format(Stream,'~`=t ~164|~n',[]),
	format(Stream,'~` t ~w ~` t ~164|~n', ['Resultados Algoritmo Genético Caixeiro Viajante']),
	format(Stream,'~`=t ~164|~n',[]),
	format(Stream,'~` t ~w ~` t ~164|~n', ['Parâmetros']),
	format(Stream,'~`-t ~164|~n',[]),
	get_time(X), 
	format_time(atom(Data), '%c', X),
	statistics(runtime,[_,Y]), 
	T is Y/1000,
	nb_getval(tamanho_da_populacao,Tp),
	nb_getval(numero_de_geracoes,Ng),
	format(Stream,'	~w ~w 	~w ~3f~w 	~w ~w 	~w ~w~n~n', ['Data = ', Data, 'Tempo de execução = ', T,'s','Tamanho da população = ',	Tp,
	'Número de gerações = ',Ng]),
	nb_getval(taxa_de_migracao,Tmi),
	TmiPorcento is Tmi * 100,
	nb_getval(ldlf,Ldlf),
	nb_getval(limite_da_distancia_euclidiana_no_torneio,Lde),

	format(Stream,'	~w ~2f~w 		~w ~w 			~w ~2f~n~n', ['Taxa de migração = ', TmiPorcento, '%','Limite de erro = ', 
	Ldlf,'Limite do Torneio em Habitat = ',	Lde]),
	format(Stream,'~`=t ~164|~n',[]),
	format(Stream,'~` t ~w ~` t ~164|~n', ['Soluções']),
	format(Stream,'~w  		~w ~` t ~w ~` t ~164|~n', ['Posição','Distância','Trajeto']),
	format(Stream,'~`-t ~164|~n',[]).
	
	
/* escreve_solucoes(+Populacao,+Stream,+LimiteErro)
   Escreve as soluções encontradas no arquivo de saída, onde:
		+Populacao -> População final após evolução.
		+Stream -> Fluxo do arquivo de saída.
		+LimiteErro -> Limite de erro da fitness no qual um indivíduo é considerado uma solução.
 */

escreve_solucoes([F-Trajeto/_|Solucoes],Stream,LimiteErro) :- 
		esc_solucoes(0,[F-Trajeto/_|Solucoes],Stream,LimiteErro).
	
/* esc_solucoes(+PosiçãoIndividuo,+Populacao,+Stream,+LimiteErro)
   Escreve as soluções encontradas no arquivo de saída, onde:
		+PosiçãoIndividuo -> Posição do indivíduo em relação ao seu fitness (quanto menor o valor da posição, melhor é o indivíduo).
		+Populacao -> População final após evolução.
		+Stream -> Fluxo do arquivo de saída.
		+LimiteErro -> Limite de erro da fitness no qual um indivíduo é considerado uma solução.
 */
esc_solucoes(_,[],Stream, _) :- 
	format(Stream,'~`=t ~164|~n',[]).

esc_solucoes(PosicaoIndividuo,[F-Trajeto/_|Solucoes],Stream,LimiteErro) :- 
	(F =< LimiteErro ->
		PosicaoIndividuoAtualizada is PosicaoIndividuo + 1,
		format(Stream,'  ~|~`0t~d~3+		 ~10f		~w~n', [PosicaoIndividuoAtualizada,F,Trajeto]),
		esc_solucoes(PosicaoIndividuoAtualizada,Solucoes,Stream,LimiteErro)
	 ;
		esc_solucoes(PosicaoIndividuo,[],Stream,LimiteErro)).	
	