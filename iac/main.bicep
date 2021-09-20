targetScope = 'subscription'

@minLength(3)
@maxLength(6)
param environment string = 'tst'

var product = 'bicepdeploydemo'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${product}-${environment}'
  location: 'West Europe'
}

module logAnalytics 'OperationalInsights/loganalytics.bicep' = {
  scope: resourceGroup
  name: 'logAnalytics'
  params: {
    resourceName: 'log-${product}-${environment}'
  }
}

module keyVault 'Keyvault/keyvault.bicep' = {
  scope: resourceGroup
  name: 'keyvault'
  params: {
    resourceName: 'kv-${product}-${environment}'
    workspaceId: logAnalytics.outputs.id
  }
}

module runScript 'DeploymentScript/deployment-script.bicep' = {
  scope: resourceGroup
  name: 'runCustomScript'
}
