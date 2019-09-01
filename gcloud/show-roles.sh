gcloud_service_account="${1}"
project="${2}"
gcloud projects get-iam-policy ${project} --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:${gcloud_service_account}@${project}.iam.gserviceaccount.com"
