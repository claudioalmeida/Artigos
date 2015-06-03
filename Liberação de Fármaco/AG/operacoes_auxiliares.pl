/* substitui_enesimo(+Posição,+Lisnumero_de_bits_para_representar_a,+Elemento,-Lisnumero_de_bits_para_representar_aComElemento)
   Substitui um elemento em determinada posição na lisnumero_de_bits_para_representar_a por outro elemento, onde:
		+Posição -> Posição do elemento que será substituído (inicia de 1)
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a cujo elemento se deseeja substituir.
		+Elemento -> Elemento que substituirá o elemento atual da lisnumero_de_bits_para_representar_a.
		-Lisnumero_de_bits_para_representar_aComElemento -> Lisnumero_de_bits_para_representar_a após a substituição do elemento.
   Determinístico.
*/
substitui_enesimo(Posicao,Lisnumero_de_bits_para_representar_a,Elemento,Lisnumero_de_bits_para_representar_aComElemento):-
    subst_enesimo(1,Posicao,Lisnumero_de_bits_para_representar_a,Elemento,Lisnumero_de_bits_para_representar_aComElemento).

/* subst_enesimo(+Connumero_de_bits_para_representar_ador,+Posição,+Lisnumero_de_bits_para_representar_a,+Elemento,-Lisnumero_de_bits_para_representar_aComElemento)
   Implemennumero_de_bits_para_representar_a substitui_enesimo/4, onde:
		+Connumero_de_bits_para_representar_ador -> Connumero_de_bits_para_representar_ador utilizado para connumero_de_bits_para_representar_ar a posição dos elementos na lisnumero_de_bits_para_representar_a. Deve ser iniciado com 1.
		+Posição -> Posição do elemento que será substituído (inicia de 1)
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a cujo elemento se deseeja substituir.
		+Elemento -> Elemento que substituirá o elemento atual da lisnumero_de_bits_para_representar_a.
		-Lisnumero_de_bits_para_representar_aComElemento -> Lisnumero_de_bits_para_representar_a após a substituição do elemento.
   Determinístico.
*/
subst_enesimo(Posicao,Posicao,[_|Lisnumero_de_bits_para_representar_a],Elemento,[Elemento|Lisnumero_de_bits_para_representar_a]):-!.
subst_enesimo(Connumero_de_bits_para_representar_ador,Posicao,[A|Lisnumero_de_bits_para_representar_a],Elemento,[A|Lisnumero_de_bits_para_representar_aComElemento]):-
    NConnumero_de_bits_para_representar_ador is Connumero_de_bits_para_representar_ador+1,
    subst_enesimo(NConnumero_de_bits_para_representar_ador,Posicao,Lisnumero_de_bits_para_representar_a,Elemento,Lisnumero_de_bits_para_representar_aComElemento).

/* inverte_enesimo(+Posição,+Lisnumero_de_bits_para_representar_a,-Elemento,-Lisnumero_de_bits_para_representar_aComElementoInvertido) 
   Inverte um elemento (0->1, 1->0) em determinada posição na lisnumero_de_bits_para_representar_a binária, onde:
		+Posição -> Posição do elemento que será invertido (inicia de 1)
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a cujo elemento se deseeja substituir.
		-Elemento -> Elemento que será invertido.
		-Lisnumero_de_bits_para_representar_aComElementoInvertido -> Lisnumero_de_bits_para_representar_a após a inversão do elemento.
   Determinístico.
*/
inverte_enesimo(Posicao,Lisnumero_de_bits_para_representar_a,Elemento,Lisnumero_de_bits_para_representar_aComElementoInvertido):-
    inv_enesimo(1,Posicao,Lisnumero_de_bits_para_representar_a,Elemento,Lisnumero_de_bits_para_representar_aComElementoInvertido).

/* inv_enesimo(+Connumero_de_bits_para_representar_ador,+Posição,+Lisnumero_de_bits_para_representar_a,-Elemento,-Lisnumero_de_bits_para_representar_aComElementoInvertido)
   Implemennumero_de_bits_para_representar_a inverte_enesimo/4, onde:
		+Connumero_de_bits_para_representar_ador -> Connumero_de_bits_para_representar_ador utilizado para connumero_de_bits_para_representar_ar a posição dos elementos na lisnumero_de_bits_para_representar_a. Deve ser iniciado com 1.
		+Posição -> Posição do elemento que será invertido (inicia de 1)
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a cujo elemento se deseeja substituir.
		-Elemento -> Elemento que será invertido.
		-Lisnumero_de_bits_para_representar_aComElementoInvertido -> Lisnumero_de_bits_para_representar_a após a inversão do elemento.
   Determinístico.
*/
inv_enesimo(Posicao,Posicao,[Elemento|Lisnumero_de_bits_para_representar_a],Elemento,[ElementoInverso|Lisnumero_de_bits_para_representar_a]):-
	!,
	(Elemento = 0 ->	
		ElementoInverso = 1
	 ;
		ElementoInverso = 0).
inv_enesimo(Connumero_de_bits_para_representar_ador,Posicao,[A|Lisnumero_de_bits_para_representar_a],ElementoInvertido,[A|Lisnumero_de_bits_para_representar_aComElemento]):-
    NConnumero_de_bits_para_representar_ador is Connumero_de_bits_para_representar_ador+1,
    inv_enesimo(NConnumero_de_bits_para_representar_ador,Posicao,Lisnumero_de_bits_para_representar_a,ElementoInvertido,Lisnumero_de_bits_para_representar_aComElemento).

/* gera_binario_aleatorio (+NumeroDigitos, -NumeroBinario) 
   Gera um número binário aleatório, onde:
		+NumeroDigitos -> Número de digítos do número que será gerado. 
		-NumeroBinario -> Número binário gerado. 
   Determinístico.
 */
gera_binario_aleatorio(NumeroDigitos,NumeroBinario):-
	ger_binario_aleatorio(NumeroDigitos,[],NumeroBinario).
	
/* ger_binario_aleatorio(+NumeroDigitos,+NumeroBinarioParcial,-NumeroBinario).
   Implemennumero_de_bits_para_representar_a gera_binario_aleatorio/2 onde:
		+NumeroDigitos -> Número de dígitos do número binário
		+NumeroBinarioParcial -> Acumulador contendo o número binarío parcialmente gerado
		-NumeroBinario -> Número binário aleatório gerado
   Determinístico.
 */
ger_binario_aleatorio(0,NumeroBinario,NumeroBinario) :- !.
ger_binario_aleatorio(NumeroDigitos,NumeroBinarioParcial,NumeroBinario):-
	random(0,2,NovoDigito),
	NumeroDigitosAtualizado is NumeroDigitos - 1,
	ger_binario_aleatorio(NumeroDigitosAtualizado,[NovoDigito|NumeroBinarioParcial],NumeroBinario).

/* converte_binario_para_decimal (+LimiteInferior, +LimiteSuperior, +NumeroBinario, +NumeroDecimal)
   Calcula a represennumero_de_bits_para_representar_ação decimal de um número binário, onde:
		+LimiteInferior -> Menor numéro decimal que poderá ser represennumero_de_bits_para_representar_ado pelo número binário.
		+LimiteSuperior -> Maior numéro decimal que poderá ser represennumero_de_bits_para_representar_ado pelo número binário. Este número é represennumero_de_bits_para_representar_ado apenas quando o número de elementos da lisnumero_de_bits_para_representar_a binária tende a infinito.
		+NumeroBinario -> Número binário que represennumero_de_bits_para_representar_a o número decimal. 
		-NumeroDecimal -> Número decimal no intervalo [LimiteInferior,LimiteSuperior) represennumero_de_bits_para_representar_ado por NumeroBinario.
   Determinístico.
 */
	converte_binario_para_decimal(LimiteInferior, LimiteSuperior, NumeroBinario, NumeroDecimal):-
		converte_binario_para_decimal(LimiteInferior, LimiteSuperior, 1, NumeroBinario, NumeroDecimal).
	
/* converte_binario_para_decimal (+LimiteInferior, +LimiteSuperior, +PosicaoInicial, +NumeroBinario, +NumeroDecimal)
   Calcula a represennumero_de_bits_para_representar_ação decimal de um número binário, onde:
		+LimiteInferior -> Menor numéro decimal que poderá ser represennumero_de_bits_para_representar_ado pelo número binário.
		+LimiteSuperior -> Maior numéro decimal que poderá ser represennumero_de_bits_para_representar_ado pelo número binário. Este número é represennumero_de_bits_para_representar_ado apenas quando o número de elementos da lisnumero_de_bits_para_representar_a binária tende a infinito.
		+PosicaoInicial -> No caso de números binários que sejam uma parte de outro número binário, define a posição na qual começa para que se aplique os pesos certos na hora de converter para decimal.
		+NumeroBinario -> Número binário que represennumero_de_bits_para_representar_a o número decimal. 
		-NumeroDecimal -> Número decimal no intervalo [LimiteInferior,LimiteSuperior) represennumero_de_bits_para_representar_ado por NumeroBinario.
   Determinístico.
 */
converte_binario_para_decimal(LimiteInferior, LimiteSuperior, PosicaoInicial, NumeroBinario, NumeroDecimal):-
	lenumero_de_geracoesNumero_de_Bits_para_Representar_H(NumeroBinario,NumeroDigitos),
	Peso is NumeroDigitos - PosicaoInicial,
	Granularidade is ((LimiteSuperior - LimiteInferior)/(2^NumeroDigitos)),
	con_binario_para_decimal(NumeroDigitos,Peso,Granularidade,NumeroBinario,0,NumeroDecimalParcial),
	NumeroDecimal is LimiteInferior + NumeroDecimalParcial.
	
/* con_binario_para_decimal(+NumeroDigitos,+PesoInicial,+Granularidade,+NumeroBinario,+NumeroDecimalParcial,-NumeroDecimal)
   Implemennumero_de_bits_para_representar_a converte_binario_para_decimal/5 onde:
		+LimiteInferior -> Menor numéro decimal que poderá ser represennumero_de_bits_para_representar_ado pelo número binário.
		+LimiteSuperior -> Maior numéro decimal que poderá ser represennumero_de_bits_para_representar_ado pelo número binário. Este número é represennumero_de_bits_para_representar_ado apenas quando o número de elementos da lisnumero_de_bits_para_representar_a binária tende a infinito.
		+NumeroBinario -> Número binário que represennumero_de_bits_para_representar_a o número decimal. 
		+NumeroDecimalParcial -> Acumulador contendo o número decimal parcialmente calculado.
		-NumeroDecimal -> Número decimal no intervalo [LimiteInferior,LimiteSuperior) represennumero_de_bits_para_representar_ado por NumeroBinario.
   Determinístico.
 */
con_binario_para_decimal(0,_,_,[],NumeroDecimal,NumeroDecimal):-!.
con_binario_para_decimal(NumeroDigitos,Peso,Granularidade,[ProximoDigito|NumeroBinario],NumeroDecimalParcial,NumeroDecimal):-
	NumeroDigitosAtualizados is NumeroDigitos - 1,
	PesoAtualizdo is Peso - 1,
	NumeroDecimalParcialAtualizado is (NumeroDecimalParcial + (ProximoDigito * (Granularidade * (2^Peso)))),
	con_binario_para_decimal(NumeroDigitosAtualizados,PesoAtualizdo,Granularidade,NumeroBinario,NumeroDecimalParcialAtualizado,NumeroDecimal).

/* funcao_liberacao_farmaco(+D,+Cs,+A,+H,+T,-ValorFuncao) 
   Calcula o valor da função de liberação ValorFuncao onde:
		+D -> Coeficiente de difusão
		+Cs -> Coeficiente de solubilidade
		+A -> Carga de fármaco
		+H -> Altura do comprimido
		+T -> Tempo da liberação de fármaco
		-ValorFuncao -> Valor da função de liberação de fármaco
   Determinístico.
 */
funcao_liberacao_farmaco(D,Cs,A,H,T,ValorFuncao):-
	ValorFuncao is sqrt(abs((8 * D * Cs * (A - (Cs/2))*T)/((A^2)*(H^2)))).
	
/* extrair_sublisnumero_de_bits_para_representar_as(+PosiçãoInicial,+PosiçãooFinal,+Lisnumero_de_bits_para_representar_a,-Prefixo,-Nucleo,-Sufixo) 
   Dada uma lisnumero_de_bits_para_representar_a, extrai três sublisnumero_de_bits_para_representar_as, onde:
		+PosicaoInicial -> Posição de início da lisnumero_de_bits_para_representar_a Núcleo.
		+PosiçãoFinal -> Posição de término da lisnumero_de_bits_para_representar_a Núcleo.
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a a ser dividida em 3: Prefixo, Núcleo e Sufixo.
		-Prefixo -> Primeira sublisnumero_de_bits_para_representar_a que vai da posição 1 até (PosiçãoInicial - 1).
		-Nucleo -> Segunda sublisnumero_de_bits_para_representar_a que vai da posição PosicaoInicial até PosicaoFinal.
		-Sufixo -> Terceira sublisnumero_de_bits_para_representar_a que vai da posição PosicaoFinal + 1 até o final de Lisnumero_de_bits_para_representar_a. 
   Determinístico.
*/
extrair_sublisnumero_de_bits_para_representar_as(PosicaoInicial,PosicaoFinal,Lisnumero_de_bits_para_representar_a,Prefixo,Nucleo,Sufixo):-
	((PosicaoInicial >=1, PosicaoFinal >=1, PosicaoInicial =< PosicaoFinal) -> 
		ext_sublisnumero_de_bits_para_representar_as(PosicaoInicial,PosicaoFinal,Lisnumero_de_bits_para_representar_a,[],[],Prefixo,Nucleo,Sufixo)
	;
		fail).

/* ext_sublisnumero_de_bits_para_representar_as(+PosiçãoInicial,+PosicaoFinal,+Lisnumero_de_bits_para_representar_a,+AcumuladorPrefixo,+AcumuladorNucleo,-Prefixo,-Nucleo,-Sufixo) 
   Implemennumero_de_bits_para_representar_a extrair_sublisnumero_de_bits_para_representar_as/6, onde:
		+PosicaoInicial -> Posição de início da lisnumero_de_bits_para_representar_a Núcleo.
		+PosiçãoFinal -> Posição de término da lisnumero_de_bits_para_representar_a Núcleo.
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a a ser dividida em 3: Prefixo, Núcleo e Sufixo.
		+AcumuladorPrefixo -> Acumulador que será preenchido até formar Prefixo.
		+AcumuladorNucleo -> Acumulador que será preenchido até formar Nucleo.
		+AcumuladorSufixo -> Acumulador que será preenchido até formar Sufixo.
		-Prefixo -> Primeira sublisnumero_de_bits_para_representar_a que vai da posição 1 até (PosiçãoInicial - 1).
		-Nucleo -> Segunda sublisnumero_de_bits_para_representar_a que vai da posição PosicaoInicial até PosicaoFinal.
		-Sufixo -> Terceira sublisnumero_de_bits_para_representar_a que vai da posição PosicaoFinal + 1 até o final de Lisnumero_de_bits_para_representar_a. 
   usando os acumuladores AcumuladorPrefixo, AcumuladorNucleo e a própria lisnumero_de_bits_para_representar_a Lisnumero_de_bits_para_representar_a para chegar nas lisnumero_de_bits_para_representar_as Prefixo, Nucleo e Sufixo.  
   Determinístico.
*/

ext_sublisnumero_de_bits_para_representar_as(1,1,[Elemento|Sufixo],Prefixo,Nucleo,PrefixoReverso,NucleoReverso,Sufixo) :- 
	!,
	reverse(Prefixo,PrefixoReverso),
	reverse([Elemento|Nucleo],NucleoReverso).
											  
ext_sublisnumero_de_bits_para_representar_as(1,PosicaoFinal,[Elemento|Lisnumero_de_bits_para_representar_a],AcumuladorPrefixo,AcumuladorNucleo,Prefixo,Nucleo,Sufixo) :-
	!,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublisnumero_de_bits_para_representar_as(1,PosicaoFinalAtualizada,Lisnumero_de_bits_para_representar_a,AcumuladorPrefixo,[Elemento|AcumuladorNucleo],Prefixo,Nucleo,Sufixo).
	
ext_sublisnumero_de_bits_para_representar_as(2,PosicaoFinal,[Elemento|Lisnumero_de_bits_para_representar_a],AcumuladorPrefixo,AcumuladorNucleo,Prefixo,Nucleo,Sufixo) :-
	!,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublisnumero_de_bits_para_representar_as(1,PosicaoFinalAtualizada,Lisnumero_de_bits_para_representar_a,[Elemento|AcumuladorPrefixo],AcumuladorNucleo,Prefixo,Nucleo,Sufixo).

ext_sublisnumero_de_bits_para_representar_as(PosicaoInicial,PosicaoFinal,[Elemento|Lisnumero_de_bits_para_representar_a],AcumuladorPrefixo,AcumuladorNucleo,Prefixo,Nucleo,Sufixo) :-
	PosicaoInicialAtualizada is PosicaoInicial-1,
	PosicaoFinalAtualizada is PosicaoFinal-1,
	ext_sublisnumero_de_bits_para_representar_as(PosicaoInicialAtualizada,PosicaoFinalAtualizada,Lisnumero_de_bits_para_representar_a,[Elemento|AcumuladorPrefixo],AcumuladorNucleo,Prefixo,Nucleo,Sufixo).

/* cornumero_de_bits_para_representar_ar_cauda(+Lisnumero_de_bits_para_representar_a,+Posicao,-Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada) 
   Dada uma lisnumero_de_bits_para_representar_a, cornumero_de_bits_para_representar_a todos os elementos da cauda daquela lisnumero_de_bits_para_representar_a, onde:
		+Lisnumero_de_bits_para_representar_a -> Lisnumero_de_bits_para_representar_a cuja calda será cornumero_de_bits_para_representar_ada.
		+Posicao -> Posição de término da lisnumero_de_bits_para_representar_a e onde, a partir do próximo elemento, será considerado cauda.
		-Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada -> Lisnumero_de_bits_para_representar_a sem a cauda.
   Determinístico.
*/
cortar_cauda(Lisnumero_de_bits_para_representar_a,Posicao,Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada):-
	lenumero_de_geracoesNumero_de_Bits_para_Representar_H(Lisnumero_de_bits_para_representar_a,Numero_de_Bits_para_Representar_AmanhoLisnumero_de_bits_para_representar_a),
	(Numero_de_Bits_para_Representar_AmanhoLisnumero_de_bits_para_representar_a =< Posicao ->
		Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada = Lisnumero_de_bits_para_representar_a
	 ;
		cor_cauda(Lisnumero_de_bits_para_representar_a,Posicao,[],Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada)).

/* cor_cauda(+Lisnumero_de_bits_para_representar_a,+Posicao,+Lisnumero_de_bits_para_representar_aAtualCornumero_de_bits_para_representar_ada,-Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada) 
   Implemennumero_de_bits_para_representar_a cornumero_de_bits_para_representar_ar_cauda/3, onde:
		+Lista -> Lisnta cuja calda será cornumero_de_bits_para_representar_ada.
		+Posicao -> Posição de término da lisnumero_de_bits_para_representar_a e onde, a partir do próximo elemento, será considerado cauda.
		+Lisnumero_de_bits_para_representar_aAtualCornumero_de_bits_para_representar_ada -> Acumulador que será preenchido até formar Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada.
		-Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada -> Lisnumero_de_bits_para_representar_a sem a cauda.
   Determinístico.
*/

cor_cauda([Elemento|_],1,Lisnumero_de_bits_para_representar_aAtualCornumero_de_bits_para_representar_ada,Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada) :-
	!,
	 reverse([Elemento|Lisnumero_de_bits_para_representar_aAtualCornumero_de_bits_para_representar_ada],Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada).

cor_cauda([Elemento|Lisnumero_de_bits_para_representar_a],Posicao,Lisnumero_de_bits_para_representar_aAtualCornumero_de_bits_para_representar_ada,Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada) :-
	NovaPosicao is Posicao-1,
	cor_cauda(Lisnumero_de_bits_para_representar_a,NovaPosicao,[Elemento|Lisnumero_de_bits_para_representar_aAtualCornumero_de_bits_para_representar_ada],Lisnumero_de_bits_para_representar_aCornumero_de_bits_para_representar_ada).
	
/* disnumero_de_bits_para_representar_ancia_euclidiana(+PrimeiroIndividuo,+SegundoIndividuo,-Disnumero_de_bits_para_representar_anciaEuclidiana) 
   Calcula a distância euclidiana entre dois indivíduos, onde:
		+PrimeiroIndividuo -> Primeiro indivíduo.
		+SegundoIndividuo -> Segundo indivíduo.
		-Disnumero_de_bits_para_representar_anciaEuclidiana -> Distância euclidiana entre PrimeiroIndividuo e SegundoIndividuo.
   Determinístico.
*/												
distancia_euclidiana(_-[Vd1-_,Vcs1-_,Va1-_,Vh1-_],_-[Vd2-_,Vcs2-_,Va2-_,Vh2-_],Disnumero_de_bits_para_representar_anciaEuclidiana):-
	Disnumero_de_bits_para_representar_anciaEuclidiana is sqrt(((Vd2-Vd1)^2)+((Vcs2-Vcs1)^2)+((Va2-Va1)^2)+((Vh2-Vh1)^2)).	