#cloud-config

hostname: ${hostname}

groups:
  - docker

system_info:
  default_user:
    groups: [docker]

write_files:
  - path: /home/ubuntu/omeka-s/Caddyfile
    encoding: b64
    content: "${base64encode(caddyfile_content)}"

runcmd:
  - [ cd, /home/ubuntu/omeka-s ]
  - [ docker, compose, up, -d ]
