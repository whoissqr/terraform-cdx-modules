#!/bin/bash
echo "export CNC_CLUSTER_NAME=$(terraform output -raw gcp_cluster_name)"
echo "export CNC_CLUSTER_REGION=$(terraform output -raw gcp_cluster_region)"
echo "export GCP_PROJECT_ID=$(terraform output -raw gcp_project_id)"
echo "export CNC_PGHOST=$(terraform output -raw db_instance_address)"
echo "export CNC_PGUSER=$(terraform output -raw db_instance_username)"
echo "export CNC_PGPASSWORD=$(terraform output -raw db_master_password)"
echo "export CNC_GCS_BUCKET_NAME=$(terraform output -raw gcs_bucket_name)"
TMP_FILE=$(mktemp)
echo "$(terraform output -raw gcs_service_account)" > "${TMP_FILE}"
echo "export CNC_GCS_SERVICE_ACCOUNT_FILE=${TMP_FILE}"