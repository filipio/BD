FROM mysql:8

ENV MYSQL_DATABASE=quizDB
ENV MYSQL_ROOT_PASSWORD=secretPassword
COPY ./init_scripts/*.sql /docker-entrypoint-initdb.d/