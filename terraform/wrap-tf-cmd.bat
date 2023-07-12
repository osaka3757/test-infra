@echo off

echo start

if %1 == plan (
  echo plan
  echo %0
  echo %5
  cd %4
  terraform validate
  terraform plan -out %3-plan.tfplan -var "project_name=%2" -var "env=%3" -var "profile=%5" -var-file "../.env/stg_var.tf"
) else if %1 == apply (
  cd %4
  terraform apply "%3-plan.tfplan"
) else if %1 == destroy (
  cd %4
  terraform destroy  -var "project_name=%2" -var "env=%3" -var "profile=%5" -var-file "../.env/stg_var.tf"
)

echo finish
