/* resolve
   Utiliza o algoritmo genético para escrever um arquivo de saída com uma lista de solucoes para a função de liberação de fármaco.
   Determinístico.
*/
resolve :-
	inicializa_variaveis,
	nb_getval(tamanho_da_populacao,Tp),
	gera_populacao(Tp,Populacao),
	keysort(Populacao,PopulacaoOrdenada),
	nb_getval(numero_de_geracoes,Ng),
	nb_setval(p,PopulacaoOrdenada),
	res(Ng),
	nb_getval(ldlf,Ldlf),
		
	nb_getval(probabilidade_mutacao,Probabilidade_Mutacao),
	nb_getval(probabilidade_rotacao,Probabilidade_Rotacao),
	nb_getval(probabilidade_crossover,Taxa_Crossover),
	nb_getval(numero_de_geracoes_para_revisao_do_contexto,Numero_de_Geracoes_para_Revisao_do_Contexto),
	nb_getval(menor_evolucao_aceitavel,Menor_Evolucao_Aceitavel),
	nb_getval(melhor_fitness,Melhor_Fitness),
	
	atom_concat('Fitness_',Melhor_Fitness,NomeArquivo1),
	atom_concat(NomeArquivo1,'-Populacao_',NomeArquivo2),
	atom_concat(NomeArquivo2,Tp,NomeArquivo3),
	atom_concat(NomeArquivo3,'-Geracoes_',NomeArquivo4),
	atom_concat(NomeArquivo4,Ng,NomeArquivo5),
	atom_concat(NomeArquivo5,'-Mutacao_',NomeArquivo6),
	atom_concat(NomeArquivo6,Probabilidade_Mutacao,NomeArquivo7),
	atom_concat(NomeArquivo7,'-Rotacao_',NomeArquivo8),
	atom_concat(NomeArquivo8,Probabilidade_Rotacao,NomeArquivo9),
	atom_concat(NomeArquivo9,'-Crossover_',NomeArquivo10),
	atom_concat(NomeArquivo10,Taxa_Crossover,NomeArquivo11),
	atom_concat(NomeArquivo11,'-Revisao_',NomeArquivo12),
	atom_concat(NomeArquivo12,Numero_de_Geracoes_para_Revisao_do_Contexto,NomeArquivo13),
	atom_concat(NomeArquivo13,'-Evolucao_',NomeArquivo14),
	atom_concat(NomeArquivo14,Menor_Evolucao_Aceitavel,NomeArquivo15),
	atom_concat(NomeArquivo15,'.txt',NomeArquivo),
	
	open(NomeArquivo,write,Stream),
	escreve_cabecalho(Stream),
	nb_getval(s,Solucoes),
	escreve_solucoes(Solucoes,Stream,Ldlf),
    close(Stream).

/* resolve(+TamanhoPopulacao,+NumeroGeracoes)
   O mesmo que resolve() oferecendo ao usuário a opção de definir as variáveis:
		+TamanhoPopulacao -> Tamanho da população.
		+NumeroGeracoes -> Número de gerações do algoritmo genético.
*/
resolve(TamanhoPopulacao,NumeroGeracoes) :-
	inicializa_variaveis,
	nb_setval(tamanho_da_populacao,TamanhoPopulacao),
	nb_setval(numero_de_geracoes,NumeroGeracoes),
	gera_populacao(TamanhoPopulacao,Populacao),
	keysort(Populacao,PopulacaoOrdenada),
	nb_setval(p,PopulacaoOrdenada),
	res(NumeroGeracoes),
	nb_getval(ldlf,Ldlf),
	
	nb_getval(probabilidade_mutacao,Probabilidade_Mutacao),
	nb_getval(probabilidade_rotacao,Probabilidade_Rotacao),
	nb_getval(probabilidade_crossover,Taxa_Crossover),
	nb_getval(numero_de_geracoes_para_revisao_do_contexto,Numero_de_Geracoes_para_Revisao_do_Contexto),
	nb_getval(menor_evolucao_aceitavel,Menor_Evolucao_Aceitavel),
	nb_getval(melhor_fitness,Melhor_Fitness),
	round(Melhor_Fitness,Melhor_Fitness_Arredondada),
	
	atom_concat('Fitness_',Melhor_Fitness_Arredondada,NomeArquivo1),
	atom_concat(NomeArquivo1,'-Populacao_',NomeArquivo2),
	atom_concat(NomeArquivo2,TamanhoPopulacao,NomeArquivo3),
	atom_concat(NomeArquivo3,'-Geracoes_',NomeArquivo4),
	atom_concat(NomeArquivo4,NumeroGeracoes,NomeArquivo5),
	atom_concat(NomeArquivo5,'-Mutacao_',NomeArquivo6),
	atom_concat(NomeArquivo6,Probabilidade_Mutacao,NomeArquivo7),
	atom_concat(NomeArquivo7,'-Rotacao_',NomeArquivo8),
	atom_concat(NomeArquivo8,Probabilidade_Rotacao,NomeArquivo9),
	atom_concat(NomeArquivo9,'-Crossover_',NomeArquivo10),
	atom_concat(NomeArquivo10,Taxa_Crossover,NomeArquivo11),
	atom_concat(NomeArquivo11,'-Revisao_',NomeArquivo12),
	atom_concat(NomeArquivo12,Numero_de_Geracoes_para_Revisao_do_Contexto,NomeArquivo13),
	atom_concat(NomeArquivo13,'-Evolucao_',NomeArquivo14),
	atom_concat(NomeArquivo14,Menor_Evolucao_Aceitavel,NomeArquivo15),
	atom_concat(NomeArquivo15,'.txt',NomeArquivo),
	
	open(NomeArquivo,write,Stream),
	escreve_cabecalho(Stream),
	nb_getval(s,Solucoes),	
	escreve_solucoes(Solucoes,Stream,Ldlf),
    close(Stream).

/* res(+NumeroGerações,+Populacao,-Solucoes)
   Implementa resolve/1, onde:
		+NumeroGeracoes -> Número de gerações de evolução que a população inicial sofrerá.
		+Populacao -> População inicial.
		-Solucoes -> População inicial evoluída apos o número determinado de gerações.
   Determinístico.
*/
	
res(NumeroGeracoes):-
	between(1,NumeroGeracoes,Geracao),
	write('Geracao: '),
	write(Geracao),
	
	nb_getval(p,Populacao),
	
	evolucao(Populacao,PopulacaoEvoluida),
		
	/*
	
	nb_getval(melhor_individuo,Melhor_Fitness-Melhor_Trajeto),
	assertz(melhor_individuo(Geracao,Melhor_Fitness-Melhor_Individuo/Cauda_Melhor_Individuo)),
	nb_getval(numero_de_geracoes_para_revisao_do_contexto,Numero_de_Geracoes_para_Revisao_do_Contexto),
	nb_setval(numero_de_geracoes_desde_a_ultima_mudanca_de_fitness,Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness),
	nb_getval(menor_diferenca_fitness_aceitavel,Menor_Diferenca_Fitness_Aceitavel),
	
	Geracao_Passada is Geracao - 1,
	melhor_individuo(Geracao_Passada,Melhor_Fitness_Anterior-Melhor_Individuo_Anterior/Cauda_Melhor_Individuo_Anterior),
	
	Diferenca_Fitness is Melhor_Fitness - Melhor_Fitness_Anterior,
	
	(Diferenca_Fitness < Menor_Diferenca_Fitness_Aceitavel ->
		Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado is Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness + 1
	 ;
		Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado = 0
	),
	
	(Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado =  Numero_de_Geracoes_para_Revisao_do_Contexto ->
		nb_getval(probabilidade_mutacao,Probabilidade_Mutacao),
		Probabilidade_Mutacao_Atualizada is Probabilidade_Mutacao * 1.1,
		nb_setval(probabilidade_mutacao,Probabilidade_Mutacao_Atualizada),
						
		nb_getval(probabilidade_rotacao,Probabilidade_Rotacao),
		Probabilidade_Rotacao_Atualizada is Probabilidade_Rotacao * 1.1,
		nb_setval(probabilidade_rotacao,Probabilidade_Rotacao_Atualizada),
		
		nb_getval(probabilidade_crossover,Probabilidade_Crossover),
		Probabilidade_Crossover_Atualizada is Probabilidade_Crossover * 0.9,
		nb_setval(probabilidade_crossover,Probabilidade_Crossover_Atualizada),
		
		trechos_iguais(Melhor_Individuo,Melhor_Individuo_Anterior,Trechos_Iguais_Melhor_Individuo_Melhor_Individuo_Anterior)	
	 ;

		true
	),*/
	
	
	nb_setval(p,PopulacaoEvoluida),
	
	(0 is Geracao mod Numero_de_Geracoes_para_Revisao_do_Contexto ->
		nb_getval(melhor_fitness,Melhor_Fitness),
		nb_setval(melhor_fitness_anterior,Melhor_Fitness)
	  ;
	  true
	),
	
	(Geracao = NumeroGeracoes -> 
		nb_setval(s,PopulacaoEvoluida)
	 ; 
	 fail).