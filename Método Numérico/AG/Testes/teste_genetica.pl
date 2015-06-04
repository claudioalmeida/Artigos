teste_genetica(NumeroGeracoes):-
	between(1,NumeroGeracoes,Geracao),
	nl,
	write('Geracao: '),
	write(Geracao),
	gera_individuo(X),
	%mutacao(X,_),
	(\+ crossover(X,Z1,	Z2,	Z3,	Z4,	Z5,	Z6,	Z7,	Z8,	Z9,	Z10,	Z11,	Z12,	Z13,	Z14,	Z15,	Z16,	Z17,	Z18,	Z19,	Z20,	Z21,	Z22,	Z23,	Z24) ->
		break,break
	 ;
	(Geracao = NumeroGeracoes -> 
		write('Entrei onde deveria!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'),
		true
	 ;
		write('Entrei onde deveria!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'),
		fail)).