Function Install-CustomWindowsUpdates() {
    [CmdletBinding()]
    param()
    $ErrorActionPreference = 'Stop'
    $StartTime = (Get-Date).ToUniversalTime().ToString('s')
    if($PSVersionTable.PSVersion.ToString() -ge "5.1"){
        try {
            if($null -eq (Get-Module -ListAvailable -Name PSWindowsUpdate)){
                Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
                Install-Module -Name PSWindowsUpdate
                Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
            }
            if($false -eq (Test-Path C:\logs)) {
                New-Item -Name Logs -Path C:\ -ItemType Directory
            }
            Import-Module -Name PSWindowsUpdate -ErrorAction Stop
            Install-WindowsUpdate -AcceptAll -Install -AutoReboot | Out-File -Append "c:\logs\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -force
            $result = New-Object psobject -Property (@{
                Result = 'Ok'
                Message = "Updates installed"
                StartTime = $StartTime
                EndTime = (Get-Date).ToUniversalTime().ToString('s')
            })
        }
        catch {
            return $_.Exception.Message
        }
    }
    else{
        $result = New-Object psobject -Property (@{
            Result = 'Error'
            Message = "PowerShell version $($PSVersionTable.PSVersion.ToString())"
            StartTime = $StartTime
            EndTime = (Get-Date).ToUniversalTime().ToString('s')
        })
    }
    return $result
}
Install-CustomWindowsUpdates
