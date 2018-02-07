#!/bin/bash

# Build config
cat <<EOF > $NGINX_CONF
daemon              off;
worker_processes    1;
user                root;

events {
  worker_connections $WORKER_CONNECTIONS;
}

http {
  include       mime.types;
  default_type  application/octet-stream;

  keepalive_timeout  15;
  autoindex          off;
  server_tokens      off;
  port_in_redirect   off;
  sendfile           off;
  tcp_nopush         on;
  tcp_nodelay        on;

  client_max_body_size 64k;
  client_header_buffer_size 16k;
  large_client_header_buffers 4 16k;

  ## Cache open FD
  open_file_cache max=10000 inactive=3600s;
  open_file_cache_valid 7200s;
  open_file_cache_min_uses 2;

  ## Gzipping is an easy way to reduce page weight
  gzip                on;
  gzip_vary           on;
  gzip_proxied        any;
  gzip_types          $GZIP_TYPES;
  gzip_buffers        16 8k;
  gzip_comp_level     $GZIP_LEVEL;

  access_log         /dev/stdout;

  server {
    listen $HTTP_PORT;
    root $PUBLIC_PATH;

    index index.html index.htm;
    autoindex off;
    charset $CHARSET;
    etag on;

    location ~* \.($CACHE_IGNORE)$ {
      add_header 'Access-Control-Allow-Origin' '$CORS_ALLOW_ORIGIN';
      add_header 'Access-Control-Allow-Methods' '$CORS_ALLOW_METHODS';
      add_header 'Access-Control-Allow-Headers' '$CORS_ALLOW_HEADERS';

      add_header Cache-Control "no-store";
      expires    off;
    }

    location ~* \.($CACHE_PUBLIC)$ {
      add_header 'Access-Control-Allow-Origin' '$CORS_ALLOW_ORIGIN';
      add_header 'Access-Control-Allow-Methods' '$CORS_ALLOW_METHODS';
      add_header 'Access-Control-Allow-Headers' '$CORS_ALLOW_HEADERS';

      add_header Cache-Control "public";
      expires +$CACHE_PUBLIC_EXPIRATION;
    }

    location ~* {
      add_header 'Access-Control-Allow-Origin' '$CORS_ALLOW_ORIGIN';
      add_header 'Access-Control-Allow-Methods' '$CORS_ALLOW_METHODS';
      add_header 'Access-Control-Allow-Headers' '$CORS_ALLOW_HEADERS';

      # Tell client that this pre-flight info is valid for 20 days
      if (\$request_method = 'OPTIONS') {
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        return 204;
      }
    }

    try_files $TRY_FILES;
  }
}

EOF

[ "" != "$DEBUG" ] && cat $NGINX_CONF

chown -R root:root /var/lib/nginx
mkdir -p /run/nginx/

exec nginx -c $NGINX_CONF
