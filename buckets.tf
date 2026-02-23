# bucket for pam users to exchange data
# free for all for data transfer. no permissions enforced
# maybe later turn on a rule where this will be cleared, leave for now
resource "google_storage_bucket" "pam-ww-tmp" {
  name     = "pam-ww-tmp"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "pam-ww-tmp"
  }

  autoclass {
    enabled = true
  }
}

# app intermediate bucket. Use the same one to avoid sprawl, unless an application calls for specific storage tier or lifecycle.
# ideally, will be subdivided into gs://pamdata-app-intermediates/[APP_NAME] so we can set more fine grained permissions as necessary
resource "google_storage_bucket" "pamdata-app-intermediates" {
  name     = "pamdata-app-intermediates"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "pamdata-app-intermediates"
  }

  autoclass {
    enabled = true
  }
}

# app outputs bucket. Use the same one to avoid sprawl, unless an application calls for specific storage tier or lifecycle.
# ideally, will be subdivided into gs://pamdata-app-outputs/[APP_NAME] so we can set more fine grained permissions as necessary
resource "google_storage_bucket" "pamdata-app-outputs" {
  name     = "pamdata-app-outputs"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "pamdata-app-outputs"
  }

  autoclass {
    enabled = true
  }
}

# all data buckets
resource "google_storage_bucket" "data_buckets" {
  for_each = var.data_buckets_map

  name     = each.key
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    data_authority     = replace(replace(each.value.data_authority, "user:", ""), "/[^\w\s]/", "-")
    bucket_name        = each.key
  }

  # default at provisioning time
  autoclass {
    enabled = true
  }

  # this allows users to remove this setting after provisioning time and not have it reset
  # on terraform apply
  # lifecycle {
  #   ignore_changes = [
  #     autoclass
  #   ]
  # }
}

# nefsc working buckets:
resource "google_storage_bucket" "nefsc-1-pab" {
  name     = "nefsc-1-pab"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "nefsc-1-pab"
  }

  autoclass {
    enabled = true
  }
}

# pifsc "working" bucket:
resource "google_storage_bucket" "pifsc-1-detector-output" {
  name     = "pifsc-1-detector-output"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "pifsc-1-detector-output"
  }

  autoclass {
    enabled = true
  }
}

# pifsc working bucket:
resource "google_storage_bucket" "pifsc-1-working" {
  name     = "pifsc-1-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "pifsc-1-working"
  }

  autoclass {
    enabled = true
  }
}

# AFSC:
resource "google_storage_bucket" "afsc-1-working" {
  name     = "afsc-1-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "afsc-1-working"
  }

  autoclass {
    enabled = true
  }
}

# SWFSC:
resource "google_storage_bucket" "swfsc-1-working" {
  name     = "swfsc-1-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "swfsc-1-working"
  }

  autoclass {
    enabled = true
  }
}

# SEFSC:
resource "google_storage_bucket" "sefsc-1-working" {
  name     = "sefsc-1-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "sefsc-1-working"
  }

  autoclass {
    enabled = true
  }
}

resource "google_storage_bucket" "sefsc-2-working" {
  name     = "sefsc-2-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "sefsc-2-working"
  }

  autoclass {
    enabled = true
  }
}

# OST
resource "google_storage_bucket" "ost-1-working" {
  name     = "ost-1-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "ost-1-working"
  }

  autoclass {
    enabled = true
  }
}

# for pngs and decimated data. Autodelete 6 months after creation.
resource "google_storage_bucket" "afsc-1-temp" {
  name     = "afsc-1-temp"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "afsc-1-temp"
  }

  autoclass {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 180
    }

    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "nmfs-collaborative-working" {
  name     = "nmfs-collaborative-working"
  location = var.region1

  uniform_bucket_level_access = true

  labels = {
    noaa_fismaid       = var.system-id
    noaa_lineoffice    = var.lineoffice
    noaa_taskorder     = var.taskorder
    noaa_environment   = var.environment
    noaa_applicationid = var.application-id
    noaa_project_id    = var.project-id
    bucket_name        = "nmfs-collaborative-working"
  }

  autoclass {
    enabled = true
  }
}

# some custom accounting of the buckets, used for pam-ww to decide mount parameters for the different
# type of buckets.

# all data_buckets:
resource "google_storage_bucket_object" "data_buckets_list" {
  bucket  = "tflocal-ggn-nmfs-pamdata-prod-1"
  name    = "cloud_variables/data_bucket_list.txt"
  content = join("\n", keys(var.data_buckets_map))
}

# list to ignore
resource "google_storage_bucket_object" "exclude_buckets_list" {
  bucket  = "tflocal-ggn-nmfs-pamdata-prod-1"
  name    = "cloud_variables/exclude_bucket_list.txt"
  content = "tflocal-ggn-nmfs-pamdata-prod-1\npamdata-app-intermediates" # add more with \n separator
  # pamdata-app-outputs users can see batch outputs in pam-ww
}

# remainder of buckets, for pam-ww, will be mounted as working (vfs cache mode writes)
