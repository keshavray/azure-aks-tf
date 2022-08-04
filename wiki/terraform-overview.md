# Terraform & Pipeline Overview

## Bootstrap

To use a Azure storage as the backend for Terraform we need to deploy the storage before we start using the pipelines. This is not currently included in the pipeline and requires you to run a script to deploy the storage account. The script can be found in ```/bootstrap/hub-storage.ps1``` and ```/bootstrap/app-storage.ps1```

## Hub and Application code

The hub resources are deployed to Azure using Terraform configuration. The code is stored in the repo <https://dev.azure.com/OxfordVR/Platform%202/_git/azure-iac>

App code is prefixed with `app-`.

## Stages

Each folder in the repo represents a different stage of the deployment.  Resources get deployed in these stages with each stage having it's own terraform state file.

We can have different regions and environments to enable us to deploy these we have different ```.tfvars``` files these are stored in an ```environment``` folder in each stage .  Each folder is structured as;

Resource

* ```\environment``` - Folder for the different region and environment variables
  * pr-eaus.tfvars - variables for production East US
  * New files can be added for new regions and environments
* ```*.tf``` - files for each resource
* ```providers.tf``` - provider configuration and backend state config
* ```data.tf``` - data lookup resources
* ```outputs.tf``` - outputs form the deployed resources
* ```terraform.tfvars``` - variables file
* ```locals.tf``` - tags and other variables

## Naming conventions

We use the join method constructed from variables to construct the resource names meaning we can consistently apply a naming convention across all resources.  This also means by changing a variable for environment or location means you can re-use your templates to deploy across multiple environments or regions.  Below is an example of how we name a vnet resources using the join method.

```hcl
  name                = join("-", [var.product, var.role, "vnet", var.location, var.environment])
```

## Tagging

We use a locals.tf file to create a map of tags providing a key and value pair of tags to apply to resources.  We use variables to assign the values, meaning as you deploy to different environments/applications the tags will update as you update the variables.

```hcl
locals {
  tags = {
    product     = var.product
    environment = var.environment
    squad       = var.squad
    description = var.description
    tfstate     = "https://${var.tfstate_store}.blob.core.windows.net/tfstate/${var.tfstate}"
  }
}
```

This allows us to add tags to all resources using this map.  Add the code below to apply tags to resources.  When you need to change or add tags it means you can do this in one place per stage rather than on each resource.

```JSON
    tags = local.tags
```

## Azure DevOps

The Azure code is deployed from Azure DevOps <https://dev.azure.com/OxfordVR/Platform%202/>. In the repo there is a folder called `ad-pipelines` this contains the yaml pipelines for deploying the hub and application resources. These pipelines carry out the Terraform init, plan and apply.  When you run a pipeline you select the stage you want to run, you also get to tick a box to say whether you want to run the `Terraform apply`.  This allows you to just run the `Terraform plan`.

Even if you tick the box to run the apply there is an approval gate which will pause before running the apply giving you the opportunity to review the IaC changes before confirming you are happy top proceed and run the apply.

## Running a Pipeline stage

* In the the Azure DevOps portal in project ```Platform 2```
* Got to ```Pipelines```
* Click ```hub-clinical-platform-iac``` or for application Infrastructure ```app-clinical-platform-iac```
* Click ```Run Pipeline```
  * Select the branch
  * Select the infrastructure component this relates to the folder or stage you want to run
  * Tick the ```Run Apply``` tick box or leave unticked to only run a ```Terraform Plan```
* Click ```Run```
* Review the logs to see what changes will be made in Azure
* If you ticked to run the Apply you will need to approve the pipeline after the plan stage
