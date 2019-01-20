%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%  FACTS   %%%
% Tum veriler gönderilen data.xls dosyasına göre düzenlenmiştir.

%%%ROOM
%%id,capacity,equipment
room(z06,10,[hcapped,projector,null]).
room(z11,10,[hcapped,smartboard,null]).

%%OCCUPANCY
%%id,hour,course
occupancy(z06,8,cse341).
occupancy(z06,9,cse341).
occupancy(z06,10,cse341).
occupancy(z06,11,cse341).
occupancy(z06,12,null).
occupancy(z06,13,cse331).
occupancy(z06,14,cse331).
occupancy(z06,15,cse331).
occupancy(z06,16,null).
occupancy(z11,8,cse343).
occupancy(z11,9,cse343).
occupancy(z11,10,cse343).
occupancy(z11,11,cse343).
occupancy(z11,12,null).
occupancy(z11,13,null).
occupancy(z11,14,cse321).
occupancy(z11,15,cse321).
occupancy(z11,16,cse321).

%%COURSE
%%id,instructor,capacity,hour,room,needs
course(cse341,genc,10,4,z06,projector).
course(cse343,turker,6,3,z11,smartboard).
course(cse331,bayrakci,5,3,z06,null).
course(cse321,gozupek,10,4,z11,smartboard).

%%INSTRUCTOR
%%id,courses,needs.
instructor(genc,cse341,projector).
instructor(turker,cse343,smartboard).
instructor(bayrakci,cse331,null).
instructor(gozupek,cse321,smartboard).

%%STUDENT
%sid,listOfCourses,handicapped.
student(1,[cse341,cse343,cse331],null).
student(2,[cse341,cse343],null).
student(3,[cse341,cse331],null).
student(4,[cse341],no).
student(5,[cse343,cse331],null).
student(6,[cse341,cse343,cse331],hcapped).
student(7,[cse341,cse343],null).
student(8,[cse341,cse331],hcapped).
student(9,[cse341],null).
student(10,[cse341,cse321],null).
student(11,[cse341,cse321],null).
student(12,[cse343,cse321],null).
student(13,[cse343,cse321],null).
student(14,[cse343,cse321],null).
student(15,[cse343,cse321],hcapped).

%%%  QUERIES   %%%

%%CONFLICTS
% Check whether there is any scheduling conflict. --> conflicts(CourseID1,CourseID2) -> true | false
% 2 ders arasında zaman yönünden çakışma olup olmadığına bakar. Ders çakışması varsa "true", yoksa "false".
% conflicts(cse341, cse331).    ->  false
% conflicts(cse341, cse341).    ->  true
conflicts(X,Y) :- 
    course(X,_,_,T1,A,_), %A -> roomid
    course(Y,_,_,_,B,_), %B -> roomid
    A == B,
    occupancy(A,C,X), %C -> hour  , E -> course
    occupancy(B,D,Y), %D -> hour  , F -> course
    Q is T1 + C,!,    %Q -> Dersin başlama saati + Dersin kaç saat sürdüğü
    ((C =< D), (D < Q)). % İlk dersin başlangıç ve bitiş saati arasında ikinci dersin başlangıç saati mevcut mu?


%%ASSIGN
% Check which room can be assigned to a given class. --> assign(RoomID,CourseID) -> true | false
% Check which room can be assigned to which classes. --> assign(RoomID,Y) -> Y = CourseID ; Y = CourseID ...
% Belirli bir sınıfa hangi odanın atanabileceğini kontrol eder. Atama işlemi mevcutsa "true", değilse "false" verir.
% Hangi odaya hangi sınıfların atanabildiğini belirler ve "Y" parametresinde sırayla gösterir.
% assign(z06, cse341). -> true
% assign(RoomID,Y) -> Y = cse341; Y = cse331.
assign(X,Y):- room(X,Rk,Nr), % 
    course(Y,_,Ck,H,X,Nc),   % 
    occupancy(X,Hl,Y),       % 
    Ck =< Rk, member(Nc,Nr), % 
    Q is H + Hl -1,          % 
    occupancy(X,Q,Y).        % 

%%ENROLL
% Check whether a student can be enrolled to a given class. --> enroll(StudentID,CourseID) -> true | false
% Check which classes a student can be assigned. --> enroll(StudentID,Y) -> Y = CourseID ; Y = CourseID ...
% Bir öğrencinin belirli bir sınıfa kayıtlı olup olmadığının kontrulunun yapıldığı kısımdır. Eğer öğrenci derse kayıtlıs ise "true", değilse "false" verir.
% Bir öğrencinin hangi sınıflara atanabileceğini belirler ve "Y" parametresinde sırayla gösterir. 
% enroll(1, cse341). -> false
% enroll(1, Y). -> Y = cse321.
enroll(X,Y):- student(X,L,Ns),
    course(Y,_,_,_,R,_),
    room(R,_,Nr),
    \+member(Y,L),member(Ns,Nr).



%%ADDROOM
% Room eklenirken C parametresi kesinlikle bir liste([]) olmalıdır.
% Ayrıca bu listenin içerisinde null diye bir veri tutulmalıdır.
% Bazı verilerin değeri mevcut olmadığı için null ile kontrol yapılmaktadır.
% Room eklemek istediğimizde aynı id ye sahip bir room eklenmemektedir.
% addRoom(z01,5,[null]). -> true
addRoom(A,B,C) :- \+room(A,_,_),assert(room(A,B,C)).

%%ADDCOURSE
% Course eklenirken Course id ve Room id önemlidir.
% Eğer aynı Course id ye sahip bir ders eklemeye çalışırsak eklenmemektedir.
% Ayrıca Room id de önemlidir. Çünkü Room fact'in de id si aynı olmayan bir Room id yi baz alırsak eklenmemektedir.
% addCourse(cse102,mahmut,5,3,z06,smartboard). -> true
% addCourse(cse341,hakki,10,4,z06,projector). -> false
addCourse(A,B,C,D,E,F) :- \+course(A,_,_,_,_,_),room(E,_,_),assert(course(A,B,C,D,E,F)).

%%ADDSTUDENT
% Bir öğrenci ekleyeceğimiz zaman öğrenci bilgisi önceden girilmiş ise id numarasında kontrol edilip bakılır.
% Eğer bu öğrenci mevcut ise eklenmez.
% Öğrenci eklenirken "Y" parametresine bir liste([]) şeklinde dersler verilmelidir.
% Liste içeriinde yer alan dersler fact olarak eklenen Course olarak eklenmediyse eğer öğrenci eklenmez.
% addStudent(71,[cse341],null). -> true
% addStudent(1,[cse321],hcapped). -> false

%%HELPER RECURSIVE QUERY
% Aynı id ye sahip bir başka kişiyi eklememek için kontrol yapılır.
% Öğrenci eklenirken fact olarak belirli ders yoksa bu dersi alamaz.
recursive(K):- course(K,_,_,_,_,_).
ismember([]).
ismember([K|L]) :- recursive(K), ismember(L).
addStudent(X,Y,Z):- \+student(X,_,_),ismember(Y),assert(student(X,Y,Z)).

