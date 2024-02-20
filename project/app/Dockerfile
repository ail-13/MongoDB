FROM node:16
WORKDIR /app
RUN npm install mongodb@3.6.2 casual
COPY ./src ./src
EXPOSE 3000
CMD ["node", "./src/app.js"]