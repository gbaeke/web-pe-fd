param vnetId string
param webappName string
param ipAddress string

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

  resource webrecord 'A@2020-06-01'={
    name: webappName
    properties:{
      ttl: 3600
      aRecords: [
        {
          ipv4Address: ipAddress
        }
      ]
    }    
  }

  
}
