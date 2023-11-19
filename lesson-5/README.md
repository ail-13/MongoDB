# Запросы к MongoDB

## Описание
1. Для выполнения запросов будем использовать базу данных созданную на виртуальном сервере GCP из lesson-4
1. Для подключения к базе данных будем использовать Studio 3T Free
1. В Studio 3T Free создаем новый Connect и указываем URI

        mongodb://root:mongo123@x.x.x.x:27001

1. В lesson-4 была создана база данных `test` с единсвенной коллекцией `notes`, все запросы будут выполняться к этой коллекции

## Запросы
### Создание
Создаем в коллекции 10 документов
```
db.getCollection("notes").insert([
    {title:"RuPaul Is: Starbooty!",year:1987,cast:[""],genres:["Comedy"]},
    {title:"The Running Man",year:1987,cast:["Arnold Schwarzenegger","Richard Dawson","María Conchita Alonso"],genres:["Science Fiction"]},
    {title:"Russkies",year:1987,cast:["Joaquin Phoenix","Peter Billingsley"],genres:["Comedy"]},
    {title:"Salvation!",year:1987,cast:["Viggo Mortensen","Exene Cervenka"],genres:["Comedy"]},
    {title:"September",year:1987,cast:["Mia Farrow","Sam Waterston","Dianne Wiest","Elaine Stritch"],genres:["Drama"]},
    {title:"K-9",year:1989,cast:["James Belushi","Mel Harris"],genres:["Comedy"]},
    {title:"Kamillions",year:1989,cast:[],genres:["Drama"]},
    {title:"The Karate Kid, Part III",year:1989,cast:["Ralph Macchio","Pat Morita","Thomas Ian Griffith"],genres:["Action"]},
    {title:"Kickboxer",year:1989,cast:["Jean-Claude Van Damme"],genres:["Action"]},
    {title:"Son in Law",year:1993,cast:["Pauly Shore","Carla Gugino","Lane Smith"],genres:["Comedy"]}
]);
```
### Поиск
Находим все документы у которых поле `year` больше либо равно 1990
```
db.getCollection("notes").find({
    year: {
        $gte: 1990
    }
});
```
### Обнолвение
Добавляем поле `rating: 5` во все документы у которых массив `genres` содержит значение `Action`
```
db.getCollection("notes").updateMany({
    genres: "Action"
}, {
    $set: {
        rating: 5
    }
});
```
### Удаление
Удаляем все документы у которых массив `genres` содержит значение `Drama`
```
db.getCollection("notes").deleteMany({
    genres: "Drama"
});
```