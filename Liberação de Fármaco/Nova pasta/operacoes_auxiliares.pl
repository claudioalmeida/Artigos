/* substitui_enesimo(+Posição,+Lista,+Elemento,-ListaComElemento) 
   É verdade se o argumento na posição Posição (inicia de 1) da Lista for substituído por Elemento resultando na nova lista ListaComElemento. 
   Determinístico.
*/
substitui_enesimo(Posicao,Lista,Elemento,ListaComElemento):-
	subst_enesimo(1,Posicao,Lista,Elemento,ListaComElemento).

/* subst_enesimo(+Contador,+Posição,+Lista,+Elemento,-ListaComElemento)
   Implementa substitui_enesimo|4, usando Contador para contar a posição dos elementos na lista. Contador deve ser iniciado com 1. 
   Determinístico.
*/
subst_enesimo(Posicao,Posicao,[_|Lista],Elemento,[Elemento|Lista]):-!.
subst_enesimo(Contador,Posicao,[A|Lista],Elemento,[A|ListaComElemento]):-
	NContador is Contador+1,
	subst_enesimo(NContador,Posicao,Lista,Elemento,ListaComElemento).
	
/* encontra_enesimo(+Posição,+Lista,-Elemento) 
   É verdade se o argumento da Lista na posição Posição (inicia de 1) for Elemento. 
   Determinístico.
*/
encontra_enesimo(Posicao,Lista,Elemento):-
	enc_enesimo(1,Posicao,Lista,Elemento).

/* enc_enesimo(+Contador,+Posição,+Lista,-Elemento)
   Implementa encontra_enesimo|4, usando Contador para contar a posição dos elementos na lista. Contador deve ser iniciado com 1. 
   Determinístico.
*/
enc_enesimo(Posicao,Posicao,[Elemento|_],Elemento):-!.
enc_enesimo(Contador,Posicao,[_|Lista],Elemento):-
	NContador is Contador+1,
	enc_enesimo(NContador,Posicao,Lista,Elemento).
	
/* troca_enesimo(+Posição,+PrimeiraLista,+SegundaLista,-PrimeiraListaModificada,-SegundaListaModificada) 
   é verdade se os elementos na posição Posição das listas PrimeiraLista e SegundaLista forem trocados
   resultando, respectivamente, nas listas PrimeiraListaModificada e SegundaListaModificada. Determinístico.
*/
troca_enesimo(Posicao,PrimeiraLista,SegundaLista,PrimeiraListaModificada,SegundaListaModificada):-
	tro_enesimo(1,Posicao,PrimeiraLista,SegundaLista,PrimeiraListaModificada,SegundaListaModificada).

/* tro_enesimo(+Contador,+PrimeiraLista,+SegundaLista,-PrimeiraListaModificada,-SegundaListaModificada)
   implementa troca_enesimo|5, usando Contador para contar a posição dos elementos nas listas. Contador 
   deve ser iniciado com 1. Determinístico.
*/
tro_enesimo(Posicao,Posicao,[ElementoPrimeiraLista|PrimeiraLista],[ElementoSegundaLista|SegundaLista],[ElementoSegundaLista|PrimeiraLista],[ElementoPrimeiraLista|SegundaLista]):-!.
tro_enesimo(Contador,Posicao,[ElementoPrimeiraLista|PrimeiraLista],[ElementoSegundaLista|SegundaLista],[ElementoPrimeiraLista|PrimeiraListaModificada],[ElementoSegundaLista|SegundaListaModificada]):-
	NContador is Contador+1,
	tro_enesimo(NContador,Posicao,PrimeiraLista,SegundaLista,PrimeiraListaModificada,SegundaListaModificada).


/* converte_binario_para_real(+LimiteInferior,+LimiteSuperior,+NumeroBinario,-NumeroReal) 
   É verdade se a lista com o numero binário NumeroBinario representa o número real NumeroReal
   dentro do intervalo delimitado por [LimiteInferior,LimiteSuperior). 
   Determinístico.
*/
converte_binario_para_real(LimiteInferior,LimiteSuperior,NumeroBinario,NumeroReal):-
	length(NumeroBinario,Tamanho),
	Granularidade is (LimiteSuperior-LimiteInferior)/(2^Tamanho),
	PesoAlgarismo is Tamanho - 1,
	conv_binario_para_real(Granularidade,PesoAlgarismo,NumeroBinario,0,NumeroRealParcial),
	NumeroReal is LimiteInferior + NumeroRealParcial.

/* conv_binario_para_real(+Granularidade,+PesoAlgarismo,+NumeroBinario,+NumeroRealParcial,-NumeroReal).
   Implementa converte_binario_para_real|4. 
   Granularidade representa a menor distância que dois números reais podem ter entre si de acordo com a representação de NumeroBinario. 
   PesoAlgarismo é o peso utilizado para representar a potência que será aplicada à base 2 para multiplicar o próximo algarismo de NumeroBinario pela Granularidade.
   NumeroBinario é o número que representa o número real. 
   NumeroRealParcial é o cálculo parcial do número real a partir dos algarismos de NumeroBinario já avaliados. Deve ser iniciado com 0.
   NumeroReal é a representação real do número binário NumeroBinario.
   Determinístico.
*/
conv_binario_para_real(_,-1,[],NumeroReal,NumeroReal).

conv_binario_para_real(Granularidade,PesoAlgarismo,[Algarismo|NumeroBinario],NumeroRealParcial,NumeroReal):-
	NumeroRealParcialAtualizado is NumeroRealParcial + ((Algarismo * (2^PesoAlgarismo))*Granularidade),
	PesoAlgarismoAtualizado is PesoAlgarismo - 1,
	conv_binario_para_real(Granularidade,PesoAlgarismoAtualizado,NumeroBinario,NumeroRealParcialAtualizado,NumeroReal).