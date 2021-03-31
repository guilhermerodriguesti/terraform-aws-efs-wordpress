#!/bin/sh


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


