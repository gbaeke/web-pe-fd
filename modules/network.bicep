param networkName string
param vnetPrefix string = '10.0.0.0/8'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01'= {
  name: networkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets:[
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
        
      

      }
      {
        name: 'AzureBastionSubnet'
        properties:{
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
  
}

output bastionSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', networkName, 'AzureBastionSubnet')
output defaultSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', networkName, 'default')
output id string = vnet.id
