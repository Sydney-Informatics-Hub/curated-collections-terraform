
# Global config which isn't secret
#
# For project config see project.tfvars
#
# For secret globals like oidc connection stuff see oidc.tfvars 


cc_prefix = "cc-sih-multitenant"
cc_domain = "curated-collections.cloud.edu.au"
tls_admin_email = "m.lynch@sydney.edu.au"

vm_image = "NeCTAR Ubuntu 22.04 LTS (Jammy) amd64 (with Docker)"
vm_flavor = "m3.large"

omeka_build_admin_email = "admin-tmp@curated-collections.edu.au"
omeka_build_site_slug = "temp-site"