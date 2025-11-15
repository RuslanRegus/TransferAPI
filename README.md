# TransferAPI





lansezi docker

in mapa cu proiect lansezi prin consola \[docker compose up --build]

se va crea containerul transferapi cu subcontainere:

transferapi\_app – .NET API (port 5000 → 8080)

transferapi\_postgres – PostgreSQL db (port 5432 → 5432)





accesezi http://localhost:5000/swagger/index.html



in /api/transfer -> try it out :

cand folosesti api trebuie sa pui expeditorul \[from\_account\_id] , receptorul \[to\_account\_id], suma amount, un string (guid) idempotency\_key.



Validari de la server:

&nbsp;	sa difere \[idempotency\_key] fiecare data pentru a Evita dublicari, in baza de date este \[idempotency\_key] cu valoarea \[string] si la default va returna tranzactia care e salvata in baza de date caci idempotency\_key : "string" deja exista. 

&nbsp;	sa existe expeditorul \[from\_account\_id],

&nbsp;	sa existe receptorul \[to\_account\_id],

&nbsp;	sa nu fie egal expeditorul si receptorul,

&nbsp;	sa fie suma mai mare ca 0. Se accepta 2 cifre dupa virgula



exemplu de valori 

{

&nbsp; "from\_account\_id": 1,

&nbsp; "to\_account\_id": 2,

&nbsp; "amount": 10.5,

&nbsp; "idempotency\_key": "dokertest2"

}





ca sa vezi datele din baza de date. lansezi doker. Click pe containerul transferapi\_postgres. Click pe Exec si scrii comenzile :

psql -U postgres -d mydb



SELECT \* FROM test."Accounts";



SELECT \* FROM test."Transactions";



datele din baza de date la moment



 id | user\_name |      balance

----+-----------+--------------------

  3 | Igor      |                280

  1 | Ruslan    | 102.16999999999999

  2 | Ion       | 138.07999999999998



Transactions

 id | from\_account\_id | to\_account\_id | amount |           timestamp           | idempotency\_key

----+-----------------+---------------+--------+-------------------------------+-----------------

  1 |               1 |             2 |     10 | 2025-11-14 21:36:43.89654+00  | string

  2 |               1 |             2 |    100 | 2025-11-14 21:37:21.937081+00 | dokertest







