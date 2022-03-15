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
    .\hello-world.ps1
.EXAMPLE
    .\hello-world.ps1 -Verbose
#>
#requires -version 5.1
[CmdletBinding()]
param (
    [string]$myVar = "testVariable",
    [switch]$uninstall,
    [bool]$runScriptIn64bitPowerShell = $true
)
begin {
    Write-Verbose -Message "`$myInvocation.GetType().FullName           = $($myinvocation.GetType().FullName)"
    Write-Verbose -Message "`$myInvocation.myCommand.GetType().FullName = $($myinvocation.myCommand.GetType().FullName)"
    Write-Verbose -Message "`$myInvocation.myCommand.name               = $($myinvocation.myCommand.name)"
    Write-Verbose -Message "`$myInvocation.myCommand.path               = $($myinvocation.myCommand.path)"
    Write-Verbose -Message "`$myInvocation.scriptName                   = $($myinvocation.scriptName)"
    Write-Verbose -Message "`$myInvocation.psScriptRoot                 = $($myinvocation.psScriptRoot)"
    Write-Verbose -Message "`$myInvocation.psCommandPath                = $($myinvocation.psCommandPath)"
    Write-Verbose -Message "`$myInvocation.commandOrigin                = $($myinvocation.commandOrigin)"
    Write-Verbose -Message  "--"
    Write-Verbose -Message  "`$MyInvocation.Line                        = $($MyInvocation.Line)"
    Write-Verbose -Message "`$MyInvocation.BoundParameters.keys         = $($MyInvocation.BoundParameters.keys)"
    Write-Verbose -Message "--"
    Write-Verbose -Message "`$PSCOMMANDPATH                             = $($PSCOMMANDPATH)"
    Write-Verbose -Message "--"

    write-host "Running 64 bit PowerShell: $([System.Environment]::Is64BitProcess)"

    if ($runScriptIn64bitPowerShell) {
        
        #region :: relaunch script in 64-bit PowerShell
        if ($([System.Environment]::Is64BitProcess) -eq $false) {
            write-host "Script must be run using 64-bit PowerShell."
            Write-host "Reloading script in 64-bit PowerShell"
            foreach ($key in $MyInvocation.BoundParameters.keys) {
                switch ($MyInvocation.BoundParameters[$key].GetType().Name) {
                    "SwitchParameter" {
                        if ($MyInvocation.BoundParameters[$key].IsPresent) { $argsString += "-$key " }
                    }
                    "String" {
                        $argsString += "-$key `"$($MyInvocation.BoundParameters[$key])`" "
                    }
                    "Int32" {
                        $argsString += "-$key $($MyInvocation.BoundParameters[$key]) "
                    }
                    "Boolean" {
                        $argsString += "-$key `$$($MyInvocation.BoundParameters[$key]) "
                    }
                    Default {}
                }
            }
            try {
                Start-Process -FilePath "$env:windir\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -ArgumentList $("-ExecutionPolicy Bypass -File .\" + $($myInvocation.myCommand.name) + " " + $($argsString)) -Wait -NoNewWindow
                exit 0
            }
            catch {
                throw "Failed to start 64-bit PowerShell"
                exit 1
            }
        }
        #endregion
    }

    Write-Verbose -Message "`$myVar: $myVar"
    Write-Verbose -Message "`$uninstall: $uninstall"

    $currentDay = $(Get-Date).DayOfWeek
    $daysToChristmas = $($([Datetime]('12/24/' + $([DateTime]::Now).Year) - $([DateTime]::Now)).Days)
}
process {

    try {
        Write-Host "Hello, world!" -ForegroundColor "Green"
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
end {}
