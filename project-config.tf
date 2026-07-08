
# Local variables which should be configured for the project you're
# spinning up
#
# cc_project_id - a unique string identifying this Omeka S in Curated
#                 Collections. Used as the hostname in URLs, ie
#                 project.curated-collections.cloud.edu.au
# omeka_admin_email   - an email address for the local admin account
# omeka_admin_user    - user name for the local admin account
# omeka_project_title - the project title
# omeka_site_title    - the title of the default public site
# omeka_site_slug     - the slug (URL path) of the default public site
#
# Note that the admin account defined by this Terraform is a local
# account which Omeka S requires - the actual users will log in via
# SSO

locals {
    cc_project_id = "testbed"
    omeka_admin_email = "actual_admin_email@institution.org"
    omeka_admin_user = "Admin User"
    omeka_project_title = "Omeka Project"
    omeka_site_title = "Site"
    omeka_site_slug = "site"
}

