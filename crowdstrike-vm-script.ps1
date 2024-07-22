 <#
    .SYNOPSIS
    
    This script will delete the Crowdstrike driver causing the BSOD loop 
    
    .DESCRIPTION
    
    This script will delete the Crowdstrike driver folder and remove the faulty driver (C-00000291*.sys)
    It can be used with Azure Automation or any other automation tool
    
    .AUTHOR
    Olivier Miossec https://github.com/omiossec

    .LICENCE
    https://github.com/omiossec/crowdstrike_Azure_VM_recovery_script/blob/main/LICENSE
#>

$crowdStrikeDefaultFolder = "C:\Windows\System32\drivers\CrowdStrike\"

$crowdStrikeFolderExist = Test-Path -Path $crowdStrikeDefaultFolder -ErrorAction SilentlyContinue

If ($crowdStrikeFolderExist) {

    $faultyDriverFiles = "$($crowdStrikeDefaultFolder)C-00000291*.sys"

    try {
        $faultyDriverFilesList = Get-ChildItem -Path $faultyDriverFiles 
    }
    catch {
        write-error "Unable to get driver list"
        Write-Error -Message " Exception Type: $($_.Exception.GetType().FullName) $($_.Exception.Message)"
        exit 0
    }

    foreach ($faultyDriver in  $faultyDriverFilesList) {
        try {
            remove-Item -Path $faultyDriver.FullName -Force

        }
        catch {
            write-error "Unable to delete driver file $($faultyDriver.FullName)"
            Write-Error -Message " Exception Type: $($_.Exception.GetType().FullName) $($_.Exception.Message)"
        }
    }
}
