targetScope = 'resourceGroup'

param addressSubSpace string
param addressPrefixes array
param location string
param vnetName string
param project string
param tags object

resource nsgHub 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg-${project}-hub'
  location: location
  tags: tags
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: 'snet-default'
        properties: {
          addressPrefix: '10.${addressSubSpace}.1.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          networkSecurityGroup: {
            id: nsgHub.id
          }
          // TODO: Just enable common service endpoints by default for now
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]

            }
            {
              service: 'Microsoft.Sql'
              locations: [
                location
              ]
            }
            {
              service: 'Microsoft.Web'
              locations: [
                location
              ]
            }
            {
              service: 'Microsoft.KeyVault'
              locations: [
                location
              ]
            }
          ]
        }
      }
      {
        name: 'snet-endpoints'
        properties: {
          networkSecurityGroup: {
            id: nsgHub.id
          }
          addressPrefix: '10.${addressSubSpace}.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output vnetName string = virtualNetwork.name
output defaultSnetId string = virtualNetwork.properties.subnets[0].id
output defaultSnetName string = virtualNetwork.properties.subnets[0].name
output pepSnetId string = virtualNetwork.properties.subnets[1].id
output pepSnetName string = virtualNetwork.properties.subnets[1].name
output nsgHubId string = nsgHub.id
