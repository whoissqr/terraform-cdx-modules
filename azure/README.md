# CNC-Azure

azure terraform automation work related to CNC .

Azure Cli needs to be installed to work with azure terraform automation modules . please refer https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
#### Get set up with azure

```bash
$ az login
```


clone the terraform modules from repo 


#### Create global resources
```bash
$ cd terraform-cnc-modules/azure/global
export TF_VAR_subscription_id ="YOUR AZURE SUBSCRIPTION ID"  # you can find the subscription id in azure portal
$ vi 1.auto.tfvars  # modify/add input values per your requirements in the 1.auto.tfvars file and save it 
$ terraform init
$ terraform plan 
$ terraform apply --auto-approve 
```
you can use sample values in 1.auto.tfvars as reference .
#### Create environment resources
```bash
$ cd terraform-cnc-modules/azure/environment
TF_VAR_subscription_id ="YOUR AZURE SUBSCRIPTION ID"
$ vi 1.auto.tfvars  # modify/add input values as per terraform output of your step-1(global-resource module) and save it
$ terraform init
$ terraform plan 
$ terraform apply --auto-approve
```





## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`resource_group_name` | The name of the resource group in which resources are created | string | `""`
`location`|The location of the resource group in which resources are created| string | `""`
`vnetwork_name`|The name of the virtual network| string | `""`
`vnet_address_space`|Virtual Network address space to be used |list|`[]`
`subnets`|For each subnet, create an object that contain fields|object|`{}`
`subnet_name`|A name of subnets inside virtual network| object |`{}`
`subnet_address_prefix`|A list of subnets address prefixes inside virtual network| list |`{}`
`gateway_subnet_address_prefix`|The address prefix to use for the gateway subnet|list|`null`
`firewall_subnet_address_prefix`|The address prefix to use for the Firewall subnet|list|`[]`
`service_endpoints`|service endpoints for the virtual subnet|object|`{}`
`cluster_endpoint_public_access_cidrs`|"List of CIDR blocks which can access the Azure AKS public API server endpoint|list(string)|`[]`
`default_node_pool_name`|name of the default node pool |string|`agentpool`
`default_node_pool_vm_size`|vm size of the default node pool|string|`Standard_DS2_v2`
`availability_zones`|availability zones for the cluster| list(string) | `["1","2"]`
`default_node_pool_os_disk_type`| OS disk type of the default nodepool | string | `Managed`
`os_disk_size_gb`|size of the os disk in gb| number | `128`
`default_node_pool_max_node_count`|maximum number of nodes on default node pool of the cluster| number | `5`
`default_node_pool_min_node_count`|minimum number of nodes on default node pool of the cluster| number | `1`
`identity_type` | The type of identity used for the managed cluster. Possible values are SystemAssigned and UserAssigned. If UserAssigned is set, a user_assigned_identity_id must be set as well | string |`SystemAssigned`
`network_plugin` | Network plugin to use for networking. Currently supported values are azure and kubenet. Changing this forces a new resource to be created. | string | `kubenet`
`custom_pool_name` | name of the custom node pool | string | `medium`
`custompool_vm_size` | vm size of the custom node pool(additional) | string | `Standard_D8as_v4`
`node_taints` | taints to be added to the nodes | list(string) | `["NodeType=ScannerNode:NoSchedule"]`
`custompool_os_disk_type` | additional nodepool os disk type | string | `Ephemeral`
`enable_auto_scaling` |  to enable the auto scaling | bool | `true`
`node_labels` | labels to be set to the nodes | map(string) | `{ "app" : "jobfarm","pool-type" : "medium"
  }`
`custompool_min_count` | minium number of nodes in custom node pool | number | `1`
`custompool_max_count` | maximum number of nodes in custom node pool | number | `5`
deploy_ingress_controller             | Flag to enable/disable the nginx-ingress-controller deployment in the aks cluster                    | `bool`         | `true`
| ingress_namespace                     | Namespace in which ingress controller should be deployed. If empty, then ingress-controller will be created | `string`       | `""`
`ingress_controller_helm_chart_version `| Version of the nginx-ingress-controller helm chart                                                   | `string`       | `3.35.0`
`ingress_white_list_ip_ranges`          | List of source ip ranges for load balancer whitelisting; we recommend you to pass the list of your organization source IPs. Note: You must add NAT IP of your existing VPC or 
| ingress_settings                      | Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx | `map("string")` | `{}`



## global Outputs

Name | Description
---- | -----------
`resource_group_name` | The name of the resource group in which resources are created
`rg_location`| The location of the resource group in which resources are created
`vnet_name` | The name of the virtual network.
`subnet_id` | subnet id of the virtual network
`publicip` | the nat ip 
`cluster_name` | name of the aks cluster created .

## Environment resources
### Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`prefix` | this is a unique value will be added as a prefix for resource name . | string |`""`
`rg_location` | location of azure resource group . you will get it from global | string | `westeurope`
`rg_name` | resouce group name , you will get it from global output .|string | `""`
`db_username` | Username for the master DB user. Note: Do NOT use 'user' as the value" | string | `psqladmin`
`db_password` | Password for the master DB user; If empty, then random password will be set by default. Note: This will be stored in the state file | string | `Synopsys@123`
`postgresql_version` | version of the postgresql database server | string | `"12"`
`vnet_subnetid` | vnet_subnetid to attached with storage account , you will get it from global output | list("string") | `[]`
`storage_firewall_ip_rules` | the whitelisted ip's for storage account access | list(string) | `[]`

## environment Outputs

Name | Description
---- | -----------
`fqdn` | fully qualified domain name of the postgres server
 `postgres_server_id` | id the postgresql server .
 `db_login` | username of the master database .
 `db_password` | password of the master database .
 `bucket` | azure storage bucket name 
 `storage_access_key` | access key which is used to access to storage bucket .
 `storageaccount_name` | name of azure storage account .


 while destroying , please destroy the environment resources first and then destroy the global resources .

 while destroying environment resources ,if you experience network or any connection issue ,then sometimes destroying the resources will fail . in such cases , just retry the terraform destroy command .