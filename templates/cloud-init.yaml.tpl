#cloud-config

hostname: ${hostname}
package_update: true
package_upgrade: true

groups:
  - docker

system_info:
  default_user:
    groups: [docker]

write_files:
  - path: /home/ubuntu/cloud-init-was-here.txt
    content: Oh hi Mark

power_state:
  mode: reboot
  message: Restarting after setting up docker
