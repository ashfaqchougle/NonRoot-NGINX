FROM nginx:alpine

RUN apk --update add bash wget dpkg-dev libcap curl

COPY nginx.conf /etc/nginx/nginx.conf
COPY dist /usr/share/nginx/html

RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx \
     && rm /etc/nginx/conf.d/default.conf

RUN adduser -D -S -g '' testuser  -s /bin/bash 

RUN chown -R testuser /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx

RUN  setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx

#RUN --cap-add SYS_ADMIN

#RUN --cap-add NET_BIND_SERVICE

EXPOSE 80

CMD ["nginx"]