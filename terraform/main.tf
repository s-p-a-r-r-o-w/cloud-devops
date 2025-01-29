provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = "free-tier-gke-cluster"
  location = var.zone

  # Remove the default node pool as we are defining a custom one
  remove_default_node_pool = true
  initial_node_count       = 1

}

resource "google_container_node_pool" "primary_nodes" {
  name       = "free-tier-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 10
  }
}
