FROM node:14
# WORKDIR /tmp/client
RUN npm install mongodb@3.6.2
COPY app.js ./
CMD ["node", "./app.js"]