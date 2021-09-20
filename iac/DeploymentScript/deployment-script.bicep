/*
These scripts can be used for performing custom steps such as:
- Perform data plane operations, for example, copy blobs or seed database
- Create a self-signed certificate
- Create an object in Azure AD
- Look up a value from a custom system
*/

param timestamp string = utcNow()
param dsName string = 'ds${uniqueString(resourceGroup().name)}'

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  kind: 'AzurePowerShell'
  name: dsName
  location: resourceGroup().location
  // identity property no longer required
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: '''
$DeploymentScriptOutputs["test"] = "test this output"
'''
    forceUpdateTag: timestamp // script will run every time
    retentionInterval: 'PT1H' // deploymentScript resource will delete itself in 4 hours
  }
}

output scriptOutput string = deploymentScript.properties.outputs.test
