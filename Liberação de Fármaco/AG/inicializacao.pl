/* inicializa_variáveis
   Inicializa as variáveis globais que serão usadas pelo programa.
   Determinístico.
*/
inicializa_variaveis  :-

% Semente do gerador de números aleatórios (para garantir que o programa sempre tenha o mesmo ponto de partida).
set_random(seed(11)),

% Numero_de_Bits_para_Representar_Amanho padrão população se o mesmo não for informado na chamada do programa.
nb_setval(tamanho_da_populacao,100),

% Número de gerações padrão se o mesmo não for informado na chamada do programa.
nb_setval(numero_de_geracoes,100),

% Probabilimite_inferior_do_dominio_de_dade de ocorrer mutação com o indivíduo.
nb_setval(probabilimite_inferior_do_dominio_de_dade_mutacao,0.15),

% Numero_de_Bits_para_Representar_Axa de migração - porcentagem de novos indivíduos que surgem (do nada) a cada geração.
nb_setval(taxa_de_migracao,0.1),

% Probabilimite_inferior_do_dominio_de_dade de ocorrer crossover com o indivíduo.
nb_setval(probabilimite_inferior_do_dominio_de_dade_crossover,0.75),

% Limite para definição de um indivíduo como solução (se o fitness dele for inferior ao valor será considerada solução.
nb_setval(limite_para_definicao_como_solucao,0),

% Número de bits para representar D.
nb_setval(numero_de_bits_para_representar_d,16),

% Limite inferior do domínio de D.
nb_setval(limite_inferior_do_dominio_de_d,0.00000042),

% Limite superior do domínio de D
nb_setval(limite_superior_do_dominio_de_d,0.0000482),

% Número de bits para representar Cs.
nb_setval(numero_de_bits_para_representar_cs,16),

% Limite inferior do domínio de Cs
nb_setval(limite_inferior_do_dominio_de_cs,2.7),

% Limite superior do domínio de Cs
nb_setval(limite_superior_do_dominio_de_cs,40),

% Número de bits para representar A.
nb_setval(numero_de_bits_para_representar_a,16),

% Limite inferior do domínio de A
nb_setval(limite_inferior_do_dominio_de_a,33.3),

% Limite superior do domínio de A
nb_setval(limite_superior_do_dominio_de_a,133.1),

% Número de bits para representar H.
nb_setval(numero_de_bits_para_representar_h,16),

% Limite inferior do domínio de H
nb_setval(limite_inferior_do_dominio_de_h,0.164),

% Limite superior do domínio de H
nb_setval(limite_superior_do_dominio_de_h,0.170),

% Limite da distância euclidana para eliminar um indivíduo no torneio (se a distância euclidiana entre dois indivíduos for menor do que esse limite, o indivíduo de maior fitness é eliminado).
nb_setval(limite_da_distancia_euclidiana_no_torneio,0.13),

% Parâmetros [D, Cs, A, H] que servirão para gerar os dados da curva que deverá ser aproximada.
nb_setval(parametros_de_referencia,[0.0000135,16.2,70,0.167]).

/* gera_individuo(-Individuo) 
   Gera um Individuo aleatório. O individuo é dado por Fitness-[D-D_Binario,Cs-Cs_Binario,A-A_Binario,H-H_Binario] onde:
		Fitness -> Valor da fitness do indivíduo
		D -> Valor do coeficiente de difusão
		D_Binario-> Representação binária do coeficiente de difusão
		Cs -> Valor do coeficiente de solubilidade
		Cs_Binario -> Representação binária do coeficiente de solubilidade
		A -> Valor da carga de fármaco
		A_Binario -> Representação binária da carga de fármaco
		H -> Valor da altura do comprimido
		H_Binario -> Representação binária da altura do comprimido
   Determinístico.
*/
gera_individuo(Fitness-[D-D_Binario,Cs-Cs_Binario,A-A_Binario,H-H_Binario]):-
	nb_getval(numero_de_bits_para_representar_d,Numero_de_Bits_para_Representar_D),
	gera_binario_aleatorio(Numero_de_Bits_para_Representar_D,D_Binario),
	nb_getval(limite_inferior_do_dominio_de_d,Lid),
	nb_getval(limite_superior_do_dominio_de_d,Lsd),
	converte_binario_para_decimal(Lid,Lsd,D_Binario,D),
	nb_getval(numero_de_bits_para_representar_cs,Numero_de_Bits_para_Representar_Cs),
	gera_binario_aleatorio(Numero_de_Bits_para_Representar_Cs,Cs_Binario),
	nb_getval(limite_inferior_do_dominio_de_cs,Lics),
	nb_getval(limite_superior_do_dominio_de_cs,Lscs),
	converte_binario_para_decimal(Lics,Lscs,Cs_Binario,Cs),
	numero_de_bits_para_representar_a,Numero_de_Bits_para_Representar_A),
	gera_binario_aleatorio(Numero_de_Bits_para_Representar_A,A_Binario),
	nb_getval(limite_inferior_do_dominio_de_a,Lia),
	nb_getval(limite_superior_do_dominio_de_a,Lsa),
	converte_binario_para_decimal(Lia,Lsa,A_Binario,A),
	nb_getval(numero_de_bits_para_representar_h,Numero_de_Bits_para_Representar_H),
	gera_binario_aleatorio(Numero_de_Bits_para_Representar_H,H_Binario),
	nb_getval(limite_inferior_do_dominio_de_h,Lih),
	nb_getval(limite_superior_do_dominio_de_h,Lsh),
	converte_binario_para_decimal(Lih,Lsh,H_Binario,H),
	fitness([D,Cs,A,H],Fitness).

/* gera_populacao(+Numero_de_Individuos,-Populacao) 
   Gera uma população de indivíduos aleatórios onde:
		+Numero_de_Individuos -> Numero de indivíduos que serão gerados para a população.
		-Populacao -> População gerada.
   Determinístico.
*/
gera_populacao(Numero_de_Individuos,Populacao) :-
	ger_populacao(Numero_de_Individuos,[],Populacao).

/* ger_populacao(+Numero_de_Individuos,+PopulacaoInicial,-PopulacaoFinal)
   Implementa gera_populacao/2, onde:
		+ Numero_de_Individuos -> Numero de indivíduos que serão gerados para a população.
		+ PopulacaoInicial -> Acumulador a ser preenchido até chegar em PopulacaoFinal 
   Determinístico.
*/
ger_populacao(0,PopulacaoFinal,PopulacaoFinal):-!.
ger_populacao(Numero_de_Individuos,Populacao,PopulacaoFinal):-
	gera_individuo(Individuo),
	NumeroIndividuosAtualizado is NumeroIndividuos-1,
	ger_populacao(NumeroIndividuosAtualizado,[Individuo|Populacao],PopulacaoFinal).