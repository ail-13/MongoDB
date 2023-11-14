# CAP теорема

**MongoDB относится к системе CP.**

1. **Сonsistency**. Т.к. в MongoDB запись происходит только через мастера, это обеспечивает согласованность данных на всех репликах.
https://www.mongodb.com/docs/manual/replication/#replication-in-mongodb

1. **Availability**. MongoDB не отвечает требованию доступности, т.к. запись происходит только через мастера, а в случае его недоступности потребуется время на выбор нового мастера. Во время выбора база будет недоступна.
https://www.mongodb.com/docs/manual/replication/#automatic-failover

1. **Partition tolerance**. В случае сбоя в репликах или связи между репликами, будет выбран новый мастер и работа всей системы будет продолжена.
https://www.mongodb.com/docs/manual/replication/#asynchronous-replication