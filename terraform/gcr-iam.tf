data "google_project" "registry_project" {
    project_id = var.registry_project_id
}

resource "google_storage_bucket_iam_member" "gke_sa_image_pull" {
    depends_on = [
        module.service_project.enabled_apis,
    ]

    bucket = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role = "roles/storage.objectViewer"
    member = format("serviceAccount:%s", google_service_account.gke_sa.email)
}

resource "google_storage_bucket_iam_member" "gitlab_runner_image_push" {
    count         = length(google_service_account.wi_sa)
    depends_on = [
        module.service_project.enabled_apis,
    ]

    bucket = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role = "roles/storage.objectAdmin"
    member = format("serviceAccount:%s", element(google_service_account.wi_sa, count.index).email)
}

resource "google_storage_bucket_iam_member" "gitlab_runner_image_push2" {
    count         = length(google_service_account.wi_sa)
    depends_on = [
        module.service_project.enabled_apis,
    ]

    bucket = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role = "roles/storage.legacyBucketReader"
    member = format("serviceAccount:%s", element(google_service_account.wi_sa, count.index).email)
}

resource "google_storage_bucket_iam_member" "gitlab_runner_image_push3" {
    count         = length(google_service_account.wi_sa)
    depends_on = [
        module.service_project.enabled_apis,
        google_service_account.wi_sa,
    ]

    bucket = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role = "roles/storage.legacyBucketWriter"
    member = format("serviceAccount:%s", element(google_service_account.wi_sa, count.index).email)
}