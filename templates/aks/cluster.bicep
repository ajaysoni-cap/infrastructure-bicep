param clusterName string = 'cluster-101'
param location string = resourceGroup().location

module cluster 'br/public:avm/res/container-service/managed-cluster:0.8.3' = {
  name: '${deployment().name}-${clusterName}'
  params: {
    name: clusterName
    skuName: 'Base'
    skuTier: 'Free'
    location: location
    enableWorkloadIdentity: true
    enableOidcIssuerProfile: true
    primaryAgentPoolProfiles: [
      {
        name: 'pool1'
        count: 1
        vmSize: 'Standard_D2as_v5'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        maxPods: 75
        type: 'VirtualMachineScaleSets'
        maxCount: 2
        minCount: 1
        enableAutoScaling: true
        scaleDownMode: 'Delete'
        enableNodePublicIP: false
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        enableFIPS: false
        enableSecureBoot: false
        enableVTPM: false
      }
    ]
    nodeResourceGroup: '${resourceGroup().name}-MANAGED'
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    networkDataplane: 'azure'
    enableRBAC: true
    dnsPrefix: '${clusterName}-dns'
    managedIdentities: {
      systemAssigned: true
    }
    supportPlan: 'KubernetesOfficial'
    loadBalancerSku: 'standard'
    aadProfile: {
      aadProfileEnableAzureRBAC: true
      aadProfileManaged: true
      aadProfileTenantId: subscription().tenantId
    }
    podCidr: '10.244.0.0/16'
    serviceCidr: '10.0.0.0/16'
    dnsServiceIP: '10.0.0.10'
    outboundType: 'loadBalancer'
    backendPoolType: 'NodeIPConfiguration'
    managedOutboundIPCount: 1
    disableLocalAccounts: true
    maintenanceConfigurations: [
      {
        name: 'aksManagedAutoUpgradeSchedule'
        maintenanceWindow: {
          schedule: {
            weekly: {
              intervalWeeks: 1
              dayOfWeek: 'Sunday'
            }
          }
          durationHours: 4
          utcOffset: '+00:00'
          startTime: '00:00'
        }
      }
      {
        name: 'aksManagedNodeOSUpgradeSchedule'
        maintenanceWindow: {
          schedule: {
            weekly: {
              intervalWeeks: 1
              dayOfWeek: 'Sunday'
            }
          }
          durationHours: 4
          utcOffset: '+00:00'
          startTime: '00:00'
        }
      }
    ]
    enableStorageProfileDiskCSIDriver: true
    enableStorageProfileFileCSIDriver: true
    enableStorageProfileSnapshotController: true
    nodeProvisioningProfileMode: 'Manual'
  }
}
