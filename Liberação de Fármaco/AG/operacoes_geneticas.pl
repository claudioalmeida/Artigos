/* fitness(+Parametros,-ValorFitness) 
   Calcula o valor da fitness do indivíduo baseada nos dados gerados da curva, onde: 
		+Parametros -> Parâmetros [D,Cs,A,H] do indivíduo.
		-ValorFitness -> Valor da fitness do indivíduo.
   Determinístico.
 */ 
fitness([D,Cs,A,H],ValorFitness):-
	nb_getval(parametros_de_referencia,[Dref,Csref,Aref,Href]),
	ValorFitness is log(abs((sqrt((D * Cs * (A - Cs/2))/(Dref * Csref * (Aref - Csref/2))) * ((Aref * Href)/(A * H))) - 1)).
	
teste_fitness([D,Cs,A,H],T,Valor):-
	nb_getval(parametros_de_referencia,[Dref,Csref,Aref,Href]),
	funcao_liberacao_farmaco(D,Cs,A,H,T,ValorFuncao),
	funcao_liberacao_farmaco(Dref,Csref,Aref,Href,T,ValorFuncaoref),
	Valor is log((ValorFuncao/ValorFuncaoref) - 1).


/* fitness(+Parametros,-ValorFitness) 
   Calcula o valor da fitness do indivíduo baseada nos dados gerados da curva, onde: 
		+Parametros -> Parâmetros [D,Cs,A,H] do indivíduo.
		-ValorFitness -> Valor da fitness do indivíduo.
   Determinístico.
 */ 
fitness_antigo(Parametros,ValorFitness):-
	nb_getval(dref,Dref),
	fit(Parametros,Dref,0,ValorFitness).

/* fit(+Parametros,+DadosReferencia,+ValorFitnessParcial,-ValorFitness) 
   Calcula o valor da fitness do indivíduo baseada nos dados gerados da curva, onde: 
		+Parametros -> Parâmetros [D,Cs,A,H] do indivíduo.
		+Dadosreferencia -> Dados de referência da curva para cálculo do fitness do indivíduo.
		+ValorFitnessParcial -> Acumulador com a fitness do indivíduo que será calculada até chegar em ValorFitness.
		-ValorFitness -> Valor da fitness do indivíduo.
   Determinístico.
 */ 
fit(_,[],ValorFitness,ValorFitness) :- !.

fit([D,Cs,A,H],[Tempo-Flf|DadosReferencia],ValorFitnessParcial,ValorFitness) :- 
	funcao_liberacao_farmaco(D,Cs,A,H,Tempo,FuncaoLiberacaoFarmaco),
	ValorFitnessParcialAtualizado is (ValorFitnessParcial + abs(FuncaoLiberacaoFarmaco-Flf)),
	fit([D,Cs,A,H],DadosReferencia,ValorFitnessParcialAtualizado,ValorFitness).
	
/* mutacao(+Individuo,-IndividuoMutado) 
   Realize a mutação em um gene aleatório do indivíduo gerando um indivíduo mutado, onde:
		+Individuo -> Indivíduo que sofrerá a mutação.
		-IndividuoMutado -> Indivíduo mutado.
   Determinístico.
 */
mutacao(_-[Vd-D,Vcs-Cs,Va-A,Vh-H],Fmut-[Vdmut-Dmut,Vcsmut-Csmut,Vamut-Amut,Vhmut-Hmut]):-
	nb_getval(numero_de_bits_para_representar_d,Numero_de_Bits_para_Representar_D),
	nb_getval(numero_de_bits_para_representar_cs,Numero_de_Bits_para_Representar_Cs),
	nb_getval(ta,Ta),
	nb_getval(Numero_de_Bits_para_Representar_H,Numero_de_Bits_para_Representar_H),
	TamanhoParametros is (Numero_de_Bits_para_Representar_D + Numero_de_Bits_para_Representar_Cs + Ta + Numero_de_Bits_para_Representar_H + 1),
	Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_Cs is Numero_de_Bits_para_Representar_D + Numero_de_Bits_para_Representar_Cs,
	Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_CsTa is Numero_de_Bits_para_Representar_D + Numero_de_Bits_para_Representar_Cs + Ta,
	random(1,TamanhoParametros,NumeroAleatorio),
	(NumeroAleatorio =< Numero_de_Bits_para_Representar_D ->
		Resto = NumeroAleatorio,
		Peso is (Numero_de_Bits_para_Representar_D - Resto),
		inverte_enesimo(Resto,D,Elemento,Dmut),
		nb_getval(lid,Lid),
		nb_getval(limite_superior_do_dominio_de_d,Lsd),
		(Elemento == 0 ->
			Vdmut is (Vd + (2^Peso * ((Lsd - Lid)/(2^Numero_de_Bits_para_Representar_D))))
		 ;
			Vdmut is (Vd - (2^Peso * ((Lsd - Lid)/(2^Numero_de_Bits_para_Representar_D))))),
		Vcsmut = Vcs,
		Csmut = Cs,
		Vamut = Va,
		Amut = A,
		Vhmut = Vh,
		Hmut = H
	 ;
		(NumeroAleatorio =< Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_Cs ->
			Resto is NumeroAleatorio - Numero_de_Bits_para_Representar_D,
			Peso is (Numero_de_Bits_para_Representar_Cs - Resto),
			inverte_enesimo(Resto,Cs,Elemento,Csmut),
			nb_getval(limite_inferior_do_dominio_de_cs,Lics),
			nb_getval(limite_superior_do_dominio_de_cs,Lscs),
			(Elemento == 0 ->
				Vcsmut is (Vcs + (2^Peso * ((Lscs - Lics)/(2^Numero_de_Bits_para_Representar_Cs))))
			;
				Vcsmut is (Vcs - (2^Peso * ((Lscs - Lics)/(2^Numero_de_Bits_para_Representar_Cs))))),
			Vdmut = Vd,
			Dmut = D,
			Vamut = Va,
			Amut = A,
			Vhmut = Vh,
			Hmut = H
		;
			(NumeroAleatorio =< Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_CsTa ->
				Resto is NumeroAleatorio - Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_Cs,
				Peso is (Ta - Resto),
				inverte_enesimo(Resto,A,Elemento,Amut),
				nb_getval(limite_inferior_do_dominio_de_a,Lia),
				nb_getval(limite_superior_do_dominio_de_a,Lsa),
				(Elemento == 0 ->
					Vamut is (Va + (2^Peso * ((Lsa - Lia)/(2^Ta))))
				;
					Vamut is (Va - (2^Peso * ((Lsa - Lia)/(2^Ta))))),
				Vdmut = Vd,
				Dmut = D,
				Vcsmut = Vcs,
				Csmut = Cs,
				Vhmut = Vh,
				Hmut = H
			;
				(Resto is NumeroAleatorio - Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_CsTa,
				Peso is (Numero_de_Bits_para_Representar_H - Resto),
				inverte_enesimo(Resto,H,Elemento,Hmut),
				nb_getval(limite_inferior_do_dominio_de_h,Lih),
				nb_getval(limite_superior_do_dominio_de_h,Lsh),
				(Elemento == 0 ->
					Vhmut is (Vh + (2^Peso * ((Lsh - Lih)/(2^Numero_de_Bits_para_Representar_H))))
				;
					Vhmut is (Vh - (2^Peso * ((Lsh - Lih)/(2^Numero_de_Bits_para_Representar_H))))),
				Vdmut = Vd,
				Dmut = D,
				Vcsmut = Vcs,
				Csmut = Cs,
				Vamut = Va,
				Amut = A)))),
		fitness([Vdmut,Vcsmut,Vamut,Vhmut],Fmut).

/* crossover(+PrimeiroIndividuo,+SegundoIndividuo,-PrimeiroIndividuoModificado,-SegundoIndividuoModificado) 
   Realize o crossover entre dois indivíduos gerando dois novos indivíduos, onde:
		+PrimeiroIndividuo -> Primeiro indivíduo.
		+SegundoIndividuo -> Segundo indivíduo.
		-PrimeiroIndividuo -> Indivíduo com os prefixos e sufixos de PrimeiroIndivíduo e o núcleo de SegundoIndividuo.
		-SegundoIndividuo -> Indivíduo com os prefixos e sufixos de SegundoIndividuo e o núcleo de PrimeiroIndivíduo.
   Determinístico.
*/
crossover(_-[Vd1-D1,Vcs1-Cs1,Va1-A1,Vh1-H1],_-[Vd2-D2,Vcs2-Cs2,Va2-A2,Vh2-H2],Fcro1-[Vdcro1-Dcro1,Vccro1-Cscro1,Vacro1-Acro1,Vhcro1-Hcro1],Fcro2-[Vdcro2-Dcro2,Vccro2-Cscro2,Vacro2-Acro2,Vhcro2-Hcro2]):-
	nb_getval(numero_de_bits_para_representar_d,Numero_de_Bits_para_Representar_D),
	nb_getval(numero_de_bits_para_representar_cs,Numero_de_Bits_para_Representar_Cs),
	nb_getval(ta,Ta),
	nb_getval(Numero_de_Bits_para_Representar_H,Numero_de_Bits_para_Representar_H),
	TamanhoParametros is (Numero_de_Bits_para_Representar_D + Numero_de_Bits_para_Representar_Cs + Ta + Numero_de_Bits_para_Representar_H + 1),
	Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_Cs is Numero_de_Bits_para_Representar_D + Numero_de_Bits_para_Representar_Cs,
	Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_CsTa is Numero_de_Bits_para_Representar_D + Numero_de_Bits_para_Representar_Cs + Ta,
	random(1,TamanhoParametros,NumeroAleatorio),
	
		(NumeroAleatorio =< Numero_de_Bits_para_Representar_D ->
			Resto = NumeroAleatorio,
			LimiteSuperior is Numero_de_Bits_para_Representar_D + 1,
			random(Resto,LimiteSuperior,PosicaoFinal),
			extrair_sublistas(Resto,PosicaoFinal,D1,Prefixo1,Nucleo1,Sufixo1),
			extrair_sublistas(Resto,PosicaoFinal,D2,Prefixo2,Nucleo2,Sufixo2),
			nb_getval(lid,Lid),
			nb_getval(limite_superior_do_dominio_de_d,Lsd),
			converte_binario_para_decimal(Lid, Lsd, Resto, Nucleo1, FenotipoNucleo1),
			converte_binario_para_decimal(Lid, Lsd, Resto, Nucleo2, FenotipoNucleo2),
			append(Prefixo1,Nucleo2,PN12),
			append(PN12,Sufixo1,Dcro1),
			Vdcro1 is Vd1 - FenotipoNucleo1 + FenotipoNucleo2,
			append(Prefixo2,Nucleo1,PN21),
			append(PN21,Sufixo2,Dcro2),
			Vdcro2 is Vd2 - FenotipoNucleo2 + FenotipoNucleo1,
			Vccro1 = Vcs1,
			Cscro1 = Cs1,
			Vacro1 = Va1,
			Acro1 = A1,
			Vhcro1 = Vh1,
			Hcro1 = H1,
			Vccro2 = Vcs2,
			Cscro2 = Cs2,
			Vacro2 = Va2,
			Acro2 = A2,
			Vhcro2 = Vh2,
			Hcro2 = H2
		;
			(NumeroAleatorio =< Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_Cs ->
				Resto is NumeroAleatorio - Numero_de_Bits_para_Representar_D,
				LimiteSuperior is Numero_de_Bits_para_Representar_Cs + 1,
				random(Resto,LimiteSuperior,PosicaoFinal),
				extrair_sublistas(Resto,PosicaoFinal,Cs1,Prefixo1,Nucleo1,Sufixo1),
				extrair_sublistas(Resto,PosicaoFinal,Cs2,Prefixo2,Nucleo2,Sufixo2),
				nb_getval(limite_inferior_do_dominio_de_cs,Lics),
				nb_getval(limite_superior_do_dominio_de_cs,Lscs),
				converte_binario_para_decimal(Lics, Lscs, Resto, Nucleo1, FenotipoNucleo1),
				converte_binario_para_decimal(Lics, Lscs, Resto, Nucleo2, FenotipoNucleo2),
				append(Prefixo1,Nucleo2,PN12),
				append(PN12,Sufixo1,Cscro1),
				Vccro1 is Vcs1 - FenotipoNucleo1 + FenotipoNucleo2,
				append(Prefixo2,Nucleo1,PN21),
				append(PN21,Sufixo2,Cscro2),
				Vccro2 is Vcs2 - FenotipoNucleo2 + FenotipoNucleo1,
				Vdcro1 = Vd1,
				Dcro1 = D1,
				Vacro1 = Va1,
				Acro1 = A1,
				Vhcro1 = Vh1,
				Hcro1 = H1,
				Vdcro2 = Vd2,
				Dcro2 = D2,
				Vacro2 = Va2,
				Acro2 = A2,
				Vhcro2 = Vh2,
				Hcro2 = H2
			;
				(NumeroAleatorio =< Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_CsTa ->
					Resto is NumeroAleatorio - Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_Cs,
					LimiteSuperior is Ta + 1,
					random(Resto,LimiteSuperior,PosicaoFinal),
					extrair_sublistas(Resto,PosicaoFinal,A1,Prefixo1,Nucleo1,Sufixo1),
					extrair_sublistas(Resto,PosicaoFinal,A2,Prefixo2,Nucleo2,Sufixo2),
					nb_getval(limite_inferior_do_dominio_de_a,Lia),
					nb_getval(limite_superior_do_dominio_de_a,Lsa),
					converte_binario_para_decimal(Lia, Lsa, Resto, Nucleo1, FenotipoNucleo1),
					converte_binario_para_decimal(Lia, Lsa, Resto, Nucleo2, FenotipoNucleo2),
					append(Prefixo1,Nucleo2,PN12),
					append(PN12,Sufixo1,Acro1),
					Vacro1 is Va1 - FenotipoNucleo1 + FenotipoNucleo2,
					append(Prefixo2,Nucleo1,PN21),
					append(PN21,Sufixo2,Acro2),
					Vacro2 is Va2 - FenotipoNucleo2 + FenotipoNucleo1,
					Vdcro1 = Vd1,
					Dcro1 = D1,
					Vccro1 = Vcs1,
					Cscro1 = Cs1,
					Vhcro1 = Vh1,
					Hcro1 = H1,
					Vdcro2 = Vd2,
					Dcro2 = D2,
					Vccro2 = Vcs2,
					Cscro2 = Cs2,
					Vhcro2 = Vh2,
					Hcro2 = H2
				;
					Resto is NumeroAleatorio - Numero_de_Bits_para_Representar_DNumero_de_Bits_para_Representar_CsTa,
					LimiteSuperior is Numero_de_Bits_para_Representar_H + 1,
					random(Resto,LimiteSuperior,PosicaoFinal),
					extrair_sublistas(Resto,PosicaoFinal,H1,Prefixo1,Nucleo1,Sufixo1),
					extrair_sublistas(Resto,PosicaoFinal,H2,Prefixo2,Nucleo2,Sufixo2),
					nb_getval(limite_inferior_do_dominio_de_h,Lih),
					nb_getval(limite_superior_do_dominio_de_h,Lsh),
					converte_binario_para_decimal(Lih, Lsh, Resto, Nucleo1, FenotipoNucleo1),
					converte_binario_para_decimal(Lih, Lsh, Resto, Nucleo2, FenotipoNucleo2),
					append(Prefixo1,Nucleo2,PN12),
					append(PN12,Sufixo1,Hcro1),
					Vhcro1 is Vh1 - FenotipoNucleo1 + FenotipoNucleo2,
					append(Prefixo2,Nucleo1,PN21),
					append(PN21,Sufixo2,Hcro2),
					Vhcro2 is Vh2 - FenotipoNucleo2 + FenotipoNucleo1,
					Vdcro1 = Vd1,
					Dcro1 = D1,
					Vccro1 = Vcs1,
					Cscro1 = Cs1,
					Vacro1 = Va1,
					Acro1 = A1,
					Vdcro2 = Vd2,
					Dcro2 = D2,
					Vccro2 = Vcs2,
					Cscro2 = Cs2,
					Vacro2 = Va2,
					Acro2 = A2))),
		fitness([Vdcro1,Vccro1,Vacro1,Vhcro1],Fcro1),
		fitness([Vdcro2,Vccro2,Vacro2,Vhcro2],Fcro2).
			
/* evolucao(+População,-PopulaçãoEvoluída)
   Aplica os operadores genéticos para evoluir a populacao, onde:
		+População -> População antes da evolução.
		-PopulaçãoEvoluída -> População após a evolução.
   Determinístico.
 */
evolucao(Populacao,PopulacaoEvoluida):-
	nb_getval(tamanho_da_populacao,Tp),
	nb_getval(taxa_de_migracao,Tmi),
	length(Populacao,TamanhoPopulacao),
	NumeroMigrantes is (round((Tp * Tmi))+(Tp-TamanhoPopulacao)),
	gera_populacao(NumeroMigrantes,Migrantes),
	append(Populacao,Migrantes,PopulacaoComMigrantes),
	evo(PopulacaoComMigrantes,1,[],PopulacaoEvoluida).

/* evo(+Populacao,+IndiceIndividuo,+PopulacaoInicial,-PopulacaoEvoluida)
   Implementa evolucao/2, onde:
		+População -> População antes da evolução.
		+IndiceIndividuo -> Contador para percorrer todos os indivíduos.
		+PopulacaoInicial -> Acumulador quer será preenchido até formar PopulacaoEvoluida.
		-PopulaçãoEvoluída -> População após a evolução.
   Determinístico.
 */
evo([],_,Populacao,PopulacaoEvoluida) :-	
	!,
	nb_getval(tamanho_da_populacao,Tp),
	keysort(Populacao,PopulacaoOrdenada),
	habitat(PopulacaoOrdenada,PopulacaoPosHabitat),
	cortar_cauda(PopulacaoPosHabitat,Tp,PopulacaoEvoluida).
										
evo([Individuo|Populacao],IndiceIndividuo,PopulacaoAtual,PopulacaoEvoluida) :-
	append(PopulacaoAtual,[Individuo],PrimeiraParcialNovaPopulacaoAtual),
	mutacao(Individuo,IndividuoMutado),
	append(PrimeiraParcialNovaPopulacaoAtual,[IndividuoMutado],SegundaParcialNovaPopulacaoAtual),
	nb_getval(tamanho_da_populacao,Tp),
	nb_getval(taxa_de_migracao,Tmi),
	TamanhoPopulacaoRestante is (round((1 + Tmi)*Tp) - IndiceIndividuo),
	(TamanhoPopulacaoRestante > 0 ->
		random(0,TamanhoPopulacaoRestante,NumeroAleatorio),
		nth0(NumeroAleatorio,Populacao,Individuo2),
		crossover(Individuo,Individuo2,IndividuoCrossover1,IndividuoCrossover2),
		append(SegundaParcialNovaPopulacaoAtual,[IndividuoCrossover1,IndividuoCrossover2],NovaPopulacaoAtual)
	;
		NovaPopulacaoAtual = SegundaParcialNovaPopulacaoAtual),
	IndiceIndividuoAtulizado is IndiceIndividuo + 1,
	evo(Populacao,IndiceIndividuoAtulizado,NovaPopulacaoAtual,PopulacaoEvoluida).

/* habitat(+População,-NovaPopulação)
   Elimina indivíduos com parâmetros muito parecidos mantendo sempre o de menor fitness,onde:
		+População -> População antes do habitat.
		-PopulaçãoEvoluída -> População após o habitat.
   Determinístico.
 */
habitat(Populacao,NovaPopulacao) :-
	hab(Populacao,[],NovaPopulacao).

/* hab(+Populacao,+PopulacaoInicial,-NovaPopulacao)
   Implementa habitat/2, onde:
		+População -> População antes do habitat.
		+PopulacaoInicial -> Acumulador quer será preenchido até formar NovaPopulacao.
		-NovaPopulacao -> População após o habitat.
   Determinístico.
 */
hab([],PopulacaoPosHabitat,PopulacaoPosHabitat) :- !.
	
hab([Individuo|RestantePopulacao],AcumuladorPopulacao,NovaPopulacao) :-
	torneio(Individuo,RestantePopulacao,[],PopulacaoPosHabitat),
	append(AcumuladorPopulacao,[Individuo],AcumuladorPopulacaoAtualizado),
	hab(PopulacaoPosHabitat,AcumuladorPopulacaoAtualizado,NovaPopulacao).

/* torneio(+Indivíduo,+Populacao,+AcumuladorPopulacao,-NovaPopulacao)
   Elimina todos os indivíduos que estão no mesmo habitat do primeiro indivíduo, onde:
		+Indivíduo -> Indivíduo com menor fitness do habitat (macho alfa).
		+População -> População antes do torneio.
		+AcumuladorPopulacao -> Acumulador quer será preenchido até formar NovaPopulacao.
		-NovaPopulacao -> População após o torneio.
   Determinístico.
 */	
torneio(_,[],NovaPopulacao,NovaPopulacao) :- !.

torneio(Individuo,[ProximoIndividuo|RestantePopulacao],AcumuladorPopulacao,NovaPopulacao) :-
	nb_getval(limite_da_distancia_euclidiana_no_torneio,Lde),
	distancia_euclidiana(Individuo,ProximoIndividuo,DistanciaEuclidiana),
	(DistanciaEuclidiana >= Lde ->
		append(AcumuladorPopulacao,[ProximoIndividuo],AcumuladorPopulacaoAtualizado)
	 ;
		AcumuladorPopulacaoAtualizado = AcumuladorPopulacao),
	torneio(Individuo,RestantePopulacao,AcumuladorPopulacaoAtualizado,NovaPopulacao).