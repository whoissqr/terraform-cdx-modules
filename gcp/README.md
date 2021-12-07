## GCP Provider
Terraform creates the below GCP cloud resources by using the individual modules.
- [global-resources](./global-resources): This module will create the VPC network, subnetwork and GKE cluster.
- [environment](./environment): This module will create the CloudSQL instance, GCS bucket(if scanfarm_enabled is true) and deploy nginx-ingress-controller in it

## Global resources
### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| gcp_project                       | GCP project id to create the resources                                                               | `string`                                   | n/a                                        | yes      |
| gcp_region                        | GCP region to create the resources                                                                   | `string`                                   | n/a                                        | yes      |
| tags                              | GCP Tags to add to all resources created (wherever possible)                                         | `map("string")`                            | `{'product': 'cnc', 'automation': 'dns', 'managedby': 'terraform'}` | no       |
| prefix                            | Prefix to use for objects that need to be created. This must be unique                               | `string`                                   | n/a                                        | yes      |
| vpc_name                          | Name of the existing VPC; if empty VPC will be created                                               | `string`                                   | `""`                                       | no       |
| vpc_cidr_block                    | CIDR block for the VPC subnet. Default: 10.0.0.0/16                                                  | `string`                                   | `10.0.0.0/16 `                             | no       |
| vpc_secondary_range_pods          | Secondary subnet range in the VPC network for pods. Default: 172.16.0.0/16                           | `string`                                   | `172.16.0.0/16`                            | no       |
| vpc_secondary_range_services      | Secondary subnet range in the VPC network for services. Default: 192.168.0.0/19                      | `string`                                   | `192.168.0.0/19`                           | no       |
| subnet_private_access             | Enable private access for the subnet                                                                 | `bool`                                     | `true`                                     | no       |
| subnet_flow_logs                  | Enable vpc flow logs for the subnet                                                                  | `bool`                                     | `false`                                    | no       |
| subnet_flow_logs_interval         | subnet flow log interval                                                                             | `string`                                   | `INTERVAL_5_SEC`                           | no       |
| subnet_flow_logs_sampling         | subnet flow logs sampling                                                                            | `string`                                   | `1`                                        | no       |
| subnet_flow_logs_metadata         | Subnet flow logs type                                                                                | `string`                                   | `INCLUDE_ALL_METADATA`                     | no       |
| cloud_nat_logs_enabled            | Enable logging for the CloudNAT                                                                      | `bool`                                     | `false`                                    | no       |
| cloud_nat_logs_filter             | Log level for the CloudNAT                                                                           | `string`                                   | `ERRORS_ONLY`                              | no       |
| vpc_subnet_name                   | Existing VPC subnet name in which cluster has to be created                                          | `string`                                   | `""`                                       | no       |
| vpc_pod_range_name                | Existing VPC pod range name to create the cluster; keep it empty to  dynamically create                                                    | `string`                                   | `""`                                       | no       |
| vpc_service_range_name            | Existing VPC service range name to create the cluster; keep it empty to  dynamically create                                                | `string`                                   | `""`                                       | no       |
| master_ipv4_cidr_block            | Master ipv4 cidr range to create the cluster. Default: 192.168.254.0/28                              | `string`                                   | `192.168.254.0/28`                         | no       |
| kubernetes_version                | Kubernetes version of the GKE cluster                                                                | `string`                                   | `1.19.0`                                   | no       |
| release_channel                   | The release channel of this cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE. Defaults to UNSPECIFIED | `string`                                   | `UNSPECIFIED`                              | no       |
| master_authorized_networks_config | List of CIDR blocks which can access the Google GKE public API server endpoint. Default: open-to-all i.e 0.0.0.0/0 | `list("object({cidr_block:"string",display_name:"string"})")` | `[{'display_name': 'open-to-all', 'cidr_block': '0.0.0.0/0'}]` | no       |
| default_node_pool_machine_type    | Machine type of each node in a default node pool                                                     | `string`                                   | `n1-standard-8`                            | no       |
| default_node_pool_image_type      | Image type of each node in a default node pool                                                       | `string`                                   | `COS_CONTAINERD`                           | no       |
| default_node_pool_disk_size       | Disk size in gb for each node in a default node pool                                                 | `number`                                   | `50`                                       | no       |
| default_node_pool_disk_type       | Disk type of each node in a default node pool. Options are pd-standard and pd-ssd                    | `string`                                   | `pd-ssd`                                   | no       |
| default_node_pool_min_size        | Min number of nodes in a default node pool                                                           | `number`                                   | `1`                                        | no       |
| default_node_pool_max_size        | Max number of nodes in a default node pool                                                           | `number`                                   | `5`                                        | no       |
| jobfarm_node_pool_machine_type    | Machine type of each node in a jobfarm node pool                                                     | `string`                                   | `c2-standard-8`                            | no       |
| jobfarm_node_pool_image_type      | Image type to each node in a jobfarm node pool                                                       | `string`                                   | `COS_CONTAINERD`                           | no       |
| jobfarm_node_pool_disk_size       | Disk size in gb for each node in a jobfarm node pool                                                 | `number`                                   | `100`                                      | no       |
| jobfarm_node_pool_disk_type       | Disk type of each node in a jobfarm node pool. Options are pd-standard and pd-ssd                    | `string`                                   | `pd-ssd`                                   | no       |
| jobfarm_node_pool_min_size        | Min number of nodes in a jobfarm node pool                                                           | `number`                                   | `0`                                        | no       |
| jobfarm_node_pool_max_size        | Max number of nodes in a jobfarm node pool                                                           | `number`                                   | `50`                                       | no       |
| preemptible_jobfarm_nodes         | Flag to enable preemptible nodes in a jobfarm node pool                                              | `bool`                                     | `false`                                    | no       |
| jobfarm_node_pool_taints          | Taints for the jobfarm node pool                                                                     | `list("any")`                              | `[{'key': 'NodeType', 'value': 'ScannerNode', 'effect': 'NO_SCHEDULE'}]` | no       |

### Outputs
| Name | Description |
|------|-------------|
| gcp_network_name | The name of the VPC network |
| gcp_subnet_name | The name of the VPC subnet |
| gcp_nat_public_ip | The public IP created for GCP Cloud NAT Gateway; will be empty if VPC is created outside of this module |
| gcp_network_self_link | The URI of the VPC being created; will be empty if VPC is created outside of this module |
| gcp_cluster_name | The name of the GKE cluster |
| gcp_cluster_region | The GCP region this GKE cluster resides in |

## Environment resources
### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| gcp_project                           | GCP project id to create the resources                                                               | `string`       | n/a                                      | yes      |
| gcp_region                            | GCP region to create the resources                                                                   | `string`       | n/a                                       | yes      |
| tags                                  | GCP Tags to add to all resources created (wherever possible)                                         | `map("string")` | `{'product': 'cnc', 'automation': 'dns', 'managedby': 'terraform'}` | no       |
| prefix                                | Prefix to use for objects that need to be created. This must be unique                                                    | `string`       | n/a                                       | yes      |
| gcp_network_self_link                 | Name of the existing VPC network self link. Format looks like: https://www.googleapis.com/compute/v1/projects/{gcp_project}/global/networks/{vpc_name} | `string`       | n/a                                       | yes      |
| gcp_cluster_name                      | Name of the existing GKE cluster to deploy ingress / create secrets                         | `string`       | n/a                                       | yes      |
| bucket_name                           | Name of the gcs bucket; if empty, then gcs bucket will be created                                    | `string`       | `""`                                     | no       |
| bucket_region                         | Region of the gcs bucket                                                                             | `string`       | `US`                                     | no       |
| expire_after                          | No.of days for expiration of gcs objects                                                             | `string`       | `30`                                     | no       |
| db_name                               | Name of the CloudSQL instance; if empty, then CloudSQL instance will be created                      | `string`       | `""`                                     | no       |
| db_tier                               | The machine type to use for CloudSQL instance                                                        | `string`       | `db-custom-2-4096`                       | no       |
| db_version                            | Postgres database version                                                                            | `string`       | `POSTGRES_11`                           | no       |
| db_availability                       | The availability type of the CloudSQL instance                                                       | `string`       | `ZONAL`                                  | no       |
| db_size_in_gb                         | Storage size in gb of the CloudSQL instance                                                          | `number`       | `10`                                     | no       |
| database_flags                        | database_flags for CloudSQL instance                                                                 | `map("any")`   | `{}`                                     | no       |
| db_username                           | Username for the master DB user. Note: Do NOT use 'user' as the value                                | `string`       | `postgres`                               | no       |
| db_password                           | Password for the master DB user; If empty, then random password will be set by default. Note: This will be stored in the state file | `string`       | `""`                                     | no       |
| db_ipv4_enabled                       | Whether this Cloud SQL instance should be assigned a public IPV4 address. Either ipv4_enabled must be enabled or a private_network must be configured. | `bool`         | `false`                                  | no       |
| db_require_ssl                        | Whether SSL connections over IP are enforced or not; if this is true, then certs will be stored in additional k8s secret(`cnc-db-ssl-cert`) | `bool`         | `false`                                  | no       |
| maintenance_window_day                | The maintenance window is specified in UTC time                                                      | `number`       | `7`                                      | no       |
| maintenance_window_hour               | The maintenance window is specified in UTC time                                                      | `number`       | `9`                                      | no       |
| deploy_ingress_controller             | Flag to enable/disable the nginx-ingress-controller deployment in the GKE cluster                    | `bool`         | `true`                                   | no       |
| ingress_namespace                     | Namespace in which ingress controller should be deployed. If empty, then ingress-controller will be created | `string`       | `""`                                     | no       |
| ingress_controller_helm_chart_version | Version of the nginx-ingress-controller helm chart                                                   | `string`       | `3.35.0`                                 | no       |
| ingress_white_list_ip_ranges          | List of source ip ranges for load balancer whitelisting; we recommend you to pass the list of your organization source IPs. Note: You must add NAT IP of your existing VPC or `gcp_nat_public_ip` output value from global module to this list | `list("string")` | `['0.0.0.0/0']`                          | no       |
| ingress_settings                      | Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx | `map("string")` | `{}`                                     | no       |
| app_namespace                         | Namespace of existing cluster in which secrets can be created; if empty, then namespace will be created with prefix value | `string`       | `""`                                     | no       |
<!-- | create_db_secret                      | Flag to enable/disable the 'cnc-db-credentials' secret creation in the eks cluster                   | `bool`         | `true`                                   | no       |
| create_gcs_secret                     | Flag to enable/disable the 'cnc-gcs-credentials' secret creation in the gke cluster                  | `bool`         | `true`                                   | no       |
| db_host                               | Host addr of the CloudSQL instance                                                                   | `string`       | `""`                                     | no       |
| db_port                               | Port number of CloudSQL instance                                                                 | `number`       | `5432`                                   | no       | -->

### Outputs
| Name | Description |
|------|-------------|
| gcp_project_id | The ID of the GCP project |
| gcp_cluster_name | The name of the GKE cluster |
| gcp_cluster_region | The GCP region this GKE cluster resides in |
| gcs_bucket_name | The name of the GCS bucket |
| gcs_bucket_region | The region where GCS bucket resides in |
| db_instance_name | The name of the CloudSQL instance |
| db_instance_address | The address of the CloudSQL instance |
| db_instance_username | The master username for the CloudSQL instance |
| db_master_password | The master password for the CloudSQL instance |
<!-- | namespace | The namespace in the GKE cluster where secrets resides in | -->

## Creating the CNC infrastructure on GCP

### Prerequisites
Make sure you install terraform
```bash
brew install terraform
```
If you have already installed, then make sure it's up-to-date
```bash
brew upgrade terraform
```
Clone this repository
```bash
$ git clone git@github.com:Synopsys-SIG-RnD/terraform-cnc-modules.git
$ cd terraform-cnc-modules/gcp
```
**Notes:**
- You must have project Admin access (should be able to create IAM roles and service accounts) to create [environment](./gcp/environment) resources.
- Terraform variable values can be passed in different ways. Please refer [this page](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence) if you want to use a different way.
- We recommend you to set your organization's CIDR ip ranges as `master_authorized_networks_config` value and also set `ingress_white_list_ip_ranges` value as per your requirement.
- Per your use case, you have to run `terraform apply` in [global-resources](./gcp/global-resources) and [environment](./gcp/environment) to create complete CNC infrastructure.
- To create scanfarm resources in both global and environment folders, you need to set `scanfarm_enabled` flag value as true.

### Complete infrastructure creation
Here, terraform will create all the required resources from the scratch. First, we will create global-resources and then environment resources. You can tweak the `terraform.tfvars.example` file in each module per your use case.

#### Get set up with gcloud

```bash
$ gcloud auth application-default login
```

#### Create global resources
```bash
$ cd terraform-cnc-modules/gcp/global-resources
$ vi terraform.tfvars.example # modify/add input values per your requirements and save it
$ terraform init
$ terraform plan -var-file="terraform.tfvars.example"
$ terraform apply --auto-approve -var-file="terraform.tfvars.example"
```
#### Create environment resources
```bash
$ cd terraform-cnc-modules/gcp/environment
$ vi terraform.tfvars.example # modify/add input values as per terraform output of your step-1(global-resource module) and save it
$ terraform init
$ terraform plan -var-file="terraform.tfvars.example"
$ terraform apply --auto-approve -var-file="terraform.tfvars.example"
```

### Complete infrastructure deletion
We have to follow reverse order while deleting the resources.

**Note:** Due to weird behavior of terraform, the cloudsql instance will be deleted before deleting the google_sql_user in it. To overcome this problem, we are removing the `google_sql_user` resource from the terraform state file manually.
#### Remove environment resources
```bash
$ cd terraform-cnc-modules/gcp/environment
$ terraform state list | grep google_sql_user | xargs -I fl terraform state rm fl
$ terraform destroy --auto-approve -var-file="terraform.tfvars.example"
```
#### Remove global resources
```bash
$ cd terraform-cnc-modules/gcp/global-resources
$ terraform destroy --auto-approve -var-file="terraform.tfvars.example"
```
