FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/
COPY team.html /usr/share/nginx/html/
COPY news.html /usr/share/nginx/html/
COPY robots.txt /usr/share/nginx/html/

COPY css/ /usr/share/nginx/html/css/
COPY images/ /usr/share/nginx/html/images/
COPY archive/ /usr/share/nginx/html/archive/
COPY internal-preview/ /usr/share/nginx/html/internal-preview/

EXPOSE 80
