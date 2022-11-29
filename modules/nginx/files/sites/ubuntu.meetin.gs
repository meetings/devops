server {
    listen      80;
    listen      443 ssl;
    server_name ubuntu.meetin.gs;

    ssl_certificate     /etc/ssl/private/meetings.pem;
    ssl_certificate_key /etc/ssl/private/meetings.pem;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://legacy_media_pool/ubuntu/$request_uri;
    }
}
