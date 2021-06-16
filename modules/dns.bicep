param vnetId string

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'

  resource privateDNSZoneNetworkLink 'virtualNetworkLinks@2020-06-01' = {
    name: 'webnetlink'
    location: 'global'
    properties:{
      registrationEnabled: false
      virtualNetwork:{
        id: vnetId
      }
    }
  }

  
}

output id string = privateDNSZone.id
