<#PSScriptInfo
.VERSION 1.0.0
.GUID FCE12379-DA0B-4413-84A5-1CD34EC83817
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell hello-world demonstration greeting
.LICENSEURI https://github.com/dotjesper/hello-world/blob/main/LICENSE
.PROJECTURI https://github.com/dotjesper/hello-world/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES https://github.com/dotjesper/hello-world/blob/main/solution#release-notes
#>
<#
.SYNOPSIS
    Hello World demonstration script showcasing PowerShell invocation details and 64-bit relaunch.

.DESCRIPTION
    Invoke-HelloWorld is a demonstration script that displays PowerShell invocation information,
    optionally relaunches in 64-bit PowerShell, and outputs a greeting with a countdown to Christmas.

.PARAMETER TestVariable
    A test variable to demonstrate parameter passing. Default is "testVariable".

.PARAMETER Force64Bit
    Forces the script to relaunch in 64-bit PowerShell if currently running in a 32-bit process.

.EXAMPLE
    .\Invoke-HelloWorld.ps1

    Runs the script with default parameters.

.EXAMPLE
    .\Invoke-HelloWorld.ps1 -Verbose

    Runs the script with verbose output showing invocation details.

.EXAMPLE
    .\Invoke-HelloWorld.ps1 -TestVariable "myValue" -Force64Bit

    Runs the script with a custom test variable and forces 64-bit PowerShell relaunch.

.NOTES
    Version: 1.0.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Initial release
#>
#requires -version 5.1
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false, Position = 0, HelpMessage = "A test variable to demonstrate parameter passing.")]
    [string]$TestVariable = "testVariable",

    [Parameter(Mandatory = $false, HelpMessage = "Forces the script to relaunch in 64-bit PowerShell.")]
    [switch]$Force64Bit
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.0.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    #endregion

    #region :: Invocation details
    Write-Verbose -Message "Script name: $($myInvocation.myCommand.name)"
    Write-Verbose -Message "Script path: $($myInvocation.myCommand.path)"
    Write-Verbose -Message "Command origin: $($myInvocation.commandOrigin)"
    Write-Verbose -Message "Running 64-bit PowerShell: $([System.Environment]::Is64BitProcess)"

    # Reconstruct the full invocation string from bound parameters
    $invocationString = "$($myInvocation.myCommand.name)"
    foreach ($key in $MyInvocation.BoundParameters.Keys) {
        $value = $MyInvocation.BoundParameters[$key]
        if ($value -is [switch]) {
            if ($value.IsPresent) { $invocationString += " -$key" }
        }
        else {
            $invocationString += " -$key `"$value`""
        }
    }
    Write-Verbose -Message "Invocation: $invocationString"
    #endregion

    #region :: Relaunch script in 64-bit PowerShell
    if ($Force64Bit) {

        # Check if currently running in 32-bit PowerShell and relaunch in 64-bit if necessary
        if (-not [System.Environment]::Is64BitProcess) {
            Write-Output -InputObject "Script must be run using 64-bit PowerShell."
            Write-Output -InputObject "Relaunching script in 64-bit PowerShell."

            # Reconstruct the argument string for relaunching the script in 64-bit PowerShell
            $argumentString = ""
            foreach ($key in $MyInvocation.BoundParameters.keys) {
                switch ($MyInvocation.BoundParameters[$key].GetType().Name) {
                    "SwitchParameter" {
                        if ($MyInvocation.BoundParameters[$key].IsPresent) { $argumentString += "-$key " }
                    }
                    "String" {
                        $argumentString += "-$key `"$($MyInvocation.BoundParameters[$key])`" "
                    }
                    "Int32" {
                        $argumentString += "-$key $($MyInvocation.BoundParameters[$key]) "
                    }
                    "Boolean" {
                        $argumentString += "-$key `$$($MyInvocation.BoundParameters[$key]) "
                    }
                    Default {}
                }
            }

            # Attempt to start the script in 64-bit PowerShell and wait for it to complete
            try {
                Start-Process -FilePath "$env:windir\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -ArgumentList $("-ExecutionPolicy Bypass -File .\" + $($myInvocation.myCommand.name) + " " + $argumentString) -Wait -NoNewWindow
                exit 0
            }
            catch {
                Write-Warning -Message "Failed to start 64-bit PowerShell: $_"
                exit 1
            }
        }
    }
    else {
        Write-Verbose -Message "Force64Bit not specified, running in current PowerShell process."
    }
    #endregion

    #region :: Date calculations
    $currentDay = (Get-Date).DayOfWeek
    $daysToChristmas = ([datetime]("12/24/$([datetime]::Now.Year)") - [datetime]::Now).Days
    #endregion
}
#endregion

#region :: process
process {
    try {
        Write-Output -InputObject "Invoke-HelloWorld v$ScriptVersion"
        Write-Output -InputObject "Hello, world!"
        Write-Output -InputObject "Today it is $currentDay, you have to wait $daysToChristmas days before it is Christmas :)"
    }
    catch {
        Write-Warning -Message "Script execution failed: $_"
        exit 1
    }
}
#endregion

#region :: end
end {
    Write-Output -InputObject "Script completed."
}
#endregion
