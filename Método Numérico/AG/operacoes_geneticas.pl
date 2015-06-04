/* mutacao(+Individuo,-IndividuoMutado) 
   Realize a mutação em um gene aleatório do indivíduo gerando um indivíduo mutado, onde:
		+Individuo -> Indivíduo que sofrerá a mutação.
		-IndividuoMutado -> Indivíduo mutado.
   Determinístico.
 */
mutacao(F-Trajeto/X,FMut-TrajetoMut/Y):-
	nb_getval(nc,Numero_Cidades),
	Limite_Maximo_Random is Numero_Cidades + 1,
	random(1,Numero_Cidades,Posicao_Inicial_Mutacao),
	random(Posicao_Inicial_Mutacao,Limite_Maximo_Random,Posicao_Final_Mutacao),
	copy_term(Trajeto/X,TrajetoCopia/Y),
		
	(Posicao_Inicial_Mutacao = Posicao_Final_Mutacao ->
		FMut = F,
		TrajetoMut = TrajetoCopia
	 ;
		nth1(Posicao_Inicial_Mutacao, Trajeto, Elemento_Posicao_Inicial_Mutacao),
		nth1(Posicao_Final_Mutacao, Trajeto, Elemento_Posicao_Final_Mutacao),
		
		substitui_enesimo(Posicao_Inicial_Mutacao, TrajetoCopia, Elemento_Posicao_Final_Mutacao, Trajeto_Parcial),
		substitui_enesimo(Posicao_Final_Mutacao, Trajeto_Parcial, Elemento_Posicao_Inicial_Mutacao, TrajetoMut),
	
		fitness(TrajetoMut,FMut)
	).
		

/* crossover(+PrimeiroIndividuo,+SegundoIndividuo,-PrimeiroIndividuoModificado,-SegundoIndividuoModificado) 
   Realize o crossover entre dois indivíduos gerando dois novos indivíduos, onde:
		+PrimeiroIndividuo -> Primeiro indivíduo.
		+SegundoIndividuo -> Segundo indivíduo.
		-PrimeiroIndividuo -> Indivíduo com os prefixos e sufixos de PrimeiroIndivíduo e o núcleo de SegundoIndividuo.
		-SegundoIndividuo -> Indivíduo com os prefixos e sufixos de SegundoIndividuo e o núcleo de PrimeiroIndivíduo.
   Determinístico.
*/
crossover(F-Trajeto/X,FCro-TrajetoCro/Y):-
	nb_getval(nc,Numero_Cidades),
	Limite_Maximo_Random is Numero_Cidades + 1,
	random(1,Limite_Maximo_Random,Posicao_Inicial_Crossover),
	random(Posicao_Inicial_Crossover,Limite_Maximo_Random,Posicao_Final_Crossover),
	copy_term(Trajeto/X,TrajetoCopia/Y),
		
	(Posicao_Inicial_Crossover = Posicao_Final_Crossover ->
		FCro = F,
		TrajetoCro = TrajetoCopia
	 ;
		Tamanho_Maximo_Crossover is Limite_Maximo_Random - Posicao_Final_Crossover,
		random(0,Tamanho_Maximo_Crossover,Tamanho_Crossover),
		Posicao_Termino_Inicial_Crossover is Posicao_Inicial_Crossover + Tamanho_Crossover,
		Posicao_Termino_Final_Crossover is Posicao_Final_Crossover + Tamanho_Crossover,
		Posicao_Posterior_Termino_Inicial is Posicao_Termino_Inicial_Crossover + 1,
		Posicao_Anterior_Final is Posicao_Final_Crossover - 1,
	
		extrair_sublistas(Posicao_Inicial_Crossover,Posicao_Termino_Inicial_Crossover,TrajetoCopia/Y,Prefixo_Trajeto,Nucleo_Trajeto,_),
		extrair_sublistas(Posicao_Final_Crossover,Posicao_Termino_Final_Crossover,TrajetoCopia/Y,_,Nucleo_Trajeto2,Sufixo_Trajeto2),
		concatena_diferenca_de_lista(Prefixo_Trajeto,Nucleo_Trajeto2,TrajetoCro_Parcial1),	
	
		(Posicao_Posterior_Termino_Inicial < Posicao_Final_Crossover ->
			extrair_sublistas(Posicao_Posterior_Termino_Inicial,Posicao_Anterior_Final,TrajetoCopia/Y,_,Nucleo,_),
			concatena_diferenca_de_lista(TrajetoCro_Parcial1,Nucleo,TrajetoCro_Parcial2),
			concatena_diferenca_de_lista(TrajetoCro_Parcial2,Nucleo_Trajeto,TrajetoCro_Parcial3),
			concatena_diferenca_de_lista(TrajetoCro_Parcial3,Sufixo_Trajeto2,TrajetoCro/Y)
		 ;
			(Posicao_Posterior_Termino_Inicial = Posicao_Final_Crossover ->
				concatena_diferenca_de_lista(TrajetoCro_Parcial1,Nucleo_Trajeto,TrajetoCro_Parcial2)
			 ;
				(Posicao_Posterior_Termino_Inicial >= Posicao_Final_Crossover ->
					extrair_sublistas(Posicao_Inicial_Crossover,Posicao_Anterior_Final,TrajetoCopia/Y,_,Nucleo,_),
					concatena_diferenca_de_lista(TrajetoCro_Parcial1,Nucleo,TrajetoCro_Parcial2)
				)
			),
			concatena_diferenca_de_lista(TrajetoCro_Parcial2,Sufixo_Trajeto2,TrajetoCro/Y)
		),
		fitness(TrajetoCro,FCro)
		%Individuos_Crossover = [FCro-TrajetoCro/Y]
	).
	
	/* crossover(+PrimeiroIndividuo,+SegundoIndividuo,-PrimeiroIndividuoModificado,-SegundoIndividuoModificado) 
   Realize o crossover entre dois indivíduos gerando dois novos indivíduos, onde:
		+PrimeiroIndividuo -> Primeiro indivíduo.
		+SegundoIndividuo -> Segundo indivíduo.
		-PrimeiroIndividuo -> Indivíduo com os prefixos e sufixos de PrimeiroIndivíduo e o núcleo de SegundoIndividuo.
		-SegundoIndividuo -> Indivíduo com os prefixos e sufixos de SegundoIndividuo e o núcleo de PrimeiroIndivíduo.
   Determinístico.
*/
crossover_igx(_-Trajeto_Pai/_,_-Trajeto_Mae/_,FCro-TrajetoCro):-
	nb_getval(nc,Numero_Cidades),
	random(0,Numero_Cidades,Cidade),
	
	remover_lista_duplamente_encadeada(pai),
	remover_lista_duplamente_encadeada(mae),
	criar_lista_duplamente_encadeada(pai,Trajeto_Pai),
	criar_lista_duplamente_encadeada(mae,Trajeto_Mae),
	igx(Numero_Cidades,Cidade,[Cidade|X]/X,0,Cidade,FCro-TrajetoCro).
	
igx(1,Primeira_Cidade,TrajetoCro,Fcro_Parcial,Cidade_Atual,FCro-TrajetoCro) :- 
	!,
	funcao_cantor(Cidade_Atual,Primeira_Cidade,Funcao_Cantor),
	distancia(Funcao_Cantor,Distancia),
	FCro is Fcro_Parcial + Distancia.

igx(N,Primeira_Cidade,TrajetoCro_Parcial,Fcro_Parcial,Cidade_Atual,FCro-TrajetoCro) :-
	anterior_proximo_elementos_lista_duplamente_encadeada(pai,Cidade_Atual,Cidade_Anterior_Pai,Cidade_Posterior_Pai),
	anterior_proximo_elementos_lista_duplamente_encadeada(mae,Cidade_Atual,Cidade_Anterior_Mae,Cidade_Posterior_Mae),
	
	funcao_cantor(Cidade_Atual,Cidade_Anterior_Pai,Funcao_Cantor_Cidade_Anterior_Pai),
	funcao_cantor(Cidade_Atual,Cidade_Posterior_Pai,Funcao_Cantor_Cidade_Posterior_Pai),
	funcao_cantor(Cidade_Atual,Cidade_Anterior_Mae,Funcao_Cantor_Cidade_Anterior_Mae),
	funcao_cantor(Cidade_Atual,Cidade_Posterior_Mae,Funcao_Cantor_Cidade_Posterior_Mae),
	
	distancia(Funcao_Cantor_Cidade_Anterior_Pai,Distancia_Cidade_Anterior_Pai),
	distancia(Funcao_Cantor_Cidade_Posterior_Pai,Distancia_Cidade_Posterior_Pai),
	distancia(Funcao_Cantor_Cidade_Anterior_Mae,Distancia_Cidade_Anterior_Mae),
	distancia(Funcao_Cantor_Cidade_Posterior_Mae,Distancia_Cidade_Posterior_Mae),
	
	keysort([Distancia_Cidade_Anterior_Pai-Cidade_Anterior_Pai,Distancia_Cidade_Posterior_Pai-Cidade_Posterior_Pai,Distancia_Cidade_Anterior_Mae-Cidade_Anterior_Mae,Distancia_Cidade_Posterior_Mae-Cidade_Posterior_Mae],[Menor_Distancia-Cidade_Mais_Proxima|_]),
	
	concatena_diferenca_de_lista(TrajetoCro_Parcial,[Cidade_Mais_Proxima|X]/X,TrajetoCro_Parcial_Atualizado),
	Fcro_Parcial_Atualizado is Fcro_Parcial + Menor_Distancia,
	N_Atualizado is N - 1,
	
	igx(N_Atualizado,Primeira_Cidade,TrajetoCro_Parcial_Atualizado,Fcro_Parcial_Atualizado,Cidade_Mais_Proxima,FCro-TrajetoCro).
	
	
	
	

	
	
	
/* evolucao(+População,-PopulaçãoEvoluída)
   Aplica os operadores genéticos para evoluir a populacao, onde:
		+População -> População antes da evolução.
		-PopulaçãoEvoluída -> População após a evolução.
   Determinístico.
 */
/*evolucao([Melhor_Individuo|Populacao],PopulacaoEvoluida):-
	nb_getval(tamanho_da_populacao,Tp),
	nb_getval(taxa_de_migracao,Tmi),
	length([Melhor_Individuo|Populacao],TamanhoPopulacao),
	NumeroMigrantes is (round((Tp * Tmi))+(Tp-TamanhoPopulacao)),
	gera_populacao(NumeroMigrantes,Migrantes),
	rotacao(Melhor_Individuo,IndividuoRotado),
	append([IndividuoRotado,Melhor_Individuo|Populacao],Migrantes,PopulacaoComMigrantes),
	evo(PopulacaoComMigrantes,1,[],PopulacaoEvoluida).*/
	
evolucao(Populacao,PopulacaoEvoluida):-
	random(0,100000,X),
	set_random(seed(X)),
	nb_getval(tamanho_da_populacao,Tp),
	nb_getval(taxa_de_migracao,Tmi),
	length(Populacao,TamanhoPopulacao),
	NumeroMigrantes is (round((Tp * Tmi))+(Tp-TamanhoPopulacao)),
	gera_populacao(NumeroMigrantes,Migrantes),
	append(Populacao,Migrantes,PopulacaoComMigrantes),
	
	pega_melhor_media_mediana_pior(PopulacaoComMigrantes,FMelhor-Melhor_Individuo,Media,FMediana-Individuo_Mediana,FPior-Pior_Individuo),
	%pega_melhor_media_mediana_pior(Populacao,FMelhor-Melhor_Individuo,Media,FMediana-Individuo_Mediana,FPior-Pior_Individuo),

	write(' | Melhor: '),
	write(FMelhor),
	nb_setval(melhor_individuo,FMelhor-Melhor_Individuo),
	write(' | Media: '),
	write(Media),
	write(' | Mediana: '),
	write(FMediana),
	write(' | Pior: '),
	write(FPior),
	nl,
	
	nb_getval(probabilidade_rotacao,Probabilidade_Rotacao),
	random(Probabilidade),
	
	(Probabilidade =< Probabilidade_Rotacao ->
		rotacao(FMelhor-Melhor_Individuo,FMelhor_Melhor-Melhor_Melhor_Individuo,FSegundo_Melhor_Melhor-Segundo_Melhor_Melhor_Individuo),
		rotacao(FMediana-Individuo_Mediana,FMelhor_Mediana-Melhor_Individuo_Mediana,FSegundo_Melhor_Mediana-Segundo_Melhor_Individuo_Mediana),
		rotacao(FPior-Pior_Individuo,FMelhor_Pior-Melhor_Pior_Individuo,FSegundo_Melhor_Pior-Segundo_Melhor_Pior_Individuo),
		
		%evo([FMelhor_Melhor-Melhor_Melhor_Individuo,FSegundo_Melhor_Melhor-Segundo_Melhor_Melhor_Individuo,FMelhor_Mediana-Melhor_Individuo_Mediana,FSegundo_Melhor_Mediana-Segundo_Melhor_Individuo_Mediana,FMelhor_Pior-Melhor_Pior_Individuo,FSegundo_Melhor_Pior-Segundo_Melhor_Pior_Individuo|Populacao],[],PopulacaoEvoluida)
		evo([FMelhor_Melhor-Melhor_Melhor_Individuo,FSegundo_Melhor_Melhor-Segundo_Melhor_Melhor_Individuo,FMelhor_Mediana-Melhor_Individuo_Mediana,FSegundo_Melhor_Mediana-Segundo_Melhor_Individuo_Mediana,FMelhor_Pior-Melhor_Pior_Individuo,FSegundo_Melhor_Pior-Segundo_Melhor_Pior_Individuo|PopulacaoComMigrantes],[],1,PopulacaoEvoluida)
	 ;
		evo(PopulacaoComMigrantes,[],1,PopulacaoEvoluida)
	).
		
	%evo([FMelhor_Melhor-Melhor_Melhor_Individuo,FSegundo_Melhor_Melhor-Segundo_Melhor_Melhor_Individuo,FMelhor_Mediana-Melhor_Individuo_Mediana,FSegundo_Melhor_Mediana-Segundo_Melhor_Individuo_Mediana,FMelhor_Pior-Melhor_Pior_Individuo,FSegundo_Melhor_Pior-Segundo_Melhor_Pior_Individuo|PopulacaoComMigrantes],[],1,PopulacaoEvoluida).

/* evo(+Populacao,+IndiceIndividuo,+PopulacaoInicial,-PopulacaoEvoluida)
   Implementa evolucao/2, onde:
		+População -> População antes da evolução.
		+IndiceIndividuo -> Contador para percorrer todos os indivíduos.
		+PopulacaoInicial -> Acumulador quer será preenchido até formar PopulacaoEvoluida.
		-PopulaçãoEvoluída -> População após a evolução.
   Determinístico.
 */
evo([],Populacao,_,PopulacaoEvoluida) :-	
	!,
	nb_getval(tamanho_da_populacao,Tp),
	keysort(Populacao,PopulacaoOrdenada),
	%habitat(PopulacaoOrdenada,PopulacaoPosHabitat),
	%cortar_cauda(PopulacaoPosHabitat,Tp,PopulacaoEvoluida).
	cortar_cauda(PopulacaoOrdenada,Tp,PopulacaoEvoluida).
										
evo([Individuo|Populacao],PopulacaoAtual,IndiceIndividuo,PopulacaoEvoluida) :-
	random(Probabilidade),
	nb_getval(probabilidade_crossover,Taxa_Crossover),
	nb_getval(probabilidade_mutacao,Probabilidade_Mutacao),
	IndiceIndividuoAtulizado is IndiceIndividuo + 1,
	
	(Probabilidade =< Taxa_Crossover ->
		%nb_getval(tamanho_da_populacao,Tp),
		%nb_getval(taxa_de_migracao,Tmi),
		%TamanhoPopulacaoRestante is (round((1 + Tmi)*Tp) + 6 - IndiceIndividuo),
		length(Populacao,TamanhoPopulacaoRestante),
		(TamanhoPopulacaoRestante > 0 ->
			random(0,TamanhoPopulacaoRestante,NumeroAleatorio),
			nth0(NumeroAleatorio,Populacao,Individuo2),
			crossover_igx(Individuo,Individuo2,IndividuoCrossover)
		 ;
			crossover(Individuo,IndividuoCrossover)
		),
		
		(Probabilidade =< Probabilidade_Mutacao ->
			mutacao(Individuo,IndividuoMutado),
			evo(Populacao,[Individuo,IndividuoMutado,IndividuoCrossover|PopulacaoAtual],IndiceIndividuoAtulizado,PopulacaoEvoluida)
		 ;
			evo(Populacao,[Individuo,IndividuoCrossover|PopulacaoAtual],IndiceIndividuoAtulizado,PopulacaoEvoluida)
		)
	 ;
		evo(Populacao,[Individuo|PopulacaoAtual],IndiceIndividuoAtulizado,PopulacaoEvoluida)
	).

/* habitat(+População,-NovaPopulação)
   Elimina indivíduos com parâmetros muito parecidos mantendo sempre o de menor fitness,onde:
		+População -> População antes do habitat.
		-PopulaçãoEvoluída -> População após o habitat.
   Determinístico.
 */
habitat(Populacao,NovaPopulacao) :-
	hab(Populacao,Cauda_Diferenca_De_Lista/Cauda_Diferenca_De_Lista,NovaPopulacao).

/* hab(+Populacao,+PopulacaoInicial,-NovaPopulacao)
   Implementa habitat/2, onde:
		+População -> População antes do habitat.
		+PopulacaoInicial -> Acumulador quer será preenchido até formar NovaPopulacao.
		-NovaPopulacao -> População após o habitat.
   Determinístico.
 */
hab([],Populacao_Pos_Habitat_Diferenca_De_Lista,Populacao_Pos_Habitat) :- 
	!,
	converte_diferenca_de_lista_lista(Populacao_Pos_Habitat_Diferenca_De_Lista,Populacao_Pos_Habitat).
	
hab([Individuo|RestantePopulacao],AcumuladorPopulacao/[Individuo|Cauda_Diferenca_De_Lista],NovaPopulacao) :-
	torneio(Individuo,RestantePopulacao,Cauda_Diferenca_De_Lista3/Cauda_Diferenca_De_Lista3,PopulacaoPosHabitat),
	hab(PopulacaoPosHabitat,AcumuladorPopulacao/Cauda_Diferenca_De_Lista,NovaPopulacao).

/* torneio(+Indivíduo,+Populacao,+AcumuladorPopulacao,-NovaPopulacao)
   Elimina todos os indivíduos que estão no mesmo habitat do primeiro indivíduo, onde:
		+Indivíduo -> Indivíduo com menor fitness do habitat (macho alfa).
		+População -> População antes do torneio.
		+AcumuladorPopulacao -> Acumulador quer será preenchido até formar NovaPopulacao.
		-NovaPopulacao -> População após o torneio.
   Determinístico.
 */	
torneio(_,[],Nova_Populacao_Diferenca_De_Lista,Nova_Populacao) :- 
	!,
	converte_diferenca_de_lista_lista(Nova_Populacao_Diferenca_De_Lista,Nova_Populacao).
	
torneio(F-Individuo,[F2-ProximoIndividuo|RestantePopulacao],AcumuladorPopulacao/Cauda_Diferenca_De_Lista,Nova_Populacao) :-
	nb_getval(ldf,Ldf),
	Diferenca_Fitness is abs(F2-F),
	
	(Diferenca_Fitness > Ldf ->
		converte_diferenca_de_lista_lista([F2-ProximoIndividuo|RestantePopulacao]/Cauda_Diferenca_De_Lista,Nova_Populacao)
	 ;
		nb_getval(limite_da_distancia_euclidiana_no_torneio,Lde),
		nb_getval(nc,Nc),
		
		numero_elementos_iguais(F-Individuo,F2-ProximoIndividuo,Numero_Elementos_Iguais),
		Distancia is Numero_Elementos_Iguais/Nc,
	
		(Distancia =< Lde ->
			concatena_diferenca_de_lista(AcumuladorPopulacao/Cauda_Diferenca_De_Lista,[F2-ProximoIndividuo|Cauda_Diferenca_De_Lista2]/Cauda_Diferenca_De_Lista2,AcumuladorPopulacaoAtualizado)
		 ;
			AcumuladorPopulacaoAtualizado = AcumuladorPopulacao/Cauda_Diferenca_De_Lista),
			
		torneio(F-Individuo,RestantePopulacao,AcumuladorPopulacaoAtualizado,Nova_Populacao)).

	 

/*torneio(F-Individuo,[F2-ProximoIndividuo|RestantePopulacao],AcumuladorPopulacao/Cauda_Diferenca_De_Lista,NovaPopulacao) :-
	nb_getval(ldf,Ldf),
	Diferenca_Fitness is abs(F2-F),
	
	(Diferenca_Fitness =< Ldf ->
		nb_getval(limite_da_distancia_euclidiana_no_torneio,Lde),
		nb_getval(nc,Nc),
		
		numero_elementos_iguais(F-Individuo,F2-ProximoIndividuo,Numero_Elementos_Iguais),
		Distancia = Numero_Elementos_Iguais/Nc,
	
		(Distancia >= Lde ->
			concatena_diferenca_de_lista(AcumuladorPopulacao/Cauda_Diferenca_De_Lista,[F2-ProximoIndividuo|Cauda_Diferenca_De_Lista2]/Cauda_Diferenca_De_Lista2,AcumuladorPopulacaoAtualizado)
		 ;
			AcumuladorPopulacaoAtualizado = AcumuladorPopulacao/Cauda_Diferenca_De_Lista)
	;
		AcumuladorPopulacaoAtualizado = AcumuladorPopulacao/Cauda_Diferenca_De_Lista),
	
	torneio(F-Individuo,RestantePopulacao,AcumuladorPopulacaoAtualizado,NovaPopulacao).*/
	
fitness([Cidade_Inicial|Trajeto],Fitness) :-
	fitness(Cidade_Inicial,[Cidade_Inicial|Trajeto],0,Fitness).

fitness(Cidade_Inicial, [Cidade_Atual|Fim], Fitness_Parcial, Fitness) :-
	var(Fim),
	!,
	funcao_cantor(Cidade_Atual,Cidade_Inicial,Funcao_Cantor),
	distancia(Funcao_Cantor,Distancia),
	Fitness is Fitness_Parcial + Distancia.
	
fitness(Cidade_Inicial, [Cidade_Atual,Proxima_Cidade|Trajeto], Fitness_Parcial, Fitness) :-
	!,
	funcao_cantor(Cidade_Atual,Proxima_Cidade,Funcao_Cantor),
	distancia(Funcao_Cantor,Distancia),
	Fitness_Parcial_Atualizada is Fitness_Parcial + Distancia,
	fitness(Cidade_Inicial,[Proxima_Cidade|Trajeto],Fitness_Parcial_Atualizada,Fitness).
	
/* rotacao(+Individuo,-Melhor_Individuo_Rotado,-Segundo_Melhor_Individuo_Rotado) 
   Realize a rotação do indivíduo (trocar a primeira cidade por todas as outras) e verifica qual o melhor indivíduo encontrado:
		+Individuo -> Indivíduo que sofrerá a rotação.
		-Melhor_Individuo_Rotado -> Melhor indivíduo gerado pela rotação (ou o próprio indivíduo caso o mesmo seja melhor).
		-Segundo_Melhor_Individuo_Rotado -> Segundo melhor indivíduo gerado pela rotação.
   Determinístico.
*/
rotacao(F-[Primeira_Cidade|Restante_Caminho]/Cauda_Individuo,Melhor_Individuo_Rotado, Segundo_Melhor_Individuo_Rotado) :-
	nb_getval(nc,Numero_Cidades),
	rot(F-[Primeira_Cidade|Restante_Caminho]/Cauda_Individuo,Numero_Cidades,Primeira_Cidade,F-[Primeira_Cidade|Restante_Caminho]/Cauda_Individuo,F-[Primeira_Cidade|Restante_Caminho]/Cauda_Individuo,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado).
	
/* rot(+Individuo,+Numero_Cidades,+Prefixo_Individuo,+Melhor_Individuo_Rotado_Atualmente,Segundo_Melhor_Individuo_Rotado_Atualmente,-Melhor_Individuo_Rotado,-Segundo_Melhor_Individuo_Rotado)
   Implementa rotacao/2, onde:
		+Individuo -> Indivíduo que sofrerá a rotação.
		+Numero_Cidades -> Número de cidades que faltam rotar.
		+Prefixo_Individuo -> Parte já analisada
		+Melhor_Individuo_Rotado_Atualmente -> Melhor indivíduo rotado até o momento.
		+Segundo_Melhor_Individuo_Rotado_Atualmente -> Segundo melhor indivíduo rotado até o momento.
		-Melhor_Individuo_Rotado -> Melhor indivíduo gerado pela rotação (ou o próprio indivíduo caso o mesmo seja melhor).
		-Segundo_Melhor_Individuo_Rotado -> Segundo melhor indivíduo gerado pela rotação.
   Determinístico.
 */
rot(_,1,_,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado) :- !.

rot(_-Individuo,Numero_Cidades,Primeira_Cidade,F-Melhor_Individuo_Rotado_Atualmente,FSeg-Segundo_Melhor_Individuo_Rotado_Atualmente,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado) :- 
	extrair_sublistas(Numero_Cidades,Numero_Cidades,Individuo,Prefixo_Trajeto/Cauda_Prefixo,[Elemento|Cauda_Nucleo]/Cauda_Nucleo,Sufixo_Trajeto),
	substitui_enesimo(1,Prefixo_Trajeto,Elemento,Prefixo_Trajeto_Atualizado),
	concatena_diferenca_de_lista(Prefixo_Trajeto_Atualizado/Cauda_Prefixo,[Primeira_Cidade|Cauda_Nucleo]/Cauda_Nucleo,Individuo_Rotado_Parcial),
	concatena_diferenca_de_lista(Individuo_Rotado_Parcial,Sufixo_Trajeto,Individuo_Rotado/Cauda_Individuo_Rotado),
	fitness(Individuo_Rotado,FRot),
	
	(FRot < F ->
		Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado = F-Melhor_Individuo_Rotado_Atualmente,
		Melhor_Individuo_Rotado_Atualmente_Atualizado = FRot-Individuo_Rotado/Cauda_Individuo_Rotado
	;
		Melhor_Individuo_Rotado_Atualmente_Atualizado = F-Melhor_Individuo_Rotado_Atualmente,
	
		(FRot < FSeg ->
			Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado = FRot-Individuo_Rotado/Cauda_Individuo_Rotado
		 ;
			Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado = FSeg-Segundo_Melhor_Individuo_Rotado_Atualmente
		 )
	),
	
	Numero_Cidades_Atualizado is Numero_Cidades - 1,
		
	rot(_-Individuo,Numero_Cidades_Atualizado,Primeira_Cidade,Melhor_Individuo_Rotado_Atualmente_Atualizado,Segundo_Melhor_Individuo_Rotado_Atualmente_Atualizado,Melhor_Individuo_Rotado,Segundo_Melhor_Individuo_Rotado).