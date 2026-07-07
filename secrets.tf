
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
