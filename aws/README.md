## AWS Provider
Terraform creates the below AWS cloud resources by using the individual modules.
- [VPC](./vpc): This module will create the VPC and subnets in it
- [EKS Cluster](./eks-cluster): This module will create the EKS cluster and deploy cluster-autoscaler, nginx-ingress-controller in it
- [RDS Instance](./rds-instance): This module will create the RDS instance and related security group rules
<!-- - [Kubernetes secrets (with RDS/S3 details)](./secrets): This module will create the kubernetes namespace and required secrets in it -->

### preparation
- setup your *aws_access_key, aws_secret_key and aws_region* in [terraform.tfvars.example](terraform.tfvars.example)
- change default RDS *db_port, db_username and db_password* in [variables.tf](variables.tf)


### setup the infra in AWS
```
terraform init
terraform plan -var-file="terraform.tfvars.example"
terraform apply --auto-approve -var-file="terraform.tfvars.example"
```

### switching k8s context
```
aws eks --region ap-southeast-1 update-kubeconfig --name cdx-cluster
```

### install Code DX
```
pwsh run-setup.ps1
```

### getting URL to Code DX web portal
```
k get svc -n cdx-app
NAME     TYPE           CLUSTER-IP      EXTERNAL-IP                                                                    PORT(S)         AGE
codedx   LoadBalancer   172.20.112.54   a9479388e576d4c9a97adb40532bab5b-2136137298.ap-southeast-1.elb.amazonaws.com   443:30815/TCP   8m52s
```
