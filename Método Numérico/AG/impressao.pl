/* escreve_o_cabecalho(+Fluxo_do_Arquivo)
	Escreve o cabeçalho do arquivo com os valores das variáveis definidas, onde:
		+Fluxo_do_Arquivo -> Fluxo do arquivo de saída.
	Determinístico.
 */
escreve_o_cabecalho(Fluxo_do_Arquivo) :-
	format(Fluxo_do_Arquivo,'~`=t ~164|~n',[]),
	format(Fluxo_do_Arquivo,'~` t ~w ~` t ~164|~n', ['Resultados Algoritmo Genético Caixeiro Viajante']),
	format(Fluxo_do_Arquivo,'~`=t ~164|~n',[]),
	format(Fluxo_do_Arquivo,'~` t ~w ~` t ~164|~n', ['Parâmetros']),
	format(Fluxo_do_Arquivo,'~`-t ~164|~n',[]),
	get_time(Data_Parcial), 
	format_time(atom(Data), '%c', Data_Parcial),
	statistics(runtime,[_,Tempo_de_Execucao_Parcial]), 
	Tempo_de_Execucao is Tempo_de_Execucao_Parcial/1000,
	nb_getval(tamanho_da_populacao,Tamanho_da_Populacao),
	nb_getval(numero_de_geracoes,Numero_de_Geracoes),
	format(Fluxo_do_Arquivo,'	~w ~w 	~w ~3f~w 	~w ~w 	~w ~w~n~n', ['Data = ', Data, 'Tempo de execução = ', Tempo_de_Execucao,'s','Tamanho da população = ',	Tamanho_da_Populacao,
	'Número de gerações = ',Numero_de_Geracoes]),
	nb_getval(taxa_de_migracao,Taxa_de_Migracao),
	Taxa_de_Migracao_em_Porcentagem is Taxa_de_Migracao * 100,
	nb_getval(limite_de_fitness_para_ser_considerado_solucao,Limite_de_Fitness_para_Ser_Considerado_Solucao),
	nb_getval(limite_da_distancia_euclidiana_para_eliminacao_no_torneio,Limite_da_Distancia_Euclidiana_para_Eliminacao_no_Torneio),

	format(Fluxo_do_Arquivo,'	~w ~2f~w 		~w ~w 			~w ~2f~n~n', ['Taxa de migração = ', Taxa_de_Migracao_em_Porcentagem, '%','Limite de erro = ', 
	Limite_de_Fitness_para_Ser_Considerado_Solucao,'Limite do Torneio em Habitat = ',	Limite_da_Distancia_Euclidiana_para_Eliminacao_no_Torneio]),
	format(Fluxo_do_Arquivo,'~`=t ~164|~n',[]),
	format(Fluxo_do_Arquivo,'~` t ~w ~` t ~164|~n', ['Soluções']),
	format(Fluxo_do_Arquivo,'~w  		~w ~` t ~w ~` t ~164|~n', ['Posição','Distância','Trajeto']),
	format(Fluxo_do_Arquivo,'~`-t ~164|~n',[]).
	
	
/* escreve_as_solucoes(+Populacao,+Fluxo_do_Arquivo,+Limite_de_Erro)
   Escreve as soluções encontradas no arquivo de saída, onde:
		+Populacao -> População final após evolução.
		+Fluxo_do_Arquivo -> Fluxo do arquivo de saída.
		+Limite_de_Erro -> Limite de erro da fitness no qual um indivíduo é considerado uma solução.
 */

escreve_as_solucoes([Fitness-Trajeto/_|Solucoes],Fluxo_do_Arquivo,Limite_de_Erro) :- 
		escreve_as_solucoes(0,[Fitness-Trajeto/_|Solucoes],Fluxo_do_Arquivo,Limite_de_Erro).
	
/* escreve_as_solucoes(+Posicao_do_Individuo,+Populacao,+Fluxo_do_Arquivo,+Limite_de_Erro)
   Escreve as soluções encontradas no arquivo de saída, onde:
		+Posicao_do_Individuo -> Posição do indivíduo em relação ao seu fitness (quanto menor o valor da posição, melhor é o indivíduo).
		+Populacao -> População final após evolução.
		+Fluxo_do_Arquivo -> Fluxo do arquivo de saída.
		+Limite_de_Erro -> Limite de erro da fitness no qual um indivíduo é considerado uma solução.
 */
escreve_as_solucoes(_,[],Fluxo_do_Arquivo, _) :- 
	format(Fluxo_do_Arquivo,'~`=t ~164|~n',[]).

escreve_as_solucoes(Posicao_do_Individuo,[Fitness-Trajeto/_|Solucoes],Fluxo_do_Arquivo,Limite_de_Erro) :- 
	(Fitness =< Limite_de_Erro ->
		Posicao_do_Individuo_Atualizada is Posicao_do_Individuo + 1,
		format(Fluxo_do_Arquivo,'  ~|~`0t~d~3+		 ~10f		~w~n', [Posicao_do_Individuo_Atualizada,Fitness,Trajeto]),
		escreve_as_solucoes(Posicao_do_Individuo_Atualizada,Solucoes,Fluxo_do_Arquivo,Limite_de_Erro)
	 ;
		escreve_as_solucoes(Posicao_do_Individuo,[],Fluxo_do_Arquivo,Limite_de_Erro)).	
	