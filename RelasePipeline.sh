#!/bin/bash
# Azure Release Pipeline Script

# Download Package from Artifactory that is associated with the Build into the Working Directory
#curl -k -u "$artifactory_username:$artifactory_password" --remote-name "https://artifactory.nasa.azu.mrshmc.com/artifactory/gciics/$BuildRepositoryName/$BuildRepositoryName_$BuildBuildNumber.zip" -o "$SystemArtifactsDirectory"
echo "https://artifactory.nasa.azu.mrshmc.com/artifactory/gciics/$BuildRepositoryName/$BuildRepositoryName_$BuildBuildNumber.zip"
echo "$BuildRepositoryName/$BuildRepositoryName_$BuildBuildNumber.zip"
echo "'$BuildRepositoryName'/'$BuildRepositoryName'_$BuildBuildNumber.zip"

# Use the IICS Asset Management Utility to import the Artifactory package into IICS
#"$SystemDefaultWorkingDirectory/_GC Integration/IICS Asset Management Utility/iics_linux" import --name "AzureDevops_Release-$BuildBuildNumber" --password "$iicscredPassword" --podHostName "$iicspodHostName" --region "us" --username "$iicscredUsername" --zipFilePath "$SystemArtifactsDirectory/$BuildRepositoryName_$BuildBuildNumber.zip"
echo "$SystemDefaultWorkingDirectory/_GC Integration/IICS Asset Management Utility/iics_linux import --name AzureDevops_Release-$BuildBuildNumber --password $iicscredPassword --podHostName $iicspodHostName --region us --username $iicscredUsername --zipFilePath $SystemArtifactsDirectory/$BuildRepositoryName_$BuildBuildNumber.zip"
