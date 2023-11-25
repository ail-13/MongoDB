# Агрегация MongoDB

## Описание
1. Для выполнения запросов будем использовать базу данных созданную на виртуальном сервере GCP из lesson-4
1. Для подключения к базе данных будем использовать Studio 3T Free
1. В Studio 3T Free создаем новый Connect и указываем URI

        mongodb://root:mongo123@x.x.x.x:27001

1. Скачиваем какой-нибудь dataset

        https://www.kaggle.com/datasets

## Запросы
### Агрегация
Выберем все фильмы с жанром `Comedy` и сгруппируем их по рейтингу
```
db.getCollection("movie").aggregate([
    {
        $match: {
            genre: "Comedy"
        }
    },
    {
        $group: {
            _id: "$rating",
            count: {
                $sum: 1
            }
        }
    }
]);

// Полученный результат
{
    "_id" : "7.4",
    "count" : 6.0
},
{
    "_id" : "7.8",
    "count" : 14.0
},
{
    "_id" : "8.2",
    "count" : 11.0
},
{
    "_id" : "4.4",
    "count" : 1.0
},
{
    "_id" : "5.8",
    "count" : 16.0
},
...
{
    "_id" : "5.6",
    "count" : 12.0
}

```
### Анализ запроса
Выполним команду `explain()` для данного запроса. В обьекте `executionStats` видно что из базы было считано 1572 документа для получения результата запроса
```
...
"executionStats" : {
    "executionSuccess" : true,
    "nReturned" : 525.0,
    "executionTimeMillis" : 14.0,
    "totalKeysExamined" : 0.0,
    "totalDocsExamined" : 1572.0,
    ...
```
### Добавление индекса
Для оптимизации выполнения этого запроса можно добавить индекс
```
db.getCollection("movie").createIndex({"genre" : 1, "rating" : 1});
```
### Повторный анализ запроса
Еще раз выполним команду `explain()` для данного запроса. Теперь в обьекте `executionStats` видно что документы из базы вообще не считывались, а запрос был выполнен с использованием только данных из индекса
```
...
"executionStats" : {
    "executionSuccess" : true,
    "nReturned" : 525.0,
    "executionTimeMillis" : 1.0,
    "totalKeysExamined" : 525.0,
    "totalDocsExamined" : 0.0,
    ...
```