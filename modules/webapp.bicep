param defaultSubnet string
param dnsZoneId string


resource webpe 'Microsoft.Network/privateEndpoints@2021-02-01'={
  name: 'pe-web'
  location: resourceGroup().location
  properties: {
    subnet: {
      id: defaultSubnet
    }
    privateLinkServiceConnections:[
      {
        name: 'pe-web'
        properties:{
          privateLinkServiceId: webapp.id
          groupIds: [
            'sites'
          ]

        }
      }
    ]
  }
  
}

// should declare this inside pe-web to not require dependsOn
// or use '${webpe.name}/web-geba in the name
resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01'={
  name: 'pe-web/web-geba'
  dependsOn: [
    webpe
  ]
  properties: {
    privateDnsZoneConfigs:[
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: dnsZoneId
        }
      }
    ]
  }
  
}




resource webplan 'Microsoft.Web/serverfarms@2021-01-01'={
  name: 'web-plan'
  location: resourceGroup().location
  sku:{
    size: 'P2V2'
    name: 'P2V2'
  }
  
}

resource webapp 'Microsoft.Web/sites@2021-01-01'={
  name: 'web-geba'
  location: resourceGroup().location
  properties:{
    serverFarmId: webplan.id
  } 

}


output appHostName string = webapp.properties.defaultHostName
output appServiceResourceId string = webapp.id
