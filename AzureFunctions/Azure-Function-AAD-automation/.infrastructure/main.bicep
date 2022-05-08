// main file to deploy rg + function app

param date string = utcNow('yyyy-MM-dd')

targetScope = 'subscription'

var tagsObject = {
  'owner': 'martin ehrnst'
  'purpose': 'demo'
  'date': date
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-auth-demo'
  location: 'westeurope'
  tags: tagsObject
}

module functionApp 'azurefunction.bicep' = {
  scope: resourceGroup
  name: 'functionDeploy'
  params: {
    appName: 'authdemo'
  }
}
