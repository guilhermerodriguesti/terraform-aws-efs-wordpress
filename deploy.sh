#!/bin/sh
export AWS_ACCESS_KEY_ID="AKIA4VLBOTSYTDZ63UZB"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-east-1"

echo "*** Deployment started"


echo "----------------------------------------"
echo "Formatting terraform files"
terraform fmt
echo "----------------------------------------"
#terraform init
echo "----------------------------------------"
echo "Validating terraform files"
terraform validate
echo "----------------------------------------"
echo "Planning..."
terraform plan
echo "----------------------------------------"
echo "Applying..."
terraform apply -auto-approve
echo "----------------------------------------"
#terraform destroy -auto-approve
echo "Done!"
echo "----------------------------------------"