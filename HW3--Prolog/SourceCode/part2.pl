%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%  FACTS   %%%
flight(edirne,erzurum,5).
flight(erzurum,edirne,5).

flight(erzurum,antalya,2).
flight(antalya,erzurum,2).		

flight(istanbul,izmir,3).
flight(izmir,istanbul,3).

flight(izmir,antalya,1).
flight(antalya,izmir,1).

flight(antalya,diyarbakir,5).
flight(diyarbakir,antalya,5).

flight(diyarbakir,ankara,8).
flight(ankara,diyarbakir,8).

flight(ankara,istanbul,2).
flight(istanbul,ankara,2).

flight(ankara,izmir,6).
flight(izmir,ankara,6).

flight(trabzon,ankara,6).
flight(ankara,trabzon,6).

flight(trabzon,istanbul,3).
flight(istanbul,trabzon,3).

flight(ankara,kars,3).
flight(kars,ankara,3).

flight(gaziantep,kars,3).
flight(kars,gaziantep,3).

%%%   QUERIES   %%%

% X, Y arasında bir uçuş olursa.
route(X,Y,C) :- flight(X,Y,C). 
% Vectexleri tutan bir liste.
route(X , Y , C) :- findcost(X , Y , C , []). 
% L (Vertex listesi) listesi icerisinde X (sehir) "varmı?" "yokmu?" kontrolu yapılarak flight fact'i çağrılır.
% Daha sonra recursive olarak  [X] + L ile çağırlır ve ucuş. maliyeti hesaplanır.
findcost(X , Y , C , _) :- flight(X , Y , C).
findcost(X , Y , C , L) :- \+ member(X , L), flight(X , Z , A), 					
							findcost(Z , Y , B , [X|L]), X\=Y, C is A + B.		