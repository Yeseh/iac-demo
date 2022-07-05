targetScope = 'subscription'

param dlzAddressSubspace string
param dlzLocation string
param dlzTags object
// param dlzConfigs array
param project string
param deploymentName string = newGuid()

// module dlz './services/data-landing-zone.bicep' = {
//   scope: subscription()
//   name: deploymentName 
//   params: {
//     addressSubspace: dlzAddressSubspace
//     location: dlzLocation
//     project: project
//     tags: dlzTags
//     dlzRgName: 'rg-${project}'
//   }
// }

module dlz 'br/Demo:services/data-landing-zone:latest' = {
  scope: subscription()
  name: deploymentName 
  params: {
    addressSubspace: dlzAddressSubspace
    location: dlzLocation
    project: project
    tags: dlzTags
    dlzRgName: 'rg-${project}'
  }
}

// module dlzLoop 'br/Demo:services/data-landing-zone:latest' = [for config in dlzConfigs: {
//   scope: subscription()
//   name: '${config.name}-${deploymentName}'
//   params: {
//     addressSubspace: config.addressSubspace
//     location: config.location 
//     project: project
//     tags: dlzTags 
//     dlzRgName: 'rg-${project}'
//   }
// }]
