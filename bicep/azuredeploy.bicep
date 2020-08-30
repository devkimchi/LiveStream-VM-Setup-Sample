param name string {
  metadata: {
    description: 'Resource name'
  }
}
param suffix string {
  metadata: {
    description: 'Resource suffix'
  }
}
param location string {
  metadata: {
    description: 'Resource location'
  }
  allowed: [
    'australiaeast'
    'koreacentral'
    'westus2'
  ]
  default: resourceGroup().location
}
param locationCode string {
  metadata: {
    description: 'Resource location code'
  }
  allowed: [
    'aue'
    'krc'
    'wus2'
  ]
  default: 'krc'
}

param publicIpDnsLabel string {
  metadata: {
    description: 'Unique DNS Name for the Public IP used to access the Virtual Machine.'
  }
}

param virtualNetworkAddressPrefix string {
  metadata: {
    description: 'CIDR notation of the Virtual Networks.'
  }
  default: '10.0.0.0/16'
}
param virtualNetworkSubnetPrefix string {
  metadata: {
    description: 'CIDR notation of the Virtual Network Subnets.'
  }
  default: '10.0.0.0/24'
}

param virtualMachineAdminUsername string {
  metadata: {
    description: 'Username for the Virtual Machine.'
  }
}
param virtualMachineAdminPassword string {
  metadata: {
    description: 'Password for the Virtual Machine.'
  }
  secure: true
}
param virtualMachineSize string {
  metadata: {
    description: 'Size of the Virtual Machine.'
  }
  allowed: [
    'Standard_D2s_v3'
    'Standard_D4s_v3'
    'Standard_D8s_v3'
  ]
  default: 'Standard_D8s_v3'
}
param virtualMachinePublisher string {
  metadata: {
    description: 'The publisher of the Virtual Machine.'
  }
  allowed: [
    'MicrosoftVisualStudio'
    'MicrosoftWindowsDesktop'
  ]
  default: 'MicrosoftWindowsDesktop'
}
param virtualMachineOffer string {
  metadata: {
    description: 'The offer of the Virtual Machine'
  }
  allowed: [
    'visualstudio2019latest'
    'Windows-10'
  ]
  default: 'Windows-10'
}
param virtualMachineSku string {
  metadata: {
    description: 'The Windows version for the VM. This will pick a fully patched image of this given Windows version.'
  }
  allowed: [
    'vs-2019-comm-latest-ws2019'
    'vs-2019-ent-latest-ws2019'
    '20h1-pro-g2'
    '20h1-ent-g2'
  ]
  default: '20h1-pro-g2'
}
param virtualMachineExtensionCustomScriptUri string {
  metadata: {
    description: 'The URI of the PowerShell Custom Script.'
  }
  default: 'https://raw.githubusercontent.com/devkimchi/LiveStream-VM-Setup-Sample/main/install.ps1'
}

var metadata = {
  longName: concat('{0}-', name, '-', locationCode, if(equals(coalesce(suffix, ''), ''), '', concat('-', suffix)))
  shortName: concat('{0}', replace(name, '-', ''), locationCode, if(equals(coalesce(suffix, ''), ''), '', suffix))
}
var storageAccount = {
  name: replace(metadata.shortName, '{0}', 'st')
  resourceId: resourceId('Microsoft.Storage/storageAccounts', replace(metadata.shortName, '{0}', 'st'))
  location: location
  sku: {
    name: 'Standard_LRS'
  }
}
var publicIp = {
  name: replace(metadata.longName, '{0}', 'pip')
  resourceId: resourceId('Microsoft.Network/publicIPAddresses', replace(metadata.longName, '{0}', 'pip'))
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: if(equals(coalesce(publicIpDnsLabel, ''), ''), replace(metadata.shortName, '{0}', 'vm'), publicIpDnsLabel)
    }
  }
}
var networkSecurityGroup = {
  name: replace(metadata.longName, '{0}', 'nsg')
  resourceId: resourceId('Microsoft.Network/networkSecurityGroups', replace(metadata.longName, '{0}', 'nsg'))
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'TCP'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: 3389
        }
      }
    ]
  }
}
var virtualNetwork = {
  name: replace(metadata.longName, '{0}', 'vnet')
  resourceId: resourceId('Microsoft.Network/virtualNetworks', replace(metadata.longName, '{0}', 'vnet'))
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: virtualNetworkSubnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.resourceId
          }
        }
      }
    ]
  }
}
var virtualNetworkSubnet = {
  name: concat(replace(metadata.longName, '{0}', 'vnet'), '/default')
  resourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', replace(metadata.longName, '{0}', 'vnet'), 'default')
  location: location
}
var networkInterface = {
  name: replace(metadata.longName, '{0}', 'nic')
  resourceId: resourceId('Microsoft.Network/networkInterfaces', replace(metadata.longName, '{0}', 'nic'))
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.resourceId
          }
          subnet: {
            id: virtualNetworkSubnet.resourceId
          }
        }
      }
    ]
  }
}
var virtualMachine = {
  name: replace(metadata.shortName, '{0}', 'vm')
  resourceId: resourceId('Microsoft.Compute/virtualMachines', replace(metadata.shortName, '{0}', 'vm'))
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    osProfile: {
      computerName: replace(metadata.shortName, '{0}', 'vm')
      adminUsername: virtualMachineAdminUsername
      adminPassword: virtualMachineAdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: virtualMachinePublisher
        offer: virtualMachineOffer
        sku: virtualMachineSku
        version: 'latest'
      }
      osDisk: {
        name: replace(metadata.longName, '{0}', 'osdisk')
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.resourceId
        }
      ]
    }
  }
}
var virtualMachineExtensionCustomScript = {
  name: concat(replace(metadata.shortName, '{0}', 'vm'), '/config-app')
  resourceId: resourceId('Microsoft.Compute/virtualMachines/extensions', replace(metadata.shortName, '{0}', 'vm'), 'config-app')
  location: location
  properties: {
    settings: {
      fileUris: [
        virtualMachineExtensionCustomScriptUri
      ]
    }
    protectedSettings: {
      commandToExecute: concat('powershell -ExecutionPolicy Unrestricted -File ', './', last(split(virtualMachineExtensionCustomScriptUri, '/')))
    }
  }
}

resource st 'Microsoft.Storage/storageAccounts@2017-10-01' = {
  name: storageAccount.name
  location: storageAccount.location
  kind: 'StorageV2'
  sku: storageAccount.sku
}

resource pip 'Microsoft.Network/publicIPAddresses@2018-07-01' = {
  name: publicIp.name
  location: publicIp.location
  properties: {
    publicIPAllocationMethod: publicIp.properties.publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: publicIp.properties.dnsSettings.domainNameLabel
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2018-07-01' = {
  name: networkSecurityGroup.name
  location: networkSecurityGroup.location
  properties: {
    securityRules: networkSecurityGroup.properties.securityRules
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2018-07-01' = {
  name: virtualNetwork.name
  location: virtualNetwork.location
  dependsOn: [
    nsg
  ]
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetwork.properties.addressSpace.addressPrefixes
    }
    subnets: virtualNetwork.properties.subnets
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2018-07-01' = {
  name: networkInterface.name
  location: networkInterface.location
  dependsOn: [
    pip
    vnet
  ]
  properties: {
    ipConfigurations: networkInterface.properties.ipConfigurations
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2018-10-01' = {
  name: virtualMachine.name
  location: virtualMachine.location
  dependsOn: [
    nic
  ]
  properties: {
    hardwareProfile: {
      vmSize: virtualMachine.properties.hardwareProfile.vmSize
    }
    osProfile: {
      computerName: virtualMachine.properties.osProfile.computerName
      adminUsername: virtualMachine.properties.osProfile.adminUsername
      adminPassword: virtualMachine.properties.osProfile.adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: virtualMachine.properties.storageProfile.imageReference.publisher
        offer: virtualMachine.properties.storageProfile.imageReference.offer
        sku: virtualMachine.properties.storageProfile.imageReference.sku
        version: virtualMachine.properties.storageProfile.imageReference.version
      }
      osDisk: {
        name: virtualMachine.properties.storageProfile.osDisk.name
        createOption: virtualMachine.properties.storageProfile.osDisk.createOption
      }
      dataDisks: virtualMachine.properties.storageProfile.dataDisks
    }
    networkProfile: {
      networkInterfaces: virtualMachine.properties.networkProfile.networkInterfaces
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(st.id).primaryEndpoints.blob
      }
    }
  }
}

resource vmext 'Microsoft.Compute/virtualMachines/extensions@2018-10-01' = {
  name: virtualMachineExtensionCustomScript.name
  location: virtualMachineExtensionCustomScript.location
  dependsOn: [
    vm
  ]
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: virtualMachineExtensionCustomScript.properties.settings.fileUris
    }
    protectedSettings: {
      commandToExecute: virtualMachineExtensionCustomScript.properties.protectedSettings.commandToExecute
    }
  }
}
