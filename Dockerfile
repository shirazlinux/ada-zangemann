# Ada & Zangemann static site for Paasta (neda1).
# Public HTTP is port 8080. Paasta runs the container unprivileged (uid 101).
# Context stays tiny: fetch the published GitHub tree at build time so
# audio/PDF do not hit Paasta's 100 MB source limit.
FROM docker.io/library/nginx:1.28-alpine

# Bump when the GitHub tree should be rebuilt into the image.
ARG SITE_REV=18c3bcfeac4cb0f365bd58b581bcbce6b2871e7c
COPY nginx.conf /etc/nginx/nginx.conf

RUN set -eux; \
    wget -O /tmp/src.tgz "https://github.com/shirazlinux/ada-zangemann/archive/${SITE_REV}.tar.gz"; \
    mkdir -p /tmp/src /usr/share/nginx/html; \
    tar -xzf /tmp/src.tgz -C /tmp/src --strip-components=1; \
    cp -a /tmp/src/404.html /tmp/src/CNAME /tmp/src/favicon.png /tmp/src/index.html /tmp/src/LICENSE /tmp/src/robots.txt /tmp/src/sitemap.xml /usr/share/nginx/html/; \
    cp -a /tmp/src/about /tmp/src/book /tmp/src/css /tmp/src/film /tmp/src/fonts /tmp/src/img /tmp/src/order /tmp/src/payam /tmp/src/presentation /tmp/src/ressources /usr/share/nginx/html/; \
    rm -rf /tmp/src /tmp/src.tgz; \
    mkdir -p /tmp/nginx; \
    chown -R 101:101 /usr/share/nginx/html /tmp/nginx /var/cache/nginx /var/run; \
    chmod -R a+rX /usr/share/nginx/html

USER 101
EXPOSE 8080
ENTRYPOINT ["nginx"]
CMD ["-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
