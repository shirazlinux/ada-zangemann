# Ada & Zangemann static site for Paasta (neda1).
# Public HTTP is port 8080. Paasta runs the container unprivileged (uid 101).
FROM docker.io/library/nginx:1.28-alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY 404.html CNAME favicon.png index.html LICENSE robots.txt sitemap.xml /usr/share/nginx/html/
COPY about /usr/share/nginx/html/about
COPY book /usr/share/nginx/html/book
COPY css /usr/share/nginx/html/css
COPY film /usr/share/nginx/html/film
COPY fonts /usr/share/nginx/html/fonts
COPY img /usr/share/nginx/html/img
COPY donate /usr/share/nginx/html/donate
COPY order /usr/share/nginx/html/order
COPY presentation /usr/share/nginx/html/presentation
COPY ressources /usr/share/nginx/html/ressources

RUN mkdir -p /tmp/nginx \
 && chown -R 101:101 /usr/share/nginx/html /tmp/nginx /var/cache/nginx /var/run \
 && chmod -R a+rX /usr/share/nginx/html

# Skip the stock entrypoint (it chowns cache dirs and needs root).
USER 101
EXPOSE 8080
ENTRYPOINT ["nginx"]
CMD ["-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
