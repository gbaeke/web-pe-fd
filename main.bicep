targetScope='subscription'

param rgName string = 'rg-webapp'
param location string = 'eastus'
@secure()
param adminPassword string
param frontDoorEndpointName string = 'afd-${uniqueString(subscription().id)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01'={
  location: location
  name: rgName
}

module vnet 'modules/network.bicep'={
  scope: rg
  name: 'vnet' 
  params: {
    networkName: 'vnet-webapp'
  }
  
}

module bastion 'modules/bastion.bicep'={
  scope: rg
  name: 'bst-webapp'
  params: {
    bastionName: 'bst-webapp'
    subnetId: vnet.outputs.bastionSubnetId
  }
  
}

module vm 'modules/vm.bicep'={
  scope: rg
  name: 'vm-webapp'
  params: {
    adminPassword: adminPassword
    subnetId: vnet.outputs.defaultSubnetId
    vmName: 'vm-webapp'
  }
  
}

module webapp 'modules/webapp.bicep'={
  scope: rg
  name: 'web-geba'
  params: {
    defaultSubnet: vnet.outputs.defaultSubnetId
  }
  
}

module privateDns 'modules/dns.bicep'={
  scope: rg
  name: 'privateDns'
  params: {
    ipAddress: '10.0.1.5'
    vnetId: vnet.outputs.id
    webappName: webapp.name
  }
  
}

module frontDoor 'modules/frontdoor.bicep'={
  scope: rg
  name: 'front-door'
  params: {
    endpointName: frontDoorEndpointName
    originHostName: webapp.outputs.appHostName
    skuName: 'Premium_AzureFrontDoor'
    privateEndpointResourceId: webapp.outputs.appServiceResourceId
    privateLinkResourceType: 'sites'
    privateEndpointLocation: 'eastus'
  }
  
}

