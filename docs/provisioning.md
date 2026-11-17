# Provisioning a new Omeka S project on Nectar

All projects run as separate Omeka S + MariaDB docker compose stacks on **one shared Nectar VM**, behind a shared Caddy proxy. Each gets a DNS record `<hostname>.curated-collections.cloud.edu.au`.

Terraform state is shared in the Nectar object store (bucket `cc-tfstate`). Read [section 4](#4-keeping-projectsautotfvars-in-sync) before running `terraform apply`.

## 1. Prerequisites

- A Nectar account in the Curated Collections project.
- Write access to [curated-collections-terraform](https://github.com/Sydney-Informatics-Hub/curated-collections-terraform).
- Terraform >= 1.6, installed from the HashiCorp tap (Homebrew core's version is too old):

  ```bash
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  ```

- These files from an existing team member:

  | File | Purpose |
  |---|---|
  | `oidc.auto.tfvars` | CILogon OIDC client ID and secret |
  | `nectar-backend-credentials.sh` | Object store keys for the Terraform state bucket |
  | `Curated-Collections-SIH.pem` | SSH key Terraform uses to deploy to the VM |

## 2. One-time setup

1. Clone the repo:

   ```bash
   git clone git@github.com:Sydney-Informatics-Hub/curated-collections-terraform.git
   cd curated-collections-terraform
   ```

2. Copy `oidc.auto.tfvars` and `nectar-backend-credentials.sh` into the repo root. Move the SSH key into `~/.ssh` and lock down its permissions:

   ```bash
   mv ~/Downloads/Curated-Collections-SIH.pem ~/.ssh/
   chmod 600 ~/.ssh/Curated-Collections-SIH.pem
   ```

3. In the [Nectar dashboard](https://dashboard.rc.nectar.org.au/), select the Curated Collections project, then open the user menu (top right) and download the **OpenStack RC File**. You'll copy `OS_PROJECT_ID` and `OS_PROJECT_NAME` from it in step 5.

4. Reset your Nectar API password at <https://dashboard.rc.nectar.org.au/settings/reset-password/>. This is different from your university password.

5. Create `openstack.auto.tfvars` and fill it in:

   ```bash
   cp openstack.auto.tfvars.example openstack.auto.tfvars
   ```

   ```hcl
   openstack_user       = "you@sydney.edu.au"   # Nectar login email
   openstack_password   = "..."                 # API password from step 4
   nectar_project_id    = "..."                 # OS_PROJECT_ID
   nectar_project_name  = "..."                 # OS_PROJECT_NAME
   ssh_private_key_path = "/Users/you/.ssh/Curated-Collections-SIH.pem"
   ```

6. Initialise Terraform. Source the credentials file in every new terminal before running Terraform:

   ```bash
   source ./nectar-backend-credentials.sh
   terraform init
   terraform validate
   terraform state list   # should list existing projects, e.g. terraform_data.omeka_s["alpha"]
   ```

## 3. Add a new project

1. Create the project's CILogon group (used as `oidc_group`).

2. Pull the latest `main` and create a branch:

   ```bash
   git checkout main && git pull
   git checkout -b add-project-<key>
   ```

3. Add an entry to the `projects` map in [projects.auto.tfvars](../projects.auto.tfvars). Copy an existing entry and change its values. The key must be a lowercase slug (letters, digits and hyphens) of 2–31 characters, and `hostname` must be unique.

   ```hcl
   	my-project = {
   		hostname    = "my-project"
   		owner_email = "owner@sydney.edu.au"
   		owner_name  = "Owner Name"
   		oidc_group  = "my-project-members"
   		oidc_hide_local_login = false
   		oidc_roles_map = {
   			admin = "global_admin"
   			user  = "editor"
   		}
   		omeka_project_title = "My Project"
   		omeka_admin_email   = "admin@curated-collections.edu.au"
   		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:..."
   		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:..."
   	}
   ```

   Pin images by digest; `:latest` is rejected. Optional fields (memory, CPU, site title and so on) and their defaults are in [variables.tf](../variables.tf).

4. Plan:

   ```bash
   source ./nectar-backend-credentials.sh
   terraform validate
   terraform plan
   ```

   The plan should only **add** resources for your project: a DNS record, three passwords and `terraform_data.omeka_s["<key>"]`. If it wants to destroy or replace anything else, stop and see [section 4](#4-keeping-projectsautotfvars-in-sync).

5. Commit, push and open a PR to `main`:

   ```bash
   git add projects.auto.tfvars
   git commit -m "Add <key> project"
   git push -u origin add-project-<key>
   ```

6. After the PR is merged, apply from `main`:

   ```bash
   git checkout main && git pull
   source ./nectar-backend-credentials.sh
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

   Terraform creates the DNS record, connects to the VM over SSH, uploads the project's config and starts its containers. After a few minutes for DNS and TLS, check `https://<hostname>.curated-collections.cloud.edu.au`.

7. Get the Omeka S admin password:

   ```bash
   echo 'nonsensitive(random_password.omeka_admin_password["<key>"].result)' | terraform console
   ```

## 4. Keeping `projects.auto.tfvars` in sync

`projects.auto.tfvars` is committed to git and lists every project that should exist. Because state is shared, applying from an out-of-date copy will **delete** any project that's missing from it. To avoid this:

1. Only plan or apply from an up-to-date `main` with a clean `git status`.
2. Make every change to `projects.auto.tfvars` through a PR.
3. Only one person applies at a time. State isn't locked, so tell the team before you apply.
4. If the plan shows an unexpected destroy or replace, stop.

Don't put secrets in `projects.auto.tfvars`. Shared secrets go in the git-ignored `*.auto.tfvars` files, and per-project passwords are generated by Terraform.

## 5. Other tasks

**Change a project:** edit its entry and follow steps 3.2–3.6. Terraform re-uploads the config and restarts the stack; data in docker volumes is kept.

**Remove a project:** delete its entry and follow steps 3.2–3.6. This removes the DNS record but leaves the containers and data on the VM. To remove those, SSH in and run:

```bash
cd /srv/projects/<key> && docker compose -p <key> down   # add -v to delete data
```

**SSH to the VM:**

```bash
terraform state show openstack_networking_floatingip_v2.floatip | grep address
ssh -i ~/.ssh/Curated-Collections-SIH.pem ubuntu@<ip>
```

> **Never run `terraform destroy`.** It deletes the shared VM and every project's data.

## 6. Troubleshooting

| Problem | Fix |
|---|---|
| `Unsupported argument "endpoints"` on init | Terraform is too old; install it from `hashicorp/tap` |
| S3 403 or missing credentials on init | `source ./nectar-backend-credentials.sh` |
| OpenStack 401 | Check the API password, project ID and project name |
| SSH timeout or auth failure on apply | Check `ssh_private_key_path` and `chmod 600` |
| Plan destroys other projects | `git checkout main && git pull` |
