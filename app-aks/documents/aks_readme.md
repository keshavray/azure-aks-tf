# Azure Kubernetes Service (AKS) 

## Configuring the credentials for Kubernetes

This command downloads credentials and configures the Kubernetes CLI to use them.
```PowerShell
az aks get-credentials --resource-group $RGName --name $AKSclusterName --overwrite-existing
```
#You need --overwrite-existing when re-building a cluster with the same name otherwise you get an error as it has cached old creds

#List the nodepools in the cluster to check you have both
```PowerShell
az aks nodepool list --resource-group $RGName --cluster-name $AKSclusterName 
```
#If you need to delete a node in the pool update the name of the pool below
#az aks nodepool delete  --cluster-name $AKSclusterName  --resource-group $RGName --name "linnp1"

#kubectl command to get the nodes and their current status
```BASH
kubectl get nodes
```

## AKS post deployment 

### Install AAD PodIdentity

https://github.com/Azure/aad-pod-identity 

https://azure.github.io/aad-pod-identity/docs/demo/standard_walkthrough/ 

We want to deploy AAD Pod identity to the kube-system workspace, to do this run the following commands once authenticated to the cluster.

```helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts```
```helm install aad-pod-identity aad-pod-identity/aad-pod-identity -n kube-system```

## Helm / k8s troubleshooting

As we install services into namespaces we need to reference this when browsing to the resources
```Bash
helm ls -n <service-name> 
```
If you need to delete a service deployed with Helm use Helm to delete as well
```Bash
helm delete ingress -n <service-name>  
```
Dry Run

This will run and output what actions helm would take so you can inspect it. Use the --dry-run switch
```Bash
helm install --dry-run ingress stable/service -f C:\git\azure-terraform-application\aks\scripts\azure-internal-lb.yaml -n service
```
Debug
To get more details you can also use the Debug switch 
```Bash
helm install --debug ingress stable/service -f C:\git\azure-terraform-application\aks\scripts\azure-internal-lb.yaml -n service
```


## Troubleshooting 

If you run the command below you can see the logs for K8s to troubleshoot any deployment issues.

```Bash
kubectl get events --all-namespaces
```


```PowerShell
#View the service state
kubectl get service internal-app
```

```PowerShell
#Delete the LB service state
kubectl delete service internal-app
```

## Dashboard
The Dashboard feature in AKS is being deprecated but you can still run the open source version.

#This command downloads credentials and configures the Kubernetes CLI to use them.
az aks get-credentials --resource-group $RGName --name $AKSclusterName --overwrite-existing

v2.0.0 of the dashboard can be installed from here
```BASH
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
```

I had to remove the clusterrole binding to remove the error
```BASH
kubectl delete clusterrolebinding kubernetes-dashboard
```
Run `kubectl proxy` to create the proxy to the dashboard which then makes the dashbaord available here;

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.

You will be presented with options to authenticate either kubeconfig or token.  We configured our kubeconfig when we ran `az aks get-credentials` we can select kubeconfig and find the config file in  `C:\Users\user\.kube

## SSH to an AKS node

If you do need to log-on the nodes you will need to add ssh keys to the AKS Virtual Machine Scale set nodes this guide shows you this process.

https://docs.microsoft.com/en-us/azure/aks/ssh 

```BASH
ssh-keygen -m PEM -t rsa -b 4096
```
This can be run from bash or PS

https://docs.microsoft.com/en-us/azure/aks/ssh

```PowerShell
az aks get-credentials --resource-group $RGName --name $AKSclusterName --overwrite-existing1
```
Create linux container node as jump box
```BASH
kubectl run -it --rm aks-ssh --image=debian
```
Install ssh 
```BASH
apt-get update && apt-get install openssh-client -y
```

From another terminal window run the command to copy your private key to the container 
```BASH
kubectl cp ~/.ssh/id_rsa $(kubectl get pod -l run=aks-ssh -o jsonpath='{.items[0].metadata.name}'):/id_rsa
```
PS was struggling to get the pod name so you can just hardcoded the above with pod name like below

#list the pods
```BASH
kubectl get pods
```

```BASH
kubectl cp C:\Users\joebloggs\.ssh\id_rsa aks-ssh-1234567-123sbc:/id_rsa
```

update the permissions on the copied id_rsa private SSH key so that it is user read-only:
```BASH
chmod 0600 id_rsa
```
Get the private IP of the K8s worker node you want to log onto for example
```BASH
ssh -i id_rsa linadmin@10.31.2.4
```

## AKS Auto-scaling 

Autoscaling has been enabled on the AKS cluster and the settings can be updated in the terraform.tfvars file.  Most have been set to the defaults.  We have included a lifecycle block for `node_count` as teh node count will change dynamically we do not want any changes to the AKS Terraform configuration to impact the performance of the cluster.  The `node_count` will only be set on initial deployment after that it is managed by the auto-scaling rules.

lifecycle {
          ignore_changes = [default_node_pool["node_count"],]
  }

https://docs.microsoft.com/en-us/azure/aks/ssh


