
# The container images from the ARCOS registry. These are used to
# populate the docker-compose.yml template


variable "omeka_s_image" {
    description = "ARCOS registry URL for the omeka container"
    default = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:54f1cffbd4d7370d70cdfdf48bff325b3b17792993f9e85d702e397a9cda3c54"
    type = string
}


variable "mariadb_image" {
    description = "ARCOS registry URL for the mariadb container"
    default = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:229b104057cb01fda97422356cd1f8e0d7de2445066d4cba39d1b6873294424c"
    type = string
}
