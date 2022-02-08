#!/bin/bash
echo "export cdx_CLUSTER_NAME=$(terraform output -raw cluster_name)"
echo "export cdx_CLUSTER_REGION=$(terraform output -raw cluster_region)"
echo "export cdx_PGHOST=$(terraform output -raw db_instance_address)"
echo "export cdx_PGPORT=$(terraform output -raw db_instance_port)"
echo "export cdx_PGUSER=$(terraform output -raw db_instance_username)"
echo "export cdx_PGPASSWORD=$(terraform output -raw db_master_password)"
echo "export cdx_S3_BUCKET_NAME=$(terraform output -raw s3_bucket_name)"
echo "export cdx_S3_BUCKET_REGION=$(terraform output -raw s3_bucket_region)"