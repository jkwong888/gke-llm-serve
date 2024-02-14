resource "google_secret_manager_secret" "hf_token" {
  project       = module.service_project.project_id

  secret_id = "hf-token"
  replication {
    auto {}
  }
}