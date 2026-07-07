#cloud-config

hostname: ${hostname}

groups:
  - docker

system_info:
  default_user:
    groups: [docker]

write_files:
  - path: /home/ubuntu/omeka-s/Caddyfile
    permissions: '0644'
    owner: ubuntu:
    encoding: b64
    content: ${base64encode(caddyfile_content)}
  - path: /home/ubuntu/omeka-s/docker-compose.yml
    permissions: '0644'
    owner: ubuntu:
    encoding: b64
    content: ${base64encode(docker_compose_content)}
  - path: /home/ubuntu/omeka-s/init-db/init-db.sql
    owner: ubuntu:
    encoding: b64
    content: ${base64encode(init_db_content)}
  - path: /home/ubuntu/omeka-s/secrets/mariadb_password
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${mariadb_password}
  - path: /home/ubuntu/omeka-s/secrets/mariadb_root_password
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${mariadb_root_password}
  - path: /home/ubuntu/omeka-s/secrets/omeka_build_admin_email
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_build_admin_email}
  - path: /home/ubuntu/omeka-s/secrets/omeka_admin_email
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_admin_email}
  - path: /home/ubuntu/omeka-s/secrets/omeka_admin_user
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_admin_user}
  - path: /home/ubuntu/omeka-s/secrets/omeka_admin_password
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_admin_password}
  - path: /home/ubuntu/omeka-s/secrets/omeka_build_site_slug
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_build_site_slug}
  - path: /home/ubuntu/omeka-s/secrets/omeka_project_title
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_project_title}
  - path: /home/ubuntu/omeka-s/secrets/omeka_site_title
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_site_title}
  - path: /home/ubuntu/omeka-s/secrets/omeka_site_slug
    permissions: '0400'
    owner: ubuntu:ubuntu
    content: ${omeka_site_slug}
runcmd:
  - cd /home/ubuntu/omeka-s
  - docker compose up -d
