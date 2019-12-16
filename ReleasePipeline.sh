#!/bin/bash
# Azure Release Pipeline Script

#Setting Variables
env="${ReleaseEnvironmentName// Promotion/}"
if ["$env" == PRE ]
 then podHostName="dmr-us.informaticacloud.com"
 else podHostName="dm-us.informaticacloud.com"
fi
echo $podHostName

# Download Package from Artifactory that is associated with the Build into the Working Directory
#curl -k -u "$artifactory_username:$artifactory_password" --remote-name "https://artifactory.nasa.azu.mrshmc.com/artifactory/gciics/DevOps_POC/Package_$BuildBuildNumber.zip" -o "$SystemArtifactsDirectory"

# Clone the GC Integration Repository to be able to utilize the Informatica Asset Managment Utility
#git clone "https://$azure_username:$azure_password@guycarp.visualstudio.com/GC%20Integration/_git/GC%20Integration"
#chmod +x "$SystemDefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux"

# Use the IICS Asset Management Utility to import the Artifactory package into IICS
#"$SystemDefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux" import --name "AzureDevops_Release-$BuildBuildNumber" --password "$iicscredPassword" --podHostName "dmr-us.informaticacloud.com" --region "us" --username "$iicscredUsername" --zipFilePath "$SystemArtifactsDirectory/Package_$BuildBuildNumber.zip"

# Unclone the GC Integration Repositry
#rm -R -f "GC%20Integration"