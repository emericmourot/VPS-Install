server {
    listen 80;
    server_name vps4.lespetitsentrepreneurs.com 164.132.195.122;
    return 301 $scheme://lespetitsentrepreneurs.com$request_uri;
}