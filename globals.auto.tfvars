
# Global config which isn't secret
#
# For project config see project.tfvars
#
# For secret globals like oidc connection stuff see oidc.tfvars 

# note that az and ip_pool are different

availability_zone = "ardc-syd-1"
ip_pool = "ardc-syd"
cc_prefix = "cc-sih-multitenant"
cc_domain = "curated-collections.cloud.edu.au"
tls_admin_email = "m.lynch@sydney.edu.au"

vm_image = "NeCTAR Ubuntu 22.04 LTS (Jammy) amd64 (with Docker)"
vm_flavor = "m3.large"
volume_size = 200

# where everything will be created on the server

proxy_caddyfile = "/srv/caddy/Caddyfile"
proxy_dir = "/srv/proxy"
docker_dir = "/srv/projects"
caddy_dir = "/srv/caddy"
volume_dir = "/pvol/projects"

omeka_build_admin_email = "admin-tmp@curated-collections.edu.au"
omeka_build_site_slug = "temp-site"