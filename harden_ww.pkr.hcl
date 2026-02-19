packer {
  required_plugins {
    googlecompute = {
      # version = ">= 1.1.1"
      # prior to a "helpful" change where it overrides your local acc name with sa_#, breaking the narrow channel of success
      version = "1.1.6"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "packer_user_password" {
  type      = string
  default   = env("PACKER_PW")
  sensitive = true
}

# just supply this with a query at runtime.
variable "source_image" {
  default = env("SRC_IMG_NAME")
  type    = string
}

# to update the lastest ww-template image to the current template (useful prior to running this one)
# gcloud compute instances stop lastest-pam-ww-template-instance --zone us-east4-c && gcloud compute images create beta-10-$(date +%s) --source-disk-lastest-pam-ww-template-instance --source-disk-zone=us-east4-c --family=pam-ww-templates
#
# to harden the image
# packer build -var source_image=$(gcloud compute images list --filter 'family=pam-ww-templates' --format 'value(name)' --sort-by ~creationTimestamp --limit 1) -var packer_user_password=$(gcloud secrets versions access latest --secret=packer_user_password)

source "googlecompute" "update-pam-ww" {
  project_id              = "ggn-nmfs-pamdata-prod-1"
  use_iap                 = true
  source_image_project_id = ["ggn-nmfs-pamdata-prod-1"]
  source_image_family     = "pam-ww-templates"
  communicator    = "winrm"
  winrm_username  = "packer_user"
  winrm_password  = var.packer_user_password
  winrm_use_ssl   = true
  winrm_insecure  = true
  service_account_email = "packer-builder-sa@ggn-nmfs-pamdata-prod-1.iam.gserviceaccount.com"
  enable_secure_boot          = false
  enable_integrity_monitoring = false
  enable_vtpm                 = false
  disk_size                   = 250

  image_family = "pam-windows-workstation"
  image_name   = "pww-disa-${var.source_image}-hardened-patched-{{timestamp}}"
  machine_type = "e2-standard-8"
}

build {
  sources = ["sources.googlecompute.update-pam-ww"]

  provisioner "powershell" {
    inline = [
      "Get-WindowsUpdate -Install -AcceptAll"
    ]

    elevated_user     = "packer_user"
    elevated_password = var.packer_user_password
  }

  provisioner "file" {
    source      = "./windows-workstation-files/"
    destination = "C:/Users/packer_user/hardening"
  }

  provisioner "powershell" {
    inline = [
      "cd C:/Users/packer_user/hardening",
      "./run_all.ps1"
    ]

    elevated_user     = "packer_user"
    elevated_password = var.packer_user_password
  }
}
