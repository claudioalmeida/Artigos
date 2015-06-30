/* resolve
   Utiliza o algoritmo genético para resolver o problema e escrever um arquivo de saída com uma lista de solucoes para a função de liberação de fármaco.
   Determinístico.
*/
resolve :-
	inicializa_parametros,
	nb_getval(tamanho_da_populacao,Tamanho_da_Populacao),
	gera_populacao(Tamanho_da_Populacao,Populacao),
	keysort(Populacao,Populacao_Ordenada),
	nb_getval(numero_de_geracoes,Numero_de_Geracoes),
	nb_setval(populacao_inicial,Populacao_Ordenada),
	resolve(Numero_de_Geracoes),
	nb_getval(limite_de_fitness_para_ser_considerado_solucao,Limite_de_Fitness_para_Ser_Considerado_Solucao),
		
	nb_getval(probabilidade_de_mutacao,Probabilidade_de_Mutacao),
	nb_getval(probabilidade_de_rotacao,Probabilidade_de_Rotacao),
	nb_getval(probabilidade_de_crossover,Probabilidade_de_Crossover),
	nb_getval(numero_de_geracoes_para_revisao_dos_parametros,Numero_de_Geracoes_para_Revisao_dos_Parametros),
	nb_getval(menor_evolucao_aceitavel_por_geracao,Menor_Evolucao_Aceitavel_por_Geracao),
	nb_getval(melhor_fitness_encontrada,Melhor_Fitness_Encontrada),
	
	atom_concat('Fitness_',Melhor_Fitness_Encontrada,Nome_do_Arquivo_Parcial1),
	atom_concat(Nome_do_Arquivo_Parcial1,'-Populacao_',Nome_do_Arquivo_Parcial2),
	atom_concat(Nome_do_Arquivo_Parcial2,Tamanho_da_Populacao,Nome_do_Arquivo_Parcial3),
	atom_concat(Nome_do_Arquivo_Parcial3,'-Geracoes_',Nome_do_Arquivo_Parcial4),
	atom_concat(Nome_do_Arquivo_Parcial4,Numero_de_Geracoes,Nome_do_Arquivo_Parcial5),
	atom_concat(Nome_do_Arquivo_Parcial5,'-Mutacao_',Nome_do_Arquivo_Parcial6),
	atom_concat(Nome_do_Arquivo_Parcial6,Probabilidade_de_Mutacao,Nome_do_Arquivo_Parcial7),
	atom_concat(Nome_do_Arquivo_Parcial7,'-Rotacao_',Nome_do_Arquivo_Parcial8),
	atom_concat(Nome_do_Arquivo_Parcial8,Probabilidade_de_Rotacao,Nome_do_Arquivo_Parcial9),
	atom_concat(Nome_do_Arquivo_Parcial9,'-Crossover_',Nome_do_Arquivo_Parcial10),
	atom_concat(Nome_do_Arquivo_Parcial10,Probabilidade_de_Crossover,Nome_do_Arquivo_Parcial11),
	atom_concat(Nome_do_Arquivo_Parcial11,'-Revisao_',Nome_do_Arquivo_Parcial12),
	atom_concat(Nome_do_Arquivo_Parcial12,Numero_de_Geracoes_para_Revisao_dos_Parametros,Nome_do_Arquivo_Parcial13),
	atom_concat(Nome_do_Arquivo_Parcial13,'-Evolucao_',Nome_do_Arquivo_Parcial14),
	atom_concat(Nome_do_Arquivo_Parcial14,Menor_Evolucao_Aceitavel_por_Geracao,Nome_do_Arquivo_Parcial15),
	atom_concat(Nome_do_Arquivo_Parcial15,'.txt',Nome_do_Arquivo),
	
	open(Nome_do_Arquivo,write,Fluxo_do_Arquivo),
	escreve_o_cabecalho(Fluxo_do_Arquivo),
	nb_getval(solucoes,Solucoes),
	escreve_as_solucoes(Solucoes,Fluxo_do_Arquivo,Limite_de_Fitness_para_Ser_Considerado_Solucao),
    close(Fluxo_do_Arquivo).

/* resolve(+Tamanho_da_Populacao,+Numero_de_Geracoes)
	O mesmo que resolve() oferecendo ao usuário a opção de definir as variáveis:
		+Tamanho_da_Populacao -> Tamanho da população.
		+Numero_de_Geracoes -> Número de gerações do algoritmo genético.
    Determinístico.
*/
resolve(Tamanho_da_Populacao,Numero_de_Geracoes) :-
	inicializa_parametros,
	nb_setval(tamanho_da_populacao,Tamanho_da_Populacao),
	nb_setval(numero_de_geracoes,Numero_de_Geracoes),
	gera_populacao(Tamanho_da_Populacao,Populacao),
	keysort(Populacao,Populacao_Ordenada),
	nb_setval(populacao_inicial,Populacao_Ordenada),
	resolve(Numero_de_Geracoes),
	nb_getval(limite_de_fitness_para_ser_considerado_solucao,Limite_de_Fitness_para_Ser_Considerado_Solucao),
	
	nb_getval(probabilidade_de_mutacao,Probabilidade_de_Mutacao),
	nb_getval(probabilidade_de_rotacao,Probabilidade_de_Rotacao),
	nb_getval(probabilidade_de_crossover,Probabilidade_de_Crossover),
	nb_getval(numero_de_geracoes_para_revisao_dos_parametros,Numero_de_Geracoes_para_Revisao_dos_Parametros),
	nb_getval(menor_evolucao_aceitavel_por_geracao,Menor_Evolucao_Aceitavel_por_Geracao),
	nb_getval(melhor_fitness_encontrada,Melhor_Fitness),
	round(Melhor_Fitness,Melhor_Fitness_Arredondada),
	
	atom_concat('Fitness_',Melhor_Fitness_Arredondada,Nome_do_Arquivo_Parcial1),
	atom_concat(Nome_do_Arquivo_Parcial1,'-Populacao_',Nome_do_Arquivo_Parcial2),
	atom_concat(Nome_do_Arquivo_Parcial2,Tamanho_da_Populacao,Nome_do_Arquivo_Parcial3),
	atom_concat(Nome_do_Arquivo_Parcial3,'-Geracoes_',Nome_do_Arquivo_Parcial4),
	atom_concat(Nome_do_Arquivo_Parcial4,Numero_de_Geracoes,Nome_do_Arquivo_Parcial5),
	atom_concat(Nome_do_Arquivo_Parcial5,'-Mutacao_',Nome_do_Arquivo_Parcial6),
	atom_concat(Nome_do_Arquivo_Parcial6,Probabilidade_de_Mutacao,Nome_do_Arquivo_Parcial7),
	atom_concat(Nome_do_Arquivo_Parcial7,'-Rotacao_',Nome_do_Arquivo_Parcial8),
	atom_concat(Nome_do_Arquivo_Parcial8,Probabilidade_de_Rotacao,Nome_do_Arquivo_Parcial9),
	atom_concat(Nome_do_Arquivo_Parcial9,'-Crossover_',Nome_do_Arquivo_Parcial10),
	atom_concat(Nome_do_Arquivo_Parcial10,Probabilidade_de_Crossover,Nome_do_Arquivo_Parcial11),
	atom_concat(Nome_do_Arquivo_Parcial11,'-Revisao_',Nome_do_Arquivo_Parcial12),
	atom_concat(Nome_do_Arquivo_Parcial12,Numero_de_Geracoes_para_Revisao_dos_Parametros,Nome_do_Arquivo_Parcial13),
	atom_concat(Nome_do_Arquivo_Parcial13,'-Evolucao_',Nome_do_Arquivo_Parcial14),
	atom_concat(Nome_do_Arquivo_Parcial14,Menor_Evolucao_Aceitavel_por_Geracao,Nome_do_Arquivo_Parcial15),
	atom_concat(Nome_do_Arquivo_Parcial15,'.txt',Nome_do_Arquivo),
	
	open(Nome_do_Arquivo,write,Fluxo_do_Arquivo),
	escreve_o_cabecalho(Fluxo_do_Arquivo),
	nb_getval(solucoes,Solucoes),	
	escreve_as_solucoes(Solucoes,Fluxo_do_Arquivo,Limite_de_Fitness_para_Ser_Considerado_Solucao),
    close(Fluxo_do_Arquivo).

/* resolve(+Numero_de_Geracoes,+Populacao,-Solucoes)
   Implementa resolve/x, onde:
		+Numero_de_Geracoes -> Número de gerações de evolução que a população inicial sofrerá.
		+Populacao -> População inicial.
		-Solucoes -> População inicial evoluída apos o número determinado de gerações.
   Determinístico.
*/
	
resolve(Numero_de_Geracoes):-
	between(1,Numero_de_Geracoes,Geracao),
	write('Geracao: '),
	write(Geracao),
	
	nb_getval(populacao_inicial,[Melhor_Fitness-Melhor_Trajeto/Cauda_do_Melhor_Trajeto|Populacao_Restante]),
	Populacao = [Melhor_Fitness-Melhor_Trajeto/Cauda_do_Melhor_Trajeto|Populacao_Restante],
	assertz(melhor_individuo(Geracao,Melhor_Fitness-Melhor_Trajeto/Cauda_do_Melhor_Trajeto)),
	nb_getval(numero_de_geracoes_para_revisao_dos_parametros,Numero_de_Geracoes_para_Revisao_dos_Parametros),
	nb_getval(numero_de_geracoes_desde_a_ultima_mudanca_de_fitness,Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness),
	nb_getval(menor_diferenca_de_fitness_aceitavel_por_geracao,Menor_Diferenca_de_Fitness_Aceitavel_por_Geracao),
		
	(Geracao > 1 ->
		Geracao_Passada is Geracao - 1,
		melhor_individuo(Geracao_Passada,Melhor_Fitness_Geracao_Passada-Melhor_Trajeto_Geracao_Passada/_),
		Diferenca_de_Fitness is abs(Melhor_Fitness - Melhor_Fitness_Geracao_Passada)
	 ;
		Diferenca_de_Fitness = Menor_Diferenca_de_Fitness_Aceitavel_por_Geracao
	),
	
	(Diferenca_de_Fitness < Menor_Diferenca_de_Fitness_Aceitavel_por_Geracao ->
		Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado is Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness + 1
	 ;
		Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado = 0
	),
	
	nb_setval(numero_de_geracoes_desde_a_ultima_mudanca_de_fitness,Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado),
	
	(Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado >=  Numero_de_Geracoes_para_Revisao_dos_Parametros ->
		nb_setval(numero_de_geracoes_desde_a_ultima_mudanca_de_fitness,0),
		%statistics,
		/*nb_getval(probabilidade_de_mutacao,Probabilidade_de_Mutacao),
		Probabilidade_de_Mutacao_Atualizada is Probabilidade_de_Mutacao * 1.1,
		nb_setval(probabilidade_de_mutacao,Probabilidade_de_Mutacao_Atualizada),
						
		nb_getval(probabilidade_de_rotacao,Probabilidade_de_Rotacao),
		Probabilidade_de_Rotacao_Atualizada is Probabilidade_de_Rotacao * 1.1,
		nb_setval(probabilidade_de_rotacao,Probabilidade_de_Rotacao_Atualizada),
		
		nb_getval(probabilidade_de_crossover,Probabilidade_Crossover),
		Probabilidade_Crossover_Atualizada is Probabilidade_Crossover * 0.9,
		nb_setval(probabilidade_de_crossover,Probabilidade_Crossover_Atualizada),*/
		
		trechos_iguais(Melhor_Trajeto,Melhor_Trajeto_Geracao_Passada,[_-[Inicio_do_Trecho_Igual_com_Maior_Fitness, Final_do_Trecho_Igual_com_Maior_Fitness,	Trecho_Igual_com_Maior_Fitness/[]]|_]),
		permuta_individuo(Trecho_Igual_com_Maior_Fitness,_-Permutacao_do_Trecho_Igual_com_Maior_Fitness/Cauda_da_Permutacao_do_Trecho_Igual_com_Maior_Fitness_Escolhida),
		extrair_sublistas(Inicio_do_Trecho_Igual_com_Maior_Fitness,Final_do_Trecho_Igual_com_Maior_Fitness,Melhor_Trajeto/Cauda_do_Melhor_Trajeto,Prefixo_do_Trecho_Igual/Cauda_do_Prefixo_do_Trecho_Igual,_,Sufixo_do_Trajeto_Igual/Cauda_do_Sufixo_do_Trajeto_Igual),
		
		Cauda_da_Permutacao_do_Trecho_Igual_com_Maior_Fitness_Escolhida = Sufixo_do_Trajeto_Igual,
		Cauda_do_Prefixo_do_Trecho_Igual = Permutacao_do_Trecho_Igual_com_Maior_Fitness,
		fitness(Prefixo_do_Trecho_Igual,Fitness_do_Individuo_Permutado),
		Individuo_Permutado = Fitness_do_Individuo_Permutado-Prefixo_do_Trecho_Igual/Cauda_do_Sufixo_do_Trajeto_Igual,
		
		Ultima_Geracao_com_Mudanca_de_Fitness is Geracao - Numero_de_Geracoes_desde_a_Ultima_Mudanca_de_Fitness_Atualizado,
		melhor_individuo(Ultima_Geracao_com_Mudanca_de_Fitness,Ultima_Melhor_Fitness_antes_da_Estagnacao-Ultimo_Melhor_Individuo_antes_da_Estagnacao),
		
		rotacao_total(Ultima_Melhor_Fitness_antes_da_Estagnacao-Ultimo_Melhor_Individuo_antes_da_Estagnacao,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente),
		Populacao_Atualizada = [Melhor_Individuo_Rotado_Totalmente,Individuo_Permutado,Segundo_Melhor_Individuo_Rotado_Totalmente|Populacao]
	 ;

		Populacao_Atualizada = Populacao
	),
	
	evolucao(Populacao_Atualizada,Populacao_Evoluida),
	nb_setval(populacao_inicial,Populacao_Evoluida),
	nb_getval(populacao_inicial,[Melhor_Fitness_da_Populacao_Evoluida-_|_]),
	nb_setval(melhor_fitness_encontrada,Melhor_Fitness_da_Populacao_Evoluida),

	(Geracao = Numero_de_Geracoes -> 
		nb_setval(solucoes,Populacao_Evoluida)
	 ; 
	 fail).