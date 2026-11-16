# Global config variables 

variable "cc_domain" {
	description = "The base domain for curated collections"
	type = string
	default = "curated-collections.cloud.edu.au"
}

variable "cc_prefix" {
	 description = "Used as a namespace for the network, subnet and compute instance"
	 type = string
}

variable "tls_admin_email" {
	description = "The admin email for TLS"
	type = string
} 

variable "oidc_idp_discovery_url" {
	description = "OIDC IDP discovery url"
	type = string
}

variable "oidc_client_id" {
	description = "OIDC client ID"
	type = string
}

variable "oidc_client_secret" {
	description = "OIDC client secret"
	type = string
	sensitive = true
}

variable "openstack_user" {
	description = "The openstack user (this is the email you use to log in to Nectar)"
	type = string
}

variable "openstack_password" {
	description = "The openstack password - this is set up in the Nectar dashboard, it is not your institutional password"
	type = string
	sensitive = true
}

variable "ssh_private_key_path" {
	description = "Path to the ssh key for the server"
	type =  string
}

variable "nectar_project_id" {
	description = "The Nectar project id"
	type = string
}

variable "nectar_project_name" {
	description = "The Nectar project name"
	type = string
}

variable "omeka_build_admin_email" {
	description = "The inital value of the Omeka build image admin email"
	type = string
	default = "admin-tmp@curated-collections.edu.au"
}

variable "omeka_build_site_slug" {
	description = "The inital value of the Omeka site slug"
	type = string
	default = "temp-site"
}

variable "projects" {
  description = "Omeka S instances hosted on the shared VM, keyed by short project slug"
  type = map(object({
	hostname    = string
	omeka_s_image = string
	mariadb_image = string
	state       = optional(string, "running")    # running | stopped

	owner_email = string
	owner_name  = string

	oidc_group =  string
	oidc_roles_map = map(string)
	oidc_hide_local_login = optional(bool, true)

	omeka_admin_email=string
	omeka_admin_user=optional(string, "Admin")
	omeka_project_title=optional(string, "Omeka S Project")
	omeka_site_title=optional(string, "Site")
	omeka_site_slug=optional(string, "site")

	# Runtime sizing
	mem_limit              = optional(string, "768m")
	cpus                   = optional(number, 1.0)
	php_memory_limit       = optional(string, "512M")
	upload_max_filesize    = optional(string, "120M")
	post_max_size          = optional(string, "120M")

	# Extra hostnames that should redirect to the canonical one
	aliases = optional(list(string), [])
  }))

  validation {
	condition     = alltrue([for k, _ in var.projects : can(regex("^[a-z][a-z0-9-]{1,30}$", k))])
	error_message = "Project keys must be lowercase slugs (letters, digits, hyphens), 2-31 chars, used as DB/container names."
  }

  validation {
	condition     = alltrue([for _, p in var.projects : contains(["running", "stopped"], p.state)])
	error_message = "state must be \"running\" or \"stopped\"."
  }

  validation {
	condition     = alltrue([for _, p in var.projects : !endswith(p.omeka_s_image, ":latest")])
	error_message = "Pin image versions; :latest is not allowed."
  }

  validation {
	condition     = alltrue([for _, p in var.projects : !endswith(p.mariadb_image, ":latest")])
	error_message = "Pin image versions; :latest is not allowed."
  }

  validation {
	condition     = length(distinct([for _, p in var.projects : p.hostname])) == length(var.projects)
	error_message = "Each project needs a unique hostname."
  }
}


