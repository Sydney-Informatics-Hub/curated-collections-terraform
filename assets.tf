# --- Object storage: hold the static, unchanging DB seed file ---

resource "openstack_objectstorage_container_v1" "app_assets" {
  region = "Syd"                     # match your provider's region
  name   = "${local.cc_prefix}-app-assets"
  metadata = {
    Temp-URL-Key = "testkey"
  }
}

resource "openstack_objectstorage_object_v1" "init_db" {
  region         = "Syd"
  container_name = openstack_objectstorage_container_v1.app_assets.name
  name           = "init.sql"
  source         = "${path.module}/assets/init-db.sql" 
  etag           = filemd5("${path.module}/assets/init-db.sql")
  content_type   = "text/plain"
}

# Signed, time-limited download URL — no need to make the container public
resource "openstack_objectstorage_tempurl_v1" "init_db_url" {
  container      = openstack_objectstorage_container_v1.app_assets.name
  object         = openstack_objectstorage_object_v1.init_db.name
  method         = "get"
  ttl            = 3600   # seconds; just needs to outlive first boot
}
