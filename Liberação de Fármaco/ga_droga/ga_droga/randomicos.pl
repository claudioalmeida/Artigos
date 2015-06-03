 % Author:
% Date: 03/12/06

% rotinas de suporte que criam e manipulam quantidade randómicas

%                       SUPORTE

% faz os parametros variaveis
string_randomica(Tamanho,Ac,String):-
R is random(2),
length(Ac,T),
(T<Tamanho-> string_randomica(Tamanho,[R|Ac],String);
 T=Tamanho-> String=Ac).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* converte um numero binario para um numero real dentro de um dominio delimitadso
 por inicio e fim. O numero binario corresponde a uma lista binaria
 ex bin2real(0,2,[1,1,1,1,1,1,0],REAL). */

bin2real(Inicio,Fim,Bin,Real):-
length(Bin,Casas),
converte_string_para_real(Inicio,Fim,Casas,Bin,0,Real).

% suporte para o bin2real/4
converte_string_para_real(Inicio,Fim,Casas,Ac,Termo,Real):-
length(Ac,C),
(C>0-> nth1(1,Ac,N),
       select(N,Ac,Ac1),
       Parcial is Termo+N*(2^(C-1)),
       converte_string_para_real(Inicio,Fim,Casas,Ac1,Parcial,Real);
C=0->  Real is (Inicio+Termo*(Fim-Inicio)/((2^Casas)-1)) ).
       % format('~10f~n',[Real]) ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% retorna um numero real randomico entre 0 e 1 com 32 bits

numero_real8(Real):-
string_randomica(8,[],String),
bin2real(0.0,1.0,String,Real).

numero_real16(Real):-
string_randomica(16,[],String),
bin2real(0.0,1.0,String,Real).

numero_real32(Real):-
string_randomica(32,[],String),
bin2real(0.0,1.0,String,Real).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% retorna um numero real randomico entre 0 e 1 com 64 bits

numero_real64(Real):-
string_randomica(64,[],String),
bin2real(0.0,1.0,String,Real).

