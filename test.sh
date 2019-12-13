#!/bin/bash
#My first script

git clone "https://$azure_username:$azure_password@guycarp.visualstudio.com/GC%20Integration/_git/GC%20Integration"

chmod +x "$SystemDefaultWorkingDirectory/GC%20Integration/IICS Asset Management Utility/iics_linux"

dir $SystemDefaultWorkingDirectory