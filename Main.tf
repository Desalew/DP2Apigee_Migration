provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable Required APIs
resource "google_project_service" "apigee" {
  project = var.project_id
  service = "apigee.googleapis.com"
}

# Create Apigee Organization
resource "google_apigee_organization" "org" {
  project_id   = var.project_id
  analytics_region = var.analytics_region
  description  = "Apigee Org for API management"

  depends_on = [google_project_service.apigee]
}

# Create Apigee Environment
resource "google_apigee_environment" "env" {
  org_id      = google_apigee_organization.org.id
  name        = var.apigee_env
  description = "Apigee Environment"

  depends_on = [google_apigee_organization.org]
}

# Create Apigee Environment Group
resource "google_apigee_envgroup" "env_group" {
  org_id = google_apigee_organization.org.id
  name   = var.apigee_env_group

  depends_on = [google_apigee_environment.env]
}

# Attach Environment to Environment Group
resource "google_apigee_envgroup_attachment" "env_attachment" {
  envgroup_id  = google_apigee_envgroup.env_group.id
  environment  = google_apigee_environment.env.name

  depends_on = [google_apigee_envgroup.env_group]
}
