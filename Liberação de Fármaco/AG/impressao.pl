/* escreve_cabecalho(+Stream)
   Escreve o cabeçalho do arquivo com os valores das variáveis definidas, onde:
		+Stream -> Fluxo do arquivo de saída.
 */
escreve_cabecalho(Stream) :-
	format(Stream,'~`=t ~164|~n',[]),
	format(Stream,'~` t ~w ~` t ~164|~n', ['Resulnumero_de_bits_para_representar_ados Algoritmo Genético Liberação de Fármaco']),
	format(Stream,'~`=t ~164|~n',[]),
	format(Stream,'~` t ~w ~` t ~164|~n', ['Parâmetros']),
	format(Stream,'~`-t ~164|~n',[]),
	get_time(X), 
	format_time(atom(Danumero_de_bits_para_representar_a), '%c', X),
	snumero_de_bits_para_representar_atistics(runtime,[_,Y]), 
	T is Y/1000,
	nb_getval(numero_de_bits_para_representar_amanho_da_populacao,Tp),
	nb_getval(numero_de_geracoes,Ng),
	nb_getval(lmaxtl,Lmaxtl),
	format(Stream,'	~w ~w 	~w ~3f~w 	~w ~w 	~w ~w 	~w ~w~n~n', ['Danumero_de_bits_para_representar_a = ', Danumero_de_bits_para_representar_a, 'Tempo de execução = ', T,'s','Numero_de_Bits_para_Representar_Amanho da população = ',	Tp,
	'Número de gerações = ',Ng,' Limite máximo de tempo = ',Lmaxtl]),
	nb_getval(numero_de_bits_para_representar_axa_de_migracao,Tmi),
	TmiPorcento is Tmi * 100,
	nb_getval(ldlf,Ldlf),
	nb_getval(limite_da_distancia_euclidiana_no_torneio,Lde),
	nb_getval(nd,Nd),
	format(Stream,'	~w ~2f~w 		~w ~w 			~w ~2f 		~w ~w~n~n', ['Numero_de_Bits_para_Representar_Axa de migração = ', TmiPorcento, '%','Limite de erro = ', 
	Ldlf,'Limite do Torneio em Habinumero_de_bits_para_representar_at = ',	Lde,'Número de pontos da curva de referência = ',Nd]),
	nb_getval(numero_de_bits_para_represennumero_de_bits_para_representar_ar_d,Numero_de_Bits_para_Representar_D),
	nb_getval(lid,Lid),
	nb_getval(limite_superior_do_dominio_de_d,Lsd),
	nb_getval(parametros_de_referencia,[D,Cs,A,H]),
	format(Stream,'	~w	~w	~w		~w	~w		~w	~w	~w	~w~n', ['Referência, Numero_de_Bits_para_Representar_Amanho, Limite Inferior e Limite Superior: ', 'D	=' , D, 'Numero_de_Bits_para_Representar_D	=' , Numero_de_Bits_para_Representar_D, 
	'Lid	 =', Lid, '	Lsd	 =' ,	Lsd]),
	nb_getval(numero_de_bits_para_represennumero_de_bits_para_representar_ar_cs,Numero_de_Bits_para_Representar_Cs),
	nb_getval(limite_inferior_do_dominio_de_cs,Lics),
	nb_getval(limite_superior_do_dominio_de_cs,Lscs),
	format(Stream,'																~w	~w		~w	~w		~w	~w			~w	~w~n', ['Cs	=' , Cs, 'Numero_de_Bits_para_Representar_Cs	=', 
	Numero_de_Bits_para_Representar_Cs, 'Lics =', Lics, 'Lscs =' ,	Lscs]),
	nb_getval(numero_de_bits_para_representar_a,Numero_de_Bits_para_Representar_A),
	nb_getval(limite_inferior_do_dominio_de_a,Lia),
	nb_getval(limite_superior_do_dominio_de_a,Lsa),
	format(Stream,'																~w	~w			~w	~w		~w	~w		~w	~w~n', ['A	=' , A, 'Numero_de_Bits_para_Representar_A	=' , 
	Numero_de_Bits_para_Representar_A,	'Lia	 =', Lia, 'Lsa	 =' ,	Lsa]),
	nb_getval(Numero_de_Bits_para_Representar_H,Numero_de_Bits_para_Representar_H),
	nb_getval(limite_inferior_do_dominio_de_h,Lih),
	nb_getval(limite_superior_do_dominio_de_h,Lsh),
	format(Stream,'																~w	~w		~w	~w		~w	~w		~w	~w~n', ['H	=' , H, 'Numero_de_Bits_para_Representar_H	=' , 
	Numero_de_Bits_para_Representar_H, 'Lih	 =', Lih, 'Lsh	 =' ,	Lsh]),
	format(Stream,'~`=t ~164|~n',[]),
	format(Stream,'~` t ~w ~` t ~164|~n', ['Soluções']),
	format(Stream,'~` t ~w ~` t ~w ~` t ~w ~` t ~w ~` t ~w ~` t ~w ~164|~n', ['Posição','Fitness','D','Cs','A','H']),
	format(Stream,'~`-t ~164|~n',[]).

/* escreve_solucoes(+Populacao,+Stream,+LimiteErro)
   Escreve as soluções encontradas no arquivo de saída, onde:
		+Populacao -> População final após evolução.
		+Stream -> Fluxo do arquivo de saída.
		+LimiteErro -> Limite de erro da fitness no qual um indivíduo é considerado uma solução.
 */

escreve_solucoes([F-[Vd-_,Vcs-_,Va-_,Vh-_]|Solucoes],Stream,LimiteErro) :- 
		esc_solucoes(0,[F-[Vd-_,Vcs-_,Va-_,Vh-_]|Solucoes],Stream,LimiteErro).
	
/* esc_solucoes(+PosiçãoIndividuo,+Populacao,+Stream,+LimiteErro)
   Escreve as soluções encontradas no arquivo de saída, onde:
		+PosiçãoIndividuo -> Posição do indivíduo em relação ao seu fitness (quanto menor o valor da posição, melhor é o indivíduo).
		+Populacao -> População final após evolução.
		+Stream -> Fluxo do arquivo de saída.
		+LimiteErro -> Limite de erro da fitness no qual um indivíduo é considerado uma solução.
 */
esc_solucoes(_,[],Stream, _) :- 
	format(Stream,'~`=t ~164|~n',[]).

esc_solucoes(PosicaoIndividuo,[F-[Vd-_,Vcs-_,Va-_,Vh-_]|Solucoes],Stream,LimiteErro) :- 
	(F =< LimiteErro ->
		PosicaoIndividuoAtualizada is PosicaoIndividuo + 1,
		format(Stream,'						 ~|~`0t~d~3+						~10f				~10f			  ~10f				~10f				~10f~n', [PosicaoIndividuoAtualizada,F,Vd,Vcs,Va,Vh]),
		%escreve_erros([Vd,Vcs,Va,Vh],Stream),
		esc_solucoes(PosicaoIndividuoAtualizada,Solucoes,Stream,LimiteErro)
	 ;
		esc_solucoes(PosicaoIndividuo,[],Stream,LimiteErro)).	
	