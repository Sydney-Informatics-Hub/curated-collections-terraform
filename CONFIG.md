# Configuration reference

This document describes every variable you can set in the `*.auto.tfvars`
files. Terraform loads all `*.auto.tfvars` files in the repo root
automatically, so you don't need to pass `-var-file`.

Variables are declared in [variables.tf](variables.tf). Values that are worked
out from these variables (full hostnames, rendered config files and so on) are
in [locals.tf](locals.tf). Don't edit `locals.tf` to change configuration.

## Where each variable goes

| File | In Git? | Contents |
|---|---|---|
| `projects.auto.tfvars` | yes | The `projects` map: one entry for each Omeka S instance |
| `globals.auto.tfvars` | yes | Settings for the shared VM, network, domain and directories |
| `oidc.auto.tfvars` | **no** | OIDC client settings shared by all projects. Copy from `oidc.auto.tfvars.example` |
| `openstack.auto.tfvars` | **no** | Nectar / OpenStack credentials. Copy from `openstack.auto.tfvars.example` |

`oidc.auto.tfvars` and `openstack.auto.tfvars` contain secrets and are listed in
`.gitignore`. Never commit them.

---

## Project variables (`projects.auto.tfvars`)

Day to day, this is the file you'll edit most. Each entry in the `projects` map
creates one Omeka S instance on the shared VM, with its own MariaDB database,
Docker Compose stack, Caddy site, DNS record and generated passwords.

```hcl
projects = {
  alpha = {
    hostname            = "alpha"
    owner_email         = "owner@example.edu.au"
    owner_name          = "Project Owner"
    oidc_group          = "alpha-project-members"
    oidc_roles_map      = {
      alpha-project-admins      = "global_admin"
      alpha-project-researchers = "editor"
    }
    omeka_admin_email   = "admin@curated-collections.edu.au"
    omeka_project_title = "Alpha"
    omeka_s_image       = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:..."
    mariadb_image       = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:..."
  }
}
```

### The project key

The map key (`alpha` above) is the project's internal name. It is used for:

- the Docker Compose project name and container names
- the project's directories on the server (`<docker_dir>/<key>`,
  `<caddy_dir>/sites/<key>`, `<volume_dir>/<key>`)
- the Terraform resource addresses, such as `terraform_data.omeka_s["alpha"]`

**Validation:** it must match `^[a-z][a-z0-9-]{1,30}$`. That means it starts
with a lowercase letter, contains only lowercase letters, digits and hyphens,
and is 2–31 characters long.

Changing the key of an existing project makes Terraform treat it as a new
project. The old instance is destroyed and a new one created, with new
passwords and empty directories.

### Required project fields

| Field | Type | Description |
|---|---|---|
| `hostname` | string | The DNS label for the site. The public address is `https://<hostname>.<cc_domain>`. It can differ from the project key, for example to give a staging site its own hostname (`carceral-archipelago` is served at `carceral-staging`). **Validation:** hostnames must be unique across all projects. |
| `omeka_s_image` | string | The Omeka S container image. **Validation:** must not end in `:latest`. Pin it to a version tag or, preferably, a `@sha256:` digest. |
| `mariadb_image` | string | The MariaDB container image. **Validation:** must not end in `:latest`. |
| `owner_email` | string | Email of the project owner (for record keeping). |
| `owner_name` | string | Name of the project owner (for record keeping). |
| `oidc_group` | string | Only users whose `isMemberOf` claim contains this group can log in to the instance. |
| `oidc_roles_map` | map(string) | Maps OIDC group names to Omeka S roles, such as `global_admin` and `editor`. The default role is empty, so members of `oidc_group` who match no entry get no role. |
| `omeka_admin_email` | string | Email address of the initial Omeka S admin user. |

### Optional project fields

| Field | Type | Default | Description |
|---|---|---|---|
| `oidc_hide_local_login` | bool | `true` | Hides the Omeka S username/password login form so users can only sign in through OIDC. Set to `false` while you still need the local admin login. |
| `omeka_admin_user` | string | `"Admin"` | Display name of the initial Omeka S admin user. |
| `omeka_project_title` | string | `"Omeka S Project"` | The installation title in Omeka S. |
| `omeka_site_title` | string | `"Site"` | Title of the first Omeka S site. |
| `omeka_site_slug` | string | `"site"` | URL slug of the first Omeka S site (`/s/<slug>`). |
| `php_memory_limit` | string | `"512M"` | PHP `memory_limit`, written to `cc-omeka.ini`. |
| `php_upload_max_filesize` | string | `"120M"` | PHP `upload_max_filesize`. This is the largest single file a user can upload. |
| `php_post_max_size` | string | `"120M"` | PHP `post_max_size`. Keep it at least as large as `php_upload_max_filesize`. |
| `state` | string | `"running"` | `running` or `stopped`. **Validation:** must be one of those two values. *Not yet acted on: setting `stopped` doesn't stop the containers.* |
| `mem_limit` | string | `"768m"` | Container memory limit. *Declared but not yet used in the Compose template.* |
| `cpus` | number | `1.0` | Container CPU limit. *Declared but not yet used in the Compose template.* |
| `aliases` | list(string) | `[]` | Extra hostnames that should redirect to the main one. *Declared but not yet used in the Caddy or DNS config.* |

The Omeka admin fields (`omeka_admin_*`, `omeka_project_title`, `omeka_site_*`)
are written to the instance's Docker secrets. They only matter the first time
the container installs Omeka S. Changing them later doesn't rename an existing
user or site.

Changing any rendered value for a project (images, PHP settings, OIDC settings,
hostname) changes that project's config hash. On the next `apply`, Terraform
re-provisions the project and runs `docker compose up -d` again.

### Adding a project

1. Add an entry to `projects` in `projects.auto.tfvars`, with a new key and a
   unique `hostname`.
2. Make sure `oidc_group` and the groups in `oidc_roles_map` exist in the
   identity provider.
3. Run `terraform plan` and check that it only adds resources for the new
   project.
4. Run `terraform apply`.

---

## Global variables (`globals.auto.tfvars`)

These variables configure the shared infrastructure: one VM, its network and
volume, the reverse proxy, and the backup container.

### Naming and domain

| Variable | Type | Default | Description |
|---|---|---|---|
| `cc_prefix` | string | *required* | Prefix for the names of the shared resources: the VM (`<cc_prefix>-network-instance`, also used as its hostname), the storage volume, network, subnet and router, and the backup object-storage container (`<cc_prefix>-backup`) and its credential. Changing it renames or replaces those resources, so in practice it's fixed once a deployment exists. |
| `cc_domain` | string | `"curated-collections.cloud.edu.au"` | The base DNS domain. Each project is served at `<hostname>.<cc_domain>`. |
| `tls_admin_email` | string | *required* | Contact email for the ACME / Let's Encrypt account Caddy uses to issue TLS certificates. |

### Nectar compute

| Variable | Type | Default | Description |
|---|---|---|---|
| `availability_zone` | string | `"ardc-syd-1"` | Nectar availability zone for the VM and volume. |
| `ip_pool` | string | `"ardc-syd"` | Nectar floating IP pool. This is a different value from the availability zone. |
| `vm_image` | string | *required* | Name of the Nectar image to boot. It needs Docker installed, e.g. `"NeCTAR Ubuntu 22.04 LTS (Jammy) amd64 (with Docker)"`. |
| `vm_flavor` | string | *required* | Nectar flavour (VM size), e.g. `"m3.large"`. All projects share this VM, so size it for the total load. |
| `volume_size` | number | *required* | Size in GB of the persistent volume that holds uploaded files. |

Changing `vm_image`, `availability_zone` or `volume_size` can force Terraform
to replace the VM or volume. Always read the plan before applying.

### Directories on the server

| Variable | Type | Default | Description |
|---|---|---|---|
| `proxy_dir` | string | *required* | Directory for the top-level reverse proxy's `docker-compose.yml`, e.g. `/srv/proxy`. |
| `proxy_caddyfile` | string | *required* | Path of the top-level proxy Caddyfile, e.g. `/srv/caddy/Caddyfile`. |
| `caddy_dir` | string | *required* | Parent directory for per-project Caddyfiles (`<caddy_dir>/sites/<key>/Caddyfile`), e.g. `/srv/caddy`. |
| `docker_dir` | string | *required* | Parent directory for per-project Compose directories and secrets (`<docker_dir>/<key>`), e.g. `/srv/projects`. |
| `volume_dir` | string | *required* | Parent directory for per-project upload storage on the persistent volume (`<volume_dir>/<key>/files`), e.g. `/pvol/projects`. **Note:** the project Compose template currently hard-codes `/pvol/projects`, so if you change this value you also need to change the template. |

### Omeka S build settings

You rarely need to change these. Leave them at their defaults unless the
container image changes.

| Variable | Type | Default | Description |
|---|---|---|---|
| `omeka_build_admin_email` | string | `"admin-tmp@curated-collections.edu.au"` | Placeholder admin email baked into the Omeka S build image. The container startup script uses it to find and replace the temporary admin with the real one. |
| `omeka_build_site_slug` | string | `"temp-site"` | Placeholder site slug baked into the build image, replaced in the same way. |
| `omeka_uid` | number | `33` | UID of `www-data` in the Omeka S image. The project's upload directory is `chown`ed to this user. |
| `omeka_gid` | number | `33` | GID of `www-data` in the Omeka S image. |

---

## OIDC variables (`oidc.auto.tfvars`, not in Git)

These are shared by every project. Settings for each project (the group that
controls access and the role mapping) are in `projects.auto.tfvars`.

| Variable | Type | Sensitive | Description |
|---|---|---|---|
| `oidc_idp_discovery_url` | string | | The identity provider's OpenID discovery document URL, e.g. `https://cilogon.aaf.edu.au/.well-known/openid-configuration`. |
| `oidc_client_id` | string | | The OIDC client ID registered with the identity provider. |
| `oidc_client_secret` | string | yes | The OIDC client secret. |

Each project's redirect URL is based on `https://<hostname>.<cc_domain>`, so
every project hostname must be allowed as a redirect in the OIDC client's
registration.

---

## OpenStack / Nectar variables (`openstack.auto.tfvars`, not in Git)

| Variable | Type | Sensitive | Description |
|---|---|---|---|
| `openstack_user` | string | | The email you use to log in to the Nectar dashboard. |
| `openstack_password` | string | yes | Your Nectar **API** password. This is not your institutional password. You can reset it at <https://dashboard.rc.nectar.org.au/settings/reset-password/>. |
| `nectar_project_id` | string | | The Nectar project ID (`OS_PROJECT_ID` in the downloaded OpenStack RC file). |
| `nectar_project_name` | string | | The Nectar project name (`OS_PROJECT_NAME` in the OpenStack RC file). |
| `ssh_private_key_path` | string | | Absolute path to the private key for the VM's key pair. Terraform uses it to SSH in and provision each project. |
