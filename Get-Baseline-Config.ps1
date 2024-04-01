$timeZone = 'Central Standard Time'
# to get all apps, run Get-AppxPackage
$appsToRemove = 'Microsoft.GamingApp', 'Microsoft.XboxGameOverlay', 'Microsoft.XboxGamingOverlay', 'Microsoft.MicrosoftOfficeHub'

#source: https://github.com/Raphire/Win11Debloat/blob/master/Win11Debloat.ps1
function RemoveApps {
    param (
        $appslist
    )

    Foreach ($app in $appsList)
    { 
        Write-Output "Attempting to remove $app..."
        # Use Remove-AppxPackage to remove all other apps
        $app = '*' + $app + '*'

        # Remove installed app for all existing users
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers

        # Remove provisioned app from OS image, so the app won't be installed for any new users
        Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }
    }
}


Rename-Computer -NewName $env:servicetag
Set-TimeZone -Name $timeZone
RemoveApps $appsToRemove
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c #high performance power option
powercfg.exe /Change monitor-timeout-ac 30
powercfg.exe /Change standby-timeout-ac 30
powercfg.exe /Change hibernate-timeout-ac 30