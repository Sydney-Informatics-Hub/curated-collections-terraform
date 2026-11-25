name: ${project}

services:

  omeka-s-app:
    image: "${omeka_s_image}"
    depends_on:
      omeka-s-db:
        condition: service_healthy
    volumes:
      - omeka-s-app:/var/www/html
      - ./cc-omeka.ini:/usr/local/etc/php/conf.d/cc-omeka.ini:ro
      - /${volume_dir}/${project}/files:/var/www/html/public/files
    secrets:
      - mariadb_password
      - omeka_admin_user
      - omeka_admin_email
      - omeka_admin_password
      - omeka_build_admin_email
      - omeka_project_title
      - omeka_site_title
      - omeka_site_slug
      - omeka_build_site_slug
      - oidc_config
    environment:
      MARIADB_DATABASE: omekas
      MARIADB_USER: omekas
      MARIADB_HOST: omeka-s-db
      MARIADB_PORT: 3306
    networks:
      proxy:
        aliases:
          - ${project}-omeka
      backend: {}
    command: /docker-entrypoint.sh
    restart: unless-stopped

  omeka-s-db:
    image: "${mariadb_image}"
    volumes:
      - omeka-s-db:/var/lib/mysql
    secrets:
      - mariadb_password
      - mariadb_root_password
    environment:
      MARIADB_DATABASE: omekas
      MARIADB_USER: omekas
      MARIADB_PASSWORD_FILE: /run/secrets/mariadb_password
      MARIADB_ROOT_PASSWORD_FILE: /run/secrets/mariadb_root_password
    networks:
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 5s
      retries: 10

networks:
  proxy:
     external: true
  backend:
     internal: true

volumes:
  omeka-s-db:
  omeka-s-app:
  caddy-data:
  caddy-config:

secrets:
  mariadb_password:
    file: secrets/mariadb_password.txt
  mariadb_root_password:
    file: secrets/mariadb_root_password.txt
  omeka_admin_user:
    file: secrets/omeka_admin_user.txt
  omeka_admin_email:
    file: secrets/omeka_admin_email.txt
  omeka_admin_password:
    file: secrets/omeka_admin_password.txt
  omeka_project_title:
    file: secrets/omeka_project_title.txt
  omeka_build_admin_email:
    file: secrets/omeka_build_admin_email.txt
  omeka_site_title:
    file: secrets/omeka_site_title.txt
  omeka_site_slug:
    file: secrets/omeka_site_slug.txt
  omeka_build_site_slug:
    file: secrets/omeka_build_site_slug.txt
  oidc_config:
    file: secrets/oidc_config.json
