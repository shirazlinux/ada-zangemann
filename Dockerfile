# Ada & Zangemann static site for Paasta (neda1).
# Public HTTP is port 8080. Paasta runs the container unprivileged (uid 101).
# Context stays tiny: clone the published GitHub tree at build time so
# audio/PDF do not hit Paasta's 100 MB source limit.
FROM docker.io/library/nginx:1.28-alpine

# Bump when the GitHub tree should be rebuilt into the image.
ARG SITE_REV=18c3bcfeac4cb0f365bd58b581bcbce6b2871e7c
COPY nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache git \
 && git clone --depth 1 https://github.com/shirazlinux/ada-zangemann.git /tmp/src \
 && mkdir -p /usr/share/nginx/html \
 && for f in 404.html CNAME favicon.png index.html LICENSE robots.txt sitemap.xml; do \
      cp -a "/tmp/src/$f" /usr/share/nginx/html/; \
    done \
 && for d in about book css film fonts img order payam presentation ressources; do \
      cp -a "/tmp/src/$d" /usr/share/nginx/html/; \
    done \
 && rm -rf /tmp/src \
 && apk del git \
 && mkdir -p /tmp/nginx \
 && chown -R 101:101 /usr/share/nginx/html /tmp/nginx /var/cache/nginx /var/run \
 && chmod -R a+rX /usr/share/nginx/html \
 && echo "site $SITE_REV"

USER 101
EXPOSE 8080
ENTRYPOINT ["nginx"]
CMD ["-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
