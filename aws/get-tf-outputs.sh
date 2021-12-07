#!/bin/bash
echo "export CNC_CLUSTER_NAME=$(terraform output -raw cluster_name)"
echo "export CNC_CLUSTER_REGION=$(terraform output -raw cluster_region)"
echo "export CNC_PGHOST=$(terraform output -raw db_instance_address)"
echo "export CNC_PGPORT=$(terraform output -raw db_instance_port)"
echo "export CNC_PGUSER=$(terraform output -raw db_instance_username)"
echo "export CNC_PGPASSWORD=$(terraform output -raw db_master_password)"
echo "export CNC_S3_BUCKET_NAME=$(terraform output -raw s3_bucket_name)"
echo "export CNC_S3_BUCKET_REGION=$(terraform output -raw s3_bucket_region)"