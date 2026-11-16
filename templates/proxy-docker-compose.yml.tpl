name: infra

services:
  caddy:
    image: caddy:2.8
    container_name: caddy
    restart: unless-stopped
    ports: ["80:80", "443:443", "443:443/udp"]
    volumes:
      - /srv/caddy:/etc/caddy:ro
      - caddy_data:/data
      - caddy_config:/config
    networks: [proxy]

networks:
  proxy:
    name: proxy

volumes:
  caddy_data:
  caddy_config: