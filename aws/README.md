## AWS Provider
Terraform creates the below AWS cloud resources by using the individual modules.
- [VPC](./vpc): This module will create the VPC and subnets in it
- [EKS Cluster](./eks-cluster): This module will create the EKS cluster and deploy cluster-autoscaler, nginx-ingress-controller in it
- [RDS Instance](./rds-instance): This module will create the RDS instance and related security group rules
<!-- - [Kubernetes secrets (with RDS/S3 details)](./secrets): This module will create the kubernetes namespace and required secrets in it -->

