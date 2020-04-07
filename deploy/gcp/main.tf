// Configure GCP provider
provider "google" {
  credentials = var.creds != null ? file(var.creds) : null
  project = var.project_id
  region = var.region
  zone = var.zone != null ? var.zone : "${var.region}-a"
}

provider "google-beta" {
  credentials = var.creds != null ? file(var.creds) : null
  project = var.project_id
  region = var.region
  zone = var.zone != null ? var.zone : "${var.region}-a"
}

// Random integer to use if identifier not given
resource "random_integer" "naming_int" {
  min = 1000
  max = 9999
}

locals {
  unique_id = "${var.identifier}-${substr(replace(var.det_version, ".", "-"), 0, 8)}-${random_integer.naming_int.result}"
}


/******************************************
	VPC configuration
 *****************************************/

module "network" {
  source = "./modules/network"

  project_id = var.project_id
  unique_id = local.unique_id
  network = var.network
}


/******************************************
	Service Account configuration
 *****************************************/

module "service_account" {
  source = "./modules/service_account"

  project_id = var.project_id
  unique_id = local.unique_id
  service_account_email = var.service_account_email
}


/******************************************
	Static IP configuration
 *****************************************/

module "ip" {
  source = "./modules/ip"

  unique_id = local.unique_id
  create_static_ip = var.create_static_ip
}


/******************************************
	GCS configuration
 *****************************************/

module "gcs" {
  source = "./modules/gcs"

  unique_id = local.unique_id
  gcs_bucket = var.gcs_bucket
  service_account_email = module.service_account.service_account_email
}


/******************************************
	Database configuration
 *****************************************/

module "database" {
  source = "./modules/database"

  unique_id = local.unique_id
  db_tier = var.db_tier
  db_username = var.db_username
  db_password = var.db_password
  db_version = var.db_version
  network_self_link = module.network.network_self_link
}


/******************************************
        Firewall configuration
 *****************************************/

module "firewall" {
  source = "./modules/firewall"

  unique_id = local.unique_id
  network_name = module.network.network_name
  port = var.port
}


/******************************************
	Compute configuration
 *****************************************/

module "compute" {
  source = "./modules/compute"

  unique_id = local.unique_id
  project_id = var.project_id
  region = var.region
  environment_image = var.environment_image
  det_version = var.det_version
  scheme = var.scheme
  port = var.port
  master_docker_network = var.master_docker_network
  master_machine_type = var.master_machine_type
  agent_docker_network = var.agent_docker_network
  agent_machine_type = var.agent_machine_type
  max_idle_agent_period = var.max_idle_agent_period
  gpu_type = var.gpu_type
  gpu_num = var.gpu_num
  max_instances = var.max_instances
  preemptible = var.preemptible
  db_username = var.db_username
  db_password = var.db_password
  hasura_secret = var.hasura_secret

  network_name = module.network.network_name
  subnetwork_name = module.network.subnetwork_name
  static_ip = module.ip.static_ip_address
  service_account_email = module.service_account.service_account_email
  gcs_bucket = module.gcs.gcs_bucket
  database_hostname = module.database.database_hostname
  database_name = module.database.database_name
  tag_master_port = module.firewall.tag_master_port
  tag_allow_internal = module.firewall.tag_allow_internal
  tag_allow_ssh = module.firewall.tag_allow_ssh
}
