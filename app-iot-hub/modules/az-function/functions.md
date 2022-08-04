# Azure Functions

## Infrastructure / IaC

The Azure functions are deployed using a Terraform module this is stored in the folder `\modules\az-function\`.  The module deploys the following resources;

* Resource Group
* Storage Account
* App Service Plan
* Azure function app

To deploy a new Function take a copy of one of the files like `quest-function.tf` this calls the modules and passes all teh required variables. On the file you copy you will need to update the following;

* Update the requirements as needed for your app
    * Kind
    * SKU
    * Tier
    * Update Docker image 
    * Update custom app Settings

## Known config requirements

* You can not deploy Linux and Windows App Service plans to the same RG.  Our functions deploy to their own RG.
* You can not configure ```always_on = true``` for Free skus or Elastic Premium 


## Pipeline deployment

The pipeline used to deploy this using Azure DevOps is:

Azure DevOps-> Pipelines-> Clinical Application -> app-clinical-platform-iac

When you run the pipeline for 'Infrastructure component' choose is `app-functions`. There are some functions that are associated with the IoT hub and these are deployed alongside the IoT resources when you run the `app-iot-hub` pipeline

## Application

The pipeline to deploy the code to the Functions has not been created yet.