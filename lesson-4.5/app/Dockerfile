FROM node:14
# Задаем текщую дирректорию в образе, относительно нее будет происходить выполнение всех команд
WORKDIR /app
RUN npm install mongodb@3.6.2
COPY ./src ./src
EXPOSE 3000
CMD ["node", "./src/app.js"]