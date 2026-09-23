
# The container images from the ARCOS registry. These are used to
# populate the docker-compose.yml template


variable "omeka_s_image" {
    description = "ARCOS registry URL for the omeka container"
    default = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:bd8d050df64be1e314fc9efd263de2df9cf61320535a13dfadb73d1ee90901a6"
    type = string
}


variable "mariadb_image" {
    description = "ARCOS registry URL for the mariadb container"
    default = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:88225ac70b1be3975aceaa39e9ed5df07ca1ab25cc6d88bc411ece14fe0b920a"
    type = string
}
