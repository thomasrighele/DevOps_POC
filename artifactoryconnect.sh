git clone "https://$azure_username:$azure_password@guycarp.visualstudio.com/GC%20Integration/_git/GC%20Integration"\
chmod +x "$SystemDefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux"\
"$SystemDefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux" import --name "AzureDevops_Release-$BuildBuildNumber" --password "$iicscredPassword" --podHostName "dm-us.informaticacloud.com" --region "us" --username "$iicscredUsername" --zipFilePath "$SystemArtifactsDirectory/Package_$BuildBuildNumber.zip"\
rm -R -f "GC%20Integration"