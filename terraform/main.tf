# create resource group with location
resource "azurerm_resource_group" "containerRG" {
  name     = "sca-project"
  location = "East US"
  tags = {
    source = "Resource group created via terraform"
  }
}

#  create container registry
resource "azurerm_container_registry" "demoContainerRegistry" {
  name                = "mycontainer220523"
  resource_group_name = azurerm_resource_group.containerRG.name
  location            = azurerm_resource_group.containerRG.location
  sku                 = "Basic"

}

#  create kubernetes cluster 
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "sca-k8s-cluster"
  location            = azurerm_resource_group.containerRG.location
  resource_group_name = azurerm_resource_group.containerRG.name
  dns_prefix          = "sca-k8s-cluster-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    source = "Cluster"
  }
}