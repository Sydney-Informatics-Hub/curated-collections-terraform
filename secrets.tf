
resource "random_password" "mariadb_password" {
  length   = 12
  special  = true
  upper    = true
  lower    = true
  numeric  = true
}


resource "random_password" "mariadb_root_password" {
  length   = 12
  special  = true
  upper    = true
  lower    = true
  numeric  = true
}


resource "random_password" "omeka_admin_password" {
  length   = 12
  special  = true
  upper    = true
  lower    = true
  numeric  = true
}

output "mariadb_password" {
  value       = random_password.mariadb_password.result
  sensitive   = true
  description = "Omeka S admin password"
}


output "mariadb_root_password" {
  value       = random_password.mariadb_root_password.result
  sensitive   = true
  description = "Omeka S admin password"
}


output "omeka_admin_password" {
  value       = random_password.omeka_admin_password.result
  sensitive   = true
  description = "Omeka S admin password"
}

