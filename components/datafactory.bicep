targetScope = 'resourceGroup'

param factoryName string
param factoryRepoConfig object
param location string
param tags object

resource df 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    repoConfiguration: factoryRepoConfig
  }
}

output id string = df.id
output name string = df.name
