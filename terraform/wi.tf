resource "google_service_account" "wi_sa" {
  count         = length(keys(var.workload_identity_map))
  project       = module.service_project.project_id
  account_id    = element(keys(var.workload_identity_map), count.index)
  display_name  = format("workload identity %s service account", element(keys(var.workload_identity_map), count.index))
}

resource "google_service_account_iam_member" "wi_sa_role" {
  count               = length(keys(var.workload_identity_map))
  service_account_id  = google_service_account.wi_sa[count.index].name
  role                = "roles/iam.workloadIdentityUser"
  member              = format("serviceAccount:%s.svc.id.goog[%s]", 
                            module.service_project.project_id, 
                            lookup(var.workload_identity_map, 
                                   google_service_account.wi_sa[count.index].account_id, ""))
}



