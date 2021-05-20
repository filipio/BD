# Aplikacja do nauki
Aplikacja webowa służąca do nauki poprzez wypełnianie testów 

Celem projektu jest zapoznanie się z mechanizmem komunikacji z bazą danych z poziomu kodu aplikacji.
Projekt powiązany z przedmiotem "Bazy Danych", tworzony przez studentów AGH, WIEiT, Informatyka, rok II

Zespół: Filip Juza, Bartosz Włodarski, Karol Zając
Wykorzystywane technologie : 
MySQL - silnik bazodanowy
ExpressJS - tworzenie REST API, kontakt z bazą
Angular - Frontend + moduł httpClient do obsługiwania http-request'ów



Użytkownicy mogą dołączać do klas za pomocą specjalnego kodu, który jest udostępniony w danej klasie. Klasa ma swojego ownera, który uruchamia quizy rankingowe, w których mogą(ale nie muszą ) wziąć udział członkowie klasy. Quiz jest dostępny w danym przedziale czasowym. Quizy rankingowe udostępniane są na tablicy danej klasy w formie postów. 
Użytkownicy mogą tworzyć pytania.
Tworzenie pytania:
Wpisanie question
stworzenie zestawu odpowiedzi z określeniem czy są one poprawne czy nie(bazowo 1 poprawna odpowiedź)
ewentualnie określenie trudności/zaawansowania pytania
Użytkownik może swoje pytania dołączać do danych kategorii w wybranych klasach. 
Użytkownik może uruchomić indywidualny quiz z danej kategorii w celu treningu/utrwalenia (quiz jest z danej klasy, użytkownik ustala kategorie pytań), nie zapisuje się w historii( tabela Post). 

Każdy użytkownik może wrzucać posty(tekstowe) na klasę.

Tworzenie quizu:
Dla każdego rodzaju quizu wybierana jest ilość czasu na każde pytanie ( zwykły / rankingowy ) 

Wybór kategorii, z którego wybierane są pytania ( zwykły / rankingowy ) 

Dodanie nazwy quizu ( rankingowy )

StartDate oraz EndDate (rankingowy)

Uczestnicy quizów rankingowych są dodawani do Quiz Participants, wraz z zdobytym wynikiem.
Highscore dla pojedynczych quizów i w obrębie klasy. 

Dotychczas zrealizowana część aplikacji : 
Logowanie/Rejestracja użytkownika 
Dołączanie do klasy za pomocą kodu 
Tworzenie pytań, podgląd do stworzonych pytań 
Tworzenie quizu 
Dołączanie pytań do wybranej kategorii 
Udział w quizie 
