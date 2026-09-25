
# The container images from the ARCOS registry. These are used to
# populate the docker-compose.yml template


variable "omeka_s_image" {
    description = "ARCOS registry URL for the omeka container"
    default = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:ed232c449d4a48c30612cae6d1851f0f963b0ca2b5b97b4921afa5128ccd4421"
    type = string
}


variable "mariadb_image" {
    description = "ARCOS registry URL for the mariadb container"
    default = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:535196d52fb683997dde77906bf08f93de8ea7dbcef15039ea18fa49c79d66d1"
    type = string
}
