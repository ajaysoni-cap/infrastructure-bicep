param clusterName string = 'cluster-101'
param location string = resourceGroup().location

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: 'cluster-102-agentpool'
  params: {
    name: 'cluster-102-agentpool'
    location: location
  }
}

module cluster 'br/public:avm/res/container-service/managed-cluster:0.8.3' = {
  name: clusterName
  params: {
    name: clusterName
    skuName: 'Base'
    skuTier: 'Free'
    location: location
    identityProfile: {
      kubeletidentity: {
        resourceId: identity.outputs.resourceId
      }
    }
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
  }
}

// resource managedClusters_cluster_101_name_resource 'Microsoft.ContainerService/managedClusters@2024-09-02-preview' = {
//   properties: {
//     windowsProfile: {
//       adminUsername: 'azureuser'
//       enableCSIProxy: true
//     }
//     servicePrincipalProfile: {
//       clientId: 'msi'
//     }
//     identityProfile: {
//       kubeletidentity: {
//         resourceId: userAssignedIdentities_cluster_101_agentpool_externalid
//         clientId: '1f8d75e6-7fe2-4b33-b6ce-df47cb5daffc'
//         objectId: 'c44a6ba6-26ce-495c-a479-177d3655d0af'
//       }
//     }
//     autoUpgradeProfile: {
//       upgradeChannel: 'patch'
//       nodeOSUpgradeChannel: 'NodeImage'
//     }
//     disableLocalAccounts: true
//     securityProfile: {
//       imageCleaner: {
//         enabled: false
//         intervalHours: 168
//       }
//       workloadIdentity: {
//         enabled: true
//       }
//     }
//     storageProfile: {
//       diskCSIDriver: {
//         enabled: true
//         version: 'v1'
//       }
//       fileCSIDriver: {
//         enabled: true
//       }
//       snapshotController: {
//         enabled: true
//       }
//     }
//     oidcIssuerProfile: {
//       enabled: true
//     }
//     workloadAutoScalerProfile: {}
//     metricsProfile: {
//       costAnalysis: {
//         enabled: false
//       }
//     }
//     nodeProvisioningProfile: {
//       mode: 'Manual'
//     }
//     bootstrapProfile: {
//       artifactSource: 'Direct'
//     }
//   }
// }
