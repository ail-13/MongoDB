const MongoClient = require('mongodb').MongoClient;
const casual = require('casual');

let numberOfUsers = 10000;

for (let i = 0; i < 10; i++) {
  setTimeout(function () {
    MongoClient.connect(process.env.db_url, { useUnifiedTopology: true, connectTimeoutMS: 30000 }, (err, client) => {
      if (err) return console.log(err)
      else {
        let users = [];

        for (let i = 0; i < numberOfUsers; i++) {
          users.push({
            first_name: casual.first_name,
            last_name: casual.last_name,
            email: casual.email,
            phone: casual.phone,
            city: casual.city,
            address: casual.address,
            description: casual.description,
            ip: casual.ip,
            user_agent: casual.user_agent
          });
        }
        
        client.db('test').collection('users').insertMany(users, (err) => {
          if (err) return console.log(err)
          else console.log((i + 1) + '. ' + numberOfUsers + ' пользователей сгенерировано и добавлено в базу данных.');
        });
      }
    });
  }, 2000 * i);
}