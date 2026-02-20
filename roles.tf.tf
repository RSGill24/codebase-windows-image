#permissions for project admins

resource "google_project_iam_member" "proj_admin_storage_admin" {
  project  = var["project-id"]
  role     = "roles/storage.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_compute_admin" {
  project  = var["project-id"]
  role     = "roles/compute.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_iap_admin" {
  project  = var["project-id"]
  role     = "roles/iap.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_osconfig" {
  project  = var["project-id"]
  role     = "roles/osconfig.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_secret_admin" {
  project  = var["project-id"]
  role     = "roles/secretmanager.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_source_repo_admin" {
  project  = var["project-id"]
  role     = "roles/source.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_source_service_admin" {
  project  = var["project-id"]
  role     = "roles/serviceusage.serviceUsageAdmin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_role_admin" {
  project  = var["project-id"]
  role     = "roles/iam.roleAdmin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_sec" {
  project  = var["project-id"]
  role     = "roles/securitycenter.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_logging" {
  project  = var["project-id"]
  role     = "roles/logging.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# needed for turning on dns logging
resource "google_project_iam_member" "proj_admin_dns" {
  project  = var["project-id"]
  role     = "roles/dns.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage bq
resource "google_project_iam_member" "proj_admin_bq" {
  project  = var["project-id"]
  role     = "roles/bigquery.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage cloud run
resource "google_project_iam_member" "proj_admin_run" {
  project  = var["project-id"]
  role     = "roles/run.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage cloud scheduler
resource "google_project_iam_member" "proj_admin_cloud_scheduler" {
  project  = var["project-id"]
  role     = "roles/cloudscheduler.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage cloudbuild
resource "google_project_iam_member" "proj_admin_cloudbuild" {
  project  = var["project-id"]
  role     = "roles/cloudbuild.builds.editor"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage pubsub
resource "google_project_iam_member" "proj_admin_pubsub" {
  project  = var["project-id"]
  role     = "roles/pubsub.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage admin container analysis
resource "google_project_iam_member" "proj_admin_container_analysis" {
  project  = var["project-id"]
  role     = "roles/containeranalysis.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

resource "google_project_iam_member" "proj_admin_container_registry_update" {
  project  = var["project-id"]
  role     = "roles/artifactregistry.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage sql
resource "google_project_iam_member" "proj_admin_sql" {
  project  = var["project-id"]
  role     = "roles/cloudsql.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage sql connection related resources
resource "google_project_iam_member" "proj_admin_sql_cxns" {
  project  = var["project-id"]
  role     = "roles/servicedirectory.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# allow project admin to manage batch compute service
resource "google_project_iam_member" "proj_admin_batch" {
  project  = var["project-id"]
  role     = "roles/batch.admin"
  for_each = toset(var.pamdata_admin)
  member   = each.key
}

# bind project owner to project compute engine account
data "google_compute_default_service_account" "default" {}

resource "google_service_account_iam_member" "proj_admin_default_compute_user" {
  service_account_id = data.google_compute_default_service_account.default.id
  role               = "roles/iam.serviceAccountUser"
  for_each           = toset(var.pamdata_admin)
  member             = each.key
}

data "google_project" "default" {
  project_id = var["project-id"]
}

# this was needed to allow terraform to manage compute instances correctly.
resource "google_project_iam_member" "default_compute_account_instance_admin" {
  project = var["project-id"]
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${data.google_project.default.number}@compute-system.iam.gserviceaccount.com"
}

# allow the windows workstations and packer sa to write out to the bq sink that is used to track compliance.
resource "google_bigquery_dataset_iam_member" "ww_packer_write_to_bq_sink" {
  dataset_id = google_bigquery_dataset.pam_ww_instance_controls.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "ww_packer_write_to_bq_sink_job_create" {
  project = var["project-id"]
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com"
}

# composer roles (composer service account from project ggn-nmfs-pamarc-dev-1):
resource "google_project_iam_member" "cloud_composer_run_developer" {
  project = var["project-id"]
  role    = "roles/run.developer"
  member  = "serviceAccount:composer-sa@ggn-nmfs-pamarc-dev-1.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloud_composer_batch_developer" {
  project  = var["project-id"]
  role     = "roles/batch.jobsEditor"
  for_each = toset([
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:composer-sa@ggn-nmfs-pamarc-dev-1.iam.gserviceaccount.com",
  ])
  member = each.key
}

resource "google_project_iam_member" "cloud_composer_batch_reporter" {
  project = var["project-id"]
  role    = "roles/batch.agentReporter"
  member  = "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com"
}

# may or may not need to add afsc-instinct to both of below
resource "google_project_iam_member" "cloud_composer_artifact_reader" {
  project = var["project-id"]
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:composer-sa@ggn-nmfs-pamarc-dev-1.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloud_composer_pamdata_intermediates_user" {
  project  = var["project-id"]
  role     = "roles/storage.objectAdmin"
  for_each = toset(concat(var.nefsc_minke_detector_users, var.nefsc_humpback_detector_users, var.afsc_instinct_users))
  member   = each.key

  condition {
    title       = "composer"
    description = "restrict admin to prefix 'composer/'"
    expression  = "resource.name.startsWith('projects/_/buckets/pamdata-app-intermediates/objects/composer/')"
  }
}

# let airflow and airflow detector process service accounts read from the pab location
resource "google_project_iam_member" "cloud_composer_pab_detector_user" {
  project  = var["project-id"]
  role     = "roles/storage.objectAdmin"
  for_each = toset([
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:composer-sa@ggn-nmfs-pamarc-dev-1.iam.gserviceaccount.com",
  ])
  member = each.key

  condition {
    title       = "composer read write to pab"
    description = "composer read write to pab"
    expression  = "resource.name.startsWith('projects/_/buckets/nefsc-1-pab/objects/DETECTORS_AND_SOFTWARE')"
  }
}

# permissions for app developers:

# allow app-developers sudo login to app dev server(s).
resource "google_compute_instance_iam_member" "app_dev_osadminlogin_users" {
  project       = var["project-id"]
  zone          = var.zone1
  instance_name = "app-dev-server1"
  role          = "roles/compute.osAdminLogin"
  for_each      = toset(var.app_developers)
  member        = each.key
  depends_on    = [google_compute_instance.app_dev_server1]
}

# allow app developers to start/stop the app dev server(s)
resource "google_compute_instance_iam_member" "app_dev_compute_user" {
  project       = var["project-id"]
  zone          = var.zone1
  instance_name = "app-dev-server1"
  role          = google_project_iam_custom_role.compute_user.id
  for_each      = toset(var.app_developers)
  member        = each.key
  depends_on    = [google_compute_instance.app_dev_server1]
}

resource "google_project_iam_member" "app_dev_iap_tunnel" {
  project  = var["project-id"]
  role     = "roles/iap.tunnelResourceAccessor"
  for_each = toset(var.app_developers)
  member   = each.key
}

# add the app-developers principle group as members.
resource "google_service_account_iam_member" "app_dev_sa_members" {
  service_account_id = google_service_account.app_dev_sa.id
  role               = "roles/iam.serviceAccountUser"
  for_each           = toset(var.app_developers)
  member             = each.key
}

# allow the app dev sa to access the postgres secret (if adding any others to app developers, change this to be more secure)
resource "google_secret_manager_secret_iam_member" "pgsec_viewer" {
  project   = data.google_secret_manager_secret.test_secret_pgpmadb.project
  secret_id = data.google_secret_manager_secret.test_secret_pgpmadb.secret_id
  role      = "roles/secretmanager.viewer"

  for_each = toset([
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key
}

resource "google_secret_manager_secret_iam_member" "pgsec_accessor" {
  project   = data.google_secret_manager_secret.test_secret_pgpmadb.project
  secret_id = data.google_secret_manager_secret.test_secret_pgpmadb.secret_id
  role      = "roles/secretmanager.secretAccessor"

  for_each = toset([
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key
}

data "google_secret_manager_secret" "test_secret_pgpmadb" {
  secret_id = "test-secret-pgpmadb"
}

# will also need to give it bq query perms once I'm able to test this.

# bind the service account to the needed roles:
# compute instances need to send metrics and write to the logging service.
resource "google_project_iam_member" "app_dev_sa_logging" {
  project = var["project-id"]
  role    = "roles/logging.logWriter"
  for_each = toset([
    "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key
}

resource "google_project_iam_member" "app_dev_sa_metrics" {
  project = var["project-id"]
  role    = "roles/monitoring.metricWriter"
  for_each = toset([
    "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key
}

# repo admin
resource "google_project_iam_member" "app_dev_sa_artifacts_admin" {
  project = var["project-id"]
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com"
}

# storage object admin for intermediate and output
resource "google_project_iam_member" "app_dev_sa_storage_obj_admin_intermediates" {
  project = var["project-id"]
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com"

  condition {
    title       = "prefix_appdev"
    description = "restrict admin to prefix 'appdev/'"
    expression  = "resource.name.startsWith('projects/_/buckets/pamdata-app-intermediates/objects/appdev/')"
  }
}

resource "google_project_iam_member" "app_dev_sa_storage_obj_admin_outputs" {
  project = var["project-id"]
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:app-dev-sa@${var["project-id"]}.iam.gserviceaccount.com"

  condition {
    title       = "prefix_appdev"
    description = "restrict admin to prefix 'appdev/'"
    expression  = "resource.name.startsWith('projects/_/buckets/pamdata-app-outputs/objects/appdev/')"
  }
}

# permissions for afsc-instinct users
resource "google_service_account_iam_member" "afsc_instinct_members" {
  service_account_id = google_service_account.afsc_instinct.id
  role               = "roles/iam.serviceAccountUser"
  for_each           = toset(var.afsc_instinct_users)
  member             = each.key
}

resource "google_project_iam_member" "afsc_instinct_user_log_viewer" {
  project  = var["project-id"]
  role     = "roles/logging.viewer"
  for_each = toset(var.afsc_instinct_users)
  member   = each.key
}

# permissions for nefsc-minke users
# can use the nefsc-minke-detector service account
resource "google_service_account_iam_member" "nefsc_minke_detector_members" {
  service_account_id = google_service_account.nefsc_minke_detector.id
  role               = "roles/iam.serviceAccountUser"
  for_each           = toset(var.nefsc_minke_detector_users)
  member             = each.key
}

# users of minke detector can view logs:
resource "google_project_iam_member" "nefsc_minke_user_log_viewer" {
  project  = var["project-id"]
  role     = "roles/logging.viewer"
  for_each = toset(var.nefsc_minke_detector_users)
  member   = each.key
}

# permissions for nefsc-humpback users:
resource "google_service_account_iam_member" "nefsc_humpback_detector_members" {
  service_account_id = google_service_account.nefsc_humpback_detector.id
  role               = "roles/iam.serviceAccountUser"
  for_each           = toset(var.nefsc_humpback_detector_users)
  member             = each.key
}

# service account can write to agreed upon output location
resource "google_project_iam_member" "nefsc_humpback_out" {
  project = var["project-id"]
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:nefsc-humpback-detector@${var["project-id"]}.iam.gserviceaccount.com"

  condition {
    title       = "approved_output_location"
    description = "restrict detector outputs to the approved output location"
    expression  = "resource.name.startsWith('projects/_/buckets/nefsc-1-detector-output/objects/PYTHON_HUMPBACK_CNN/Raw/')"
  }
}

# service account can write to agreed upon output location
resource "google_project_iam_member" "nefsc_humpback_out2" {
  project = var["project-id"]
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:nefsc-humpback-detector@${var["project-id"]}.iam.gserviceaccount.com"

  condition {
    title       = "approved_output_location"
    description = "restrict detector outputs to the approved output location"
    expression  = "resource.name.startsWith('projects/_/buckets/nefsc-1-pab/objects/DETECTOR_OUTPUT/PYTHON_HUMPBACK_CNN/Raw/')"
  }
}

resource "google_project_iam_member" "nefsc_humpback_user_log_viewer" {
  project  = var["project-id"]
  role     = "roles/logging.viewer"
  for_each = toset(var.nefsc_humpback_detector_users)
  member   = each.key
}

# both service accounts can write out here
resource "google_project_iam_member" "detectors_out_appdev" {
  project  = var["project-id"]
  role     = "roles/storage.objectAdmin"
  for_each = toset([
    "serviceAccount:nefsc-minke-detector@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:nefsc-humpback-detector@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key

  condition {
    title       = "approved_output_location"
    description = "restrict detector outputs to the approved output location"
    expression  = "resource.name.startsWith('projects/_/buckets/pamdata-app-outputs/objects/appdev/')"
  }
}

# service account can write to agreed upon output location
resource "google_project_iam_member" "nefsc_minke_out" {
  project = var["project-id"]
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:nefsc-minke-detector@${var["project-id"]}.iam.gserviceaccount.com"

  condition {
    title       = "approved_output_location"
    description = "restrict detector outputs to the approved output location"
    expression  = "resource.name.startsWith('projects/_/buckets/nefsc-1-pab/objects/DETECTOR_OUTPUT/PYTHON_MINKE_KETOS_v0.2/Raw/')"
  }
}

# user roles for cloud run
resource "google_project_iam_member" "cloud_run_dev" {
  project  = var["project-id"]
  role     = "roles/run.developer"
  for_each = toset(concat(var.nefsc_minke_detector_users, var.nefsc_humpback_detector_users))
  member   = each.key
}

resource "google_project_iam_member" "cloud_run_artifact_reader" {
  project  = var["project-id"]
  role     = "roles/artifactregistry.reader"
  for_each = toset(concat(
    var.nefsc_minke_detector_users,
    var.nefsc_humpback_detector_users,
    ["serviceAccount:afsc-instinct@${var["project-id"]}.iam.gserviceaccount.com"],
  ))
  member = each.key
}

# permissions for transfer appliance users
resource "google_project_iam_member" "tau_kms_admin" {
  project  = var["project-id"]
  role     = "roles/cloudkms.admin"
  for_each = toset(var.pamdata_transfer_appliance_admins)
  member   = each.key
}

# this seems overpermissioned, but required by documentation
resource "google_project_iam_member" "tau_service_account_admin" {
  project  = var["project-id"]
  role     = "roles/iam.serviceAccountAdmin"
  for_each = toset(var.pamdata_transfer_appliance_admins)
  member   = each.key
}

resource "google_project_iam_member" "tau_transfer_appliance_admin" {
  project  = var["project-id"]
  role     = "roles/transferappliance.admin"
  for_each = toset(var.pamdata_transfer_appliance_admins)
  member   = each.key
}

resource "google_project_iam_member" "tau_kms_user" {
  project  = var["project-id"]
  role     = google_project_iam_custom_role.tau_kms_user_role.id
  for_each = toset(var.pamdata_transfer_appliance_users)
  member   = each.key
}

resource "google_project_iam_member" "tau_kms_user_predefined" {
  project  = var["project-id"]
  role     = "roles/transferappliance.viewer"
  for_each = toset(var.pamdata_transfer_appliance_users)
  member   = each.key
}

# permissions for project supervisors:
# viewing for current resources:
resource "google_project_iam_member" "network_viewer" {
  project  = var["project-id"]
  role     = "roles/compute.networkViewer"
  for_each = toset(var.pamdata_supervisors)
  member   = each.key
}

resource "google_project_iam_member" "compute_viewer" {
  project  = var["project-id"]
  role     = "roles/compute.viewer"
  for_each = toset(var.pamdata_supervisors)
  member   = each.key
}

resource "google_project_iam_member" "artifact_reg_reader" {
  project  = var["project-id"]
  role     = "roles/artifactregistry.reader"
  for_each = toset(var.pamdata_supervisors)
  member   = each.key
}

resource "google_project_iam_member" "source_reader" {
  project  = var["project-id"]
  role     = "roles/source.reader"
  for_each = toset(concat(var.pamdata_supervisors, ["user:joshua.le@noaa.gov"]))
  member   = each.key
}

# permissions for data authorities and data admins
# we could also make it so data authorities have the ability to set data admins at their discretion,
# but that would move control of that to the authorities themselves.
# data authority does not assume data admin.

# changing to binding. Think that's fine given how it's managed.
resource "google_storage_bucket_iam_binding" "data_bucket_data_admin" {
  for_each = var.data_buckets_map
  bucket   = each.key
  role     = "roles/storage.objectUser"
  members  = each.value.data_admins
}

# roles for pam-ww users
# allow users of pam-ww to transfer files in and out
resource "google_storage_bucket_iam_member" "pam_ww_tmp_object_admin" {
  bucket   = google_storage_bucket.pam_ww_tmp.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.pam_ww_users1, [
    "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com",
    "serviceAccount:nefsc-minke-detector@ggn-nmfs-pamdata-prod-1.iam.gserviceaccount.com",
    "serviceAccount:nefsc-humpback-detector@ggn-nmfs-pamdata-prod-1.iam.gserviceaccount.com",
    "serviceAccount:composer-sa@ggn-nmfs-pamarc-dev-1.iam.gserviceaccount.com",
    "serviceAccount:afsc-instinct@ggn-nmfs-pamdata-prod-1.iam.gserviceaccount.com",
  ]))
  member = each.key
}

resource "google_service_account_iam_member" "ww_sa_members" {
  service_account_id = google_service_account.windows_workstation_sa.id
  role               = "roles/iam.serviceAccountUser"
  for_each           = toset(var.pam_ww_users1)
  member             = each.key
}

# after testing, replace with below
resource "google_project_iam_member" "ww_iap_tunnel_members" {
  project  = var["project-id"]
  role     = "roles/iap.tunnelResourceAccessor"
  for_each = toset(var.pam_ww_users1)
  member   = each.key
}

# use this once confirmed success.
resource "google_iap_tunnel_instance_iam_member" "ww_iap_tunnel_instance_members" {
  project  = var["project-id"]
  zone     = var.zone1
  for_each = toset(var.pam_ww_users1)

  instance = "${lower(replace(replace(replace(each.value, "/[^a-z0-9]+/", "-"), "_", "-"), ".noaa.gov", ""))}-pam-ww"
  role     = "roles/iap.tunnelResourceAccessor"
  member   = each.key

  depends_on = [google_compute_instance.user_pam_windows_workstation_instance]
}

# give this to becca, then manually remove her broader condition to test.
# resource "google_iap_tunnel_instance_iam_member" "test_ww_iap_tunnel_members" {
#   project = var["project-id"]
#   zone    = var.zone1
#   instance = "rebecca-vanhoeck-pam-ww"
#   role    = "roles/iap.tunnelResourceAccessor"
#   member  = "user:rebecca.vanhoeck@noaa.gov"
# }

resource "google_project_iam_member" "ww_compute_viewers" {
  project  = var["project-id"]
  role     = "roles/compute.viewer"
  for_each = toset(var.pam_ww_users1)
  member   = each.key
}

# instance specific permissions: oslogin bound to instance, state custom role
# encompasses state and oslogin, bound to instance
resource "google_compute_instance_iam_member" "pam_ww_login" {
  for_each = toset(var.pam_ww_users1)

  zone          = var.zone1
  project       = var["project-id"]
  instance_name = google_compute_instance.user_pam_windows_workstation_instance[each.key].name
  role          = google_project_iam_custom_role.compute_user.id
  member        = each.value

  depends_on = [google_compute_instance.user_pam_windows_workstation_instance]
}

# allow user to delete their own VM, important for update flow.
resource "google_project_iam_member" "self_delete_vm" {
  for_each = toset(var.pam_ww_users1)

  project = var["project-id"]
  role    = "roles/compute.instanceAdmin.v1"
  member  = each.key

  condition {
    title       = "SelfDeleteOk"
    description = "allow user to delete their own VM, important for prompt pam-ww updates"
    expression  = "resource.name == 'projects/${var["project-id"]}/zones/${var.zone1}/instances/${google_compute_instance.user_pam_windows_workstation_instance[each.key].name}'"
  }

  depends_on = [google_compute_instance.user_pam_windows_workstation_instance]
}

# compute instances need to send metrics and write to the logging service.
resource "google_project_iam_member" "ww_sa1_logging" {
  project = var["project-id"]
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "ww_sa1_metrics" {
  project = var["project-id"]
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com"
}

# give taiki access to secret manager. This should let him create and manage his own secrets without allowing him access
# to other user's secrets.
resource "google_secret_manager_secret_iam_member" "manager" {
  project   = data.google_secret_manager_secret.taiki_api_key.project
  secret_id = data.google_secret_manager_secret.taiki_api_key.secret_id
  role      = "roles/secretmanager.secretVersionManager"
  member    = "user:taiki.sakai@noaa.gov"
}

resource "google_secret_manager_secret_iam_member" "viewer" {
  project   = data.google_secret_manager_secret.taiki_api_key.project
  secret_id = data.google_secret_manager_secret.taiki_api_key.secret_id
  role      = "roles/secretmanager.viewer"
  for_each  = toset([
    "user:taiki.sakai@noaa.gov",
    "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key
}

resource "google_secret_manager_secret_iam_member" "accessor" {
  project   = data.google_secret_manager_secret.taiki_api_key.project
  secret_id = data.google_secret_manager_secret.taiki_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  for_each  = toset([
    "user:taiki.sakai@noaa.gov",
    "serviceAccount:windows-workstation-sa@${var["project-id"]}.iam.gserviceaccount.com",
  ])
  member = each.key
}

data "google_secret_manager_secret" "taiki_api_key" {
  secret_id = "taiki-api-key"
}

# FMC specific working bucket roles:
resource "google_storage_bucket_iam_member" "nefsc_1_detector_output_object_admin" {
  bucket   = google_storage_bucket.nefsc_1_detector_output.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.nefsc_1.data_admins, var.data_buckets_map.nefsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "nefsc_1_ancillary_data_object_admin" {
  bucket   = google_storage_bucket.nefsc_1_ancillary_data.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.nefsc_1.data_admins, var.data_buckets_map.nefsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "nefsc_1_pab_data_object_admin" {
  bucket   = google_storage_bucket.nefsc_1_pab.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.nefsc_1.data_admins, var.data_buckets_map.nefsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "pifsc_1_detector_output_object_admin" {
  bucket   = google_storage_bucket.pifsc_1_detector_output.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.pifsc_1.data_admins, var.data_buckets_map.pifsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "pifsc_1_working_object_admin" {
  bucket   = google_storage_bucket.pifsc_1_working.name
  role     = "roles/storage.objectUser"
  for_each = toset(var.data_buckets_map.pifsc_1.data_admins)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "swfsc_1_working_data_object_admin" {
  bucket   = google_storage_bucket.swfsc_1_working.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.swfsc_1.data_admins, var.data_buckets_map.swfsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "afsc_1_working_object_admin" {
  bucket   = google_storage_bucket.afsc_1_working.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.afsc_1.data_admins, var.data_buckets_map.afsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "afsc_1_temp_object_admin" {
  bucket   = google_storage_bucket.afsc_1_temp.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.afsc_1.data_admins, var.data_buckets_map.afsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "sefsc_1_working_object_admin" {
  bucket   = google_storage_bucket.sefsc_1_working.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.sefsc_1.data_admins, var.data_buckets_map.sefsc_1.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "sefsc_2_working_object_admin" {
  bucket   = google_storage_bucket.sefsc_2_working.name
  role     = "roles/storage.objectUser"
  for_each = toset(concat(var.data_buckets_map.sefsc_2.data_admins, var.data_buckets_map.sefsc_2.all_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "ost_1_working_object_admin" {
  bucket   = google_storage_bucket.ost_1_working.name
  role     = "roles/storage.objectUser"
  for_each = toset(["user:samara.h.haven@noaa.gov", "user:murali.moore@noaa.gov", "user:louisa.li@noaa.gov"])
  member   = each.key
}

# repo source readers:
resource "google_project_iam_member" "proj_admin_source_repo_readers" {
  project  = var["project-id"]
  role     = "roles/source.reader"
  for_each = toset(["user:chris.angiel@noaa.gov", "user:rajinder.gill@noaa.gov"])
  member   = each.key
}

#### bucket permissions:
# all data buckets (fine, presumably), working buckets (to keep consistent current behavior- ask about this when feds are back bc I assume we want working data more locked down) readable by all now,
# do not expose: tf_state

# open up bucket listership and metadata viewership
resource "google_project_iam_member" "all_noaa_bucket_viewer" {
  project  = var["project-id"]
  role     = google_project_iam_custom_role.bucket_lister.id
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_project_iam_member" "all_noaa_bucket_metadata_viewer" {
  project  = var["project-id"]
  role     = "roles/storage.insightsCollectorService"
  for_each = toset(var.bucket_users)
  member   = each.key
}

# solution: copy/pasting to grant access to individual buckets.
# remember: need to manually add new buckets here.

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_afsc_1" {
  bucket   = "afsc-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_afsc_1_temp" {
  bucket   = "afsc-1-temp"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_afsc_1_working" {
  bucket   = "afsc-1-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nefsc_1" {
  bucket   = "nefsc-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(concat(["serviceAccount:aa-ncsi-sa1@ggn-nmfs-aa-dev-1.iam.gserviceaccount.com"], var.bucket_users))
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nefsc_1_ancillary_data" {
  bucket   = "nefsc-1-ancillary-data"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nefsc_1_detector_output" {
  bucket   = "nefsc-1-detector-output"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nefsc_1_pab" {
  bucket   = "nefsc-1-pab"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nwfsc_1" {
  bucket   = "nwfsc-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nwfsc_2" {
  bucket   = "nwfsc-2"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_onms_1" {
  bucket   = "onms-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_ost_1" {
  bucket   = "ost-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_ost_1_working" {
  bucket   = "ost-1-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_pam_ww_tmp" {
  bucket   = "pam-ww-tmp"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_pamdata_app_intermediates" {
  bucket   = "pamdata-app-intermediates"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_pamdata_app_outputs" {
  bucket   = "pamdata-app-outputs"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_pifsc_1" {
  bucket   = "pifsc-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_pifsc_1_detector_output" {
  bucket   = "pifsc-1-detector-output"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_pifsc_1_working" {
  bucket   = "pifsc-1-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_sefsc_1" {
  bucket   = "sefsc-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_sefsc_1_working" {
  bucket   = "sefsc-1-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_sefsc_2" {
  bucket   = "sefsc-2"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_sefsc_2_working" {
  bucket   = "sefsc-2-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_swfsc_1" {
  bucket   = "swfsc-1"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_swfsc_1_working" {
  bucket   = "swfsc-1-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_swfsc_2" {
  bucket   = "swfsc-2"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_swfsc_2_working" {
  bucket   = "swfsc-2-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nmfs_collaborative" {
  bucket   = "nmfs-collaborative"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer_nmfs_collaborative_working" {
  bucket   = "nmfs-collaborative-working"
  role     = "roles/storage.objectViewer"
  for_each = toset(var.bucket_users)
  member   = each.key
}

# all that to exclude:
# tf local- ggn-nmfs-pamdata-prod-1

################################################################################
# Added from screenshot: roles.tf lines ~495–560 (Transfer Appliance + Supervisors)
################################################################################

#permissions for transer appliance users

resource "google_project_iam_member" "tau-kms-admin" {
  project  = var.project_id
  role     = "roles/cloudkms.admin"
  for_each = toset(var.pamdata-transfer-appliance-admins)
  member   = each.key
}

#this seems overpermissioned, but required by documentation
resource "google_project_iam_member" "tau-service-account-admin" {
  project  = var.project_id
  role     = "roles/iam.serviceAccountAdmin"
  for_each = toset(var.pamdata-transfer-appliance-admins)
  member   = each.key
}

resource "google_project_iam_member" "tau-transfer-appliance-admin" {
  project  = var.project_id
  role     = "roles/transferappliance.admin"
  for_each = toset(var.pamdata-transfer-appliance-admins)
  member   = each.key
}

resource "google_project_iam_member" "tau-kms-user" {
  project  = var.project_id
  role     = google_project_iam_custom_role.tau-kms-user-role.id
  for_each = toset(var.pamdata-transfer-appliance-users)
  member   = each.key
}

resource "google_project_iam_member" "tau-kms-user-predefined" {
  project  = var.project_id
  role     = "roles/transferappliance.viewer"
  for_each = toset(var.pamdata-transfer-appliance-users)
  member   = each.key
}

#permissions for project supervisors
#viewing for current resources:

resource "google_project_iam_member" "network-viewer" {
  project  = var.project_id
  role     = "roles/compute.networkViewer"
  for_each = toset(var.pamdata-supervisors)
  member   = each.key
}

resource "google_project_iam_member" "compute-viewer" {
  project  = var.project_id
  role     = "roles/compute.viewer"
  for_each = toset(var.pamdata-supervisors)
  member   = each.key
}

resource "google_project_iam_member" "artifact-reg-reader" {
  project  = var.project_id
  role     = "roles/artifactregistry.reader"
  for_each = toset(var.pamdata-supervisors)
  member   = each.key
}

resource "google_project_iam_member" "source-reader" {
  project  = var.project_id
  role     = "roles/source.reader"
  for_each = toset(concat(var.pamdata-supervisors, ["user:joshua.leigh@noaa.gov"]))
  member   = each.key
}

################################################################################

################################################################################
### Bucket permissions
### All data buckets (fine, presumably), working buckets (to keep consistent current behavior - ask about this when feds are back bc I assume we want working data more locked down) readable by all NOAA.
### Do not expose: tf.state
################################################################################

# Open up bucket listership and metadata viewership
resource "google_project_iam_member" "all_noaa_bucket_viewer" {
  project  = var.project_id
  role     = google_project_iam_custom_role.bucket_lister.id
  for_each = toset(var.bucket_users)
  member   = each.key
}

resource "google_project_iam_member" "all_noaa_bucket_metadata_viewer" {
  project  = var.project_id
  role     = "roles/storage.insightsCollectorService"
  for_each = toset(var.bucket_users)
  member   = each.key
}

# Solution: copy/pasting to grant access to individual buckets.
# Remember: need to manually add new buckets here.

locals {
  all_noaa_objectviewer_buckets = [
    "afsc-1",
    "afsc-1-temp",
    "afsc-1-working",
    "nefsc-1",
    "nefsc-1-ancillary-data",
    "nefsc-1-detector-output",
    "nefsc-1-pab",
    "nwfsc-1",
    "nwfsc-2",
    "oms-1",
    "ost-1",
    "ost-1-working",
    "pam-ww-tmp",
    "pamdata-app-intermediates",
    "pamdata-app-outputs",
    "pifsc-1",
    "pifsc-1-detector-output",
    "pifsc-1-working",
    "sefsc-1",
    "sefsc-1-working",
    "sefsc-2",
    "sefsc-2-working",
    "swfsc-1",
    "swfsc-1-working",
    "nmfs-collaborative",
    "nmfs-collaborative-working",
  ]

  all_noaa_objectviewer_bindings = {
    for pair in setproduct(local.all_noaa_objectviewer_buckets, toset(var.bucket_users)) :
    "${pair[0]}|${pair[1]}" => {
      bucket = pair[0]
      member = pair[1]
    }
  }
}

resource "google_storage_bucket_iam_member" "all_noaa_bucket_objects_viewer" {
  for_each = local.all_noaa_objectviewer_bindings

  bucket = each.value.bucket
  role   = "roles/storage.objectViewer"
  member = each.value.member
}

# all that to exclude:
# tfLocal-ggn-nmfs-pamdata-prod-1
