@echo off

echo start

if %1 == plan (
  echo plan
  echo %0
  cd %4
  terraform validate
  terraform plan -var-file ../env/%3.tfvars -out %3-plan.tfplan -var "project_name=%2" -var "env=%3"
) else if %1 == apply (
  cd %4
  terraform apply "%3-plan.tfplan"
) else if %1 == destroy (
  cd %4
  terraform destroy
)

echo finish
