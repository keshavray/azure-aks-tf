resource "azurerm_kubernetes_cluster" "k8s" {
  name                = join("-", [var.product, var.role, "k8s", var.location, var.environment])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = join("-", [var.product, var.role, "k8s", var.location, var.environment])
  node_resource_group = join("-", [var.product, "k8s-rg", var.location, var.environment])
  
  /*   
  linux_profile {
    admin_username = var.agentpool_username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  } 
  */

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name = var.agentpool_name
    #node_count          = var.agent_count
    vm_size             = var.agentpool_vmsize
    vnet_subnet_id      = azurerm_subnet.subnet.id
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.min_count
    max_count           = var.max_count
    max_pods            = var.max_pods
  }
  lifecycle {
    ignore_changes = [default_node_pool["node_count"]]
  }
  auto_scaler_profile {
    max_graceful_termination_sec     = var.max_graceful_termination_sec
    scale_down_delay_after_add       = var.scale_down_delay_after_add
    scale_down_delay_after_failure   = var.scale_down_delay_after_failure
    scan_interval                    = var.scan_interval
    scale_down_utilization_threshold = var.scale_down_utilization_threshold
  }

  network_profile {
    network_plugin     = "azure"
    #load_balancer_sku  = "basic"
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = var.aks_dns
    docker_bridge_cidr = var.docker_bridge_cidr
  }

  identity {
    type = "SystemAssigned"
  }
  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [var.aks_admin_groups]
    }
  }
  addon_profile {

    /*     oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
    } */

    aci_connector_linux {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    #oms_agent {
    #  enabled                    = false #This can be very expensive if left on only turn it on for debugging
    #  log_analytics_workspace_id = data.terraform_remote_state.loga.outputs.log_analytics_resource_id
    #}
  }
  tags = local.tags
}

resource "azurerm_role_assignment" "aks_network_role" {
  scope                = azurerm_subnet.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}

resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = data.terraform_remote_state.creg.outputs.creg_id
  role_definition_name = "acrpull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
/*
#Add back when DNS is available
resource "azurerm_role_assignment" "dns_zone_contributor_role" {
  scope                = data.terraform_remote_state.platform.outputs.dns_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
*/
data "azurerm_resource_group" "k8s-rg" {
  name       = join("-", [var.product, "k8s-rg", var.location, var.environment])
  depends_on = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_role_assignment" "managed_id_role" {
  scope                = data.azurerm_resource_group.k8s-rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  depends_on           = [data.azurerm_resource_group.k8s-rg]
}

resource "azurerm_role_assignment" "vm_contributor_role" {
  scope                = data.azurerm_resource_group.k8s-rg.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  depends_on           = [data.azurerm_resource_group.k8s-rg]
}

/*
#This may not be needed but is for management from an Azure DevOps Agent VM.  See data.tf for source and update id as required.
resource "azurerm_role_assignment" "azdo-agent_aks_admin" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = data.terraform_remote_state.azdo-agent.outputs.id
  depends_on           = [data.azurerm_resource_group.k8s-rg]
}

resource "azurerm_role_assignment" "azuredevops_aks_rbac_admin" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.terraform_remote_state.azdo-agent.outputs.id
  depends_on           = [data.azurerm_resource_group.k8s-rg]
}
*/