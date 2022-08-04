# Application Gateway Ingress Controller (AGIC)

We deploy the Application Gateway Ingress Controller (AGIC), this manages the Azure Application Gateway by applying rules to the AppGW as you deploy new services to AKS. 

## Deploying the AGIC
We deploy using Azure Devops pipelines and the `install-app-gw-ingress-controller.sh` script.  Before you can run the pipeline you need to update the values in the values file.  Currently we just have prd.  In the file `prd-appgw-helm-config.yml` update the section below;

*`identityResourceID` is the full azure resource id of the AppGW managed identity deploy via Terraform in `\app-aks\appgw-identity.tf` 
*`identityClientID` is just the client ID

```
armAuth:
    type: aadPodIdentity
    identityResourceID: /subscriptions/<subscription ID>/resourceGroups/<rg name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<managed identity name>
    identityClientID:  <managed identity client ID>
```


The document here provides the full walk through. 
https://azure.github.io/application-gateway-kubernetes-ingress/

Useful annotations;

https://azure.github.io/application-gateway-kubernetes-ingress/annotations/

Below is how to deploy a demo app with the ingress configuration.

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: aspnetapp
  labels:
    app: aspnetapp
spec:
  containers:
  - image: "mcr.microsoft.com/dotnet/core/samples:aspnetapp"
    name: aspnetapp-image
    ports:
    - containerPort: 80
      protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  name: aspnetapp
spec:
  selector:
    app: aspnetapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: aspnetapp
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
          serviceName: aspnetapp
          servicePort: 80
EOF

```

Below is a further example, this includes the way to add a service on a new path.

We update the health probe path 
```
    readinessProbe:
          httpGet:
            path: /
            port: 80
          periodSeconds: 3
          timeoutSeconds: 1
```

We update the re-write path using this section.  This adds path so the app can be reached on `yourdomain.com/apppath" but sends the traffic to route folder.  If your app is configured to have the path folder then your probe and path-prefix may not need to be altered.

```
    appgw.ingress.kubernetes.io/backend-path-prefix: "/"

    paths:
      - path: /apppath/*
```

```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: aspnetapp
  labels:
    app: aspnetapp
spec:
  containers:
  - image: "mcr.microsoft.com/dotnet/core/samples:aspnetapp"
    name: aspnetapp-image
    ports:
    - containerPort: 80
      protocol: TCP
    readinessProbe:
          httpGet:
            path: /
            port: 80
          periodSeconds: 3
          timeoutSeconds: 1
---

apiVersion: v1
kind: Service
metadata:
  name: aspnetapp
spec:
  selector:
    app: aspnetapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
	
---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: aspnetapp
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
    appgw.ingress.kubernetes.io/backend-path-prefix: "/"
spec:
  rules:
  - http:
      paths:
      - path: /apppath/*
        backend:
          serviceName: aspnetapp
          servicePort: 80

EOF
```