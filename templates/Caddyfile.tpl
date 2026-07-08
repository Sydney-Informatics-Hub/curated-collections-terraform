${hostname} {
    reverse_proxy * omeka-s-app:80
    tls {
        on_demand
        issuer acme {
            email ${tls_admin_email}
        }
    }
}
