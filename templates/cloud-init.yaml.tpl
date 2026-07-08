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
  - path: /home/ubuntu/omeka-s/docker-compose.yml
    encoding: b64
    content: "${base64encode(docker_compose_content)}"
  - path: /home/ubuntu/omeka-s/secrets/mariadb_password.txt
    content: "${mariadb_password}"
  - path: /home/ubuntu/omeka-s/secrets/mariadb_root_password.txt
    content: "${mariadb_root_password}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_build_admin_email.txt
    content: "${omeka_build_admin_email}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_admin_email.txt
    content: "${omeka_admin_email}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_admin_user.txt
    content: "${omeka_admin_user}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_admin_password.txt
    content: "${omeka_admin_password}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_build_site_slug.txt
    content: "${omeka_build_site_slug}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_project_title.txt
    content: "${omeka_project_title}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_site_title.txt
    content: "${omeka_site_title}"
  - path: /home/ubuntu/omeka-s/secrets/omeka_site_slug.txt
    content: "${omeka_site_slug}"
