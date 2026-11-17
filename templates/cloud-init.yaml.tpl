#cloud-config

hostname: ${hostname}

groups:
  - docker

system_info:
  default_user:
    groups: [docker]

write_files:
  - path: /srv/caddy/Caddyfile
    encoding: b64
    content: "${base64encode(caddyfile_content)}"
  - path: /srv/proxy/docker-compose.yml
    encoding: b64
    content: "${base64encode(compose_content)}"

runcmd:
  - [ cd, /srv/proxy ]
  - [ docker, compose, up, -d ]
