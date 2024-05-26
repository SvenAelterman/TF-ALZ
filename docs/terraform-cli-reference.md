# `terraform` reference for ALZ deployments

Terraform uses the AZ CLI. Verify `az` is installed and available with a recent version.

```bash
az --version
```

Verify Terraform is installed on the local host.

```terraform
terraform --version
```

Create a plan for the deployment of any Terraform file and save the plan output.

```HCL
terraform plan -out ./alz.plan
```

Show the output of the plan. This output is also shown after running `terraform plan`.

```HCL
terraform show ./alz.plan
```

Apply the Terraform to the environment. This will run a new plan and ask for confirmation to apply.

```terraform
terraform apply
```

Apply the previously planned deployment. This will not ask for confirmation.

```HCL
terraform apply ./alz.plan
```
