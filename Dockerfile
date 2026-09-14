# Ada & Zangemann static site for Paasta (neda1).
# Public HTTP is port 8080.
FROM docker.io/library/nginx:1.28-alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY 404.html CNAME favicon.png index.html LICENSE robots.txt sitemap.xml /usr/share/nginx/html/
COPY about /usr/share/nginx/html/about
COPY book /usr/share/nginx/html/book
COPY css /usr/share/nginx/html/css
COPY film /usr/share/nginx/html/film
COPY fonts /usr/share/nginx/html/fonts
COPY img /usr/share/nginx/html/img
COPY order /usr/share/nginx/html/order
COPY presentation /usr/share/nginx/html/presentation
COPY ressources /usr/share/nginx/html/ressources

EXPOSE 8080
