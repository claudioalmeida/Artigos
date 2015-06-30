/* mutacao(+Individuo,-Individuo_Mutado) 
   Realiza a mutação em um gene aleatório do indivíduo gerando um indivíduo mutado, onde:
		+Individuo -> Indivíduo que sofrerá a mutação.
		-Individuo_Mutado -> Indivíduo gerado por mutação.
   Determinístico.
 */
mutacao(Individuo,Individuo_Mutado):-
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	Tamanho_do_Individuo is Numero_de_Cidades + 1,
	random(1,Numero_de_Cidades,Posicao_Inicial_da_Mutacao),
	random(Posicao_Inicial_da_Mutacao,Tamanho_do_Individuo,Posicao_Final_da_Mutacao),
	
	mutacao_com_genes_definidos(Individuo,Individuo_Mutado,Posicao_Inicial_da_Mutacao,Posicao_Final_da_Mutacao).

/* mutacao_com_genes_definidos(+Individuo,-Individuo_Mutado) 
   Realiza a mutação em um gene aleatório do indivíduo gerando um indivíduo mutado, onde:
		+Individuo -> Indivíduo que sofrerá a mutação.
		-Individuo_Mutado -> Indivíduo gerado por mutação.
		+Posicao_Inicial_da_Mutacao -> Posição do primeiro gene da mutação.
		+Posicao_Final_da_Mutacao -> Posição do segundo gene da mutação.
   Determinístico.
 */
mutacao_com_genes_definidos(Fitness-Trajeto/Cauda_do_Trajeto,Fitness_do_Individuo_Mutado-Trajeto_Mutado/Cauda_do_Trajeto_Mutado,Posicao_Inicial_da_Mutacao,Posicao_Final_da_Mutacao):-
	copy_term(Trajeto/Cauda_do_Trajeto,Copia_do_Trajeto/Cauda_do_Trajeto_Mutado),
		
	(Posicao_Inicial_da_Mutacao = Posicao_Final_da_Mutacao ->
		Fitness_do_Individuo_Mutado = Fitness,
		Trajeto_Mutado = Copia_do_Trajeto
	 ;
		nth1(Posicao_Inicial_da_Mutacao, Trajeto, Elemento_na_Posicao_Inicial_da_Mutacao),
		nth1(Posicao_Final_da_Mutacao, Trajeto, Elemento_na_Posicao_Final_da_Mutacao),
		
		substitui_enesimo(Posicao_Inicial_da_Mutacao, Copia_do_Trajeto, Elemento_na_Posicao_Final_da_Mutacao, Trajeto_Mutado_Parcial),
		substitui_enesimo(Posicao_Final_da_Mutacao, Trajeto_Mutado_Parcial, Elemento_na_Posicao_Inicial_da_Mutacao, Trajeto_Mutado),
	
		fitness(Trajeto_Mutado,Fitness_do_Individuo_Mutado)
	).
		

/* crossover_hemafrodita(+Individuo,-Individuo_Cruzado) 
   Realiza o crossover em um trecho de gene aleatório do indivíduo gerando um indivíduo cruzado, onde:
		+Individuo -> Indivíduo que sofrerá a mutação.
		-Individuo_Cruzado -> Indivíduo gerado por crossover.
   Determinístico.
 */
crossover_hemafrodita(Fitness-Trajeto/Cauda_do_Trajeto,Fitness_do_Individuo_Cruzado-Trajeto_Cruzado/Cauda_do_Trajeto_Cruzado):-
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	Tamanho_do_Individuo is Numero_de_Cidades + 1,
	random(1,Tamanho_do_Individuo,Posicao_Inicial_do_Primeiro_Trecho_do_Crossover),
	random(Posicao_Inicial_do_Primeiro_Trecho_do_Crossover,Tamanho_do_Individuo,Posicao_Inicial_do_Segundo_Trecho_do_Crossover),
	copy_term(Trajeto/Cauda_do_Trajeto,Copia_do_Trajeto/Cauda_do_Trajeto_Cruzado),
		
	(Posicao_Inicial_do_Primeiro_Trecho_do_Crossover = Posicao_Inicial_do_Segundo_Trecho_do_Crossover ->
		Fitness_do_Individuo_Cruzado = Fitness,
		Trajeto_Cruzado = Copia_do_Trajeto
	 ;
		Tamanho_Maximo_do_Crossover is Tamanho_do_Individuo - Posicao_Inicial_do_Segundo_Trecho_do_Crossover,
		random(0,Tamanho_Maximo_do_Crossover,Tamanho_Crossover),
		Posicao_Final_do_Primeiro_Trecho_do_Crossover is Posicao_Inicial_do_Primeiro_Trecho_do_Crossover + Tamanho_Crossover,
		Posicao_Final_do_Segundo_Trecho_do_Crossover is Posicao_Inicial_do_Segundo_Trecho_do_Crossover + Tamanho_Crossover,
		Posicao_Posterior_ao_Final_do_Primeiro_Trecho_do_Crossover is Posicao_Final_do_Primeiro_Trecho_do_Crossover + 1,
		Posicao_Anterior_ao_Inicial_do_Segundo_Trecho_do_Crossover is Posicao_Inicial_do_Segundo_Trecho_do_Crossover - 1,
	
		extrair_sublistas(Posicao_Inicial_do_Primeiro_Trecho_do_Crossover,Posicao_Final_do_Primeiro_Trecho_do_Crossover,Copia_do_Trajeto/Cauda_do_Trajeto_Cruzado,Prefixo_Anterior_ao_Primeiro_Trecho_do_Crossover,Primeiro_Trecho_do_Crossover,_),
		extrair_sublistas(Posicao_Inicial_do_Segundo_Trecho_do_Crossover,Posicao_Final_do_Segundo_Trecho_do_Crossover,Copia_do_Trajeto/Cauda_do_Trajeto_Cruzado,_,Segundo_Trecho_do_Crossover,Sufixo_Posterior_ao_Segundo_Trecho_do_Crossover),
		concatena_diferenca_de_lista(Prefixo_Anterior_ao_Primeiro_Trecho_do_Crossover,Segundo_Trecho_do_Crossover,Trajeto_Cruzado_Parcial1),	
	
		(Posicao_Posterior_ao_Final_do_Primeiro_Trecho_do_Crossover < Posicao_Inicial_do_Segundo_Trecho_do_Crossover ->
			extrair_sublistas(Posicao_Posterior_ao_Final_do_Primeiro_Trecho_do_Crossover,Posicao_Anterior_ao_Inicial_do_Segundo_Trecho_do_Crossover,Copia_do_Trajeto/Cauda_do_Trajeto_Cruzado,_,Trecho_entre_Primeiro_Trecho_e_Segundo_Trecho_do_Crossover,_),
			concatena_diferenca_de_lista(Trajeto_Cruzado_Parcial1,Trecho_entre_Primeiro_Trecho_e_Segundo_Trecho_do_Crossover,Trajeto_Cruzado_Parcial2),
			concatena_diferenca_de_lista(Trajeto_Cruzado_Parcial2,Primeiro_Trecho_do_Crossover,Trajeto_Cruzado_Parcial3),
			concatena_diferenca_de_lista(Trajeto_Cruzado_Parcial3,Sufixo_Posterior_ao_Segundo_Trecho_do_Crossover,Trajeto_Cruzado/Cauda_do_Trajeto_Cruzado)
		 ;
			(Posicao_Posterior_ao_Final_do_Primeiro_Trecho_do_Crossover = Posicao_Inicial_do_Segundo_Trecho_do_Crossover ->
				concatena_diferenca_de_lista(Trajeto_Cruzado_Parcial1,Primeiro_Trecho_do_Crossover,Trajeto_Cruzado_Parcial2)
			 ;
				(Posicao_Posterior_ao_Final_do_Primeiro_Trecho_do_Crossover > Posicao_Inicial_do_Segundo_Trecho_do_Crossover ->
					extrair_sublistas(Posicao_Inicial_do_Primeiro_Trecho_do_Crossover,Posicao_Anterior_ao_Inicial_do_Segundo_Trecho_do_Crossover,Copia_do_Trajeto/Cauda_do_Trajeto_Cruzado,_,Trecho_sem_Interseccao_do_Primeiro_Trecho_com_o_Segundo_Trecho_do_Crossover,_),
					concatena_diferenca_de_lista(Trajeto_Cruzado_Parcial1,Trecho_sem_Interseccao_do_Primeiro_Trecho_com_o_Segundo_Trecho_do_Crossover,Trajeto_Cruzado_Parcial2)
				)
			),
			concatena_diferenca_de_lista(Trajeto_Cruzado_Parcial2,Sufixo_Posterior_ao_Segundo_Trecho_do_Crossover,Trajeto_Cruzado/Cauda_do_Trajeto_Cruzado)
		),
		fitness(Trajeto_Cruzado,Fitness_do_Individuo_Cruzado)
	).
	
/* crossover_improved_gx(+Primeiro_Individuo,+SegundoIndividuo,-Individuo_Cruzado) 
   Realize o crossover do tipo igx (improved gx - sugerido por iranianos) entre dois indivíduos gerando um novo indivíduo, onde:
		+Primeiro_Individuo -> Primeiro indivíduo.
		+SegundoIndividuo -> Segundo indivíduo.
		-Individuo_Cruzado -> Indivíduo gerado pelo crossover improved_gx.
   Determinístico.
*/
crossover_improved_gx(_-Trajeto_do_Pai/_,_-Trajeto_da_Mae/_,Fitness_do_Individuo_Cruzado-Trajeto_Cruzado):-
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	random(0,Numero_de_Cidades,Cidade),
	
	/*remover_lista_duplamente_encadeada(pai),
	remover_lista_duplamente_encadeada(mae),
	criar_lista_duplamente_encadeada(pai,Trajeto_do_Pai),
	criar_lista_duplamente_encadeada(mae,Trajeto_da_Mae),*/
	
	criar_lista_duplamente_encadeada_com_key_value(Trajeto_do_Pai,Trajeto_do_Pai_em_Lista_Duplamente_Encadeada),
	criar_lista_duplamente_encadeada_com_key_value(Trajeto_da_Mae,Trajeto_da_Mae_em_Lista_Duplamente_Encadeada),
	hashtable:list_to_ht(Trajeto_do_Pai_em_Lista_Duplamente_Encadeada,Trajeto_do_Pai_em_Lista_Duplamente_Encadeada_com_Hash_Table),
	hashtable:list_to_ht(Trajeto_da_Mae_em_Lista_Duplamente_Encadeada,Trajeto_da_Mae_em_Lista_Duplamente_Encadeada_com_Hash_Table),
	
	crossover_improved_gx(Numero_de_Cidades,Cidade,Trajeto_do_Pai_em_Lista_Duplamente_Encadeada_com_Hash_Table,Trajeto_da_Mae_em_Lista_Duplamente_Encadeada_com_Hash_Table,0-[Cidade|Cauda_do_Trajeto]/Cauda_do_Trajeto,Cidade,Fitness_do_Individuo_Cruzado-Trajeto_Cruzado).

/* crossover_improved_gx(+Numero_de_Cidades_Restantes,+Primeira_Cidade_do_Trajeto_Cruzado,+Trajeto_do_Pai_em_Lista_Duplamente_Encadeada,+Trajeto_da_Mae_em_Lista_Duplamente_Encadeada,+Individuo_Cruzado_Parcial,+Cidade_Atual_do_Trajeto,-Individuo_Cruzado) 
   Realize o crossover do tipo igx (improved gx - sugerido por iranianos) entre dois indivíduos gerando um novo indivíduo, onde:
		+Numero_de_Cidades_Restantes -> Número de cidades que ainda faltam no trajeto.
		+Primeira_Cidade_do_Trajeto_Cruzado -> Cidade onde começa o trajeto do indivíduo cruzado.
		+Trajeto_do_Pai_em_Lista_Duplamente_Encadeada -> Trajeto do pai representado por uma lista duplamente encadeada.
		+Trajeto_da_Mae_em_Lista_Duplamente_Encadeada -> Trajeto da mãe representado por uma lista duplamente encadeada.
		+Individuo_Cruzado_Parcial -> Indivíduo cruzado construído até o momento.
		+Cidade_Atual_do_Trajeto -> Cidade onde o trajeto se encontra no momento.
		-Individuo_Cruzado -> Indivíduo gerado pelo crossover improved_gx.
   Determinístico.
*/
crossover_improved_gx(1,Primeira_Cidade_do_Trajeto_Cruzado,_,_,Fitness_do_Individuo_Cruzado_Parcial-Trajeto_Cruzado,Cidade_Atual_do_Trajeto,Fitness_do_Individuo_Cruzado-Trajeto_Cruzado) :- 
	!,
	funcao_de_paridade_de_cantor(Cidade_Atual_do_Trajeto,Primeira_Cidade_do_Trajeto_Cruzado,Funcao_de_Paridade_de_Cantor),
	distancia(Funcao_de_Paridade_de_Cantor,Distancia),
	Fitness_do_Individuo_Cruzado is Fitness_do_Individuo_Cruzado_Parcial + Distancia.

crossover_improved_gx(Numero_de_Cidades_Restantes,Primeira_Cidade_do_Trajeto_Cruzado,Trajeto_do_Pai_em_Lista_Duplamente_Encadeada,Trajeto_da_Mae_em_Lista_Duplamente_Encadeada,Fitness_do_Individuo_Cruzado_Parcial-Trajeto_Cruzado_Parcial/Cauda_do_Trajeto_Cruzado_Parcial,Cidade_Atual_do_Trajeto,Fitness_do_Individuo_Cruzado-Trajeto_Cruzado) :-
	/*pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(pai,Cidade_Atual_do_Trajeto,Cidade_Anterior_do_Trajeto_do_Pai,Cidade_Posterior_do_Trajeto_do_Pai),
	pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(mae,Cidade_Atual_do_Trajeto,Cidade_Anterior_do_Trajeto_da_Mae,Cidade_Posterior_do_Trajeto_da_Mae),*/
	
	pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(Trajeto_do_Pai_em_Lista_Duplamente_Encadeada,Cidade_Atual_do_Trajeto,Cidade_Anterior_do_Trajeto_do_Pai,Cidade_Posterior_do_Trajeto_do_Pai),
	pega_elemento_anterior_e_elemento_posterior_de_elemento_de_lista_duplamente_encadeada(Trajeto_da_Mae_em_Lista_Duplamente_Encadeada,Cidade_Atual_do_Trajeto,Cidade_Anterior_do_Trajeto_da_Mae,Cidade_Posterior_do_Trajeto_da_Mae),
	
	funcao_de_paridade_de_cantor(Cidade_Atual_do_Trajeto,Cidade_Anterior_do_Trajeto_do_Pai,Funcao_de_Paridade_de_Cantor_para_Cidade_Anterior_do_Trajeto_do_Pai),
	funcao_de_paridade_de_cantor(Cidade_Atual_do_Trajeto,Cidade_Posterior_do_Trajeto_do_Pai,Funcao_de_Paridade_de_Cantor_para_Cidade_Posterior_do_Trajeto_do_Pai),
	funcao_de_paridade_de_cantor(Cidade_Atual_do_Trajeto,Cidade_Anterior_do_Trajeto_da_Mae,Funcao_de_Paridade_de_Cantor_para_Cidade_Anterior_do_Trajeto_da_Mae),
	funcao_de_paridade_de_cantor(Cidade_Atual_do_Trajeto,Cidade_Posterior_do_Trajeto_da_Mae,Funcao_de_Paridade_de_Cantor_para_Cidade_Posterior_do_Trajeto_da_Mae),
	
	distancia(Funcao_de_Paridade_de_Cantor_para_Cidade_Anterior_do_Trajeto_do_Pai,Distancia_para_Cidade_Anterior_do_Trajeto_do_Pai),
	distancia(Funcao_de_Paridade_de_Cantor_para_Cidade_Posterior_do_Trajeto_do_Pai,Distancia_para_Cidade_Posterior_do_Trajeto_do_Pai),
	distancia(Funcao_de_Paridade_de_Cantor_para_Cidade_Anterior_do_Trajeto_da_Mae,Distancia_para_Cidade_Anterior_do_Trajeto_da_Mae),
	distancia(Funcao_de_Paridade_de_Cantor_para_Cidade_Posterior_do_Trajeto_da_Mae,Distancia_para_Cidade_Posterior_do_Trajeto_da_Mae),
	
	keysort([Distancia_para_Cidade_Anterior_do_Trajeto_do_Pai-Cidade_Anterior_do_Trajeto_do_Pai,Distancia_para_Cidade_Posterior_do_Trajeto_do_Pai-Cidade_Posterior_do_Trajeto_do_Pai,Distancia_para_Cidade_Anterior_do_Trajeto_da_Mae-Cidade_Anterior_do_Trajeto_da_Mae,Distancia_para_Cidade_Posterior_do_Trajeto_da_Mae-Cidade_Posterior_do_Trajeto_da_Mae],[Menor_Distancia-Cidade_Mais_Proxima|_]),
	
	Cauda_do_Trajeto_Cruzado_Parcial = [Cidade_Mais_Proxima|Cauda_do_Trajeto_Cruzado_Parcial_Atualizada],
	Fitness_do_Individuo_Cruzado_Parcial_Atualizado is Fitness_do_Individuo_Cruzado_Parcial + Menor_Distancia,
	Numero_de_Cidades_Restantes_Atualizado is Numero_de_Cidades_Restantes - 1,
	
	crossover_improved_gx(Numero_de_Cidades_Restantes_Atualizado,Primeira_Cidade_do_Trajeto_Cruzado,Trajeto_do_Pai_em_Lista_Duplamente_Encadeada,Trajeto_da_Mae_em_Lista_Duplamente_Encadeada,Fitness_do_Individuo_Cruzado_Parcial_Atualizado-Trajeto_Cruzado_Parcial/Cauda_do_Trajeto_Cruzado_Parcial_Atualizada,Cidade_Mais_Proxima,Fitness_do_Individuo_Cruzado-Trajeto_Cruzado).
		
/* evolucao(+Populacao,-Populacao_Evoluida)
   Aplica os operadores genéticos para evoluir a populacao, onde:
		+Populacao -> População antes da evolução.
		-Populacao_Evoluida -> População após a evolução.
   Determinístico.
 */
	
evolucao(Populacao,Populacao_Evoluida):-
	random(0,100000,Semente_do_Gerador_de_Numeros_Aleatorios),
	set_random(seed(Semente_do_Gerador_de_Numeros_Aleatorios)),
	nb_getval(tamanho_da_populacao,Tamanho_da_Populacao),
	nb_getval(taxa_de_migracao,Taxa_de_Migracao),
	length(Populacao,Tamanho_Real_da_Populacao),
	Numero_de_Migrantes is (round((Tamanho_da_Populacao * Taxa_de_Migracao))+(Tamanho_da_Populacao-Tamanho_Real_da_Populacao)),
	gera_populacao(Numero_de_Migrantes,Migrantes),
	append(Populacao,Migrantes,Populacao_com_Migrantes),
	
	pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo(Populacao_com_Migrantes,Fitness_do_Melhor_Individuo-Melhor_Individuo,Media,Fitness_do_Individuo_da_Mediana-Individuo_da_Mediana,Fitness_do_Pior_Individuo-Pior_Individuo),
	%pega_melhor_individuo_e_media_e_individuo_mediana_e_pior_individuo(Populacao,Fitness_do_Melhor_Individuo-Melhor_Individuo,Media,Fitness_do_Individuo_da_Mediana-Individuo_da_Mediana,Fitness_do_Pior_Individuo-Pior_Individuo),

	write(' | Melhor: '),
	write(Fitness_do_Melhor_Individuo),
	write(' | Media: '),
	write(Media),
	write(' | Mediana: '),
	write(Fitness_do_Individuo_da_Mediana),
	write(' | Pior: '),
	write(Fitness_do_Pior_Individuo),
	nl,
	
	nb_getval(probabilidade_de_rotacao,Probabilidade_de_Rotacao),
	random(Probabilidade),
	
	(Probabilidade =< Probabilidade_de_Rotacao ->
		rotacao(Fitness_do_Melhor_Individuo-Melhor_Individuo,1,Fitness_do_Melhor_Individuo_Rotado-Melhor_Individuo_Rotado,Fitness_do_Segundo_Melhor_Individuo_Rotado-Segundo_Melhor_Individuo_Rotado),
		rotacao(Fitness_do_Individuo_da_Mediana-Individuo_da_Mediana,1,Fitness_do_Melhor_Individuo_da_Mediana_Rotado-Melhor_Individuo_da_Mediana_Rotado,Fitness_do_Segundo_Melhor_Individuo_da_Mediana_Rotado-Segundo_Melhor_Individuo_da_Mediana_Rotado),
		rotacao(Fitness_do_Pior_Individuo-Pior_Individuo,1,Fitness_do_Melhor_Pior_Individuo_Rotado-Melhor_Pior_Individuo_Rotado,Fitness_do_Segundo_Melhor_Pior_Individuo_Rotado-Segundo_Melhor_Pior_Individuo_Rotado),
		evolucao([Fitness_do_Melhor_Individuo_Rotado-Melhor_Individuo_Rotado,Fitness_do_Segundo_Melhor_Individuo_Rotado-Segundo_Melhor_Individuo_Rotado,Fitness_do_Melhor_Individuo_da_Mediana_Rotado-Melhor_Individuo_da_Mediana_Rotado,Fitness_do_Segundo_Melhor_Individuo_da_Mediana_Rotado-Segundo_Melhor_Individuo_da_Mediana_Rotado,Fitness_do_Melhor_Pior_Individuo_Rotado-Melhor_Pior_Individuo_Rotado,Fitness_do_Segundo_Melhor_Pior_Individuo_Rotado-Segundo_Melhor_Pior_Individuo_Rotado|Populacao_com_Migrantes],[],1,Populacao_Evoluida)
	 ;
		evolucao(Populacao_com_Migrantes,[],1,Populacao_Evoluida)
	).

/* evolucao(+Populacao_a_Ser_Evoluida,+Populacao_Evoluida_Parcial,+Indice_do_Individuo_que_Esta_Sendo_Evoluido,-Populacao_Evoluida)
   Implementa evolucao/2, onde:
		+Populacao_a_Ser_Evoluida -> População que ainda falta ser evoluída (aplicar algoritmos genéticos).
		+Indice_do_Individuo_que_Esta_Sendo_Evoluido -> Contador para percorrer todos os indivíduos.
		+Populacao_Evoluida_Parcial -> População evoluída até o momento.
		-Populacao_Evoluida -> População após a evolução.
   Determinístico.
 */
evolucao([],Populacao,_,Populacao_Evoluida) :-	
	!,
	nb_getval(tamanho_da_populacao,Tamanho_da_Populacao),
	keysort(Populacao,Populacao_Ordenada),
	habitat(Populacao_Ordenada,Populacao_Pos_Habitat),
	cortar_cauda(Populacao_Pos_Habitat,Tamanho_da_Populacao,Populacao_Evoluida).
	%cortar_cauda(Populacao_Ordenada,Tamanho_da_Populacao,Populacao_Evoluida).
										
evolucao([Individuo|Populacao_a_Ser_Evoluida],Populacao_Evoluida_Parcial,Indice_do_Individuo_que_Esta_Sendo_Evoluido,Populacao_Evoluida) :-
	random(Probabilidade),
	nb_getval(probabilidade_de_crossover,Probabilidade_de_Crossover),
	nb_getval(probabilidade_de_mutacao,Probabilidade_de_Mutacao),
	Indice_do_Individuo_que_Esta_Sendo_Evoluido_Atualizado is Indice_do_Individuo_que_Esta_Sendo_Evoluido + 1,
	
	(Probabilidade =< Probabilidade_de_Crossover ->
		%nb_getval(tamanho_da_populacao,Tamanho_da_Populacao),
		%nb_getval(taxa_de_migracao,Taxa_de_Migracao),
		%Tamanho_da_Populacao_Restante is (round((1 + Taxa_de_Migracao)*Tamanho_da_Populacao) + 6 - Indice_do_Individuo_que_Esta_Sendo_Evoluido),
		length(Populacao_a_Ser_Evoluida,Tamanho_da_Populacao_Restante),
		(Tamanho_da_Populacao_Restante > 0 ->
			random(0,Tamanho_da_Populacao_Restante,Numero_Aleatorio),
			nth0(Numero_Aleatorio,Populacao_a_Ser_Evoluida,Individuo2),
			crossover_improved_gx(Individuo,Individuo2,Individuo_Crossover)
		 ;
			crossover_hemafrodita(Individuo,Individuo_Crossover)
		),
		
		(Probabilidade =< Probabilidade_de_Mutacao ->
			mutacao(Individuo,Individuo_Mutado),
			evolucao(Populacao_a_Ser_Evoluida,[Individuo,Individuo_Mutado,Individuo_Crossover|Populacao_Evoluida_Parcial],Indice_do_Individuo_que_Esta_Sendo_Evoluido_Atualizado,Populacao_Evoluida)
		 ;
			evolucao(Populacao_a_Ser_Evoluida,[Individuo,Individuo_Crossover|Populacao_Evoluida_Parcial],Indice_do_Individuo_que_Esta_Sendo_Evoluido_Atualizado,Populacao_Evoluida)
		)
	 ;
		evolucao(Populacao_a_Ser_Evoluida,[Individuo|Populacao_Evoluida_Parcial],Indice_do_Individuo_que_Esta_Sendo_Evoluido_Atualizado,Populacao_Evoluida)
	).

/* habitat(+População,-Populacao_Pos_Habitat)
   Elimina indivíduos com trajetos muito parecidos mantendo sempre o de menor fitness,onde:
		+População -> População antes do habitat.
		-Populacao_Pos_Habitat -> População após o habitat.
   Determinístico.
 */
habitat(Populacao,Populacao_Pos_Habitat) :-
	habitat(Populacao,Cauda_da_Populacao_Parcial/Cauda_da_Populacao_Parcial,Populacao_Pos_Habitat).

/* habitat(+Populacao,+Populacao_Parcial,-Populacao_Pos_Habitat)
   Implementa habitat/2, onde:
		+População -> População antes do habitat.
		+Populacao_Parcial -> População que já passou pelo habitat até o momento.
		-Populacao_Pos_Habitat -> População após o habitat.
   Determinístico.
 */
habitat([],Populacao_Pos_Habitat_Diferenca_de_Lista,Populacao_Pos_Habitat) :- 
	!,
	converte_diferenca_de_lista_em_lista(Populacao_Pos_Habitat_Diferenca_de_Lista,Populacao_Pos_Habitat).
	
habitat([Individuo|Populacao_Restante],Populacao_Parcial/[Individuo|Cauda_da_Populacao_Parcial],Populacao_Pos_Habitat) :-
	torneio(Individuo,Populacao_Restante,Cauda_da_Populacao_para_Torneio/Cauda_da_Populacao_para_Torneio,Populacao_Pos_Torneio),
	habitat(Populacao_Pos_Torneio,Populacao_Parcial/Cauda_da_Populacao_Parcial,Populacao_Pos_Habitat).

/* torneio(+Indivíduo,+Populacao,+Populacao_Parcial,-Populacao_Pos_Torneio)
   Elimina todos os indivíduos que estão no mesmo habitat do primeiro indivíduo, onde:
		+Indivíduo -> Indivíduo com menor fitness do habitat (macho alfa).
		+Populacao -> População antes do torneio.
		+Populacao_Parcial -> Acumulador quer será preenchido até formar Populacao_Pos_Habitat.
		-Populacao_Pos_Torneio -> População após o torneio.
   Determinístico.
 */	
torneio(_,[],Populacao_Pos_Torneio_Diferenca_de_Lista,Populacao_Pos_Torneio) :- 
	!,
	converte_diferenca_de_lista_em_lista(Populacao_Pos_Torneio_Diferenca_de_Lista,Populacao_Pos_Torneio).
	
torneio(Fitness_Melhor_Individuo-Melhor_Individuo,[Fitness_Proximo_Individuo-ProximoIndividuo|Populacao_Restante],Populacao_Parcial/Cauda_da_Populacao_Parcial,Populacao_Pos_Torneio) :-
	nb_getval(limite_da_diferenca_de_fitness_para_entrar_em_torneio,Limite_da_Diferenca_de_Fitness_para_Entrar_em_Torneio),
	Diferenca_de_Fitness is abs(Fitness_Proximo_Individuo-Fitness_Melhor_Individuo),
	
	(Diferenca_de_Fitness > Limite_da_Diferenca_de_Fitness_para_Entrar_em_Torneio ->
		converte_diferenca_de_lista_em_lista([Fitness_Proximo_Individuo-ProximoIndividuo|Populacao_Restante]/Cauda_da_Populacao_Parcial,Populacao_Pos_Torneio)
	 ;
		nb_getval(limite_da_distancia_euclidiana_para_eliminacao_no_torneio,Limite_da_Distancia_Euclidiana_para_Eliminacao_no_Torneio),
		nb_getval(numero_de_cidades,Numero_de_Cidades),
		
		numero_de_elementos_iguais(Fitness_Melhor_Individuo-Melhor_Individuo,Fitness_Proximo_Individuo-ProximoIndividuo,Numero_de_Elementos_Iguais),
		Porcentagem_de_Semelhanca is Numero_de_Elementos_Iguais/Numero_de_Cidades,
	
		(Porcentagem_de_Semelhanca =< Limite_da_Distancia_Euclidiana_para_Eliminacao_no_Torneio ->
			Cauda_da_Populacao_Parcial = [Fitness_Proximo_Individuo-ProximoIndividuo|Cauda_da_Populacao_Parcial_Atualizada]
		 ;
			Cauda_da_Populacao_Parcial_Atualizada = Cauda_da_Populacao_Parcial
		),
		
		torneio(Fitness_Melhor_Individuo-Melhor_Individuo,Populacao_Restante,Populacao_Parcial/Cauda_da_Populacao_Parcial_Atualizada,Populacao_Pos_Torneio)
	).

/* fitness(+Trajeto,-Fitness)
   Calcula a fitness (distância) do trajeto, onde:
		+Trajeto -> Trajeto cuja fitness se deseja calcular.
		-Fitness -> Fitness do trajeto.
   Determinístico.
 */	
 
fitness([Cidade_Inicial|Trajeto],Fitness) :-
	fitness(Cidade_Inicial,[Cidade_Inicial|Trajeto],0,Fitness).

/* fitness(+Primeira_Cidade_do_Trajeto,+Trajeto_Restante,+Fitness_Parcial,-Fitness)
   Implemente fitness/2, onde:
		+Primeira_Cidade_do_Trajeto -> Cidade onde começa o trajeto do indivíduo.
		+Trajeto_Restante -> Trajeto que ainda falta ser percorrido para avaliar a fitness.
		+Fitness_Parcial -> Fitness do trajeto até o momento.
		-Fitness -> Fitness do trajeto.
		Determinístico.
 */	
	
fitness(Cidade_Inicial, [Cidade_Atual|Fim], Fitness_Parcial, Fitness) :-
	var(Fim),
	!,
	funcao_de_paridade_de_cantor(Cidade_Atual,Cidade_Inicial,Funcao_de_Paridade_de_Cantor),
	distancia(Funcao_de_Paridade_de_Cantor,Distancia),
	Fitness is Fitness_Parcial + Distancia.
	
fitness(Cidade_Inicial, [Cidade_Atual,Proxima_Cidade|Trajeto], Fitness_Parcial, Fitness) :-
	funcao_de_paridade_de_cantor(Cidade_Atual,Proxima_Cidade,Funcao_de_Paridade_de_Cantor),
	distancia(Funcao_de_Paridade_de_Cantor,Distancia),
	Fitness_Parcial_Atualizada is Fitness_Parcial + Distancia,
	fitness(Cidade_Inicial,[Proxima_Cidade|Trajeto],Fitness_Parcial_Atualizada,Fitness).
	
/* rotacao(+Individuo,+Posicao,-Melhor_Individuo_Rotado,-Segundo_Melhor_Individuo_Rotado) 
   Realize a rotação do indivíduo (trocar uma posição - cidade - por todas as outras posições - cidades) e verifica qual o melhor indivíduo encontrado:
		+Individuo -> Indivíduo que sofrerá a rotação.
		+Posicao -> Posição onde será realizada a rotação.
		-Melhor_Individuo_Rotado -> Melhor indivíduo gerado pela rotação (ou o próprio indivíduo caso o mesmo seja melhor).
		-Segundo_Melhor_Individuo_Rotado -> Segundo melhor indivíduo gerado pela rotação.
   Determinístico.
*/
rotacao(Individuo,Posicao,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado) :-
	nb_getval(numero_de_cidades,Numero_de_Cidades),
	rotacao(Individuo,Posicao,Numero_de_Cidades,Individuo,Individuo,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado).
	
/* rotacao(+Individuo,+Posicao,+Numero_de_Cidades,+Melhor_Individuo_Rotado_Atualmente,Segundo_Melhor_Individuo_Rotado_Atualmente,-Melhor_Individuo_Rotado,-Segundo_Melhor_Individuo_Rotado)
   Implementa rotacao/2, onde:
		+Individuo -> Indivíduo que sofrerá a rotação.
		+Posicao -> Posição onde será realizada a rotação.
		+Numero_de_Cidades -> Número de cidades que faltam rotar.
		+Melhor_Individuo_Rotado_Atualmente -> Melhor indivíduo rotado até o momento.
		+Segundo_Melhor_Individuo_Rotado_Atualmente -> Segundo melhor indivíduo rotado até o momento.
		-Melhor_Individuo_Rotado -> Melhor indivíduo gerado pela rotação (ou o próprio indivíduo caso o mesmo seja melhor).
		-Segundo_Melhor_Individuo_Rotado -> Segundo melhor indivíduo gerado pela rotação.
   Determinístico.
 */
rotacao(_,_,1,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado) :- !.

rotacao(Individuo,Posicao,Numero_de_Cidades,Fitness_do_Melhor_Individuo_Rotado_Atualmente-Melhor_Individuo_Rotado_Atualmente,Fitness_do_Segundo_Melhor_Individuo_Rotado_Atualmente-Segundo_Melhor_Individuo_Rotado_Atualmente,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado) :- 
	mutacao_com_genes_definidos(Individuo,Fitness_do_Individuo_Rotado-Individuo_Rotado,Posicao,Numero_de_Cidades),
	
	(Fitness_do_Individuo_Rotado < Fitness_do_Melhor_Individuo_Rotado_Atualmente ->
		Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado_Atualmente-Melhor_Individuo_Rotado_Atualmente,
		Melhor_Individuo_Rotado_Atualmente_Atualizado = Fitness_do_Individuo_Rotado-Individuo_Rotado
	;
		Melhor_Individuo_Rotado_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado_Atualmente-Melhor_Individuo_Rotado_Atualmente,
	
		(Fitness_do_Individuo_Rotado < Fitness_do_Segundo_Melhor_Individuo_Rotado_Atualmente ->
			Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado = Fitness_do_Individuo_Rotado-Individuo_Rotado
		 ;
			Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado = Fitness_do_Segundo_Melhor_Individuo_Rotado_Atualmente-Segundo_Melhor_Individuo_Rotado_Atualmente
		 )
	),
	
	Numero_de_Cidades_Atualizado is Numero_de_Cidades - 1,
		
	rotacao(Individuo,Posicao,Numero_de_Cidades_Atualizado,Melhor_Individuo_Rotado_Atualmente_Atualizado,Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado).

/* rotacao_total(+Individuo,+Melhor_Individuo_Rotado_Totalmente,+Segundo_Melhor_Individuo_Rotado_Totalmente)
   Realiza a rotação total (em todas as posições - cidades) do indivíduo:
		+Individuo -> Indivíduo que sofrerá a rotação total.
		-Melhor_Individuo_Rotado_Totalmente -> Melhor indivíduo gerado pela rotação total (ou o próprio indivíduo caso o mesmo seja melhor).
		-Segundo_Melhor_Individuo_Rotado_Totalmente -> Segundo melhor indivíduo gerado pela rotação total.
   Determinístico.
 */	
rotacao_total(Individuo,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente) :-
		nb_getval(numero_de_cidades,Numero_de_Cidades),
		rotacao_total(Individuo,Numero_de_Cidades,Individuo,Individuo,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente).

/* rotacao_total(+Individuo,+Numero_de_Cidades,+Melhor_Individuo_Rotado_Totalmente,+Segundo_Melhor_Individuo_Rotado_Totalmente)
   Implemente rotacao_total/3, onde:
		+Individuo -> Indivíduo que sofrerá a rotação total.
		+Numero_de_Cidades -> Número de cidades que faltam rotar.
		+Melhor_Individuo_Rotado_Totalmente_Atualmente -> Melhor indivíduo rotado totalmente até o momento.
		+Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente -> Segundo melhor indivíduo rotado totalmente até o momento.
		-Melhor_Individuo_Rotado_Totalmente -> Melhor indivíduo gerado pela rotação total (ou o próprio indivíduo caso o mesmo seja melhor).
		-Segundo_Melhor_Individuo_Rotado_Totalmente -> Segundo melhor indivíduo gerado pela rotação total.
   Determinístico.
 */	
rotacao_total(_,0,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente) :- !.

rotacao_total(Individuo,Numero_de_Cidades,Fitness_do_Melhor_Individuo_Rotado_Totalmente_Atualmente-Melhor_Individuo_Rotado_Totalmente_Atualmente,Fitness_do_Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente-Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente) :-
	rotacao(Individuo,Numero_de_Cidades,Fitness_do_Melhor_Individuo_Rotado-Melhor_Individuo_Rotado,Fitness_do_Segundo_Melhor_Individuo_Rotado-Segundo_Melhor_Individuo_Rotado),
	
	(Fitness_do_Segundo_Melhor_Individuo_Rotado < Fitness_do_Melhor_Individuo_Rotado_Totalmente_Atualmente ->
		Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado-Melhor_Individuo_Rotado,
		Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Segundo_Melhor_Individuo_Rotado-Segundo_Melhor_Individuo_Rotado
	;
		(Fitness_do_Melhor_Individuo_Rotado < Fitness_do_Melhor_Individuo_Rotado_Totalmente_Atualmente ->
			Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado_Totalmente_Atualmente-Melhor_Individuo_Rotado_Totalmente_Atualmente,
			Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado-Melhor_Individuo_Rotado
		 ;
			(Fitness_do_Melhor_Individuo_Rotado < Fitness_do_Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente ->
				Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado_Totalmente_Atualmente-Melhor_Individuo_Rotado_Totalmente_Atualmente,
				Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado-Melhor_Individuo_Rotado
			 ;
				Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Melhor_Individuo_Rotado_Totalmente_Atualmente-Melhor_Individuo_Rotado_Totalmente_Atualmente,
				Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado = Fitness_do_Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente-Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente
			)
		)
	),
	
	Numero_de_Cidades_Atualizado is Numero_de_Cidades - 1,
	rotacao_total(Individuo,Numero_de_Cidades_Atualizado,Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado,Segundo_Melhor_Individuo_Rotado_Totalmente_Atualmente_Atualizado,Melhor_Individuo_Rotado_Totalmente,Segundo_Melhor_Individuo_Rotado_Totalmente).