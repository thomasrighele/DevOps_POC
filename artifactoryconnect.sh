curl -k -u "$1:$2" --remote-name "https://artifactory.nasa.azu.mrshmc.com/artifactory/gciics/DevOps_POC/Package_$3.zip" -o "$4"

git clone "https://$5:$6@guycarp.visualstudio.com/GC%20Integration/_git/GC%20Integration"

chmod +x "$7/GC%20Integration/IICS Asset Management Utility/iics_linux"

"$(System.DefaultWorkingDirectory)/GC%20Integration/IICS Asset Management Utility/iics_linux" import --name "AzureDevops_Release-$8" --password "$9" --podHostName "dm-us.informaticacloud.com" --region "us" --username "$10" --zipFilePath "$(System.ArtifactsDirectory)/Package_$3.zip"

rm -R -f "GC%20Integration"