const MongoClient = require('mongodb').MongoClient;

const data = [
  { name: 'Запись 1', description: 'Описание 1' },
  { name: 'Запись 2', description: 'Описание 2' },
  { name: 'Запись 3', description: 'Описание 3' }
];

setTimeout(function() {
  MongoClient.connect( 'mongodb://' + process.env.db_username + ':' + process.env.db_pass + '@' + process.env.db_url + ':' + process.env.db_port, { useUnifiedTopology: true }, (err, client) => {
      if (err) return console.log(err)
      else client.db('test').collection('notes').insertMany(data);
  });
}, 5000);