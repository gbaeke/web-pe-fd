param defaultSubnet string



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
// see https://github.com/gbaeke/web-pe-fd/issues/1
// output ip string = webpe.properties.networkInterfaces[0].properties.ipConfigurations[0].properties.privateIPAddress
