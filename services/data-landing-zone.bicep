targetScope = 'subscription'

param location string
param project string
param tags object
param addressSubspace string
param dlzRgName string

module rg '../components/resource-group.bicep' = {
  scope: subscription()
  name: 'DlzResourceGroup'
  params: {
    location: location
    rgName: dlzRgName
    tags: tags
  }
}

var rgScope = resourceGroup(dlzRgName)

module vnet '../components/vnet.bicep' = {
  scope: rgScope
  name: 'DlzVnet'
  params: {
    location: location
    tags: {
      Deployment: 'Bicep'
      Owner: 'Jesse Wellenberg'
    }
    addressSubSpace: addressSubspace
    vnetName: 'vnet-${project}'
    addressPrefixes: [
      '10.${addressSubspace}.0.0/16'
    ]
    project: project
  }
  dependsOn: [
    rg
  ]
}

module datalakeStorage '../components/datalake-storage.bicep' = {
  scope: rgScope
  name: 'DlzDatalakeStorage'
  params: {
    ipWhitelist: []
    location: location
    networkMode: 'Private'
    pepSubnetId: vnet.outputs.pepSnetId
    project: project
    subnetId: vnet.outputs.defaultSnetId
    tags: tags
  }
  dependsOn: [
    rg
  ]
}

module datafactory '../components/datafactory.bicep' = {
  scope: rgScope
  name: 'DlzDataFactory'
  params: {
    factoryName: 'df-${project}'
    location: location
    tags: tags
    factoryRepoConfig: {}
  }
  dependsOn: [
    rg
  ]
}
