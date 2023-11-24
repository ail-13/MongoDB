const MongoClient = require('mongodb').MongoClient;
const db_config = require('./db_config.json');

const data = [
  { name: 'Запись 1', description: 'Описание 1' },
  { name: 'Запись 2', description: 'Описание 2' },
  { name: 'Запись 3', description: 'Описание 3' }
];

setTimeout(function() {
  MongoClient.connect('mongodb://' + db_config.username + ':' + db_config.pass + '@' + db_config.url + ':' + db_config.port, { useUnifiedTopology: true }, (err, client) => {
      if (err) return console.log(err)
      else client.db('test').collection('notes').insertMany(data);
  });
}, 5000);