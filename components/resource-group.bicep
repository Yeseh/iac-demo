targetScope = 'subscription'

@allowed([
  'westeurope'
  'northeurope'
])
param location string
@maxLength(15)
@minLength(5)
param rgName string
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: rgName
  tags: tags
}

output name string = rg.name
output id string = rg.id
output location string = rg.location
