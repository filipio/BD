FROM mysql:5

ENV MYSQL_DATABASE=quizDB
ENV MYSQL_ROOT_PASSWORD=secretPassword
COPY ./init_scripts/ /docker-entrypoint-initdb.d/
EXPOSE 3306