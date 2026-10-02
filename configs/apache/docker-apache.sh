#!/bin/sh    

docker build -t plac-apache:latest .
docker run --name plac-apache -p 80:80 -v "$(pwd)/www:/var/www/html" plac-apache:latest
