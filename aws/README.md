## AWS Provider
Terraform creates the below AWS cloud resources by using the individual modules.
- [VPC](./vpc): This module will create the VPC and subnets in it
- [EKS Cluster](./eks-cluster): This module will create the EKS cluster and deploy cluster-autoscaler, nginx-ingress-controller in it
- [S3 Bucket](./s3-bucket): This module will create the S3 bucket
- [RDS Instance](./rds-instance): This module will create the RDS instance and related security group rules
<!-- - [Kubernetes secrets (with RDS/S3 details)](./secrets): This module will create the kubernetes namespace and required secrets in it -->

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_access_key                        | AWS access key to create the resources                         | `string`                | n/a                                      | yes     |
| aws_secret_key                        | AWS secret key to create the resources                         | `string`                | n/a                                      | yes     |
| aws_region                            | AWS region to create the resources                             | `string`                | n/a                                      | yes     |
| tags                                  | AWS Tags to add to all resources created (wherever possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/   | `map(string)`               | `{'product': 'cnc', 'automation': 'dns', 'managedby': 'terraform'}` | no     |
| prefix                                | Prefix to use for objects that need to be created (only alphanumeric characters and hyphens allowed) `Note: hyphens will be removed from prefix for RDS, S3 and namespace resources`    | `string`                      | n/a        | yes     |
| vpc_id                                | ID of the existing VPC; if empty, then VPC will be created     | `string`                                 | `""`                                       | no      |
| vpc_cidr_block                        | CIDR block for the VPC                                         | `string`                                 | `"10.0.0.0/16"`                            | no      |
| cluster_name                          | Name of the existing EKS cluster; if empty, then EKS cluster will be created        | `string`                                                                               | `""`                                       | no      |
| map_users                             | Additional IAM users to add to the aws-auth configmap                               |  ```list(object({ userarn  = string username = string groups   = list(string) }))```   | `[]`                                       | no      |
| kubernetes_version                    | Kubernetes version of the EKS cluster                                               | `string`                                                                               | `"1.19"`                                   | no      |
| cluster_endpoint_public_access_cidrs  | List of CIDR blocks which can access the Amazon EKS public API server endpoint. `Note: by default its open to all, we recommend to set your org CIDR blocks`                    | `list(string)`                       | `['0.0.0.0/0']`                            | no      |
| deploy_autoscaler                     | Flag to enable/disable the cluster-autoscaler deployment in the eks cluster         | `bool`              | `true`                                     | no      |
| cluster_autoscaler_helm_chart_version | Version of the cluster-autoscaler helm chart                                        | `string`            | `"9.10.4"`                                 | no      |
| deploy_ingress_controller             | Flag to enable/disable the nginx-ingress-controller deployment in the eks cluster   | `bool`              | `true`                                     | no      |
| ingress_controller_helm_chart_version | Version of the nginx-ingress-controller helm chart                                  | `string`            | `"3.35.0"`                                 | no      |
| default_node_pool_instance_type       | Instance type of each node in a default node pool                                   | `string`            | `"c5d.2xlarge"`                            | no      |
| default_node_pool_ami_type            | Type of Amazon Machine Image (AMI) associated with the EKS Node Group               | `string`            | `"AL2_x86_64"`                             | no      |
| default_node_pool_disk_size           | Disk size in gb for each node in a default node pool                                | `number`            | `50`                                       | no      |
| default_node_pool_capacity_type       | Type of instance capacity to provision default node pool. Options are `ON_DEMAND` and `SPOT`              | `string`                  | `"ON_DEMAND"`              | no      |
| default_node_pool_min_size            | Min number of nodes in a default node pool                                                                | `number`                  | `3`                        | no      |
| default_node_pool_max_size            | Max number of nodes in a default node pool                                                                | `number`                  | `9`                        | no      |
| jobfarm_node_pool_instance_type       | Instance type of each node in a jobfarm node pool                                                         | `string`                  | `"c5d.2xlarge"`            | no      |
| jobfarm_node_pool_ami_type            | Type of Amazon Machine Image (AMI) associated with the EKS Node Group                                     | `string`                  | `"AL2_x86_64"`             | no      |
| jobfarm_node_pool_disk_size           | Disk size in gb for each node in a jobfarm node pool                                                      | `number`                  | `100`                      | no      |
| jobfarm_node_pool_capacity_type       | Type of instance capacity to provision jobfarm node pool. Options are `ON_DEMAND` and `SPOT`              | `string`                  | `"SPOT"`                   | no      |
| jobfarm_node_pool_min_size            | Min number of nodes in a jobfarm node pool                                                                | `number`                  | `0`                        | no      |
| jobfarm_node_pool_max_size            | Max number of nodes in a jobfarm node pool                                                                | `number`                  | `50`                       | no      |
| bucket_name                           | Name of the S3 bucket; if empty, then S3 bucket will be created                                           | `string`                  | `""`                       | no      |
| expire_after                          | No.of days for expiration of S3 objects                                                                   | `string`                  | `"30"`                     | no      |
| db_name                               | Name of the RDS instance; if empty, then RDS instance will be created                                     | `string`                  | `""`                       | no      |
| db_postgres_version                   | Postgres version of the RDS instance                                                                      | `string`                  | `"11"`                    | no      |
| db_username                           | Username for the master DB user. `Note: Do NOT use 'user' as the value`                                   | `string`                  | `"postgres"`               | no      |
| db_password                           | Password for the master DB user; If empty, then random password will be set by default. `Note: This will be stored in the state file` | `string`       | `""`      | no      |
| db_public_access                      | Bool to control if instance is publicly accessible                                                        | `bool`                    | `false`                    | no      |
| db_instance_class                     | Instance type of the RDS instance                                                                         | `string`                  | `"db.t2.small"`            | no      |
| db_size_in_gb                         | Storage size in gb of the RDS instance                                                                    | `number`                  | `10`                       | no      |
| db_port                               | Port number on which the DB accepts connections                                                           | `number`                  | `5432`                     | no      |
<!-- | create_db_secret                      | Flag to enable/disable the `cnc-db-credentials` secret creation in the eks cluster                        | `bool`                    | `true`                     | no      |
| create_s3_secret                      | Flag to enable/disable the `cnc-s3-credentials` secret creation in the eks cluster                        | `bool`                    | `true`                     | no      | -->

## Outputs
| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_public_subnets | List of IDs of public subnets |
| vpc_private_subnets | List of IDs of private subnets |
| vpc_nat_public_ips | List of public Elastic IPs created for AWS NAT Gateway |
| cluster_name | The name of the EKS cluster |
| cluster_region | The AWS region this EKS cluster resides in |
| s3_bucket_name | The name of the S3 bucket |
| s3_bucket_region | The AWS region this S3 bucket resides in |
| db_instance_name | The name of the RDS instance |
| db_instance_address | The address of the RDS instance |
| db_instance_port |The database port of the RDS instance |
| db_instance_username | The master username for the RDS instance |
| db_master_password | The master password for the RDS instance |
| db_subnet_group_id | The subnet group name of the RDS instance |
<!-- | namespace | The namespace in the EKS cluster where secrets resides in | -->


## Creating the CNC infrastructure on AWS

### Prerequisites
Make sure you install the terraform
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
$ cd terraform-cnc-modules/aws
$ export TF_VAR_aws_access_key="<aws_access_key>"
$ export TF_VAR_aws_secret_key="<aws_secret_key>"
$ export TF_VAR_aws_region="<aws_region>"
$ export TF_VAR_prefix="<unique_prefix_str>"
```
**Notes:**
- You can follow these [instructions](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/) to get access and secret key from AWS.
- Terraform variable values can be passed in different ways. Please refer [this page](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence) if you want to use a different way.
- We recommend you to set your organization's CIDR ip ranges as `cluster_endpoint_public_access_cidrs` value and also set `map_users` value as per your requirement.
- To create scanfarm resources, you need to set `scanfarm_enabled` flag value as true.

### Scenario-1: Complete infrastructure creation
Here, terraform will create all the required resources from the scratch (set `scanfarm_enabled` flag value as true to create scanfarm resources).
```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

### Scenario-2: Infrastructure creation with existing VPC
Here, terraform will create the EKS cluster, RDS instance and deploy cluster-autoscaler, nginx-ingress-controller in the cluster. if `scanfarm_enabled` is true, then it will also create the S3 bucket.
```bash
$ export TF_VAR_prefix="cnc"
$ export TF_VAR_vpc_id="vpc-07dc99f9a6682xxxx"
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

### Scenario-3: Infrastructure creation with existing VPC and EKS cluster
Here, terraform will try to deploy cluster-autoscaler, nginx-ingress-controller in the existing EKS cluster and then create the RDS instance. if `scanfarm_enabled` is true, then it will also create the S3 bucket.
```bash
$ export TF_VAR_prefix="cnc"
$ export TF_VAR_vpc_id="vpc-07dc99f9a6682xxxx"
$ export TF_VAR_cluster_name="cnc-cluster"
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
**Note:** If cluster-autoscaler and nginx-ingress-controller is already deployed in your eks cluster, then set the respective flags to `false`

<!-- ### Scenario-4: Infrastructure creation with existing VPC, EKS cluster and S3 bucket
Here, terraform will create the RDS instance.
```bash
$ export TF_VAR_prefix="cnc"
$ export TF_VAR_vpc_id="vpc-07dc99f9a6682xxxx"
$ export TF_VAR_cluster_name="cnc-cluster"
$ export TF_VAR_bucket_name="cnc-uploads-bucket"
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
``` -->

<!-- ### Scenario-5: Infrastructure creation with existing VPC, EKS cluster, S3 bucket and RDS instance
Here, terraform will create the namespace and two kubernetes secrets (`cnc-db-credentials`, `cnc-s3-credentials`) in it.
```bash
$ export TF_VAR_prefix="cnc"
$ export TF_VAR_vpc_id="vpc-07dc99f9a6682xxxx"
$ export TF_VAR_cluster_name="cnc-cluster"
$ export TF_VAR_bucket_name="cnc-uploads-bucket"
$ export TF_VAR_db_name="cnc-postgres"
$ export TF_VAR_db_password="<random_password>"
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
**Note:** As terraform can't read the db password from existing db, You MUST pass `db_password` variable value along with `db_name` -->
