#!/bin/bash
cd ../global
echo "export CNC_CLUSTER_NAME=$(terraform output -raw cluster_name)"
echo "export CNC_CLUSTER_REGION=$(terraform output -raw rg_location)"
echo "export AZ_RESOURCE_GROUP=$(terraform output -raw rg_name)"
cd ../environment
echo "export CNC_PGHOST=$(terraform output -raw fqdn)"
echo "export CNC_PGUSER=$(terraform output -raw db_login)"
echo "export CNC_PGPASSWORD=$(terraform output -raw db_password)"
echo "export CNC_AZ_BUCKET_NAME=$(terraform output -raw bucket)"
echo "export CNC_AZ_SA_SECRET_NAME=$(terraform output -raw storageaccount_name)"
echo "export CNC_AZ_SA_SECRET_KEY=$(terraform output -raw storage_access_key)"

