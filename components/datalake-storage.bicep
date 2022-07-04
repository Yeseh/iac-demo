param location string
param project string
param tags object
param pepSubnetId string
param subnetId string
param ipWhitelist array
@allowed([
  'Private'
  'Public'
])
param networkMode string

var isPrivate = networkMode == 'Private'

resource dls 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  name: 'dls${replace(project, '-', '')}'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: subnetId
        }
      ]
      ipRules: ipWhitelist
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: 'default'
  parent: dls
}

resource dlContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: 'datalake'
  parent: blobService
}

resource dlsEp 'Microsoft.Network/privateEndpoints@2021-05-01' = if (isPrivate) {
  name: 'pep-${dls.name}'
  location: location
  properties: {
    subnet: {
      id: pepSubnetId
    }
    privateLinkServiceConnections: [
      {
        properties: {
          privateLinkServiceId: dls.id
          groupIds: [
            'dfs'
          ]
        }
        name: 'pep-${dls.name}-blob'
      }
    ]
  }
}

output id string = dls.id
