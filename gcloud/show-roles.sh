gcloud_service_account="example"
project="helloworld"
gcloud projects get-iam-policy ${project} --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:${gcloud_service_account}@${project}.iam.gserviceaccount.com"
