
# Sample file for non-secret variables about this Omeka project.


variable "cc_project_id" {
    description = "A unique ID for the omeka project, which is used to build the site's hostname"
    default = "example"
    type = string
}

variable "cilogon_group" {
    description = "The name of the CILogon group whose membership defines who gets to log in to this project"
    default = "example"
    type = string
}

variable "omeka_admin_email" {
    description = "Email address for the local admin account"
    default = "example@curated-collections.cloud.edu.au"
    type = string
}

variable "omeka_admin_user" {
    description = "User name for the local admin account"
    default = "Local Admin"
    type = string
}

variable "omeka_project_title" {
    description = "The title for the Omeka instance"
    default = "Project Title"
    type = string
}

variable "omeka_site_title" {
    description = "The title for the Omeka instance's public site`"
    default = "Site"
    type = string
}

variable "omeka_site_slug" {
    description = "The url path (slug) for the public site"
    default = "site"
    type = string
}


