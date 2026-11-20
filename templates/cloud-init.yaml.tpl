#cloud-config

hostname: ${hostname}

groups:
  - docker

system_info:
  default_user:
    groups: [docker]

write_files:
  - path: ${proxy_caddyfile}
    encoding: b64
    content: "${base64encode(proxy_caddyfile_content)}"
  - path: ${proxy_docker}
    encoding: b64
    content: "${base64encode(proxy_docker_content)}"

runcmd:
  - [ cd, /srv/proxy ]
  - [ docker, compose, up, -d ]
