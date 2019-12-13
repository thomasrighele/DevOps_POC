#!/bin/sh
git clone "https://$azure_username:azure_password@guycarp.visualstudio.com/GC%20Integration/_git/GC%20Integration" \
chmod +x "$System.DefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux" \
"$System.DefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux" import --name "AzureDevops_Release-$Build.BuildNumber" --password "$iicscred.Password" --podHostName "dm-us.informaticacloud.com" --region "us" --username "$iicscred.Username" --zipFilePath "$(System.ArtifactsDirectory)/Package_$Build.BuildNumber.zip" \
rm -R -f "GC%20Integration"