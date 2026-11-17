${hostname} {
    reverse_proxy * ${project}-omeka-s-app-1:80
    tls {
        on_demand
        issuer acme {
            email ${tls_admin_email}
        }
    }
}
