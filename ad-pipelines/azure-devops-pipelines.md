# Azure DevOps pipelines

There are two main pipelines;

Hub Platform -hub-clinical-platform-iac
Clinical Platform - app-clinical-platform-iac

These have two variables

loc - location
env - environment

Currently these are set to East US and Production.  These variables can be over-ridden at deployment time as a quick way to deploy to other locations or environments.

# Deploying to Multiple environments using a Pipeline

To allow us to deploy to multiple environments in one pipeline we need to edit the current pipeline.  To do this we need to move the pipeline variables to variable groups. For example, we could have a variable group for East US, Prod and one for East US Dev.  If these contain the variables for loc and env when we create our pipeline we have repeated stages.  In each stage we can reference the relevant variable group.  

```
- stage: terraform_apply
    variables:
    - group: cp-pfm-eaus-prd
    dependsOn: terraform_plan
    condition: and(succeeded('terraform_plan'), eq(${{parameters.apply}}, 'true'))
    jobs:
    - deployment: terraform_apply
      displayName: Terraform Apply ${{parameters.infrastructure_component}}
      environment: prd
      pool: 'Clinical-Platform-Hub'
      workspace:
        clean: all
      strategy:
        runOnce:
          deploy:
            steps:
            - checkout: self
            
            - task: replacetokens@3
              displayName: 'Replace tokens in static_variables files'
              inputs:
                targetFiles: |
                  $(System.DefaultWorkingDirectory)/${{parameters.infrastructure_component}}/*.tf
                  $(System.DefaultWorkingDirectory)/${{parameters.infrastructure_component}}/environment/*.tfvars
                encoding: 'auto'
                writeBOM: true
                actionOnMissing: 'warn'
                keepToken: false
                tokenPrefix: '#{'
                tokenSuffix: '}#'
                useLegacyPattern: false
                enableTelemetry: false
            
            - task: TerraformTaskV1@0
              inputs:
                provider: 'azurerm'
                command: 'init'
                workingDirectory: '$(System.DefaultWorkingDirectory)/${{parameters.infrastructure_component}}'
                backendServiceArm: 'Azure-DevOps-CP-Prod-SPN'
                backendAzureRmResourceGroupName: 'cp-tf-state-rg-$(loc)-$(env)'
                backendAzureRmStorageAccountName: 'cptfstr$(loc)$(env)'
                backendAzureRmContainerName: 'tfstate'
                backendAzureRmKey: '${{parameters.infrastructure_component}}.tfstate'

            - task: TerraformTaskV1@0
              inputs:
                provider: 'azurerm'
                command: 'apply'
                workingDirectory: '$(System.DefaultWorkingDirectory)/${{parameters.infrastructure_component}}'
                commandOptions: '-auto-approve -var-file="environment/$(env)-$(loc).tfvars"'
                environmentServiceNameAzureRM: 'Azure-DevOps-CP-Prod-SPN'
```