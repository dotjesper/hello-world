<#PSScriptInfo
.VERSION 0.0.1.0
.GUID 3B4A9A7B-9E9A-4630-A991-2316FE701ED9
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell-5 windows-10 windows-11
.LICENSEURI https://github.com/dotjesper/hello-world/blob/master/LICENSE
.PROJECTURI https://github.com/dotjesper/hello-world/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES https://github.com/dotjesper/hello-world/wiki/release-notes
#>
<#
.SYNOPSIS
     Hello World demonstration script.
.DESCRIPTION
.PARAMETER <none>
.EXAMPLE
    .\rhythm.ps1
.EXAMPLE
    .\hello-world.ps1 -Verbose
#>
#requires -version 5.1
[CmdletBinding()]
param ()
begin {
    $currentDay = $(Get-Date).DayOfWeek
    $daysToChristmas = $($([Datetime]('12/24/' + $([DateTime]::Now).Year) - $([DateTime]::Now)).Days)
}
process {
    try {
        Write-Host "Hello wordl!" -ForegroundColor "Green"
        Write-Host "Today it is $currentDay, you have to wait" -NoNewline
        Write-host " $daysToChristmas " -ForegroundColor "Red" -NoNewline
        Write-host "days before it is Christmas :)"
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Host "ERROR: $errMsg" -ForegroundColor "Red"
    }
    finally {}
}
end{}
