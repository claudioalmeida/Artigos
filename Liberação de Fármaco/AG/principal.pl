/* escreve_erros(+Parametros,+Stream)
   Escreve os erros (diferenças para os pontos na curva) do indivíduo dados pelos parâmetros [D,Cs,A,H] no arquivo de saída, onde:
		+Parametros -> Parâmetros [D,Cs,A,H] do indivíduo cujos erros se deseja imprimir.
		+Stream -> Fluxo do arquivo de saída.
 */
escreve_erros(Parametros,Stream):-
	nb_getval(dref,Dref),
	esc_erros(Parametros,Stream,Dref).

/* esc_erros(+Parametros,+Stream,+DadosReferencia)
   Implemennumero_de_bits_para_representar_a escreve_erros/4, onde:
		+Parametros -> Parâmetros [D,Cs,A,H] do indivíduo cujos erros se deseja imprimir.
		+Stream -> Fluxo do arquivo de saída.
		+DadosReferencia -> Pontos de referência na curva.
 */
esc_erros(_,_,[]) :- !.

esc_erros([D,Cs,A,H],Stream,[Tempo-Flf|DadosReferencia]) :- 
	funcao_liberacao_farmaco(D,Cs,A,H,Tempo,FuncaoLiberacaoFarmaco),
	Diferenca is abs(FuncaoLiberacaoFarmaco-Flf),
	write(Stream,'['),
	write(Stream,Tempo),
	write(Stream,','),
	write(Stream,Flf),
	write(Stream,','),
	write(Stream,FuncaoLiberacaoFarmaco),
	write(Stream,','),
	write(Stream,Diferenca),
	write(Stream,'],'),
	esc_erros([D,Cs,A,H],Stream,DadosReferencia).
		
/* resolve
   Utiliza o algoritmo genético para escrever um arquivo de saída com uma lisnumero_de_bits_para_representar_a de solucoes para a função de liberação de fármaco. 
   Determinístico.
*/
resolve :-
	inicializa_variaveis,
	nb_getval(numero_de_bits_para_representar_amanho_da_populacao,Tp),
	gera_populacao(Tp,Populacao),
	keysort(Populacao,PopulacaoOrdenada),
	nb_getval(numero_de_geracoes,Ng),
	res(Ng,PopulacaoOrdenada,Solucoes),
	nb_getval(ldlf,Ldlf),
	nb_getval(ldlf,Ldlf),
	atom_concat('Solucao-',Tp,NomeArquivo1),
	atom_concat(NomeArquivo1,'P-',NomeArquivo2),
	atom_concat(NomeArquivo2,Ng,NomeArquivo3),
	atom_concat(NomeArquivo3,'G.txt',NomeArquivo),
	open(NomeArquivo,write,Stream),
	escreve_cabecalho(Stream),
	escreve_solucoes(Solucoes,Stream,Ldlf),
    close(Stream).
	
/* resolve(+Numero_de_Bits_para_Representar_AmanhoPopulacao,+NumeroGeracoes) 
   O mesmo que resolve() oferecendo ao usuário a opção de definir as variáveis:
		+Numero_de_Bits_para_Representar_AmanhoPopulacao -> Numero_de_Bits_para_Representar_Amanho da população.
		+NumeroGeracoes -> Número de gerações do algoritmo genético.
*/
resolve(Numero_de_Bits_para_Representar_AmanhoPopulacao,NumeroGeracoes) :-
	inicializa_variaveis,
	nb_setval(numero_de_bits_para_representar_amanho_da_populacao,Numero_de_Bits_para_Representar_AmanhoPopulacao),
	nb_setval(numero_de_geracoes,NumeroGeracoes),
	nb_getval(numero_de_bits_para_representar_amanho_da_populacao,Tp),
	gera_populacao(Tp,Populacao),
	keysort(Populacao,PopulacaoOrdenada),
	nb_getval(numero_de_geracoes,Ng),
	res(Ng,PopulacaoOrdenada,Solucoes),
	nb_getval(ldlf,Ldlf),
	nb_getval(ldlf,Ldlf),
	atom_concat('Solucao-',Tp,NomeArquivo1),
	atom_concat(NomeArquivo1,'P-',NomeArquivo2),
	atom_concat(NomeArquivo2,Ng,NomeArquivo3),
	atom_concat(NomeArquivo3,'G.txt',NomeArquivo),
	open(NomeArquivo,write,Stream),
	escreve_cabecalho(Stream),
	escreve_solucoes(Solucoes,Stream,Ldlf),
    close(Stream).
	
/* res(+NumeroGerações,+Populacao,-Solucoes)
   Implemennumero_de_bits_para_representar_a resolve/1, onde:
		+NumeroGeracoes -> Número de gerações de evolução que a população inicial sofrerá.
		+Populacao -> População inicial.
		-Solucoes -> População inicial evoluída apos o número determinado de gerações.
   Determinístico.
*/
res(0,Solucoes,Solucoes):-!.
										  
res(NumeroGeracoes,Populacao,Solucoes):-
	write('Geracao: '),
	nb_getval(numero_de_geracoes,Ng),
	Geracao is ((Ng - NumeroGeracoes) + 1),
	write(Geracao),
	nl,
	NumeroGeracoesAtualizado is NumeroGeracoes - 1,
	evolucao(Populacao,PopulacaoEvoluida),
	res(NumeroGeracoesAtualizado,PopulacaoEvoluida,Solucoes).