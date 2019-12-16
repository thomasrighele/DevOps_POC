#!/bin/bash
# Azure Release Pipeline Script

#Setting Variables
env="${ReleaseEnvironmentName// Promotion/}"
if [ "$env" == PRE ]
 then podHostName="dmr-us.informaticacloud.com"
 else podHostName="dm-us.informaticacloud.com"
fi


# Download Package from Artifactory that is associated with the Build into the Working Directory
curl -k -u "$artifactory_username:$artifactory_password" --remote-name "https://artifactory.nasa.azu.mrshmc.com/artifactory/gciics/DevOps_POC/Package_$BuildBuildNumber.zip" -o "$SystemArtifactsDirectory"

# Use the IICS Asset Management Utility to import the Artifactory package into IICS
"$SystemDefaultWorkingDirectory/_GC Integration/IICS Asset Management Utility/iics_linux" import --name "AzureDevops_Release-$BuildBuildNumber" --password "$iicscredPassword" --podHostName "$podHostName" --region "us" --username "$iicscredUsername" --zipFilePath "$SystemArtifactsDirectory/Package_$BuildBuildNumber.zip"